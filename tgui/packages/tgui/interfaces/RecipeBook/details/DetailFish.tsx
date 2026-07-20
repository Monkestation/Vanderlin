import { Box } from 'tgui-core/components';
import { SectionHead } from '../Primitives';
import type { Recipe } from '../types';

export const DetailFish = ({ r }: { r: Recipe }) => {
  const diffColor = r.difficulty === 'Hard' ? '#d9534f' : r.difficulty === 'Medium' ? '#f0ad4e' : '#5cb85c';
  return (
    <>
      {r.desc && <Box className="RecipeBook__desc" dangerouslySetInnerHTML={{ __html: r.desc }} />}
      <SectionHead>Physical</SectionHead>
      <Box className="RecipeBook__step-block">
        <Box className="RecipeBook__step-row">Size: {r.avg_size}cm</Box>
        <Box className="RecipeBook__step-row">Weight: {r.avg_weight}g</Box>
      </Box>
      <SectionHead>Environment</SectionHead>
      <Box className="RecipeBook__step-block">
        <Box className="RecipeBook__step-row">Fluid: {r.fluid_type}</Box>
        <Box className="RecipeBook__step-row">Temperature: {r.temp_min}C – {r.temp_max}C</Box>
      </Box>
      <SectionHead>Fishing</SectionHead>
      <Box className="RecipeBook__step-block">
        <Box className="RecipeBook__step-row">Found: {r.spots}</Box>
        <Box className="RecipeBook__step-row">
          Difficulty: <span style={{ color: diffColor }}>{r.difficulty}</span>
        </Box>
        <Box className="RecipeBook__step-row">Favourite bait: {r.fav_bait}</Box>
        <Box className="RecipeBook__step-row">Disliked bait: {r.dislike_bait}</Box>
        {r.lures?.map((l, i) => (
          <Box key={i} className="RecipeBook__step-row">• {l}</Box>
        ))}
      </Box>
      {!!r.traits?.length && (
        <>
          <SectionHead>Behaviour</SectionHead>
          <Box className="RecipeBook__step-block">
            {r.traits!.map((t, i) => (
              <Box key={i} className="RecipeBook__step-row">• {t}</Box>
            ))}
          </Box>
        </>
      )}
    </>
  );
};
