import { sortBy } from 'es-toolkit';
import { useMemo, useState } from 'react';
import {
  Box,
  Icon,
  Section,
  Stack,
  Table,
  Tooltip,
} from 'tgui-core/components';
import { exhaustiveCheck } from 'tgui-core/exhaustive';
import { createSearch } from 'tgui-core/string';

import { useBackend } from '../../backend';
import { SearchBar } from '../common/SearchBar';
import { count, exact, metaFor } from './format';
import {
  BytesBar,
  EmptyState,
  ReportHeader,
  SortCell,
  TruncatedNotice,
  useSort,
} from './parts';
import type { Data, TypeRow } from './types';

type SortKey = 'typepath' | 'count' | 'self_bytes';

function sortValue(row: TypeRow, key: SortKey): number | string {
  switch (key) {
    case 'typepath':
      return row.typepath;
    case 'count':
      return exact(row.count);
    case 'self_bytes':
      return exact(row.self_bytes);
    default:
      return exhaustiveCheck(key);
  }
}

export function TypesTab() {
  const { act, data } = useBackend<Data>();
  const { census, busy, report_meta } = data;
  const [search, setSearch] = useState('');
  const { sort, toggle } = useSort<SortKey>('self_bytes');

  const rows = useMemo(() => {
    if (!census) {
      return [];
    }
    const searchFn = createSearch(search, (row: TypeRow) => row.typepath);
    const sorted = sortBy(census.types.filter(searchFn), [
      (row) => sortValue(row, sort.key),
    ]);
    return sort.desc ? sorted.reverse() : sorted;
  }, [census, search, sort]);

  const largest = useMemo(
    () => Math.max(1, ...rows.map((row) => exact(row.self_bytes))),
    [rows],
  );

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section>
          <ReportHeader
            label="Capture census"
            busy={busy}
            onCapture={() => act('capture_census')}
            meta={metaFor(report_meta, 'census')}
          />
        </Section>
      </Stack.Item>
      {!census ? (
        <Stack.Item>
          <EmptyState>
            No census captured yet. A census walks the entire heap and freezes
            the server while it runs.
          </EmptyState>
        </Stack.Item>
      ) : (
        <>
          <Stack.Item>
            <TruncatedNotice
              truncated={census.types_truncated}
              shown={census.types.length}
              total={census.types_total}
              noun="typepaths"
            />
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill
              scrollable
              title="Typepaths"
              buttons={
                <SearchBar
                  expensive
                  query={search}
                  onSearch={setSearch}
                  placeholder="Filter typepaths..."
                  style={{ width: '20rem' }}
                />
              }
            >
              <Table>
                <Table.Row header>
                  <SortCell
                    active={sort.key === 'typepath'}
                    desc={sort.desc}
                    onClick={() => toggle('typepath')}
                  >
                    Typepath
                  </SortCell>
                  <SortCell
                    collapsing
                    active={sort.key === 'count'}
                    desc={sort.desc}
                    onClick={() => toggle('count')}
                  >
                    Instances
                  </SortCell>
                  <SortCell
                    active={sort.key === 'self_bytes'}
                    desc={sort.desc}
                    onClick={() => toggle('self_bytes')}
                  >
                    Self bytes
                  </SortCell>
                </Table.Row>
                {rows.map((row) => (
                  <Table.Row key={row.typepath} className="candystripe">
                    <Table.Cell>
                      <Box inline color={row.costed ? undefined : 'average'}>
                        {row.typepath}
                      </Box>
                      {!row.costed && (
                        <Tooltip content="No verified base size for this type, so its bytes are not charged here. That is not the same as it being free.">
                          <Icon
                            name="triangle-exclamation"
                            ml={1}
                            color="average"
                          />
                        </Tooltip>
                      )}
                    </Table.Cell>
                    <Table.Cell collapsing className="text-right text-nowrap">
                      {count(row.count)}
                    </Table.Cell>
                    <Table.Cell>
                      <BytesBar value={row.self_bytes} max={largest} />
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          </Stack.Item>
        </>
      )}
    </Stack>
  );
}
