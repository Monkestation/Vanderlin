import { memo, useCallback, useMemo, type CSSProperties } from 'react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Input, Stack, Tooltip } from 'tgui-core/components';
import { Window } from '../layouts';
import { resolveAsset } from '../assets';

const LEDGER_FIGURE_ASSET = 'attribute_ledger_figure.png';

const SEAL_SPRITESHEET_CLASS = 'attribute_seals104x104';
const SEAL_STATES = new Set([
  'strength',
  'constitution',
  'endurance',
  'speed',
  'intellect',
  'fortune',
  'perception',
]);

type TutorialAnchor = 'right' | 'left' | 'bottom' | 'top' | 'center';

interface TutorialHighlight {
  top: number;
  left: number;
  width: number;
  height: number;
}

interface TutorialStep {
  title: string;
  body: string;
  highlight?: TutorialHighlight;
  popupAnchor?: TutorialAnchor;
}

const TUTORIAL_STEPS: TutorialStep[] = [
  {
    title: 'Welcome to the Character Ledger',
    body: "This ledger lays out your character's seals and the guild's register. Let me walk you through what each page holds.",
    popupAnchor: 'center',
  },
  {
    title: 'Character Seals',
    body: 'The left page bears seven Core Attribute seals arranged around the figure: Strength, Perception, Intellect, Speed, Constitution, Endurance, and Fortune. These foundations govern almost everything you do.',
    highlight: { top: 1, left: 0.5, width: 33, height: 98 },
    popupAnchor: 'right',
  },
  {
    title: 'Current / Base reading',
    body: 'Each seal shows two numbers: current / base. Green means a blessing lifts you above your base. Red means a curse drags you below. Pale ink means it is unmodified.',
    highlight: { top: 13, left: 13.5, width: 8, height: 12 },
    popupAnchor: 'right',
  },
  {
    title: 'Guild Register',
    body: 'The middle page is the Skills Book — your trained crafts, grouped by guild. The current / base numbers behave just like the seals.',
    highlight: { top: 1, left: 34, width: 38, height: 98 },
    popupAnchor: 'left',
  },
  {
    title: 'All Skills toggle',
    body: 'By default only trained skills are shown. Tick All Skills to also reveal untrained ones, so you can see what is left to learn.',
    highlight: { top: 1, left: 59, width: 12, height: 7 },
    popupAnchor: 'bottom',
  },
  {
    title: 'Search the Register',
    body: 'Type a skill name here to filter the register in real time. Searching automatically reveals untrained skills so nothing stays hidden.',
    highlight: { top: 10, left: 34, width: 38, height: 6 },
    popupAnchor: 'bottom',
  },
  {
    title: 'Marginal Notes',
    body: 'Click any seal or guild entry and the scribe will note the details here: description, difficulty, governing attribute, defaults, and any active blessings or curses. Press the x to close the note.',
    highlight: { top: 1, left: 72, width: 27.5, height: 98 },
    popupAnchor: 'left',
  },
  {
    title: 'Skill Tiers',
    body: 'Numbers replace the old tier names: Novice was 10–19, Apprentice 20–29, Journeyman 30–39, Expert 40–49, Master 50–59, Legendary 60 and above.',
    popupAnchor: 'center',
  },
  {
    title: 'That is the ledger.',
    body: 'Open the seals to inspect your stats, browse the register for your skills, and read the marginal notes whenever you want details. Press the ? at any time to revisit this walkthrough.',
    popupAnchor: 'center',
  },
];

const TUTORIAL_CARD_WIDTH = 270;
const TUTORIAL_CARD_GAP = 12;

