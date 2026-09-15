import { sortBy } from 'es-toolkit';
import { useMemo, useState } from 'react';
import { Box, LabeledList, Section, Stack, Table } from 'tgui-core/components';
import { exhaustiveCheck } from 'tgui-core/exhaustive';
import { createSearch } from 'tgui-core/string';

import { useBackend } from '../../backend';
import { SearchBar } from '../common/SearchBar';
import { bytes, count, exact, metaFor } from './format';
import {
  BytesBar,
  EmptyState,
  ReportHeader,
  SortCell,
  TruncatedNotice,
  useSort,
} from './parts';
import type { Data, VarRow } from './types';

type SortKey = 'name' | 'count' | 'bytes';

function sortValue(row: VarRow, key: SortKey): number | string {
  switch (key) {
    case 'name':
      return row.name;
    case 'count':
      return exact(row.count);
    case 'bytes':
      return exact(row.bytes);
    default:
      return exhaustiveCheck(key);
  }
}

export function VarsTab() {
  const { act, data } = useBackend<Data>();
  const { vars_report, busy, report_meta } = data;
  const [search, setSearch] = useState('');
  const { sort, toggle } = useSort<SortKey>('bytes');

  const rows = useMemo(() => {
    if (!vars_report) {
      return [];
    }
    const searchFn = createSearch(search, (row: VarRow) => row.name);
    const sorted = sortBy(vars_report.vars.filter(searchFn), [
      (row) => sortValue(row, sort.key),
    ]);
    return sort.desc ? sorted.reverse() : sorted;
  }, [vars_report, search, sort]);

  const largest = useMemo(
    () => Math.max(1, ...rows.map((row) => exact(row.bytes))),
    [rows],
  );

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section>
          <ReportHeader
            label="Capture var histogram"
            busy={busy}
            onCapture={() => act('capture_vars')}
            meta={metaFor(report_meta, 'vars')}
          />
        </Section>
      </Stack.Item>
      {!vars_report ? (
        <Stack.Item>
          <EmptyState>
            A var row exists only where a var is set away from its type default,
            at 16 bytes each. A var on /atom set on every atom is a concrete
            thing to go delete, and this is how you find it.
          </EmptyState>
        </Stack.Item>
      ) : (
        <>
          <Stack.Item>
            <Section>
              <LabeledList>
                <LabeledList.Item label="Var rows">
                  {count(vars_report.var_rows_total)} rows across{' '}
                  {count(vars_report.vars_total)} distinct names
                </LabeledList.Item>
                <LabeledList.Item label="Total cost">
                  {bytes(vars_report.var_bytes)}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <TruncatedNotice
              truncated={vars_report.vars_truncated}
              shown={vars_report.vars.length}
              total={vars_report.vars_total}
              noun="var names"
            />
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill
              scrollable
              title="Var names"
              buttons={
                <SearchBar
                  expensive
                  query={search}
                  onSearch={setSearch}
                  placeholder="Filter var names..."
                  style={{ width: '20rem' }}
                />
              }
            >
              <Table>
                <Table.Row header>
                  <SortCell
                    active={sort.key === 'name'}
                    desc={sort.desc}
                    onClick={() => toggle('name')}
                  >
                    Var name
                  </SortCell>
                  <SortCell
                    collapsing
                    active={sort.key === 'count'}
                    desc={sort.desc}
                    onClick={() => toggle('count')}
                  >
                    Rows
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
                  <Table.Row key={row.name} className="candystripe">
                    <Table.Cell>
                      <Box inline>{row.name}</Box>
                    </Table.Cell>
                    <Table.Cell collapsing className="text-right text-nowrap">
                      {count(row.count)}
                    </Table.Cell>
                    <Table.Cell>
                      <BytesBar
                        value={row.bytes}
                        max={largest}
                        color="purple"
                      />
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
