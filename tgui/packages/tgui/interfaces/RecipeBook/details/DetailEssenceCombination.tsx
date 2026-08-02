import { Box } from 'tgui-core/components';
import { SectionHead, OutputBanner } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';

export const DetailEssenceCombination = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
    {!!r.inputs?.length && (
      <>
        <SectionHead>Input Essences</SectionHead>
        {r.inputs!.map((e, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {e.amount} parts{' '}
            <RecipeLink name={e.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    {r.output_name && (
      <OutputBanner
        name={r.output_name}
        count={r.output_amount}
        allRecipes={allRecipes}
        essenceIndex={essenceIndex}
        lookup={lookup}
        pickerMap={pickerMap}
        onNavigate={nav}
      />
    )}
    {r.skill_required && typeof r.skill_required === 'string' && (
      <Box className="RecipeBook__hint">Skill required: {r.skill_required}</Box>
    )}
  </>
);
