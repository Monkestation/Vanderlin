import { useLocalState } from '../../backend';
import { Box, Input } from 'tgui-core/components';
import type { Recipe } from './types';

type Props = {
  recipes: Recipe[];
  lookup: Map<string, Recipe>;
  selectedRecipe: Recipe | null;
  onSelect: (r: Recipe) => void;
};

export const Sidebar = ({ recipes, lookup, selectedRecipe, onSelect }: Props) => {
  const [search, setSearch] = useLocalState('rb_search', '');
  const [category, setCategory] = useLocalState('rb_category', 'All');

  const categories = ['All', ...Array.from(new Set(recipes.map((r) => r.category))).sort()];

  const filtered = recipes.filter((r) => {
    const matchCat = category === 'All' || r.category === category;
    const q = search.toLowerCase();
    const matchSearch = !q || r.name?.toLowerCase().includes(q) || (r.search_data && r.search_data.toLowerCase().includes(q));
    return matchCat && matchSearch;
  });

  return (
    <Box style={{ width: '260px', height: '100%', borderRight: '2px solid var(--rb-border)', background: 'var(--rb-surface-alt)', display: 'flex', flexDirection: 'column' }}>
      <Box style={{ padding: '4px 6px', borderBottom: '1px solid var(--rb-border-faint)', flexShrink: 0 }}>
        <Input fluid placeholder="Search…" value={search} onChange={(value: string) => setSearch(value)} className="RecipeBook__search" />
      </Box>
      <Box style={{ display: 'flex', alignItems: 'center', height: '26px', minHeight: '26px', maxHeight: '26px', borderBottom: '1px solid var(--rb-border-faint)', flexShrink: 0, overflow: 'hidden' }}>
        <span className="RecipeBook__cat-arrow" onClick={() => { const el = document.getElementById('rb-cat-strip'); if (el) el.scrollLeft -= 80; }}>←</span>
        <div id="rb-cat-strip" style={{ display: 'flex', flexWrap: 'nowrap', gap: '3px', overflowX: 'auto', overflowY: 'hidden', flex: 1, alignItems: 'center', scrollbarWidth: 'none' }}>
          {categories.map((cat) => (
            <span key={cat} className={`RecipeBook__cat-pill${category === cat ? ' active' : ''}`} onClick={() => setCategory(cat)}>
              {cat}
            </span>
          ))}
        </div>
        <span className="RecipeBook__cat-arrow" onClick={() => { const el = document.getElementById('rb-cat-strip'); if (el) el.scrollLeft += 80; }}>→</span>
      </Box>
      <Box overflowY="scroll" style={{ flex: 1 }}>
        {!filtered.length && <Box style={{ padding: '10px', color: 'var(--rb-text-muted)', fontStyle: 'italic', textAlign: 'center' }}>No matching recipes.</Box>}
        {filtered.map((r, i) => (
          <Box key={i} className={`RecipeBook__recipe-entry${selectedRecipe === r ? ' active' : ''}`} onClick={() => onSelect(r)}>
            {r.name}
          </Box>
        ))}
      </Box>
    </Box>
  );
};
