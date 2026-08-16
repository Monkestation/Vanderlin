import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  DmIcon,
  Icon,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { Window } from 'tgui/layouts';

type Track = {
  id: string;
  name: string;
  level: number;
  rank: string;
  modifiers?: {
    cost: number;
    castSpeed: number;
    magnitude: number;
  } | null;
};

type SpellEntry = {
  path: string;
  name: string;
  desc: string;
  technique: string | null;
  form: string | null;
  level: number;
  formCost: number;
  techniqueCost: number;
  unlocked: boolean;
  canLearn: boolean;
  canUnlearn: boolean;
  icon: string;
  iconState: string;
};

type SpellBookData = {
  unspentFormPoints: number;
  unspentTechniquePoints: number;
  unlearnMode: boolean;
  techniqueLevels: Track[];
  formLevels: Track[];
  spells: SpellEntry[];
};

type SpellBookStatic = {
  techniques: string[];
  forms: string[];
};

const formatModifierPart = (label: string, multiplier: number) => {
  if (multiplier === 1) return null;
  const pct = Math.round((multiplier - 1) * 100);
  return `${pct > 0 ? '+' : ''}${pct}% ${label}`;
};

const formatModifierWhole = (label: string, multiplier: number) => {
  if (multiplier === 0) return null;
  const pct = ((multiplier));
  return `${pct > 0 ? '+' : ''}${pct} ${label}`;
};

const formatModifiers = (modifiers: Track['modifiers']) => {
  if (!modifiers) return null;
  const parts = [
    formatModifierPart('mana cost', modifiers.cost),
    formatModifierPart('cast speed', modifiers.castSpeed),
    formatModifierWhole('magnitude', modifiers.magnitude),
  ].filter(Boolean);
  return parts.length > 0 ? parts.join(', ') : null;
};

const SpellSprite = (props: { icon: string; iconState: string }) => {
  const { icon, iconState } = props;
  if (!icon || !iconState) {
    return null;
  }
  return (
    <DmIcon
      fallback={<Icon name="wand-magic-sparkles" size={1.4} color="gray" />}
      icon={icon}
      icon_state={iconState}
      height={2}
      width={2}
    />
  );
};

const costLabel = (spell: SpellEntry) => {
  const parts: string[] = [];
  if (spell.formCost > 0) {
    parts.push(`${spell.formCost} form pt${spell.formCost === 1 ? '' : 's'}`);
  }
  if (spell.techniqueCost > 0) {
    parts.push(
      `${spell.techniqueCost} technique pt${spell.techniqueCost === 1 ? '' : 's'}`,
    );
  }
  return parts.length > 0 ? parts.join(', ') : 'Free';
};

