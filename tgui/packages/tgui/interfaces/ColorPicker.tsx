import { Box, Button, Icon, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export type ColorEntry = {
  /** Display name, e.g. "Forest Green" */
  name: string;
  /** Hex value, e.g. "#3a7d44" */
  hex: string;
  /** Whether the client owns this color */
  owned: BooleanLike;
  /**
   * Loadout item path string used to purchase this color.
   * Null for always-free colors (peasant palette).
   */
  purchase_path: string | null;
  /** Triumph cost to permanently unlock. 0 = free. */
  cost: number;
};

type ColorPickerProps = {
  colors: ColorEntry[];
  selected: string | null;
  onSelect: (hex: string) => void;
  onClear: () => void;
  onBuy: (path: string) => void;
  label?: string;
  /** If true, renders without a Section wrapper (for embedding) */
  bare?: boolean;
};

const SWATCH_SIZE = '22px';

const ColorSwatch = ({
  entry,
  isSelected,
  onSelect,
  onBuy,
}: {
  entry: ColorEntry;
  isSelected: boolean;
  onSelect: (hex: string) => void;
  onBuy: (path: string) => void;
}) => {
  const owned = !!entry.owned;
  const free  = entry.cost === 0;

  const tooltip = owned
    ? entry.name
    : free
      ? `${entry.name} - free, click to claim`
      : `${entry.name} - ${entry.cost} triumphs to unlock`;

  return (
    <Box
      as="div"
      title={tooltip}
      onClick={() => {
        if (owned) {
          onSelect(entry.hex);
        } else if (entry.purchase_path) {
          onBuy(entry.purchase_path);
        }
      }}
      style={{
        display: 'inline-block',
        width: SWATCH_SIZE,
        height: SWATCH_SIZE,
        borderRadius: '3px',
        background: entry.hex,
        cursor: owned ? 'pointer' : 'default',
        opacity: owned ? 1 : 0.3,
        outline: isSelected
          ? '2px solid white'
          : '1px solid rgba(255,255,255,0.15)',
        outlineOffset: isSelected ? '2px' : '0px',
        position: 'relative',
        margin: '2px',
        flexShrink: 0,
      }}
    >
      {!owned && (
        <Box
          style={{
            position: 'absolute',
            bottom: '1px',
            right: '1px',
            fontSize: '8px',
            lineHeight: 1,
            color: 'white',
            textShadow: '0 0 2px black',
            pointerEvents: 'none',
          }}
        >
          {free ? '✓' : '🔒'}
        </Box>
      )}
    </Box>
  );
};

export const ColorPicker = ({
  colors,
  selected,
  onSelect,
  onClear,
  onBuy,
  label,
  bare,
}: ColorPickerProps) => {
  const inner = (
    <Stack vertical>
      <Stack.Item>
        <Stack align="center" wrap>
          {colors.map((entry) => (
            <Stack.Item key={entry.hex}>
              <ColorSwatch
                entry={entry}
                isSelected={selected === entry.hex}
                onSelect={onSelect}
                onBuy={onBuy}
              />
            </Stack.Item>
          ))}
        </Stack>
      </Stack.Item>

      <Stack.Item>
        <Stack align="center">
          {selected ? (
            <>
              <Stack.Item>
                <Box
                  style={{
                    width: '14px',
                    height: '14px',
                    background: selected,
                    borderRadius: '2px',
                    border: '1px solid rgba(255,255,255,0.3)',
                    display: 'inline-block',
                    verticalAlign: 'middle',
                    marginRight: '4px',
                  }}
                />
              </Stack.Item>
              <Stack.Item color="label" fontSize="0.8em">
                {colors.find((c) => c.hex === selected)?.name ?? selected}
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="times"
                  color="transparent"
                  fontSize="0.8em"
                  tooltip="Clear color (revert to default)"
                  onClick={onClear}
                />
              </Stack.Item>
            </>
          ) : (
            <Stack.Item color="label" fontSize="0.8em">
              <Icon name="circle" mr={1} color="label" />
              No color applied, default appearance
            </Stack.Item>
          )}
        </Stack>
      </Stack.Item>

      <Stack.Item>
        <Box color="label" fontSize="0.75em">
          <Icon name="lock" mr={1} />
          Greyed swatches require triumph unlocks. Click to purchase.
        </Box>
      </Stack.Item>
    </Stack>
  );

  if (bare) {
    return inner;
  }

  return (
    <Section title={label ?? 'Color'} mb={0}>
      {inner}
    </Section>
  );
};
