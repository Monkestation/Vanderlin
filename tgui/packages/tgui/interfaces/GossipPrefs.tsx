import { useState } from 'react';
import { Box, Button, Input, NumberInput, Section, Stack, Tabs } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  rumors: string[];
  noble_gossip: string[];
  max_rumors: number;
  max_noble_gossip: number;
  rival_count: number;
  rival_count_min: number;
  rival_count_max: number;
};

type TabKey = 'rumors' | 'noble' | 'rivals';

export const GossipPrefs = () => {
  const { data, act } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('rumors');

  return (
    <Window width={400} height={480} title="Gossip & Rumors">
      <Window.Content scrollable>
        <Box color="gray" italic mb={1}>
          Rumors and gossip you author here will be spread to other characters
          at roundstart. Write them as continuations of &quot;Did you hear
          that [name]...&quot;
        </Box>
        <Tabs>
          <Tabs.Tab selected={tab === 'rumors'} onClick={() => setTab('rumors')}>
            Rumors
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 'noble'} onClick={() => setTab('noble')}>
            Noble Gossip
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 'rivals'} onClick={() => setTab('rivals')}>
            Rivals
          </Tabs.Tab>
        </Tabs>
        {tab === 'rumors' && (
          <GossipList
            entries={data.rumors}
            max={data.max_rumors}
            addAction="add_rumor"
            removeAction="remove_rumor"
            editAction="edit_rumor"
            placeholder="stole bread from the market stalls..."
          />
        )}
        {tab === 'noble' && (
          <GossipList
            entries={data.noble_gossip}
            max={data.max_noble_gossip}
            addAction="add_noble_gossip"
            removeAction="remove_noble_gossip"
            editAction="edit_noble_gossip"
            placeholder="was seen meeting with foreign envoys in secret..."
          />
        )}
        {tab === 'rivals' && (
          <Section title="Rival Count">
            <Stack vertical>
              <Stack.Item>
                <Box color="gray" italic mb={1}>
                  Number of rivals your character starts with at roundstart.
                </Box>
              </Stack.Item>
              <Stack.Item>
                <NumberInput
                  value={data.rival_count}
                  minValue={data.rival_count_min}
                  maxValue={data.rival_count_max}
                  step={1}
                  onChange={(val) => act('set_rival_count', { value: val })}
                />
              </Stack.Item>
            </Stack>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};

type GossipListProps = {
  entries: string[];
  max: number;
  addAction: string;
  removeAction: string;
  editAction: string;
  placeholder: string;
};

const GossipList = ({
  entries,
  max,
  addAction,
  removeAction,
  editAction,
  placeholder,
}: GossipListProps) => {
  const { act } = useBackend();
  const [draft, setDraft] = useState('');
  const [editingIdx, setEditingIdx] = useState<number | null>(null);
  const [editText, setEditText] = useState('');

  const atCap = entries.length >= max;

  return (
    <Stack vertical>
      {entries.length === 0 && (
        <Stack.Item>
          <Box color="gray" italic>
            No entries yet.
          </Box>
        </Stack.Item>
      )}
      {entries.map((entry, i) => (
        <Stack.Item key={i}>
          <Section
            title={`Rumor ${i + 1}`}
            buttons={
              <>
                <Button
                  icon="pencil"
                  tooltip="Edit"
                  onClick={() => {
                    setEditingIdx(i);
                    setEditText(entry);
                  }}
                />
                <Button
                  icon="trash"
                  color="bad"
                  tooltip="Remove"
                  onClick={() => act(removeAction, { index: i + 1 })}
                />
              </>
            }
          >
            {editingIdx === i ? (
              <Stack vertical>
                <Stack.Item>
                  <Input
                    fluid
                    maxLength={150}
                    value={editText}
                    onChange={(val) => setEditText(val)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Stack>
                    <Stack.Item>
                      <Button
                        icon="check"
                        color="good"
                        onClick={() => {
                          act(editAction, { index: i + 1, text: editText });
                          setEditingIdx(null);
                        }}
                      >
                        Save
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="times"
                        onClick={() => setEditingIdx(null)}
                      >
                        Cancel
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            ) : (
              <Box color="label" italic>
                &quot;...{entry}&quot;
              </Box>
            )}
          </Section>
        </Stack.Item>
      ))}
      {!atCap && (
        <Stack.Item>
          <Section title="Add New">
            <Stack vertical>
              <Stack.Item>
                <Input
                  fluid
                  maxLength={150}
                  placeholder={placeholder}
                  value={draft}
                  onChange={(val) => setDraft(val)}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="plus"
                  color="good"
                  disabled={!draft.trim().length}
                  onClick={() => {
                    act(addAction, { text: draft });
                    setDraft('');
                  }}
                >
                  Add
                </Button>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
      )}
      {atCap && (
        <Stack.Item>
          <Box color="average" italic>
            Maximum entries reached ({max}).
          </Box>
        </Stack.Item>
      )}
    </Stack>
  );
};
