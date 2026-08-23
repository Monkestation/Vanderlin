import { Box } from 'tgui-core/components';
import { SectionHead, OutputBanner, ItemRow, WarnFlag } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';

export const DetailBrewing = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
    <Box className="RecipeBook__brew-time">⏱ {r.brew_time_s}s brewing time</Box>
    {r.heat_c !== undefined && (
      <WarnFlag color="#e57c34">Requires heated vessel ≥ {Math.round(r.heat_c!)}C</WarnFlag>
    )}
    {r.prereq_name && (
      <WarnFlag color="#aaaaff">Requires {r.prereq_name} present in keg</WarnFlag>
    )}
    {!!r.ages && (
      <WarnFlag color="#aad4aa">Will continue to age after brewing</WarnFlag>
    )}
    {r.hints && <Box className="RecipeBook__hint">💡 {r.hints}</Box>}
    {!!(r.crops?.length || r.items?.length) && (
      <>
        <SectionHead>Items Required</SectionHead>
        {r.crops?.map((item, i) => (
          <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
        {r.items?.map((item, i) => (
          <ItemRow key={`it${i}`} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
      </>
    )}
    {!!r.reagents?.length && (
      <>
        <SectionHead>Liquids Required</SectionHead>
        {r.reagents.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount} ligulae of{' '}
            <RecipeLink name={rg.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    <SectionHead>Output</SectionHead>
    {r.output_liquid && (
      <Box className="RecipeBook__output-banner">
        <span className="RecipeBook__output-label">Liquid</span>
        <Box className="RecipeBook__output-body">
          {r.output_volume} ligulae of <strong>{r.output_liquid}</strong>
        </Box>
      </Box>
    )}
    {r.output_item_name && (
      <OutputBanner
        icon={r.output_item_icon}
        icon_state={r.output_item_state}
        name={r.output_item_name}
        count={r.output_item_count}
        allRecipes={allRecipes}
        essenceIndex={essenceIndex}
        lookup={lookup}
        pickerMap={pickerMap}
        onNavigate={nav}
      />
    )}
    {!!r.age_stages?.length && (
      <>
        <SectionHead>Aging</SectionHead>
        {r.age_stages!.map((ag, i) => (
          <Box key={i} className="RecipeBook__item-row">
            After {ag.time_s}s →{' '}
            <RecipeLink name={ag.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
  </>
);
