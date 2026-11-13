import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
  Box,
  Button,
  Divider,
  Flex,
  Icon,
  Input,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type LootEntry = {
  path: string;
  value: number;
  is_table: boolean;
  odds: number;
  effective: number;
};

type LootTable = {
  path: string;
  name: string;
  cascading: boolean;
  luck_chance_bonus: number;
  req_keys: string[];
  min_level: number;
  growth_factor: number | null;
  rolls: number;
  base_min: number;
  base_max: number;
  scaling_factor: number;
  entries: LootEntry[];
  reach: number;
  nothing: number;
};

type LastRoll = {
  found: boolean;
  path?: string;
  name?: string;
  icon?: string;
  route: string[];
};

type TallyRow = {
  path: string;
  name: string;
  count: number;
  pct: number;
};

type Data = {
  tables: LootTable[];
  root: string | null;
  selected: string | null;
  notice: string | null;
  search_results: string[];
  last_roll: LastRoll | null;
  tally: TallyRow[] | null;
  tally_runs: number;
  tally_nothing: number;
  export_text: string | null;
  loadable: string[];
};

type NodePos = { x: number; y: number };

const NODE_W = 220;
const NODE_H = 120;
const H_GAP = 40;
const V_GAP = 60;

function layoutTables(
  tables: LootTable[],
  root: string | null,
  existing: Record<string, NodePos>,
): Record<string, NodePos> {
  const byPath = Object.fromEntries(tables.map((t) => [t.path, t]));
  const positions: Record<string, NodePos> = { ...existing };

  if (!root || !byPath[root]) return positions;

  const visited = new Set<string>();
  const queue: { path: string; depth: number; index: number }[] = [
    { path: root, depth: 0, index: 0 },
  ];
  const depthCounts: Record<number, number> = {};

  while (queue.length) {
    const { path, depth, index } = queue.shift()!;
    if (visited.has(path) || !byPath[path]) continue;
    visited.add(path);

    const col = depthCounts[depth] ?? 0;
    depthCounts[depth] = col + 1;

    if (!positions[path]) {
      positions[path] = {
        x: 40 + col * (NODE_W + H_GAP),
        y: 40 + depth * (NODE_H + V_GAP),
      };
    }

    const table = byPath[path];
    let childIdx = 0;
    for (const entry of table.entries) {
      if (entry.is_table && !visited.has(entry.path)) {
        queue.push({ path: entry.path, depth: depth + 1, index: childIdx++ });
      }
    }
  }

  let orphanY = 40;
  for (const t of tables) {
    if (!positions[t.path]) {
      positions[t.path] = { x: 40, y: orphanY };
      orphanY += NODE_H + V_GAP;
    }
  }

  return positions;
}

function ConnectionLines({
  tables,
  positions,
  selected,
}: {
  tables: LootTable[];
  positions: Record<string, NodePos>;
  selected: string | null;
}) {
  const byPath = Object.fromEntries(tables.map((t) => [t.path, t]));
  const lines: JSX.Element[] = [];

  for (const table of tables) {
    const from = positions[table.path];
    if (!from) continue;

    for (const entry of table.entries) {
      if (!entry.is_table) continue;
      const to = positions[entry.path];
      if (!to) continue;

      const x1 = from.x + NODE_W;
      const y1 = from.y + NODE_H / 2;
      const x2 = to.x;
      const y2 = to.y + NODE_H / 2;
      const midX = (x1 + x2) / 2;

      const isHot =
        selected === table.path || selected === entry.path;

      lines.push(
        <path
          key={`${table.path}->${entry.path}`}
          d={`M ${x1} ${y1} C ${midX} ${y1}, ${midX} ${y2}, ${x2} ${y2}`}
          fill="none"
          stroke={isHot ? '#5ba4e5' : '#3a4a5a'}
          strokeWidth={isHot ? 2.5 : 1.5}
          markerEnd="url(#arrowhead)"
        />,
      );
    }
  }

  return (
    <svg
      style={{
        position: 'absolute',
        inset: 0,
        width: '100%',
        height: '100%',
        pointerEvents: 'none',
        overflow: 'visible',
      }}
    >
      <defs>
        <marker
          id="arrowhead"
          markerWidth="8"
          markerHeight="6"
          refX="7"
          refY="3"
          orient="auto"
        >
          <polygon points="0 0, 8 3, 0 6" fill="#5ba4e5" />
        </marker>
      </defs>
      {lines}
    </svg>
  );
}

