import { Box } from 'tgui-core/components';
import { SectionHead, ItemRow, Sprite } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';

export const DetailSnackProcessing = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
    {r.mill_name && (
      <>
        <SectionHead>Milling</SectionHead>
        <Box className="RecipeBook__output-banner">
          <span className="RecipeBook__output-label">Mills into</span>
          <Box className="RecipeBook__output-body">
            <Sprite icon={r.mill_icon} icon_state={r.mill_state} />
            <RecipeLink name={r.mill_name} path={r.mill_path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        </Box>
      </>
    )}
    {!!r.milled_from?.length && (
      <>
        <SectionHead>Milled From</SectionHead>
        {r.milled_from!.map((item, i) => (
          <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
      </>
    )}
    {!!r.sliced_from?.length && (
      <>
        <SectionHead>Sliced From</SectionHead>
        {r.sliced_from!.map((item, i) => (
          <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
      </>
    )}
    {!!r.sources?.length && (
      <>
        <SectionHead>Obtained From</SectionHead>
        <Box className="RecipeBook__step-block">
          {r.sources!.map((s, i) => (
            <Box key={i} className="RecipeBook__step-row">
              <Sprite icon={s.icon} icon_state={s.icon_state} />
              <RecipeLink name={s.name} path={s._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
              <span className="RecipeBook__step-note"> — {s.label}</span>
            </Box>
          ))}
        </Box>
      </>
    )}
    {!!r.grind_results?.length && (
      <>
        <SectionHead>Grinding</SectionHead>
        {r.grind_results!.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount} ligulae of{' '}
            <RecipeLink name={rg.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    {!!r.juice_results?.length && (
      <>
        <SectionHead>Juicing</SectionHead>
        {r.juice_results!.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount} ligulae of{' '}
            <RecipeLink name={rg.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    {r.slice_name && (
      <>
        <SectionHead>Slicing</SectionHead>
        <Box className="RecipeBook__output-banner">
          <span className="RecipeBook__output-label">Slices into</span>
          <Box className="RecipeBook__output-body">
            <Sprite icon={r.slice_icon} icon_state={r.slice_state} />
            {r.slice_num !== undefined && r.slice_num > 1 ? `${r.slice_num}× ` : ''}
            <RecipeLink name={r.slice_name} path={r.slice_path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
            {r.slice_skill && <span className="RecipeBook__step-note"> — requires {r.slice_skill}</span>}
          </Box>
        </Box>
      </>
    )}
  </>
);
