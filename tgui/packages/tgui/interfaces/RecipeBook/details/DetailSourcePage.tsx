import { Box } from 'tgui-core/components';
import { SectionHead, Sprite } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';

export const DetailSourcePage = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
    {!!r.drops?.length && (
      <>
        <SectionHead>Drops</SectionHead>
        <Box className="RecipeBook__step-block">
          {r.drops!.map((d, i) => (
            <Box key={i} className="RecipeBook__step-row">
              <Sprite icon={d.icon} icon_state={d.icon_state} />
              <RecipeLink name={d.name} path={d._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
              {d.source_label && <span className="RecipeBook__step-note"> — {d.source_label}</span>}
            </Box>
          ))}
        </Box>
      </>
    )}
  </>
);
