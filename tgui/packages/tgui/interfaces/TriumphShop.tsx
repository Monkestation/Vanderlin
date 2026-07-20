import { useEffect, useMemo, useRef, useState } from 'react';
import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  DmIcon,
  Icon,
  Input,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { Window } from '../layouts';
import { ColorPicker } from './ColorPicker';
import type { ColorEntry } from './ColorPicker';
import {
  ActiveTriumphBuysView,
  TriumphBuyCategoryView,
  type ActiveTriumphBuy,
  type TriumphBuyEntry,
} from './TriumphBuy';
import {
  TicketShopView,
  type TicketEntry,
  type HistoryEntry,
  type IncomingTrade,
  type OutgoingTrade,
} from './TicketShop';


type LoadoutEntry = {
  path: string;
  name: string;
  description: string | null;
  cost_single: number;
  cost_permanent: number;
  free: BooleanLike;
  owned: BooleanLike;
  equipped: BooleanLike;
  rented: BooleanLike;
  can_afford_single: BooleanLike;
  can_afford_perm: BooleanLike;
  award_locked: BooleanLike;
  ui_icon: string | null;
  ui_icon_state: string | null;
  category: string;
  no_rent: BooleanLike;
  no_equip: BooleanLike;
  patreon_locked: BooleanLike;
  giveaway_only: BooleanLike;
  donator_free: BooleanLike;
};

type EquippedSlot = {
  path: string | null;
  name: string;
  permanent: BooleanLike;
  dyeable: BooleanLike;
  has_detail: BooleanLike;
  base_color: string | null;
  detail_color: string | null;
};

type SpecialEntry = {
  path: string;
  name: string;
  greet_text: string;
  req_text: string | null;
  weight: number;
  total_weight: number;
  eligible: BooleanLike;
  cost_random: number;
  cost_specific: number;
  is_pending: BooleanLike;
};

type Data = {
  triumph_balance: number;
  cost_random_special: number;
  pending_special: string | null;
  donator: BooleanLike;
  categories: Record<string, LoadoutEntry[]>;
  equipped_slots: [EquippedSlot, EquippedSlot, EquippedSlot];
  specials: SpecialEntry[];
  available_colors: ColorEntry[];
  /** keyed by TRIUMPH_CAT_* strings */
  triumph_buy_categories: Record<string, TriumphBuyEntry[]>;
  active_triumph_buys: ActiveTriumphBuy[];
  owned_tickets: TicketEntry[];
  ticket_history: HistoryEntry[];
  incoming_trades: IncomingTrade[];
  outgoing_trades: OutgoingTrade[];
  locked_offering_ids: string[];   // ticket_ids currently in outgoing trades
  online_ckeys: string[];
  lookup_result_ckey: string | null;
  lookup_result_tickets: TicketEntry[] | null;


};

function flattenCategories(
  categories: Record<string, LoadoutEntry[]>,
): LoadoutEntry[] {
  return Object.values(categories).flatMap((v) =>
    Array.isArray(v) ? v : [v as unknown as LoadoutEntry],
  );
}

type RarityTier = 'common' | 'uncommon' | 'rare' | 'epic';

function getRarity(weight: number, allWeights: number[]): RarityTier {
  if (!allWeights.length || weight <= 0) return 'epic';
  const sorted = [...allWeights].sort((a, b) => b - a);
  const q1 = sorted[Math.floor(sorted.length * 0.25)];
  const q2 = sorted[Math.floor(sorted.length * 0.5)];
  const q3 = sorted[Math.floor(sorted.length * 0.75)];
  if (weight >= q1) return 'common';
  if (weight >= q2) return 'uncommon';
  if (weight >= q3) return 'rare';
  return 'epic';
}

const RARITY_COLOR: Record<RarityTier, string> = {
  common: '#9e9e9e',
  uncommon: '#4caf50',
  rare: '#2196f3',
  epic: '#9c27b0',
};

const RARITY_LABEL: Record<RarityTier, string> = {
  common: 'Common',
  uncommon: 'Uncommon',
  rare: 'Rare',
  epic: 'Epic',
};

const ItemSprite = ({
  icon,
  icon_state,
  size = 2,
}: {
  icon: string | null;
  icon_state: string | null;
  size?: number;
}) => {
  if (!icon || !icon_state) {
    return <Icon name="question" size={1} color="gray" />;
  }
  return (
    <DmIcon
      icon={icon}
      icon_state={icon_state}
      height={size}
      width={size}
      fallback={<Icon name="spinner" size={1} spin color="gray" />}
    />
  );
};

