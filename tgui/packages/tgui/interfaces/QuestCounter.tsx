import { useState } from 'react';
import { Box, Button, DmIcon, Icon, Section, Stack, Tabs } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type ActiveQuest = {
  ref: string;
  scroll_ref: string;
  title: string;
  difficulty: string;
  type: string;
  receiver: string;
  region: string | null;
  progress: number;
  progress_max: number;
  reward: number;
  reward_boosted: number;
  pledge_backed: number;
  accepted_time: number;
  is_custom: number;
};

type CustomQuest = {
  ref: string;
  title: string;
  difficulty: string;
  mode: string;
  receiver: string | null;
  claimed: number;
};

type Data = {
  is_quest_giver: number;
  quest_fund: number;
  steward_balance: number;
  active_quests: ActiveQuest[];
  my_custom_quests: CustomQuest[];
  counter_icon: string;
  counter_icon_state: string;
  world_time: number;
};

const DIFF_COLOR: Record<string, string> = {
  Easy: 'good',
  Medium: 'average',
  Hard: 'bad',
};

function formatElapsed(acceptedTime: number, worldTime: number): string {
  const at = parseFloat(String(acceptedTime));
  const wt = parseFloat(String(worldTime));
  if (!at || Number.isNaN(at) || Number.isNaN(wt)) return '—';
  const ds = wt - at;
  if (ds < 60) return 'just now';
  const totalMin = Math.floor(ds / 600);
  if (totalMin < 1) return 'less than a minute';
  const hours = Math.floor(totalMin / 60);
  const mins = totalMin % 60;
  return hours > 0 ? `${hours}h ${mins}m` : `${mins}m`;
}

const CounterSprite = (props: { icon: string; icon_state: string; size?: number }) => {
  const { icon, icon_state, size = 2 } = props;
  const fallback = <Icon name="spinner" size={1} spin color="gray" />;
  return (
    <DmIcon
      fallback={fallback}
      icon={icon}
      icon_state={icon_state}
      height={size}
      width={size}
    />
  );
};

const DiffBadge = (props: { difficulty: string }) => {
  const color = DIFF_COLOR[props.difficulty] ?? 'label';
  return (
    <Box as="span" inline color={color} style={{ fontWeight: 'bold', marginRight: '4px' }}>
      [{props.difficulty}]
    </Box>
  );
};

const ActiveQuestsPanel = (props: {
  quests: ActiveQuest[];
  worldTime: number;
  onBoost: (ref: string) => void;
  onRevoke: (ref: string) => void;
}) => {
  const { quests, worldTime, onBoost, onRevoke } = props;

  if (!quests.length) {
    return (
      <Box color="label" italic>
        No quests are currently in progress.
      </Box>
    );
  }

  return (
    <Stack vertical>
      {quests.map((q) => (
        <Stack.Item key={q.ref}>
          <Section
            title={
              <>
                <DiffBadge difficulty={q.difficulty} />
                {q.title}
                {q.pledge_backed === 1 && (
                  <Box as="span" color="label" fontSize="0.8em" ml={1}>
                    [pledged]
                  </Box>
                )}
              </>
            }
            buttons={
              <Stack>
                <Stack.Item>
                  <Button
                    icon="arrow-up"
                    color="average"
                    tooltip="Add to reward from the quest fund"
                    onClick={() => onBoost(q.ref)}
                  >
                    Boost
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="undo"
                    color="bad"
                    tooltip="Recall this scroll — quest returns to the notice board"
                    onClick={() => onRevoke(q.ref)}
                  >
                    Recall
                  </Button>
                </Stack.Item>
              </Stack>
            }
          >
            <Stack vertical>
              <Stack.Item>
                <Box>
                  <Box as="span" color="label">
                    Held by:{' '}
                  </Box>
                  {q.receiver}
                </Box>
              </Stack.Item>
              {!!q.region && (
                <Stack.Item>
                  <Box>
                    <Box as="span" color="label">
                      Region:{' '}
                    </Box>
                    {q.region}
                  </Box>
                </Stack.Item>
              )}
              <Stack.Item>
                <Box>
                  <Box as="span" color="label">
                    Progress:{' '}
                  </Box>
                  {q.progress} / {q.progress_max}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box>
                  <Box as="span" color="label">
                    Reward:{' '}
                  </Box>
                  <Box as="span" color="good" bold>
                    {q.reward} mammons
                  </Box>
                  {q.reward_boosted > 0 && (
                    <Box as="span" color="average" fontSize="0.85em" ml={1}>
                      (+{q.reward_boosted} mammons boosted)
                    </Box>
                  )}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box>
                  <Box as="span" color="label">
                    Time held:{' '}
                  </Box>
                  {formatElapsed(q.accepted_time, worldTime)}
                </Box>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
      ))}
    </Stack>
  );
};