const tutorialCardStyle = (
  anchor: TutorialAnchor,
  hl: TutorialHighlight | undefined,
): CSSProperties => {
  if (!hl || anchor === 'center') {
    return {
      top: '50%',
      left: '50%',
      transform: 'translate(-50%, -50%)',
    };
  }
  switch (anchor) {
    case 'right':
      return {
        top: `${hl.top + hl.height / 2}%`,
        left: `calc(${hl.left + hl.width}% + ${TUTORIAL_CARD_GAP}px)`,
        transform: 'translateY(-50%)',
      };
    case 'left':
      return {
        top: `${hl.top + hl.height / 2}%`,
        left: `calc(${hl.left}% - ${TUTORIAL_CARD_WIDTH + TUTORIAL_CARD_GAP}px)`,
        transform: 'translateY(-50%)',
      };
    case 'bottom':
      return {
        top: `calc(${hl.top + hl.height}% + ${TUTORIAL_CARD_GAP}px)`,
        left: `${hl.left + hl.width / 2}%`,
        transform: 'translateX(-50%)',
      };
    case 'top':
      return {
        top: `calc(${hl.top}% - ${TUTORIAL_CARD_GAP}px)`,
        left: `${hl.left + hl.width / 2}%`,
        transform: 'translate(-50%, -100%)',
      };
  }
};

const AttributeTutorial = (props: { onClose: () => void }) => {
  const { onClose } = props;
  const [step, setStep] = useLocalState<number>('attribute_menu_tutorial_step', 0);

  const safe = Math.min(Math.max(step, 0), TUTORIAL_STEPS.length - 1);
  const current = TUTORIAL_STEPS[safe];
  const isFirst = safe === 0;
  const isLast = safe === TUTORIAL_STEPS.length - 1;
  const anchor = current.popupAnchor ?? 'center';
  const hl = current.highlight;

  const close = () => {
    setStep(0);
    onClose();
  };

  return (
    <div className="AttributeMenu__tutorialOverlay">
      <div className="AttributeMenu__tutorialBackdrop" onClick={close} />
      {hl && (
        <div
          className="AttributeMenu__tutorialHighlight"
          style={{
            top: `${hl.top}%`,
            left: `${hl.left}%`,
            width: `${hl.width}%`,
            height: `${hl.height}%`,
          }}
        />
      )}
      <div
        className="AttributeMenu__tutorialCard"
        style={{ width: `${TUTORIAL_CARD_WIDTH}px`, ...tutorialCardStyle(anchor, hl) }}
      >
        {hl && anchor !== 'center' && (
          <div className={`AttributeMenu__tutorialCaret AttributeMenu__tutorialCaret--${anchor}`} />
        )}
        <div className="AttributeMenu__tutorialHeader">
          <div className="AttributeMenu__tutorialEyebrow">
            Step {safe + 1} of {TUTORIAL_STEPS.length}
          </div>
          <div className="AttributeMenu__tutorialTitle">{current.title}</div>
          <button
            type="button"
            className="AttributeMenu__tutorialClose"
            onClick={close}
            aria-label="Close walkthrough"
          >
            ✕
          </button>
        </div>
        <div className="AttributeMenu__tutorialBody">{current.body}</div>
        <div className="AttributeMenu__tutorialDots">
          {TUTORIAL_STEPS.map((_, i) => (
            <button
              key={i}
              type="button"
              className={`AttributeMenu__tutorialDot${i === safe ? ' is-active' : ''}`}
              onClick={() => setStep(i)}
              aria-label={`Go to step ${i + 1}`}
            />
          ))}
        </div>
        <div className="AttributeMenu__tutorialFooter">
          {isFirst ? (
            <span style={{ minWidth: '70px', display: 'inline-block' }} />
          ) : (
            <button
              type="button"
              className="AttributeMenu__tutorialNav"
              onClick={() => setStep(safe - 1)}
            >
              ← Back
            </button>
          )}
          <button
            type="button"
            className={`AttributeMenu__tutorialNav${isLast ? ' AttributeMenu__tutorialNav--done' : ''}`}
            onClick={isLast ? close : () => setStep(safe + 1)}
          >
            {isLast ? '✓ Done' : 'Next →'}
          </button>
        </div>
      </div>
    </div>
  );
};

type AttributeValue = number | string | null;

interface AttributeModifier {
  id: string;
  value: number;
}

