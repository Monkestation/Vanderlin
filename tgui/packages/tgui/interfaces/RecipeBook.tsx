import { useBackend } from '../backend';
import { useLocalState } from '../backend';
import { Box, Button, DmIcon, Icon, Input, Stack, Tooltip } from 'tgui-core/components';
import { Window } from '../layouts';

interface IconData {
  icon: string;
  icon_state: string;
}

interface ItemRef extends IconData {
  name: string;
  count?: number;
  any?: boolean;
  _path?: string;
}

interface ReagentRef {
  name: string;
  amount: number;
}

interface SurgeryStep {
  name: string;
  desc?: string;
  tools?: { name: string; chance: number }[];
  accept_hand?: boolean;
  accept_any?: boolean;
  self_operable?: boolean;
  lying_required?: boolean;
  repeating?: boolean;
  ignore_clothes?: boolean;
  skill_name?: string;
  skill_min?: string;
  skill_median?: string;
  chems?: string;
  organs?: string[];
  flags?: string[];
}

interface PotteryStep extends IconData {
  name: string;
  time_s: number;
}

interface SlapcraftStep extends IconData {
  name: string;
  desc: string;
  optional: boolean;
  verb: string;
  index: number;
  recipe_link?: string;
  _path?: string;
}

interface NodeEntry {
  name: string;
  likelihood: string;
}

interface AgeStage {
  name: string;
  time_s: number;
}

interface EssenceEntry {
  name: string;
  amount: number;
}

interface Recipe {
  type: string;
  name: string;
  category: string;
  // shared output fields
  output_name?: string;
  output_icon?: string;
  output_state?: string;
  output_count?: number;
  _output_path?: string;
  _extra_output_paths?: string[];
  yield_names?: string[];  // natural_precursor: essences this yields
  // repeatable
  requirements?: ItemRef[];
  tools?: ItemRef[];
  reagents?: ReagentRef[];
  skill_name?: string;
  skill_level?: string;
  skill_required?: boolean | string;
  starting_name?: string;
  starting_icon?: string;
  starting_state?: string;
  attacked_name?: string;
  attacked_icon?: string;
  attacked_state?: string;
  allow_inverse?: boolean;
  // orderless_slapcraft / slapcraft
  steps?: (SlapcraftStep | PotteryStep | SurgeryStep)[];
  finishing_name?: string;
  finishing_icon?: string;
  finishing_state?: string;
  // blueprint
  desc?: string;
  materials?: ItemRef[];
  tool_name?: string;
  tool_icon?: string;
  tool_state?: string;
  _tool_path?: string;
  skill_diff?: number;
  build_time?: number;
  supports_directions?: boolean;
  floor_object?: boolean;
  // container_craft
  craft_verb?: string;
  crafting_time?: number;
  wildcards?: { name: string; count: number }[];
  max_optionals?: number;
  opt_items?: ItemRef[];
  opt_wildcards?: { name: string; count: number }[];
  container_name?: string;
  container_icon?: string;
  container_state?: string;
  extra_html?: string;
  // molten
  temperature_c?: number;
  outputs?: { name: string; count: number }[];
  // anvil / artificer
  bar_name?: string;
  bar_icon?: string;
  bar_state?: string;
  base_name?: string;
  base_icon?: string;
  base_state?: string;
  extras?: ItemRef[];
  // brewing
  brew_time_s?: number;
  hints?: string;
  heat_c?: number;
  prereq_name?: string;
  ages?: boolean;
  crops?: ItemRef[];
  items?: ItemRef[];
  output_liquid?: string;
  output_volume?: number;
  output_item_name?: string;
  output_item_icon?: string;
  output_item_state?: string;
  output_item_count?: number;
  age_stages?: AgeStage[];
  // runeritual
  tier?: number;
  // book_entry
  html?: string;
  // alch_cauldron
  essences?: EssenceEntry[];
  output_reagents?: { name: string; amount: number }[];
  output_items?: ItemRef[];
  smells_like?: string;
  // essence_combination
  inputs?: EssenceEntry[];
  output_amount?: number;
  // essence_infusion
  target_name?: string;
  target_icon?: string;
  target_state?: string;
  result_name?: string;
  result_icon?: string;
  result_state?: string;
  infusion_time?: number;
  // natural_precursor
  yields?: EssenceEntry[];
  splits_from?: string[];
  splits_from_paths?: string[];
  search_data?: string;
  // plant_def
  maturation_min?: number;
  produce_min?: number;
  yield_min?: number;
  yield_max?: number;
  perennial?: boolean;
  water_drain?: number;
  weed_immune?: boolean;
  underground?: boolean;
  family?: string;
  nitrogen_req?: number;
  phosphorus_req?: number;
  potassium_req?: number;
  nitrogen_prod?: number;
  phosphorus_prod?: number;
  potassium_prod?: number;
  // surgery
  heretical?: boolean;
  req_bodypart?: boolean;
  req_missing_bodypart?: boolean;
  req_real_bodypart?: boolean;
  // wound
  severity_text?: string;
  severity_color?: string;
  critical?: boolean;
  mortal?: boolean;
  disabling?: boolean;
  whp?: number;
  can_sew?: boolean;
  can_cauterize?: boolean;
  sew_threshold?: number;
  sewn_whp?: number;
  bleed_rate?: number;
  sewn_bleed_rate?: number;
  clotting_rate?: number;
  clotting_threshold?: number;
  sewn_clotting_rate?: number;
  sewn_clotting_threshold?: number;
  passive_healing?: number;
  sleep_healing?: number;
  woundpain?: number;
  sewn_woundpain?: number;
  special_props?: string[];
  check_name?: string;
  // chimeric_node
  slot_name?: string;
  slot_color?: string;
  is_special?: boolean;
  allowed_slots?: string[];
  forbidden_slots?: string[];
  // chimeric_table
  node_tier?: number;
  purity_min?: number;
  purity_max?: number;
  base_blood_cost?: number;
  pref_bonus?: number;
  incompat_penalty?: number;
  preferred_blood?: string[];
  compatible_blood?: string[];
  incompatible_blood?: string[];
  input_nodes?: NodeEntry[];
  output_nodes?: NodeEntry[];
  special_nodes?: NodeEntry[];
  source_mobs?: { name: string; icon: string; icon_state: string; _path: string }[];
  // snack_processing
  mill_name?: string;
  mill_icon?: string;
  mill_state?: string;
  mill_path?: string;
  grind_results?: { name: string; amount: number }[];
  juice_results?: { name: string; amount: number }[];
  milled_from?: ItemRef[];
  sliced_from?: ItemRef[]
  slice_name?: string;
  slice_icon?: string;
  slice_state?: string;
  slice_path?: string;
  slice_num?: number;
  slice_skill?: string;
  // fish
  avg_size?: number;
  avg_weight?: number;
  fluid_type?: string;
  temp_min?: number;
  temp_max?: number;
  spots?: string;
  difficulty?: string;
  fav_bait?: string;
  dislike_bait?: string;
  lures?: string[];
  traits?: string[];
  // obtained_from
  sources?: { label: string; _path: string; name: string; icon: string; icon_state: string }[];
  // source_page
  drops?: { name: string; icon: string; icon_state: string; _path: string; source_label: string }[];
  // pottery
  speed_sweetspot?: string | number;
  // organ
  zone?: string;
  threshold_low?: number;
  threshold_high?: number;
  threshold_max?: number;
  msg_bruised?: string;
  msg_broken?: string;
  msg_bruised_healed?: string;
  msg_broken_healed?: string;
  msg_failing?: string;
  msg_fixed?: string;
  healing_factor?: number;
  healing_items?: ItemRef[];
  healing_tools?: string[];
  attaching_items?: ItemRef[];
  blood_req?: number;
  oxygen_req?: number;
  nutriment_req?: number;
  hydration_req?: number;
}

