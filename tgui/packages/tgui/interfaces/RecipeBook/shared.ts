import type { Recipe } from './types';

export type NavProps = {
  r: Recipe;
  lookup: Map<string, Recipe>;
  pickerMap: Map<string, Recipe[]>;
  allRecipes: Recipe[];
  essenceIndex: Map<string, Recipe[]>;
  nav: (r: Recipe) => void;
};
