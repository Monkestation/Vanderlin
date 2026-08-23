import { Box } from 'tgui-core/components';
import { SectionHead, Sprite } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';

export const DetailObtainedFrom = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
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
  </>
);
