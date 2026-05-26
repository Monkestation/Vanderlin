import { Box } from 'tgui-core/components';
import type { Recipe } from '../types';

export const DetailBookEntry = ({ r }: { r: Recipe }) => (
  <Box className="RecipeBook__lore-content" dangerouslySetInnerHTML={{ __html: r.html || '' }} />
);
