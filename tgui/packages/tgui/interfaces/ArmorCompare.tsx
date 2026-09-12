import { useState } from 'react';
import { useBackend } from '../backend';
import { Box, Button, Icon, Input, Section, Table } from 'tgui-core/components';
import { Window } from '../layouts';

type ArmorEntry = {
  type: string;
  armor_class: string | number;
  blunt: number;
  slash: number;
  stab: number;
  piercing: number;
  fire: number;
  acid: number;
  magic: number;
  wound: number;
  slash_ep: number;
  stab_ep: number;
  piercing_ep: number;
};

type ArmorCompareData = {
  armors: ArmorEntry[];
  usage_built?: boolean;
  item_usage?: Record<string, string[]>;
};

const RATINGS: (keyof Omit<ArmorEntry, 'type'>)[] = [
  'blunt',
  'slash',
  'stab',
  'piercing',
  'fire',
  'acid',
  'magic',
  'wound',
  'slash_ep',
  'stab_ep',
  'piercing_ep',
];

const RATING_LABELS: Record<string, string> = {
  blunt: 'Blunt',
  slash: 'Slash',
  stab: 'Stab',
  piercing: 'Pierce',
  fire: 'Fire',
  acid: 'Acid',
  magic: 'Magic',
  wound: 'Wound',
  slash_ep: "Slash EP",
  stab_ep: "Stab EP",
  piercing_ep: "Piercing EP",
};

type SortDirection = 'default' | 'asc' | 'desc';

// Mirrors armor_to_color() on the DM side
function armorColor(value: number): string {
  if (value >= 100) return '#1F3FBF';
  if (value >= 75) return '#00FF00';
  if (value >= 50) return '#7CFF7C';
  if (value >= 25) return '#fffb00';
  if (value > 0) return '#ff8800';
  return '#FF0000';
}

