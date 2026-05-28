import { useBackend, useLocalState } from '../backend';
import { Box, Button, Input, Stack, Tooltip } from 'tgui-core/components';
import { Window } from '../layouts';

type AttributeValue = number | string | null;

interface AttributeModifier {
  id: string;
  value: number;
}

interface Attribute {
  name: string;
  shorthand?: string;
  desc?: string;
  icon?: string;
  value: AttributeValue;
  raw_value: AttributeValue;
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

const isNumeric = (value: AttributeValue): value is number =>
  typeof value === 'number' && Number.isFinite(value);

const valueTone = (value: AttributeValue, raw: AttributeValue) => {
  if (!isNumeric(value) || !isNumeric(raw)) {
    return 'is-muted';
  }
  if (value > raw) {
    return 'is-buffed';
  }
  if (value < raw) {
    return 'is-debuffed';
  }
  return 'is-even';
};

const displayValue = (value: AttributeValue | undefined) => {
  if (value === null || value === undefined || value === '') {
    return 'NA';
  }
  return String(value);
};

const valuePair = (attribute: Attribute) => {
  const value = displayValue(attribute.value);
  const raw = displayValue(attribute.raw_value);
  if (value === 'NA' && raw === 'NA') {
    return 'NA';
  }
  return `${value}/${raw}`;
};

const IconSprite = (props: { icon?: string; size: 'small' | 'big' }) => {
  const { icon, size } = props;

  if (!icon) {
    return <span className={`AttributeMenu__iconFallback AttributeMenu__iconFallback--${size}`} />;
  }

  return (
    <span className={`AttributeMenu__sprite AttributeMenu__sprite--${size}`}>
      <span className={`attributes_${size === 'big' ? 'big128x128' : 'small16x16'} ${icon}`} />
    </span>
  );
};

const AttributeSeal = (props: {
  attribute: Attribute;
  selectedName?: string | null;
  act: any;
}) => {
  const { attribute, selectedName, act } = props;
  const selected = selectedName === attribute.name;

  return (
    <Tooltip content={attribute.desc || attribute.name} position="right">
      <button
        className={`AttributeMenu__seal${selected ? ' is-selected' : ''}`}
        onClick={() => act('inspect_closely', { attribute_name: attribute.name })}
        type="button"
      >
        <span className="AttributeMenu__wax">
          <IconSprite icon={attribute.icon} size="small" />
        </span>
        <span className="AttributeMenu__sealText">
          <span className="AttributeMenu__sealName">
            {attribute.name}
            {attribute.shorthand && (
              <span className="AttributeMenu__sealShort"> ({attribute.shorthand})</span>
            )}
          </span>
          <span className="AttributeMenu__sealSub">Core attribute</span>
        </span>
        <span className={`AttributeMenu__value ${valueTone(attribute.value, attribute.raw_value)}`}>
          {valuePair(attribute)}
        </span>
      </button>
    </Tooltip>
  );
};

const CoreAttributes = (props: {
  stats: Attribute[];
  selectedName?: string | null;
  act: any;
}) => {
  const { stats, selectedName, act } = props;

  return (
    <section className="AttributeMenu__panel AttributeMenu__panel--seals">
      <header className="AttributeMenu__panelHeader">
        <div className="AttributeMenu__eyebrow">Character Seals</div>
        <div className="AttributeMenu__title">Core Attributes</div>
      </header>
      <div className="AttributeMenu__divider" />
      <div className="AttributeMenu__scroll AttributeMenu__sealList">
        {!stats.length && (
          <div className="AttributeMenu__empty">No attributes recorded.</div>
        )}
        {stats.map((stat) => (
          <AttributeSeal
            key={stat.name}
            attribute={stat}
            selectedName={selectedName}
            act={act}
          />
        ))}
      </div>
    </section>
  );
};

const SkillEntry = (props: {
  skill: Attribute;
  selectedName?: string | null;
  act: any;
}) => {
  const { skill, selectedName, act } = props;
  const selected = selectedName === skill.name;

  return (
    <Tooltip
      position="bottom"
      content={
        <Box>
          {skill.desc || skill.name}
          {skill.difficulty && <Box mt={0.5}>[{skill.difficulty}]</Box>}
        </Box>
      }
    >
      <button
        className={`AttributeMenu__skill${selected ? ' is-selected' : ''}`}
        onClick={() => act('inspect_closely', { attribute_name: skill.name })}
        type="button"
      >
        <span className="AttributeMenu__skillIcon">
          <IconSprite icon={skill.icon} size="small" />
        </span>
        <span className="AttributeMenu__skillName">{skill.name}</span>
        <span className={`AttributeMenu__value ${valueTone(skill.value, skill.raw_value)}`}>
          {valuePair(skill)}
        </span>
      </button>
    </Tooltip>
  );
};

const SkillRegister = (props: {
  data: AttributeData;
  selectedName?: string | null;
  act: any;
}) => {
  const { data, selectedName, act } = props;
  const { show_bad_skills, skills_by_category = [] } = data;
  const [search, setSearch] = useLocalState<string>('attribute_menu_search', '');
  const [searchForcedAllSkills, setSearchForcedAllSkills] = useLocalState<boolean>(
    'attribute_menu_search_forced_all_skills',
    false,
  );

  const searchText = search.trim().toLowerCase();
  const isSearching = searchText.length > 0;

  const handleSearch = (value: string) => {
    const wasSearching = search.trim().length > 0;
    const nowSearching = value.trim().length > 0;

    setSearch(value);

    if (nowSearching && !wasSearching && !show_bad_skills) {
      setSearchForcedAllSkills(true);
      act('enable_bad_skills');
    }

    if (!nowSearching && wasSearching && searchForcedAllSkills) {
      setSearchForcedAllSkills(false);
      act('disable_bad_skills');
    }
  };

  const toggleAllSkills = () => {
    if (isSearching) {
      if (show_bad_skills) {
        setSearchForcedAllSkills(!searchForcedAllSkills);
      } else {
        setSearchForcedAllSkills(false);
        act('enable_bad_skills');
      }
      return;
    }

    setSearchForcedAllSkills(false);
    act(show_bad_skills ? 'disable_bad_skills' : 'enable_bad_skills');
  };

  const visibleCategories = skills_by_category
    .map((category) => ({
      ...category,
      skills: category.skills.filter((skill) => {
        if (!searchText) {
          return true;
        }
        return (
          skill.name.toLowerCase().includes(searchText) ||
          (skill.desc || '').toLowerCase().includes(searchText) ||
          category.name.toLowerCase().includes(searchText)
        );
      }),
    }))
    .filter((category) => category.skills.length > 0);

  return (
    <section className="AttributeMenu__panel AttributeMenu__panel--register">
      <header className="AttributeMenu__panelHeader AttributeMenu__panelHeader--row">
        <div>
          <div className="AttributeMenu__eyebrow">Guild Register</div>
          <div className="AttributeMenu__title">Skills Book</div>
        </div>
        <Button.Checkbox
          checked={show_bad_skills || isSearching}
          onClick={toggleAllSkills}
          className="AttributeMenu__toggle"
        >
          All Skills
        </Button.Checkbox>
      </header>

      <div className="AttributeMenu__search">
        <Input
          fluid
          placeholder="Search the register..."
          value={search}
          onChange={(value: string) => handleSearch(value)}
        />
      </div>

      <div className="AttributeMenu__divider" />

      <div className="AttributeMenu__scroll AttributeMenu__skillList">
        {!visibleCategories.length && (
          <div className="AttributeMenu__empty">No matching entries.</div>
        )}
        {visibleCategories.map((category) => (
          <section className="AttributeMenu__category" key={category.name}>
            <div className="AttributeMenu__categoryTitle">{category.name}</div>
            {category.skills.map((skill) => (
              <SkillEntry
                key={skill.name}
                skill={skill}
                selectedName={selectedName}
                act={act}
              />
            ))}
          </section>
        ))}
      </div>
    </section>
  );
};

const DetailLine = (props: { label: string; value?: string | number | null }) => {
  const { label, value } = props;

  return (
    <div className="AttributeMenu__detailLine">
      <span>{label}</span>
      <strong>{displayValue(value ?? null)}</strong>
    </div>
  );
};

const InspectionPanel = (props: {
  attribute: Attribute | null;
  act: any;
}) => {
  const { attribute, act } = props;

  if (!attribute) {
    return (
      <section className="AttributeMenu__panel AttributeMenu__panel--notes">
        <header className="AttributeMenu__panelHeader">
          <div className="AttributeMenu__eyebrow">Marginal Notes</div>
          <div className="AttributeMenu__title">Inspection</div>
        </header>
        <div className="AttributeMenu__divider" />
        <div className="AttributeMenu__placeholder">
          <div className="AttributeMenu__placeholderMark">Uninspected</div>
          <p>Select a seal or guild entry to read the scribe's notes.</p>
          <p>Values, defaults, modifiers, and governing attributes will appear here.</p>
        </div>
      </section>
    );
  }

  return (
    <section className="AttributeMenu__panel AttributeMenu__panel--notes">
      <button
        className="AttributeMenu__closeNote"
        onClick={() => act('clear_inspection')}
        type="button"
      >
        x
      </button>

      <header className="AttributeMenu__panelHeader">
        <div className="AttributeMenu__eyebrow">Marginal Notes</div>
        <div className="AttributeMenu__title">
          {attribute.name}
          {attribute.shorthand && (
            <span className="AttributeMenu__titleShort"> ({attribute.shorthand})</span>
          )}
        </div>
      </header>

      <div className="AttributeMenu__divider" />

      <div className="AttributeMenu__noteScroll">
        <Stack className="AttributeMenu__inspectionIntro">
          <Stack.Item>
            <span className="AttributeMenu__largeIcon">
              <IconSprite icon={attribute.icon} size="big" />
            </span>
          </Stack.Item>
          <Stack.Item grow>
            <p className="AttributeMenu__description">
              {attribute.desc || 'No description has been written by the scribe.'}
            </p>
          </Stack.Item>
        </Stack>

        <div className="AttributeMenu__valueCard">
          <span>Current / Base</span>
          <strong className={valueTone(attribute.value, attribute.raw_value)}>
            {valuePair(attribute)}
          </strong>
        </div>

        <div className="AttributeMenu__detailGrid">
          <DetailLine label="Difficulty" value={attribute.difficulty || 'NA'} />
          <DetailLine label="Governing" value={attribute.governing_attribute || 'NA'} />
        </div>

        {!!attribute.defaults?.length && (
          <section className="AttributeMenu__noteBlock">
            <h3>Defaults To</h3>
            {attribute.defaults.map((def) => (
              <button
                className="AttributeMenu__defaultRow"
                key={def.name}
                onClick={() => act('inspect_closely', { attribute_name: def.name })}
                type="button"
              >
                <IconSprite icon={def.icon} size="small" />
                <span>{def.name}</span>
                <strong>{displayValue(def.default_value ?? null)}</strong>
              </button>
            ))}
          </section>
        )}

        {!!attribute.modifiers?.length && (
          <section className="AttributeMenu__noteBlock">
            <h3>Blessings And Curses</h3>
            {attribute.modifiers.map((mod) => (
              <div className="AttributeMenu__modifierRow" key={mod.id}>
                <span>{mod.id || 'Unnamed modifier'}</span>
                <strong className={mod.value >= 0 ? 'is-buffed' : 'is-debuffed'}>
                  {mod.value >= 0 ? `+${mod.value}` : mod.value}
                </strong>
              </div>
            ))}
          </section>
        )}
      </div>
    </section>
  );
};

export const AttributeMenu = () => {
  const { act, data } = useBackend<AttributeData>();
  const {
    parent,
    stats = [],
    skills_by_category = [],
    closely_inspected_attribute,
  } = data;
  const selectedName = closely_inspected_attribute?.name || null;

  return (
    <Window
      title={parent ? `${parent} Character Ledger` : 'Character Ledger'}
      width={980}
      height={560}
    >
      <Window.Content>
        <Box className="AttributeMenu">
          <div className="AttributeMenu__backdrop">
            <CoreAttributes stats={stats} selectedName={selectedName} act={act} />
            <SkillRegister
              data={{
                ...data,
                skills_by_category,
              }}
              selectedName={selectedName}
              act={act}
            />
            <InspectionPanel attribute={closely_inspected_attribute} act={act} />
          </div>
        </Box>
      </Window.Content>
    </Window>
  );
};
