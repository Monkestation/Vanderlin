import { useState } from 'react';
import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  Icon,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { Window } from '../layouts';

type UiConfigItem = {
  key: string;
  label: string;
  icon: string;
  desc?: string;
};

type FamilyPrefsData = {
  family_mode: string;
  setspouse: string;
  setchild: string;
  setparent: string;
  was_divorced: boolean;
  gender_choice: string;
  wants_adoption: boolean;

  same_species_family: boolean;
  accepted_species: string[];
  accepted_patron_faiths: string[];
  family_job_filter: string[];

  all_species: { name: string; path: string }[];
  all_faiths: { name: string; path: string }[];
  all_job_groups: { label: string; key: string }[];

  ui_family_modes: UiConfigItem[];
  ui_gender_prefs: UiConfigItem[];
};

// Kept solely for cosmetic presentation maps that are safe from logic breakages
const BOND_ICONS: Record<string, string> = {
  parent: 'user-shield',
  adopted_parent: 'user-shield',
  child: 'child',
  adopted_child: 'child',
  sibling: 'people-arrows',
  spouse: 'heart',
  step_parent: 'user-shield',
  step_child: 'child',
};

export const FamilyPrefs = () => {
  const { data } = useBackend<FamilyPrefsData>();
  const [tab, setTab] = useState<'bonds' | 'filters' | 'relations'>('bonds');

  return (
    <Window title="Family & Bonds" width={520} height={620}>
      <Window.Content scrollable>
        <Tabs fluid>
          <Tabs.Tab
            selected={tab === 'bonds'}
            icon="link"
            onClick={() => setTab('bonds')}
          >
            Bonds
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 'filters'}
            icon="filter"
            onClick={() => setTab('filters')}
          >
            Filters
          </Tabs.Tab>
        </Tabs>

        <Box mt={1}>
          {tab === 'bonds' && <BondsTab />}
          {tab === 'filters' && <FiltersTab />}
        </Box>
      </Window.Content>
    </Window>
  );
};

