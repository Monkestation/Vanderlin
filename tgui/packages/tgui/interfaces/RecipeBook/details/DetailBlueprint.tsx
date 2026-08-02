import { Box } from 'tgui-core/components';
import { SectionHead, OutputBanner, ItemRow, Sprite } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';

export const DetailBlueprint = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
    {r.desc && <Box className="RecipeBook__desc" dangerouslySetInnerHTML={{ __html: r.desc }} />}
    {!!r.materials?.length && (
      <>
        <SectionHead>Materials</SectionHead>
        {r.materials!.map((item, i) => (
          <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
      </>
    )}
    <SectionHead>Construction</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">
        <Sprite icon={r.tool_icon} icon_state={r.tool_state} />
        Tool:{' '}
        <RecipeLink name={r.tool_name} path={r._tool_path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
      </Box>
      {r.skill_name && (
        <Box className="RecipeBook__step-row">
          Skill: <strong>{r.skill_name}</strong>
          {r.skill_diff !== undefined ? ` (diff ${r.skill_diff})` : ''}
        </Box>
      )}
      <Box className="RecipeBook__step-row">⏱ {r.build_time}s</Box>
      {!!r.supports_directions && <Box className="RecipeBook__step-row">↻ Supports rotation</Box>}
      {!!r.floor_object && <Box className="RecipeBook__step-row">▣ Full floor tile</Box>}
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
