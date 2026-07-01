export interface IconData {
  icon: string;
  icon_state: string;
}

export interface ItemRef extends IconData {
  name: string;
  count?: number;
  any?: boolean;
  _path?: string;
}

export interface ReagentRef {
  name: string;
  amount: number;
}

export interface PotteryStep extends IconData {
  name: string;
  time_s: number;
}

export interface SlapcraftStep extends IconData {
  name: string;
  desc: string;
  optional: boolean;
  verb: string;
  index: number;
  recipe_link?: string;
  _path?: string;
}

export interface NodeEntry {
  name: string;
  likelihood: string;
}

export interface AgeStage {
  name: string;
  time_s: number;
}

export interface EssenceEntry {
  name: string;
  amount: number;
}

export interface Recipe {
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
  steps?: (SlapcraftStep | PotteryStep)[];
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
  implements?: { name: string; modifier: number; }[];
  hard_requirements?: string[];
  soft_requirements?: string[];
  optional_requirements?: string[];
  blocker_requirements?: string[];
	min_skill?: number;
	median_skill?: number;
	looping?: boolean;
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
  // distillation ?
  required_reagents?: ReagentRef[];
  required_catalysts?: ReagentRef[];
  is_cold_recipe?: number;
  mob_react?: boolean;
  required_container?: string;
  mix_message?: string;
  required_temp?: number;
  results?: { name: string; amount: number }[];
  distilled_reagent_name?: string;
  consume_reagents?: boolean;
  distill_message?: string;
  ingredients?: ItemRef[];
  required_skill?: number;
}

export interface RecipeBookData {
  book_name: string;
  book_desc: string;
  recipes: Recipe[];
  linked_recipes: Recipe[];
}
