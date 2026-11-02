import { useRef, useState } from 'react';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  Box,
  Button,
  Dropdown,
  Input,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';

type WageSortOrder = 'none' | 'desc' | 'asc';

type StockEntry = {
  ref: string;
  name: string;
  desc: string;
  held: number;
  payoutPrice: number;
  withdrawPrice: number;
  withdrawDisabled: boolean;
  percentBounty: boolean;
  demand: string;
  oversupplyAmount: number;
  oversupplyPayout: number;
  importExportAmt: number;
  importPrice?: number;
  exportPrice?: number;
  stablePrice?: boolean;
  createdBy?: string;
};

type WageEntry = {
  title: string;
  category: string;
  wage: number;
};

type Account = {
  ref: string;
  name: string;
  balance: number;
  title: string;
};

type JobEntry = {
  ref: string;
  name: string;
  title: string;
  isLord: boolean;
};

type AvailableItem = {
  name: string;
  path: string;
};

type Data = {
  treasury: number;
  lordTax: number;
  queensTax: number;
  accounts: Account[];
  stockpiles: StockEntry[];
  imports: StockEntry[];
  bounties: StockEntry[];
  customStocks: StockEntry[];
  availableItems: AvailableItem[];
  jobs: JobEntry[];
  assignableJobs: string[];
  payableJobs: string[];
  log: string[];
  wages: WageEntry[];
};

type TabName =
  | 'bank'
  | 'stockpile'
  | 'import'
  | 'bounties'
  | 'jobs'
  | 'custom'
  | 'log'
  | 'wages';

