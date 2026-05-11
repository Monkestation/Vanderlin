import { useBackend } from '../backend';
import { useLocalState } from '../backend';
import { Window } from '../layouts';
import { Box } from 'tgui-core/components';
import { Sidebar } from './RecipeBook/Sidebar';
import { RecipeDetail } from './RecipeBook/RecipeDetails';
import type { Recipe, RecipeBookData } from './RecipeBook/types';

export const RecipeBook = (props: any, context: any) => {
  const { data } = useBackend<RecipeBookData>();
  const { book_name, recipes = [], linked_recipes = [] } = data;
  const allRecipes = [...recipes, ...linked_recipes];

  const recipeMultiMap = new Map<string, Recipe[]>();
  const addToMultiMap = (key: string, r: Recipe) => {
    if (!recipeMultiMap.has(key)) recipeMultiMap.set(key, []);
    const existing = recipeMultiMap.get(key)!;
    if (!existing.includes(r)) existing.push(r);
  };

  const essencePrecursorIndex = new Map<string, Recipe[]>();

  for (const r of allRecipes) {
    if (r.type === 'natural_precursor') {
      if (r.yield_names) {
        for (const ename of r.yield_names) {
          const key = ename.toLowerCase();
          if (!essencePrecursorIndex.has(key)) essencePrecursorIndex.set(key, []);
          essencePrecursorIndex.get(key)!.push(r);
        }
      }
      continue;
    }
    if (r.type === 'essence_combination' && r.output_name) {
      const key = r.output_name.toLowerCase();
      if (!essencePrecursorIndex.has(key)) essencePrecursorIndex.set(key, []);
      essencePrecursorIndex.get(key)!.push(r);
    }
    if (r.type === 'snack_processing') {
      for (const rg of r.grind_results || []) addToMultiMap(rg.name.toLowerCase(), r);
      for (const rg of r.juice_results || []) addToMultiMap(rg.name.toLowerCase(), r);
    }
    if (r.name) addToMultiMap(r.name.toLowerCase(), r);
    if (r.output_name) addToMultiMap(r.output_name.toLowerCase(), r);
    if (r._output_path) addToMultiMap(r._output_path, r);
  }

  const recipeLookup = new Map<string, Recipe>();
  const recipePickerMap = new Map<string, Recipe[]>();
  for (const [key, entries] of recipeMultiMap) {
    if (entries.length === 1) recipeLookup.set(key, entries[0]);
    else recipePickerMap.set(key, entries);
  }

  const [selectedRecipe, setSelectedRecipe] = useLocalState<Recipe | null>('rb_selected', null);
  const [history, setHistory] = useLocalState<Recipe[]>('rb_history', []);

  const handleSelect = (r: Recipe) => {
    setHistory([]);
    setSelectedRecipe(r);
  };

  const handleNavigate = (r: Recipe) => {
    setHistory([...(history || []), selectedRecipe!].filter(Boolean) as Recipe[]);
    setSelectedRecipe(r);
  };

  const handleBack = () => {
    const h = [...(history || [])];
    const prev = h.pop();
    setHistory(h);
    setSelectedRecipe(prev || null);
  };

  return (
    <Window title={book_name} width={820} height={600}>
      <Window.Content>
        <Box style={{ position: 'relative', width: '100%', height: '568px', display: 'flex' }}>
          <Sidebar recipes={recipes} lookup={recipeLookup} selectedRecipe={selectedRecipe} onSelect={handleSelect} />
          <Box style={{ flex: 1, height: '100%', overflow: 'hidden', display: 'flex', flexDirection: 'column', background: 'var(--rb-bg)' }}>
            {selectedRecipe ? (
              <RecipeDetail
                recipe={selectedRecipe}
                lookup={recipeLookup}
                pickerMap={recipePickerMap}
                allRecipes={allRecipes}
                essenceIndex={essencePrecursorIndex}
                onNavigate={handleNavigate}
                history={history || []}
                onBack={handleBack}
              />
            ) : (
              <Box style={{ margin: 'auto', color: 'var(--rb-text-muted)', fontStyle: 'italic' }}>
                Select a recipe from the list.
              </Box>
            )}
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};
