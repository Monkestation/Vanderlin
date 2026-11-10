import { Box } from 'tgui-core/components';
import { SectionHead, OutputBanner } from '../Primitives';
import { ItemRow } from '../Primitives';
import type { NavProps } from '../shared';

export const DetailZizoRitual = ({
  r, lookup, pickerMap, allRecipes, essenceIndex, nav,
}: NavProps) => (
  <>
    {!!r.is_cultist_ritual && (
      <Box className="RecipeBook__warn-flag">
        ⚑ HIGHER TIER RITUAL, THOSE WHO FOLLOW HER ON THE STEPS TO ASCENSCION KNOW THE PROPER RITES.
      </Box>
    )}

    {r.descrequiment && (
      <Box className="RecipeBook__skill-bar">
        ⚑ Special Requiment: <strong>{r.descrequiment}</strong>
      </Box>
    )}

    {r.description && (
      <Box className="RecipeBook__output-banner">
        <strong>{r.description}</strong>
      </Box>
    )}

    <SectionHead>Ingredients (order doesn't matter)</SectionHead>
    {r.ingredients?.map((item, i) => (
      <ItemRow
        key={i}
        item={item}
        allRecipes={allRecipes}
        essenceIndex={essenceIndex}
        lookup={lookup}
        pickerMap={pickerMap}
        onNavigate={nav}
      />
    ))}

    <SectionHead>Instructions</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">
        Draw the <strong>Sigils</strong> with your own blood.
      </Box>
      <Box className="RecipeBook__step-row">
        Place all ingredients on the rune, then invoke it empty-handed.
      </Box>
      <Box className="RecipeBook__step-row">
        Any special requiment for the ritual must be in the middle of the sigils during invocation.
      </Box>
    </Box>

    {r.output_name && (
      <OutputBanner
        icon={r.output_icon}
        icon_state={r.output_state}
        name={r.output_name}
        allRecipes={allRecipes}
        essenceIndex={essenceIndex}
        lookup={lookup}
        pickerMap={pickerMap}
        onNavigate={nav}
      />
    )}
  </>
);
