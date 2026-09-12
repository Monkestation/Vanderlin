import {
  Box,
  Icon,
  LabeledList,
  NoticeBox,
  Section,
  Table,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { bytes, count, exact } from './format';
import type { Footer, StorageRow } from './types';

function Flag(props: { set: BooleanLike; children: string }) {
  const { set, children } = props;

  return (
    <Box inline mr={2} color={set ? 'good' : 'average'}>
      <Icon name={set ? 'check' : 'xmark'} mr={0.5} />
      {children}
    </Box>
  );
}

type StorageMeta = {
  label: string;
  /** What the crate's text report prints in place of a number when this pass
   * did not run - not walked for a skipped walk, not resolved for a table
   * whose globals never came back. */
  missing: string;
  /** No live count to show, only bytes. */
  countless?: boolean;
  note?: string;
};

/**
 * Display names, keyed by the crate's stable label.
 *
 * Falls back to the raw key for anything unrecognised, so a storage class added
 * on the extension side still renders rather than vanishing from a section whose
 * whole job is disclosure.
 */
const STORAGE_META: Record<string, StorageMeta> = {
  table_pointer_arrays: {
    label: 'Table pointer arrays',
    missing: 'not walked',
    countless: true,
    note: 'Four bytes per slot of every table this walk reaches, live or not. Counted once here rather than folded into the rows below.',
  },
  alist_records: { label: 'Alist records', missing: 'not walked' },
  alist_trees: { label: 'Alist trees', missing: 'not walked' },
  turf_var_nodes: { label: 'Turf var nodes', missing: 'not walked' },
  string_table: {
    label: 'String table',
    missing: 'not resolved',
    note: "Live entries only. A dead slot is a null pointer with nothing behind it, so it costs nothing here - BYOND's own report charges 32 B for one because it synthesizes a fallback entry rather than reading the raw table.",
  },
  suspended_proc_frames: {
    label: 'Suspended proc frames',
    missing: 'not walked',
    note: 'The frame itself only. Its parent_context chain, the proc queue and the destructor table are not walked, and neither is anything currently running.',
  },
};

/**
 * Which storage classes actually got charged this run.
 *
 * A zero here means one of two completely different things, so the state column
 * is the point of the table rather than a decoration.
 */
function StorageTable(props: { rows?: StorageRow[] }) {
  const { rows } = props;

  if (!rows?.length) {
    return (
      <Box color="label">
        This census carries no storage breakdown, so what the extension charged
        beyond instances and lists is unknown.
      </Box>
    );
  }

  return (
    <Table>
      <Table.Row header>
        <Table.Cell>Storage</Table.Cell>
        <Table.Cell collapsing>Live</Table.Cell>
        <Table.Cell collapsing>Bytes</Table.Cell>
      </Table.Row>
      {rows.map((row) => {
        const meta = STORAGE_META[row.label];

        return (
          <Table.Row key={row.label} className="candystripe">
            <Table.Cell>
              {meta ? meta.label : row.label}
              {!!meta?.note && (
                <Tooltip content={meta.note}>
                  <Icon name="circle-info" ml={1} color="label" />
                </Tooltip>
              )}
            </Table.Cell>
            <Table.Cell collapsing className="text-right text-nowrap">
              {row.walked && !meta?.countless ? count(row.count) : ''}
            </Table.Cell>
            <Table.Cell collapsing className="text-right text-nowrap">
              {row.walked ? (
                bytes(row.bytes)
              ) : (
                <Box inline color="average">
                  {meta ? meta.missing : 'not walked'}
                </Box>
              )}
            </Table.Cell>
          </Table.Row>
        );
      })}
    </Table>
  );
}

/**
 * What the numbers above do not include.
 *
 * Every total in every report is partial, and the difference between a useful
 * profiler and a misleading one is whether it says so on the same screen.
 */
export function Honesty(props: { footer: Footer }) {
  const { footer } = props;

  return (
    <Section title="What these numbers leave out">
      {!footer.bytes_available && (
        <NoticeBox danger>
          Byte reporting is unavailable on this platform, so every byte count in
          every report reads as zero. Instance and element counts are still
          real.
        </NoticeBox>
      )}
      <LabeledList>
        <LabeledList.Item label="Not counted">
          {footer.exclusions}
        </LabeledList.Item>
        <LabeledList.Item label="Orphan sources">
          {footer.orphan_sources}
        </LabeledList.Item>
        <LabeledList.Item
          label="Uncosted"
          color={exact(footer.uncosted_instances) > 0 ? 'average' : undefined}
        >
          {count(footer.uncosted_instances)} instances counted with no verified
          base size to charge. Every kind this walk reaches has one, so anything
          other than zero is a kind that shipped without a traced size.
        </LabeledList.Item>
        <LabeledList.Item label="This run">
          <Flag set={footer.bytes_available}>bytes</Flag>
          <Flag set={footer.image_base_verified}>image base</Flag>
          <Flag set={footer.turfs_walked}>turfs walked</Flag>
          <Flag set={footer.alists_walked}>alists walked</Flag>
        </LabeledList.Item>
      </LabeledList>
      <Section title="Storage charged this run">
        <StorageTable rows={footer.storage} />
      </Section>
    </Section>
  );
}
