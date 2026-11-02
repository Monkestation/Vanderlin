import { sortBy } from 'es-toolkit';
import { useMemo, useState } from 'react';
import { Box, Icon, Section, Table, Tooltip } from 'tgui-core/components';
import { exhaustiveCheck } from 'tgui-core/exhaustive';
import { createSearch } from 'tgui-core/string';

import { SearchBar } from '../common/SearchBar';
import { count, exact } from './format';
import { BytesBar, SortCell, TruncatedNotice, useSort } from './parts';
import {
  LIST_STATUS_NOTE,
  type ListRow,
  type ListsReport,
  type ListWalkStatus,
  type OwnerSite,
} from './types';

type SortKey =
  | 'owner'
  | 'length'
  | 'allocated'
  | 'ref_count'
  | 'assoc_nodes'
  | 'bytes';

function sortValue(row: ListRow, key: SortKey): number | string {
  switch (key) {
    case 'owner':
      return row.owner;
    case 'length':
      return exact(row.length);
    case 'allocated':
      return exact(row.allocated);
    case 'ref_count':
      return row.ref_count;
    case 'assoc_nodes':
      return row.assoc_nodes;
    case 'bytes':
      return exact(row.bytes);
    default:
      return exhaustiveCheck(key);
  }
}

const SITE_COLORS: Record<OwnerSite, string> = {
  var: 'good',
  global: 'teal',
  list_index: 'purple',
  list_assoc: 'violet',
  client_slot: 'blue',
  alist_value: 'olive',
  proc_slot: 'orange',
  vis_vector: 'pink',
  orphan: 'bad',
};

/** Only where the key does not say plainly enough what was holding the list. */
const SITE_NOTES: Partial<Record<OwnerSite, string>> = {
  proc_slot:
    'An argument or local of a suspended proc frame. This is a last-resort label: the walk runs suspended frames after everything else, so a list only reads as proc_slot when no datum var, global or list holds it too.',
  vis_vector:
    'The vis_contents or vis_locs vector of an atom or image. Those are not lists - they are a flat Value array - so a list found only there used to read as an orphan.',
};

function SiteTag(props: { site: OwnerSite }) {
  const { site } = props;
  const note = SITE_NOTES[site];
  const tag = (
    <Box inline color={SITE_COLORS[site]}>
      {site}
    </Box>
  );

  return note ? <Tooltip content={note}>{tag}</Tooltip> : tag;
}

/**
 * A warning icon only where something is actually wrong.
 *
 * `empty` gets nothing on purpose: empty lists are most of a real world, and an
 * icon on nine rows in ten is noise rather than a signal.
 */
function StatusIcon(props: { status: ListWalkStatus }) {
  const { status } = props;

  switch (status) {
    case 'walked':
    case 'empty':
      return null;
    case 'no_vector':
    case 'over_capacity':
    case 'length_absurd':
      return (
        <Tooltip content={LIST_STATUS_NOTE[status]}>
          <Icon name="triangle-exclamation" ml={1} color="bad" />
        </Tooltip>
      );
    default:
      return exhaustiveCheck(status);
  }
}

/** One row per list, named by whoever holds it. */
export function PerListTable(props: { report: ListsReport }) {
  const { report } = props;
  const [search, setSearch] = useState('');
  const { sort, toggle } = useSort<SortKey>('bytes');

  const rows = useMemo(() => {
    const searchFn = createSearch(
      search,
      (row: ListRow) => `${row.owner} ${row.owner_site}`,
    );
    const sorted = sortBy(report.lists.filter(searchFn), [
      (row) => sortValue(row, sort.key),
    ]);
    return sort.desc ? sorted.reverse() : sorted;
  }, [report, search, sort]);

  const largest = useMemo(
    () => Math.max(1, ...rows.map((row) => exact(row.bytes))),
    [rows],
  );

  return (
    <>
      <TruncatedNotice
        truncated={report.lists_truncated}
        shown={report.lists.length}
        total={report.lists_total}
        noun="lists"
      />
      {/* The title is load-bearing: Section only gives its header a real
          height when it has one, and buttons are absolutely positioned
          inside that header, so a title-less Section drops the search bar
          on top of the first table rows. */}
      <Section
        fill
        scrollable
        title="Lists"
        buttons={
          <SearchBar
            expensive
            query={search}
            onSearch={setSearch}
            placeholder="Filter owners, or type a site like orphan..."
            style={{ width: '24rem' }}
          />
        }
      >
        <Table>
          <Table.Row header>
            <SortCell
              active={sort.key === 'owner'}
              desc={sort.desc}
              onClick={() => toggle('owner')}
            >
              Owner
            </SortCell>
            <Table.Cell collapsing>Site</Table.Cell>
            <SortCell
              collapsing
              active={sort.key === 'length'}
              desc={sort.desc}
              onClick={() => toggle('length')}
            >
              Len
            </SortCell>
            <SortCell
              collapsing
              active={sort.key === 'allocated'}
              desc={sort.desc}
              onClick={() => toggle('allocated')}
            >
              Alloc
            </SortCell>
            <SortCell
              collapsing
              active={sort.key === 'ref_count'}
              desc={sort.desc}
              onClick={() => toggle('ref_count')}
            >
              Refs
            </SortCell>
            <SortCell
              collapsing
              active={sort.key === 'assoc_nodes'}
              desc={sort.desc}
              onClick={() => toggle('assoc_nodes')}
            >
              Assoc
            </SortCell>
            <SortCell
              active={sort.key === 'bytes'}
              desc={sort.desc}
              onClick={() => toggle('bytes')}
            >
              Bytes
            </SortCell>
          </Table.Row>
          {rows.map((row) => (
            <Table.Row key={row.list_id} className="candystripe">
              <Table.Cell>
                {/* The id is never parsed anywhere: past 2^24 a rounded id
                    names a different list. */}
                <Tooltip content={`list#${row.list_id}`}>
                  <Box inline style={{ fontFamily: 'monospace' }}>
                    {row.owner}
                  </Box>
                </Tooltip>
                {!row.capacity_sane && (
                  <Tooltip content="Capacity failed the walk's sanity guard, so this row's allocated size is not trustworthy.">
                    <Icon name="ruler" ml={1} color="average" />
                  </Tooltip>
                )}
                <StatusIcon status={row.walk_status} />
              </Table.Cell>
              <Table.Cell collapsing>
                <SiteTag site={row.owner_site} />
              </Table.Cell>
              <Table.Cell collapsing className="text-right text-nowrap">
                {count(row.length)}
              </Table.Cell>
              <Table.Cell collapsing className="text-right text-nowrap">
                {count(row.allocated)}
              </Table.Cell>
              <Table.Cell collapsing className="text-right text-nowrap">
                {row.ref_count}
              </Table.Cell>
              <Table.Cell collapsing className="text-right text-nowrap">
                {row.assoc_nodes}
              </Table.Cell>
              <Table.Cell>
                <BytesBar value={row.bytes} max={largest} />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
    </>
  );
}
