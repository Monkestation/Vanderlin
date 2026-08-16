import { useMemo } from 'react';
import { Box, LabeledList, Section, Stack, Table } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Dumps } from './Dumps';
import { bytes, count, exact, metaFor } from './format';
import { Honesty } from './Honesty';
import { BytesBar, EmptyState, ReportHeader, SkipBreakdown } from './parts';
import type { Data } from './types';

export function Overview() {
  const { act, data } = useBackend<Data>();
  const { census, busy, report_meta, base_sizes } = data;

  const largestRetained = useMemo(
    () =>
      Math.max(
        1,
        ...(census?.retained.by_type ?? []).map((row) => exact(row.bytes)),
      ),
    [census],
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
      <Stack.Item grow>
        <Section fill scrollable>
          <Stack vertical>
            {!census ? (
              <Stack.Item>
                <EmptyState>
                  Nothing captured yet. A census walks the entire heap, which
                  takes seconds and freezes the server for all of them. It is a
                  diagnostic you run deliberately, not something to leave on a
                  timer.
                </EmptyState>
              </Stack.Item>
            ) : (
              <>
                <Stack.Item>
                  <Section title="Totals">
                    <LabeledList>
                      <LabeledList.Item label="Instances">
                        {count(census.total_instances)} across{' '}
                        {count(census.types_total)} typepaths, holding{' '}
                        {bytes(census.total_self_bytes)}
                      </LabeledList.Item>
                      <LabeledList.Item label="Lists">
                        {count(census.lists_total)} holding{' '}
                        {bytes(census.list_bytes)}
                      </LabeledList.Item>
                      <LabeledList.Item
                        label="Orphans"
                        color={
                          exact(census.orphan_lists) > 0 ? 'average' : undefined
                        }
                      >
                        {count(census.orphan_lists)} lists no named root reaches
                      </LabeledList.Item>
                      <SkipBreakdown skipped={census.skipped} />
                      <LabeledList.Item label="Var rows">
                        {count(census.var_rows_total)} rows across{' '}
                        {count(census.vars_total)} names, costing{' '}
                        {bytes(census.var_bytes)}
                      </LabeledList.Item>
                      <LabeledList.Item label="Build">
                        {census.build}
                      </LabeledList.Item>
                    </LabeledList>
                  </Section>
                </Stack.Item>
                <Stack.Item>
                  <Section title="Retained list bytes, attributed">
                    <LabeledList>
                      <LabeledList.Item label="Shared">
                        {bytes(census.retained.shared_bytes)} held more than
                        once, so ownership is genuinely ambiguous
                      </LabeledList.Item>
                      <LabeledList.Item label="Globals">
                        {bytes(census.retained.global_bytes)}
                      </LabeledList.Item>
                      <LabeledList.Item label="Alists">
                        {bytes(census.retained.alist_bytes)}
                      </LabeledList.Item>
                      <LabeledList.Item label="Orphans">
                        {bytes(census.retained.orphan_bytes)}
                      </LabeledList.Item>
                      <LabeledList.Item label="Too deep">
                        {bytes(census.retained.deep_bytes)} on chains that ran
                        past the hop cap
                      </LabeledList.Item>
                      <LabeledList.Item label="Unattributed">
                        {bytes(census.retained.unattributed_bytes)}, the five
                        above summed. This is what the refcount approximation
                        gives up on; it is not a dominator tree.
                      </LabeledList.Item>
                    </LabeledList>
                    <Table mt={1}>
                      <Table.Row header>
                        <Table.Cell>Attributed to typepath</Table.Cell>
                        <Table.Cell>Bytes</Table.Cell>
                      </Table.Row>
                      {census.retained.by_type.map((row) => (
                        <Table.Row key={row.typepath} className="candystripe">
                          <Table.Cell>{row.typepath}</Table.Cell>
                          <Table.Cell>
                            <BytesBar
                              value={row.bytes}
                              max={largestRetained}
                              color="olive"
                            />
                          </Table.Cell>
                        </Table.Row>
                      ))}
                    </Table>
                  </Section>
                </Stack.Item>
                <Stack.Item>
                  <Honesty footer={census.footer} />
                </Stack.Item>
              </>
            )}
            <Stack.Item>
              <Dumps />
            </Stack.Item>
            <Stack.Item>
              <Section title="What a row costs">
                <Box color="label" mb={1}>
                  Base sizes, each traced to an allocation site in byondcore. An
                  instance is charged this plus its var block, and a list this
                  plus its assoc tree, so these are the floor of a row rather
                  than the whole of it.
                </Box>
                <LabeledList>
                  {base_sizes.map((entry) => (
                    <LabeledList.Item key={entry.label} label={entry.label}>
                      {entry.bytes} B
                      {!!entry.note && (
                        <Box inline color="average" ml={1}>
                          - {entry.note}
                        </Box>
                      )}
                    </LabeledList.Item>
                  ))}
                </LabeledList>
              </Section>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
}