export const Steward = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    treasury = 0,
    lordTax = 0,
    queensTax = 0,
    accounts = [],
    stockpiles = [],
    imports = [],
    bounties = [],
    customStocks = [],
    availableItems = [],
    jobs = [],
    assignableJobs = [],
    payableJobs = [],
    wages = [],
    log = [],
  } = data;

  const [tab, setTab] = useState<TabName>('bank');
  const [compact, setCompact] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');

  const normalizedQuery = (searchQuery || '').toLowerCase().trim();

  const filteredAccounts = accounts.filter(
    (acc) =>
      (acc.name || '').toLowerCase().includes(normalizedQuery) ||
      (acc.title || '').toLowerCase().includes(normalizedQuery)
  );

  const filteredStockpiles = stockpiles.filter(
    (entry) =>
      (entry.name || '').toLowerCase().includes(normalizedQuery) ||
      (entry.desc || '').toLowerCase().includes(normalizedQuery)
  );

  const filteredImports = imports.filter(
    (entry) =>
      (entry.name || '').toLowerCase().includes(normalizedQuery) ||
      (entry.desc || '').toLowerCase().includes(normalizedQuery)
  );

  const filteredBounties = bounties.filter(
    (entry) =>
      (entry.name || '').toLowerCase().includes(normalizedQuery) ||
      (entry.desc || '').toLowerCase().includes(normalizedQuery)
  );

  const filteredJobs = jobs.filter(
    (job) =>
      (job.name || '').toLowerCase().includes(normalizedQuery) ||
      (job.title || '').toLowerCase().includes(normalizedQuery)
  );

  const filteredWages = wages.filter(
    (wage) =>
      (wage.title || '').toLowerCase().includes(normalizedQuery) ||
      (wage.category || '').toLowerCase().includes(normalizedQuery)
  );

  const filteredCustomStocks = customStocks.filter(
    (entry) =>
      (entry.name || '').toLowerCase().includes(normalizedQuery) ||
      (entry.desc || '').toLowerCase().includes(normalizedQuery)
  );

  const filteredLog = log.filter((line) =>
    (line || '').toLowerCase().includes(normalizedQuery)
  );

  const handleSearchInput = (e: any, value: any) => {
    if (typeof value === 'string') {
      setSearchQuery(value);
    } else if (e && e.target && typeof e.target.value === 'string') {
      setSearchQuery(e.target.value);
    } else if (typeof e === 'string') {
      setSearchQuery(e);
    } else {
      setSearchQuery('');
    }
  };

  return (
    <Window title="Master of Nerves" width={860} height={560}>
      <Window.Content scrollable>
        <Section>
          <Table>
            <Table.Row>
              <Table.Cell bold width="120px">
                Treasury:
              </Table.Cell>
              <Table.Cell>{treasury}m</Table.Cell>
              <Table.Cell bold width="100px">
                Lord's Tax:
              </Table.Cell>
              <Table.Cell>
                <LordTaxControl value={lordTax} />
              </Table.Cell>
              <Table.Cell bold width="110px">
                Guild's Tax:
              </Table.Cell>
              <Table.Cell>{queensTax}%</Table.Cell>
            </Table.Row>
          </Table>
        </Section>

        <Box mb={1}>
          <Input
            placeholder="Search across all tabs..."
            value={searchQuery}
            onInput={handleSearchInput}
            fluid
          />
        </Box>

        <Tabs>
          <Tabs.Tab icon="landmark" selected={tab === 'bank'} onClick={() => setTab('bank')}>
            Bank
          </Tabs.Tab>
          <Tabs.Tab icon="boxes" selected={tab === 'stockpile'} onClick={() => setTab('stockpile')}>
            Stockpile
          </Tabs.Tab>
          <Tabs.Tab icon="ship" selected={tab === 'import'} onClick={() => setTab('import')}>
            Import
          </Tabs.Tab>
          <Tabs.Tab icon="scroll" selected={tab === 'bounties'} onClick={() => setTab('bounties')}>
            Bounties
          </Tabs.Tab>
          <Tabs.Tab icon="user-tie" selected={tab === 'jobs'} onClick={() => setTab('jobs')}>
            Jobs
          </Tabs.Tab>
          <Tabs.Tab icon="coins" selected={tab === 'wages'} onClick={() => setTab('wages')}>
            Wages
          </Tabs.Tab>
          <Tabs.Tab icon="wrench" selected={tab === 'custom'} onClick={() => setTab('custom')}>
            Custom
          </Tabs.Tab>
          <Tabs.Tab icon="book" selected={tab === 'log'} onClick={() => setTab('log')}>
            Log
          </Tabs.Tab>
        </Tabs>

        {tab === 'bank' && <BankTab accounts={filteredAccounts} />}

        {tab === 'stockpile' && (
          <StockTab
            title="Stockpile"
            entries={filteredStockpiles}
            compact={compact}
            onToggleCompact={() => setCompact(!compact)}
            showImportExport
          />
        )}

        {tab === 'import' && (
          <StockTab
            title="Imports"
            entries={filteredImports}
            compact={compact}
            onToggleCompact={() => setCompact(!compact)}
            showImportOnly
          />
        )}

        {tab === 'wages' && <WagesTab entries={filteredWages} />}

        {tab === 'bounties' && <BountyTab entries={filteredBounties} />}

        {tab === 'jobs' && (
          <JobsTab
            jobs={filteredJobs}
            assignableJobs={assignableJobs}
            payableJobs={payableJobs}
          />
        )}

        {tab === 'custom' && (
          <CustomTab
            entries={filteredCustomStocks}
            availableItems={availableItems}
            compact={compact}
            onToggleCompact={() => setCompact(!compact)}
          />
        )}

        {tab === 'log' && <LogTab entries={filteredLog} />}
      </Window.Content>
    </Window>
  );
};

const LordTaxControl = ({ value }: { value: number }) => {
  const { act } = useBackend<Data>();
  const [tax, setTax] = useState(value);
  return (
    <Stack align="center">
      <Stack.Item>
        <NumberInput
          width="55px"
          step={1}
          minValue={1}
          maxValue={99}
          value={tax}
          onChange={setTax}
        />
      </Stack.Item>
      <Stack.Item>
        <Button onClick={() => act('set_tax', { value: tax })}>Set</Button>
      </Stack.Item>
    </Stack>
  );
};

const MoneyControl = ({
  action,
  refId,
  initial = 0,
  label,
  color,
}: {
  action: string;
  refId: string;
  initial?: number;
  label: string;
  color?: string;
}) => {
  const { act } = useBackend<Data>();
  const [value, setValue] = useState(initial);
  return (
    <Stack align="center" justify="flex-end">
      <Stack.Item>
        <NumberInput width="60px" step={1} minValue={1} maxValue={9999} value={value} onChange={setValue} />
      </Stack.Item>
      <Stack.Item>
        <Button color={color} onClick={() => act(action, { ref: refId, value })}>
          {label}
        </Button>
      </Stack.Item>
    </Stack>
  );
};

