import { useMemo, useState } from 'react';
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

export type TicketEntry = {
  ticket_id: string;
  ticket_type: 'loadout' | 'special' | 'job_boost' | 'unknown';
  name: string;
  description: string | null;
  granted_by: string;
  granted_at: string;
  grant_reason: string | null;
  ui_icon: string | null;
  ui_icon_state: string | null;
  ui_fa_icon: string;        // font-awesome fallback
  ui_color: string;          // hex accent
  ui_type_label: string;     // badge text
  ui_grant_summary: string;  // one-liner
};

export type HistoryEntry = {
  event: 'used' | 'traded_away' | 'traded_received' | 'granted' | 'converted';
  description: string;
  timestamp: string;
  // may be comma-joined list of ids for basket trades
  ticket_ids: string;
  names: string;
  received_names?: string;
  partner?: string;
};

export type IncomingTrade = {
  trade_id: string;
  from_ckey: string;
  /** Tickets they are giving us **/
  offered_tickets: TicketEntry[];
  offered_ticket_names: string[];
  /** Tickets they want from us **/
  requested_tickets: TicketEntry[];
  requested_ticket_names: string[];
  cancelling: BooleanLike;
};

export type OutgoingTrade = {
  trade_id: string;
  to_ckey: string;
  offered_ticket_ids: string[];
  offered_ticket_names: string[];
  requested_ticket_ids: string[];
  requested_ticket_names: string[];
  cancelling: BooleanLike;
};

const TicketSprite = ({ ticket, size = 2 }: { ticket: TicketEntry; size?: number }) => {
  if (ticket.ui_icon && ticket.ui_icon_state) {
    return (
      <DmIcon
        icon={ticket.ui_icon}
        icon_state={ticket.ui_icon_state}
        height={size}
        width={size}
        fallback={<Icon name="spinner" size={1} spin color="gray" />}
      />
    );
  }
  return (
    <Icon
      name={ticket.ui_fa_icon}
      size={Math.max(size - 0.5, 1)}
      color={ticket.ui_color}
    />
  );
};

const ticketGrantSummary = (t: TicketEntry) => t.ui_grant_summary;

type TicketCardProps = {
  ticket: TicketEntry;
  selected?: boolean;
  locked?: boolean;       // already in an outgoing trade
  onToggle?: (id: string) => void;  // basket selection
  onUse?: (id: string) => void;
  readOnly?: boolean;
};

const TicketCard = ({
  ticket,
  selected = false,
  locked = false,
  onToggle,
  onUse,
  readOnly = false,
}: TicketCardProps) => {
  const typeColor = ticket.ui_color;
  const isClickable = !!onToggle && !locked && !readOnly;

  return (
    <Box
      mb={0.5}
      style={{
        border: `1px solid ${selected ? typeColor : 'rgba(255,255,255,0.1)'}`,
        borderRadius: '4px',
        padding: '6px 8px',
        background: selected ? `${typeColor}18` : 'transparent',
        cursor: isClickable ? 'pointer' : 'default',
        opacity: locked ? 0.5 : 1,
      }}
      onClick={isClickable ? () => onToggle!(ticket.ticket_id) : undefined}
    >
      <Stack align="center">
        <Stack.Item
          width="3px"
          style={{
            alignSelf: 'stretch',
            background: typeColor,
            borderRadius: '2px',
            marginRight: '6px',
            flexShrink: 0,
          }}
        />
        <Stack.Item>
          <TicketSprite ticket={ticket} size={2} />
        </Stack.Item>
        <Stack.Item grow>
          <Box bold fontSize="0.9em">
            {ticket.name}
            {locked && (
              <Box as="span" color="average" fontSize="0.75em" ml={1}>
                (in trade)
              </Box>
            )}
          </Box>
          <Box fontSize="0.75em" color="label">
            {ticketGrantSummary(ticket)}
          </Box>
          {!!ticket.description && (
            <Box fontSize="0.7em" color="label">
              {ticket.description}
            </Box>
          )}
          <Box fontSize="0.65em" style={{ color: typeColor }}>
            {ticket.ui_type_label} &mdash; from {ticket.granted_by} on {ticket.granted_at}
            {!!ticket.grant_reason && ` (${ticket.grant_reason})`}
          </Box>
        </Stack.Item>
        {!readOnly && (
          <Stack.Item>
            {onToggle && (
              <Icon
                name={selected ? 'check-circle' : 'circle'}
                color={selected ? 'good' : 'label'}
              />
            )}
            {!onToggle && !!onUse && (
              <Button
                icon="play"
                color="good"
                disabled={locked}
                tooltip={
                  locked
                    ? 'Ticket is in a pending trade'
                    : ticketGrantSummary(ticket)
                }
                onClick={(e: React.MouseEvent) => {
                  e.stopPropagation();
                  onUse(ticket.ticket_id);
                }}
              >
                Use
              </Button>
            )}
          </Stack.Item>
        )}
      </Stack>
    </Box>
  );
};