function TableNode({
  table,
  isRoot,
  isSelected,
  pos,
  onSelect,
  onDragStart,
}: {
  table: LootTable;
  isRoot: boolean;
  isSelected: boolean;
  pos: NodePos;
  onSelect: () => void;
  onDragStart: (e: React.MouseEvent) => void;
}) {
  const entryCount = table.entries.length;
  const subCount = table.entries.filter((e) => e.is_table).length;
  const itemCount = entryCount - subCount;

  return (
    <Box
      className="LootNode"
      style={{
        position: 'absolute',
        left: pos.x,
        top: pos.y,
        width: NODE_W,
        minHeight: NODE_H,
        background: isSelected
          ? 'linear-gradient(145deg, #1a2a3a, #0d1520)'
          : 'linear-gradient(145deg, #161e28, #0c1018)',
        border: isSelected
          ? '2px solid #5ba4e5'
          : isRoot
            ? '2px solid #c9a227'
            : '1px solid #2a3545',
        borderRadius: 6,
        boxShadow: isSelected
          ? '0 0 12px rgba(91,164,229,0.4)'
          : '0 4px 12px rgba(0,0,0,0.5)',
        cursor: 'grab',
        userSelect: 'none',
        zIndex: isSelected ? 10 : 1,
      }}
      onMouseDown={onDragStart}
      onClick={(e) => {
        e.stopPropagation();
        onSelect();
      }}
    >
      <Box
        style={{
          padding: '6px 10px',
          background: isRoot
            ? 'rgba(201,162,39,0.15)'
            : 'rgba(91,164,229,0.08)',
          borderBottom: '1px solid #2a3545',
          borderRadius: '4px 4px 0 0',
          fontWeight: 'bold',
          fontSize: '13px',
          whiteSpace: 'nowrap',
          overflow: 'hidden',
          textOverflow: 'ellipsis',
        }}
      >
        {table.name || 'Unnamed'}
      </Box>

      <Box style={{ padding: '8px 10px', fontSize: '11px' }}>
        <Box color="label">
          {!!table.cascading ? 'Cascading' : 'Weighted'}
          {!!table.cascading && table.luck_chance_bonus
            ? ` (+${table.luck_chance_bonus} luck)`
            : ''}
        </Box>
        <Box mt={0.5}>
          {itemCount} item{itemCount !== 1 ? 's' : ''} · {subCount} sub
          {subCount !== 1 ? 's' : ''}
        </Box>
        {table.reach > 0 && (
          <Box color="good" mt={0.3}>
            Reach {table.reach.toFixed(1)}%
            {table.nothing > 0.5 && (
              <span style={{ color: '#888' }}>
                {' '}
                · nothing {table.nothing.toFixed(1)}%
              </span>
            )}
          </Box>
        )}
        <Box
          color="label"
          style={{
            marginTop: 4,
            fontSize: '10px',
            opacity: 0.7,
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
          }}
        >
          {table.path.replace('/datum/loot_table/', '')}
        </Box>
      </Box>

      <Box
        style={{
          position: 'absolute',
          left: -6,
          top: '50%',
          width: 12,
          height: 12,
          borderRadius: '50%',
          background: '#3a4a5a',
          border: '2px solid #5ba4e5',
          transform: 'translateY(-50%)',
        }}
      />
      <Box
        style={{
          position: 'absolute',
          right: -6,
          top: '50%',
          width: 12,
          height: 12,
          borderRadius: '50%',
          background: '#3a4a5a',
          border: '2px solid #5ba4e5',
          transform: 'translateY(-50%)',
        }}
      />
    </Box>
  );
}

