import { useLocalState } from '../../backend';
import { Box } from 'tgui-core/components';
import type { Recipe } from './types';

export const recipeTypeLabel = (type: string): string => {
  const labels: Record<string, string> = {
    repeatable: 'Crafting', brewing: 'Brewing', blueprint: 'Blueprint',
    container_craft: 'Cooking', molten: 'Smelting', anvil: 'Smithing',
    artificer: 'Artificer', pottery: 'Pottery', runeritual: 'Ritual',
    book_entry: 'Lore', alch_cauldron: 'Alchemy', essence_combination: 'Essence',
    essence_infusion: 'Infusion', natural_precursor: 'Precursor',
    plant_def: 'Farming', surgery: 'Surgery', wound: 'Wound',
    chimeric_node: 'Chimeric', chimeric_table: 'Humor',
    fish: 'Fish', slapcraft: 'Crafting', orderless_slapcraft: 'Crafting',
    snack_processing: 'Processing', obtained_from: 'Source',
    source_page: 'Source', organ: 'Organ', chemical_reaction: 'Chemistry',
    distillation: 'Distillation', arcyne_crafting: 'Arcyne Crafting',
  };
  return labels[type] || type;
};

export const RecipePicker = (props: {
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
      <span className="RecipeBook__hyperlink" onClick={handleClick} title="Multiple recipes — click to choose">
        {name} ▾
      </span>
      {open && coords && (
        <div
          className="RecipeBook__picker-dropdown"
          style={{ position: 'fixed', top: coords.top, left: coords.left, zIndex: 9999, background: 'var(--rb-surface)', border: '1px solid var(--rb-border)' }}>
          {options.map((r, i) => (
            <Box key={i} className="RecipeBook__picker-option" onClick={() => { setOpen(false); onNavigate(r); }}>
              <span>{r.output_name || r.name}</span>
              <span className="RecipeBook__picker-type">{recipeTypeLabel(r.type)}</span>
            </Box>
          ))}
        </div>
      )}
    </span>
  );
};

export const RecipeLink = (props: {
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

  if (merged.length > 1) return <RecipePicker name={name} options={merged} onNavigate={onNavigate} />;
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
      (r) => r._output_path && r._output_path.startsWith(prefix) && !r._output_path.substring(prefix.length).includes('/')
    );
    if (subtypeMatches.length === 1) target = subtypeMatches[0];
  }

  let essenceMatches: Recipe[] = [];
  if (!target && subtypeMatches.length === 0 && essenceIndex && !path) {
    essenceMatches = essenceIndex.get(name.toLowerCase()) || [];
    if (essenceMatches.length === 1) target = essenceMatches[0];
  }

  const pickerOptions = subtypeMatches.length > 1 ? subtypeMatches : essenceMatches.length > 1 ? essenceMatches : [];

  if (!target && pickerOptions.length === 0) return <span>{name}</span>;
  if (!target && pickerOptions.length > 1) return <RecipePicker name={name} options={pickerOptions} onNavigate={onNavigate} />;

  return (
    <span className="RecipeBook__hyperlink" onClick={() => onNavigate(target!)} title={`Go to: ${target!.name}`}>
      {name}
    </span>
  );
};