const BankTab = ({ accounts }: { accounts: Account[] }) => (
  <Section title="Bank Accounts">
    <Table>
      <Table.Row header>
        <Table.Cell>Name</Table.Cell>
        <Table.Cell>Balance</Table.Cell>
        <Table.Cell align="right">Give</Table.Cell>
        <Table.Cell align="right">Fine</Table.Cell>
      </Table.Row>
      {accounts.length === 0 ? (
        <Table.Row>
          <Table.Cell colSpan={4}>No accounts found.</Table.Cell>
        </Table.Row>
      ) : (
        accounts.map((acc) => (
          <Table.Row key={acc.ref} className="candystripe">
            <Table.Cell verticalAlign="middle">
              <Box bold>{acc.name}</Box>
              {!!acc.title && (
                <Box color="label" fontSize="0.9em">
                  {acc.title}
                </Box>
              )}
            </Table.Cell>
            <Table.Cell verticalAlign="middle">{acc.balance}m</Table.Cell>
            <Table.Cell verticalAlign="middle" align="right">
              <MoneyControl action="give_money" refId={acc.ref} label="Give" color="good" />
            </Table.Cell>
            <Table.Cell verticalAlign="middle" align="right">
              <MoneyControl action="fine_account" refId={acc.ref} label="Fine" color="bad" />
            </Table.Cell>
          </Table.Row>
        ))
      )}
    </Table>
  </Section>
);

const StockRowCompact = ({
  entry,
  showImportExport,
  showImportOnly,
}: {
  entry: StockEntry;
  showImportExport?: boolean;
  showImportOnly?: boolean;
}) => {
  const { act } = useBackend<Data>();

  return (
    <Table.Row className="candystripe">
      <Table.Cell verticalAlign="middle">
        <Box bold>{entry.name}</Box>
      </Table.Cell>
      <Table.Cell verticalAlign="middle">{entry.held}</Table.Cell>
      <Table.Cell verticalAlign="middle">
        <NumberInput
          width="60px"
          step={1}
          minValue={0}
          maxValue={999}
          value={entry.payoutPrice}
          onChange={(value) => act('set_bounty', { ref: entry.ref, value })}
        />
      </Table.Cell>
      {!showImportOnly && (
        <Table.Cell verticalAlign="middle">
          <NumberInput
            width="60px"
            step={1}
            minValue={0}
            maxValue={999}
            value={entry.withdrawPrice}
            onChange={(value) => act('set_withdraw_price', { ref: entry.ref, value })}
          />
        </Table.Cell>
      )}
      <Table.Cell verticalAlign="middle" align="right">
        {!!entry.importExportAmt && (
          <Stack justify="flex-end">
            {(showImportExport || showImportOnly) && (
              <Stack.Item>
                <Button compact icon="ship" onClick={() => act('import', { ref: entry.ref })}>
                  Imp {entry.importExportAmt} ({entry.importPrice})
                </Button>
              </Stack.Item>
            )}
            {showImportExport && (
              <Stack.Item>
                <Button compact icon="truck" onClick={() => act('export', { ref: entry.ref })}>
                  Exp {entry.importExportAmt} ({entry.exportPrice})
                </Button>
              </Stack.Item>
            )}
          </Stack>
        )}
      </Table.Cell>
    </Table.Row>
  );
};