const EquippedPanel = ({
  slots,
  availableColors,
  onUnequip,
  onSetColor,
  onClearColor,
  onBuyColor,
}: {
  slots: EquippedSlot[];
  availableColors: ColorEntry[];
  onUnequip: (path: string) => void;
  onSetColor: (path: string, layer: 'base' | 'detail', hex: string) => void;
  onClearColor: (path: string, layer: 'base' | 'detail') => void;
  onBuyColor: (colorPath: string) => void;
}) => {
  const [openSlotPath, setOpenSlotPath] = useState<string | null>(null);
  const [openLayer, setOpenLayer] = useState<'base' | 'detail'>('base');

  const togglePicker = (path: string, layer: 'base' | 'detail' = 'base') => {
    if (openSlotPath === path && openLayer === layer) {
      setOpenSlotPath(null);
    } else {
      setOpenSlotPath(path);
      setOpenLayer(layer);
    }
  };

  return (
    <Section title="Loadout Slots" fill>
      <Stack vertical>
        {slots.map((slot, i) => {
          const isOpen = !!slot.path && openSlotPath === slot.path;
          const dyeable = !!slot.dyeable;
          const hasDetail = !!slot.has_detail;

          return (
            <Stack.Item key={i}>
              <Stack align="center">
                <Stack.Item>
                  <Icon
                    name={slot.path ? 'check-circle' : 'circle'}
                    color={slot.path ? 'good' : 'average'}
                  />
                </Stack.Item>
                <Stack.Item grow>
                  {slot.path ? slot.name : `Slot ${i + 1} - Empty`}
                </Stack.Item>

                {!!slot.path && dyeable && (
                  <Stack.Item>
                    <Button
                      icon="palette"
                      color={
                        isOpen && openLayer === 'base'
                          ? 'average'
                          : 'transparent'
                      }
                      tooltip="Set base color"
                      onClick={() => togglePicker(slot.path!, 'base')}
                      style={
                        slot.base_color
                          ? { borderBottom: `2px solid ${slot.base_color}` }
                          : {}
                      }
                    />
                  </Stack.Item>
                )}
                {!!slot.path && hasDetail && (
                  <Stack.Item>
                    <Button
                      icon="star"
                      color={
                        isOpen && openLayer === 'detail'
                          ? 'average'
                          : 'transparent'
                      }
                      tooltip="Set accent/detail color"
                      onClick={() => togglePicker(slot.path!, 'detail')}
                      style={
                        slot.detail_color
                          ? { borderBottom: `2px solid ${slot.detail_color}` }
                          : {}
                      }
                    />
                  </Stack.Item>
                )}

                {!!slot.path && (
                  <Stack.Item>
                    <Button
                      icon="times"
                      color="transparent"
                      tooltip={
                        !!slot.permanent
                          ? 'Unequip (item stays owned)'
                          : 'Cancel rental (refunded)'
                      }
                      onClick={() => onUnequip(slot.path!)}
                    />
                  </Stack.Item>
                )}
              </Stack>

              {isOpen && slot.path && (
                <Box mt={1} ml={2}>
                  {dyeable && hasDetail && (
                    <Stack mb={1}>
                      <Stack.Item>
                        <Button
                          selected={openLayer === 'base'}
                          onClick={() => setOpenLayer('base')}
                          fontSize="0.8em"
                        >
                          Base
                        </Button>
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          selected={openLayer === 'detail'}
                          onClick={() => setOpenLayer('detail')}
                          fontSize="0.8em"
                        >
                          Accent
                        </Button>
                      </Stack.Item>
                    </Stack>
                  )}
                  <ColorPicker
                    colors={availableColors}
                    selected={
                      openLayer === 'base'
                        ? slot.base_color
                        : slot.detail_color
                    }
                    onSelect={(hex) => onSetColor(slot.path!, openLayer, hex)}
                    onClear={() => onClearColor(slot.path!, openLayer)}
                    onBuy={onBuyColor}
                    label={
                      openLayer === 'base' ? 'Base Color' : 'Accent Color'
                    }
                  />
                </Box>
              )}
            </Stack.Item>
          );
        })}

        <Stack.Item>
          <Box mt={1} color="label" fontSize="0.8em">
            Items and colors apply on your next spawn.
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const LoadoutItemRow = ({
  item,
  onBuySingle,
  onBuyPermanent,
  onEquip,
  onUnequip,
  slotsUsed,
  donator,
}: {
  item: LoadoutEntry;
  onBuySingle: (path: string) => void;
  onBuyPermanent: (path: string) => void;
  onEquip: (path: string) => void;
  onUnequip: (path: string) => void;
  slotsUsed: number;
  donator: BooleanLike;
}) => {
  const slotsFull = slotsUsed >= 3;
  const owned = !!item.owned;
  const equipped = !!item.equipped;
  const rented = !!item.rented;
  const free = !!item.free;
  const awardLocked = !!item.award_locked;
  const canSingle = !!item.can_afford_single;
  const canPerm = !!item.can_afford_perm;
  const noRent = !!item.no_rent;
  const noEquip = !!item.no_equip;
  const patreonLock = !!item.patreon_locked;
  const giveawayLocked = !!item.giveaway_only;
  const isDonatorFree = !!donator && !!item.donator_free;

  return (
    <Stack align="center" mb={1}>
      <Stack.Item>
        <ItemSprite icon={item.ui_icon} icon_state={item.ui_icon_state} />
      </Stack.Item>
      <Stack.Item grow>
        <Box bold>{item.name}</Box>
        {!!item.description && (
          <Box color="label" fontSize="0.8em">
            {item.description}
          </Box>
        )}
      </Stack.Item>
      <Stack.Item>
        {patreonLock && !owned && (
          <Box color="purple" fontSize="0.8em">
            Patreon exclusive
          </Box>
        )}
         {giveawayLocked && !owned && (
          <Box color="purple" fontSize="0.8em">
            Giveaway exclusive
          </Box>
        )}
        {awardLocked && (
          <Box color="bad" fontSize="0.8em">
            Achievement locked
          </Box>
        )}
        {!awardLocked && !patreonLock && owned && (
          <Box color="good" fontSize="0.8em">
            {noEquip ? 'Claimed' : 'Owned'}
          </Box>
        )}
        {!awardLocked && !patreonLock && !giveawayLocked && !owned && rented && (
          <Box color="average" fontSize="0.8em">
            Rented this round
          </Box>
        )}
      </Stack.Item>
      <Stack.Item>
        <Stack>
          {owned && !equipped && !noEquip && (
            <Button
              icon="plus"
              disabled={slotsFull}
              tooltip={slotsFull ? 'All slots full' : 'Equip'}
              onClick={() => onEquip(item.path)}
            >
              Equip
            </Button>
          )}
          {equipped && !noEquip && (
            <Button
              icon="minus"
              color="bad"
              tooltip="Unequip"
              onClick={() => onUnequip(item.path)}
            >
              Unequip
            </Button>
          )}
          {!owned &&
          !rented &&
          !awardLocked &&
          !patreonLock &&
          !giveawayLocked &&
          !noRent &&
          !noEquip && (
            <Button
              icon={isDonatorFree ? 'flask' : 'clock'}
              disabled={slotsFull || (!isDonatorFree && !free && !canSingle)}
              tooltip={
                slotsFull
                  ? 'All slots full'
                  : isDonatorFree
                    ? 'Try this item for one round for free (Patreon perk)'
                    : free
                      ? 'Free, use for one round'
                      : canSingle
                        ? `Rent for ${item.cost_single} triumphs (one round)`
                        : `Need ${item.cost_single} triumphs`
              }
              onClick={() => onBuySingle(item.path)}
            >
              {isDonatorFree ? 'Try' : free ? 'Use' : `Rent (${item.cost_single})`}
            </Button>
          )}
          {rented && !noEquip && (
            <Button
              icon="undo"
              color="average"
              tooltip={isDonatorFree ? 'Remove trial item (no refund)' : 'Cancel rental and get a refund'}
              onClick={() => onUnequip(item.path)}
            >
              {isDonatorFree ? 'Remove' : 'Cancel'}
            </Button>
          )}
          {!owned && !awardLocked && !patreonLock  && !giveawayLocked && item.cost_permanent > 0 && (
            <Button
              icon="lock-open"
              color={canPerm ? 'good' : 'bad'}
              disabled={!canPerm}
              tooltip={
                canPerm
                  ? `Permanently unlock for ${item.cost_permanent} triumphs`
                  : `Need ${item.cost_permanent} triumphs to permanently unlock`
              }
              onClick={() => onBuyPermanent(item.path)}
            >
              Unlock ({item.cost_permanent})
            </Button>
          )}
          {!owned &&
            !awardLocked &&
            !patreonLock &&
            !giveawayLocked &&
            item.cost_permanent === 0 &&
            !rented &&
            free && (
              <Button
                icon="gift"
                color="good"
                tooltip="Claim permanently for free"
                onClick={() => onBuyPermanent(item.path)}
              >
                Claim
              </Button>
            )}
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const LoadoutCategoryView = ({
  items,
  onBuySingle,
  onBuyPermanent,
  onEquip,
  onUnequip,
  slotsUsed,
  search,
  donator,
}: {
  items: LoadoutEntry[];
  onBuySingle: (path: string) => void;
  onBuyPermanent: (path: string) => void;
  onEquip: (path: string) => void;
  onUnequip: (path: string) => void;
  slotsUsed: number;
  search: string;
  donator: BooleanLike;
}) => {
  const filtered = useMemo(() => {
    if (!search) return items;
    const q = search.toLowerCase();
    return items.filter(
      (i) =>
        i.name.toLowerCase().includes(q) ||
        (i.description ?? '').toLowerCase().includes(q),
    );
  }, [items, search]);

  if (!filtered.length) {
    return (
      <NoticeBox>
        No items found{search ? ` for "${search}"` : ''}.
      </NoticeBox>
    );
  }

  return (
    <Box>
      {filtered.map((item) => (
        <LoadoutItemRow
          key={item.path}
          item={item}
          onBuySingle={onBuySingle}
          onBuyPermanent={onBuyPermanent}
          onEquip={onEquip}
          onUnequip={onUnequip}
          slotsUsed={slotsUsed}
          donator={donator}
        />
      ))}
    </Box>
  );
};

const CollectionView = ({
  categories,
  onEquip,
  onUnequip,
  slotsUsed,
  donator,
}: {
  categories: Record<string, LoadoutEntry[]>;
  onEquip: (path: string) => void;
  onUnequip: (path: string) => void;
  slotsUsed: number;
  donator: BooleanLike;
}) => {
  const items = useMemo(
    () =>
      flattenCategories(categories).filter(
        (i) => i.owned || i.equipped || i.rented,
      ),
    [categories],
  );

  if (!items.length) {
    return (
      <NoticeBox>
        You have not unlocked any items yet. Browse the shop tabs to spend
        triumphs!
      </NoticeBox>
    );
  }

 return (
    <Box>
      {items.map((item) => (
        <LoadoutItemRow
          key={item.path}
          item={item}
          onBuySingle={() => {}}
          onBuyPermanent={() => {}}
          onEquip={onEquip}
          onUnequip={onUnequip}
          slotsUsed={slotsUsed}
          donator={donator}
        />
      ))}
    </Box>
  );
};

const REEL_VISIBLE = 5;
const REEL_CARD_H = 52;
const REEL_LAND_MS = 2000;
const REEL_LINGER_MS = 2500;

function buildPool(specials: SpecialEntry[]): string[] {
  if (!specials.length) return [];
  const totalWeight = specials.reduce((s, x) => s + x.weight, 0);
  const divisor = totalWeight / 20;
  const pool: string[] = [];
  for (const s of specials) {
    const reps = Math.max(1, Math.round(s.weight / divisor));
    for (let i = 0; i < reps; i++) pool.push(s.path);
  }
  for (let i = pool.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [pool[i], pool[j]] = [pool[j], pool[i]];
  }
  while (pool.length < 50) {
    pool.push(...pool.slice(0, Math.min(pool.length, 50 - pool.length)));
  }
  return pool;
}

function safeMod(n: number, m: number): number {
  if (m <= 0) return 0;
  return ((n % m) + m) % m;
}

const TraitReel = ({
  specials,
  landOnPath,
  onDone,
}: {
  specials: SpecialEntry[];
  landOnPath: string | null;
  onDone: () => void;
}) => {
  const allWeights = useMemo(
    () => specials.map((s) => s.weight),
    [specials],
  );
  const nameMap = useMemo(
    () => Object.fromEntries(specials.map((s) => [s.path, s.name])),
    [specials],
  );
  const weightMap = useMemo(
    () => Object.fromEntries(specials.map((s) => [s.path, s.weight])),
    [specials],
  );

  const [strip, setStrip] = useState<string[]>(() => buildPool(specials));
  const [offsetY, setOffsetY] = useState(0);

  const rafRef = useRef<number | null>(null);
  const phaseRef = useRef<'spin' | 'land' | 'linger'>('spin');
  const spinOffsetRef = useRef(0);
  const landStartRef = useRef<number | null>(null);
  const landFromRef = useRef(0);
  const landTargetRef = useRef(0);
  const lingerStartRef = useRef<number | null>(null);
  const doneRef = useRef(false);
  const centreIndex = Math.floor(REEL_VISIBLE / 2);

  const spinLoopRef = useRef<(ts: number) => void>(() => {});
  spinLoopRef.current = (_ts: number) => {
    if (phaseRef.current !== 'spin') return;
    spinOffsetRef.current += REEL_CARD_H * 0.35;
    const maxOffset = strip.length * REEL_CARD_H;
    if (maxOffset > 0 && spinOffsetRef.current >= maxOffset)
      spinOffsetRef.current -= maxOffset;
    setOffsetY(Math.round(spinOffsetRef.current));
    rafRef.current = requestAnimationFrame(spinLoopRef.current);
  };

  useEffect(() => {
    phaseRef.current = 'spin';
    rafRef.current = requestAnimationFrame(spinLoopRef.current);
    return () => {
      if (rafRef.current !== null) cancelAnimationFrame(rafRef.current);
    };
  }, []);

  useEffect(() => {
    if (!landOnPath || phaseRef.current !== 'spin') return;
    const newStrip = buildPool(specials);
    newStrip.push(landOnPath);
    setStrip(newStrip);

    const targetIndex = newStrip.length - 1 - centreIndex;
    const targetOffset = targetIndex * REEL_CARD_H;
    landFromRef.current = spinOffsetRef.current;
    landTargetRef.current = targetOffset;
    landStartRef.current = null;
    phaseRef.current = 'land';
    if (rafRef.current !== null) cancelAnimationFrame(rafRef.current);

    const lingerLoop = (ts: number) => {
      if (!lingerStartRef.current) lingerStartRef.current = ts;
      if (ts - lingerStartRef.current < REEL_LINGER_MS) {
        rafRef.current = requestAnimationFrame(lingerLoop);
      } else if (!doneRef.current) {
        doneRef.current = true;
        onDone();
      }
    };

    const landAnimate = (ts: number) => {
      if (!landStartRef.current) landStartRef.current = ts;
      const elapsed = ts - landStartRef.current;
      const t = Math.min(elapsed / REEL_LAND_MS, 1);
      const eased = 1 - Math.pow(1 - t, 3);
      const current =
        landFromRef.current +
        (landTargetRef.current - landFromRef.current) * eased;
      setOffsetY(Math.round(current));
      if (t < 1) {
        rafRef.current = requestAnimationFrame(landAnimate);
      } else {
        setOffsetY(landTargetRef.current);
        phaseRef.current = 'linger';
        lingerStartRef.current = null;
        rafRef.current = requestAnimationFrame(lingerLoop);
      }
    };
    rafRef.current = requestAnimationFrame(landAnimate);
  }, [landOnPath]);

  const startIndex =
    strip.length > 0 ? Math.floor(offsetY / REEL_CARD_H) : 0;
  const pixelOffset = strip.length > 0 ? offsetY % REEL_CARD_H : 0;
  const visibleIndices: number[] = [];
  for (let i = 0; i < REEL_VISIBLE + 1; i++)
    visibleIndices.push(startIndex + i);

  const centredPath =
    strip.length > 0
      ? strip[safeMod(startIndex + centreIndex, strip.length)] ?? ''
      : '';
  const centredRarity = getRarity(weightMap[centredPath] ?? 0, allWeights);
  const centreColor = RARITY_COLOR[centredRarity];

  return (
    <Section
      title={
        phaseRef.current === 'linger'
          ? `You got: ${nameMap[centredPath] ?? '???'}`
          : landOnPath
            ? 'Landing...'
            : 'Rolling...'
      }
    >
      <Box
        style={{
          height: `${REEL_VISIBLE * REEL_CARD_H}px`,
          overflow: 'hidden',
          position: 'relative',
        }}
      >
        <Box
          style={{
            position: 'absolute',
            top: `${centreIndex * REEL_CARD_H}px`,
            left: 0,
            right: 0,
            height: `${REEL_CARD_H}px`,
            background: `${centreColor}18`,
            borderTop: `1px solid ${centreColor}88`,
            borderBottom: `1px solid ${centreColor}88`,
            pointerEvents: 'none',
            zIndex: 1,
          }}
        />
        <Box
          style={{
            position: 'absolute',
            top: `-${pixelOffset}px`,
            left: 0,
            right: 0,
          }}
        >
          {visibleIndices.map((idx, i) => {
            const path =
              strip.length > 0
                ? strip[safeMod(idx, strip.length)] ?? ''
                : '';
            const isCentre = i === centreIndex;
            const rarity = getRarity(weightMap[path] ?? 0, allWeights);
            const color = RARITY_COLOR[rarity];
            return (
              <Box
                key={i}
                style={{
                  height: `${REEL_CARD_H}px`,
                  display: 'flex',
                  alignItems: 'center',
                  paddingLeft: '12px',
                  fontWeight: isCentre ? 'bold' : 'normal',
                  opacity: isCentre ? 1 : 0.4,
                  fontSize: isCentre ? '1.05em' : '0.9em',
                  color: isCentre ? color : 'inherit',
                  borderLeft: `3px solid ${color}`,
                }}
              >
                <Icon name="dice" mr={1} />
                {nameMap[path] ?? '???'}
              </Box>
            );
          })}
        </Box>
      </Box>
    </Section>
  );
};

const SpecialsTab = ({
  specials,
  pendingSpecial,
  balance,
  costRandom,
  donator,
  onRollRandom,
  onBuySpecific,
  onClearPending,
}: {
  specials: SpecialEntry[];
  pendingSpecial: string | null;
  balance: number;
  costRandom: number;
  donator: BooleanLike;
  onRollRandom: () => void;
  onBuySpecific: (path: string) => void;
  onClearPending: () => void;
}) => {
  const [showReel, setShowReel] = useState(false);
  const [landOnPath, setLandOnPath] = useState<string | null>(null);
  const prevPendingRef = useRef<string | null>(pendingSpecial);

  const allWeights = useMemo(() => specials.map((s) => s.weight), [specials]);
  const totalWeight = specials[0]?.total_weight ?? 1;

  useEffect(() => {
    if (showReel && pendingSpecial && pendingSpecial !== prevPendingRef.current) {
      setLandOnPath(pendingSpecial);
    }
  }, [pendingSpecial, showReel]);

  const handleRollClick = () => {
    prevPendingRef.current = pendingSpecial;
    setLandOnPath(null);
    setShowReel(true);
    onRollRandom();
  };

  const handleReelDone = () => setShowReel(false);

  const hasPending = !!pendingSpecial;
  const canAffordRandom = balance >= costRandom;
  const pendingTrait = pendingSpecial
    ? specials.find((s) => s.path === pendingSpecial)
    : null;

  return (
    <Stack vertical fill>
      <Stack.Item>
        {!!donator ? (
          <NoticeBox info>
            <Icon name="heart" mr={1} color="purple" />
            <Box as="span" bold>
              Patreon Supporter perk:
            </Box>{' '}
            Random rolls are free for you, and specific trait costs are 50% off.
          </NoticeBox>
        ) : (
          <Box color="label" fontSize="0.8em" mb={0.5}>
            <Icon name="heart" mr={1} color="purple" />
            Patreon supporters get free random rolls and 50% off specific trait
            picks.
          </Box>
        )}
      </Stack.Item>

      <Stack.Item>
        <Section title="Next Round Special">
          {showReel ? (
            <TraitReel
              specials={specials}
              landOnPath={landOnPath}
              onDone={handleReelDone}
            />
          ) : hasPending ? (
            <NoticeBox>
              <Stack align="center">
                <Stack.Item grow>
                  <Box bold>
                    <Icon name="dice" mr={1} />
                    {pendingTrait?.name ?? pendingSpecial}
                  </Box>
                  {pendingTrait && (
                    <Box
                      fontSize="0.8em"
                      style={{
                        color:
                          RARITY_COLOR[
                            getRarity(pendingTrait.weight, allWeights)
                          ],
                      }}
                    >
                      {
                        RARITY_LABEL[
                          getRarity(pendingTrait.weight, allWeights)
                        ]
                      }
                    </Box>
                  )}
                  {pendingTrait?.req_text && (
                    <Box color="label" fontSize="0.85em" mt={0.5}>
                      Requirements: {pendingTrait.req_text}
                    </Box>
                  )}
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="times"
                    color="bad"
                    tooltip="Clear pending special (no refund)"
                    onClick={onClearPending}
                  >
                    Clear
                  </Button>
                </Stack.Item>
              </Stack>
            </NoticeBox>
          ) : (
            <Stack align="center">
              <Stack.Item>
                <Button
                  icon="dice"
                  color={canAffordRandom ? 'caution' : 'bad'}
                  disabled={!canAffordRandom || hasPending || showReel}
                  tooltip={
                    !canAffordRandom
                      ? `Need ${costRandom} triumphs`
                      : !!donator
                        ? 'Roll a random special for free (Patreon perk)'
                        : `Roll a random special for ${costRandom} triumphs`
                  }
                  onClick={handleRollClick}
                >
                  {!!donator
                    ? 'Roll Random (Free)'
                    : `Roll Random (${costRandom})`}
                </Button>
              </Stack.Item>
              <Stack.Item color="label" fontSize="0.85em">
                or pick a specific trait below, cost varies by rarity
              </Stack.Item>
            </Stack>
          )}
        </Section>
      </Stack.Item>

      <Stack.Item grow>
        <Section title="Available Specials" fill scrollable>
          {specials.map((trait) => {
            const eligible = !!trait.eligible;
            const rarity = getRarity(trait.weight, allWeights);
            const color = RARITY_COLOR[rarity];
            const canAfford = balance >= trait.cost_specific;
            const expectedRolls =
              totalWeight > 0
                ? Math.round(totalWeight / Math.max(trait.weight, 1))
                : 999;

            return (
              <Stack key={trait.path} align="center" mb={1}>
                <Stack.Item
                  width="4px"
                  style={{
                    alignSelf: 'stretch',
                    background: color,
                    borderRadius: '2px',
                    marginRight: '8px',
                  }}
                />
                <Stack.Item grow>
                  <Box bold color={eligible ? 'default' : 'label'}>
                    {trait.name}
                    {!eligible && (
                      <Box as="span" color="average" fontSize="0.8em" ml={1}>
                        (ineligible)
                      </Box>
                    )}
                  </Box>
                  <Box fontSize="0.75em" style={{ color }}>
                    {RARITY_LABEL[rarity]} ~1 in {expectedRolls} rolls
                  </Box>
                  {!!trait.req_text && (
                    <Box color="label" fontSize="0.8em">
                      Requires: {trait.req_text}
                    </Box>
                  )}
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="hand-pointer"
                    color={canAfford && eligible ? 'default' : 'bad'}
                    disabled={!eligible || !canAfford || hasPending || showReel}
                    tooltip={
                      !eligible
                        ? 'Your character does not meet the requirements'
                        : hasPending
                          ? 'You already have a special queued, clear it first'
                          : !canAfford
                            ? `Need ${trait.cost_specific} triumphs`
                            : !!donator
                              ? `Pick this trait for ${trait.cost_specific} triumphs (50% Patreon discount applied)`
                              : `Pick this trait for ${trait.cost_specific} triumphs`
                    }
                    onClick={() => onBuySpecific(trait.path)}
                  >
                    Pick ({trait.cost_specific})
                  </Button>
                </Stack.Item>
              </Stack>
            );
          })}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

export const TriumphShop = () => {
  const { act, data } = useBackend<Data>();
  const {
    triumph_balance,
    categories,
    equipped_slots,
    specials,
    pending_special,
    cost_random_special,
    donator,
    available_colors,
    triumph_buy_categories = {},
    active_triumph_buys = [],
    owned_tickets = [],
    ticket_history = [],
    incoming_trades = [],
    outgoing_trades = [],
    locked_offering_ids = [],
    online_ckeys = [],
    lookup_result_ckey = null,
    lookup_result_tickets = null,


  } = data;

  const loadoutCategoryNames = Object.keys(categories);

  const tbCategoryNames = Object.keys(triumph_buy_categories).filter(
    (k) => triumph_buy_categories[k]?.length > 0,
  );

  const TRIUMPH_SHOP_TAB = 'Seasonal / Round Shop';
  const MY_PURCHASES_TAB = 'My Purchases';
  const TICKETS_TAB = 'Tickets';

  const allTabs = [
    TICKETS_TAB,
    'Collection',
    'Specials',
    ...loadoutCategoryNames,
    ...(tbCategoryNames.length > 0 ? [TRIUMPH_SHOP_TAB] : []),
  ];

  const [activeTab, setActiveTab] = useLocalState('ts_tab', 'Specials');
  const [search, setSearch] = useLocalState('ts_search', '');
  const [triumphShopSubTab, setTriumphShopSubTab] = useLocalState(
    'ts_triumph_subtab',
    MY_PURCHASES_TAB,
  );

  const slotsUsed = equipped_slots.filter((s) => s.path !== null).length;

    const isTicketsTab      = activeTab === TICKETS_TAB;
  const isTriumphShopTab  = activeTab === TRIUMPH_SHOP_TAB;
  const isSpecialsTab     = activeTab === 'Specials';

  const showEquippedPanel = !isSpecialsTab && !isTriumphShopTab && !isTicketsTab;
  const showSearch        = !isSpecialsTab && !isTicketsTab;

  const effectiveTab =
    search.length > 1 && !isTriumphShopTab && !isSpecialsTab
      ? '__search__'
      : activeTab;

  const allLoadoutItems = useMemo(
    () => flattenCategories(categories),
    [categories],
  );
  const allTbItems = useMemo(
    () => Object.values(triumph_buy_categories).flat(),
    [triumph_buy_categories],
  );

  const [convertAmount, setConvertAmount] = useState('');
  const [showConvert, setShowConvert] = useState(false);

  const handleConvertToTicket = () => {
    const n = parseInt(convertAmount, 10);
    if (!n || n <= 0) return;
    act('convert_triumphs_to_ticket', { amount: n });
    setConvertAmount('');
    setShowConvert(false);
  };

  const handleBuySingle = (path: string) => act('buy_single', { path });
  const handleBuyPermanent = (path: string) => act('buy_permanent', { path });
  const handleEquip = (path: string) => act('equip_item', { path });
  const handleUnequip = (path: string) => act('unequip_item', { path });
  const handleSetColor = (
    path: string,
    layer: 'base' | 'detail',
    hex: string,
  ) => act('set_loadout_color', { path, layer, hex });
  const handleClearColor = (path: string, layer: 'base' | 'detail') =>
    act('clear_loadout_color', { path, layer });
  const handleBuyColor = (colorPath: string) =>
    act('buy_permanent', { path: colorPath });

  const handleRollRandom = () => act('buy_random_special');
  const handleBuySpecific = (path: string) =>
    act('buy_specific_special', { path });
  const handleClearPending = () => act('clear_pending_special');

  const handleTriumphBuy = (ref: string) => act('triumph_buy', { ref });
  const handleTriumphRefund = (ref: string) => act('triumph_refund', { ref });
  const handleContribute = (ref: string, amount: number) =>
    act('triumph_contribute', { ref, amount });

  const handleUseTicket    = (ticket_id: string) => act('use_ticket',    { ticket_id });
  const handleOfferTrade = (
    offered_ids: string[],
    requested_ids: string[],
    to_ckey: string,
  ) => act('offer_trade', { offered_ids, requested_ids, to_ckey });

  const handleAcceptTrade  = (trade_id: string)  => act('accept_trade',  { trade_id });
  const handleCancelTrade  = (trade_id: string)  => act('cancel_trade',  { trade_id });
  const handleDeclineTrade = (trade_id: string)  => act('cancel_trade',  { trade_id }); // recipient decline reuses cancel
  const handleLookupCkey   = (target_ckey: string) => act('lookup_ckey_tickets', { target_ckey });


  return (
    <Window title="Triumph Shop" width={860} height={620}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section>
              <Stack align="center">
                <Stack.Item grow>
                  <Box bold>
                    <Icon name="trophy" mr={1} color="average" />
                    Triumph Shop
                  </Box>
                  <Box color="label" fontSize="0.85em">
                    Spend triumphs on loadout items, special traits, and server
                    events.
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Stack align="center">
                    <Stack.Item>
                      <Box bold color="average">
                        <Icon name="trophy" mr={1} />
                        {triumph_balance.toLocaleString()} triumphs
                      </Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="ticket-alt"
                        color="transparent"
                        tooltip="Convert triumphs into a tradeable ticket"
                        selected={showConvert}
                        onClick={() => setShowConvert(!showConvert)}
                      />
                    </Stack.Item>
                  </Stack>
                  {showConvert && (
                    <Stack align="center" mt={0.5}>
                      <Stack.Item>
                        <Input
                          width="80px"
                          placeholder="Amount"
                          value={convertAmount}
                          onChange={(v: string) => setConvertAmount(v)}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon="arrow-right"
                          color={
                            parseInt(convertAmount) > 0 &&
                            parseInt(convertAmount) <= triumph_balance
                              ? 'good'
                              : 'bad'
                          }
                          disabled={
                            !parseInt(convertAmount) ||
                            parseInt(convertAmount) <= 0 ||
                            parseInt(convertAmount) > triumph_balance
                          }
                          tooltip={`Convert ${convertAmount || '?'} triumphs into a tradeable ticket`}
                          onClick={handleConvertToTicket}
                        >
                          Convert
                        </Button>
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon="times"
                          color="transparent"
                          onClick={() => {
                            setShowConvert(false);
                            setConvertAmount('');
                          }}
                        />
                      </Stack.Item>
                    </Stack>
                  )}
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section>
              <Stack vertical>
                <Stack.Item>
                  <Tabs scrollable>
                    {allTabs.map((tab) => {
                      const isDivider = tab === TRIUMPH_SHOP_TAB;
                      return (
                        <Tabs.Tab
                          key={tab}
                          selected={effectiveTab === tab}
                          onClick={() => {
                            setActiveTab(tab);
                            setSearch('');
                          }}
                          style={
                            isDivider
                              ? {
                                  borderLeft: '1px solid rgba(255,255,255,0.15)',
                                  marginLeft: '4px',
                                }
                              : {}
                          }
                        >
                          <Icon
                              name={
                                tab === TICKETS_TAB
                                  ? 'ticket-alt'
                                  : tab === 'Specials'
                                  ? 'dice'
                                  : tab === 'Collection'
                                  ? 'archive'
                                  : tab === TRIUMPH_SHOP_TAB
                                  ? 'shopping-cart'
                                  : 'tag'
                              }
                            mr={1}
                          />
                          {tab}
                          {tab === 'Specials' && !!pending_special && (
                            <Icon
                              name="circle"
                              color="good"
                              ml={1}
                              fontSize="0.6em"
                            />
                          )}
                          {tab === TRIUMPH_SHOP_TAB &&
                            active_triumph_buys.length > 0 && (
                              <Box
                                as="span"
                                ml={1}
                                fontSize="0.7em"
                                style={{
                                  background: 'rgba(255,255,255,0.15)',
                                  borderRadius: '8px',
                                  padding: '0 4px',
                                }}
                              >
                                {active_triumph_buys.length}
                              </Box>
                            )}
                            {tab === TICKETS_TAB && incoming_trades.length > 0 && (
                              <Box
                                as="span"
                                ml={1}
                                fontSize="0.7em"
                                style={{
                                  background: '#f44336',
                                  borderRadius: '8px',
                                  padding: '0 4px',
                                }}
                              >
                                {incoming_trades.length}
                              </Box>
                            )}
                        </Tabs.Tab>
                      );
                    })}
                  </Tabs>
                </Stack.Item>
                {showSearch && (
                  <Stack.Item>
                    <Input
                      fluid
                      placeholder={
                        isTriumphShopTab
                          ? 'Search shop items...'
                          : 'Search items...'
                      }
                      value={search}
                      onChange={(value: string) => setSearch(value)}
                    />
                  </Stack.Item>
                )}
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Stack fill>
              {showEquippedPanel && (
                <Stack.Item width="230px">
                  <EquippedPanel
                    slots={equipped_slots}
                    availableColors={available_colors}
                    onUnequip={handleUnequip}
                    onSetColor={handleSetColor}
                    onClearColor={handleClearColor}
                    onBuyColor={handleBuyColor}
                  />
                </Stack.Item>
              )}

              <Stack.Item grow>
                {isSpecialsTab && (
                  <SpecialsTab
                    specials={specials}
                    pendingSpecial={pending_special}
                    balance={triumph_balance}
                    costRandom={cost_random_special}
                    donator={donator}
                    onRollRandom={handleRollRandom}
                    onBuySpecific={handleBuySpecific}
                    onClearPending={handleClearPending}
                  />
                )}

                {isTriumphShopTab && (
                  <Stack vertical fill>
                    <Stack.Item>
                      <Section>
                        <Tabs>
                          <Tabs.Tab
                            selected={triumphShopSubTab === MY_PURCHASES_TAB}
                            onClick={() =>
                              setTriumphShopSubTab(MY_PURCHASES_TAB)
                            }
                          >
                            <Icon name="receipt" mr={1} />
                            My Purchases
                            {active_triumph_buys.length > 0 && (
                              <Box
                                as="span"
                                ml={1}
                                fontSize="0.7em"
                                style={{
                                  background: 'rgba(255,255,255,0.15)',
                                  borderRadius: '8px',
                                  padding: '0 4px',
                                }}
                              >
                                {active_triumph_buys.length}
                              </Box>
                            )}
                          </Tabs.Tab>
                          {tbCategoryNames.map((cat) => (
                            <Tabs.Tab
                              key={cat}
                              selected={triumphShopSubTab === cat}
                              onClick={() => setTriumphShopSubTab(cat)}
                            >
                              <Icon name="shopping-bag" mr={1} />
                              {cat}
                            </Tabs.Tab>
                          ))}
                        </Tabs>
                      </Section>
                    </Stack.Item>
                    <Stack.Item grow>
                      {triumphShopSubTab === MY_PURCHASES_TAB ? (
                        <Section fill scrollable title="My Purchases">
                          <ActiveTriumphBuysView
                            items={active_triumph_buys}
                            onRefund={handleTriumphRefund}
                          />
                        </Section>
                      ) : (
                        <Section fill scrollable title={triumphShopSubTab} key={triumphShopSubTab}>
                          <TriumphBuyCategoryView
                            items={
                              triumph_buy_categories[triumphShopSubTab] ?? []
                            }
                            balance={triumph_balance}
                            search={search}
                            onBuy={handleTriumphBuy}
                            onContribute={handleContribute}
                          />
                        </Section>
                      )}
                    </Stack.Item>
                  </Stack>
                )}

                {isTicketsTab && (
                  <TicketShopView
                    ownedTickets={owned_tickets}
                    ticketHistory={ticket_history}
                    incomingTrades={incoming_trades}
                    outgoingTrades={outgoing_trades}
                    lockedOfferingIds={locked_offering_ids}
                    onlineCkeys={online_ckeys}
                    lookupResultCkey={lookup_result_ckey}
                    lookupResultTickets={lookup_result_tickets}
                    onUseTicket={handleUseTicket}
                    onOfferTrade={handleOfferTrade}
                    onAcceptTrade={handleAcceptTrade}
                    onCancelTrade={handleCancelTrade}
                    onDeclineTrade={handleDeclineTrade}
                    onLookupCkey={handleLookupCkey}
                  />
                )}


                {!isSpecialsTab && !isTriumphShopTab && (
                  <Section
                    fill
                    scrollable
                    title={
                      effectiveTab === '__search__'
                        ? `Search: "${search}"`
                        : activeTab
                    }
                  >
                    {effectiveTab === '__search__' ? (
                      <LoadoutCategoryView
                        items={allLoadoutItems}
                        onBuySingle={handleBuySingle}
                        onBuyPermanent={handleBuyPermanent}
                        onEquip={handleEquip}
                        onUnequip={handleUnequip}
                        slotsUsed={slotsUsed}
                        search={search}
                        donator={donator}
                      />
                    ) : activeTab === 'Collection' ? (
                      <CollectionView
                        categories={categories}
                        onEquip={handleEquip}
                        onUnequip={handleUnequip}
                        slotsUsed={slotsUsed}
                        donator={donator}
                      />
                    ) : (
                      <LoadoutCategoryView
                        items={categories[activeTab] ?? []}
                        onBuySingle={handleBuySingle}
                        onBuyPermanent={handleBuyPermanent}
                        onEquip={handleEquip}
                        onUnequip={handleUnequip}
                        slotsUsed={slotsUsed}
                        donator={donator}
                        search=""
                      />
                    )}
                  </Section>
                )}
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
