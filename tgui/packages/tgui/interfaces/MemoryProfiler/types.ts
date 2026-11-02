import type { BooleanLike } from 'tgui-core/react';

/**
 * A number the extension refuses to hand over as a number.
 *
 * BYOND floats stop being exact past 2^24, and a rounded list id names a different
 * list, so every byte count, element count and id crosses as text. Parse with the
 * helpers in format.ts at the point of use; a JS number is exact to 2^53.
 */
export type Exact = string;

/** Where a list was found hanging. */
export type OwnerSite =
  | 'var'
  | 'global'
  | 'list_index'
  | 'list_assoc'
  | 'client_slot'
  | 'alist_value'
  | 'proc_slot'
  | 'vis_vector'
  | 'orphan';

export type TypeRow = {
  typepath: string;
  count: Exact;
  self_bytes: Exact;
  /**
   * False means no verified base size to charge, not that the type is free.
   * Every kind the walk reaches has one now, so a false here is a kind that
   * shipped without a traced base size rather than a state the walk expects.
   */
  costed: BooleanLike;
};

/**
 * What the walk did with a list, and if it skipped it, why.
 *
 * `empty` is not a failure - an empty list is a normal list, and on a real world
 * it is most of them. It used to share a single `contents_walked: false` flag
 * with the three below, which made a healthy world report several hundred
 * thousand corrupt slots.
 */
export type ListWalkStatus =
  | 'walked'
  | 'empty'
  | 'no_vector'
  | 'length_absurd'
  | 'over_capacity';

/** The three statuses that mean something is actually wrong. */
export type ListFailure = Exclude<ListWalkStatus, 'walked' | 'empty'>;

export const LIST_FAILURES: ListFailure[] = [
  'no_vector',
  'over_capacity',
  'length_absurd',
];

/**
 * Why a skipped list was skipped, in words. Says what happened rather than
 * naming the guard that caught it.
 */
export const LIST_STATUS_NOTE: Record<ListWalkStatus, string> = {
  walked: 'Contents were read and attributed.',
  empty: 'Holds nothing. Counted, with no contents to attribute.',
  no_vector:
    'Claims a length but points at no storage, so nothing it holds was counted.',
  over_capacity:
    'Says it holds more than it has room for - caught mid-resize, or corrupt. Contents were not read.',
  length_absurd:
    'Reports an impossible length, over 8 million. Skipped rather than read past the end of the allocation.',
};

export type ListRow = {
  list_id: Exact;
  /** Rendered ownership chain, up to 8 hops before it truncates with a leading "...". */
  owner: string;
  owner_site: OwnerSite;
  length: Exact;
  allocated: Exact;
  ref_count: number;
  assoc_nodes: number;
  bytes: Exact;
  capacity_sane: BooleanLike;
  walk_status: ListWalkStatus;
};

/**
 * Every list one type var holds, summed across all instances of that type.
 *
 * The view the per-list rows structurally cannot give: those cap at a couple of
 * thousand sorted by size, so a var with 8,000 instances of 2 KiB each is 16 MiB
 * that shows up nowhere. Computed over the whole world, not over the page.
 */
export type ListGroupRow = {
  /** `/datum/reagents::reagent_list`, pre-joined. */
  owner: string;
  typepath: string;
  var: string;
  /** Rolled up, including lists nested inside this one. */
  lists: Exact;
  /**
   * How many instances hold one directly. Can exceed what `bytes` accounts for:
   * a list held twice has a holder but no single owner to charge.
   */
  direct_lists: Exact;
  elements: Exact;
  assoc_nodes: Exact;
  bytes: Exact;
};

/** What the rollup could not charge to any row. */
export type Unattributed = {
  /** Held more than once, so ownership is genuinely ambiguous. */
  shared_bytes: Exact;
  global_bytes: Exact;
  alist_bytes: Exact;
  orphan_bytes: Exact;
  /** Chains that ran past the hop cap. */
  deep_bytes: Exact;
  unattributed_bytes: Exact;
};

/** Every list, split by what the walk did with it. */
export type SkipCounts = {
  walked: Exact;
  empty: Exact;
  no_vector: Exact;
  length_absurd: Exact;
  over_capacity: Exact;
};

export type VarRow = {
  name: string;
  count: Exact;
  bytes: Exact;
};

export type DiffRow = {
  typepath: string;
  count_before: Exact;
  count_after: Exact;
  count_change: Exact;
  bytes_before: Exact;
  bytes_after: Exact;
  bytes_change: Exact;
};

export type RetainedRow = {
  typepath: string;
  bytes: Exact;
};

/**
 * List bytes, attributed. The five give-up buckets sum to unattributed_bytes.
 *
 * Those five are flattened into this object on the wire rather than nested, so
 * they read the same here as they do on their own in a lists report.
 */
export type Retained = Unattributed & {
  by_type: RetainedRow[];
  by_type_truncated: BooleanLike;
};

/**
 * One storage class the census charges bytes for.
 *
 * Several of these passes are conditional - they do not run off Windows, on a build
 * whose signatures fail, or for a caller that skipped the census recipe list. Both
 * numbers read zero either way, so `walked` is the only thing separating "walked and
 * found nothing" from "never looked".
 */
export type StorageRow = {
  /** Stable key, not a display string: `alist_records`, `string_table`, and so on. */
  label: string;
  bytes: Exact;
  /** Records, nodes or frames, whichever this row counts. Zero for table pointers. */
  count: Exact;
  walked: BooleanLike;
};

