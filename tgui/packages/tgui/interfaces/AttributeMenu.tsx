import { useBackend, useLocalState } from '../backend';
import { Box, Button, Input, Stack, Tooltip } from 'tgui-core/components';
import { Window } from '../layouts';
import { TutorialOverlay, TutorialStep, PP } from '../interfaces/_common/TutorialOverlay';

interface AttributeModifier {
  id: string;
  value: number;
}

interface Attribute {
  name: string;
  shorthand?: string;
  desc?: string;
  icon?: string;
  value: number | null;
  raw_value: number | null;
  difficulty?: string;
  governing_attribute?: string;
  default_value?: number;
  defaults?: Attribute[];
  modifiers?: AttributeModifier[];
}

interface SkillCategory {
  name: string;
  skills: Attribute[];
}

interface AttributeData {
  show_bad_skills: boolean;
  parent?: string;
  skills_by_category: SkillCategory[];
  stats: Attribute[];
  closely_inspected_attribute: Attribute | null;
}

const TUTORIAL_STEPS: TutorialStep[] = [
  {
    title: 'Welcome to the Attribute Menu!',
    body: "This menu shows your character's stats and skills at a glance. Let's walk through what everything means.",
    popupAnchor: 'center',
  },
  {
    title: 'Stats Panel',
    body: 'The left column lists your core attributes: Strength, Perception, Intelligence, etc. These fundamental numbers govern how your character performs at nearly everything.',
    highlight: { top: 0, left: 0, width: 40, height: 100 },
    popupAnchor: 'right',
  },
  {
    title: 'The (current / base) Display',
    body: 'Each entry shows two numbers. The left is your effective value after all modifiers. Green = buffed above base. Red = debuffed below base. White = unmodified.',
    highlight: { top: 8, left: 24, width: 16, height: 84 },
    popupAnchor: 'right',
  },
  {
    title: 'Skills Panel',
    body: 'The right column lists skills grouped by category: Firearms, Medicine, Persuasion, etc. These are specific trained abilities separate from your raw stats.',
    highlight: { top: 0, left: 40, width: 60, height: 100 },
    popupAnchor: 'left',
  },
  {
    title: '"All Skills" Toggle',
    body: 'By default, only trained skills are shown. Tick "All Skills" to also reveal untrained ones so you can see everything available to improve.',
    highlight: { top: 0, left: 62, width: 38, height: 14 },
    popupAnchor: 'bottom',
  },
  {
    title: 'Search Bar',
    body: 'Type here to filter skills by name in real-time. Searching automatically reveals untrained skills so nothing is hidden.',
    highlight: { top: 12, left: 40, width: 60, height: 13 },
    popupAnchor: 'bottom',
  },
  {
    title: 'Inspecting a Stat or Skill',
    body: 'Click any stat or skill name to open a detailed view; showing the full description, difficulty rating, governing attribute, what it defaults to, and any active modifiers. Click the ribbon to go back.',
    highlight: { top: 8, left: 0, width: 40, height: 84 },
    popupAnchor: 'right',
  },
  {
    title: 'Skill Tiers',
    body: 'Unlike the old system where you only saw a tier name, you now see the raw numbers behind them. For reference: Novice was 10–19, Apprentice 20–29, Journeyman 30–39, Expert 40–49, Master 50–59, and Legendary was 60 and above.',
    popupAnchor: 'center',
  },
  {
    title: "That's everything!",
    body: "You're all set. Use the stats panel to understand your core attributes, and the skills panel to track your expertise. Click any entry at any time to inspect it in detail.",
    popupAnchor: 'center',
  },
];

