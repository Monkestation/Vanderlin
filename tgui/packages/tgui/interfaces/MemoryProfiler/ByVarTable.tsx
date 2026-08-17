import { sortBy } from 'es-toolkit';
import { useMemo, useState } from 'react';
import { Box, Section, Stack, Table, Tooltip } from 'tgui-core/components';
import { exhaustiveCheck } from 'tgui-core/exhaustive';
import { createSearch } from 'tgui-core/string';

import { SearchBar } from '../common/SearchBar';
import { count, exact } from './format';
import {
  BytesBar,
  SortCell,
  TruncatedNotice,
  UnattributedList,
  useSort,
} from './parts';
import type { ListGroupRow, ListsReport } from './types';

type SortKey =
  | 'owner'
  | 'lists'
  | 'direct_lists'
  | 'elements'
  | 'assoc_nodes'
  | 'bytes';

function sortValue(row: ListGroupRow, key: SortKey): number | string {
  switch (key) {
    case 'owner':
      return row.owner;
    case 'lists':
      return exact(row.lists);
    case 'direct_lists':
      return exact(row.direct_lists);
    case 'elements':
      return exact(row.elements);
    case 'assoc_nodes':
      return exact(row.assoc_nodes);
    case 'bytes':
      return exact(row.bytes);
    default:
      return exhaustiveCheck(key);
  }
}

/**
 * Every list one type var holds, summed across all instances of that type.
 *
 * The per-list view cannot show this: it caps at a couple of thousand rows
 * sorted by size, so a var with 8,000 instances of 2 KiB each is 16 MiB spread
 * so thinly that no single row is ever big enough to appear. These totals come
 * off the whole world rather than off that page.
 */
export function ByVarTable(props: { report: ListsReport }) {
  const { report } = props;
  const [search, setSearch] = useState('');
  const { sort, toggle } = useSort<SortKey>('bytes');

  const rows = useMemo(() => {
    const searchFn = createSearch(
      search,
      (row: ListGroupRow) => `${row.typepath} ${row.var}`,
    );
    const sorted = sortBy(report.list_groups.filter(searchFn), [
      (row) => sortValue(row, sort.key),
    ]);
    return sort.desc ? sorted.reverse() : sorted;
  }, [report, search, sort]);

  const largest = useMemo(
    () => Math.max(1, ...rows.map((row) => exact(row.bytes))),
    [rows],
  );

  return (
    <Stack fill vertical>
      <Stack.Item>
        <TruncatedNotice
          truncated={report.list_groups_truncated}
          shown={report.list_groups.length}
          total={report.groups_total}
          noun="type vars"
        />
      </Stack.Item>
      <Stack.Item grow>
        {/* Title is load-bearing - see the note in PerListTable. */}
        <Section
          fill
          scrollable
          title="Lists by type var"
          buttons={
            <SearchBar
              expensive
              query={search}
              onSearch={setSearch}
              placeholder="Filter by typepath or var name..."
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
                Type var
              </SortCell>
              <SortCell
                collapsing
                active={sort.key === 'lists'}
                desc={sort.desc}
                onClick={() => toggle('lists')}
              >
                Lists
              </SortCell>
              <SortCell
                collapsing
                active={sort.key === 'direct_lists'}
                desc={sort.desc}
                onClick={() => toggle('direct_lists')}
              >
                Instances
              </SortCell>
              <SortCell
                collapsing
                active={sort.key === 'elements'}
                desc={sort.desc}
                onClick={() => toggle('elements')}
              >
                Elems
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
              <Table.Row key={row.owner} className="candystripe">
                <Table.Cell>
                  <Box inline style={{ fontFamily: 'monospace' }}>
                    {row.owner}
                  </Box>
                </Table.Cell>
                <Table.Cell collapsing className="text-right text-nowrap">
                  {/* Lists past the instance count are ones nested inside the
                      var's own list, which is exactly the case worth spotting. */}
                  <Tooltip
                    content={
                      exact(row.lists) > exact(row.direct_lists)
                        ? `${count(row.direct_lists)} held directly, the rest nested inside them`
                        : 'None of these are nested inside each other'
                    }
                  >
                    <Box inline>{count(row.lists)}</Box>
                  </Tooltip>
                </Table.Cell>
                <Table.Cell collapsing className="text-right text-nowrap">
                  {count(row.direct_lists)}
                </Table.Cell>
                <Table.Cell collapsing className="text-right text-nowrap">
                  {count(row.elements)}
                </Table.Cell>
                <Table.Cell collapsing className="text-right text-nowrap">
                  {count(row.assoc_nodes)}
                </Table.Cell>
                <Table.Cell>
                  <BytesBar value={row.bytes} max={largest} />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Stack.Item>
      <Stack.Item>
        {/* Rows that sum to less than the total, with nothing saying where the
            rest went, read as a complete accounting when they are not. */}
        <Section title="Not charged to any row above">
          <UnattributedList unattributed={report.unattributed} />
        </Section>
      </Stack.Item>
    </Stack>
  );
}