const ValidatePanel = (props: {
  customQuests: CustomQuest[];
  onValidate: (ref: string) => void;
}) => {
  const { customQuests, onValidate } = props;

  if (!customQuests.length) {
    return (
      <Box color="label" italic>
        No custom quests are awaiting validation.
      </Box>
    );
  }

  return (
    <Stack vertical>
      {customQuests.map((cq) => (
        <Stack.Item key={cq.ref}>
          <Stack align="center">
            <Stack.Item grow>
              <Box bold>{cq.title}</Box>
              <Box color="label" fontSize="0.85em">
                <DiffBadge difficulty={cq.difficulty} />
                {cq.mode === 'item' ? 'Item Collection' : 'Freeform'}
                {cq.claimed === 1 && cq.receiver !== null && cq.receiver !== ''
                  ? ` — Claimed by ${cq.receiver}`
                  : ' — Unclaimed'}
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="check-circle"
                color="good"
                onClick={() => onValidate(cq.ref)}
              >
                Validate
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      ))}
    </Stack>
  );
};

export const QuestCounter = () => {
  const { data, act } = useBackend<Data>();
  const {
    is_quest_giver,
    quest_fund,
    steward_balance,
    active_quests,
    my_custom_quests,
    counter_icon,
    counter_icon_state,
    world_time,
  } = data;

  const isQuestGiver = is_quest_giver === 1;

  const [stewardTab, setStewardTab] = useState<'active' | 'validate'>('active');

  return (
    <Window
      width={520}
      height={isQuestGiver ? 580 : 220}
      title="Guild Quest Counter"
    >
      <Window.Content scrollable>

        <Section>
          <Stack align="center">
            <Stack.Item>
              <CounterSprite
                icon={counter_icon}
                icon_state={counter_icon_state}
                size={3}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Box fontSize="1.2em" bold>
                Guild Quest Counter
              </Box>
              <Box color="label">
                Quest Fund:{' '}
                <Box as="span" color="good" bold>
                  {quest_fund} mammons
                </Box>
              </Box>
              {isQuestGiver && (
                <Box color="label" fontSize="0.9em">
                  Your balance:{' '}
                  <Box as="span" color="good">
                    {steward_balance} mammons
                  </Box>
                </Box>
              )}
            </Stack.Item>
          </Stack>
        </Section>

        <Section title="Contract Filing">
          <Stack>
            <Stack.Item grow>
              <Button
                fluid
                icon="scroll"
                color="good"
                onClick={() => act('turnin')}
              >
                Turn In Quest
              </Button>
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fluid
                icon="times-circle"
                color="bad"
                onClick={() => act('abandon')}
              >
                Abandon Quest
              </Button>
            </Stack.Item>
          </Stack>
          <Box color="label" italic fontSize="0.85em" mt={1}>
            Hold your scroll in hand, or place it on the marked area in front of the counter.
          </Box>
        </Section>

        {isQuestGiver && (
          <Section
            title="Steward Desk"
            buttons={
              <Stack>
                <Stack.Item>
                  <Button
                    icon="coins"
                    color="average"
                    onClick={() => act('deposit_fund')}
                  >
                    Deposit ({steward_balance}m)
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="plus-circle"
                    color="good"
                    onClick={() => act('issue_custom')}
                  >
                    Issue Quest
                  </Button>
                </Stack.Item>
              </Stack>
            }
          >
            <Tabs>
              <Tabs.Tab
                selected={stewardTab === 'active'}
                onClick={() => setStewardTab('active')}
              >
                <Icon name="tasks" mr={1} />
                Active ({active_quests.length})
              </Tabs.Tab>
              <Tabs.Tab
                selected={stewardTab === 'validate'}
                onClick={() => setStewardTab('validate')}
              >
                <Icon name="check-circle" mr={1} />
                Validate ({my_custom_quests.length})
              </Tabs.Tab>
            </Tabs>

            <Box mt={1}>
              {stewardTab === 'active' && (
                <ActiveQuestsPanel
                  quests={active_quests}
                  worldTime={world_time}
                  onBoost={(ref) => act('boost_reward', { ref })}
                  onRevoke={(ref) => act('revoke_quest', { ref })}
                />
              )}
              {stewardTab === 'validate' && (
                <ValidatePanel
                  customQuests={my_custom_quests}
                  onValidate={(ref) => act('validate_custom', { ref })}
                />
              )}
            </Box>
          </Section>
        )}

      </Window.Content>
    </Window>
  );
};
