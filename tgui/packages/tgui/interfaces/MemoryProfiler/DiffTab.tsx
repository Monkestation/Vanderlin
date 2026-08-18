import { sortBy } from 'es-toolkit';
import { useMemo, useState } from 'react';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { exhaustiveCheck } from 'tgui-core/exhaustive';
import { createSearch } from 'tgui-core/string';

import { useBackend } from '../../backend';
import { SearchBar } from '../common/SearchBar';
import {
  bytes,
  count,
  deltaColor,
  exact,
  metaFor,
  signedBytes,
  signedCount,
} from './format';
import { EmptyState, SortCell, TruncatedNotice, useSort } from './parts';
import type { Data, DiffRow } from './types';

type SortKey = 'typepath' | 'count_change' | 'bytes_change' | 'count_after';

function sortValue(row: DiffRow, key: SortKey): number | string {
  switch (key) {
    case 'typepath':
      return row.typepath;
    case 'count_change':
      return exact(row.count_change);
    case 'bytes_change':
      return exact(row.bytes_change);
    case 'count_after':
      return exact(row.count_after);
    default:
      return exhaustiveCheck(key);
  }
}

export function DiffTab() {
  const { act, data } = useBackend<Data>();
  const { diff_report, busy, report_meta, baseline_at, baseline_by } = data;
  const [search, setSearch] = useState('');
  const { sort, toggle } = useSort<SortKey>('bytes_change');

  const rows = useMemo(() => {
    if (!diff_report) {
      return [];
    }
    const searchFn = createSearch(search, (row: DiffRow) => row.typepath);
    const sorted = sortBy(diff_report.types.filter(searchFn), [
      (row) => sortValue(row, sort.key),
    ]);
    return sort.desc ? sorted.reverse() : sorted;
  }, [diff_report, search, sort]);

  const meta = metaFor(report_meta, 'diff');

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section title="Baseline">
          <Stack vertical>
            <Stack.Item>
              <Stack align="center">
                <Stack.Item>
                  <Button
                    icon="flag"
                    disabled={!!busy}
                    onClick={() => act('set_baseline')}
                  >
                    Set baseline
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="scale-balanced"
                    disabled={!!busy || !baseline_at}
                    onClick={() => act('capture_diff')}
                  >
                    Diff against baseline
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    icon="trash"
                    color="bad"
                    disabled={!!busy}
                    onClick={() => act('clear')}
                  >
                    Clear
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item grow>
                  <Box color="label" textAlign="right">
                    {baseline_at
                      ? `baseline set by ${baseline_by} at ${baseline_at}`
                      : 'no baseline recorded'}
                    {meta
                      ? `, last walk froze the server for ${(meta.duration_ds / 10).toFixed(1)}s`
                      : ''}
                  </Box>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <NoticeBox info>
                Round start against round end is what actually finds a leak;
                absolute numbers rarely are. The extension keeps exactly one
                baseline and every diff installs a fresh one, so consecutive
                diffs each measure from the previous. The Memory Census (Text)
                verb shares that baseline with this panel.
              </NoticeBox>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      {!diff_report ? (
        <Stack.Item>
          <EmptyState>
            Set a baseline, let the round run, then diff. Types that did not
            move are dropped, and what is left is sorted by growth.
          </EmptyState>
        </Stack.Item>
      ) : diff_report.no_baseline ? (
        <Stack.Item>
          <NoticeBox color="yellow">
            That call only recorded a baseline, so there was nothing to compare
            against. Diff again to see what moved since.
          </NoticeBox>
        </Stack.Item>
      ) : (
        <>
          <Stack.Item>
            <Section>
              <LabeledList>
                <LabeledList.Item
                  label="Lists"
                  color={deltaColor(diff_report.list_count_change)}
                >
                  {signedCount(diff_report.list_count_change)} lists,{' '}
                  {signedBytes(diff_report.list_bytes_change)}
                </LabeledList.Item>
                <LabeledList.Item label="Types moved">
                  {count(diff_report.types_total)}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <TruncatedNotice
              truncated={diff_report.types_truncated}
              shown={diff_report.types.length}
              total={diff_report.types_total}
              noun="changed typepaths"
            />
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill
              scrollable
              title="Changed typepaths"
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
                    active={sort.key === 'count_after'}
                    desc={sort.desc}
                    onClick={() => toggle('count_after')}
                  >
                    Instances
                  </SortCell>
                  <SortCell
                    collapsing
                    active={sort.key === 'count_change'}
                    desc={sort.desc}
                    onClick={() => toggle('count_change')}
                  >
                    Change
                  </SortCell>
                  <Table.Cell collapsing>Bytes</Table.Cell>
                  <SortCell
                    collapsing
                    active={sort.key === 'bytes_change'}
                    desc={sort.desc}
                    onClick={() => toggle('bytes_change')}
                  >
                    Change
                  </SortCell>
                </Table.Row>
                {rows.map((row) => (
                  <Table.Row key={row.typepath} className="candystripe">
                    <Table.Cell>{row.typepath}</Table.Cell>
                    <Table.Cell collapsing className="text-right text-nowrap">
                      {count(row.count_before)} to {count(row.count_after)}
                    </Table.Cell>
                    <Table.Cell
                      collapsing
                      className="text-right text-nowrap"
                      color={deltaColor(row.count_change)}
                    >
                      {signedCount(row.count_change)}
                    </Table.Cell>
                    <Table.Cell collapsing className="text-right text-nowrap">
                      {bytes(row.bytes_before)} to {bytes(row.bytes_after)}
                    </Table.Cell>
                    <Table.Cell
                      collapsing
                      className="text-right text-nowrap"
                      color={deltaColor(row.bytes_change)}
                    >
                      {signedBytes(row.bytes_change)}
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
