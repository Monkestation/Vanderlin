import { Box, Button, DmIcon, Icon, Input, Section, Stack, Tabs } from 'tgui-core/components';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type RoleSettingBase = {
  savefile_key: string;
  display_name: string;
  category: string;
  max_lines: number;
};

type FreeTextSetting = RoleSettingBase & {
  kind: 'freetext';
  example_text: string | null;
  lines: string[];
};

type PickerOption = {
  value: string;
  name: string;
  is_path: boolean;
  icon?: string;
  icon_state?: string;
};

type PickerSetting = RoleSettingBase & {
  kind: 'picker';
  options: PickerOption[];
  lines: string[];
};

type RoleSetting = FreeTextSetting | PickerSetting;

type Data = {
  settings: RoleSetting[];
  categories: string[];
};

type EditState = {
  savefile_key: string;
  index: number;
  value: string;
};

export const RoleSettings = () => {
  const { data, act } = useBackend<Data>();
  const { settings = [], categories = [] } = data;
  const [tab, setTab] = useLocalState('tab', categories[0] ?? '');
  const [editing, setEditing] = useLocalState<EditState | null>('editing', null);

  const visible = settings.filter((s) => s.category === tab);

  return (
    <Window width={450} height={600} title="Role Settings">
      <Window.Content scrollable>
        <Tabs>
          {categories.map((cat) => (
            <Tabs.Tab
              key={cat}
              selected={tab === cat}
              onClick={() => {
                setTab(cat);
                setEditing(null);
              }}
            >
              {cat}
            </Tabs.Tab>
          ))}
        </Tabs>
        <Stack vertical>
          {visible.map((setting) => (
            <Stack.Item key={setting.savefile_key}>
              {setting.kind === 'picker' ? (
                <PickerSection setting={setting} act={act} />
              ) : (
                <FreeTextSection
                  setting={setting}
                  editing={
                    editing?.savefile_key === setting.savefile_key
                      ? editing
                      : null
                  }
                  setEditing={setEditing}
                  act={act}
                />
              )}
            </Stack.Item>
          ))}
        </Stack>
      </Window.Content>
    </Window>
  );
};

const FreeTextSection = ({ setting, editing, setEditing, act }) => {
  const { lines, display_name, example_text, max_lines, savefile_key } =
    setting as FreeTextSetting;

  return (
    <Section title={`${display_name} (${lines.length}/${max_lines})`}>
      <Stack vertical>
        {lines.length === 0 && (
          <Stack.Item>
            <Box color="gray" italic>
              No lines set.
              {example_text && ` Example: ${example_text.split('\n')[0]}`}
            </Box>
          </Stack.Item>
        )}
        {lines.map((line, index) => {
          const isEditing = editing?.index === index;
          return (
            <Stack.Item key={index}>
              {isEditing ? (
                <Stack>
                  <Stack.Item grow>
                    <Input
                      fluid
                      autoFocus
                      value={editing.value}
                      onChange={(value) => setEditing({ ...editing, value })}
                      onEnter={() => {
                        if (editing.value.trim()) {
                          act('edit_line', {
                            savefile_key,
                            index,
                            value: editing.value.trim(),
                          });
                        }
                        setEditing(null);
                      }}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="check"
                      color="green"
                      disabled={!editing.value.trim()}
                      onClick={() => {
                        act('edit_line', {
                          savefile_key,
                          index,
                          value: editing.value.trim(),
                        });
                        setEditing(null);
                      }}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="times"
                      color="red"
                      onClick={() => setEditing(null)}
                    />
                  </Stack.Item>
                </Stack>
              ) : (
                <Stack>
                  <Stack.Item grow>
                    <Box>{line}</Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="pencil"
                      tooltip="Edit"
                      onClick={() =>
                        setEditing({ savefile_key, index, value: line })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="trash"
                      color="red"
                      tooltip="Remove"
                      onClick={() =>
                        act('remove_line', { savefile_key, index })
                      }
                    />
                  </Stack.Item>
                </Stack>
              )}
            </Stack.Item>
          );
        })}
        {editing?.index === -1 ? (
          <Stack.Item>
            <Stack>
              <Stack.Item grow>
                <Input
                  fluid
                  autoFocus
                  placeholder={example_text?.split('\n')[0] ?? 'New line...'}
                  value={editing.value}
                  onChange={(value) => setEditing({ ...editing, value })}
                  onEnter={() => {
                    if (editing.value.trim()) {
                      act('add_line', {
                        savefile_key,
                        value: editing.value.trim(),
                      });
                    }
                    setEditing(null);
                  }}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="check"
                  color="green"
                  disabled={!editing.value.trim()}
                  onClick={() => {
                    act('add_line', {
                      savefile_key,
                      value: editing.value.trim(),
                    });
                    setEditing(null);
                  }}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="times"
                  color="red"
                  onClick={() => setEditing(null)}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        ) : (
          <Stack.Item>
            <Button
              fluid
              icon="plus"
              disabled={lines.length >= max_lines}
              onClick={() =>
                setEditing({ savefile_key, index: -1, value: '' })
              }
            >
              Add line
            </Button>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};

const PickerSection = ({ setting, act }) => {
  const { lines, display_name, options, max_lines, savefile_key } =
    setting as PickerSetting;
  const available = options.filter((o) => !lines.includes(o.value));
  const selected = options.filter((o) => lines.includes(o.value));

  return (
    <Section title={`${display_name} (${lines.length}/${max_lines})`}>
      <Stack vertical>
        {selected.length === 0 && (
          <Stack.Item>
            <Box color="gray" italic>
              Nothing selected.
            </Box>
          </Stack.Item>
        )}
        {selected.map((option) => (
          <Stack.Item key={option.value}>
            <Stack align="center">
              {option.is_path && (
                <Stack.Item>
                  <DmIcon
                    icon={option.icon!}
                    icon_state={option.icon_state!}
                    height={2}
                    width={2}
                    fallback={<Icon name="spinner" size={1} spin color="gray" />}
                  />
                </Stack.Item>
              )}
              <Stack.Item grow>
                <Box>{option.name}</Box>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="trash"
                  color="red"
                  tooltip="Remove"
                  onClick={() =>
                    act('remove_line', {
                      savefile_key,
                      index: lines.indexOf(option.value),
                    })
                  }
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        ))}
        {available.length > 0 && lines.length < max_lines && (
          <Stack.Item>
            <Section title="Available" level={2}>
              <Stack vertical>
                {available.map((option) => (
                  <Stack.Item key={option.value}>
                    <Stack align="center">
                      {option.is_path && (
                        <Stack.Item>
                          <DmIcon
                            icon={option.icon!}
                            icon_state={option.icon_state!}
                            height={2}
                            width={2}
                            fallback={
                              <Icon name="spinner" size={1} spin color="gray" />
                            }
                          />
                        </Stack.Item>
                      )}
                      <Stack.Item grow>
                        <Button
                          fluid
                          onClick={() =>
                            act('add_line', {
                              savefile_key,
                              value: option.value,
                            })
                          }
                        >
                          {option.name}
                        </Button>
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};
