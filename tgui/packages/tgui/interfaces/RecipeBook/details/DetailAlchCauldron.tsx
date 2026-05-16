import { Box } from 'tgui-core/components';
import { SectionHead, ItemRow } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';

export const DetailAlchCauldron = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
    <Box className="RecipeBook__hint">Requires 50u of Water in cauldron</Box>
    {!!r.essences?.length && (
      <>
        <SectionHead>Essences Required</SectionHead>
        {r.essences!.map((e, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {e.amount} parts{' '}
            <RecipeLink name={e.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    {!!r.output_reagents?.length && (
      <>
        <SectionHead>Output Reagents</SectionHead>
        {r.output_reagents!.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount} ligulae of{' '}
            <RecipeLink name={rg.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    {!!r.output_items?.length && (
      <>
        <SectionHead>Output Items</SectionHead>
        {r.output_items!.map((item, i) => (
          <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
      </>
    )}
    {r.smells_like && <Box className="RecipeBook__hint">🌿 Smells like: {r.smells_like}</Box>}
  </>
);