interface AttributeValues {
  value: AttributeValue;
  raw_value: AttributeValue;
}

interface StatMeta {
  name: string;
  desc?: string;
  icon?: string;
  shorthand?: string;
  anchor: string;
  seal_label: string;
}

interface SkillMeta {
  name: string;
  desc?: string;
  icon?: string;
  difficulty?: string;
}

interface SkillCategoryMeta {
  name: string;
  skills: SkillMeta[];
}

interface DefaultMeta {
  name: string;
  desc?: string;
  icon?: string;
  default_value: number;
}

interface AttributeFullMeta {
  name: string;
  desc?: string;
  icon?: string;
  shorthand?: string;
  difficulty?: string;
  governing_attribute?: string;
  defaults?: DefaultMeta[];
  kind: 'stat' | 'skill';
}

interface CloselyInspectedDynamic {
  name: string;
  value: AttributeValue;
  raw_value: AttributeValue;
  desc_from_level?: string;
  modifiers: AttributeModifier[];
}

interface ResolvedStat extends StatMeta, AttributeValues {}

interface ResolvedSkill extends SkillMeta, AttributeValues {}

interface ResolvedSkillCategory {
  name: string;
  skills: ResolvedSkill[];
}

interface ResolvedInspectedAttribute extends Partial<AttributeFullMeta> {
  name: string;
  value: AttributeValue;
  raw_value: AttributeValue;
  desc_from_level?: string;
  modifiers: AttributeModifier[];
}

interface AttributeData {
  stats_meta?: StatMeta[];
  skills_by_category_meta?: SkillCategoryMeta[];
  attribute_meta_by_name?: Record<string, AttributeFullMeta>;

  show_bad_skills: boolean;
  parent?: string;
  stats_values?: Record<string, AttributeValues>;
  skills_values?: Record<string, AttributeValues>;
  closely_inspected?: CloselyInspectedDynamic | null;
}

const EMPTY_VALUES: AttributeValues = { value: null, raw_value: null };

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

const valuePair = (value: AttributeValue, raw: AttributeValue) => {
  const v = displayValue(value);
  const r = displayValue(raw);
  if (v === 'NA' && r === 'NA') {
    return 'NA';
  }
  return `${v}/${r}`;
};

const sameSelection = (
  first: string | null | undefined,
  second: string | null | undefined,
  attributeName: string,
) => (first === attributeName) === (second === attributeName);

const IconSprite = memo((props: { icon?: string; size: 'small' | 'big' }) => {
  const { icon, size } = props;

  if (!icon) {
    return <span className={`AttributeMenu__iconFallback AttributeMenu__iconFallback--${size}`} />;
  }

  return (
    <span className={`AttributeMenu__sprite AttributeMenu__sprite--${size}`}>
      <span className={`attributes_${size === 'big' ? 'big128x128' : 'small16x16'} ${icon}`} />
    </span>
  );
});

const AnatomyFigure = memo(() => {
  const figureUrl = resolveAsset(LEDGER_FIGURE_ASSET);
  const hasFigure = figureUrl !== LEDGER_FIGURE_ASSET;

  return (
    <>
      <svg className="AttributeMenu__anatomy" viewBox="0 0 1000 1000" aria-hidden="true">
        <circle className="AttributeMenu__anatomyCircle AttributeMenu__anatomyCircle--outer" cx="500" cy="500" r="382" />
        {hasFigure && (
          <circle className="AttributeMenu__anatomyCircle AttributeMenu__anatomyCircle--track" cx="500" cy="500" r="366" />
        )}
        {!hasFigure && (
          <>
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
          </>
        )}
      </svg>
      {hasFigure && (
        <div
          className="AttributeMenu__figure"
          style={{ backgroundImage: `url('${figureUrl}')` }}
          aria-hidden="true"
        />
      )}
    </>
  );
});

