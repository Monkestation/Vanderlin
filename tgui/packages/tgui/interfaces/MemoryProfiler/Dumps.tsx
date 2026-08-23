import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../../backend';
import { bytes, count } from './format';
import type { Data } from './types';

export function Dumps() {
  const { act, data } = useBackend<Data>();
  const { dumps, busy, dump_row_options, census, lists_report } = data;

  const knownLists = lists_report?.lists_total ?? census?.lists_total;

  return (
    <Section title="File dumps">
      <Stack vertical>
        <Stack.Item>
          <NoticeBox info>
            A returned report is capped at the top 40 rows per section, so a
            file is the only way to see everything. The server stays frozen for
            the whole walk and the whole write, and a full census on a live
            world runs to hundreds of megabytes.
          </NoticeBox>
        </Stack.Item>
        <Stack.Item>
          <Stack align="center" wrap>
            <Stack.Item>
              <Button.Confirm
                icon="file-arrow-down"
                disabled={!!busy}
                onClick={() => act('dump', { kind: 'census' })}
              >
                Dump full census
              </Button.Confirm>
            </Stack.Item>
            <Stack.Item color="label">Dump lists:</Stack.Item>
            {dump_row_options.map((option) =>
              option === 'all' ? (
                <Stack.Item key={option}>
                  <Button.Confirm
                    icon="triangle-exclamation"
                    color="bad"
                    disabled={!!busy}
                    confirmContent={
                      knownLists
                        ? `All ${count(knownLists)} lists?`
                        : 'Every list?'
                    }
                    onClick={() => act('dump', { kind: 'lists', rows: option })}
                  >
                    all
                  </Button.Confirm>
                </Stack.Item>
              ) : (
                <Stack.Item key={option}>
                  <Button
                    disabled={!!busy}
                    onClick={() => act('dump', { kind: 'lists', rows: option })}
                  >
                    {count(option)}
                  </Button>
                </Stack.Item>
              ),
            )}
          </Stack>
        </Stack.Item>
        <Stack.Item>
          {dumps.length === 0 ? (
            <Box color="label">Nothing dumped this round.</Box>
          ) : (
            <Table>
              <Table.Row header>
                <Table.Cell collapsing>When</Table.Cell>
                <Table.Cell>File</Table.Cell>
                <Table.Cell collapsing>Rows</Table.Cell>
                <Table.Cell collapsing>Size</Table.Cell>
                <Table.Cell collapsing />
              </Table.Row>
              {dumps.map((entry, index) => (
                <Table.Row key={entry.path} className="candystripe">
                  <Table.Cell collapsing className="text-nowrap">
                    {entry.at}
                  </Table.Cell>
                  <Table.Cell>
                    <Box inline style={{ fontFamily: 'monospace' }}>
                      {entry.name}
                    </Box>
                  </Table.Cell>
                  <Table.Cell
                    collapsing
                    className="text-right text-nowrap"
                    color={entry.truncated ? 'average' : undefined}
                  >
                    {count(entry.rows)} of {count(entry.total)}
                  </Table.Cell>
                  {/* BYOND measured this, so past 16 MB it is an estimate. It is a
                      "should you really click download" hint, not an accounting
                      figure. */}
                  <Table.Cell collapsing className="text-right text-nowrap">
                    ~{bytes(entry.size)}
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      icon="download"
                      onClick={() => act('download', { index: index + 1 })}
                    >
                      Download
                    </Button>
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
}
