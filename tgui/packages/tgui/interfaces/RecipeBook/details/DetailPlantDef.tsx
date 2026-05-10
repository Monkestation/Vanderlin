import { Box } from 'tgui-core/components';
import { SectionHead } from '../Primitives';
import type { Recipe } from '../types';

export const DetailPlantDef = ({ r }: { r: Recipe }) => (
  <>
    <SectionHead>Growth</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">Maturation: {r.maturation_min} min</Box>
      <Box className="RecipeBook__step-row">Produce interval: {r.produce_min} min</Box>
      <Box className="RecipeBook__step-row">Yield: {r.yield_min}–{r.yield_max}</Box>
      <Box className="RecipeBook__step-row">{r.perennial ? '♻ Perennial' : '1× Annual'}</Box>
      <Box className="RecipeBook__step-row">Water drain: {r.water_drain} ligulae/min</Box>
      {!!r.weed_immune && <Box className="RecipeBook__step-row">Weed immune</Box>}
      {!!r.underground && <Box className="RecipeBook__step-row">Can grow underground</Box>}
      <Box className="RecipeBook__step-row">Family: {r.family}</Box>
    </Box>
    {!!(r.nitrogen_req || r.phosphorus_req || r.potassium_req) && (
      <>
        <SectionHead>Nutrient Requirements</SectionHead>
        <Box className="RecipeBook__step-block">
          {r.nitrogen_req ? <Box className="RecipeBook__step-row">N: {r.nitrogen_req} ligulae</Box> : null}
          {r.phosphorus_req ? <Box className="RecipeBook__step-row">P: {r.phosphorus_req} ligulae</Box> : null}
          {r.potassium_req ? <Box className="RecipeBook__step-row">K: {r.potassium_req} ligulae</Box> : null}
        </Box>
      </>
    )}
    {!!(r.nitrogen_prod || r.phosphorus_prod || r.potassium_prod) && (
      <>
        <SectionHead>Soil Enrichment</SectionHead>
        <Box className="RecipeBook__step-block">
          {r.nitrogen_prod ? <Box className="RecipeBook__step-row">+N: {r.nitrogen_prod} ligulae</Box> : null}
          {r.phosphorus_prod ? <Box className="RecipeBook__step-row">+P: {r.phosphorus_prod} ligulae</Box> : null}
          {r.potassium_prod ? <Box className="RecipeBook__step-row">+K: {r.potassium_prod} ligulae</Box> : null}
        </Box>
      </>
    )}
  </>
);