const BondsTab = () => {
  const { data, act } = useBackend<FamilyPrefsData>();

  // Safe fallbacks to prevent runtime map crashes if data hasn't fully loaded
  const familyModes = data.ui_family_modes || [];
  const genderPreferences = data.ui_gender_prefs || [];

  // Dynamically find descriptions based on current selection state
  const currentModeConfig = familyModes.find((m) => m.key === data.family_mode);
  const isNewlywed = currentModeConfig?.label === 'Newlywed';

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title="Family Mode">
          <Stack vertical spacing={0.5}>
            {familyModes.map((mode) => {
              const active = data.family_mode === mode.key;
              return (
                <Button
                  key={mode.key}
                  fluid
                  icon={mode.icon}
                  selected={active}
                  color={active ? 'selected' : undefined}
                  onClick={() => act('set_family_mode', { mode: mode.key })}
                >
                  <Flex align="center" justify="space-between">
                    <Box bold={active}>{mode.label}</Box>
                    <Box ml={1} opacity={0.7} fontSize="0.85em">
                      {mode.desc}
                    </Box>
                  </Flex>
                </Button>
              );
            })}
          </Stack>
        </Section>
      </Stack.Item>

      {/* Compare against the active found data token instead of a hardcoded string */}
      {currentModeConfig && currentModeConfig.label !== 'None' && (
        <Stack.Item>
          <Section title="Spousal Preference Settings">
            <LabeledList mb={1}>
              <LabeledList.Item label="Partner Gender">
                <Flex gap={0.5}>
                  {genderPreferences.map((pref) => {
                    const isSelected = data.gender_choice === pref.key;
                    return (
                      <Button
                        key={pref.key}
                        icon={pref.icon}
                        selected={isSelected}
                        color={isSelected ? 'selected' : undefined}
                        onClick={() => act('set_gender_choice', { choice: pref.key })}
                      >
                        {pref.label}
                      </Button>
                    );
                  })}
                </Flex>
              </LabeledList.Item>
              <LabeledList.Item label="Designated Spouse">
                <Flex align="center" gap={1}>
                  <Box flex={1} italic={!data.setspouse}>
                    {data.setspouse || 'No target name set'}
                  </Box>
                  <Button
                    icon="pen"
                    compact
                    onClick={() => act('edit_setspouse')}
                  >
                    Edit
                  </Button>
                  {data.setspouse && (
                    <Button
                      icon="times"
                      compact
                      onClick={() => act('clear_setspouse')}
                    />
                  )}
                </Flex>
              </LabeledList.Item>
              <LabeledList.Item label="Designated Child">
                <Flex align="center" gap={1}>
                  <Box flex={1} italic={!data.setchild}>
                    {data.setchild || 'No target name set'}
                  </Box>
                  <Button
                    icon="pen"
                    compact
                    onClick={() => act('edit_setchild')}
                  >
                    Edit
                  </Button>
                  {data.setchild && (
                    <Button
                      icon="times"
                      compact
                      onClick={() => act('clear_setchild')}
                    />
                  )}
                </Flex>
              </LabeledList.Item>
              <LabeledList.Item label="Designated Parent">
                <Flex align="center" gap={1}>
                  <Box flex={1} italic={!data.setparent}>
                    {data.setparent || 'No target name set'}
                  </Box>
                  <Button
                    icon="pen"
                    compact
                    onClick={() => act('edit_setparent')}
                  >
                    Edit
                  </Button>
                  {data.setparent && (
                    <Button
                      icon="times"
                      compact
                      onClick={() => act('clear_setparent')}
                    />
                  )}
                </Flex>
              </LabeledList.Item>
            </LabeledList>
            <Box mt={1} color="label" fontSize="0.82em">
              {isNewlywed
                ? 'Prioritizes matchmaking you with a Newlywed player whose details check out.'
                : 'Prevents players with a custom spouse rule configuration from matching you unless targeted.'}
            </Box>
          </Section>
        </Stack.Item>
      )}

      <Stack.Item>
        <Section title="Marital History">
          <Flex align="center" justify="space-between">
            <Box>
              <Icon
                name={data.was_divorced ? 'heart-crack' : 'heart'}
                mr={1}
              />
              {data.was_divorced
                ? 'Marked as previously divorced'
                : 'No prior marriages'}
            </Box>
            <Button
              icon={data.was_divorced ? 'toggle-on' : 'toggle-off'}
              selected={data.was_divorced}
              color={data.was_divorced ? 'selected' : undefined}
              onClick={() => act('toggle_divorced')}
            >
              {data.was_divorced ? 'On' : 'Off'}
            </Button>
          </Flex>
          <Box mt={1} color="label" fontSize="0.82em">
            Stamps a divorced relation on your character at round-start so your
            history is visible to others.
          </Box>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="Adoption Preference">
          <Flex align="center" justify="space-between">
            <Box>
              <Icon
                name={data.wants_adoption ? 'child' : 'user'}
                mr={1}
              />
              {data.wants_adoption
                ? 'Prefer adopted family ties'
                : 'Prefer biological family ties'}
            </Box>
            <Button
              icon={data.wants_adoption ? 'toggle-on' : 'toggle-off'}
              selected={data.wants_adoption}
              color={data.wants_adoption ? 'selected' : undefined}
              onClick={() => act('toggle_adoption')}
            >
              {data.wants_adoption ? 'On' : 'Off'}
            </Button>
          </Flex>
          <Box mt={1} color="label" fontSize="0.82em">
            Allows the matchmaking system to establish adopted bonds (e.g., adopted child or parent) at round-start.
          </Box>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const FiltersTab = () => {
  const { data, act } = useBackend<FamilyPrefsData>();

  const noFiltersActive =
    !data?.same_species_family &&
    (data?.accepted_species?.length ?? 0) === 0 &&
    (data?.accepted_patron_faiths?.length ?? 0) === 0 &&
    (data?.family_job_filter?.length ?? 0) === 0;

  return (
    <Stack vertical fill>
      {noFiltersActive && (
        <Stack.Item>
          <NoticeBox info>
            No filters active, you may be assigned to any compatible family.
          </NoticeBox>
        </Stack.Item>
      )}

      <Stack.Item>
        <Section
          title="Species"
          buttons={
            data.same_species_family ? (
              <Button
                compact
                icon="lock"
                tooltip="Same-species lock is on, species list ignored"
                tooltipPosition="left"
              />
            ) : null
          }
        >
          <Flex align="center" justify="space-between" mb={1}>
            <Box bold>Same species only</Box>
            <Button
              icon={data.same_species_family ? 'toggle-on' : 'toggle-off'}
              selected={data.same_species_family}
              color={data.same_species_family ? 'selected' : undefined}
              onClick={() => act('toggle_same_species')}
            >
              {data.same_species_family ? 'On' : 'Off'}
            </Button>
          </Flex>

          {!data.same_species_family && (
            <>
              <Box color="label" fontSize="0.82em" mb={1}>
                Toggle entries below to accept or exclude specific species.
              </Box>
              <SelectionGrid
                items={data.all_species}
                active={data.accepted_species}
                labelKey="name"
                valueKey="path"
                onToggle={(path) => act('toggle_accepted_species', { path })}
              />
            </>
          )}
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Patron Faiths">
          <Box color="label" fontSize="0.82em" mb={1}>
            Toggle entries below to accept or exclude specific faiths.
          </Box>
          <SelectionGrid
            items={data.all_faiths}
            active={data.accepted_patron_faiths}
            labelKey="name"
            valueKey="path"
            onToggle={(path) => act('toggle_accepted_faith', { path })}
          />
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Job Groups">
          <Box color="label" fontSize="0.82em" mb={1}>
            Toggle entries below to restrict placement to specific social strata.
          </Box>
          <SelectionGrid
            items={data.all_job_groups}
            active={data.family_job_filter}
            labelKey="label"
            valueKey="key"
            onToggle={(key) => act('toggle_job_group', { key })}
          />
        </Section>
      </Stack.Item>

      {!noFiltersActive && (
        <Stack.Item>
          <Button
            fluid
            icon="broom"
            onClick={() => act('clear_all_filters')}
          >
            Clear All Filters
          </Button>
        </Stack.Item>
      )}
    </Stack>
  );
};

type SelectionGridProps = {
  items: { name?: string; label?: string; path?: string; key?: string }[];
  active: string[];
  labelKey: 'name' | 'label';
  valueKey: 'path' | 'key';
  onToggle: (val: string) => void;
};

const SelectionGrid = ({
  items,
  active,
  labelKey,
  valueKey,
  onToggle,
}: SelectionGridProps) => {
  if (!items || items.length === 0) {
    return (
      <Box color="label" fontSize="0.85em">
        No options available.
      </Box>
    );
  }

  return (
    <Stack vertical spacing={0.25}>
      {items.map((item) => {
        const val = item[valueKey] as string;
        const label = item[labelKey] as string;
        const isEnabled = active.includes(val);

        return (
          <Flex key={val} align="center" justify="space-between" py={0.25}>
            <Box bold={isEnabled}>
              {label}
            </Box>
            <Button
              compact
              selected={isEnabled}
              color={isEnabled ? 'selected' : undefined}
              onClick={() => onToggle(val)}
            >
              {isEnabled ? 'Enabled' : 'Disabled'}
            </Button>
          </Flex>
        );
      })}
    </Stack>
  );
};
