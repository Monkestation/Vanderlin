import { Button, Dropdown, Input, NumberInput, Section, Stack, Table } from 'tgui-core/components';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type Waypoint = {
  ref: string;
  order: number;
  name: string;
};

type MobEntry = {
  path: string;
  name: string;
  count: number;
};

type MobType = {
  path: string;
  name: string;
};

type Data = {
  set_id: string;
  waypoints: Waypoint[];
  mob_entries: MobEntry[];
};

type StaticData = {
  living_subtypes: MobType[];
};

export const WaveCreator = () => {
  const { data, act } = useBackend<Data & StaticData>();
  const { set_id, waypoints = [], mob_entries = [], living_subtypes = [] } = data;

  const [editingSetId, setEditingSetId] = useLocalState('editingSetId', false);
  const [setIdDraft, setSetIdDraft] = useLocalState('setIdDraft', set_id);
  const [selectedPath, setSelectedPath] = useLocalState('selectedPath', living_subtypes[0]?.path ?? '');

  const selectedMob = living_subtypes.find((m) => m.path === selectedPath);

  return (
    <Window width={640} height={580} title="Wave Creator">
      <Window.Content scrollable>

        <Section title="Wave Set">
          <Stack align="center">
            <Stack.Item color="label">Set ID:</Stack.Item>
            <Stack.Item grow>
              {editingSetId ? (
                <Input
                  fluid
                  value={setIdDraft}
                  onChange={(val) => setSetIdDraft(val)}
                  onEnter={() => {
                    act('set_set_id', { set_id: setIdDraft });
                    setEditingSetId(false);
                  }}
                />
              ) : (
                <b>{set_id}</b>
              )}
            </Stack.Item>
            <Stack.Item>
              {editingSetId ? (
                <Button
                  icon="check"
                  color="good"
                  onClick={() => {
                    act('set_set_id', { set_id: setIdDraft });
                    setEditingSetId(false);
                  }}
                />
              ) : (
                <Button icon="pencil-alt" onClick={() => { setSetIdDraft(set_id); setEditingSetId(true); }} />
              )}
            </Stack.Item>
            <Stack.Item>
              <Button icon="play" color="good" onClick={() => act('launch_wave')}>
                Launch Wave
              </Button>
            </Stack.Item>
          </Stack>
        </Section>

        <Section
          title={`Waypoints (${waypoints.length})`}
          buttons={
            <Button icon="plus" color="good" onClick={() => act('add_waypoint')}>
              Place at Feet
            </Button>
          }
        >
          {waypoints.length === 0 ? (
            <i>No landmarks for set &quot;{set_id}&quot;. Click &quot;Place at Feet&quot; to create one.</i>
          ) : (
            <Stack vertical>
              {waypoints.map((wp) => (
                <Stack.Item key={wp.ref}>
                  <Stack align="center">
                    <Stack.Item color="label" width="2rem" textAlign="center">
                      #{wp.order}
                    </Stack.Item>
                    <Stack.Item grow>{wp.name}</Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="trash"
                        color="bad"
                        onClick={() => act('remove_waypoint', { ref: wp.ref })}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              ))}
            </Stack>
          )}
        </Section>

        <Section title="Wave Mobs">
          <Stack align="center" mb={1}>
            <Stack.Item grow>
              <Dropdown
                fluid
                selected={selectedPath}
                options={living_subtypes.map((m) => m.path)}
                onSelected={(val) => setSelectedPath(val)}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="plus"
                disabled={!selectedPath}
                onClick={() => {
                  const existing = mob_entries.find((e) => e.path === selectedPath);
                  act('set_mob_count', { path: selectedPath, count: (existing?.count ?? 0) + 1 });
                }}
              >
                Add
              </Button>
            </Stack.Item>
          </Stack>

          {mob_entries.filter((e) => e.count > 0).length > 0 && (
            <Table>
              <Table.Row header>
                <Table.Cell>Type Path</Table.Cell>
                <Table.Cell collapsing>Count</Table.Cell>
                <Table.Cell collapsing />
              </Table.Row>
              {mob_entries
                .filter((e) => e.count > 0)
                .map((e) => (
                  <Table.Row key={e.path}>
                    <Table.Cell>{e.path}</Table.Cell>
                    <Table.Cell collapsing>
                      <NumberInput
                        width="60px"
                        minValue={1}
                        step={1}
                        maxValue={50}
                        value={e.count}
                        onChange={(val) => act('set_mob_count', { path: e.path, count: val })}
                      />
                    </Table.Cell>
                    <Table.Cell collapsing>
                      <Button
                        icon="times"
                        color="bad"
                        onClick={() => act('set_mob_count', { path: e.path, count: 0 })}
                      />
                    </Table.Cell>
                  </Table.Row>
                ))}
            </Table>
          )}
        </Section>

      </Window.Content>
    </Window>
  );
};