const CloserInspection = (props: { data: AttributeData; act: any }) => {
  const { data, act } = props;
  const attribute = data.closely_inspected_attribute;
  if (!attribute) return null;

  const hasDefaults = !!attribute.defaults?.length;
  const hasModifiers = !!attribute.modifiers?.length;

  let mainHeight = '85%';
  if (hasDefaults && hasModifiers) mainHeight = '42%';
  else if (hasDefaults || hasModifiers) mainHeight = '52.5%';
  const secondaryHeight = hasDefaults && hasModifiers ? '24%' : '32.5%';

  return (
    <Stack width="100%" height="100%" vertical>
      <Stack.Item mb={0} height={mainHeight}>
        <Box width="100%" className="PreferencesMenu__papersplease__header__left">
          <Box textAlign="center" className="PreferencesMenu__papersplease__header__title" style={{ fontSize: '200%' }}>
            <Box>
              {attribute.name}
              {attribute.shorthand && <span style={{ fontSize: '70%' }}> ({attribute.shorthand})</span>}
            </Box>
            <Tooltip content="Stop inspecting" position="top">
              <Box className="PreferencesMenu__ribbon" onClick={() => act('inspect_closely')} />
            </Tooltip>
          </Box>
        </Box>
        <Box
          overflowY="hidden" width="100%" height="100%"
          className={hasDefaults || hasModifiers
            ? 'PreferencesMenu__papersplease__leftbottomless'
            : 'PreferencesMenu__papersplease__left'}
          style={{ paddingTop: '8px', paddingBottom: '8px' }}>
          <Stack>
            <Stack.Item>
              <Box height="128px" width="128px" className={`attributes_big128x128 ${attribute.icon}`} />
            </Stack.Item>
            <Stack.Item overflowX="hidden" overflowY="hidden" width="85%" height="128px">
              <Box overflowX="hidden" overflowY="hidden" height="100%" width="100%"
                className="PreferencesMenu__papersplease__dotted">
                {attribute.desc}
                <Box mt={1.5} style={{ fontSize: '120%' }}>
                  {attribute.difficulty && <Box><b>Difficulty: </b>{attribute.difficulty}</Box>}
                  {attribute.governing_attribute && <Box><b>Governing attribute: </b>{attribute.governing_attribute}</Box>}
                </Box>
              </Box>
            </Stack.Item>
          </Stack>
        </Box>
      </Stack.Item>

      {hasDefaults && (
        <>
          <Stack.Item mt={0} mb={0}>
            <Box height={1} className="PreferencesMenu__papersplease__gutterhorizontal" />
          </Stack.Item>
          <Stack.Item mt={0} height={secondaryHeight}>
            <Box width="100%" className="PreferencesMenu__papersplease__header__leftnoradius">
              <Box textAlign="center" className="PreferencesMenu__papersplease__header__title" style={{ fontSize: '175%' }}>
                Defaults to:
              </Box>
            </Box>
            <Box overflowX="hidden" overflowY="scroll" height="100%"
              className={hasModifiers ? 'PreferencesMenu__papersplease__leftbottomless' : 'PreferencesMenu__papersplease__left'}
              style={{ paddingLeft: '4px', paddingRight: '4px', paddingTop: '10px', paddingBottom: '8px' }}>
              {attribute.defaults?.map((def) => (
                <Stack.Item ml={1} mb={2} key={def.name} style={{ fontSize: '165%' }}
                  onClick={() => act('inspect_closely', { attribute_name: def.name })}>
                  <Tooltip position="bottom"
                    content={<Box>{def.desc}{def.difficulty && <Box mt={0.5}>[{def.difficulty}]</Box>}</Box>}>
                    <Stack>
                      <Stack.Item>
                        <Box>
                          <Box mr={1} className={`attributes_small16x16 ${def.icon}`} />
                          {def.name}
                          {def.shorthand && <span style={{ fontSize: '65%' }}> ({def.shorthand})</span>}
                        </Box>
                      </Stack.Item>
                      <Stack.Item ml={1}>
                        <Box textAlign="right">{def.default_value}</Box>
                      </Stack.Item>
                    </Stack>
                  </Tooltip>
                </Stack.Item>
              ))}
            </Box>
          </Stack.Item>
        </>
      )}

      {hasModifiers && (
        <>
          <Stack.Item mt={0} mb={0}>
            <Box height={1} className="PreferencesMenu__papersplease__gutterhorizontal" />
          </Stack.Item>
          <Stack.Item mt={0} height={secondaryHeight}>
            <Box width="100%" className="PreferencesMenu__papersplease__header__leftnoradius">
              <Box textAlign="center" className="PreferencesMenu__papersplease__header__title" style={{ fontSize: '175%' }}>
                Active Modifiers
              </Box>
            </Box>
            <Box overflowX="hidden" overflowY="scroll" height="100%"
              className="PreferencesMenu__papersplease__left"
              style={{ paddingLeft: '4px', paddingRight: '4px', paddingTop: '10px', paddingBottom: '8px' }}>
              {attribute.modifiers?.map((mod) => (
                <Stack.Item ml={1} mb={2} key={mod.id} style={{ fontSize: '165%' }}>
                  <Stack>
                    <Stack.Item grow>{mod.id}</Stack.Item>
                    <Stack.Item mr={2}>
                      <Box textAlign="right" style={{ color: mod.value >= 0 ? PP.green : PP.red }}>
                        {mod.value >= 0 ? `+${mod.value}` : mod.value}
                      </Box>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              ))}
            </Box>
          </Stack.Item>
        </>
      )}
    </Stack>
  );
};

