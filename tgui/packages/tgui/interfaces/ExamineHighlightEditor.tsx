import { useState } from 'react';
import { Button, Section, Stack, TextArea, Input, Box, NoticeBox } from 'tgui-core/components';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';

type ExamineHighlightData = {
  adjective: string;
  leader: string;
  explanation: string;
  color: string;
  symbol: string;
  desc: string;
  is_custom: boolean;
};

export const ExamineHighlightEditor = () => {
  const { act, data } = useBackend<ExamineHighlightData>();
  const [adjective, setAdjective] = useState(data.adjective);
  const [leader, setLeader] = useState(data.leader);
  const [explanation, setExplanation] = useState(data.explanation);
  const [symbol, setSymbol] = useState(data.symbol);
  const [desc, setDesc] = useState(data.desc);

  return (
    <Window width={760} height={600}>
      <Window.Content>
        <Stack fill>
          <Stack.Item width="16em" basis="16em" shrink={0}>
            <Stack vertical fill>
              <Stack.Item>
                <Section title="Label">
                  <Stack vertical>
                    <Stack.Item>
                      <Box color="label">Leader phrase</Box>
                      <Input
                        fluid
                        value={leader}
                        onChange={(v) => setLeader(v)}
                        placeholder="It is "
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Box color="label">Adjective</Box>
                      <Input
                        fluid
                        value={adjective}
                        onChange={(v) => setAdjective(v)}
                        placeholder="HERETICAL"
                      />
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>

              <Stack.Item>
                <Section title="Examine Description">
                  <TextArea
                    value={desc}
                    onChange={(v) => setDesc(v)}
                    height="4em"
                    placeholder="It radiates unholy energy."
                  />
                </Section>
              </Stack.Item>

              <Stack.Item>
                <Section title="Style">
                  <Stack vertical>
                    <Stack.Item>
                      <Button fluid onClick={() => act('pick_color', {})}>
                        <Stack align="center">
                          <Stack.Item>
                            <Box
                              style={{
                                background: data.color,
                                border: '2px solid white',
                                boxSizing: 'content-box',
                                height: '11px',
                                width: '11px',
                              }}
                            />
                          </Stack.Item>
                          <Stack.Item>Color</Stack.Item>
                        </Stack>
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Input
                        fluid
                        value={symbol}
                        onChange={(v) => setSymbol(v)}
                        placeholder="Symbol (e.g. ᛣ)"
                      />
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>

              <Stack.Item grow />

              <Stack.Item>
                <Button
                  fluid
                  color="good"
                  content="Save"
                  onClick={() => act('set_highlight', { adjective, leader, explanation, symbol, desc })}
                />
              </Stack.Item>
              {!!data.is_custom && (
                <Stack.Item>
                  <Button fluid color="bad" content="Revert to Default" onClick={() => act('clear_highlight')} />
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>

          <Stack.Item grow basis={0}>
            <Section title="Tooltip Explanation (HTML)" fill>
              <TextArea
                value={explanation}
                onChange={(v) => setExplanation(v)}
                height="100%"
                width="100%"
                placeholder="<b>This is dangerous!</b><br>Extended lore text..."
              />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