const AttributeSealNode = memo((props: {
  stat: ResolvedStat;
  selected: boolean;
  act: any;
}) => {
  const { stat, selected, act } = props;
  const nodeClass = `AttributeMenu__sealNode AttributeMenu__sealNode--${stat.anchor}${
    selected ? ' is-selected' : ''
  }`;

  const hasMedallion = SEAL_STATES.has(stat.anchor);

  return (
    <Tooltip content={stat.desc || stat.name} position="bottom">
      <button
        className={nodeClass}
        onClick={() => act('inspect_closely', { attribute_name: stat.name })}
        type="button"
      >
        {hasMedallion ? (
          <span className="AttributeMenu__sealNodeMedallion">
            <span className={`${SEAL_SPRITESHEET_CLASS} ${stat.anchor}`} />
          </span>
        ) : (
          <span className="AttributeMenu__sealNodeOrb" />
        )}
        <span className="AttributeMenu__sealNodeName">{stat.seal_label}</span>
        <span className={`AttributeMenu__sealNodeValue ${valueTone(stat.value, stat.raw_value)}`}>
          {valuePair(stat.value, stat.raw_value)}
        </span>
      </button>
    </Tooltip>
  );
}, (previous, next) =>
  previous.selected === next.selected &&
  previous.stat.name === next.stat.name &&
  previous.stat.value === next.stat.value &&
  previous.stat.raw_value === next.stat.raw_value &&
  previous.stat.anchor === next.stat.anchor &&
  previous.stat.seal_label === next.stat.seal_label);

const CoreAttributes = memo((props: {
  stats: ResolvedStat[];
  selectedName?: string | null;
  act: any;
  onHelpClick: () => void;
}) => {
  const { stats, selectedName, act, onHelpClick } = props;

  return (
    <section className="AttributeMenu__panel AttributeMenu__panel--seals">
      <button
        type="button"
        className="AttributeMenu__helpButton"
        onClick={onHelpClick}
        title="How to read this ledger"
        aria-label="Open walkthrough"
      >
        ?
      </button>
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
            {stats.map((stat) => (
              <AttributeSealNode
                key={stat.name}
                stat={stat}
                selected={selectedName === stat.name}
                act={act}
              />
            ))}
          </div>
        )}
      </div>
    </section>
  );
});

const SkillEntry = memo((props: {
  skill: ResolvedSkill;
  selected: boolean;
  act: any;
}) => {
  const { skill, selected, act } = props;

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
          {valuePair(skill.value, skill.raw_value)}
        </span>
      </button>
    </Tooltip>
  );
}, (previous, next) =>
  previous.selected === next.selected &&
  previous.skill.name === next.skill.name &&
  previous.skill.value === next.skill.value &&
  previous.skill.raw_value === next.skill.raw_value &&
  previous.skill.icon === next.skill.icon &&
  previous.skill.difficulty === next.skill.difficulty &&
  previous.skill.desc === next.skill.desc);

