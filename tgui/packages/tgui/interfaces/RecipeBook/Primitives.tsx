import { Box, DmIcon, Icon } from 'tgui-core/components';
import { RecipeLink } from './RecipeLink';
import type { Recipe, ItemRef } from './types';

export const Sprite = (props: { icon?: string; icon_state?: string; size?: number }) => {
  const { icon, icon_state, size = 2 } = props;
  if (!icon || !icon_state) return null;
  const fallback = <Icon name="spinner" size={1} spin color="gray" />;
  return <DmIcon fallback={fallback} icon={icon} icon_state={icon_state} height={size} width={size} />;
};

export const SectionHead = (props: { children: any }) => (
  <Box className="RecipeBook__section-head">{props.children}</Box>
);

export const HR = () => <Box className="RecipeBook__hr" />;

export const Badge = (props: { color?: string; children: any }) => (
  <Box as="span" className="RecipeBook__badge" style={{ borderColor: props.color || 'var(--rb-accent)' }}>
    {props.children}
  </Box>
);

export const WarnFlag = (props: { color: string; children: any }) => (
  <Box className="RecipeBook__warn-flag" style={{ color: props.color }}>⚠ {props.children}</Box>
);

export const OutputBanner = (props: {
  icon?: string;
  icon_state?: string;
  name: string;
  count?: number;
  lookup: Map<string, Recipe>;
  pickerMap: Map<string, Recipe[]>;
  allRecipes: Recipe[];
  essenceIndex: Map<string, Recipe[]>;
  onNavigate: (r: Recipe) => void;
}) => {
  const { icon, icon_state, name, count, lookup, pickerMap, allRecipes, essenceIndex, onNavigate } = props;
  return (
    <Box className="RecipeBook__output-banner">
      <span className="RecipeBook__output-label">Creates</span>
      <Box className="RecipeBook__output-body">
        <Sprite icon={icon} icon_state={icon_state} size={2} />
        {count !== undefined && count > 1 ? `${count}× ` : ''}
        <RecipeLink name={name} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={onNavigate} />
      </Box>
    </Box>
  );
};

export const ItemRow = (props: {
  item: ItemRef;
  lookup: Map<string, Recipe>;
  pickerMap: Map<string, Recipe[]>;
  allRecipes: Recipe[];
  essenceIndex: Map<string, Recipe[]>;
  onNavigate: (r: Recipe) => void;
}) => {
  const { item, lookup, pickerMap, allRecipes, essenceIndex, onNavigate } = props;
  return (
    <Box className="RecipeBook__item-row">
      <Sprite icon={item.icon} icon_state={item.icon_state} />
      {item.any ? 'any ' : ''}
      {item.count !== undefined && item.count !== 1 ? `${item.count}× ` : ''}
      <RecipeLink name={item.name} path={item._path} allRecipes={allRecipes} essenceIndex={essenceIndex} lookup={lookup} pickerMap={pickerMap} onNavigate={onNavigate} />
    </Box>
  );
};
