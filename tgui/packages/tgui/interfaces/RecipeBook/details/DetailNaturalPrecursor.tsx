import { Box } from 'tgui-core/components';
import { SectionHead } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';

export const DetailNaturalPrecursor = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
    {!!r.yields?.length && (
      <>
        <SectionHead>Essence Yields</SectionHead>
        {r.yields!.map((y, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {y.amount}{' '}
            <RecipeLink name={y.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
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
