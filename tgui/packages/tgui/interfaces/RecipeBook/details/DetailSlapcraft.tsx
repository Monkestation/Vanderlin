import { Box } from 'tgui-core/components';
import { SectionHead, OutputBanner, Sprite } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';
import type { SlapcraftStep } from '../types';

export const DetailSlapcraft = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => {
  const steps = r.steps as SlapcraftStep[] | undefined;
  if (!steps) return null;
  const first = steps[0];
  const second = steps[1];
  return (
    <>
      <SectionHead>Steps</SectionHead>
      <Box className="RecipeBook__step-block">
        {second && (() => {
          const parts = second.desc.split(second.name);
          return (
            <Box className="RecipeBook__step-row">
              <Sprite icon={second.icon} icon_state={second.icon_state} />
              {parts.length > 1 ? (
                <>
                  {parts[0]}
                  <RecipeLink name={second.name} path={second._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
                  {parts.slice(1).join(second.name)}
                </>
              ) : (
                <>
                  <RecipeLink name={second.name} path={second._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
                  {' '}{second.verb}
                </>
              )}
            </Box>
          );
        })()}
        {first && (
          <Box className="RecipeBook__step-row">
            <Sprite icon={first.icon} icon_state={first.icon_state} />
            a{' '}
            <RecipeLink name={first.name} path={(first as any)._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
          </Box>
        )}
        {steps.slice(2).map((s, i) => {
          const descParts = s.desc.split(s.name);
          return (
            <Box key={i} className="RecipeBook__step-row">
              <Sprite icon={s.icon} icon_state={s.icon_state} />
              {descParts.length > 1 ? (
                <>
                  {descParts[0]}
                  <RecipeLink name={s.name} path={s._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
                  {descParts.slice(1).join(s.name)}
                </>
              ) : (
                <>
                  {s.desc}{' '}
                  <RecipeLink name={s.name} path={s._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
                </>
              )}
              {!!s.optional && <span className="RecipeBook__step-note"> (optional)</span>}
            </Box>
          );
        })}
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
};