function BlueprintCanvas({
  tables,
  root,
  selected,
  onSelect,
}: {
  tables: LootTable[];
  root: string | null;
  selected: string | null;
  onSelect: (path: string) => void;
}) {
  const [positions, setPositions] = useState<Record<string, NodePos>>({});
  const [pan, setPan] = useState({ x: 0, y: 0 });
  const [zoom, setZoom] = useState(1);
  const dragRef = useRef<{
    type: 'node' | 'pan';
    path?: string;
    startX: number;
    startY: number;
    origX: number;
    origY: number;
  } | null>(null);
  const canvasRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    setPositions((prev) => layoutTables(tables, root, prev));
  }, [tables, root]);

  const onMouseDownNode = useCallback(
    (e: React.MouseEvent, path: string) => {
      e.preventDefault();
      e.stopPropagation();
      const pos = positions[path] || { x: 0, y: 0 };
      dragRef.current = {
        type: 'node',
        path,
        startX: e.clientX,
        startY: e.clientY,
        origX: pos.x,
        origY: pos.y,
      };
      onSelect(path);
    },
    [positions, onSelect],
  );

  const onMouseDownCanvas = useCallback((e: React.MouseEvent) => {
    if (e.button !== 0 && e.button !== 1) return;
    if (e.button === 1 || (e.target as HTMLElement).dataset.canvas) {
      e.preventDefault();
      dragRef.current = {
        type: 'pan',
        startX: e.clientX,
        startY: e.clientY,
        origX: pan.x,
        origY: pan.y,
      };
    }
  }, [pan]);

  useEffect(() => {
    const onMove = (e: MouseEvent) => {
      const d = dragRef.current;
      if (!d) return;
      const dx = (e.clientX - d.startX) / zoom;
      const dy = (e.clientY - d.startY) / zoom;

      if (d.type === 'node' && d.path) {
        setPositions((prev) => ({
          ...prev,
          [d.path!]: { x: d.origX + dx, y: d.origY + dy },
        }));
      } else if (d.type === 'pan') {
        setPan({ x: d.origX + dx * zoom, y: d.origY + dy * zoom });
      }
    };
    const onUp = () => {
      dragRef.current = null;
    };
    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
    return () => {
      window.removeEventListener('mousemove', onMove);
      window.removeEventListener('mouseup', onUp);
    };
  }, [zoom]);

  const onWheel = useCallback((e: React.WheelEvent) => {
    e.preventDefault();
    setZoom((z) => Math.min(2, Math.max(0.4, z - e.deltaY * 0.001)));
  }, []);

  return (
    <Box
      data-canvas="true"
      style={{
        position: 'relative',
        width: '100%',
        height: '100%',
        overflow: 'hidden',
        background:
          'radial-gradient(circle at 50% 50%, #0e141c 0%, #080b10 100%)',
        backgroundImage:
          'linear-gradient(#1a222e 1px, transparent 1px), linear-gradient(90deg, #1a222e 1px, transparent 1px)',
        backgroundSize: `${24 * zoom}px ${24 * zoom}px`,
        backgroundPosition: `${pan.x}px ${pan.y}px`,
        cursor: dragRef.current?.type === 'pan' ? 'grabbing' : 'default',
      }}
      onMouseDown={onMouseDownCanvas}
      onWheel={onWheel}
    >
      <Box
        style={{
          transform: `translate(${pan.x}px, ${pan.y}px) scale(${zoom})`,
          transformOrigin: '0 0',
          position: 'absolute',
          inset: 0,
        }}
      >
        <ConnectionLines
          tables={tables}
          positions={positions}
          selected={selected}
        />
        {tables.map((t) => (
          <TableNode
            key={t.path}
            table={t}
            isRoot={t.path === root}
            isSelected={t.path === selected}
            pos={positions[t.path] || { x: 0, y: 0 }}
            onSelect={() => onSelect(t.path)}
            onDragStart={(e) => onMouseDownNode(e, t.path)}
          />
        ))}
      </Box>

      <Box
        style={{
          position: 'absolute',
          bottom: 8,
          right: 8,
          display: 'flex',
          gap: 4,
        }}
      >
        <Button
          icon="search-minus"
          compact
          onClick={() => setZoom((z) => Math.max(0.4, z - 0.1))}
        />
        <Button
          compact
          onClick={() => {
            setZoom(1);
            setPan({ x: 0, y: 0 });
          }}
        >
          {Math.round(zoom * 100)}%
        </Button>
        <Button
          icon="search-plus"
          compact
          onClick={() => setZoom((z) => Math.min(2, z + 0.1))}
        />
      </Box>
    </Box>
  );
}

