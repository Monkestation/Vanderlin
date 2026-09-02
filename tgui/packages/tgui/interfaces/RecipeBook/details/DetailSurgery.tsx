import { Box } from 'tgui-core/components';
import { SectionHead, WarnFlag, HR } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';
import { capitalize } from 'tgui-core/string';

export const DetailSurgery = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => {
  return (
    <>
      {!!r.heretical && <WarnFlag color="#cc3333">HERETICAL RESEARCH</WarnFlag>}
      {r.desc && <Box className="RecipeBook__desc" dangerouslySetInnerHTML={{ __html: r.desc }} />}
      <SectionHead>Procedure</SectionHead>
      <Box className="RecipeBook__surgery-step">
        {!!r.implements?.length && (
          <Box className="RecipeBook__step-block">
            <strong>Tools:</strong>
            {r.implements!.map((t, ti) => (
              <Box key={ti} className="RecipeBook__step-row">
                <RecipeLink name={t.name.replace("_", " ")} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} /> {t.modifier}x Operation time
              </Box>
            ))}
          </Box>
        )}
        {r.skill_name && (
          <Box className="RecipeBook__step-block">
            <strong>Skill {r.skill_name}:</strong>
            <Box>
              Minimum: <span dangerouslySetInnerHTML={{ __html: r.min_skill || 'None' }} /> / Optimal: <span dangerouslySetInnerHTML={{ __html: r.median_skill || 'None' }} />
            </Box>
          </Box>
        )}
        <Box>
        {!!r.hard_requirements?.length && (
          <Box className="RecipeBook__step-block">
            <strong>Hard Requirements:</strong>
            {r.hard_requirements.map((string, index) => (
              <Box key={index} className="RecipeBook__step-row">
                {capitalize(string)}
              </Box>
            ))}
          </Box>
        )}
        </Box>
        <Box>
        {!!r.soft_requirements?.length && (
          <Box className="RecipeBook__step-block">
            <strong>Soft Requirements:</strong>
            {r.soft_requirements.map((string, index) => (
              <Box key={index} className="RecipeBook__step-row">
                {capitalize(string)}
              </Box>
            ))}
          </Box>
        )}
        </Box>
        <Box>
        {!!r.optional_requirements?.length && (
          <Box className="RecipeBook__step-block">
            <strong>Optional Requirements:</strong>
            {r.optional_requirements.map((string, index) => (
              <Box key={index} className="RecipeBook__step-row">
                {capitalize(string)}
              </Box>
            ))}
          </Box>
        )}
        </Box>
        <Box>
        {!!r.blocker_requirements?.length && (
          <Box className="RecipeBook__step-block">
            <strong>Blocking Requirements:</strong>
            {r.blocker_requirements.map((string, index) => (
              <Box key={index} className="RecipeBook__step-row">
                {capitalize(string)}
              </Box>
            ))}
          </Box>
        )}
        </Box>
        <HR />
      </Box>
    </>
  );
};