const BasketSummary = ({
  offerTickets,
  requestTickets,
  targetCkey,
}: {
  offerTickets: TicketEntry[];
  requestTickets: TicketEntry[];
  targetCkey: string;
}) => {
  const hasOffer   = offerTickets.length > 0;
  const hasRequest = requestTickets.length > 0;
  if (!hasOffer && !hasRequest) return null;

  const Chip = ({ ticket }: { ticket: TicketEntry }) => (
    <Box
      as="span"
      mr={0.5}
      mb={0.25}
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        background: `${ticket.ui_color}22`,
        border: `1px solid ${ticket.ui_color}55`,
        borderRadius: '12px',
        padding: '1px 6px',
        fontSize: '0.8em',
      }}
    >
      <TicketSprite ticket={ticket} size={1} />
      <Box as="span" ml={0.5}>
        {ticket.name}
      </Box>
    </Box>
  );

  return (
    <Box
      mt={1}
      style={{
        background: 'rgba(255,255,255,0.04)',
        border: '1px solid rgba(255,255,255,0.12)',
        borderRadius: '4px',
        padding: '8px',
      }}
    >
      <Stack>
        <Stack.Item grow basis="50%">
          <Box fontSize="0.75em" color="good" bold mb={0.5}>
            <Icon name="arrow-right" mr={0.5} />
            You give to {targetCkey || '…'}
          </Box>
          {hasOffer ? (
            <Box>
              {offerTickets.map((t) => (
                <Chip key={t.ticket_id} ticket={t} />
              ))}
            </Box>
          ) : (
            <Box color="label" fontSize="0.8em">
              Nothing
            </Box>
          )}
        </Stack.Item>
        <Stack.Item
          width="1px"
          style={{ background: 'rgba(255,255,255,0.1)', margin: '0 8px' }}
        />
        <Stack.Item grow basis="50%">
          <Box fontSize="0.75em" color="average" bold mb={0.5}>
            <Icon name="arrow-left" mr={0.5} />
            You get from {targetCkey || '…'}
          </Box>
          {hasRequest ? (
            <Box>
              {requestTickets.map((t) => (
                <Chip key={t.ticket_id} ticket={t} />
              ))}
            </Box>
          ) : (
            <Box color="label" fontSize="0.8em">
              Nothing
            </Box>
          )}
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const IncomingTradeCard = ({
  trade,
  onAccept,
  onDecline,
}: {
  trade: IncomingTrade;
  onAccept: (id: string) => void;
  onDecline: (id: string) => void;
}) => {
  const [expanded, setExpanded] = useState(false);
  const isCancelling = !!trade.cancelling;
  const hasOffered   = trade.offered_tickets.length > 0;
  const hasRequested = trade.requested_tickets.length > 0;

  return (
    <Box
      mb={1}
      style={{
        border: '1px solid rgba(255,200,0,0.3)',
        borderRadius: '4px',
        padding: '8px',
        background: 'rgba(255,200,0,0.04)',
      }}
    >
      <Stack align="center">
        <Stack.Item grow>
          <Box bold fontSize="0.9em">
            <Icon name="exchange-alt" mr={0.5} color="average" />
            Trade offer from <b>{trade.from_ckey}</b>
          </Box>
          <Box fontSize="0.75em" color="label" mt={0.25}>
            {hasOffered
              ? `They give: ${trade.offered_ticket_names.join(', ')}`
              : 'They give: nothing'}
            {' · '}
            {hasRequested
              ? `They want: ${trade.requested_ticket_names.join(', ')}`
              : 'They want: nothing'}
          </Box>
          {isCancelling && (
            <Box fontSize="0.75em" color="average" mt={0.25}>
              <Icon name="hourglass-half" mr={0.5} />
              Sender is cancelling
            </Box>
          )}
        </Stack.Item>
        <Stack.Item>
          <Stack>
            <Button
              fontSize="0.8em"
              icon={expanded ? 'chevron-up' : 'chevron-down'}
              color="transparent"
              onClick={() => setExpanded(!expanded)}
            >
              {expanded ? 'Hide' : 'Details'}
            </Button>
            <Button
              icon="check"
              color="good"
              disabled={isCancelling}
              tooltip={
                isCancelling
                  ? 'Sender is cancelling'
                  : 'Accept'
              }
              onClick={() => onAccept(trade.trade_id)}
            >
              Accept
            </Button>
            <Button
              icon="times"
              color="bad"
              tooltip="Decline this offer"
              onClick={() => onDecline(trade.trade_id)}
            >
              Decline
            </Button>
          </Stack>
        </Stack.Item>
      </Stack>
      {expanded && (
        <Box mt={1}>
          <Stack>
            <Stack.Item grow basis="50%">
              <Box fontSize="0.75em" color="good" bold mb={0.5}>
                <Icon name="arrow-down" mr={0.5} />
                You receive
              </Box>
              {hasOffered ? (
                trade.offered_tickets.map((t) => (
                  <TicketCard key={t.ticket_id} ticket={t} readOnly />
                ))
              ) : (
                <Box color="label" fontSize="0.8em">
                  Nothing
                </Box>
              )}
            </Stack.Item>
            <Stack.Item
              width="1px"
              style={{
                background: 'rgba(255,255,255,0.1)',
                margin: '0 8px',
              }}
            />
            <Stack.Item grow basis="50%">
              <Box fontSize="0.75em" color="average" bold mb={0.5}>
                <Icon name="arrow-up" mr={0.5} />
                They take from you
              </Box>
              {hasRequested ? (
                trade.requested_tickets.map((t) => (
                  <TicketCard key={t.ticket_id} ticket={t} readOnly />
                ))
              ) : (
                <Box color="label" fontSize="0.8em">
                  Nothing
                </Box>
              )}
            </Stack.Item>
          </Stack>
        </Box>
      )}
    </Box>
  );
};

type TradeComposerProps = {
  ownedTickets: TicketEntry[];
  lockedOfferingIds: Set<string>;
  outgoingTrades: OutgoingTrade[];
  onlineCkeys: string[];
  lookupResultCkey: string | null;
  lookupResultTickets: TicketEntry[] | null;
  onLookupCkey: (ckey: string) => void;
  onOfferTrade: (
    offered_ids: string[],
    requested_ids: string[],
    to_ckey: string,
  ) => void;
  onCancelTrade: (trade_id: string) => void;
};

const TradeComposerPanel = ({
  ownedTickets,
  lockedOfferingIds,
  outgoingTrades,
  onlineCkeys,
  lookupResultCkey,
  lookupResultTickets,
  onLookupCkey,
  onOfferTrade,
  onCancelTrade,
}: TradeComposerProps) => {
  const [targetMode, setTargetMode] = useState<'online' | 'offline'>('online');
  const [targetCkey, setTargetCkey] = useState('');
  const [offlineInput, setOfflineInput] = useState('');

  const [offerIds, setOfferIds]     = useState<Set<string>>(new Set());
  const [requestIds, setRequestIds] = useState<Set<string>>(new Set());

  const effectiveCkey =
    targetMode === 'online' ? targetCkey : offlineInput.trim().toLowerCase();

  const toggle = (
    set: Set<string>,
    setter: React.Dispatch<React.SetStateAction<Set<string>>>,
    id: string,
  ) => {
    setter((prev) => {
      const next = new Set(prev);
      next.has(id) ? next.delete(id) : next.add(id);
      return next;
    });
  };

  const offerTickets   = ownedTickets.filter((t) => offerIds.has(t.ticket_id));
  const requestTickets = (lookupResultTickets ?? []).filter((t) =>
    requestIds.has(t.ticket_id),
  );

  const lookupIsFresh =
    lookupResultCkey && lookupResultCkey === effectiveCkey;

  const canSend =
    !!effectiveCkey &&
    (offerIds.size > 0 || requestIds.size > 0) &&
    [...offerIds].every((id) => !lockedOfferingIds.has(id));

  const handleSend = () => {
    if (!canSend) return;
    onOfferTrade([...offerIds], [...requestIds], effectiveCkey);
    setOfferIds(new Set());
    setRequestIds(new Set());
    setTargetCkey('');
    setOfflineInput('');
  };

  return (
    <Box>
      <Box mb={1}>
        <Box fontSize="0.8em" bold color="label" mb={0.5}>
          Who are you trading with?
        </Box>
        <Stack mb={0.5}>
          <Stack.Item>
            <Button
              selected={targetMode === 'online'}
              fontSize="0.8em"
              onClick={() => {
                setTargetMode('online');
                setTargetCkey('');
                setRequestIds(new Set());
              }}
            >
              Online
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              selected={targetMode === 'offline'}
              fontSize="0.8em"
              onClick={() => {
                setTargetMode('offline');
                setTargetCkey('');
                setRequestIds(new Set());
              }}
            >
              Offline (exact ckey)
            </Button>
          </Stack.Item>
        </Stack>

        {targetMode === 'online' ? (
          onlineCkeys.length === 0 ? (
            <Box color="label" fontSize="0.8em">
              No other players online.
            </Box>
          ) : (
            <Stack wrap>
              {onlineCkeys.map((ckey) => (
                <Stack.Item key={ckey} mb={0.25}>
                  <Button
                    selected={targetCkey === ckey}
                    fontSize="0.8em"
                    onClick={() => {
                      setTargetCkey(ckey);
                      setRequestIds(new Set());
                      onLookupCkey(ckey);
                    }}
                  >
                    {ckey}
                  </Button>
                </Stack.Item>
              ))}
            </Stack>
          )
        ) : (
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                placeholder="Enter exact ckey…"
                value={offlineInput}
                onChange={(v: string) => setOfflineInput(v)}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="search"
                disabled={!offlineInput.trim()}
                onClick={() => {
                  setRequestIds(new Set());
                  onLookupCkey(offlineInput.trim().toLowerCase());
                }}
              >
                Look up
              </Button>
            </Stack.Item>
          </Stack>
        )}
      </Box>

      <Box mb={1}>
        <Box fontSize="0.8em" bold color="label" mb={0.5}>
          Tickets you are offering{' '}
          {offerIds.size > 0 && (
            <Box as="span" color="good">
              ({offerIds.size} selected)
            </Box>
          )}
        </Box>
        {ownedTickets.length === 0 ? (
          <Box color="label" fontSize="0.8em">
            You have no tickets to offer.
          </Box>
        ) : (
          ownedTickets.map((t) => (
            <TicketCard
              key={t.ticket_id}
              ticket={t}
              selected={offerIds.has(t.ticket_id)}
              locked={lockedOfferingIds.has(t.ticket_id)}
              onToggle={(id) => toggle(offerIds, setOfferIds, id)}
            />
          ))
        )}
        {offerIds.size > 0 && (
          <Button
            fontSize="0.75em"
            color="transparent"
            icon="times"
            mt={0.5}
            onClick={() => setOfferIds(new Set())}
          >
            Clear offer selection
          </Button>
        )}
      </Box>

      <Box mb={1}>
        <Box fontSize="0.8em" bold color="label" mb={0.5}>
          Tickets you want in return{' '}
          {requestIds.size > 0 && (
            <Box as="span" color="average">
              ({requestIds.size} selected)
            </Box>
          )}
        </Box>
        {!effectiveCkey ? (
          <Box color="label" fontSize="0.8em">
            Select a player first to see their tickets.
          </Box>
        ) : !lookupIsFresh ? (
          <Box color="label" fontSize="0.8em">
            {targetMode === 'offline'
              ? 'Click "Look up" to fetch their inventory.'
              : 'Select a player above to load their tickets.'}
          </Box>
        ) : !lookupResultTickets || lookupResultTickets.length === 0 ? (
          <Box color="label" fontSize="0.8em">
            {lookupResultCkey} has no tickets.
          </Box>
        ) : (
          lookupResultTickets.map((t) => (
            <TicketCard
              key={t.ticket_id}
              ticket={t}
              selected={requestIds.has(t.ticket_id)}
              onToggle={(id) => toggle(requestIds, setRequestIds, id)}
            />
          ))
        )}
        {requestIds.size > 0 && (
          <Button
            fontSize="0.75em"
            color="transparent"
            icon="times"
            mt={0.5}
            onClick={() => setRequestIds(new Set())}
          >
            Clear request selection
          </Button>
        )}
      </Box>

      <BasketSummary
        offerTickets={offerTickets}
        requestTickets={requestTickets}
        targetCkey={effectiveCkey}
      />

      <Box mt={1}>
        <Button
          fluid
          icon="paper-plane"
          color={canSend ? 'good' : 'bad'}
          disabled={!canSend}
          tooltip={
            !effectiveCkey
              ? 'Select a target player first'
              : offerIds.size === 0 && requestIds.size === 0
              ? 'Select at least one ticket on either side'
              : [...offerIds].some((id) => lockedOfferingIds.has(id))
              ? 'One of your selected tickets is already in a pending trade'
              : 'Send trade offer'
          }
          onClick={handleSend}
        >
          Send Trade Offer
        </Button>
      </Box>
      {outgoingTrades.length > 0 && (
        <Box mt={1}>
          <Box fontSize="0.8em" bold color="label" mb={0.5}>
            Your pending outgoing trades:
          </Box>
          {outgoingTrades.map((tr) => (
            <Box
              key={tr.trade_id}
              mb={0.5}
              style={{
                border: '1px solid rgba(255,255,255,0.1)',
                borderRadius: '4px',
                padding: '6px 8px',
              }}
            >
              <Stack align="center">
                <Stack.Item grow>
                  <Box fontSize="0.85em">
                    <Icon name="exchange-alt" mr={0.5} color="label" />
                    To <b>{tr.to_ckey}</b>
                    {!!tr.cancelling && (
                      <Box as="span" color="average" fontSize="0.8em" ml={1}>
                        (cancelling…)
                      </Box>
                    )}
                  </Box>
                  <Box fontSize="0.75em" color="label">
                    {tr.offered_ticket_names.length > 0
                      ? `Offering: ${tr.offered_ticket_names.join(', ')}`
                      : 'Offering: nothing'}
                    {tr.requested_ticket_names.length > 0 &&
                      ` · Wanting: ${tr.requested_ticket_names.join(', ')}`}
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="times"
                    color="bad"
                    disabled={!!tr.cancelling}
                    fontSize="0.8em"
                    tooltip={
                      tr.cancelling
                        ? 'Cancel in progress'
                        : 'Cancel (5s anti-dupe lock)'
                    }
                    onClick={() => onCancelTrade(tr.trade_id)}
                  >
                    Cancel
                  </Button>
                </Stack.Item>
              </Stack>
            </Box>
          ))}
        </Box>
      )}
    </Box>
  );
};

const EVENT_ICON: Record<string, string> = {
  used: 'play',
  traded_away: 'arrow-right',
  traded_received: 'arrow-left',
  granted: 'arrow-left',
  converted: 'arrow-left',
};
const EVENT_COLOR: Record<string, string> = {
  used: 'good',
  traded_away: 'average',
  traded_received: '#2196f3',
  granted: 'good',
  converted: 'bad',
};
const EVENT_LABEL: Record<string, string> = {
  used: 'Used',
  traded_away: 'Traded away',
  traded_received: 'Received via trade',
  granted: 'Given',
  converted: "Converted",
};

const HistoryView = ({ history }: { history: HistoryEntry[] }) => {
  const sorted = useMemo(() => [...history].reverse(), [history]);

  if (!sorted.length) {
    return (
      <NoticeBox>
        No history yet, use or trade a ticket to see it here.
      </NoticeBox>
    );
  }

  return (
    <Box>
      {sorted.map((entry, i) => {
        const color = EVENT_COLOR[entry.event] ?? 'label';
        const icon  = EVENT_ICON[entry.event] ?? 'info';
        const label = EVENT_LABEL[entry.event] ?? entry.event;
        return (
          <Stack key={i} align="center" mb={0.75}>
            <Stack.Item>
              <Icon name={icon} color={color} />
            </Stack.Item>
            <Stack.Item grow>
              <Box fontSize="0.85em">
                <Box as="span" style={{ color }} bold>
                  {label}
                </Box>
                <b>{entry.names}</b>
                {!!entry.received_names && (
                  <Box as="span" color="label">
                    {' ↔ '}{entry.received_names}
                  </Box>
                )}
                {!!entry.partner && (
                  <Box as="span" color="label">
                    {' '}
                    {entry.event === 'traded_away'
                      ? `→ ${entry.partner}`
                      : `← ${entry.partner}`}
                  </Box>
                )}
              </Box>
              {!!entry.description && (
                <Box fontSize="0.7em" color="label">
                  {entry.description}
                </Box>
              )}
              <Box fontSize="0.7em" color="label">
                {entry.timestamp}
              </Box>
            </Stack.Item>
          </Stack>
        );
      })}
    </Box>
  );
};

type TicketShopViewProps = {
  ownedTickets: TicketEntry[];
  ticketHistory: HistoryEntry[];
  incomingTrades: IncomingTrade[];
  outgoingTrades: OutgoingTrade[];
  lockedOfferingIds: string[];   // ticket_ids locked in outgoing trades
  onlineCkeys: string[];
  lookupResultCkey: string | null;
  lookupResultTickets: TicketEntry[] | null;
  onUseTicket: (ticket_id: string) => void;
  onOfferTrade: (
    offered_ids: string[],
    requested_ids: string[],
    to_ckey: string,
  ) => void;
  onAcceptTrade: (trade_id: string) => void;
  onCancelTrade: (trade_id: string) => void;
  onDeclineTrade: (trade_id: string) => void;
  onLookupCkey: (ckey: string) => void;
};

type SubTab = 'inventory' | 'trade' | 'history';

export const TicketShopView = ({
  ownedTickets,
  ticketHistory,
  incomingTrades,
  outgoingTrades,
  lockedOfferingIds,
  onlineCkeys,
  lookupResultCkey,
  lookupResultTickets,
  onUseTicket,
  onOfferTrade,
  onAcceptTrade,
  onCancelTrade,
  onDeclineTrade,
  onLookupCkey,
}: TicketShopViewProps) => {
  const [subTab, setSubTab] = useState<SubTab>('inventory');

  const lockedSet = useMemo(
    () => new Set(lockedOfferingIds),
    [lockedOfferingIds],
  );

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section>
          <Tabs>
            <Tabs.Tab
              selected={subTab === 'inventory'}
              onClick={() => setSubTab('inventory')}
            >
              <Icon name="ticket-alt" mr={1} />
              My Tickets
              {ownedTickets.length > 0 && (
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
                  {ownedTickets.length}
                </Box>
              )}
            </Tabs.Tab>
            <Tabs.Tab
              selected={subTab === 'trade'}
              onClick={() => setSubTab('trade')}
            >
              <Icon name="exchange-alt" mr={1} />
              Trade
              {incomingTrades.length > 0 && (
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
                  {incomingTrades.length}
                </Box>
              )}
            </Tabs.Tab>
            <Tabs.Tab
              selected={subTab === 'history'}
              onClick={() => setSubTab('history')}
            >
              <Icon name="history" mr={1} />
              History
            </Tabs.Tab>
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        {subTab === 'inventory' && (
          <Section fill scrollable title="My Tickets">
            {ownedTickets.length === 0 ? (
              <NoticeBox>
                You have no tickets. Tickets are granted by admins and server
                events.
              </NoticeBox>
            ) : (
              ownedTickets.map((t) => (
                <TicketCard
                  key={t.ticket_id}
                  ticket={t}
                  locked={lockedSet.has(t.ticket_id)}
                  onUse={onUseTicket}
                />
              ))
            )}
          </Section>
        )}

        {subTab === 'trade' && (
          <Stack vertical fill>
            {incomingTrades.length > 0 && (
              <Stack.Item>
                <Section
                  title={`Incoming Trade Offers (${incomingTrades.length})`}
                >
                  {incomingTrades.map((tr) => (
                    <IncomingTradeCard
                      key={tr.trade_id}
                      trade={tr}
                      onAccept={onAcceptTrade}
                      onDecline={onDeclineTrade}
                    />
                  ))}
                </Section>
              </Stack.Item>
            )}
            <Stack.Item grow>
              <Section fill scrollable title="Compose a Trade Offer">
                <TradeComposerPanel
                  ownedTickets={ownedTickets}
                  lockedOfferingIds={lockedSet}
                  outgoingTrades={outgoingTrades}
                  onlineCkeys={onlineCkeys}
                  lookupResultCkey={lookupResultCkey}
                  lookupResultTickets={lookupResultTickets}
                  onLookupCkey={onLookupCkey}
                  onOfferTrade={onOfferTrade}
                  onCancelTrade={onCancelTrade}
                />
              </Section>
            </Stack.Item>
          </Stack>
        )}

        {subTab === 'history' && (
          <Section fill scrollable title="Ticket History">
            <HistoryView history={ticketHistory} />
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};