export const ArmorCompare = (props) => {
  const { data, act } = useBackend<ArmorCompareData>();
  const armors = data.armors || [];
  const usageBuilt = !!data.usage_built;
  const itemUsage = data.item_usage || {};

  const [search, setSearch] = useState('');
  const [sortKey, setSortKey] = useState<keyof ArmorEntry | null>(null);
  const [sortDirection, setSortDirection] = useState<SortDirection>('default');
  const [compareSlots, setCompareSlots] = useState<(ArmorEntry | null)[]>([
    null,
    null,
  ]);
  const [viewingType, setViewingType] = useState<string | null>(null);

  // Clicking a column header cycles asc -> desc -> default (unsorted)
  const handleSortClick = (key: keyof ArmorEntry) => {
    if (sortKey !== key) {
      setSortKey(key);
      setSortDirection('asc');
      return;
    }
    if (sortDirection === 'asc') {
      setSortDirection('desc');
    } else if (sortDirection === 'desc') {
      setSortKey(null);
      setSortDirection('default');
    } else {
      setSortDirection('asc');
    }
  };

  const lowerSearch = (search || '').toLowerCase();

  const handleSearchInput = (a: any, b: any) => {
    if (typeof b === 'string') {
      setSearch(b);
      return;
    }
    if (typeof a === 'string') {
      setSearch(a);
      return;
    }
    if (a?.target && typeof a.target.value === 'string') {
      setSearch(a.target.value);
      return;
    }
    if (typeof a?.value === 'string') {
      setSearch(a.value);
    }
  };

  const armorMatchesUsage = (armor: ArmorEntry) => {
    if (!usageBuilt || !lowerSearch) return false;
    const items = itemUsage[armor.type];
    if (!items) return false;
    return items.some((path) => path.toLowerCase().includes(lowerSearch));
  };

  const filteredArmors = armors.filter(
    (armor) =>
      !lowerSearch ||
      armor.type.toLowerCase().includes(lowerSearch) ||
      armorMatchesUsage(armor)
  );

  const sortedArmors =
    sortKey && sortDirection !== 'default'
      ? [...filteredArmors].sort((a, b) => {
          const diff = (a[sortKey] as number) - (b[sortKey] as number);
          return sortDirection === 'asc' ? diff : -diff;
        })
      : filteredArmors;

  const addToCompare = (armor: ArmorEntry) => {
    setCompareSlots(([first, second]) => {
      if (first?.type === armor.type || second?.type === armor.type) {
        return [first, second];
      }
      if (!first) {
        return [armor, second];
      }
      if (!second) {
        return [first, armor];
      }
      return [first, armor];
    });
  };

  const removeFromCompare = (index: number) => {
    setCompareSlots((slots) => {
      const updated = [...slots];
      updated[index] = null;
      return updated;
    });
  };

  const renderSortIcon = (key: keyof ArmorEntry) => {
    if (sortKey !== key || sortDirection === 'default') {
      return <Icon name="sort" opacity={0.35} ml={0.5} />;
    }
    return (
      <Icon
        name={sortDirection === 'asc' ? 'sort-up' : 'sort-down'}
        ml={0.5}
      />
    );
  };

  const renderCompareArrow = (index: number, rating: keyof ArmorEntry) => {
    const [first, second] = compareSlots;
    if (!first || !second) {
      return null;
    }
    const self = index === 0 ? first : second;
    const other = index === 0 ? second : first;
    if (self[rating] === other[rating]) {
      return null;
    }
    const isBetter = (self[rating] as number) > (other[rating] as number);
    return (
      <Icon
        name={isBetter ? 'caret-up' : 'caret-down'}
        color={isBetter ? 'good' : 'bad'}
        ml={1}
      />
    );
  };

  const viewingItems = viewingType ? itemUsage[viewingType] || [] : [];

  return (
    <Window width={1200} height={680}>
      <Window.Content scrollable>
        <Section
          title="Compare"
          buttons={
            <Box color="label" fontSize="0.9em">
              Click an armor below to add it here. Click a filled slot to
              remove it.
            </Box>
          }
        >
          <Table>
            <Table.Row header>
              <Table.Cell>Slot</Table.Cell>
              <Table.Cell collapsing width="80px">Class</Table.Cell>
              {RATINGS.map((rating) => (
                <Table.Cell key={rating} collapsing>
                  {RATING_LABELS[rating]}
                </Table.Cell>
              ))}
            </Table.Row>
            {compareSlots.map((armor, index) => (
              <Table.Row key={index}>
                <Table.Cell>
                  {armor ? (
                    <Button
                      icon="times"
                      content={armor.type}
                      onClick={() => removeFromCompare(index)}
                    />
                  ) : (
                    <Box color="label" italic>
                      Empty slot
                    </Box>
                  )}
                </Table.Cell>
                <Table.Cell>{armor ? armor.armor_class : '-'}</Table.Cell>
                {RATINGS.map((rating) => (
                  <Table.Cell key={rating}>
                    {armor ? (
                      <>
                        <Box inline color={armorColor(armor[rating] as number)}>
                          {armor[rating]}
                        </Box>
                        {renderCompareArrow(index, rating)}
                      </>
                    ) : (
                      '-'
                    )}
                  </Table.Cell>
                ))}
              </Table.Row>
            ))}
          </Table>
        </Section>

        {viewingType && (
          <Section
            title={`Items using ${viewingType}`}
            buttons={
              <Button
                icon="times"
                content="Close"
                onClick={() => setViewingType(null)}
              />
            }
          >
            {viewingItems.length === 0 ? (
              <Box color="label" italic>
                No item types default to this armor directly (it may only be
                applied dynamically, e.g. via set_armor).
              </Box>
            ) : (
              <Box
                as="ul"
                style={{
                  margin: 0,
                  paddingLeft: '1.2em',
                  maxHeight: '220px',
                  overflowY: 'auto',
                }}
              >
                {viewingItems.map((path) => (
                  <Box as="li" key={path} fontFamily="monospace" fontSize="0.85em">
                    {path}
                  </Box>
                ))}
              </Box>
            )}
          </Section>
        )}

        <Section
          title="Armor Types"
          fill
          scrollable
          buttons={
            <Button
              icon={usageBuilt ? 'check' : 'magnifying-glass'}
              content={usageBuilt ? 'Item usage scanned' : 'Scan item usage'}
              disabled={usageBuilt}
              onClick={() => act('build_usage')}
            />
          }
        >
          <Input
            fluid
            placeholder={
              usageBuilt
                ? 'Search by armor type or item path...'
                : 'Search by type... (scan item usage to also search by item)'
            }
            value={search}
            onInput={handleSearchInput}
            mb={1}
          />
          <Table>
            <Table.Row header>
              <Table.Cell>Type</Table.Cell>
              <Table.Cell width="80px">Class</Table.Cell>
              <Table.Cell collapsing>Used By</Table.Cell>
              {RATINGS.map((rating) => (
                <Table.Cell
                  key={rating}
                  collapsing
                  style={{ cursor: 'pointer', userSelect: 'none' }}
                  onClick={() => handleSortClick(rating)}
                >
                  {RATING_LABELS[rating]}
                  {renderSortIcon(rating)}
                </Table.Cell>
              ))}
            </Table.Row>
            {sortedArmors.map((armor) => {
              const inCompare = compareSlots.some(
                (slot) => slot?.type === armor.type
              );
              const usageCount = itemUsage[armor.type]?.length ?? 0;
              return (
                <Table.Row
                  key={armor.type}
                  className="candystripe"
                  style={{
                    cursor: inCompare ? 'default' : 'pointer',
                    opacity: inCompare ? 0.5 : 1,
                  }}
                  onClick={() => !inCompare && addToCompare(armor)}
                >
                  <Table.Cell>{armor.type}</Table.Cell>
                  <Table.Cell>{armor.armor_class}</Table.Cell>
                  <Table.Cell>
                    {usageBuilt ? (
                      <Button
                        compact
                        icon="list"
                        content={`${usageCount}`}
                        disabled={usageCount === 0}
                        onClick={(e: any) => {
                          e?.stopPropagation?.();
                          setViewingType(armor.type);
                        }}
                      />
                    ) : (
                      <Box color="label">—</Box>
                    )}
                  </Table.Cell>
                  {RATINGS.map((rating) => (
                    <Table.Cell key={rating}>
                      <Box color={armorColor(armor[rating] as number)}>
                        {armor[rating]}
                      </Box>
                    </Table.Cell>
                  ))}
                </Table.Row>
              );
            })}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