function TableInspector({
  table,
  isRoot,
  searchResults,
  onSearch,
}: {
  table: LootTable | null;
  isRoot: boolean;
  searchResults: string[];
  onSearch: (q: string) => void;
}) {
  const { act } = useBackend<Data>();
  const [searchQuery, setSearchQuery] = useState('');
  const [addPath, setAddPath] = useState('');
  const [subName, setSubName] = useState('');

  if (!table) {
    return (
      <Section fill title="Inspector">
        <Box color="label" textAlign="center" mt={4}>
          Select a node or create a new root table.
        </Box>
      </Section>
    );
  }

  const setVar = (varName: string, value: string | number | boolean) => {
    act('set_table_var', {
      table: table.path,
      var: varName,
      value,
    });
  };

  return (
    <Section
      fill
      scrollable
      title={table.name}
      buttons={
        <Button
          icon="copy"
          tooltip="Copy path"
          compact
          onClick={() => navigator.clipboard?.writeText(table.path)}
        />
      }
    >
      <Box color="label" fontSize="11px" mb={1}>
        {table.path}
      </Box>

      <LabeledList>
        <LabeledList.Item label="Name">
          <Input
            fluid
            value={table.name}
            onChange={(v) => setVar('name', v)}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Mode">
          <Button
            selected={!table.cascading}
            onClick={() => setVar('cascading', 0)}
          >
            Weighted
          </Button>
          <Button
            selected={table.cascading}
            onClick={() => setVar('cascading', 1)}
          >
            Cascading
          </Button>
        </LabeledList.Item>
        {!!table.cascading && (
          <LabeledList.Item label="Luck bonus">
            <NumberInput
              width="60px"
              value={table.luck_chance_bonus}
              minValue={0}
              maxValue={20}
              step={0.5}
              onChange={(v) => setVar('luck_chance_bonus', v)}
            />
          </LabeledList.Item>
        )}
        {!isRoot && (
          <>
            <LabeledList.Item label="Req keys">
              <Input
                fluid
                value={table.req_keys.join(', ')}
                placeholder="STAT_FORTUNE, /datum/attribute/skill/..."
                onChange={(v) => setVar('req_keys', v)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Min level">
              <NumberInput
                width="60px"
                value={table.min_level}
                minValue={0}
                maxValue={100}
                step={1}
                onChange={(v) => setVar('min_level', v)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Growth">
              <NumberInput
                width="70px"
                value={table.growth_factor ?? 0}
                minValue={0}
                maxValue={5}
                step={0.01}
                stepPixelSize={4}
                onChange={(v) => setVar('growth_factor', v || 0)}
              />
              <Box inline color="label" ml={1} fontSize="11px">
                0 = default
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Rolls">
              <NumberInput
                width="60px"
                value={table.rolls}
                minValue={1}
                maxValue={20}
                step={1}
                onChange={(v) => setVar('rolls', v)}
              />
            </LabeledList.Item>
          </>
        )}
        {isRoot && (
          <>
            <LabeledList.Item label="Base min">
              <NumberInput
                width="60px"
                value={table.base_min}
                minValue={0}
                maxValue={50}
                step={1}
                onChange={(v) => setVar('base_min', v)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Base max">
              <NumberInput
                width="60px"
                value={table.base_max}
                minValue={0}
                maxValue={50}
                step={1}
                onChange={(v) => setVar('base_max', v)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Scaling">
              <NumberInput
                width="70px"
                value={table.scaling_factor}
                minValue={0}
                maxValue={5}
                step={0.05}
                onChange={(v) => setVar('scaling_factor', v)}
              />
            </LabeledList.Item>
          </>
        )}
      </LabeledList>

      <Divider />

      <Box fontWeight="bold" mb={0.5}>
        Entries ({table.entries.length})
        {table.nothing > 0.5 && (
          <Box inline color="average" ml={1} fontSize="11px">
            nothing {table.nothing.toFixed(1)}%
          </Box>
        )}
        {!!table.cascading && table.entries.length > 1 && (
          <Button
            icon="sort-amount-up"
            compact
            ml={1}
            tooltip="Sort entries lowest to highest"
            onClick={() =>
              act('sort_entries', {
                table: table.path,
                ascending: 1,
              })
            }
          >
            Sort ↑
          </Button>
        )}
            </Box>

      {table.entries.map((entry, i) => (
        <Box
          key={`${entry.path}-${i}`}
          style={{
            background: i % 2 ? 'rgba(255,255,255,0.03)' : 'transparent',
            padding: '4px 6px',
            borderRadius: 3,
            marginBottom: 2,
          }}
        >
          <Flex align="center">
            <Flex.Item grow>
              <Box
                fontSize="12px"
                color={entry.is_table ? 'good' : undefined}
                style={{
                  whiteSpace: 'nowrap',
                  overflow: 'hidden',
                  textOverflow: 'ellipsis',
                  maxWidth: 180,
                }}
              >
                {!!entry.is_table && <Icon name="sitemap" mr={0.5} />}
                {entry.path.split('/').pop()}
              </Box>
              <Box fontSize="10px" color="label">
                odds {entry.odds.toFixed(1)}% · eff{' '}
                {entry.effective.toFixed(2)}%
              </Box>
            </Flex.Item>
            <Flex.Item>
              <NumberInput
                width="55px"
                value={entry.value}
                minValue={0}
                maxValue={table.cascading ? 100 : 9999}
                step={table.cascading ? 1 : 5}
                onChange={(v) =>
                  act('set_entry', {
                    table: table.path,
                    index: i + 1,
                    value: v,
                  })
                }
              />
            </Flex.Item>
            <Flex.Item>
              <Button
                icon="arrow-up"
                compact
                disabled={i === 0}
                onClick={() =>
                  act('move_entry', {
                    table: table.path,
                    index: i + 1,
                    dir: -1,
                  })
                }
              />
              <Button
                icon="arrow-down"
                compact
                disabled={i === table.entries.length - 1}
                onClick={() =>
                  act('move_entry', {
                    table: table.path,
                    index: i + 1,
                    dir: 1,
                  })
                }
              />
              <Button
                icon="trash"
                color="bad"
                compact
                onClick={() =>
                  act('remove_entry', {
                    table: table.path,
                    index: i + 1,
                  })
                }
              />
            </Flex.Item>
          </Flex>
        </Box>
      ))}

      <Divider />

      <Box fontWeight="bold" mb={0.5}>
        Add item
      </Box>
      <Stack>
        <Stack.Item grow>
          <Input
            fluid
            placeholder="/obj/item/..."
            value={addPath}
            onChange={setAddPath}
            onEnter={() => {
              if (addPath.trim()) {
                act('add_entry', { table: table.path, path: addPath.trim() });
                setAddPath('');
              }
            }}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="plus"
            onClick={() => {
              if (addPath.trim()) {
                act('add_entry', { table: table.path, path: addPath.trim() });
                setAddPath('');
              }
            }}
          />
        </Stack.Item>
      </Stack>

      <Box mt={1}>
        <Input
          fluid
          placeholder="Search items (3+ chars)..."
          value={searchQuery}
          onChange={(v) => {
            setSearchQuery(v);
            if (v.length >= 3) onSearch(v);
          }}
        />
        {searchResults.length > 0 && (
          <Box
            mt={0.5}
            style={{
              maxHeight: 140,
              overflowY: 'auto',
              background: 'rgba(0,0,0,0.3)',
              borderRadius: 4,
              padding: 4,
            }}
          >
            {searchResults.map((path) => (
              <Button
                key={path}
                fluid
                compact
                color="transparent"
                onClick={() => {
                  act('add_entry', { table: table.path, path });
                  setSearchQuery('');
                }}
              >
                {path.replace('/obj/item/', '')}
              </Button>
            ))}
          </Box>
        )}
      </Box>

      <Divider />

      <Box fontWeight="bold" mb={0.5}>
        New sub-table
      </Box>
      <Stack>
        <Stack.Item grow>
          <Input
            fluid
            placeholder="Name..."
            value={subName}
            onChange={setSubName}
            onEnter={() => {
              if (subName.trim()) {
                act('add_subtable', {
                  table: table.path,
                  name: subName.trim(),
                });
                setSubName('');
              }
            }}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="plus"
            onClick={() => {
              if (subName.trim()) {
                act('add_subtable', {
                  table: table.path,
                  name: subName.trim(),
                });
                setSubName('');
              }
            }}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
}

function TestPanel({
  lastRoll,
  tally,
  tallyRuns,
  tallyNothing,
  exportText,
}: {
  lastRoll: LastRoll | null;
  tally: TallyRow[] | null;
  tallyRuns: number;
  tallyNothing: number;
  exportText: string | null;
}) {
  const { act } = useBackend<Data>();

  return (
    <Section
      fill
      scrollable
      title="Test & Export"
      buttons={
        <>
          <Button icon="dice" onClick={() => act('roll')}>
            Roll
          </Button>
          <Button icon="chart-bar" onClick={() => act('roll_many')}>
            ×1000
          </Button>
          <Button icon="file-code" color="good" onClick={() => act('export')}>
            Export
          </Button>
        </>
      }
    >
      {lastRoll && (
        <Box mb={1}>
          <Box fontWeight="bold">Last roll</Box>
          {lastRoll.found ? (
            <Box>
              {lastRoll.icon && (
                <img
                  src={`data:image/png;base64,${lastRoll.icon}`}
                  style={{
                    width: 32,
                    height: 32,
                    imageRendering: 'pixelated',
                    verticalAlign: 'middle',
                    marginRight: 6,
                  }}
                />
              )}
              <Box inline>{lastRoll.name}</Box>
              <Box color="label" fontSize="11px">
                {lastRoll.path}
              </Box>
              <Box color="label" fontSize="11px">
                Route: {lastRoll.route?.join(' → ')}
              </Box>
            </Box>
          ) : (
            <Box color="average">Nothing</Box>
          )}
        </Box>
      )}

      {tally && (
        <Box mb={1}>
          <Box fontWeight="bold">
            Tally ({tallyRuns} runs
            {tallyNothing > 0 && (
              <span style={{ color: '#c9a227' }}>
                {' '}
                · nothing {(tallyNothing / tallyRuns * 100).toFixed(1)}%
              </span>
            )}
            )
          </Box>
          {tally.map((row) => (
            <Box key={row.path} fontSize="12px">
              <Box inline style={{ width: 50 }} color="good">
                {row.pct.toFixed(1)}%
              </Box>
              {row.name || row.path.split('/').pop()}
              <Box inline color="label" ml={1}>
                ×{row.count}
              </Box>
            </Box>
          ))}
        </Box>
      )}

      {exportText && (
        <Box>
          <Flex mb={0.5}>
            <Flex.Item grow>
              <Box fontWeight="bold">DM export</Box>
            </Flex.Item>
            <Flex.Item>
              <Button
                icon="download"
                compact
                onClick={() => act('save_export')}
              >
                Save .dm
              </Button>
              <Button
                icon="times"
                compact
                onClick={() => act('close_export')}
              />
            </Flex.Item>
          </Flex>
          <Box
            as="pre"
            style={{
              background: '#0a0e14',
              padding: 8,
              borderRadius: 4,
              fontSize: '11px',
              maxHeight: 280,
              overflow: 'auto',
              whiteSpace: 'pre-wrap',
              wordBreak: 'break-all',
            }}
          >
            {exportText}
          </Box>
        </Box>
      )}
    </Section>
  );
}

export const LootTableEditor = () => {
  const { act, data } = useBackend<Data>();
  const {
    tables = [],
    root,
    selected,
    notice,
    search_results = [],
    last_roll,
    tally,
    tally_runs = 0,
    tally_nothing = 0,
    export_text,
    loadable = [],
  } = data;

  const [tab, setTab] = useState<'inspector' | 'test'>('inspector');
  const [newName, setNewName] = useState('');
  const [loadPath, setLoadPath] = useState('');
  const [showLoad, setShowLoad] = useState(false);

  const selectedTable = useMemo(
    () => tables.find((t) => t.path === selected) || null,
    [tables, selected],
  );

  const isRoot = selected === root;

  return (
    <Window title="Loot Table Editor" width={1100} height={720}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section>
              <Flex>
                <Flex.Item>
                  <Input
                    placeholder="New table name..."
                    value={newName}
                    width={16}
                    onChange={setNewName}
                    onEnter={() => {
                      if (newName.trim()) {
                        act('new_root', { name: newName.trim() });
                        setNewName('');
                      }
                    }}
                  />
                  <Button
                    icon="plus"
                    color="good"
                    onClick={() => {
                      if (newName.trim()) {
                        act('new_root', { name: newName.trim() });
                        setNewName('');
                      }
                    }}
                  >
                    New Root
                  </Button>
                </Flex.Item>
                <Flex.Item ml={1}>
                  <Button
                    icon="folder-open"
                    onClick={() => setShowLoad(!showLoad)}
                  >
                    Load
                  </Button>
                  {showLoad && (
                    <Box
                      style={{
                        position: 'absolute',
                        zIndex: 100,
                        background: '#121820',
                        border: '1px solid #3a4a5a',
                        borderRadius: 4,
                        padding: 8,
                        maxHeight: 260,
                        overflowY: 'auto',
                        minWidth: 320,
                      }}
                    >
                      <Input
                        fluid
                        placeholder="Filter paths..."
                        value={loadPath}
                        onChange={setLoadPath}
                      />
                      {loadable
                        .filter((p) =>
                          p.toLowerCase().includes(loadPath.toLowerCase()),
                        )
                        .slice(0, 40)
                        .map((p) => (
                          <Button
                            key={p}
                            fluid
                            compact
                            color="transparent"
                            onClick={() => {
                              act('load_table', { path: p });
                              setShowLoad(false);
                              setLoadPath('');
                            }}
                          >
                            {p.replace('/datum/loot_table/', '')}
                          </Button>
                        ))}
                    </Box>
                  )}
                </Flex.Item>
                <Flex.Item ml={1}>
                  <Button icon="undo" onClick={() => act('reset')}>
                    Reset
                  </Button>
                </Flex.Item>
                <Flex.Item grow />
                <Flex.Item>
                  {root && (
                    <Box inline color="label" mr={1}>
                      Root: {root.replace('/datum/loot_table/', '')}
                    </Box>
                  )}
                </Flex.Item>
              </Flex>
              {notice && (
                <NoticeBox mt={1} info>
                  {notice}
                </NoticeBox>
              )}
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Stack fill>
              <Stack.Item grow>
                <Section fill fitted>
                  {tables.length === 0 ? (
                    <Box
                      color="label"
                      textAlign="center"
                      style={{
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        height: '100%',
                      }}
                    >
                      Create a new root table or load an existing one to begin.
                    </Box>
                  ) : (
                    <BlueprintCanvas
                      tables={tables}
                      root={root}
                      selected={selected}
                      onSelect={(path) => act('select', { path })}
                    />
                  )}
                </Section>
              </Stack.Item>

              <Stack.Item style={{ width: 340 }}>
                <Stack fill vertical>
                  <Stack.Item>
                    <Tabs>
                      <Tabs.Tab
                        selected={tab === 'inspector'}
                        onClick={() => setTab('inspector')}
                      >
                        Inspector
                      </Tabs.Tab>
                      <Tabs.Tab
                        selected={tab === 'test'}
                        onClick={() => setTab('test')}
                      >
                        Test / Export
                      </Tabs.Tab>
                    </Tabs>
                  </Stack.Item>
                  <Stack.Item grow>
                    {tab === 'inspector' ? (
                      <TableInspector
                        table={selectedTable}
                        isRoot={!!isRoot}
                        searchResults={search_results}
                        onSearch={(q) => act('search', { query: q })}
                      />
                    ) : (
                      <TestPanel
                        lastRoll={last_roll}
                        tally={tally}
                        tallyRuns={tally_runs}
                        tallyNothing={tally_nothing}
                        exportText={export_text}
                      />
                    )}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
