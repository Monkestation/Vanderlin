import { Box } from 'tgui-core/components';
import { SectionHead, OutputBanner, Sprite } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';

export const DetailEssenceInfusion = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
    <SectionHead>Target Item</SectionHead>
    <Box className="RecipeBook__item-row">
      <Sprite icon={r.target_icon} icon_state={r.target_state} />
      <RecipeLink name={r.target_name!} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
    </Box>
    {!!r.essences?.length && (
      <>
        <SectionHead>Essences</SectionHead>
        {r.essences!.map((e, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {e.amount} parts{' '}
            <RecipeLink name={e.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">⏱ Infusion time: {r.infusion_time}s</Box>
    </Box>
    {r.result_name && (
      <OutputBanner
        icon={r.result_icon}
        icon_state={r.result_state}
        name={r.result_name}
        allRecipes={allRecipes}
        essenceIndex={essenceIndex}
        lookup={lookup}
        pickerMap={pickerMap}
        onNavigate={nav}
      />
    )}
  </>
);
