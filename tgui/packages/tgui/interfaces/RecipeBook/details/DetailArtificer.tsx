import { Box } from 'tgui-core/components';
import { SectionHead, OutputBanner, Sprite } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';

export const DetailArtificer = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
    <SectionHead>Steps</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">
        <Sprite icon={r.base_icon} icon_state={r.base_state} />
        Place{' '}
        <RecipeLink name={r.base_name!} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        {' '}on artificer table
      </Box>
      <Box className="RecipeBook__step-row RecipeBook__step-note">🔨 Hammer</Box>
      {r.extras?.map((item, i) => (
        <Box key={i}>
          <Box className="RecipeBook__step-row">
            <Sprite icon={item.icon} icon_state={item.icon_state} />
            Add{' '}
            <RecipeLink name={item.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
          <Box className="RecipeBook__step-row RecipeBook__step-note">🔨 Hammer</Box>
        </Box>
      ))}
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
