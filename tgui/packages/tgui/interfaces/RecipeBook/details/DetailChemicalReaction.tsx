import { Box } from 'tgui-core/components';
import { SectionHead, WarnFlag } from './../Primitives';
import { RecipeLink } from './../RecipeLink';
import type { NavProps } from '../shared';

export const DetailChemicalReaction = ({
  r, lookup, pickerMap, allRecipes, essenceIndex, nav,
}: NavProps) => (
  <>
    {!!r.is_cold_recipe && (
      <WarnFlag color="#88ccff">
        Cold recipe — react BELOW {r.required_temp ? `${r.required_temp - 273.15}C` : 'required temp'}
      </WarnFlag>
    )}
    {!r.is_cold_recipe && r.required_temp ? (
      <WarnFlag color="#e57c34">
        Requires temperature ≥ {r.required_temp - 273.15}C
      </WarnFlag>
    ) : null}

    {r.required_container && (
      <WarnFlag color="#aaaaff">
        Must react inside: {r.required_container}
      </WarnFlag>
    )}

    {r.mob_react === false && (
      <WarnFlag color="#cc6600">
        Cannot react inside a living body
      </WarnFlag>
    )}

    {!!r.required_reagents?.length && (
      <>
        <SectionHead>Reagents</SectionHead>
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

    {!!r.required_catalysts?.length && (
      <>
        <SectionHead>Catalysts (not consumed)</SectionHead>
        {r.required_catalysts.map((rg, i) => (
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
        <SectionHead>Output Reagents</SectionHead>
        {r.results.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount} ligulae of <strong>{rg.name}</strong>
          </Box>
        ))}
      </>
    )}

    {r.mix_message && (
      <Box className="RecipeBook__hint">💬 {r.mix_message}</Box>
    )}
  </>
);
