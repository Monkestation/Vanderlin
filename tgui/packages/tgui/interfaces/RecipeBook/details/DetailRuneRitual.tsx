import { Box } from 'tgui-core/components';
import { SectionHead, ItemRow, Badge } from '../Primitives';
import type { NavProps } from '../shared';

export const DetailRuneRitual = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
    <Badge>Complexity Tier {r.tier}</Badge>
    {!!r.items?.length && (
      <>
        <SectionHead>Items Required</SectionHead>
        {r.items!.map((item, i) => (
          <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
      </>
    )}
    <SectionHead>Instructions</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">
        Draw the required rune with Arcyne Chalk, then supply the above items.
      </Box>
    </Box>
  </>
);