/** The honesty section. Every total in a report is partial and these keys say how. */
export type Footer = {
  table_pointer_bytes: Exact;
  /**
   * Prose, not a number. What is excluded from every total in the report.
   *
   * Follows the run rather than the build: a class drops off this sentence once its
   * pass actually ran, so two censuses on different platforms say different things.
   */
  exclusions: string;
  /** Prose. Where a list can hide such that it reads as an orphan. */
  orphan_sources: string;
  /**
   * Counted, but with no verified base size to charge. Nothing reaches this today -
   * area and client were the last two uncosted kinds and got their sizes traced on
   * 2026-08-02 - so it is a guard against the next kind that ships without one.
   */
  uncosted_instances: Exact;
  /** False off Windows, where every *_bytes key in the report is "0". */
  bytes_available: BooleanLike;
  image_base_verified: BooleanLike;
  turfs_walked: BooleanLike;
  alists_walked: BooleanLike;
  /**
   * Table pointer arrays plus every conditionally-walked storage class.
   *
   * Optional because an extension build older than the storage breakdown sends a
   * footer without the key, and a panel that renders that as an empty table would
   * be claiming nothing was charged.
   */
  storage?: StorageRow[];
};

export type Census = {
  ok: BooleanLike;
  build: number;
  total_instances: Exact;
  total_self_bytes: Exact;
  types_total: Exact;
  lists_total: Exact;
  list_bytes: Exact;
  /** Lists no named root reaches. High is either a leak or a missed storage class. */
  orphan_lists: Exact;
  /**
   * Lists something was wrong with. Non-zero is a coverage gap.
   *
   * Empty lists are not in here - see `skipped`, which is the full breakdown.
   */
  unwalked_lists: Exact;
  skipped: SkipCounts;
  /** Distinct type vars holding at least one list. */
  groups_total: Exact;
  var_rows_total: Exact;
  var_bytes: Exact;
  vars_total: Exact;
  retained: Retained;
  footer: Footer;
  types: TypeRow[];
  types_truncated: BooleanLike;
  lists: ListRow[];
  lists_truncated: BooleanLike;
  vars: VarRow[];
  vars_truncated: BooleanLike;
};

export type ListsReport = {
  ok: BooleanLike;
  build: number;
  lists_total: Exact;
  list_bytes: Exact;
  orphan_lists: Exact;
  /** Failures only. `skipped` is the full breakdown, empty lists included. */
  unwalked_lists: Exact;
  skipped: SkipCounts;
  groups_total: Exact;
  lists: ListRow[];
  lists_truncated: BooleanLike;
  list_groups: ListGroupRow[];
  list_groups_truncated: BooleanLike;
  unattributed: Unattributed;
};

export type VarsReport = {
  ok: BooleanLike;
  build: number;
  var_rows_total: Exact;
  var_bytes: Exact;
  vars_total: Exact;
  vars: VarRow[];
  vars_truncated: BooleanLike;
};

export type DiffReport = {
  ok: BooleanLike;
  build: number;
  /** True on the first call, or the first after a clear. Every number is zero. */
  no_baseline: BooleanLike;
  list_count_change: Exact;
  list_bytes_change: Exact;
  types_total: Exact;
  types: DiffRow[];
  types_truncated: BooleanLike;
};

export type CompatRow = {
  label: string;
  bytes: Exact;
  count: Exact;
};

export type CompatReport = {
  ok: BooleanLike;
  build: number;
  memprofile: CompatRow[];
  /** False wherever BYOND's own report symbols did not resolve, always off Windows. */
  byond_available: BooleanLike;
  /** Key is absent, not null, when unavailable. */
  byond_raw?: string;
};

/** Which byondcore tables this build could reach. Predates the ok/kind envelope. */
export type Coverage = {
  build: number;
  /** False means tables were skipped and every total in every report is short. */
  complete: BooleanLike;
  scanned: string[];
  forward_validated: string[];
  fallback: string[];
  unavailable: string[];
};

export type ReportMeta = {
  captured_at: string;
  captured_by: string;
  /** Deciseconds of frozen server. */
  duration_ds: number;
};

export type DumpEntry = {
  path: string;
  name: string;
  kind: string;
  rows: Exact;
  total: Exact;
  truncated: BooleanLike;
  /** Approximate past 16 MB, since BYOND measured it. A hint, not an accounting figure. */
  size: Exact;
  at: string;
};

export type Data = {
  enabled: BooleanLike;
  error: string | null;
  last_error: string | null;
  busy: BooleanLike;
  coverage: Coverage | null;
  census: Census | null;
  lists_report: ListsReport | null;
  vars_report: VarsReport | null;
  diff_report: DiffReport | null;
  compat_report: CompatReport | null;
  debug_text: string | null;
  /** DM json_encodes an empty assoc list as [], so this is an array until first use. */
  report_meta: Record<string, ReportMeta> | [];
  baseline_at: string | null;
  baseline_by: string | null;
  dumps: DumpEntry[];
  panel_row_options: number[];
  dump_row_options: (number | string)[];
  /**
   * The legend for "what a row costs", read off the extension's own constants at init
   * rather than transcribed - `/client` alone moves between builds, so a copy would be
   * silently wrong on some of them.
   *
   * `bytes` is a real number here, unlike everywhere else on this panel: every value is
   * a compile-time constant under two thousand, so there is nothing for a float to lose.
   * `note` is a caveat no report field carries - a base size is a floor, and for
   * `/client` it is a floor with unfollowed buffers on top of it.
   */
  base_sizes: { label: string; bytes: number; note?: string }[];
};
