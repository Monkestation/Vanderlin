import { type ReactNode, useState } from 'react';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Stack,
  Table,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { bytes, count, duration, exact } from './format';
import {
  type Exact,
  LIST_FAILURES,
  LIST_STATUS_NOTE,
  type ListFailure,
  type ReportMeta,
  type SkipCounts,
  type Unattributed,
} from './types';

/** Sort state for a table, with click-to-toggle-direction. */
export function useSort<K extends string>(initialKey: K, initialDesc = true) {
  const [sort, setSort] = useState<{ key: K; desc: boolean }>({
    key: initialKey,
    desc: initialDesc,
  });

  function toggle(key: K) {
    setSort((prev) =>
      prev.key === key ? { key, desc: !prev.desc } : { key, desc: true },
    );
  }

  return { sort, toggle };
}

type SortCellProps = {
  children: ReactNode;
  active: boolean;
  desc: boolean;
  onClick: () => void;
  collapsing?: boolean;
};

/** A clickable column header. */
export function SortCell(props: SortCellProps) {
  const { children, active, desc, onClick, collapsing } = props;

  return (
    <Table.Cell collapsing={collapsing}>
      <Button
        compact
        fluid
        color="transparent"
        icon={active ? (desc ? 'caret-down' : 'caret-up') : undefined}
        onClick={onClick}
      >
        {children}
      </Button>
    </Table.Cell>
  );
}

type ReportHeaderProps = {
  label: string;
  busy: BooleanLike;
  onCapture: () => void;
  meta?: ReportMeta;
  children?: ReactNode;
};

/**
 * Capture button plus a line saying who last ran this report and what it cost.
 * The duration is the point: an admin should learn how expensive this is.
 */
export function ReportHeader(props: ReportHeaderProps) {
  const { label, busy, onCapture, meta, children } = props;

  return (
    <Stack align="center">
      <Stack.Item>
        <Button icon="camera" disabled={!!busy} onClick={onCapture}>
          {label}
        </Button>
      </Stack.Item>
      {!!children && <Stack.Item>{children}</Stack.Item>}
      <Stack.Item grow>
        <Box color="label" textAlign="right">
          {meta
            ? `${meta.captured_by} at ${meta.captured_at}, froze the server for ${duration(meta.duration_ds)}`
            : 'not captured this round'}
        </Box>
      </Stack.Item>
    </Stack>
  );
}

/** Shown in place of a table before anything has been captured. */
export function EmptyState(props: { children: ReactNode }) {
  return <NoticeBox info>{props.children}</NoticeBox>;
}

type TruncatedProps = {
  truncated: BooleanLike;
  shown: number;
  total: Exact;
  noun: string;
};

/**
 * A short table is otherwise indistinguishable from a complete one, which is the
 * single easiest way to read a profiler wrong.
 */
export function TruncatedNotice(props: TruncatedProps) {
  const { truncated, shown, total, noun } = props;

  if (!truncated) {
    return null;
  }

  return (
    <NoticeBox color="yellow">
      Showing {count(shown)} of {count(total)} {noun}. Dump to a file from the
      Overview tab to see the rest.
    </NoticeBox>
  );
}

/** Short label per failure, for the left column. */
const FAILURE_LABEL: Record<ListFailure, string> = {
  no_vector: 'No storage',
  over_capacity: 'Over capacity',
  length_absurd: 'Bad length',
};

/**
 * How many lists the walk skipped, one line per reason.
 *
 * Empty lists get their own neutral line rather than being folded in with the
 * failures. They are normally most of a world, and counting them as failures is
 * what made this panel report a healthy server as several hundred thousand
 * corrupt slots. The three real failures only appear when non-zero, so a healthy
 * world shows one calm line instead of three red zeroes.
 */
export function SkipBreakdown(props: { skipped: SkipCounts }) {
  const { skipped } = props;

  return (
    <>
      <LabeledList.Item label="Empty">
        {count(skipped.empty)} lists hold nothing. Normal - they are counted,
        they just have no contents to attribute.
      </LabeledList.Item>
      {LIST_FAILURES.filter((status) => exact(skipped[status]) > 0).map(
        (status) => (
          <LabeledList.Item
            key={status}
            label={FAILURE_LABEL[status]}
            color="bad"
          >
            {count(skipped[status])} lists {LIST_STATUS_NOTE[status]}
          </LabeledList.Item>
        ),
      )}
    </>
  );
}

/** What the rollup could not charge to any row, itemized. */
export function UnattributedList(props: { unattributed: Unattributed }) {
  const { unattributed } = props;
  const rows: [string, Exact, string][] = [
    [
      'Shared',
      unattributed.shared_bytes,
      'held in more than one place, so no single var can be blamed',
    ],
    [
      'Globals',
      unattributed.global_bytes,
      'held by a global, client or proc frame',
    ],
    [
      'Alists',
      unattributed.alist_bytes,
      'held by an alist, which has no typepath',
    ],
    ['No holder', unattributed.orphan_bytes, 'reached by no named root at all'],
    [
      'Too deep',
      unattributed.deep_bytes,
      'nested past the depth the walk follows',
    ],
  ];

  return (
    <LabeledList>
      {rows.map(([label, value, why]) => (
        <LabeledList.Item key={label} label={label}>
          {bytes(value)} {why}
        </LabeledList.Item>
      ))}
      <LabeledList.Item label="Total">
        {bytes(unattributed.unattributed_bytes)} not on any row above
      </LabeledList.Item>
    </LabeledList>
  );
}

/** A bar sized against the largest row in the same table. */
export function BytesBar(props: { value: Exact; max: number; color?: string }) {
  const { value, max, color = 'teal' } = props;

  return (
    <ProgressBar
      value={exact(value)}
      minValue={0}
      maxValue={max || 1}
      color={color}
    >
      {bytes(value)}
    </ProgressBar>
  );
}
