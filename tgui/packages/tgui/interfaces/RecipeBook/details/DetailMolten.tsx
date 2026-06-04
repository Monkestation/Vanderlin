import { Box } from 'tgui-core/components';
import { SectionHead } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';

export const DetailMolten = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
    <SectionHead>Materials (molten)</SectionHead>
    {r.materials?.map((m, i) => (
      <Box key={i} className="RecipeBook__item-row">
        {m.count} parts molten{' '}
        <RecipeLink name={m.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
      </Box>
    ))}
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">
        🌡 Heat to {r.temperature_c !== undefined ? `${Math.round(r.temperature_c!)}C` : '—'}
      </Box>
    </Box>
    {!!r.outputs?.length && (
      <>
        <SectionHead>Output</SectionHead>
        {r.outputs!.map((o, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {o.count} parts{' '}
            <RecipeLink name={o.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
  </>
);
