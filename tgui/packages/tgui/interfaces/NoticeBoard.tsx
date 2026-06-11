import { useState } from 'react';
import { Box, Button, DmIcon, Icon, Section, Stack, Tabs } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Quest = {
  ref: string;
  title: string;
  type: string;
  difficulty: string;
  reward: number;
  reward_boosted: number;
  objective: string;
  location: string;
  region: string | null;
  giver: string | null;
  is_custom: number;
};

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

type ThreatRegion = {
  name: string;
  level: string;
  color: string;
  latent: number;
  fixed: number;
  invasion: number;
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
  easy_quests: Quest[];
  medium_quests: Quest[];
  hard_quests: Quest[];
  active_quests: ActiveQuest[];
  threats: ThreatRegion[];
  my_custom_quests: CustomQuest[];
  board_icon: string;
  board_icon_state: string;
  world_time: number;
};

const DIFF_COLOR: Record<string, string> = {
  Easy: 'good',
  Medium: 'average',
  Hard: 'bad',
};

function formatElapsed(acceptedTime: number, worldTime: number): string {
  console.log('formatElapsed raw:', acceptedTime, worldTime, typeof acceptedTime, typeof worldTime);
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

const BoardSprite = (props: { icon: string; icon_state: string; size?: number }) => {
  const { icon, icon_state, size = 2 } = props;
  const fallback = <Icon name="spinner" size={1} spin color="gray" />;
  return (
    <DmIcon fallback={fallback} icon={icon} icon_state={icon_state} height={size} width={size} />
  );
};

const DiffBadge = (props: { difficulty: string }) => {
  const color = DIFF_COLOR[props.difficulty] ?? 'label';
  return (
    <Box
      as="span"
      inline
      color={color}
      style={{ fontWeight: 'bold', marginRight: '4px' }}
    >
      [{props.difficulty}]
    </Box>
  );
};

const QuestDetail = (props: {
  quest: Quest;
  isQuestGiver: boolean;
  onBack: () => void;
  onClaim: (ref: string) => void;
  onBoost: (ref: string) => void;
}) => {
  const { quest, isQuestGiver, onBack, onClaim, onBoost } = props;
  return (
    <Section
      title={quest.title}
      buttons={
        <Stack>
          {isQuestGiver && (
            <Stack.Item>
              <Button
                icon="arrow-up"
                color="average"
                tooltip="Add to reward from the quest fund"
                onClick={() => onBoost(quest.ref)}
              >
                Boost
              </Button>
            </Stack.Item>
          )}
          <Stack.Item>
            <Button icon="arrow-left" onClick={onBack}>
              Back
            </Button>
          </Stack.Item>
        </Stack>
      }
    >
      <Stack vertical>
        <Stack.Item>
          <DiffBadge difficulty={quest.difficulty} />
          <Box as="span" color="label">
            {quest.type}
          </Box>
        </Stack.Item>

        <Stack.Item>
          <Box bold>Objective</Box>
          <Box>{quest.objective}</Box>
        </Stack.Item>

        {!!quest.location && (
          <Stack.Item>
            <Box bold>Location</Box>
            <Box>{quest.location}</Box>
          </Stack.Item>
        )}

        {quest.region !== null && quest.region !== '' && (
          <Stack.Item>
            <Box bold>Region</Box>
            <Box>{quest.region}</Box>
          </Stack.Item>
        )}

        {quest.giver !== null && quest.giver !== '' && (
          <Stack.Item>
            <Box bold>Issued by</Box>
            <Box>{quest.giver}</Box>
          </Stack.Item>
        )}

        <Stack.Item>
          <Box bold>Reward</Box>
          <Box color="good">
            {quest.reward} mammons
            {quest.reward_boosted > 0 && (
              <Box as="span" color="average" fontSize="0.85em" ml={1}>
                (+{quest.reward_boosted} mammons boosted)
              </Box>
            )}
          </Box>
        </Stack.Item>

        <Stack.Item>
          <Button
            fluid
            color="good"
            icon="scroll"
            onClick={() => onClaim(quest.ref)}
          >
            Accept this Quest
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const QuestPoolTab = (props: {
  quests: Quest[];
  difficulty: string;
  onSelect: (q: Quest) => void;
}) => {
  const { quests, difficulty, onSelect } = props;

  if (!quests.length) {
    return (
      <Box color="label" italic mt={1}>
        No {difficulty} quests are posted right now. Check back later.
      </Box>
    );
  }

  return (
    <Stack vertical>
      {quests.map((q) => (
        <Stack.Item key={q.ref}>
          <Button
            fluid
            color={DIFF_COLOR[q.difficulty] ?? 'default'}
            onClick={() => onSelect(q)}
          >
            <Stack align="center">
              <Stack.Item>
                <Icon name="scroll" mr={1} />
              </Stack.Item>
              <Stack.Item grow>
                <Box bold>{q.title}</Box>
                <Box fontSize="0.85em" color="label">
                  {q.type}
                  {q.is_custom === 1 && q.giver !== null && q.giver !== ''
                    ? ` — issued by ${q.giver}`
                    : ''}
                </Box>
              </Stack.Item>
             <Stack.Item>
                <Box color="good" bold>
                  {q.reward} mammons
                  {q.reward_boosted > 0 && (
                    <Box as="span" color="average" fontSize="0.8em" ml={1}>
                      ↑
                    </Box>
                  )}
                </Box>
              </Stack.Item>
            </Stack>
          </Button>
        </Stack.Item>
      ))}
    </Stack>
  );
};

const ThreatPanel = (props: { threats: ThreatRegion[] }) => {
  const { threats } = props;
  if (!threats.length) {
    return (
      <Box color="label" italic>
        No threat regions are registered.
      </Box>
    );
  }
  return (
    <Stack vertical>
      {threats.map((t) => (
        <Stack.Item key={t.name}>
          <Stack align="center">
            <Stack.Item grow>
              <Box bold style={{ color: t.color }}>
                {t.name}
                {t.fixed === 1 && (
                  <Box as="span" color="label" fontSize="0.8em" ml={1}>
                    (fixed)
                  </Box>
                )}
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Box style={{ color: t.color }}>
                {t.level}
                <Box as="span" color="label" fontSize="0.8em" ml={1}>
                  ({t.latent})
                </Box>
                {t.invasion === 1 && (
                  <Box as="span" color="bad" bold ml={1}>
                    ⚠ INVASION RISK
                  </Box>
                )}
              </Box>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      ))}
      <Stack.Item>
        <Box italic color="label" mt={1}>
          Funding more quests in high-threat areas reduces danger faster.
        </Box>
      </Stack.Item>
    </Stack>
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
        No quests currently in progress.
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
                    tooltip="Recall this scroll — quest returns to the board"
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
                  <Box as="span" color="label">Held by: </Box>
                  {q.receiver}
                </Box>
              </Stack.Item>
              {!!q.region && (
                <Stack.Item>
                  <Box>
                    <Box as="span" color="label">Region: </Box>
                    {q.region}
                  </Box>
                </Stack.Item>
              )}
              <Stack.Item>
                <Box>
                  <Box as="span" color="label">Progress: </Box>
                  {q.progress} / {q.progress_max}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box>
                  <Box as="span" color="label">Reward: </Box>
                  <Box as="span" color="good" bold>{q.reward} mammons</Box>
                  {q.reward_boosted > 0 && (
                    <Box as="span" color="average" fontSize="0.85em" ml={1}>
                      (+{q.reward_boosted} mammons boosted)
                    </Box>
                  )}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box>
                  <Box as="span" color="label">Time held: </Box>
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
        You have no active custom quests awaiting validation.
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
                  : ''}
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

export const NoticeBoard = () => {
  const { data, act } = useBackend<Data>();
  const {
    is_quest_giver,
    quest_fund,
    steward_balance,
    easy_quests,
    medium_quests,
    hard_quests,
    active_quests,
    threats,
    my_custom_quests,
    board_icon,
    board_icon_state,
    world_time,
  } = data;

  const isQuestGiver = is_quest_giver === 1;

  const [selectedQuest, setSelectedQuest] = useState<Quest | null>(null);
  const [diffTab, setDiffTab] = useState<'Easy' | 'Medium' | 'Hard'>('Easy');
  const [stewardTab, setStewardTab] = useState<'threats' | 'active' | 'validate'>('threats');

  const questsByDiff: Record<string, Quest[]> = {
    Easy: easy_quests,
    Medium: medium_quests,
    Hard: hard_quests,
  };

  return (
    <Window width={560} height={isQuestGiver ? 660 : 520} title="Guild Notice Board">
      <Window.Content scrollable>

        <Section>
          <Stack align="center">
            <Stack.Item>
              <BoardSprite icon={board_icon} icon_state={board_icon_state} size={3} />
            </Stack.Item>
            <Stack.Item grow>
              <Box fontSize="1.2em" bold>
                Guild Notice Board
              </Box>
              <Box color="label">
                Quest Fund:{' '}
                <Box as="span" color="good" bold>
                  {quest_fund} mammons
                </Box>
              </Box>
              <Box color="label">
                Available:{' '}
                <Box as="span" color="good">
                  {easy_quests.length} Easy
                </Box>{' '}
                /{' '}
                <Box as="span" color="average">
                  {medium_quests.length} Medium
                </Box>{' '}
                /{' '}
                <Box as="span" color="bad">
                  {hard_quests.length} Hard
                </Box>
              </Box>
            </Stack.Item>
          </Stack>
        </Section>

        <Section
          title="Quest Board"
          buttons={
            <Stack>
              <Stack.Item>
                <Button
                  icon="hand-holding-usd"
                  color="good"
                  onClick={() => act('turnin')}
                >
                  Turn In
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="times-circle"
                  color="bad"
                  onClick={() => act('abandon')}
                >
                  Abandon
                </Button>
              </Stack.Item>
            </Stack>
          }
        >
          {selectedQuest ? (
           <QuestDetail
              quest={selectedQuest}
              isQuestGiver={isQuestGiver}
              onBack={() => setSelectedQuest(null)}
              onClaim={(ref) => {
                act('claim_quest', { ref });
                setSelectedQuest(null);
              }}
              onBoost={(ref) => act('boost_reward', { ref })}
            />
          ) : (
            <>
              <Tabs>
                {(['Easy', 'Medium', 'Hard'] as const).map((d) => (
                  <Tabs.Tab
                    key={d}
                    selected={diffTab === d}
                    color={DIFF_COLOR[d]}
                    onClick={() => setDiffTab(d)}
                  >
                    {d} ({questsByDiff[d].length})
                  </Tabs.Tab>
                ))}
              </Tabs>
              <Box mt={1}>
                <QuestPoolTab
                  quests={questsByDiff[diffTab]}
                  difficulty={diffTab}
                  onSelect={setSelectedQuest}
                />
              </Box>
            </>
          )}
        </Section>

        {isQuestGiver && (
          <Section
            title="Steward Options"
            buttons={
              <Stack>
                <Stack.Item>
                  <Button
                    icon="coins"
                    color="average"
                    onClick={() => act('deposit_fund')}
                  >
                    Deposit ({steward_balance} mammons)
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
                selected={stewardTab === 'threats'}
                onClick={() => setStewardTab('threats')}
              >
                <Icon name="exclamation-triangle" mr={1} />
                Threats
              </Tabs.Tab>
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
              {stewardTab === 'threats' && <ThreatPanel threats={threats} />}
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