const AttributeStack = (props: { data: AttributeData; act: any }) => {
  const { data, act } = props;
  const { show_bad_skills, skills_by_category = [], stats = [] } = data;
  const [search, setSearch] = useLocalState('skill_search', '');
  const [showTutorial, setShowTutorial] = useLocalState('show_attribute_tutorial', false);

  const isSearching = search.trim().length > 0;

  const handleSearch = (val: string) => {
    const wasSearching = search.trim().length > 0;
    const nowSearching = val.trim().length > 0;
    setSearch(val);
    if (nowSearching && !wasSearching && !show_bad_skills) act('enable_bad_skills');
    else if (!nowSearching && wasSearching && !show_bad_skills) act('disable_bad_skills');
  };

  const visibleCategories = skills_by_category
    .map((cat) => ({
      ...cat,
      skills: cat.skills.filter(
        (skill) => !isSearching || skill.name.toLowerCase().includes(search.toLowerCase())
      ),
    }))
    .filter((cat) => cat.skills.length > 0);

  return (
    <Box style={{ width: '100%', height: '100%' }}>
      {showTutorial && (
        <TutorialOverlay
          steps={TUTORIAL_STEPS}
          stateKey="attribute_menu_tutorial"
          onClose={() => setShowTutorial(false)}
        />
      )}

      <Stack width="100%" height="100%">
        <Stack.Item width="40%" height="100%">
          <Box width="100%" className="PreferencesMenu__papersplease__header__left">
            <Stack align="center" width="100%" className="PreferencesMenu__papersplease__header__title">
              <Stack.Item grow textAlign="center" style={{ fontSize: '275%', paddingLeft: '28px' }}>
                Stats
              </Stack.Item>
              <Stack.Item mr={1}>
                <Tooltip content="Show tutorial" position="bottom">
                  <Box
                    onClick={() => setShowTutorial(true)}
                    style={{
                      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                      width: '20px', height: '20px', borderRadius: '50%',
                      border: `1px solid ${PP.border}`, color: PP.textMuted,
                      fontSize: '120%', fontWeight: 'bold', cursor: 'pointer',
                      userSelect: 'none', lineHeight: 1, background: 'rgba(90,76,76,0.2)',
                    }}>
                    ?
                  </Box>
                </Tooltip>
              </Stack.Item>
            </Stack>
          </Box>
          <Box width="100%" overflowY="scroll" className="PreferencesMenu__papersplease__left"
            style={{ paddingLeft: '4px', paddingRight: '4px', paddingTop: '8px', paddingBottom: '8px', fontSize: '150%' }}>
            <Stack vertical>
              {!stats.length && <Box>No stats!</Box>}
              {stats.map((stat) => (
                <Stack.Item mb={2} width="100%" key={stat.name}
                  onClick={() => act('inspect_closely', { attribute_name: stat.name })}>
                  <Tooltip position="bottom" content={<Box>{stat.desc}</Box>}>
                    <Stack>
                      <Stack.Item width="85%">
                        <Box width="100%">
                          <Box mr={1} className={`attributes_small16x16 ${stat.icon}`} />
                          {stat.name}
                          {stat.shorthand && <span style={{ fontSize: '65%' }}> ({stat.shorthand})</span>}
                        </Box>
                      </Stack.Item>
                      <Stack.Item>
                        <Box textAlign="right">
                          (<span style={{
                            color: (stat.value ?? 0) < (stat.raw_value ?? 0) ? PP.red
                              : (stat.value ?? 0) > (stat.raw_value ?? 0) ? PP.green : '',
                          }}>
                            {stat.value}
                          </span>/{stat.raw_value})
                        </Box>
                      </Stack.Item>
                    </Stack>
                  </Tooltip>
                </Stack.Item>
              ))}
            </Stack>
          </Box>
        </Stack.Item>

        <Stack.Item width="60%" height="100%">
          <Box width="100%" className="PreferencesMenu__papersplease__header__left">
            <Stack align="center" width="100%" className="PreferencesMenu__papersplease__header__title">
              <Stack.Item grow textAlign="center" style={{ fontSize: '275%' }}>
                Skills
              </Stack.Item>
              <Stack.Item mr={1}>
                <Tooltip content={show_bad_skills ? 'Hide untrained skills' : 'Show untrained skills'} position="bottom">
                  <Button.Checkbox
                    checked={show_bad_skills || isSearching}
                    onClick={() => act(show_bad_skills ? 'disable_bad_skills' : 'enable_bad_skills')}
                    style={{ fontSize: '120%' }}>
                    All skills
                  </Button.Checkbox>
                </Tooltip>
              </Stack.Item>
            </Stack>
            <Box px={1} pb={1}>
              <Input fluid placeholder="Search skills..." value={search}
                onInput={(e) => handleSearch(e.target.value)} />
            </Box>
          </Box>
          <Box width="100%" height="85.5%" className="PreferencesMenu__papersplease__left"
            style={{ paddingLeft: '4px', paddingRight: '4px', paddingBottom: '4px', fontSize: '150%' }}>
            <Stack width="100%" height="100%" overflowX="hidden" overflowY="scroll" vertical>
              {!visibleCategories.length && <Box>No skills!</Box>}
              {visibleCategories.map((category) => (
                <Stack vertical key={category.name}>
                  <Stack.Item>
                    <Box mt={2} style={{
                      fontSize: '140%', fontWeight: 'bold',
                      borderTop: '4px dotted rgba(90,76,76,0.7)',
                      borderBottom: '4px dotted rgba(90,76,76,0.7)',
                    }}>
                      {category.name}
                    </Box>
                  </Stack.Item>
                  {category.skills.map((skill) => (
                    <Stack.Item ml={1} mb={2} width="100%" key={skill.name}
                      onClick={() => act('inspect_closely', { attribute_name: skill.name })}>
                      <Tooltip position="bottom"
                        content={<Box>{skill.desc}{skill.difficulty && <Box mt={0.5}>[{skill.difficulty}]</Box>}</Box>}>
                        <Stack>
                          <Stack.Item width="85%">
                            <Box width="100%">
                              <Box mr={1} className={`attributes_small16x16 ${skill.icon}`} />
                              {skill.name}
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Box textAlign="right" mr={2}>
                              {skill.value !== null && skill.raw_value !== null ? (
                                <>(<span style={{
                                  color: skill.value < skill.raw_value ? PP.red
                                    : skill.value > skill.raw_value ? PP.green : '',
                                }}>{skill.value}</span>/{skill.raw_value})</>
                              ) : (
                                <>
                                  {typeof skill.value === 'number' && (
                                    <>(<span style={{ color: PP.green }}>{skill.value}</span>/{skill.raw_value})</>
                                  )}
                                  {typeof skill.raw_value === 'number' && !skill.value && (
                                    <>(<span style={{ color: PP.red }}>{skill.value}</span>/{skill.raw_value})</>
                                  )}
                                </>
                              )}
                            </Box>
                          </Stack.Item>
                        </Stack>
                      </Tooltip>
                    </Stack.Item>
                  ))}
                </Stack>
              ))}
            </Stack>
          </Box>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

export const AttributeMenu = (props, context) => {
  const { act, data } = useBackend<AttributeData>(context);
  const { parent, closely_inspected_attribute } = data;

  return (
    <Window
      title={parent ? `${parent} Attributes` : 'Attributes'}
      width={800}
      height={450}>
      <Window.Content>
        <Box style={{ position: 'relative', width: '100%', height: '418px' }}>
          {closely_inspected_attribute?.name
            ? <CloserInspection data={data} act={act} />
            : <AttributeStack data={data} act={act} />}
        </Box>
      </Window.Content>
    </Window>
  );
};
