import { useState, Fragment } from 'react';
import { useBackend } from '../backend';
import { Box, Button, Input, Section, Table, Tabs } from 'tgui-core/components';
import { Window } from '../layouts';

type AltChoice = {
  value: string;
  locked: boolean;
  reason?: string;
};

// Structural configuration data provided via ui_static_data
type StaticJobEntry = {
  title: string;
  tutorial: string;
  slots: number;
  title_choices: AltChoice[];
  honorary_choices: AltChoice[];
};

type StaticCategory = {
  name: string;
  color: string;
  jobs: StaticJobEntry[];
};

// Fluid state updates sent regularly via ui_data
type DynamicJobState = {
  display_name: string;
  pref_level: number | null;
  status: 'available' | 'locked' | 'banned';
  lock_label?: string;
  lock_detail?: string[];
  current_title: string;
  current_honorary: string;
};

type JobPrefsData = {
  jobless_role: string;
  last_class: string;
  race_banned: boolean;
  race_banned_name?: string;
  categories: StaticCategory[];
  job_states: Record<string, DynamicJobState>;
};

const PREF_LEVELS = [
  { value: 3, label: 'High' },
  { value: 2, label: 'Medium' },
  { value: 1, label: 'Low' },
  { value: null, label: 'Never' },
] as const;