const StockCard = ({
  entry,
  showImportExport,
  showImportOnly,
}: {
  entry: StockEntry;
  showImportExport?: boolean;
  showImportOnly?: boolean;
}) => {
  const { act } = useBackend<Data>();

  return (
    <Box
      mb={1}
      p={1}
      style={{
        width: '100%',
        boxSizing: 'border-box',
        backgroundColor: 'rgba(255, 255, 255, 0.04)',
        border: '1px solid rgba(255, 255, 255, 0.1)',
        borderRadius: '4px',
      }}
    >
      <Stack vertical align="stretch">
        <Stack.Item>
          <Box bold fontSize="1.1em">{entry.name}</Box>
          <Box color="label" fontSize="0.9em">
            {entry.desc}
          </Box>
        </Stack.Item>
        <Stack.Item>Stockpiled Amount: {entry.held}</Stack.Item>
        {!entry.stablePrice && <Stack.Item>Demand: {entry.demand}</Stack.Item>}
        <Stack.Item>
          <Stack align="center">
            <Stack.Item width="140px">Bounty Price:</Stack.Item>
            <Stack.Item>
              <NumberInput
                width="60px"
                step={1}
                minValue={0}
                maxValue={999}
                value={entry.payoutPrice}
                onChange={(value) => act('set_bounty', { ref: entry.ref, value })}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        {!showImportOnly && (
          <>
            <Stack.Item>
              <Stack align="center">
                <Stack.Item width="140px">Withdraw Price:</Stack.Item>
                <Stack.Item>
                  <NumberInput
                    width="60px"
                    step={1}
                    minValue={0}
                    maxValue={999}
                    value={entry.withdrawPrice}
                    onChange={(value) => act('set_withdraw_price', { ref: entry.ref, value })}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            {!entry.percentBounty && (
              <>
                <Stack.Item>
                  <Stack align="center">
                    <Stack.Item width="140px">Oversupply Amount:</Stack.Item>
                    <Stack.Item>
                      <NumberInput
                        width="60px"
                        step={1}
                        minValue={0}
                        maxValue={9999}
                        value={entry.oversupplyAmount}
                        onChange={(value) => act('set_oversupply_amount', { ref: entry.ref, value })}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack align="center">
                    <Stack.Item width="140px">Oversupply Price:</Stack.Item>
                    <Stack.Item>
                      <NumberInput
                        width="60px"
                        step={1}
                        minValue={0}
                        maxValue={999}
                        value={entry.oversupplyPayout}
                        onChange={(value) => act('set_oversupply_payout', { ref: entry.ref, value })}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </>
            )}
          </>
        )}
        <Stack.Item mt={0.5}>
          <Stack align="center" justify="flex-end">
            {!showImportOnly && (
              <Stack.Item>
                <Button
                  icon={entry.withdrawDisabled ? 'lock' : 'lock-open'}
                  onClick={() => act('toggle_withdraw', { ref: entry.ref })}
                >
                  {entry.withdrawDisabled ? 'Enable' : 'Disable'} Withdrawing
                </Button>
              </Stack.Item>
            )}
            {!!entry.importExportAmt && (
              <>
                {(showImportExport || showImportOnly) && (
                  <Stack.Item>
                    <Button icon="ship" onClick={() => act('import', { ref: entry.ref })}>
                      Import {entry.importExportAmt} ({entry.importPrice})
                    </Button>
                  </Stack.Item>
                )}
                {showImportExport && (
                  <Stack.Item>
                    <Button icon="truck" onClick={() => act('export', { ref: entry.ref })}>
                      Export {entry.importExportAmt} ({entry.exportPrice})
                    </Button>
                  </Stack.Item>
                )}
              </>
            )}
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const StockTab = ({
  title,
  entries,
  compact,
  onToggleCompact,
  showImportExport,
  showImportOnly,
}: {
  title: string;
  entries: StockEntry[];
  compact: boolean;
  onToggleCompact: () => void;
  showImportExport?: boolean;
  showImportOnly?: boolean;
}) => (
  <Section
    title={title}
    buttons={
      <Button icon="compress" selected={compact} onClick={onToggleCompact}>
        Compact
      </Button>
    }
  >
    {entries.length === 0 ? (
      <Box color="label">Nothing found.</Box>
    ) : compact ? (
      <Table>
        <Table.Row header>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell>Amt</Table.Cell>
          <Table.Cell>Bounty</Table.Cell>
          {!showImportOnly && <Table.Cell>Withdraw</Table.Cell>}
          <Table.Cell align="right">Trade</Table.Cell>
        </Table.Row>
        {entries.map((entry) => (
          <StockRowCompact
            key={entry.ref}
            entry={entry}
            showImportExport={showImportExport}
            showImportOnly={showImportOnly}
          />
        ))}
      </Table>
    ) : (
      <Box style={{ display: 'flex', flexDirection: 'column', width: '100%', alignItems: 'stretch' }}>
        {entries.map((entry) => (
          <StockCard
            key={entry.ref}
            entry={entry}
            showImportExport={showImportExport}
            showImportOnly={showImportOnly}
          />
        ))}
      </Box>
    )}
  </Section>
);

const BountyTab = ({ entries }: { entries: StockEntry[] }) => {
  return (
    <Section title="Bounties">
      <Table>
        {entries.length === 0 ? (
          <Table.Row>
            <Table.Cell>No active bounties found.</Table.Cell>
          </Table.Row>
        ) : (
          entries.map((entry) => <BountyRow key={entry.ref} entry={entry} />)
        )}
      </Table>
    </Section>
  );
};

const BountyRow = ({ entry }: { entry: StockEntry }) => {
  const { act } = useBackend<Data>();
  return (
    <Table.Row className="candystripe">
      <Table.Cell verticalAlign="middle">
        <Box bold>{entry.name}</Box>
        <Box color="label" fontSize="0.9em">
          {entry.desc}
        </Box>
        <Box fontSize="0.85em">Total Collected: {entry.held}</Box>
      </Table.Cell>
      <Table.Cell verticalAlign="middle" align="right" width="120px">
        <NumberInput
          width="60px"
          step={1}
          minValue={entry.percentBounty ? 1 : 0}
          maxValue={entry.percentBounty ? 99 : 999}
          value={entry.payoutPrice}
          onChange={(value) => act('set_bounty', { ref: entry.ref, value })}
        />
      </Table.Cell>
    </Table.Row>
  );
};

const JobsTab = ({
  jobs,
  assignableJobs,
  payableJobs,
}: {
  jobs: JobEntry[];
  assignableJobs: string[];
  payableJobs: string[];
}) => {
  const { act } = useBackend<Data>();
  const [payJob, setPayJob] = useState<string | undefined>(payableJobs[0]);
  const [payAmount, setPayAmount] = useState(1);

  return (
    <>
      <Section title="Pay by Class">
        <Stack align="center">
          <Stack.Item grow>
            <Dropdown
              width="100%"
              selected={payJob}
              options={payableJobs}
              onSelected={(value) => setPayJob(value)}
            />
          </Stack.Item>
          <Stack.Item>
            <NumberInput width="70px" step={1} minValue={1} maxValue={9999} value={payAmount} onChange={setPayAmount} />
          </Stack.Item>
          <Stack.Item>
            <Button
              color="good"
              disabled={!payJob}
              onClick={() => act('payroll', { job: payJob, amount: payAmount })}
            >
              Pay All
            </Button>
          </Stack.Item>
        </Stack>
      </Section>
      <Section title="Assign Jobs">
        <Table>
          <Table.Row header>
            <Table.Cell>Name</Table.Cell>
            <Table.Cell align="right">Assign</Table.Cell>
          </Table.Row>
          {jobs.length === 0 ? (
            <Table.Row>
              <Table.Cell colSpan={2}>No residents found matching criteria.</Table.Cell>
            </Table.Row>
          ) : (
            jobs.map((job) => <JobRow key={job.ref} job={job} assignableJobs={assignableJobs} />)
          )}
        </Table>
      </Section>
    </>
  );
};

const JobRow = ({ job, assignableJobs }: { job: JobEntry; assignableJobs: string[] }) => {
  const { act } = useBackend<Data>();
  const [selected, setSelected] = useState<string | undefined>(assignableJobs[0]);
  return (
    <Table.Row className="candystripe">
      <Table.Cell verticalAlign="middle">
        <Box bold>{job.name}</Box>
        <Box color="label" fontSize="0.9em">
          {job.title}
        </Box>
      </Table.Cell>
      <Table.Cell verticalAlign="middle" align="right">
        {job.isLord ? (
          <Box color="label" italic>
            The Monarch cannot be reassigned.
          </Box>
        ) : (
          <Stack align="center" justify="flex-end">
            <Stack.Item width="180px">
              <Dropdown width="100%" selected={selected} options={assignableJobs} onSelected={setSelected} />
            </Stack.Item>
            <Stack.Item>
              <Button disabled={!selected} onClick={() => act('change_job', { ref: job.ref, job: selected })}>
                Assign
              </Button>
            </Stack.Item>
          </Stack>
        )}
      </Table.Cell>
    </Table.Row>
  );
};

const CustomTab = ({
  entries,
  availableItems,
  compact,
  onToggleCompact,
}: {
  entries: StockEntry[];
  availableItems: AvailableItem[];
  compact: boolean;
  onToggleCompact: () => void;
}) => {
  const { act } = useBackend<Data>();
  const [selectedPath, setSelectedPath] = useState<string | undefined>(availableItems[0]?.path);
  const itemOptions = availableItems.map((item) => item.name);

  return (
    <Section
      title="Custom Stocks"
      buttons={
        <Button icon="compress" selected={compact} onClick={onToggleCompact}>
          Compact
        </Button>
      }
    >
      <Box mb={1}>
        <Stack align="center">
          <Stack.Item grow>
            <Dropdown
              width="100%"
              selected={availableItems.find((i) => i.path === selectedPath)?.name}
              options={itemOptions}
              onSelected={(value) => {
                const match = availableItems.find((i) => i.name === value);
                setSelectedPath(match?.path);
              }}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              color="good"
              icon="plus"
              disabled={!selectedPath}
              onClick={() => act('create_custom', { path: selectedPath })}
            >
              Create New Custom Stock
            </Button>
          </Stack.Item>
        </Stack>
        {availableItems.length === 0 && (
          <NoticeBox mt={0.5}>Carry an item to create a custom stock for it.</NoticeBox>
        )}
      </Box>
      {entries.length === 0 ? (
        <Box color="label" italic>
          No custom stocks found.
        </Box>
      ) : compact ? (
        <Table>
          <Table.Row header>
            <Table.Cell>Name</Table.Cell>
            <Table.Cell>Amt</Table.Cell>
            <Table.Cell>Bounty</Table.Cell>
            <Table.Cell>Withdraw</Table.Cell>
            <Table.Cell align="right">Actions</Table.Cell>
          </Table.Row>
          {entries.map((entry) => (
            <CustomRowCompact key={entry.ref} entry={entry} />
          ))}
        </Table>
      ) : (
        <Box style={{ display: 'flex', flexDirection: 'column', width: '100%', alignItems: 'stretch' }}>
          {entries.map((entry) => (
            <CustomCard key={entry.ref} entry={entry} />
          ))}
        </Box>
      )}
    </Section>
  );
};

const useConfirmDelete = (ref: string) => {
  const { act } = useBackend<Data>();
  const [confirming, setConfirming] = useState(false);
  return (
    <Button
      color="bad"
      icon="trash"
      onClick={() => {
        if (confirming) {
          act('delete_custom', { ref });
          setConfirming(false);
        } else {
          setConfirming(true);
        }
      }}
    >
      {confirming ? 'Confirm Delete?' : 'Delete'}
    </Button>
  );
};

const CustomRowCompact = ({ entry }: { entry: StockEntry }) => {
  const deleteButton = useConfirmDelete(entry.ref);

  return (
    <Table.Row className="candystripe">
      <Table.Cell verticalAlign="middle">
        <Box bold>{entry.name}</Box>
      </Table.Cell>
      <Table.Cell verticalAlign="middle">{entry.held}</Table.Cell>
      <Table.Cell verticalAlign="middle">
        <NumberInput
          width="60px"
          step={1}
          minValue={0}
          maxValue={999}
          value={entry.payoutPrice}
          onChange={(value) => act('set_bounty', { ref: entry.ref, value })}
        />
      </Table.Cell>
      <Table.Cell verticalAlign="middle">
        <NumberInput
          width="60px"
          step={1}
          minValue={0}
          maxValue={999}
          value={entry.withdrawPrice}
          onChange={(value) => act('set_withdraw_price', { ref: entry.ref, value })}
        />
      </Table.Cell>
      <Table.Cell verticalAlign="middle" align="right">
        {deleteButton}
      </Table.Cell>
    </Table.Row>
  );
};

const CustomCard = ({ entry }: { entry: StockEntry }) => {
  const { act } = useBackend<Data>();
  const deleteButton = useConfirmDelete(entry.ref);

  return (
    <Box
      mb={1}
      p={1}
      style={{
        width: '100%',
        boxSizing: 'border-box',
        backgroundColor: 'rgba(255, 255, 255, 0.04)',
        border: '1px solid rgba(255, 255, 255, 0.1)',
        borderRadius: '4px',
      }}
    >
      <Stack vertical align="stretch">
        <Stack.Item>
          <Box bold fontSize="1.1em">{entry.name}</Box>
          <Box color="label" fontSize="0.9em">
            {entry.desc}
          </Box>
          <Box fontSize="0.85em">Created by: {entry.createdBy}</Box>
        </Stack.Item>
        <Stack.Item>Stockpiled Amount: {entry.held}</Stack.Item>
        <Stack.Item>Demand: {entry.demand}</Stack.Item>
        <Stack.Item>
          <Stack align="center">
            <Stack.Item width="140px">Bounty Price:</Stack.Item>
            <Stack.Item>
              <NumberInput
                width="60px"
                step={1}
                minValue={0}
                maxValue={999}
                value={entry.payoutPrice}
                onChange={(value) => act('set_bounty', { ref: entry.ref, value })}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack align="center">
            <Stack.Item width="140px">Withdraw Price:</Stack.Item>
            <Stack.Item>
              <NumberInput
                width="60px"
                step={1}
                minValue={0}
                maxValue={999}
                value={entry.withdrawPrice}
                onChange={(value) => act('set_withdraw_price', { ref: entry.ref, value })}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item mt={0.5}>
          <Stack align="center" justify="flex-end">
            <Stack.Item>
              <Button
                icon={entry.withdrawDisabled ? 'lock' : 'lock-open'}
                onClick={() => act('toggle_withdraw', { ref: entry.ref })}
              >
                {entry.withdrawDisabled ? 'Enable' : 'Disable'} Withdrawing
              </Button>
            </Stack.Item>
            <Stack.Item>{deleteButton}</Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const LogTab = ({ entries }: { entries: string[] }) => (
  <Section title="Log">
    {entries.length === 0 ? (
      <Box color="label">No log entries found.</Box>
    ) : (
      <Stack vertical>
        {entries.map((line, i) => (
          <Stack.Item key={i}>
            <Box color="label" fontSize="0.9em">
              {line}
            </Box>
          </Stack.Item>
        ))}
      </Stack>
    )}
  </Section>
);

const WagesTab = ({ entries }: { entries: WageEntry[] }) => {
  const categories = Array.from(new Set(entries.map((e) => e.category)));
  const [category, setCategory] = useState<string | undefined>(categories[0]);
  const [sortOrder, setSortOrder] = useState<WageSortOrder>('none');
  const scrollRef = useRef<HTMLDivElement>(null);
  const handleToggleSort = () => {
    if (sortOrder === 'none') {
      setSortOrder('desc');
    } else if (sortOrder === 'desc') {
      setSortOrder('asc');
    } else {
      setSortOrder('none');
    }
  };

  const filtered = entries.filter((e) => !category || e.category === category);
  const shown = [...filtered].sort((a, b) => {
    if (sortOrder === 'desc') return b.wage - a.wage;
    if (sortOrder === 'asc') return a.wage - b.wage;
    return 0;
  });

  return (
    <Section title="Daily Wages">
      {categories.length > 0 && (
        <Stack align="center" mb={1}>
          <Stack.Item grow style={{ overflow: 'hidden', minWidth: 0 }}>
            <div
              ref={scrollRef}
              style={{
                display: 'flex',
                overflowX: 'auto',
                scrollbarWidth: 'none',
                msOverflowStyle: 'none',
              }}
            >
              <Tabs style={{ display: 'flex', flexWrap: 'nowrap', width: 'max-content' }}>
                {categories.map((cat) => (
                  <Tabs.Tab
                    key={cat}
                    selected={category === cat}
                    onClick={() => setCategory(cat)}
                    style={{ flex: '0 0 auto', whiteSpace: 'nowrap' }}
                  >
                    {cat}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </div>
          </Stack.Item>
        </Stack>
      )}

      <Table>
        <Table.Row header>
          <Table.Cell>Job</Table.Cell>
          <Table.Cell
            align="right"
            onClick={handleToggleSort}
            style={{ cursor: 'pointer', userSelect: 'none' }}
          >
            Daily Wage {sortOrder === 'desc' ? '▼' : sortOrder === 'asc' ? '▲' : ''}
          </Table.Cell>
        </Table.Row>
        {shown.length === 0 ? (
          <Table.Row>
            <Table.Cell colSpan={2}>No jobs found matching criteria.</Table.Cell>
          </Table.Row>
        ) : (
          shown.map((entry) => <WageRow key={entry.title} entry={entry} />)
        )}
      </Table>
    </Section>
  );
};

const WageRow = ({ entry }: { entry: WageEntry }) => {
  const { act } = useBackend<Data>();
  return (
    <Table.Row className="candystripe">
      <Table.Cell verticalAlign="middle">{entry.title}</Table.Cell>
      <Table.Cell verticalAlign="middle" align="right">
        <NumberInput
          width="70px"
          step={1}
          minValue={0}
          maxValue={999}
          value={entry.wage}
          onChange={(value) => act('set_wage', { job: entry.title, value })}
        />
      </Table.Cell>
    </Table.Row>
  );
};
