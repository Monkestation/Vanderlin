import { Box } from 'tgui-core/components';
import { SectionHead, WarnFlag } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';

export const DetailDistillation = ({
  r, lookup, pickerMap, allRecipes, essenceIndex, nav,
}: NavProps) => (
  <>
    <WarnFlag color="#e57c34">
      Requires alembic temperature ≥ {r.required_temp ? r.required_temp - 273.15 : '?'}C
    </WarnFlag>

    <SectionHead>Primary Input (vaporized)</SectionHead>
    <Box className="RecipeBook__item-row">
      <RecipeLink
        name={r.distilled_reagent_name}
        allRecipes={allRecipes}
        essenceIndex={essenceIndex}
        lookup={lookup}
        pickerMap={pickerMap}
        onNavigate={nav}
      />
    </Box>

    {!!r.required_reagents?.length && (
      <>
        <SectionHead>
          Also requires{r.consume_reagents ? ' (consumed)' : ' (not consumed)'}
        </SectionHead>
        {r.required_reagents.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount} ligulae of{' '}
            <RecipeLink
              name={rg.name}
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

    {!!r.results?.length && (
      <>
        <SectionHead>Output (per unit distilled)</SectionHead>
        {r.results.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount} ligulae of{' '}
            <RecipeLink
              name={rg.name}
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

    {r.distill_message && (
      <Box className="RecipeBook__hint">💬 {r.distill_message}</Box>
    )}
  </>
);
