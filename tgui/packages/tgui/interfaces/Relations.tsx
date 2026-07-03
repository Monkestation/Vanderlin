import { Box, Button, Section, Stack, Tabs } from 'tgui-core/components';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type RelationEntry = {
  name: string;
  category: string;
  snapshot: SnapshotData | null;
  desc: string;
  grudges: GrudgeEntry[];
  is_asymmetric: boolean;
};

type SnapshotData = {
  name: string;
  vcolor: string | null;
  job: string;
  gender: string;
  age: number | string;
};

type GrudgeEntry = {
  label: string;
  text: string;
  is_gossip: number | boolean;
  say_string: string | null;
  rel_index: number | null;
  history_index: number | null;
};

type Data = {
  relations: RelationEntry[];
  rival_count: number;
  rival_pref: number;
};

// Known categories in preferred display order.
// Any category not listed here will appear alphabetically after these.
const TAB_ORDER = ['Rival', 'Friend'];

export const Relations = () => {
  const { data } = useBackend<Data>();
  const { relations = [], rival_count, rival_pref } = data;

  const [tab, setTab] = useLocalState<string>('rel_tab', 'All');

  const categories = Array.from(new Set(relations.map((r) => r.category)));
  const orderedCategories = [
    ...TAB_ORDER.filter((t) => categories.includes(t)),
    ...categories.filter((t) => !TAB_ORDER.includes(t)).sort(),
  ];
  const tabs = ['All', ...orderedCategories];

  const visible = relations.filter((r) => {
    if (tab === 'All') return true;
    return r.category === tab;
  });

  return (
    <Window width={360} height={520} title="Relations">
      <Window.Content scrollable>
        <Tabs>
          {tabs.map((t) => (
            <Tabs.Tab
              key={t}
              selected={tab === t}
              onClick={() => setTab(t)}
            >
              {t}
            </Tabs.Tab>
          ))}
        </Tabs>
        <Box mb={1} color="label">
          Rivals: {rival_count} / {rival_pref} preferred
        </Box>
        <Stack vertical>
          {visible.length === 0 && (
            <Stack.Item>
              <Box color="gray" italic>
                No relations in this category.
              </Box>
            </Stack.Item>
          )}
          {visible.map((rel, i) => (
            <Stack.Item key={i}>
              <RelationCard rel={rel} />
            </Stack.Item>
          ))}
        </Stack>
      </Window.Content>
    </Window>
  );
};

const RelationCard = ({ rel }: { rel: RelationEntry }) => {
  const { act } = useBackend<Data>();
  const { name, snapshot, desc, grudges } = rel;
  const [open, setOpen] = useLocalState<boolean>(`grudge_open_${name}`, false);

  const displayName = snapshot?.name ?? name;
  const job = snapshot?.job ?? 'Unknown';
  const gender = snapshot?.gender
    ? snapshot.gender.charAt(0).toUpperCase() + snapshot.gender.slice(1)
    : 'Unknown';
  const age = snapshot?.age ?? '?';

  return (
    <Section
      title={
        <Box inline>
          {displayName}
        </Box>
      }
      buttons={
        grudges.length > 0 && (
          <Button
            icon={open ? 'chevron-up' : 'chevron-down'}
            tooltip={open ? 'Hide history' : 'Show history'}
            onClick={() => setOpen(!open)}
          />
        )
      }
    >
      <Stack vertical>
        <Stack.Item>
          <Box color="gray" italic>
            {desc}
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Box>
            {job} &mdash; {gender}, {age}
          </Box>
        </Stack.Item>
        {open && grudges.length > 0 && (
          <Stack.Item>
            <Section title="History">
              <Stack vertical>
                {grudges.map((g, i) => (
                  <Stack.Item key={i}>
                    <Stack align="center">
                      <Stack.Item grow>
                        <Box color="average">
                          <b>{g.label}:</b> {g.text}
                        </Box>
                      </Stack.Item>
                      {!!g.is_gossip && g.say_string && (
                        <Stack.Item>
                          <Button
                            icon="comment"
                            tooltip="Say this gossip aloud"
                            onClick={() => act('say_gossip', { text: g.say_string, rel_index: g.rel_index, history_index: g.history_index })}
                          />
                        </Stack.Item>
                      )}
                    </Stack>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};
