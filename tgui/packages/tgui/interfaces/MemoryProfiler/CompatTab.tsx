import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../../backend';
import { bytes, count, metaFor } from './format';
import { EmptyState, ReportHeader } from './parts';
import type { Data } from './types';

const MONOSPACE = { fontFamily: 'monospace', whiteSpace: 'pre-wrap' } as const;

function bucket(labels: string[] | undefined) {
  return labels?.length ? labels.join(', ') : 'none';
}

export function CompatTab() {
  const { act, data } = useBackend<Data>();
  const { compat_report, coverage, debug_text, busy, report_meta } = data;

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section title="Cross-check against BYOND">
          <ReportHeader
            label="Capture comparison"
            busy={busy}
            onCapture={() => act('capture_compat')}
            meta={metaFor(report_meta, 'compat')}
          />
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          <Stack vertical>
            <Stack.Item>
              <NoticeBox info>
                These rows must match BYOND's own GetServerMemUsage output. A
                table this tool failed to find otherwise looks exactly like a
                clean scan, which is the entire reason this comparison exists.
                Five rows always, plus a sixth for alists on a world holding any
                - BYOND omits that row when the count is zero, so this does too,
                and a missing alists row on both sides is agreement rather than
                a gap.
              </NoticeBox>
            </Stack.Item>
            {!compat_report ? (
              <Stack.Item>
                <EmptyState>Nothing captured yet.</EmptyState>
              </Stack.Item>
            ) : (
              <>
                <Stack.Item>
                  <Section title="byond_memprofile">
                    <Table>
                      <Table.Row header>
                        <Table.Cell>Kind</Table.Cell>
                        <Table.Cell collapsing>Count</Table.Cell>
                        <Table.Cell collapsing>Bytes</Table.Cell>
                      </Table.Row>
                      {compat_report.memprofile.map((row) => (
                        <Table.Row key={row.label} className="candystripe">
                          <Table.Cell>{row.label}</Table.Cell>
                          <Table.Cell
                            collapsing
                            className="text-right text-nowrap"
                          >
                            {count(row.count)}
                          </Table.Cell>
                          <Table.Cell
                            collapsing
                            className="text-right text-nowrap"
                          >
                            {bytes(row.bytes)}
                          </Table.Cell>
                        </Table.Row>
                      ))}
                    </Table>
                  </Section>
                </Stack.Item>
                <Stack.Item>
                  <Section title="BYOND GetServerMemUsage">
                    {compat_report.byond_available &&
                    compat_report.byond_raw ? (
                      <Box style={MONOSPACE}>{compat_report.byond_raw}</Box>
                    ) : (
                      <NoticeBox color="yellow">
                        BYOND's own report symbols did not resolve, which is
                        always the case off Windows. There is nothing to compare
                        against, so a missing table here would go unnoticed.
                      </NoticeBox>
                    )}
                  </Section>
                </Stack.Item>
              </>
            )}
            <Stack.Item>
              <Section title="Table coverage">
                {!coverage ? (
                  <EmptyState>
                    Coverage is read once at init. If this is empty, the
                    extension never initialized.
                  </EmptyState>
                ) : (
                  <>
                    {!coverage.complete && (
                      <NoticeBox danger>
                        This build could not reach every table. Every total in
                        every report is short by whatever lives in the
                        unavailable ones.
                      </NoticeBox>
                    )}
                    <LabeledList>
                      <LabeledList.Item label="Build">
                        {coverage.build}
                      </LabeledList.Item>
                      <LabeledList.Item label="Scanned" color="good">
                        {bucket(coverage.scanned)}
                      </LabeledList.Item>
                      <LabeledList.Item label="Forward validated" color="teal">
                        {bucket(coverage.forward_validated)}
                      </LabeledList.Item>
                      <LabeledList.Item label="Fallback" color="average">
                        {bucket(coverage.fallback)}
                      </LabeledList.Item>
                      <LabeledList.Item label="Unavailable" color="bad">
                        {bucket(coverage.unavailable)}
                      </LabeledList.Item>
                    </LabeledList>
                  </>
                )}
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Section
                title="Extension debug buffer"
                buttons={
                  <Button
                    icon="download"
                    disabled={!!busy}
                    onClick={() => act('drain_debug')}
                  >
                    Drain
                  </Button>
                }
              >
                {debug_text ? (
                  <Box style={MONOSPACE}>{debug_text}</Box>
                ) : (
                  <Box color="label">
                    Empty. Draining clears the buffer on the extension side.
                  </Box>
                )}
              </Section>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
}