interface RecipeBookData {
  book_name: string;
  book_desc: string;
  recipes: Recipe[];
  linked_recipes: Recipe[];
}

const Sprite = (props: { icon?: string; icon_state?: string; size?: number }) => {
  const { icon, icon_state, size = 2 } = props;
  if (!icon || !icon_state) return null;
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

const RecipeLink = (props: {
  name: string | null | undefined;
  path?: string;
  lookup: Map<string, Recipe>;
  pickerMap: Map<string, Recipe[]>;
  allRecipes: Recipe[];
  essenceIndex?: Map<string, Recipe[]>;
  onNavigate: (r: Recipe) => void;
}) => {
  const { name, path, lookup, pickerMap, allRecipes, essenceIndex, onNavigate } = props;
  if (!name) return null;

  const pickerByPath = (path && pickerMap.get(path)) || [];
  const pickerByName = pickerMap.get(name.toLowerCase()) || [];
  const essenceByName = (!path && essenceIndex?.get(name.toLowerCase())) || [];
  const merged = [...new Set([...(pickerByPath.length ? pickerByPath : pickerByName), ...essenceByName])];
  if (merged.length > 1) {
    return <RecipePicker name={name} options={merged} onNavigate={onNavigate} />;
  }
  if (merged.length === 1 && !path && !lookup.get(name.toLowerCase())) {
    const sole = merged[0];
    return <span className="RecipeBook__hyperlink" onClick={() => onNavigate(sole)} title={`Go to: ${sole.name}`}>{name}</span>;
  }

  let target: Recipe | undefined = lookup.get(name.toLowerCase());

  if (!target && path) target = lookup.get(path);

  let subtypeMatches: Recipe[] = [];
  if (!target && path) {
    const prefix = path + '/';
    subtypeMatches = allRecipes.filter(
      (r) => r._output_path && r._output_path.startsWith(prefix)
        && !r._output_path.substring(prefix.length).includes('/')
    );
    if (subtypeMatches.length === 1) target = subtypeMatches[0];
  }

  let essenceMatches: Recipe[] = [];
  if (!target && subtypeMatches.length === 0 && essenceIndex && !path) {
    essenceMatches = essenceIndex.get(name.toLowerCase()) || [];
    if (essenceMatches.length === 1) target = essenceMatches[0];
  }

  const pickerOptions = subtypeMatches.length > 1 ? subtypeMatches
    : essenceMatches.length > 1 ? essenceMatches
    : [];

  if (!target && pickerOptions.length === 0) return <span>{name}</span>;
  if (!target && pickerOptions.length > 1) {
    return <RecipePicker name={name} options={pickerOptions} onNavigate={onNavigate} />;
  }

  return (
    <span className="RecipeBook__hyperlink" onClick={() => onNavigate(target!)} title={`Go to: ${target!.name}`}>
      {name}
    </span>
  );
};

const recipeTypeLabel = (type: string): string => {
  const labels: Record<string, string> = {
    repeatable: 'Crafting', brewing: 'Brewing', blueprint: 'Blueprint',
    container_craft: 'Cooking', molten: 'Smelting', anvil: 'Smithing',
    artificer: 'Artificer', pottery: 'Pottery', runeritual: 'Ritual',
    book_entry: 'Lore', alch_cauldron: 'Alchemy', essence_combination: 'Essence',
    essence_infusion: 'Infusion', natural_precursor: 'Precursor',
    plant_def: 'Farming', surgery: 'Surgery', wound: 'Wound',
    chimeric_node: 'Chimeric', chimeric_table: 'Humor',
    fish: 'Fish', slapcraft: 'Crafting', orderless_slapcraft: 'Crafting',
    snack_processing: 'Processing',
    obtained_from: 'Source',
    source_page: 'Source', organ: 'Organ',
  };
  return labels[type] || type;
};

const RecipePicker = (props: {
  name: string;
  options: Recipe[];
  onNavigate: (r: Recipe) => void;
}) => {
  const { name, options, onNavigate } = props;
  const [open, setOpen] = useLocalState(`picker_${name}`, false);
  const [coords, setCoords] = useLocalState<{ top: number; left: number } | null>(`picker_coords_${name}`, null);

  const handleClick = (e: any) => {
    const rect = e.currentTarget.getBoundingClientRect();
    setCoords({ top: rect.bottom + 2, left: rect.left });
    setOpen(!open);
  };

  return (
    <span style={{ display: 'inline-block' }}>
      <span
        className="RecipeBook__hyperlink"
        onClick={handleClick}
        title="Multiple recipes — click to choose">
        {name} ▾
      </span>
      {open && coords && (
        <div
          className="RecipeBook__picker-dropdown"
          style={{ position: 'fixed', top: coords.top, left: coords.left, zIndex: 9999, background: 'var(--rb-surface)', border: '1px solid var(--rb-border)' }}>
          {options.map((r, i) => (
            <Box
              key={i}
              className="RecipeBook__picker-option"
              onClick={() => { setOpen(false); onNavigate(r); }}>
              <span>{r.output_name || r.name}</span>
              <span className="RecipeBook__picker-type">{recipeTypeLabel(r.type)}</span>
            </Box>
          ))}
        </div>
      )}
    </span>
  );
};

const ItemRow = (props: {
  item: ItemRef;
  lookup: Map<string, Recipe>;
  pickerMap: Map<string, Recipe[]>;
  allRecipes: Recipe[];
  essenceIndex: Map<string, Recipe[]>;
  onNavigate: (r: Recipe) => void;
}) => {
  const { item, lookup, pickerMap, allRecipes, essenceIndex, onNavigate } = props;
  return (
    <Box className="RecipeBook__item-row">
      <Sprite icon={item.icon} icon_state={item.icon_state} />
      {item.any ? 'any ' : ''}
      {item.count !== undefined && item.count !== 1 ? `${item.count}× ` : ''}
      <RecipeLink name={item.name} path={item._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={onNavigate} />
    </Box>
  );
};

const SectionHead = (props: { children: any }) => (
  <Box className="RecipeBook__section-head">{props.children}</Box>
);

const HR = () => <Box className="RecipeBook__hr" />;

const Badge = (props: { color?: string; children: any }) => (
  <Box as="span" className="RecipeBook__badge" style={{ borderColor: props.color || 'var(--rb-accent)' }}>
    {props.children}
  </Box>
);

const WarnFlag = (props: { color: string; children: any }) => (
  <Box className="RecipeBook__warn-flag" style={{ color: props.color }}>⚠ {props.children}</Box>
);

const OutputBanner = (props: {
  icon?: string;
  icon_state?: string;
  name: string;
  count?: number;
  lookup: Map<string, Recipe>;
  pickerMap: Map<string, Recipe[]>;
  allRecipes: Recipe[];
  essenceIndex: Map<string, Recipe[]>;
  onNavigate: (r: Recipe) => void;
}) => {
  const { icon, icon_state, name, count, lookup, pickerMap, allRecipes, essenceIndex, onNavigate } = props;
  return (
    <Box className="RecipeBook__output-banner">
      <span className="RecipeBook__output-label">Creates</span>
      <Box className="RecipeBook__output-body">
        <Sprite icon={icon} icon_state={icon_state} size={2} />
        {count !== undefined && count > 1 ? `${count}× ` : ''}
        <RecipeLink name={name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={onNavigate} />
      </Box>
    </Box>
  );
};

const DetailOrgan = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    {r.zone && <Box className="RecipeBook__hint">Located in: <strong>{r.zone}</strong></Box>}

    <SectionHead>Damage Thresholds</SectionHead>
    <Box className="RecipeBook__step-block">
      {r.threshold_low !== undefined && (
        <Box className="RecipeBook__step-row" style={{ color: '#f0ad4e' }}>
          Bruised: {r.threshold_low}
          {r.msg_bruised && <Box className="RecipeBook__step-note" dangerouslySetInnerHTML={{ __html: r.msg_bruised }} />}
        </Box>
      )}
      {r.threshold_high !== undefined && (
        <Box className="RecipeBook__step-row" style={{ color: '#d9534f' }}>
          Failing: {r.threshold_high}
          {r.msg_broken && <Box className="RecipeBook__step-note" dangerouslySetInnerHTML={{ __html: r.msg_broken }} />}
        </Box>
      )}
      {r.threshold_max !== undefined && (
        <Box className="RecipeBook__step-row" style={{ color: '#880000' }}>
          Destroyed: {r.threshold_max}
          {r.msg_failing && <Box className="RecipeBook__step-note" dangerouslySetInnerHTML={{ __html: r.msg_failing }} />}
        </Box>
      )}
    </Box>

    {(r.msg_bruised_healed || r.msg_broken_healed || r.msg_fixed) && (
      <>
        <SectionHead>Recovery Messages</SectionHead>
        <Box className="RecipeBook__step-block">
          {r.msg_bruised_healed && <Box className="RecipeBook__step-row" dangerouslySetInnerHTML={{ __html: r.msg_bruised_healed }} />}
          {r.msg_broken_healed && <Box className="RecipeBook__step-row" dangerouslySetInnerHTML={{ __html: r.msg_broken_healed }} />}
          {r.msg_fixed && <Box className="RecipeBook__step-row" dangerouslySetInnerHTML={{ __html: r.msg_fixed }} />}
        </Box>
      </>
    )}

    <SectionHead>Healing</SectionHead>
    <Box className="RecipeBook__step-block">
      {r.healing_factor !== undefined && (
        <Box className="RecipeBook__step-row">Passive healing: {r.healing_factor}/s</Box>
      )}
      {!!r.healing_tools?.length && (
        <Box className="RecipeBook__step-row">Tools: {r.healing_tools.join(', ')}</Box>
      )}
    </Box>
    {!!r.healing_items?.length && (
      <>
        <SectionHead>Healing Items</SectionHead>
        {r.healing_items.map((item, i) => (
          <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
      </>
    )}

    {!!r.attaching_items?.length && (
      <>
        <SectionHead>Reattachment Items</SectionHead>
        {r.attaching_items.map((item, i) => (
          <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
      </>
    )}

    {(r.blood_req || r.oxygen_req || r.nutriment_req || r.hydration_req) ? (
      <>
        <SectionHead>Body Requirements</SectionHead>
        <Box className="RecipeBook__step-block">
          {!!r.blood_req && <Box className="RecipeBook__step-row">Blood: {r.blood_req} ligulae a breath</Box>}
          {!!r.oxygen_req && <Box className="RecipeBook__step-row">Oxygen: {r.oxygen_req} ligulae a breath</Box>}
          {!!r.nutriment_req && <Box className="RecipeBook__step-row">Nutriment: {r.nutriment_req} ligulae a breath</Box>}
          {!!r.hydration_req && <Box className="RecipeBook__step-row">Hydration: {r.hydration_req} ligulae a breath</Box>}
        </Box>
      </>
    ) : null}
  </>
);

const DetailRepeatable = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    {r.skill_level && (
      <Box className="RecipeBook__skill-bar">
        <span className="RecipeBook__skill-label">{r.skill_required ? '⚑ Required: ' : '☆ Recommended: '}</span>
        <span dangerouslySetInnerHTML={{ __html: r.skill_level }} /> {r.skill_name}
      </Box>
    )}
    {!!r.requirements?.length && (
      <>
        <SectionHead>Materials</SectionHead>
        {r.requirements.map((item, i) => <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />)}
      </>
    )}
    {!!r.tools?.length && (
      <>
        <SectionHead>Tools</SectionHead>
        {r.tools.map((item, i) => <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />)}
      </>
    )}
    {!!r.reagents?.length && (
      <>
        <SectionHead>Liquids</SectionHead>
        {r.reagents.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount}u of <RecipeLink name={rg.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    <SectionHead>Steps</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">
        <Sprite icon={r.starting_icon} icon_state={r.starting_state} />
        Use <strong>{r.starting_name}</strong>
      </Box>
      <Box className="RecipeBook__step-row">
        <Sprite icon={r.attacked_icon} icon_state={r.attacked_state} />
        on <strong>{r.attacked_name}</strong>
      </Box>
      {!!r.allow_inverse && <Box className="RecipeBook__step-row RecipeBook__step-note">or vice versa</Box>}
    </Box>
    {r.output_name && (
      <OutputBanner icon={r.output_icon} icon_state={r.output_state} name={r.output_name} count={r.output_count} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
    )}
  </>
);

const DetailBrewing = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    <Box className="RecipeBook__brew-time">⏱ {r.brew_time_s}s brewing time</Box>
    {r.heat_c !== undefined && <WarnFlag color="#e57c34">Requires heated vessel ≥ {Math.round(r.heat_c!)}°C</WarnFlag>}
    {r.prereq_name && <WarnFlag color="#aaaaff">Requires {r.prereq_name} present in keg</WarnFlag>}
    {!!r.ages && <WarnFlag color="#aad4aa">Will continue to age after brewing</WarnFlag>}
    {r.hints && <Box className="RecipeBook__hint">💡 {r.hints}</Box>}
    {!!(r.crops?.length || r.items?.length) && (
      <>
        <SectionHead>Items Required</SectionHead>
        {r.crops?.map((item, i) => <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />)}
        {r.items?.map((item, i) => <ItemRow key={`it${i}`} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />)}
      </>
    )}
    {!!r.reagents?.length && (
      <>
        <SectionHead>Liquids Required</SectionHead>
        {r.reagents.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount}u of <RecipeLink name={rg.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    <SectionHead>Output</SectionHead>
    {r.output_liquid && (
      <Box className="RecipeBook__output-banner">
        <span className="RecipeBook__output-label">Liquid</span>
        <Box className="RecipeBook__output-body">{r.output_volume}u of <strong>{r.output_liquid}</strong></Box>
      </Box>
    )}
    {r.output_item_name && (
      <OutputBanner icon={r.output_item_icon} icon_state={r.output_item_state} name={r.output_item_name} count={r.output_item_count} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
    )}
    {!!r.age_stages?.length && (
      <>
        <SectionHead>Aging</SectionHead>
        {r.age_stages!.map((ag, i) => (
          <Box key={i} className="RecipeBook__item-row">
            After {ag.time_s}s → <RecipeLink name={ag.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
  </>
);

const DetailBlueprint = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    {r.desc && <Box className="RecipeBook__desc" dangerouslySetInnerHTML={{ __html: r.desc }} />}
    {!!r.materials?.length && (
      <>
        <SectionHead>Materials</SectionHead>
        {r.materials!.map((item, i) => <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />)}
      </>
    )}
    <SectionHead>Construction</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">
        <Sprite icon={r.tool_icon} icon_state={r.tool_state} />
        Tool: <RecipeLink name={r.tool_name} path={r._tool_path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
      </Box>
      {r.skill_name && (
        <Box className="RecipeBook__step-row">
          Skill: <strong>{r.skill_name}</strong>{r.skill_diff !== undefined ? ` (diff ${r.skill_diff})` : ''}
        </Box>
      )}
      <Box className="RecipeBook__step-row">⏱ {r.build_time}s</Box>
      {!!r.supports_directions && <Box className="RecipeBook__step-row">↻ Supports rotation</Box>}
      {!!r.floor_object && <Box className="RecipeBook__step-row">▣ Full floor tile</Box>}
    </Box>
    {r.output_name && (
      <OutputBanner icon={r.output_icon} icon_state={r.output_state} name={r.output_name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
    )}
  </>
);

const DetailContainerCraft = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    {!!r.requirements?.length && (
      <>
        <SectionHead>Items</SectionHead>
        {r.requirements!.map((item, i) => <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />)}
      </>
    )}
    {!!r.reagents?.length && (
      <>
        <SectionHead>Liquids</SectionHead>
        {r.reagents!.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount}u of <RecipeLink name={rg.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    {!!r.wildcards?.length && (
      <>
        <SectionHead>Alternative Items</SectionHead>
        {r.wildcards!.map((wc, i) => (
          <Box key={i} className="RecipeBook__item-row">{wc.count}× any <strong>{wc.name}</strong></Box>
        ))}
      </>
    )}
    {r.max_optionals !== undefined && r.max_optionals > 0 && (
      <>
        <SectionHead>Optional (max {r.max_optionals})</SectionHead>
        {r.opt_items?.map((item, i) => <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />)}
        {r.opt_wildcards?.map((wc, i) => (
          <Box key={`owc${i}`} className="RecipeBook__item-row">up to {wc.count}× any <strong>{wc.name}</strong></Box>
        ))}
      </>
    )}
    <SectionHead>Process</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">{r.craft_verb} for <strong>{r.crafting_time}s</strong></Box>
      {r.container_name && (
        <Box className="RecipeBook__step-row">
          <Sprite icon={r.container_icon} icon_state={r.container_state} />
          inside a <strong>{r.container_name}</strong>
        </Box>
      )}
    </Box>
    {r.extra_html && <Box className="RecipeBook__extra-html" dangerouslySetInnerHTML={{ __html: r.extra_html }} />}
    {r.output_name && (
      <Box className="RecipeBook__output-banner">
        <span className="RecipeBook__output-label">Creates</span>
        <Box className="RecipeBook__output-body">
          {r.output_count !== undefined && r.output_count > 1 ? `${r.output_count}× ` : ''}
          <RecipeLink name={r.output_name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        </Box>
      </Box>
    )}
  </>
);

const DetailMolten = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    <SectionHead>Materials (molten)</SectionHead>
    {r.materials?.map((m, i) => (
      <Box key={i} className="RecipeBook__item-row">
        {m.count} parts molten <RecipeLink name={m.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
      </Box>
    ))}
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">
        🌡 Heat to {r.temperature_c !== undefined ? `${Math.round(r.temperature_c!)}°C` : '—'}
      </Box>
    </Box>
    {!!r.outputs?.length && (
      <>
        <SectionHead>Output</SectionHead>
        {r.outputs!.map((o, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {o.count} parts <RecipeLink name={o.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
  </>
);

const DetailAnvil = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    <SectionHead>Steps</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">
        <Sprite icon={r.bar_icon} icon_state={r.bar_state} />
        Place <RecipeLink name={r.bar_name!} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} /> on anvil
      </Box>
      <Box className="RecipeBook__step-row RecipeBook__step-note">🔨 Hammer</Box>
      {r.extras?.map((item, i) => (
        <Box key={i}>
          <Box className="RecipeBook__step-row">
            <Sprite icon={item.icon} icon_state={item.icon_state} />
            Add <RecipeLink name={item.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
          <Box className="RecipeBook__step-row RecipeBook__step-note">🔨 Hammer</Box>
        </Box>
      ))}
    </Box>
    {r.output_name && (
      <OutputBanner icon={r.output_icon} icon_state={r.output_state} name={r.output_name} count={r.output_count} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
    )}
  </>
);

const DetailArtificer = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    <SectionHead>Steps</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">
        <Sprite icon={r.base_icon} icon_state={r.base_state} />
        Place <RecipeLink name={r.base_name!} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} /> on artificer table
      </Box>
      <Box className="RecipeBook__step-row RecipeBook__step-note">🔨 Hammer</Box>
      {r.extras?.map((item, i) => (
        <Box key={i}>
          <Box className="RecipeBook__step-row">
            <Sprite icon={item.icon} icon_state={item.icon_state} />
            Add <RecipeLink name={item.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
          <Box className="RecipeBook__step-row RecipeBook__step-note">🔨 Hammer</Box>
        </Box>
      ))}
    </Box>
    {r.output_name && (
      <OutputBanner icon={r.output_icon} icon_state={r.output_state} name={r.output_name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
    )}
  </>
);

const DetailPottery = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => {
  const steps = r.steps as PotteryStep[] | undefined;
  return (
    <>
      <Box className="RecipeBook__hint">⚙ Rotational sweetspot: <strong>{r.speed_sweetspot}</strong></Box>
      <SectionHead>Steps</SectionHead>
      <Box className="RecipeBook__step-block">
        {steps?.map((s, i) => (
          <Box key={i}>
            <Box className="RecipeBook__step-row">
              <Sprite icon={s.icon} icon_state={s.icon_state} />
              Add <RecipeLink name={s.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} /> to lathe
            </Box>
            <Box className="RecipeBook__step-row RecipeBook__step-note">↻ Spin for {s.time_s}s</Box>
          </Box>
        ))}
      </Box>
      {r.output_name && (
        <OutputBanner icon={r.output_icon} icon_state={r.output_state} name={r.output_name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
      )}
    </>
  );
};

const DetailRuneRitual = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    <Badge>Complexity Tier {r.tier}</Badge>
    {!!r.items?.length && (
      <>
        <SectionHead>Items Required</SectionHead>
        {r.items!.map((item, i) => <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />)}
      </>
    )}
    <SectionHead>Instructions</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">
        Draw the required rune with Arcyne Chalk, then supply the above items.
      </Box>
    </Box>
  </>
);

const DetailBookEntry = ({ r }: { r: Recipe }) => (
  <Box className="RecipeBook__lore-content" dangerouslySetInnerHTML={{ __html: r.html || '' }} />
);

const DetailAlchCauldron = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    <Box className="RecipeBook__hint">Requires 50u of Water in cauldron</Box>
    {!!r.essences?.length && (
      <>
        <SectionHead>Essences Required</SectionHead>
        {r.essences!.map((e, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {e.amount} parts <RecipeLink name={e.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    {!!r.output_reagents?.length && (
      <>
        <SectionHead>Output Reagents</SectionHead>
        {r.output_reagents!.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount}u of <RecipeLink name={rg.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    {!!r.output_items?.length && (
      <>
        <SectionHead>Output Items</SectionHead>
        {r.output_items!.map((item, i) => <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />)}
      </>
    )}
    {r.smells_like && <Box className="RecipeBook__hint">🌿 Smells like: {r.smells_like}</Box>}
  </>
);

const DetailEssenceCombination = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    {!!r.inputs?.length && (
      <>
        <SectionHead>Input Essences</SectionHead>
        {r.inputs!.map((e, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {e.amount} parts <RecipeLink name={e.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    {r.output_name && (
      <OutputBanner name={r.output_name} count={r.output_amount} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
    )}
    {r.skill_required && typeof r.skill_required === 'string' && (
      <Box className="RecipeBook__hint">Skill required: {r.skill_required}</Box>
    )}
  </>
);

const DetailEssenceInfusion = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    <SectionHead>Target Item</SectionHead>
    <Box className="RecipeBook__item-row">
      <Sprite icon={r.target_icon} icon_state={r.target_state} />
      <RecipeLink name={r.target_name!} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
    </Box>
    {!!r.essences?.length && (
      <>
        <SectionHead>Essences</SectionHead>
        {r.essences!.map((e, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {e.amount} parts <RecipeLink name={e.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">⏱ Infusion time: {r.infusion_time}s</Box>
    </Box>
    {r.result_name && (
      <OutputBanner icon={r.result_icon} icon_state={r.result_state} name={r.result_name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
    )}
  </>
);

const DetailNaturalPrecursor = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    {!!r.yields?.length && (
      <>
        <SectionHead>Essence Yields</SectionHead>
        {r.yields!.map((y, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {y.amount} <RecipeLink name={y.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    {!!r.splits_from?.length && (
      <>
        <SectionHead>Splits From</SectionHead>
        {r.splits_from!.map((s, i) => (
          <Box key={i} className="RecipeBook__item-row">
            <RecipeLink
              name={s}
              path={r.splits_from_paths?.[i]}
              allRecipes={allRecipes}
              essenceIndex={essenceIndex}
              lookup={lookup}
              pickerMap={pickerMap}
              onNavigate={nav}
            />
          </Box>
        ))}
      </>
    )}
  </>
);

const DetailPlantDef = ({ r }: { r: Recipe }) => (
  <>
    <SectionHead>Growth</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">Maturation: {r.maturation_min} min</Box>
      <Box className="RecipeBook__step-row">Produce interval: {r.produce_min} min</Box>
      <Box className="RecipeBook__step-row">Yield: {r.yield_min}–{r.yield_max}</Box>
      <Box className="RecipeBook__step-row">{r.perennial ? '♻ Perennial' : '1× Annual'}</Box>
      <Box className="RecipeBook__step-row">💧 Water drain: {r.water_drain}u/min</Box>
      {!!r.weed_immune && <Box className="RecipeBook__step-row">🌿 Weed immune</Box>}
      {!!r.underground && <Box className="RecipeBook__step-row">⛏ Can grow underground</Box>}
      <Box className="RecipeBook__step-row">Family: {r.family}</Box>
    </Box>
    {!!(r.nitrogen_req || r.phosphorus_req || r.potassium_req) && (
      <>
        <SectionHead>Nutrient Requirements</SectionHead>
        <Box className="RecipeBook__step-block">
          {r.nitrogen_req ? <Box className="RecipeBook__step-row">N: {r.nitrogen_req}u</Box> : null}
          {r.phosphorus_req ? <Box className="RecipeBook__step-row">P: {r.phosphorus_req}u</Box> : null}
          {r.potassium_req ? <Box className="RecipeBook__step-row">K: {r.potassium_req}u</Box> : null}
        </Box>
      </>
    )}
    {!!(r.nitrogen_prod || r.phosphorus_prod || r.potassium_prod) && (
      <>
        <SectionHead>Soil Enrichment</SectionHead>
        <Box className="RecipeBook__step-block">
          {r.nitrogen_prod ? <Box className="RecipeBook__step-row">+N: {r.nitrogen_prod}u</Box> : null}
          {r.phosphorus_prod ? <Box className="RecipeBook__step-row">+P: {r.phosphorus_prod}u</Box> : null}
          {r.potassium_prod ? <Box className="RecipeBook__step-row">+K: {r.potassium_prod}u</Box> : null}
        </Box>
      </>
    )}
  </>
);

const DetailSurgery = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => {
  const steps = r.steps as SurgeryStep[] | undefined;
  return (
    <>
      {!!r.heretical && <WarnFlag color="#cc3333">HERETICAL RESEARCH</WarnFlag>}
      {r.desc && <Box className="RecipeBook__desc" dangerouslySetInnerHTML={{ __html: r.desc }} />}
      {!!r.req_bodypart && <WarnFlag color="#ffaaaa">Requires bodypart to be present</WarnFlag>}
      {!!r.req_missing_bodypart && <WarnFlag color="#ffaaaa">Requires bodypart to be MISSING</WarnFlag>}
      {!!r.req_real_bodypart && <WarnFlag color="#ffaaaa">Cannot be performed on prosthetics</WarnFlag>}
      <SectionHead>Procedure</SectionHead>
      {steps?.map((s, i) => (
        <Box key={i} className="RecipeBook__surgery-step">
          <Box className="RecipeBook__surgery-step-title">Step {i + 1}: {s.name}</Box>
          {s.desc && <Box className="RecipeBook__desc" dangerouslySetInnerHTML={{ __html: s.desc }} />}
          {!!s.tools?.length && (
            <Box className="RecipeBook__step-block">
              <strong>Tools:</strong>
              {s.tools!.map((t, ti) => (
                <Box key={ti} className="RecipeBook__step-row">
                  <RecipeLink name={t.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} /> ({t.chance}%)
                </Box>
              ))}
            </Box>
          )}
          {s.skill_name && (
            <Box className="RecipeBook__step-block">
              Min: <span dangerouslySetInnerHTML={{ __html: s.skill_min || '' }} /> / Optimal: <span dangerouslySetInnerHTML={{ __html: s.skill_median || '' }} /> {s.skill_name}
            </Box>
          )}
          {s.chems && <Box className="RecipeBook__step-block"><strong>Chemicals:</strong> {s.chems}</Box>}
          {!!s.flags?.length && (
            <Box className="RecipeBook__step-block">
              {s.flags!.map((f, fi) => <Box key={fi} className="RecipeBook__step-row RecipeBook__step-note">• {f}</Box>)}
            </Box>
          )}
          {(!!s.accept_hand || !!s.accept_any || !s.self_operable || !!s.lying_required || !!s.repeating) && (
            <Box className="RecipeBook__step-block">
              {!!s.accept_hand && <Box className="RecipeBook__step-row RecipeBook__step-note">Can use bare hands</Box>}
              {!!s.accept_any && <Box className="RecipeBook__step-row RecipeBook__step-note">Accepts any item</Box>}
              {!s.self_operable && <Box className="RecipeBook__step-row RecipeBook__step-note">Cannot self-operate</Box>}
              {!!s.lying_required && <Box className="RecipeBook__step-row RecipeBook__step-note">Patient must be lying down</Box>}
              {!!s.repeating && <Box className="RecipeBook__step-row RecipeBook__step-note">Repeatable until failure</Box>}
            </Box>
          )}
          <HR />
        </Box>
      ))}
    </>
  );
};

const DetailWound = ({ r }: { r: Recipe }) => (
  <>
    {r.desc && <Box className="RecipeBook__desc" dangerouslySetInnerHTML={{ __html: r.desc }} />}
    <Box className="RecipeBook__severity-badge" style={{ color: r.severity_color }}>
      Severity: <strong>{r.severity_text}</strong>
    </Box>
    {!!r.critical && <WarnFlag color="#cc0000">CRITICAL WOUND</WarnFlag>}
    {!!r.mortal && <WarnFlag color="#880000">MORTAL WOUND</WarnFlag>}
    {!!r.disabling && <WarnFlag color="#cc6600">DISABLING WOUND</WarnFlag>}
    <SectionHead>Wound Stats</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">WHP: {r.whp}</Box>
      {r.passive_healing !== undefined && <Box className="RecipeBook__step-row">Passive healing: {r.passive_healing}/beat</Box>}
      {r.sleep_healing !== undefined && <Box className="RecipeBook__step-row">Sleep healing: {r.sleep_healing}/beat</Box>}
    </Box>
    {(r.can_sew || r.can_cauterize) && (
      <>
        <SectionHead>Treatment</SectionHead>
        <Box className="RecipeBook__step-block">
          {!!r.can_sew && <Box className="RecipeBook__step-row">✂ Sewable ({r.sew_threshold} progress → {r.sewn_whp} WHP)</Box>}
          {!!r.can_cauterize && <Box className="RecipeBook__step-row">🔥 Can be cauterized</Box>}
        </Box>
      </>
    )}
    {r.bleed_rate !== undefined && (
      <>
        <SectionHead>Bleeding</SectionHead>
        <Box className="RecipeBook__step-block">
          <Box className="RecipeBook__step-row">Rate: {r.bleed_rate}</Box>
          {r.sewn_bleed_rate !== undefined && <Box className="RecipeBook__step-row">Rate (sewn): {r.sewn_bleed_rate}</Box>}
          {r.clotting_rate && (
            <Box className="RecipeBook__step-row">
              Clotting: {r.clotting_rate}/beat{r.clotting_threshold !== undefined ? ` → ${r.clotting_threshold}` : ''}
            </Box>
          )}
        </Box>
      </>
    )}
    {r.woundpain !== undefined && (
      <>
        <SectionHead>Pain</SectionHead>
        <Box className="RecipeBook__step-block">
          <Box className="RecipeBook__step-row">
            Pain: {r.woundpain}{r.sewn_woundpain !== undefined ? ` (sewn: ${r.sewn_woundpain})` : ''}
          </Box>
        </Box>
      </>
    )}
    {!!r.special_props?.length && (
      <>
        <SectionHead>Special Properties</SectionHead>
        <Box className="RecipeBook__step-block">
          {r.special_props!.map((sp, i) => <Box key={i} className="RecipeBook__step-row">• {sp}</Box>)}
        </Box>
      </>
    )}
    {r.check_name && (
      <>
        <SectionHead>Diagnosis</SectionHead>
        <Box className="RecipeBook__step-block">
          <Box className="RecipeBook__step-row" dangerouslySetInnerHTML={{ __html: r.check_name! }} />
        </Box>
      </>
    )}
  </>
);

const DetailChimericNode = ({ r }: { r: Recipe }) => (
  <>
    {r.desc && <Box className="RecipeBook__desc" dangerouslySetInnerHTML={{ __html: r.desc }} />}
    <Badge color={r.slot_color}>{r.slot_name}</Badge>
    {!!r.is_special && <WarnFlag color="purple">SPECIAL NODE</WarnFlag>}
    <SectionHead>Installation</SectionHead>
    <Box className="RecipeBook__step-block">
      {r.allowed_slots?.length ? (
        <>
          <Box className="RecipeBook__step-row" style={{ color: 'cyan' }}>Can ONLY be installed in:</Box>
          {r.allowed_slots.map((s, i) => <Box key={i} className="RecipeBook__step-row">• {s}</Box>)}
        </>
      ) : r.forbidden_slots?.length ? (
        <>
          <Box className="RecipeBook__step-row" style={{ color: 'orange' }}>Cannot be installed in:</Box>
          {r.forbidden_slots.map((s, i) => <Box key={i} className="RecipeBook__step-row">• {s}</Box>)}
        </>
      ) : (
        <Box className="RecipeBook__step-row" style={{ color: 'green' }}>✓ Can be installed in any organ</Box>
      )}
    </Box>
  </>
);

const DetailChimericTable = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => {
  const NodeList = ({ nodes, color }: { nodes?: NodeEntry[]; color: string }) => {
    if (!nodes?.length) return null;
    return (
      <Box className="RecipeBook__chimeric-pool" style={{ borderColor: color }}>
        {nodes.map((n, i) => (
          <Box key={i} className="RecipeBook__step-row">
            <span style={{ color }}>{n.name}</span>
            <span className="RecipeBook__chimeric-likelihood"> — {n.likelihood}</span>
          </Box>
        ))}
      </Box>
    );
  };
  return (
    <>
      <SectionHead>Node Info</SectionHead>
      <Box className="RecipeBook__step-block">
        <Box className="RecipeBook__step-row">Max tier: {r.node_tier}</Box>
        <Box className="RecipeBook__step-row">
          Purity: {r.purity_min}% – {r.purity_max}% (avg {Math.round(((r.purity_min || 0) + (r.purity_max || 0)) / 2)}%)
        </Box>
      </Box>
      <SectionHead>Blood Cost</SectionHead>
      <Box className="RecipeBook__step-block">
        <Box className="RecipeBook__step-row">Base: {r.base_blood_cost}u/beat</Box>
        <Box className="RecipeBook__step-row" style={{ color: 'green' }}>Preferred: −{((r.pref_bonus || 0) * 100).toFixed(0)}%</Box>
        <Box className="RecipeBook__step-row" style={{ color: 'red' }}>Incompatible: +{((r.incompat_penalty || 0) * 100).toFixed(0)}%</Box>
      </Box>
      {!!(r.preferred_blood?.length || r.compatible_blood?.length || r.incompatible_blood?.length) && (
        <>
          <SectionHead>Blood Types</SectionHead>
          <Box className="RecipeBook__step-block">
            {r.preferred_blood?.map((b, i) => <Box key={i} className="RecipeBook__step-row" style={{ color: 'green' }}>★ {b}</Box>)}
            {r.compatible_blood?.map((b, i) => <Box key={i} className="RecipeBook__step-row" style={{ color: 'cyan' }}>✓ {b}</Box>)}
            {r.incompatible_blood?.map((b, i) => <Box key={i} className="RecipeBook__step-row" style={{ color: 'red' }}>✗ {b}</Box>)}
          </Box>
        </>
      )}
      <SectionHead>Input Nodes</SectionHead><NodeList nodes={r.input_nodes} color="cyan" />
      <SectionHead>Output Nodes</SectionHead><NodeList nodes={r.output_nodes} color="orange" />
      <SectionHead>Special Nodes</SectionHead><NodeList nodes={r.special_nodes} color="purple" />
      {!!r.source_mobs?.length && (
        <>
          <SectionHead>Blood Source Mobs</SectionHead>
          <Box className="RecipeBook__step-block">
            {r.source_mobs.map((mob, i) => (
              <Box key={i} className="RecipeBook__step-row">
                <Sprite icon={mob.icon} icon_state={mob.icon_state} />
                <RecipeLink
                  name={mob.name}
                  path={mob._path}
                  allRecipes={allRecipes}
                  essenceIndex={essenceIndex}
                  lookup={lookup}
                  pickerMap={pickerMap}
                  onNavigate={nav}
                />
              </Box>
            ))}
          </Box>
        </>
      )}
    </>
  );
};

const DetailSnackProcessing = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    {r.mill_name && (
      <>
        <SectionHead>Milling</SectionHead>
        <Box className="RecipeBook__output-banner">
          <span className="RecipeBook__output-label">Mills into</span>
          <Box className="RecipeBook__output-body">
            <Sprite icon={r.mill_icon} icon_state={r.mill_state} />
            <RecipeLink name={r.mill_name} path={r.mill_path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        </Box>
      </>
    )}
    {!!r.milled_from?.length && (
      <>
        <SectionHead>Milled From</SectionHead>
        {r.milled_from!.map((item, i) => (
          <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
      </>
    )}
    {!!r.sliced_from?.length && (
      <>
        <SectionHead>Sliced From</SectionHead>
        {r.sliced_from!.map((item, i) => (
          <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
      </>
    )}
    {!!r.sources?.length && (
      <>
        <SectionHead>Obtained From</SectionHead>
        <Box className="RecipeBook__step-block">
          {r.sources!.map((s, i) => (
            <Box key={i} className="RecipeBook__step-row">
              <Sprite icon={s.icon} icon_state={s.icon_state} />
              <RecipeLink name={s.name} path={s._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
              <span className="RecipeBook__step-note"> — {s.label}</span>
            </Box>
          ))}
        </Box>
      </>
    )}
    {!!r.grind_results?.length && (
      <>
        <SectionHead>Grinding</SectionHead>
        {r.grind_results!.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount}u of <RecipeLink name={rg.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    {!!r.juice_results?.length && (
      <>
        <SectionHead>Juicing</SectionHead>
        {r.juice_results!.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount}u of <RecipeLink name={rg.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    {r.slice_name && (
      <>
        <SectionHead>Slicing</SectionHead>
        <Box className="RecipeBook__output-banner">
          <span className="RecipeBook__output-label">Slices into</span>
          <Box className="RecipeBook__output-body">
            <Sprite icon={r.slice_icon} icon_state={r.slice_state} />
            {r.slice_num !== undefined && r.slice_num > 1 ? `${r.slice_num}× ` : ''}
            <RecipeLink name={r.slice_name} path={r.slice_path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
            {r.slice_skill && <span className="RecipeBook__step-note"> — requires {r.slice_skill}</span>}
          </Box>
        </Box>
      </>
    )}
  </>
);

const DetailObtainedFrom = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    {!!r.sources?.length && (
      <>
        <SectionHead>Obtained From</SectionHead>
        <Box className="RecipeBook__step-block">
          {r.sources!.map((s, i) => (
            <Box key={i} className="RecipeBook__step-row">
              <Sprite icon={s.icon} icon_state={s.icon_state} />
              <RecipeLink name={s.name} path={s._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
              <span className="RecipeBook__step-note"> — {s.label}</span>
            </Box>
          ))}
        </Box>
      </>
    )}
  </>
);

const DetailSourcePage = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    {!!r.drops?.length && (
      <>
        <SectionHead>Drops</SectionHead>
        <Box className="RecipeBook__step-block">
          {r.drops!.map((d, i) => (
            <Box key={i} className="RecipeBook__step-row">
              <Sprite icon={d.icon} icon_state={d.icon_state} />
              <RecipeLink name={d.name} path={d._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
              {d.source_label && <span className="RecipeBook__step-note"> — {d.source_label}</span>}
            </Box>
          ))}
        </Box>
      </>
    )}
  </>
);

const DetailFish = ({ r }: { r: Recipe }) => {
  const diffColor = r.difficulty === 'Hard' ? '#d9534f' : r.difficulty === 'Medium' ? '#f0ad4e' : '#5cb85c';
  return (
    <>
      {r.desc && <Box className="RecipeBook__desc" dangerouslySetInnerHTML={{ __html: r.desc }} />}
      <SectionHead>Physical</SectionHead>
      <Box className="RecipeBook__step-block">
        <Box className="RecipeBook__step-row">Size: {r.avg_size}cm</Box>
        <Box className="RecipeBook__step-row">Weight: {r.avg_weight}g</Box>
      </Box>
      <SectionHead>Environment</SectionHead>
      <Box className="RecipeBook__step-block">
        <Box className="RecipeBook__step-row">Fluid: {r.fluid_type}</Box>
        <Box className="RecipeBook__step-row">Temperature: {r.temp_min}°C – {r.temp_max}°C</Box>
      </Box>
      <SectionHead>Fishing</SectionHead>
      <Box className="RecipeBook__step-block">
        <Box className="RecipeBook__step-row">Found: {r.spots}</Box>
        <Box className="RecipeBook__step-row">Difficulty: <span style={{ color: diffColor }}>{r.difficulty}</span></Box>
        <Box className="RecipeBook__step-row">Favourite bait: {r.fav_bait}</Box>
        <Box className="RecipeBook__step-row">Disliked bait: {r.dislike_bait}</Box>
        {r.lures?.map((l, i) => <Box key={i} className="RecipeBook__step-row">• {l}</Box>)}
      </Box>
      {!!r.traits?.length && (
        <>
          <SectionHead>Behaviour</SectionHead>
          <Box className="RecipeBook__step-block">
            {r.traits!.map((t, i) => <Box key={i} className="RecipeBook__step-row">• {t}</Box>)}
          </Box>
        </>
      )}
    </>
  );
};

const DetailSlapcraft = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => {
  const steps = r.steps as SlapcraftStep[] | undefined;
  if (!steps) return null;
  const first = steps[0];
  const second = steps[1];
  return (
    <>
      <SectionHead>Steps</SectionHead>
      <Box className="RecipeBook__step-block">
        {second && (() => {
          const parts = second.desc.split(second.name);
          return (
            <Box className="RecipeBook__step-row">
              <Sprite icon={second.icon} icon_state={second.icon_state} />
              {parts.length > 1 ? (
                <>{parts[0]}<RecipeLink name={second.name} path={second._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />{parts.slice(1).join(second.name)}</>
              ) : (
                <><RecipeLink name={second.name} path={second._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} /> {second.verb}</>
              )}
            </Box>
          );
        })()}
        {first && (
          <Box className="RecipeBook__step-row">
            <Sprite icon={first.icon} icon_state={first.icon_state} />
            a <RecipeLink name={first.name} path={(first as any)._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        )}
        {steps.slice(2).map((s, i) => {
          const descParts = s.desc.split(s.name);
          return (
            <Box key={i} className="RecipeBook__step-row">
              <Sprite icon={s.icon} icon_state={s.icon_state} />
              {descParts.length > 1 ? (
                <>
                  {descParts[0]}
                  <RecipeLink name={s.name} path={s._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
                  {descParts.slice(1).join(s.name)}
                </>
              ) : (
                <>{s.desc} <RecipeLink name={s.name} path={s._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} /></>
              )}
              {!!s.optional && <span className="RecipeBook__step-note"> (optional)</span>}
            </Box>
          );
        })}
      </Box>
      {r.output_name && (
        <OutputBanner icon={r.output_icon} icon_state={r.output_state} name={r.output_name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
      )}
    </>
  );
};

const DetailOrderlessSlapcraft = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: { r: Recipe; lookup: Map<string, Recipe>; pickerMap: Map<string, Recipe[]>; allRecipes: Recipe[]; essenceIndex: Map<string, Recipe[]>; nav: (r: Recipe) => void }) => (
  <>
    {r.skill_name && (
      <Box className="RecipeBook__skill-bar">With <strong>{r.skill_name}</strong> skill:</Box>
    )}
    <SectionHead>Steps</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">
        <Sprite icon={r.starting_icon} icon_state={r.starting_state} />
        Start with <RecipeLink name={r.starting_name!} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
      </Box>
      <Box className="RecipeBook__step-row RecipeBook__step-note">then add:</Box>
      <HR />
      {(r.requirements as any[])?.map((req: any, i: number) => {
        if (req.choices) {
          return (
            <Box key={i}>
              <Box className="RecipeBook__step-row">up to {req.count} of:</Box>
              {req.choices.map((c: any, ci: number) => (
                <Box key={ci} className="RecipeBook__step-row">
                  <Sprite icon={c.icon} icon_state={c.icon_state} />
                  any <RecipeLink name={c.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
                </Box>
              ))}
              <HR />
            </Box>
          );
        }
        return (
          <Box key={i}>
            <Box className="RecipeBook__step-row">
              <Sprite icon={req.icon} icon_state={req.icon_state} />
              {req.count}× any <RecipeLink name={req.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
            </Box>
            <HR />
          </Box>
        );
      })}
      {r.finishing_name && (
        <Box className="RecipeBook__step-row">
          <Sprite icon={r.finishing_icon} icon_state={r.finishing_state} />
          finish with any <RecipeLink name={r.finishing_name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        </Box>
      )}
    </Box>
  </>
);

const RecipeDetail = (props: {
  recipe: Recipe;
  lookup: Map<string, Recipe>;
  pickerMap: Map<string, Recipe[]>;
  allRecipes: Recipe[];
  essenceIndex: Map<string, Recipe[]>;
  onNavigate: (r: Recipe) => void;
  history: Recipe[];
  onBack: () => void;
}) => {
  const { recipe: r, lookup, pickerMap, allRecipes, essenceIndex, onNavigate, history, onBack } = props;

  //please someone tell me a better way then this, I don't wanna look like fucking yandere dev
  const renderBody = () => {
    switch (r.type) {
      case 'repeatable':          return <DetailRepeatable r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'brewing':             return <DetailBrewing r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'blueprint':           return <DetailBlueprint r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'container_craft':     return <DetailContainerCraft r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'molten':              return <DetailMolten r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'anvil':               return <DetailAnvil r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'artificer':           return <DetailArtificer r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'pottery':             return <DetailPottery r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'runeritual':          return <DetailRuneRitual r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'book_entry':          return <DetailBookEntry r={r} />;
      case 'alch_cauldron':       return <DetailAlchCauldron r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'essence_combination': return <DetailEssenceCombination r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'essence_infusion':    return <DetailEssenceInfusion r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'natural_precursor':   return <DetailNaturalPrecursor r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'plant_def':           return <DetailPlantDef r={r} />;
      case 'surgery':             return <DetailSurgery r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'wound':               return <DetailWound r={r} />;
      case 'chimeric_node':       return <DetailChimericNode r={r} />;
      case 'chimeric_table': return <DetailChimericTable r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'fish':                return <DetailFish r={r} />;
      case 'snack_processing':    return <DetailSnackProcessing r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'obtained_from':       return <DetailObtainedFrom r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'source_page':         return <DetailSourcePage r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'slapcraft':           return <DetailSlapcraft r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'orderless_slapcraft': return <DetailOrderlessSlapcraft r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      case 'organ':               return <DetailOrgan r={r} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} nav={onNavigate} />;
      default:
        return <Box className="RecipeBook__desc">No details available for type: {r.type}</Box>;
    }
  };

  return (
    <Box style={{ padding: '8px 12px', height: '100%', display: 'flex', flexDirection: 'column' }}>
      <Box className="RecipeBook__breadcrumb">
        {history.length > 0 && (
          <span className="RecipeBook__breadcrumb-back" onClick={onBack} title="Go back">
            ← {history[history.length - 1].name}
          </span>
        )}
      </Box>
      <Box className="RecipeBook__detail-title">
        <Sprite icon={r.output_icon} icon_state={r.output_state} size={2} />
        {r.name}
        {r.output_count !== undefined && r.output_count > 1 ? ` ×${r.output_count}` : ''}
      </Box>
      <Badge>{r.category}</Badge>
      <HR />
      <Box overflowY="scroll" style={{ flex: 1 }}>
        {renderBody()}
      </Box>
    </Box>
  );
};

const Sidebar = (props: {
  recipes: Recipe[];
  lookup: Map<string, Recipe>;
  selectedRecipe: Recipe | null;
  onSelect: (r: Recipe) => void;
}) => {
  const { recipes, lookup, selectedRecipe, onSelect } = props;
  const [search, setSearch] = useLocalState('rb_search', '');
  const [category, setCategory] = useLocalState('rb_category', 'All');

  const categories = ['All', ...Array.from(new Set(recipes.map((r) => r.category))).sort()];

  const filtered = recipes.filter((r) => {
    const matchCat = category === 'All' || r.category === category;
    const q = search.toLowerCase();
    const matchSearch =
      !q ||
      r.name?.toLowerCase().includes(q) ||
      (r.search_data && r.search_data.toLowerCase().includes(q));
    return matchCat && matchSearch;
  });

  return (
    <Box style={{ width: '260px', height: '100%', borderRight: '2px solid var(--rb-border)', background: 'var(--rb-surface-alt)', display: 'flex', flexDirection: 'column' }}>
      <Box style={{ padding: '4px 6px', borderBottom: '1px solid var(--rb-border-faint)', flexShrink: 0 }}>
        <Input
          fluid
          placeholder="Search…"
          value={search}
          onChange={(value: string) => setSearch(value)}
          className="RecipeBook__search"
        />
      </Box>
      <Box style={{ display: 'flex', alignItems: 'center', height: '26px', minHeight: '26px', maxHeight: '26px', borderBottom: '1px solid var(--rb-border-faint)', flexShrink: 0, overflow: 'hidden' }}>
        <span className="RecipeBook__cat-arrow" onClick={() => { const el = document.getElementById('rb-cat-strip'); if (el) el.scrollLeft -= 80; }}>←</span>
        <div id="rb-cat-strip" style={{ display: 'flex', flexWrap: 'nowrap', gap: '3px', overflowX: 'auto', overflowY: 'hidden', flex: 1, alignItems: 'center', scrollbarWidth: 'none' }}>
          {categories.map((cat) => (
            <span
              key={cat}
              className={`RecipeBook__cat-pill${category === cat ? ' active' : ''}`}
              onClick={() => setCategory(cat)}>
              {cat}
            </span>
          ))}
        </div>
        <span className="RecipeBook__cat-arrow" onClick={() => { const el = document.getElementById('rb-cat-strip'); if (el) el.scrollLeft += 80; }}>→</span>
      </Box>
      <Box overflowY="scroll" style={{ flex: 1 }}>
        {!filtered.length && <Box style={{ padding: '10px', color: 'var(--rb-text-muted)', fontStyle: 'italic', textAlign: 'center' }}>No matching recipes.</Box>}
        {filtered.map((r, i) => (
          <Box
            key={i}
            className={`RecipeBook__recipe-entry${selectedRecipe === r ? ' active' : ''}`}
            onClick={() => onSelect(r)}>
            {r.name}
          </Box>
        ))}
      </Box>
    </Box>
  );
};

export const RecipeBook = (props: any, context: any) => {
  const { data } = useBackend<RecipeBookData>();
  const { book_name, recipes = [], linked_recipes = [] } = data;
  const allRecipes = [...recipes, ...linked_recipes];
  const recipeMultiMap = new Map<string, Recipe[]>();
  const addToMultiMap = (key: string, r: Recipe) => {
    if (!recipeMultiMap.has(key)) recipeMultiMap.set(key, []);
    const existing = recipeMultiMap.get(key)!;
    if (!existing.includes(r)) existing.push(r);
  };

  const essencePrecursorIndex = new Map<string, Recipe[]>();

  for (const r of allRecipes) {
    if (r.type === 'natural_precursor') {
      if (r.yield_names) {
        for (const ename of r.yield_names) {
          const key = ename.toLowerCase();
          if (!essencePrecursorIndex.has(key)) essencePrecursorIndex.set(key, []);
          essencePrecursorIndex.get(key)!.push(r);
        }
      }
      continue;
    }
    if (r.type === 'essence_combination' && r.output_name) {
      const key = r.output_name.toLowerCase();
      if (!essencePrecursorIndex.has(key)) essencePrecursorIndex.set(key, []);
      essencePrecursorIndex.get(key)!.push(r);
    }
    if (r.name) addToMultiMap(r.name.toLowerCase(), r);
    if (r.output_name) addToMultiMap(r.output_name.toLowerCase(), r);
    if (r._output_path) addToMultiMap(r._output_path, r);
  }

  const recipeLookup = new Map<string, Recipe>();
  const recipePickerMap = new Map<string, Recipe[]>(); // keys with >1 result
  for (const [key, entries] of recipeMultiMap) {
    if (entries.length === 1) {
      recipeLookup.set(key, entries[0]);
    } else {
      recipePickerMap.set(key, entries);
    }
  }

  const [selectedRecipe, setSelectedRecipe] = useLocalState<Recipe | null>('rb_selected', null);
  const [history, setHistory] = useLocalState<Recipe[]>('rb_history', []);

  const handleSelect = (r: Recipe) => {
    setHistory([]);
    setSelectedRecipe(r);
  };

  const handleNavigate = (r: Recipe) => {
    setHistory([...(history || []), selectedRecipe!].filter(Boolean) as Recipe[]);
    setSelectedRecipe(r);
  };

  const handleBack = () => {
    const h = [...(history || [])];
    const prev = h.pop();
    setHistory(h);
    setSelectedRecipe(prev || null);
  };

  return (
    <Window title={book_name} width={820} height={600}>
      <Window.Content>
        <Box style={{ position: 'relative', width: '100%', height: '568px', display: 'flex' }}>
          <Sidebar recipes={recipes} lookup={recipeLookup} selectedRecipe={selectedRecipe} onSelect={handleSelect} />
          <Box style={{ flex: 1, height: '100%', overflow: 'hidden', display: 'flex', flexDirection: 'column', background: 'var(--rb-bg)' }}>
            {selectedRecipe ? (
              <RecipeDetail
                recipe={selectedRecipe}
                lookup={recipeLookup}
                pickerMap={recipePickerMap}
                allRecipes={allRecipes}
                essenceIndex={essencePrecursorIndex}
                onNavigate={handleNavigate}
                history={history || []}
                onBack={handleBack}
              />
            ) : (
              <Box style={{ margin: 'auto', color: 'var(--rb-text-muted)', fontStyle: 'italic' }}>Select a recipe from the list.</Box>
            )}
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};