export const JobPreferences = (props) => {
  const { act, data } = useBackend<JobPrefsData>();
  const { jobless_role, last_class, race_banned, race_banned_name, categories = [], job_states = {} } = data;

  const [activeCategory, setActiveCategory] = useState(categories[0]?.name);
  const [expandedJob, setExpandedJob] = useState<string | null>(null);
  const [activeExtraTab, setActiveExtraTab] = useState<'titles' | 'honorary'>('titles');
  const [searchText, setSearchText] = useState('');

  const currentCategory = categories.find((cat) => cat.name === activeCategory) || categories[0];

  const normalizedSearch = (typeof searchText === 'string' ? searchText : '').trim().toLowerCase();
  const isSearching = normalizedSearch.length > 0;

  // Map every job title back to the color of the department it belongs to,
  // so we can keep showing department color even when jobs are flattened
  // together (e.g. during search).
  const jobCategoryColor: Record<string, string> = {};
  for (const category of categories) {
    for (const job of category.jobs) {
      jobCategoryColor[job.title] = category.color;
    }
  }

  const getJobState = (job: StaticJobEntry): DynamicJobState =>
    job_states[job.title] || {
      display_name: job.title,
      pref_level: null,
      status: 'locked',
      current_title: job.title,
      current_honorary: '',
    };

  const jobMatchesSearch = (job: StaticJobEntry) => {
    const state = getJobState(job);
    const altTitleValues = job.title_choices?.map((choice) => choice.value) ?? [];
    const honoraryValues = job.honorary_choices?.map((choice) => choice.value) ?? [];
    const haystack = [
      job.title,
      state.display_name,
      state.current_title,
      state.current_honorary,
      ...altTitleValues,
      ...honoraryValues,
    ]
      .filter(Boolean)
      .join(' ')
      .toLowerCase();
    return haystack.includes(normalizedSearch);
  };

  const visibleJobs = isSearching
    ? categories.flatMap((category) => category.jobs.filter(jobMatchesSearch))
    : currentCategory?.jobs ?? [];

  if (race_banned) {
    return (
      <Window width={500} height={200} title="Class Selection">
        <Window.Content>
          <Section>
            <Box color="bad" bold>
              You are banned from playing the species: {race_banned_name}
            </Box>
          </Section>
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window width={950} height={700} title="Class Selection">
      <Window.Content scrollable>
        <Section>
          <Button content={`If Role Unavailable: ${jobless_role}`} onClick={() => act('toggle_jobless')} />
          <Button content="Reset" onClick={() => act('reset')} ml={1} />
          <Button content="Open Role Settings" onClick={() => act('open_role_settings')} ml={1} />
          {last_class && (
            <Button content={`Play as ${last_class} again`} onClick={() => act('play_last_class')} ml={1} />
          )}
        </Section>

        <Section>
          <Input
            fluid
            placeholder="Search jobs..."
            value={searchText}
            onChange={(value) => setSearchText(typeof value === 'string' ? value : '')}
          />
        </Section>

        <Tabs>
          {categories.map((category) => {
            const selected = activeCategory === category.name;
            return (
              <Tabs.Tab
                key={category.name}
                selected={selected}
                onClick={() => {
                  setActiveCategory(category.name);
                  setExpandedJob(null);
                }}
                style={{
                  borderBottom: `2px solid ${selected ? category.color : 'transparent'}`,
                }}
              >
                <Box style={{ color: category.color }} bold={selected}>
                  {category.name}
                </Box>
              </Tabs.Tab>
            );
          })}
        </Tabs>

        {(isSearching || currentCategory) && (
          <Section
            title={
              isSearching ? (
                `Search Results (${visibleJobs.length})`
              ) : (
                <Box style={{ color: currentCategory?.color }}>{currentCategory?.name}</Box>
              )
            }
          >
            <Table>
              <Table.Row header>
                <Table.Cell width="45%">Job</Table.Cell>
                <Table.Cell width="30%">Info</Table.Cell>
                <Table.Cell width="25%">Priority</Table.Cell>
              </Table.Row>

              {visibleJobs.length === 0 && isSearching && (
                <Table.Row>
                  <Table.Cell colSpan={3}>
                    <Box color="label" italic>
                      No jobs match "{searchText}"
                    </Box>
                  </Table.Cell>
                </Table.Row>
              )}

              {visibleJobs.map((job) => {
                const jobState = getJobState(job);
                const departmentColor = jobCategoryColor[job.title];

                const isExpanded = expandedJob === job.title;
                const hasTitles = job.title_choices && job.title_choices.length > 1;
                const hasHonorary = job.honorary_choices && job.honorary_choices.length > 1;
                const hasExtraInfo = jobState.status === 'available' && (hasTitles || hasHonorary);

                return (
                  <Fragment key={job.title}>
                    <Table.Row>
                      <Table.Cell
                        py={0.5}
                        style={{
                          borderLeft: `3px solid ${departmentColor || 'transparent'}`,
                          paddingLeft: '6px',
                        }}
                      >
                        <Button tooltip={job.tutorial} color="transparent" bold={jobState.status === 'available'}>
                          {jobState.status === 'available' ? jobState.current_title : jobState.display_name}
                        </Button>
                        {jobState.status === 'available' && (
                          <Box color="label" style={{ fontSize: '11px' }}>
                            {job.slots} slot{job.slots === 1 ? '' : 's'}
                          </Box>
                        )}
                        {jobState.status === 'banned' && (
                          <Box color="bad" style={{ fontSize: '11px' }}>
                            BANNED
                          </Box>
                        )}
                        {jobState.status === 'locked' && (
                          <Box color="average" style={{ fontSize: '11px' }}>
                            <Box bold>{jobState.lock_label}</Box>
                            {jobState.lock_detail?.map((line) => (
                              <Box key={line}>{line}</Box>
                            ))}
                          </Box>
                        )}
                      </Table.Cell>

                      <Table.Cell py={0.5}>
                        {hasExtraInfo && (
                          <Button
                            icon="info-circle"
                            selected={isExpanded}
                            color={isExpanded ? 'blue' : 'default'}
                            content={isExpanded ? "Close Info" : "Customize"}
                            onClick={() => {
                              setExpandedJob(isExpanded ? null : job.title);
                              setActiveExtraTab(hasTitles ? 'titles' : 'honorary');
                            }}
                          />
                        )}
                      </Table.Cell>

                      <Table.Cell py={0.5}>
                        {jobState.status === 'available' && (
                          <Box>
                            {PREF_LEVELS.map((opt) => {
                              const isSelected = jobState.pref_level === opt.value;
                              return (
                                <Button
                                  key={opt.value ?? 'never'}
                                  color={isSelected ? 'good' : 'transparent'}
                                  selected={isSelected}
                                  onClick={() => act('set_pref_level', { job: job.title, level: opt.value })}
                                >
                                  {opt.label}
                                </Button>
                              );
                            })}
                          </Box>
                        )}
                      </Table.Cell>
                    </Table.Row>

                    {isExpanded && (
                      <Table.Row>
                        <Table.Cell colSpan={3} style={{ backgroundColor: 'rgba(0,0,0,0.15)', padding: '8px' }}>
                          <Box mb={1} style={{ display: 'flex', gap: '4px' }}>
                            {hasTitles && (
                              <Button
                                compact
                                selected={activeExtraTab === 'titles'}
                                content="Alternate Titles"
                                onClick={() => setActiveExtraTab('titles')}
                              />
                            )}
                            {hasHonorary && (
                              <Button
                                compact
                                selected={activeExtraTab === 'honorary'}
                                content="Honorary Prefix"
                                onClick={() => setActiveExtraTab('honorary')}
                              />
                            )}
                          </Box>

                          {activeExtraTab === 'titles' && hasTitles && (
                            <Box style={{ maxHeight: '120px', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: '2px' }}>
                              {job.title_choices?.map((choice) => {
                                const isSelected = !choice.locked && jobState.current_title === choice.value;
                                return (
                                  <Button
                                    key={choice.value}
                                    content={choice.value}
                                    disabled={choice.locked}
                                    fluid
                                    textAlign="left"
                                    tooltip={choice.locked ? choice.reason : undefined}
                                    selected={isSelected}
                                    color={isSelected ? 'good' : 'transparent'}
                                    onClick={() =>
                                      !choice.locked &&
                                      act('set_job_pref', { job: job.title, category: 'title', value: choice.value })
                                    }
                                  />
                                );
                              })}
                            </Box>
                          )}

                          {activeExtraTab === 'honorary' && hasHonorary && (
                            <Box style={{ maxHeight: '120px', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: '2px' }}>
                              {job.honorary_choices?.map((choice) => {
                                const isSelected = !choice.locked && jobState.current_honorary === choice.value;
                                return (
                                  <Button
                                    key={choice.value || 'none'}
                                    content={choice.value || 'None'}
                                    disabled={choice.locked}
                                    fluid
                                    textAlign="left"
                                    tooltip={choice.locked ? choice.reason : undefined}
                                    selected={isSelected}
                                    color={isSelected ? 'good' : 'transparent'}
                                    onClick={() =>
                                      !choice.locked &&
                                      act('set_job_pref', {
                                        job: job.title,
                                        category: 'honorary',
                                        value: choice.value,
                                      })
                                    }
                                  />
                                );
                              })}
                            </Box>
                          )}
                        </Table.Cell>
                      </Table.Row>
                    )}
                  </Fragment>
                );
              })}
            </Table>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
