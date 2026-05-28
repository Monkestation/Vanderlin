import { memo } from 'react';
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

const sameAttributePreview = (first: Attribute, second: Attribute) =>
  first.name === second.name &&
  first.shorthand === second.shorthand &&
  first.desc === second.desc &&
  first.icon === second.icon &&
  first.value === second.value &&
  first.raw_value === second.raw_value &&
  first.difficulty === second.difficulty;

const sameSelection = (
  first: string | null | undefined,
  second: string | null | undefined,
  attributeName: string,
) => (first === attributeName) === (second === attributeName);

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

const attributeAnchor = (attribute: Attribute, index: number) => {
  const name = attribute.name.toLowerCase();

  if (name.includes('strength')) {
    return 'strength';
  }
  if (name.includes('perception')) {
    return 'perception';
  }
  if (name.includes('intellect') || name.includes('intelligence')) {
    return 'intellect';
  }
  if (name.includes('speed') || name.includes('agility')) {
    return 'speed';
  }
  if (name.includes('constitution')) {
    return 'constitution';
  }
  if (name.includes('endurance')) {
    return 'endurance';
  }
  if (name.includes('fortune') || name.includes('luck')) {
    return 'fortune';
  }

  return `fallback${index % 7}`;
};

const AnatomyFigure = () => (
  <svg className="AttributeMenu__anatomy" viewBox="0 0 1000 1000" aria-hidden="true">
    <circle className="AttributeMenu__anatomyCircle AttributeMenu__anatomyCircle--outer" cx="500" cy="500" r="360" />
    <circle className="AttributeMenu__anatomyCircle AttributeMenu__anatomyCircle--middle" cx="500" cy="500" r="250" />
    <circle className="AttributeMenu__anatomyCircle AttributeMenu__anatomyCircle--inner" cx="500" cy="500" r="118" />
    <path
      className="AttributeMenu__anatomyGeometry"
      d="M500 140 L500 860 M140 500 L860 500 M245 245 L755 245 L755 755 L245 755 Z M500 140 L755 755 L245 755 Z M245 245 L755 755 M755 245 L245 755"
    />
    <path
      className="AttributeMenu__anatomyArc"
      d="M178 612 C250 748 366 826 500 826 C634 826 750 748 822 612"
    />
    <path
      className="AttributeMenu__bodyFill"
      d="M468 334 C486 306 514 306 532 334 C552 406 547 526 522 676 L478 676 C453 526 448 406 468 334 Z"
    />
    <circle className="AttributeMenu__bodyHead" cx="500" cy="267" r="36" />
    <path
      className="AttributeMenu__bodyStroke"
      d="M500 304 L500 676 M463 356 L363 516 M537 356 L637 516 M363 516 L344 544 M637 516 L656 544 M480 676 L425 844 M520 676 L575 844 M425 844 L386 860 M575 844 L614 860"
    />
    <path
      className="AttributeMenu__bodyDetail"
      d="M468 334 C486 358 514 358 532 334 M456 440 C485 468 515 468 544 440 M478 676 C492 704 508 704 522 676 M500 334 C486 424 486 560 500 676 M500 334 C514 424 514 560 500 676"
    />
  </svg>
);

const AttributeSealNode = memo((props: {
  attribute: Attribute;
  selectedName?: string | null;
  act: any;
  index: number;
}) => {
  const { attribute, selectedName, act, index } = props;
  const selected = selectedName === attribute.name;
  const anchor = attributeAnchor(attribute, index);
  const nodeClass = `AttributeMenu__sealNode AttributeMenu__sealNode--${anchor}${
    selected ? ' is-selected' : ''
  }`;

  return (
    <Tooltip content={attribute.desc || attribute.name} position="bottom">
      <button
        className={nodeClass}
        onClick={() => act('inspect_closely', { attribute_name: attribute.name })}
        type="button"
      >
        <span className="AttributeMenu__sealNodeOrb">
          <IconSprite icon={attribute.icon} size="small" />
        </span>
        <span className="AttributeMenu__sealNodeName">
          {attribute.name}
          {attribute.shorthand && (
            <span className="AttributeMenu__sealNodeShort"> ({attribute.shorthand})</span>
          )}
        </span>
        <span className={`AttributeMenu__sealNodeValue ${valueTone(attribute.value, attribute.raw_value)}`}>
          {valuePair(attribute)}
        </span>
      </button>
    </Tooltip>
  );
}, (previous, next) =>
  previous.index === next.index &&
  sameSelection(previous.selectedName, next.selectedName, previous.attribute.name) &&
  sameAttributePreview(previous.attribute, next.attribute));

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
      <div className="AttributeMenu__constellation">
        {!stats.length && (
          <div className="AttributeMenu__empty">No attributes recorded.</div>
        )}
        {!!stats.length && (
          <div className="AttributeMenu__ringStage">
            <AnatomyFigure />
            {stats.map((stat, index) => (
              <AttributeSealNode
                key={stat.name}
                attribute={stat}
                selectedName={selectedName}
                act={act}
                index={index}
              />
            ))}
          </div>
        )}
      </div>
    </section>
  );
};

const SkillEntry = memo((props: {
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
}, (previous, next) =>
  sameSelection(previous.selectedName, next.selectedName, previous.skill.name) &&
  sameAttributePreview(previous.skill, next.skill));

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
      width={1180}
      height={720}
    >
      <Window.Content fitted>
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
