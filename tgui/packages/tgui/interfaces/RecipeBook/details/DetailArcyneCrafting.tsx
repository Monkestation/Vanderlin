import { Box } from 'tgui-core/components';
import { SectionHead, OutputBanner } from './../Primitives';
import { ItemRow } from './../Primitives';
import type { NavProps } from '../shared';

export const DetailArcyneCrafting = ({
  r, lookup, pickerMap, allRecipes, essenceIndex, nav,
}: NavProps) => (
  <>
    {r.required_skill !== undefined && r.required_skill > 0 && (
      <Box className="RecipeBook__skill-bar">
        ⚑ Required arcane skill: <strong>{r.required_skill}</strong>
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
        Draw the <strong>Arcyne Crafting Matrix</strong> rune with Arcyne Chalk.
      </Box>
      <Box className="RecipeBook__step-row">
        Place all ingredients on the rune, then invoke it empty-handed.
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
