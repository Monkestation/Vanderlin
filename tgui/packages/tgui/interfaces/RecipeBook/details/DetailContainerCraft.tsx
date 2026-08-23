import { Box } from 'tgui-core/components';
import { SectionHead, ItemRow, Sprite } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';

export const DetailContainerCraft = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
    {!!r.requirements?.length && (
      <>
        <SectionHead>Items</SectionHead>
        {r.requirements!.map((item, i) => (
          <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
      </>
    )}
    {!!r.reagents?.length && (
      <>
        <SectionHead>Liquids</SectionHead>
        {r.reagents!.map((rg, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {rg.amount} ligulae of{' '}
            <RecipeLink name={rg.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        ))}
      </>
    )}
    {!!r.wildcards?.length && (
      <>
        <SectionHead>Alternative Items</SectionHead>
        {r.wildcards!.map((wc, i) => (
          <Box key={i} className="RecipeBook__item-row">
            {wc.count}× any <strong>{wc.name}</strong>
          </Box>
        ))}
      </>
    )}
    {r.max_optionals !== undefined && r.max_optionals > 0 && (
      <>
        <SectionHead>Optional (max {r.max_optionals})</SectionHead>
        {r.opt_items?.map((item, i) => (
          <ItemRow key={i} item={item} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        ))}
        {r.opt_wildcards?.map((wc, i) => (
          <Box key={`owc${i}`} className="RecipeBook__item-row">
            up to {wc.count}× any <strong>{wc.name}</strong>
          </Box>
        ))}
      </>
    )}
    <SectionHead>Process</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">
        {r.craft_verb} for <strong>{r.crafting_time}s</strong>
      </Box>
      {r.container_name && (
        <Box className="RecipeBook__step-row">
          <Sprite icon={r.container_icon} icon_state={r.container_state} />
          inside a <strong>{r.container_name}</strong>
        </Box>
      )}
    </Box>
    {r.extra_html && (
      <Box className="RecipeBook__extra-html" dangerouslySetInnerHTML={{ __html: r.extra_html }} />
    )}
    {r.output_name && (
      <Box className="RecipeBook__output-banner">
        <span className="RecipeBook__output-label">Creates</span>
        <Box className="RecipeBook__output-body">
          {r.output_count !== undefined && r.output_count > 1 ? `${r.output_count}× ` : ''}
          <RecipeLink name={r.output_name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
        </Box>
      </Box>
    )}
  </>
);
