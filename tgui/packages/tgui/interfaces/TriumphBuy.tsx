import { useMemo, useState } from 'react';
import { Box, Button, Icon, NoticeBox, NumberInput, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export type TriumphBuyEntry = {
  ref: string;
  triumph_buy_id: string;
  name: string;
  desc: string;
  cost: number;
  category: string;
  is_communal: BooleanLike;
  communal_current: number;
  communal_max: number;
  communal_activated: BooleanLike;
  pre_round_only: BooleanLike;
  limited: BooleanLike;
  /** -1 = unlimited */
  stock: number;
  conflicted: BooleanLike;
  disabled: BooleanLike;
  allow_multiple: BooleanLike;
  already_owned: BooleanLike;
  can_be_refunded: BooleanLike;
  activated: BooleanLike;
  is_seasonal: BooleanLike;
  visible_active: BooleanLike;
};

export type ActiveTriumphBuy = {
  ref: string;
  triumph_buy_id: string;
  name: string;
  desc: string;
  cost: number;
  pre_round_only: BooleanLike;
  can_be_refunded: BooleanLike;
  activated: BooleanLike;
  is_seasonal: BooleanLike;
};

const CommunalContributor = ({
  entry,
  balance,
  onContribute,
}: {
  entry: TriumphBuyEntry;
  balance: number;
  onContribute: (ref: string, amount: number) => void;
}) => {
  const remaining = Math.max(0, entry.communal_max - entry.communal_current);
  const maxPossible = Math.min(balance, remaining > 0 ? remaining : balance);
  const [amount, setAmount] = useState(1);

  const progressPct =
    entry.communal_max > 0
      ? Math.min(100, (entry.communal_current / entry.communal_max) * 100)
      : 0;

  const canContribute =
    !entry.communal_activated && amount > 0 && amount <= balance && balance > 0;

  return (
    <Box mt={1} ml={2} mb={1}>
      <Box mb={0.5}>
        <Stack align="center" mb={0.25}>
          <Stack.Item grow>
            <Box fontSize="0.8em" color="label">
              Community pool: {entry.communal_current.toLocaleString()}
              {entry.communal_max > 0 &&
                ` / ${entry.communal_max.toLocaleString()}`}
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Box fontSize="0.8em" color="label">
              {Math.round(progressPct)}%
            </Box>
          </Stack.Item>
        </Stack>
        <Box
          style={{
            height: '6px',
            background: 'rgba(255,255,255,0.1)',
            borderRadius: '3px',
            overflow: 'hidden',
          }}
        >
          <Box
            style={{
              height: '100%',
              width: `${progressPct}%`,
              background: progressPct >= 100 ? '#4caf50' : '#2196f3',
              borderRadius: '3px',
              transition: 'width 0.3s ease',
            }}
          />
        </Box>
      </Box>

      {entry.communal_activated ? (
        <Box color="good" fontSize="0.85em">
          <Icon name="check-circle" mr={1} />
          This communal goal is already active!
        </Box>
      ) : remaining === 0 && entry.communal_max > 0 ? (
        <Box color="average" fontSize="0.85em">
          Pool is full.
        </Box>
      ) : (
        <Stack align="center">
          <Stack.Item>
            <Box fontSize="0.8em" color="label" mb={0.25}>
              Contribute triumphs:
            </Box>
            <NumberInput
              value={amount}
              minValue={1}
              maxValue={maxPossible > 0 ? maxPossible : 1}
              stepPixelSize={4}
              onChange={(val: number) => setAmount(Math.max(1, Math.floor(val)))}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="donate"
              color={canContribute ? 'good' : 'bad'}
              disabled={!canContribute}
              tooltip={
                balance <= 0
                  ? 'No triumphs to contribute'
                  : amount > balance
                    ? `You only have ${balance} triumphs`
                    : `Contribute ${amount} triumph${amount !== 1 ? 's' : ''}`
              }
              onClick={() => onContribute(entry.ref, amount)}
            >
              Contribute ({amount})
            </Button>
          </Stack.Item>
          {maxPossible > 0 && (
            <Stack.Item>
              <Button
                icon="angle-double-right"
                color="transparent"
                tooltip={`Contribute all you can (${maxPossible})`}
                onClick={() => setAmount(maxPossible)}
              >
                Max
              </Button>
            </Stack.Item>
          )}
        </Stack>
      )}
    </Box>
  );
};

const TriumphBuyRow = ({
  entry,
  balance,
  onBuy,
  onContribute,
}: {
  entry: TriumphBuyEntry;
  balance: number;
  onBuy: (ref: string) => void;
  onContribute: (ref: string, amount: number) => void;
}) => {
  const [communalOpen, setCommunalOpen] = useState(false);

  const isCommunal = !!entry.is_communal;
  const disabled = !!entry.disabled;
  const conflicted = !!entry.conflicted;
  const preRound = !!entry.pre_round_only;
  const outOfStock = !!entry.limited && entry.stock <= 0;
  const alreadyOwned = !!entry.already_owned;
  const activated = !!entry.activated;
  const isSeasonal = !!entry.is_seasonal;
  const canAfford = balance >= entry.cost;

  let statusText: string | null = null;
  let statusColor = 'label';
  if (disabled) {
    statusText = 'Disabled';
    statusColor = 'bad';
  } else if (conflicted) {
    statusText = preRound ? 'Round started' : 'Conflict';
    statusColor = 'average';
  } else if (outOfStock) {
    statusText = 'Out of stock';
    statusColor = 'bad';
  } else if (alreadyOwned) {
    statusText = isSeasonal ? 'Active (seasonal)' : 'Purchased';
    statusColor = 'good';
  } else if (isCommunal && activated) {
    statusText = 'Active';
    statusColor = 'good';
  }

  const buyBlocked =
    disabled || conflicted || outOfStock || alreadyOwned || (isCommunal && activated);

  return (
    <Box mb={1}>
      <Stack align="center">
        <Stack.Item>
          <Icon
            name={
              isCommunal ? 'users' : isSeasonal ? 'snowflake' : 'shopping-bag'
            }
            color={isSeasonal ? 'blue' : isCommunal ? 'teal' : 'label'}
            mr={1}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Box bold>{entry.name}</Box>
          <Box color="label" fontSize="0.8em">
            {entry.desc}
          </Box>
          {isCommunal && (
            <Box fontSize="0.75em" color="teal" mt={0.25}>
              <Icon name="users" mr={0.5} />
              Community goal
              {entry.communal_max > 0 &&
                `  ${entry.communal_current.toLocaleString()} / ${entry.communal_max.toLocaleString()}`}
            </Box>
          )}
          {isSeasonal && (
            <Box fontSize="0.75em" color="blue" mt={0.25}>
              <Icon name="snowflake" mr={0.5} />
              Seasonal: persists across rounds
            </Box>
          )}
        </Stack.Item>

        {statusText && (
          <Stack.Item>
            <Box color={statusColor} fontSize="0.8em">
              {statusText}
            </Box>
          </Stack.Item>
        )}

        {!!entry.limited && entry.stock > 0 && (
          <Stack.Item>
            <Box color="label" fontSize="0.8em">
              {entry.stock} left
            </Box>
          </Stack.Item>
        )}

        <Stack.Item>
          {isCommunal && !disabled ? (
            <Button
              icon={communalOpen ? 'chevron-up' : 'donate'}
              color={
                communalOpen
                  ? 'average'
                  : canAfford && !activated
                    ? 'good'
                    : 'transparent'
              }
              disabled={activated}
              tooltip={
                activated
                  ? 'Already active'
                  : communalOpen
                    ? 'Close contribution panel'
                    : 'Contribute triumphs'
              }
              onClick={() => setCommunalOpen((o) => !o)}
            >
              {activated ? 'Active' : 'Contribute'}
            </Button>
          ) : (
            <Button
              icon={alreadyOwned ? 'check' : 'shopping-bag'}
              color={
                buyBlocked ? 'transparent' : canAfford ? 'good' : 'bad'
              }
              disabled={buyBlocked || !canAfford}
              tooltip={
                disabled
                  ? 'This item is currently disabled by administrators'
                  : conflicted
                    ? preRound
                      ? 'Only available before the round starts'
                      : 'Conflicts with something you already have'
                    : outOfStock
                      ? 'No stock remaining'
                      : alreadyOwned
                        ? 'Already purchased'
                        : !canAfford
                          ? `Need ${entry.cost} triumphs (you have ${balance})`
                          : `Buy for ${entry.cost} triumph${entry.cost !== 1 ? 's' : ''}`
              }
              onClick={() => !buyBlocked && canAfford && onBuy(entry.ref)}
            >
              {alreadyOwned ? 'Purchased' : `Buy (${entry.cost})`}
            </Button>
          )}
        </Stack.Item>
      </Stack>

      {isCommunal && communalOpen && !activated && (
        <CommunalContributor
          entry={entry}
          balance={balance}
          onContribute={(ref, amt) => {
            onContribute(ref, amt);
            setCommunalOpen(false);
          }}
        />
      )}
    </Box>
  );
};

export const TriumphBuyCategoryView = ({
  items,
  balance,
  search,
  onBuy,
  onContribute,
}: {
  items: TriumphBuyEntry[];
  balance: number;
  search: string;
  onBuy: (ref: string) => void;
  onContribute: (ref: string, amount: number) => void;
}) => {
  const filtered = useMemo(() => {
    if (!search) return items;
    const q = search.toLowerCase();
    return items.filter(
      (i) =>
        i.name.toLowerCase().includes(q) || i.desc.toLowerCase().includes(q),
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
      {filtered.map((entry) => (
        <TriumphBuyRow
          key={entry.triumph_buy_id}
          entry={entry}
          balance={balance}
          onBuy={onBuy}
          onContribute={onContribute}
        />
      ))}
    </Box>
  );
};

export const ActiveTriumphBuysView = ({
  items,
  onRefund,
}: {
  items: ActiveTriumphBuy[];
  onRefund: (ref: string) => void;
}) => {
  if (!items.length) {
    return (
      <NoticeBox>
        You have no active triumph purchases this round. Browse the shop tabs to
        spend triumphs!
      </NoticeBox>
    );
  }

  return (
    <Box>
      {items.map((entry) => {
        const roundStarted = !!entry.pre_round_only; // server already set conflicted if round started
        const canRefund = !!entry.can_be_refunded && !entry.activated;
        const isSeasonal = !!entry.is_seasonal;

        return (
          <Stack key={entry.triumph_buy_id} align="center" mb={1}>
            <Stack.Item>
              <Icon
                name={isSeasonal ? 'snowflake' : 'shopping-bag'}
                color={isSeasonal ? 'blue' : 'good'}
                mr={1}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Box bold>{entry.name}</Box>
              <Box color="label" fontSize="0.8em">
                {entry.desc}
              </Box>
              {isSeasonal && (
                <Box fontSize="0.75em" color="blue" mt={0.25}>
                  <Icon name="snowflake" mr={0.5} />
                  Seasonal: no refund available
                </Box>
              )}
              {entry.activated && !isSeasonal && (
                <Box fontSize="0.75em" color="average" mt={0.25}>
                  Already activated, cannot refund
                </Box>
              )}
            </Stack.Item>
            <Stack.Item>
              {canRefund ? (
                <Button
                  icon="undo"
                  color="average"
                  tooltip={
                    roundStarted
                      ? 'Round has started, refund may be unavailable'
                      : 'Refund this purchase'
                  }
                  onClick={() => onRefund(entry.ref)}
                >
                  Refund
                </Button>
              ) : (
                <Box color="label" fontSize="0.8em">
                  {isSeasonal ? 'No refund' : 'Activated'}
                </Box>
              )}
            </Stack.Item>
          </Stack>
        );
      })}
    </Box>
  );
};
