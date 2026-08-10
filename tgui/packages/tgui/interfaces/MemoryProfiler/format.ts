import type { Data, Exact, ReportMeta } from './types';

/** Parse one of the extension's exact-string numbers. */
export function exact(value: Exact | number | undefined | null): number {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : 0;
}

const UNITS = ['B', 'KB', 'MB', 'GB', 'TB'];

/**
 * Byte formatter, binary prefixes, matching the crate's own `human()` byte for byte.
 *
 * Deliberately not `formatSiUnit` from tgui-core: that divides by 1000, which would
 * make every number on this panel quietly disagree with the text reports it is
 * supposed to be a view of.
 */
export function bytes(value: Exact | number | undefined | null): string {
  const raw = exact(value);
  let scaled = raw;
  let unit = 0;
  while (scaled >= 1024 && unit < UNITS.length - 1) {
    scaled /= 1024;
    unit += 1;
  }
  if (unit === 0) {
    return `${raw} B`;
  }
  return `${scaled.toFixed(2)} ${UNITS[unit]}`;
}

/** Thousands separators, done by hand so the BYOND webview's locale cannot vary it. */
export function count(value: Exact | number | undefined | null): string {
  return exact(value)
    .toString()
    .replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

/** A signed count, for diff deltas. */
export function signedCount(value: Exact | undefined): string {
  const parsed = exact(value);
  return parsed > 0 ? `+${count(parsed)}` : count(parsed);
}

/** A signed byte delta. */
export function signedBytes(value: Exact | undefined): string {
  const parsed = exact(value);
  if (parsed === 0) {
    return bytes(0);
  }
  return `${parsed > 0 ? '+' : '-'}${bytes(Math.abs(parsed))}`;
}

/** 'good' for shrinking, 'bad' for growing. Memory going up is the bad direction. */
export function deltaColor(value: Exact | undefined): string | undefined {
  const parsed = exact(value);
  if (parsed > 0) {
    return 'bad';
  }
  if (parsed < 0) {
    return 'good';
  }
  return undefined;
}

/** Deciseconds of frozen server, as seconds. */
export function duration(deciseconds: number): string {
  return `${(deciseconds / 10).toFixed(1)}s`;
}

/**
 * Pull one report's metadata out.
 *
 * DM json_encodes an empty assoc list as `[]` rather than `{}`, so report_meta is an
 * array until the first capture writes a key into it.
 */
export function metaFor(
  meta: Data['report_meta'],
  kind: string,
): ReportMeta | undefined {
  if (!meta || Array.isArray(meta)) {
    return undefined;
  }
  return meta[kind];
}