const SpellCard = (props: {
  spell: SpellEntry;
  unlearnMode: boolean;
  onLearn: (path: string) => void;
  onUnlearn: (path: string) => void;
}) => {
  const { spell, unlearnMode, onLearn, onUnlearn } = props;
  const status = spell.unlocked
    ? 'unlocked'
    : spell.canLearn
      ? 'available'
      : 'locked';

  return (
    <Box
      className={`SpellBook__node SpellBook__node--${status}`}
      backgroundColor="rgba(255,255,255,0.03)"
      p={1}
      mb={0.5}
    >
      <Stack align="center">
        <Stack.Item>
          <SpellSprite icon={spell.icon} iconState={spell.iconState} />
        </Stack.Item>
        <Stack.Item grow>
          <Box bold>{spell.name}</Box>
          <Box color="label" fontSize="0.9em">
            {spell.desc}
          </Box>
          <Box fontSize="0.85em" color="label">
            Cost: {costLabel(spell)}
            {spell.level > 0 &&
              (spell.form || spell.technique) &&
              ` · Requires ${spell.form || spell.technique} ${spell.level}`}
          </Box>
        </Stack.Item>
        <Stack.Item>
          {unlearnMode ? (
            <Button
              content="Unlearn"
              color="bad"
              disabled={!spell.canUnlearn}
              onClick={() => onUnlearn(spell.path)}
            />
          ) : spell.unlocked ? (
            <Icon name="check" color="good" />
          ) : (
            <Button
              content="Learn"
              disabled={!spell.canLearn}
              onClick={() => onLearn(spell.path)}
            />
          )}
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const TrackSummary = (props: { track: Track | undefined; label: string }) => {
  const { track, label } = props;
  if (!track) {
    return null;
  }
  return (
    <Box bold mb={1}>
      {label} - {track.rank} ({track.level})
    </Box>
  );
};

const InvestRow = (props: {
  track: Track;
  disabled: boolean;
  onInvest: (id: string) => void;
}) => {
  const { track, disabled, onInvest } = props;
  const modifierText = formatModifiers(track.modifiers);

  return (
    <Stack align="center" mb={0.5} className="SpellBook__invest-row">
      <Stack.Item grow>
        <Box bold>{track.name}</Box>
        <Box color="label" fontSize="0.9em">
          {track.rank} - Level {track.level}
        </Box>
        {modifierText && (
          <Box color="average" fontSize="0.85em">
            {modifierText}
          </Box>
        )}
      </Stack.Item>
      <Stack.Item>
        <Button
          content="Invest 1 point"
          disabled={disabled}
          onClick={() => onInvest(track.id)}
        />
      </Stack.Item>
    </Stack>
  );
};

const StatsPage = (props: {
  unspentFormPoints: number;
  unspentTechniquePoints: number;
  techniqueLevels: Track[];
  formLevels: Track[];
  act: (action: string, params?: object) => void;
}) => {
  const {
    unspentFormPoints,
    unspentTechniquePoints,
    techniqueLevels,
    formLevels,
    act,
  } = props;

  return (
    <Stack fill mt={1}>
      <Stack.Item grow>
        <Section
          title="Techniques"
          fill
          scrollable
          buttons={
            <Box color={unspentTechniquePoints > 0 ? 'good' : 'label'}>
              {unspentTechniquePoints} pt{unspentTechniquePoints === 1 ? '' : 's'}
            </Box>
          }
        >
          {techniqueLevels.map((track) => (
            <InvestRow
              key={track.id}
              track={track}
              disabled={unspentTechniquePoints < 1}
              onInvest={(id) => act('invest_technique', { technique: id })}
            />
          ))}
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section
          title="Forms"
          fill
          scrollable
          buttons={
            <Box color={unspentFormPoints > 0 ? 'good' : 'label'}>
              {unspentFormPoints} pt{unspentFormPoints === 1 ? '' : 's'}
            </Box>
          }
        >
          {formLevels.map((track) => (
            <InvestRow
              key={track.id}
              track={track}
              disabled={unspentFormPoints < 1}
              onInvest={(id) => act('invest_form', { form: id })}
            />
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const LearnPage = (props: {
  techniques: string[];
  forms: string[];
  techniqueLevels: Track[];
  formLevels: Track[];
  spells: SpellEntry[];
  unlearnMode: boolean;
  act: (action: string, params?: object) => void;
}) => {
  const {
    techniques,
    forms,
    techniqueLevels,
    formLevels,
    spells,
    unlearnMode,
    act,
  } = props;

  const [activeForm, setActiveForm] = useState<string>(forms[0]);
  const [activeTechnique, setActiveTechnique] = useState<string | null>(null);

  const formTrack = formLevels.find((f) => f.id === activeForm);
  const spellsInForm = spells.filter((spell) => spell.form === activeForm);

  const techniqueSpells = spellsInForm.filter((spell) => spell.technique);
  const techniquelessSpells = spellsInForm.filter((spell) => !spell.technique);

  const relevantTechniques = techniques.filter((technique) =>
    techniqueSpells.some((spell) => spell.technique === technique),
  );
  const currentTechnique =
    activeTechnique && relevantTechniques.includes(activeTechnique)
      ? activeTechnique
      : relevantTechniques[0];
  const techniqueTrack = techniqueLevels.find(
    (t) => t.id === currentTechnique,
  );
  const visibleTechniqueSpells = techniqueSpells.filter(
    (spell) => spell.technique === currentTechnique,
  );

  const onLearn = (path: string) => act('learn_spell', { path });
  const onUnlearn = (path: string) => act('unlearn_spell', { path });

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Stack align="center">
          <Stack.Item grow>
            <Tabs>
              {forms.map((form) => {
                const track = formLevels.find((f) => f.id === form);
                return (
                  <Tabs.Tab
                    key={form}
                    selected={activeForm === form}
                    onClick={() => {
                      setActiveForm(form);
                      setActiveTechnique(null);
                    }}
                  >
                    {form}
                    {track ? ` (${track.level})` : ''}
                  </Tabs.Tab>
                );
              })}
            </Tabs>
          </Stack.Item>
        </Stack>
      </Stack.Item>

      <Stack.Item grow style={{ minHeight: 0 }}>
        <Stack fill>
          <Stack.Item grow={3} style={{ minHeight: 0 }}>
            <Section title="Techniques" fill>
              <Stack vertical fill>

                <Stack.Item>
                  <TrackSummary track={formTrack} label={activeForm} />

                  {relevantTechniques.length > 0 && (
                    <Tabs mb={1}>
                      {relevantTechniques.map((technique) => (
                        <Tabs.Tab
                          key={technique}
                          selected={currentTechnique === technique}
                          onClick={() => setActiveTechnique(technique)}
                        >
                          {technique}
                        </Tabs.Tab>
                      ))}
                    </Tabs>
                  )}

                  <TrackSummary track={techniqueTrack} label={currentTechnique || ''} />
                </Stack.Item>

                <Stack.Item grow style={{ minHeight: 0, overflowY: 'auto' }}>
                  {visibleTechniqueSpells.length === 0 && (
                    <Box color="label" italic>
                      No technique-gated spells here yet.
                    </Box>
                  )}
                  {visibleTechniqueSpells.map((spell) => (
                    <SpellCard
                      key={spell.path}
                      spell={spell}
                      unlearnMode={unlearnMode}
                      onLearn={onLearn}
                      onUnlearn={onUnlearn}
                    />
                  ))}
                </Stack.Item>

              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item grow={2} style={{ minHeight: 0 }}>
            <Section title={`Techniqueless ${activeForm}`} fill scrollable>
              {techniquelessSpells.length === 0 && (
                <Box color="label" italic>
                  No techniqueless {activeForm} spells.
                </Box>
              )}
              {techniquelessSpells.map((spell) => (
                <SpellCard
                  key={spell.path}
                  spell={spell}
                  unlearnMode={unlearnMode}
                  onLearn={onLearn}
                  onUnlearn={onUnlearn}
                />
              ))}
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const SpellBook = () => {
  const { act, data } = useBackend<SpellBookData & SpellBookStatic>();
  const {
    unspentFormPoints,
    unspentTechniquePoints,
    unlearnMode,
    techniques = [],
    forms = [],
    techniqueLevels = [],
    formLevels = [],
    spells = [],
  } = data;

  const [page, setPage] = useState<'learn' | 'stats'>('learn');

  return (
    <Window width={780} height={640} title="Spellcraft">
      <Window.Content scrollable={false}>
        <Stack vertical fill>
          <Stack.Item>
            <Section
              title="Spellcraft"
              buttons={
                <Stack>
                  <Stack.Item>
                    <Box bold color={unspentFormPoints > 0 ? 'good' : 'label'}>
                      Form: {unspentFormPoints}
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Box bold color={unspentTechniquePoints > 0 ? 'good' : 'label'}>
                      Technique: {unspentTechniquePoints}
                    </Box>
                  </Stack.Item>
                </Stack>
              }
            >
              <Tabs>
                <Tabs.Tab selected={page === 'learn'} onClick={() => setPage('learn')}>
                  <Icon name="book-open" mr={1} />
                  Learn
                </Tabs.Tab>
                <Tabs.Tab selected={page === 'stats'} onClick={() => setPage('stats')}>
                  <Icon name="chart-simple" mr={1} />
                  Stats
                </Tabs.Tab>
              </Tabs>
            </Section>
          </Stack.Item>

          <Stack.Item grow style={{ minHeight: 0 }}>
            {page === 'learn' ? (
              <LearnPage
                techniques={techniques}
                forms={forms}
                techniqueLevels={techniqueLevels}
                formLevels={formLevels}
                spells={spells}
                unlearnMode={unlearnMode}
                act={act}
              />
            ) : (
              <StatsPage
                unspentFormPoints={unspentFormPoints}
                unspentTechniquePoints={unspentTechniquePoints}
                techniqueLevels={techniqueLevels}
                formLevels={formLevels}
                act={act}
              />
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
