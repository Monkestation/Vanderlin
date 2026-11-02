import { Box, Button, Input, Section, Stack, Tabs, Tooltip} from 'tgui-core/components';
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
  job_key: string;
  job_category: string;
  honorary: string | null;
  honorary_suffix: string | null;
  species: string;
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

const TAB_ORDER = ['Rival', 'Friend'];

const JOB_CATEGORY_ORDER = [
  'Court',
  'Garrison',
  'Gallowband',
  'Church',
  'Inquisition',
  'Serfs',
  'Company',
  'Peasants',
  'Apprentices',
  'Youth',
  'Wanderers',
  'Other',
  'Unknown',
];

const jobCategoryRank = (cat: string | undefined) => {
  const idx = JOB_CATEGORY_ORDER.indexOf(cat ?? 'Unknown');
  return idx === -1 ? JOB_CATEGORY_ORDER.length : idx;
};

const formatDisplayName = (snapshot: SnapshotData | null, fallback: string) => {
  if (!snapshot) return fallback;
  const parts = [snapshot.honorary, snapshot.name ?? fallback, snapshot.honorary_suffix].filter(Boolean);
  return parts.join(' ');
};

export const Relations = () => {
  const { data } = useBackend<Data>();
  const { relations = [], rival_count, rival_pref } = data;

  const [tab, setTab] = useLocalState<string>('rel_tab', 'All');
  const [search, setSearch] = useLocalState<string>('rel_search', '');

  const categories = Array.from(new Set(relations.map((r) => r.category)));
  const orderedCategories = [
    ...TAB_ORDER.filter((t) => categories.includes(t)),
    ...categories.filter((t) => !TAB_ORDER.includes(t)).sort(),
  ];
  const tabs = ['All', ...orderedCategories];

  const query = (search ?? '').trim().toLowerCase();

  const visible = relations
    .filter((r) => (tab === 'All' ? true : r.category === tab))
    .filter((r) => {
      if (!query) return true;
      const s = r.snapshot;
      const haystack = [
        formatDisplayName(s, r.name),
        s?.job,
        s?.job_key,
        s?.species,
      ]
        .filter(Boolean)
        .join(' ')
        .toLowerCase();
      return haystack.includes(query);
    })
    .sort((a, b) => {
      const catDiff = jobCategoryRank(a.snapshot?.job_category) - jobCategoryRank(b.snapshot?.job_category);
      if (catDiff !== 0) return catDiff;
      return formatDisplayName(a.snapshot, a.name).localeCompare(formatDisplayName(b.snapshot, b.name));
    });

  return (
    <Window width={380} height={560} title="Relations">
      <Window.Content scrollable>
        <Tabs>
          {tabs.map((t) => (
            <Tabs.Tab key={t} selected={tab === t} onClick={() => setTab(t)}>
              {t}
            </Tabs.Tab>
          ))}
        </Tabs>
        <Box mb={1}>
          <Input
            fluid
            placeholder="Search name, job, or species..."
            value={search ?? ''}
            onChange={(value) => setSearch(value ?? '')}
          />
        </Box>
        <Box mb={1} color="label">
          Rivals: {rival_count} / {rival_pref} preferred
        </Box>
        <Stack vertical>
          {visible.length === 0 && (
            <Stack.Item>
              <Box color="gray" italic>
                No relations match.
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

  const displayName = formatDisplayName(snapshot, name);
  const job = snapshot?.job ?? 'Unknown';
  const species = snapshot?.species ?? 'Unknown';
  const gender = snapshot?.gender
    ? snapshot.gender.charAt(0).toUpperCase() + snapshot.gender.slice(1)
    : 'Unknown';
  const age = snapshot?.age ?? '?';
  const jobKey = snapshot?.job_key ?? job;
  const hasAltTitle = jobKey && job !== jobKey;


  return (
    <Section
      title={
        <Box inline style={{ color: 'red', fontWeight: 'bold' }}>
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
            {hasAltTitle ? (
              <Tooltip content={jobKey}>
                <Box inline style={{ borderBottom: '1px dotted currentColor', cursor: 'help' }}>
                  {job}
                </Box>
              </Tooltip>
            ) : (
              job
            )}
            {' '}&mdash; {species}, {gender}, {age}
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
                            onClick={() =>
                              act('say_gossip', {
                                text: g.say_string,
                                rel_index: g.rel_index,
                                history_index: g.history_index,
                              })
                            }
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