const SkillRegister = memo((props: {
  categoriesMeta: SkillCategoryMeta[];
  skillsValues: Record<string, AttributeValues>;
  showBadSkills: boolean;
  selectedName?: string | null;
  act: any;
}) => {
  const { categoriesMeta, skillsValues, showBadSkills, selectedName, act } = props;
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

    if (nowSearching && !wasSearching && !showBadSkills) {
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
      if (showBadSkills) {
        setSearchForcedAllSkills(!searchForcedAllSkills);
      } else {
        setSearchForcedAllSkills(false);
        act('enable_bad_skills');
      }
      return;
    }

    setSearchForcedAllSkills(false);
    act(showBadSkills ? 'disable_bad_skills' : 'enable_bad_skills');
  };

  const visibleCategories = useMemo<ResolvedSkillCategory[]>(() => {
    const result: ResolvedSkillCategory[] = [];
    for (const category of categoriesMeta) {
      const categoryNameLower = category.name.toLowerCase();
      const matchedSkills: ResolvedSkill[] = [];
      for (const skill of category.skills) {
        const values = skillsValues[skill.name] || EMPTY_VALUES;
        if (!showBadSkills && values.value === null) {
          continue;
        }
        if (searchText) {
          const nameHit = skill.name.toLowerCase().includes(searchText);
          const descHit = (skill.desc || '').toLowerCase().includes(searchText);
          const catHit = categoryNameLower.includes(searchText);
          if (!nameHit && !descHit && !catHit) {
            continue;
          }
        }
        matchedSkills.push({ ...skill, ...values });
      }
      if (matchedSkills.length > 0) {
        result.push({ name: category.name, skills: matchedSkills });
      }
    }
    return result;
  }, [categoriesMeta, skillsValues, showBadSkills, searchText]);

  return (
    <section className="AttributeMenu__panel AttributeMenu__panel--register">
      <header className="AttributeMenu__panelHeader AttributeMenu__panelHeader--row">
        <div>
          <div className="AttributeMenu__eyebrow">Guild Register</div>
          <div className="AttributeMenu__title">Skills Book</div>
        </div>
        <Button.Checkbox
          checked={showBadSkills || isSearching}
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
                selected={selectedName === skill.name}
                act={act}
              />
            ))}
          </section>
        ))}
      </div>
    </section>
  );
});

const DetailLine = (props: { label: string; value?: string | number | null }) => {
  const { label, value } = props;

  return (
    <div className="AttributeMenu__detailLine">
      <span>{label}</span>
      <strong>{displayValue(value ?? null)}</strong>
    </div>
  );
};

const InspectionPanel = memo((props: {
  attribute: ResolvedInspectedAttribute | null;
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
            {valuePair(attribute.value, attribute.raw_value)}
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
});

export const AttributeMenu = () => {
  const { act, data } = useBackend<AttributeData>();
  const {
    parent,
    stats_meta,
    skills_by_category_meta,
    attribute_meta_by_name,
    stats_values,
    skills_values,
    show_bad_skills = false,
    closely_inspected,
  } = data;

  const statsMetaSafe = stats_meta || [];
  const skillsMetaSafe = skills_by_category_meta || [];
  const attributeMetaSafe = attribute_meta_by_name || {};
  const statsValuesSafe = stats_values || {};
  const skillsValuesSafe = skills_values || {};

  const stats = useMemo<ResolvedStat[]>(
    () =>
      statsMetaSafe.map((meta) => ({
        ...meta,
        ...(statsValuesSafe[meta.name] || EMPTY_VALUES),
      })),
    [statsMetaSafe, statsValuesSafe],
  );

  const inspectedAttribute = useMemo<ResolvedInspectedAttribute | null>(() => {
    if (!closely_inspected) {
      return null;
    }
    const meta = attributeMetaSafe[closely_inspected.name] || {};
    return {
      ...meta,
      ...closely_inspected,
    };
  }, [closely_inspected, attributeMetaSafe]);

  const selectedName = closely_inspected?.name ?? null;

  const [showTutorial, setShowTutorial] = useLocalState<boolean>(
    'attribute_menu_tutorial_open',
    false,
  );
  const openTutorial = useCallback(() => setShowTutorial(true), []);
  const closeTutorial = useCallback(() => setShowTutorial(false), []);

  return (
    <Window
      title={parent ? `${parent} Character Ledger` : 'Character Ledger'}
      width={1180}
      height={720}
    >
      <Window.Content fitted>
        <Box className="AttributeMenu">
          <div className="AttributeMenu__backdrop">
            <CoreAttributes
              stats={stats}
              selectedName={selectedName}
              act={act}
              onHelpClick={openTutorial}
            />
            <SkillRegister
              categoriesMeta={skillsMetaSafe}
              skillsValues={skillsValuesSafe}
              showBadSkills={show_bad_skills}
              selectedName={selectedName}
              act={act}
            />
            <InspectionPanel attribute={inspectedAttribute} act={act} />
          </div>
          {showTutorial && <AttributeTutorial onClose={closeTutorial} />}
        </Box>
      </Window.Content>
    </Window>
  );
};
