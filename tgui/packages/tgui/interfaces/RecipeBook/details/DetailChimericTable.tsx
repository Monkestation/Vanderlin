import { Box } from 'tgui-core/components';
import { SectionHead, Sprite } from '../Primitives';
import { RecipeLink } from '../RecipeLink';
import type { NavProps } from '../shared';
import type { NodeEntry } from '../types';

const NodeList = ({ nodes, color }: { nodes?: NodeEntry[]; color: string }) => {
  if (!nodes?.length) return null;
  return (
    <Box className="RecipeBook__chimeric-pool" style={{ borderColor: color }}>
      {nodes.map((n, i) => (
        <Box key={i} className="RecipeBook__step-row">
          <span style={{ color }}>{n.name}</span>
          <span className="RecipeBook__chimeric-likelihood"> — {n.likelihood}</span>
        </Box>
      ))}
    </Box>
  );
};

export const DetailChimericTable = ({ r, lookup, pickerMap, allRecipes, essenceIndex, nav }: NavProps) => (
  <>
    <SectionHead>Node Info</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">Max tier: {r.node_tier}</Box>
      <Box className="RecipeBook__step-row">
        Purity: {r.purity_min}% – {r.purity_max}% (avg {Math.round(((r.purity_min || 0) + (r.purity_max || 0)) / 2)}%)
      </Box>
    </Box>
    <SectionHead>Blood Cost</SectionHead>
    <Box className="RecipeBook__step-block">
      <Box className="RecipeBook__step-row">Base: {r.base_blood_cost}u/beat</Box>
      <Box className="RecipeBook__step-row" style={{ color: 'green' }}>
        Preferred: −{((r.pref_bonus || 0) * 100).toFixed(0)}%
      </Box>
      <Box className="RecipeBook__step-row" style={{ color: 'red' }}>
        Incompatible: +{((r.incompat_penalty || 0) * 100).toFixed(0)}%
      </Box>
    </Box>
    {!!(r.preferred_blood?.length || r.compatible_blood?.length || r.incompatible_blood?.length) && (
      <>
        <SectionHead>Blood Types</SectionHead>
        <Box className="RecipeBook__step-block">
          {r.preferred_blood?.map((b, i) => (
            <Box key={i} className="RecipeBook__step-row" style={{ color: 'green' }}>★ {b}</Box>
          ))}
          {r.compatible_blood?.map((b, i) => (
            <Box key={i} className="RecipeBook__step-row" style={{ color: 'cyan' }}>✓ {b}</Box>
          ))}
          {r.incompatible_blood?.map((b, i) => (
            <Box key={i} className="RecipeBook__step-row" style={{ color: 'red' }}>✗ {b}</Box>
          ))}
        </Box>
      </>
    )}
    <SectionHead>Input Nodes</SectionHead>
    <NodeList nodes={r.input_nodes} color="cyan" />
    <SectionHead>Output Nodes</SectionHead>
    <NodeList nodes={r.output_nodes} color="orange" />
    <SectionHead>Special Nodes</SectionHead>
    <NodeList nodes={r.special_nodes} color="purple" />
    {!!r.source_mobs?.length && (
      <>
        <SectionHead>Blood Source Mobs</SectionHead>
        <Box className="RecipeBook__step-block">
          {r.source_mobs.map((mob, i) => (
            <Box key={i} className="RecipeBook__step-row">
              <Sprite icon={mob.icon} icon_state={mob.icon_state} />
              <RecipeLink
                name={mob.name}
                path={mob._path}
                allRecipes={allRecipes}
                essenceIndex={essenceIndex}
                lookup={lookup}
                pickerMap={pickerMap}
                onNavigate={nav}
              />
            </Box>
          ))}
        </Box>
      </>
    )}
  </>
);
