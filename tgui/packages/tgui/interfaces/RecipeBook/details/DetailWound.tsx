import { Box } from 'tgui-core/components';
import { SectionHead, WarnFlag } from '../Primitives';
import type { Recipe } from '../types';

export const DetailWound = ({ r }: { r: Recipe }) => (
  <>
    {r.desc && <Box className="RecipeBook__desc" dangerouslySetInnerHTML={{ __html: r.desc }} />}
    <Box className="RecipeBook__severity-badge" style={{ color: r.severity_color }}>
      Severity: <strong>{r.severity_text}</strong>
    </Box>
    {!!r.critical && <WarnFlag color="#cc0000">CRITICAL WOUND</WarnFlag>}
    {!!r.mortal && <WarnFlag color="#880000">MORTAL WOUND</WarnFlag>}
    {!!r.disabling && <WarnFlag color="#cc6600">DISABLING WOUND</WarnFlag>}
    <SectionHead>Wound Stats</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">WHP: {r.whp}</Box>
      {r.passive_healing !== undefined && (
        <Box className="RecipeBook__step-row">Passive healing: {r.passive_healing}/beat</Box>
      )}
      {r.sleep_healing !== undefined && (
        <Box className="RecipeBook__step-row">Sleep healing: {r.sleep_healing}/beat</Box>
      )}
    </Box>
    {(r.can_sew || r.can_cauterize) && (
      <>
        <SectionHead>Treatment</SectionHead>
        <Box className="RecipeBook__step-block">
          {!!r.can_sew && (
            <Box className="RecipeBook__step-row">✂ Sewable ({r.sew_threshold} progress → {r.sewn_whp} WHP)</Box>
          )}
          {!!r.can_cauterize && (
            <Box className="RecipeBook__step-row">🔥 Can be cauterized</Box>
          )}
        </Box>
      </>
    )}
    {r.bleed_rate !== undefined && (
      <>
        <SectionHead>Bleeding</SectionHead>
        <Box className="RecipeBook__step-block">
          <Box className="RecipeBook__step-row">Rate: {r.bleed_rate}</Box>
          {r.sewn_bleed_rate !== undefined && (
            <Box className="RecipeBook__step-row">Rate (sewn): {r.sewn_bleed_rate}</Box>
          )}
          {r.clotting_rate && (
            <Box className="RecipeBook__step-row">
              Clotting: {r.clotting_rate}/beat{r.clotting_threshold !== undefined ? ` → ${r.clotting_threshold}` : ''}
            </Box>
          )}
        </Box>
      </>
    )}
    {r.woundpain !== undefined && (
      <>
        <SectionHead>Pain</SectionHead>
        <Box className="RecipeBook__step-block">
          <Box className="RecipeBook__step-row">
            Pain: {r.woundpain}{r.sewn_woundpain !== undefined ? ` (sewn: ${r.sewn_woundpain})` : ''}
          </Box>
        </Box>
      </>
    )}
    {!!r.special_props?.length && (
      <>
        <SectionHead>Special Properties</SectionHead>
        <Box className="RecipeBook__step-block">
          {r.special_props!.map((sp, i) => (
            <Box key={i} className="RecipeBook__step-row">• {sp}</Box>
          ))}
        </Box>
      </>
    )}
    {r.check_name && (
      <>
        <SectionHead>Diagnosis</SectionHead>
        <Box className="RecipeBook__step-block">
          <Box className="RecipeBook__step-row" dangerouslySetInnerHTML={{ __html: r.check_name! }} />
        </Box>
      </>
    )}
  </>
);
