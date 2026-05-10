import { Box } from 'tgui-core/components';
import { SectionHead, WarnFlag, HR } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';
import type { SurgeryStep } from '../types';

export const DetailSurgery = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => {
  const steps = r.steps as SurgeryStep[] | undefined;
  return (
    <>
      {!!r.heretical && <WarnFlag color="#cc3333">HERETICAL RESEARCH</WarnFlag>}
      {r.desc && <Box className="RecipeBook__desc" dangerouslySetInnerHTML={{ __html: r.desc }} />}
      {!!r.req_bodypart && <WarnFlag color="#ffaaaa">Requires bodypart to be present</WarnFlag>}
      {!!r.req_missing_bodypart && <WarnFlag color="#ffaaaa">Requires bodypart to be MISSING</WarnFlag>}
      {!!r.req_real_bodypart && <WarnFlag color="#ffaaaa">Cannot be performed on prosthetics</WarnFlag>}
      <SectionHead>Procedure</SectionHead>
      {steps?.map((s, i) => (
        <Box key={i} className="RecipeBook__surgery-step">
          <Box className="RecipeBook__surgery-step-title">Step {i + 1}: {s.name}</Box>
          {s.desc && <Box className="RecipeBook__desc" dangerouslySetInnerHTML={{ __html: s.desc }} />}
          {!!s.tools?.length && (
            <Box className="RecipeBook__step-block">
              <strong>Tools:</strong>
              {s.tools!.map((t, ti) => (
                <Box key={ti} className="RecipeBook__step-row">
                  <RecipeLink name={t.name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={nav} />
                  {' '}({t.chance}%)
                </Box>
              ))}
            </Box>
          )}
          {s.skill_name && (
            <Box className="RecipeBook__step-block">
              Min: <span dangerouslySetInnerHTML={{ __html: s.skill_min || '' }} /> / Optimal:{' '}
              <span dangerouslySetInnerHTML={{ __html: s.skill_median || '' }} /> {s.skill_name}
            </Box>
          )}
          {s.chems && (
            <Box className="RecipeBook__step-block"><strong>Chemicals:</strong> {s.chems}</Box>
          )}
          {!!s.flags?.length && (
            <Box className="RecipeBook__step-block">
              {s.flags!.map((f, fi) => (
                <Box key={fi} className="RecipeBook__step-row RecipeBook__step-note">• {f}</Box>
              ))}
            </Box>
          )}
          {(!!s.accept_hand || !!s.accept_any || !s.self_operable || !!s.lying_required || !!s.repeating) && (
            <Box className="RecipeBook__step-block">
              {!!s.accept_hand && <Box className="RecipeBook__step-row RecipeBook__step-note">Can use bare hands</Box>}
              {!!s.accept_any && <Box className="RecipeBook__step-row RecipeBook__step-note">Accepts any item</Box>}
              {!s.self_operable && <Box className="RecipeBook__step-row RecipeBook__step-note">Cannot self-operate</Box>}
              {!!s.lying_required && <Box className="RecipeBook__step-row RecipeBook__step-note">Patient must be lying down</Box>}
              {!!s.repeating && <Box className="RecipeBook__step-row RecipeBook__step-note">Repeatable until failure</Box>}
            </Box>
          )}
          <HR />
        </Box>
      ))}
    </>
  );
};
