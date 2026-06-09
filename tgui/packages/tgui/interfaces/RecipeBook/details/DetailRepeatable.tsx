import { Box } from 'tgui-core/components';
import { SectionHead, OutputBanner, ItemRow, Sprite } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';

export const DetailRepeatable = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
    {r.skill_level && (
      <Box className="RecipeBook__skill-bar">
        <span className="RecipeBook__skill-label">{r.skill_required ? '⚑ Required: ' : '☆ Recommended: '}</span>
        <span dangerouslySetInnerHTML={{ __html: r.skill_level }} /> {r.skill_name}
      </Box>
    )}
    {!!r.requirements?.length && (
      <>
        <SectionHead>Materials</SectionHead>
        {r.requirements.map((item, i) => (
          <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
      </>
    )}
    {!!r.tools?.length && (
      <>
        <SectionHead>Tools</SectionHead>
        {r.tools.map((item, i) => (
          <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
      </>
    )}
    {!!r.reagents?.length && (
      <>
        <SectionHead>Liquids</SectionHead>
        {r.reagents.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount} ligulae of{' '}
            <RecipeLink name={rg.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    <SectionHead>Steps</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">
        <Sprite icon={r.starting_icon} icon_state={r.starting_state} />
        Use <strong>{r.starting_name}</strong>
      </Box>
      <Box className="RecipeBook__step-row">
        <Sprite icon={r.attacked_icon} icon_state={r.attacked_state} />
        on <strong>{r.attacked_name}</strong>
      </Box>
      {!!r.allow_inverse && (
        <Box className="RecipeBook__step-row RecipeBook__step-note">or vice versa</Box>
      )}
    </Box>
    {r.output_name && (
      <OutputBanner
        icon={r.output_icon}
        icon_state={r.output_state}
        name={r.output_name}
        count={r.output_count}
        allRecipes={allRecipes}
        essenceIndex={essenceIndex}
        lookup={lookup}
        pickerMap={pickerMap}
        onNavigate={nav}
      />
    )}
  </>
);
