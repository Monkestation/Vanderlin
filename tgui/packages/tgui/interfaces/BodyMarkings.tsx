import { useBackend } from '../backend';
import { Button, Section, Stack } from 'tgui-core/components';
import { Window } from '../layouts';

type Marking = {
  name: string;
  color: string;
};

type ZoneEntry = {
  zone: string;
  display_name: string;
  markings: Marking[];
  can_add: boolean;
};

type Data = {
  zones: ZoneEntry[];
};

export const BodyMarkings = () => {
  const { data, act } = useBackend<Data>();
  const { zones = [] } = data;

  return (
    <Window width={520} height={600} title="Body Markings">
      <Window.Content scrollable>
        {zones.map((z) => (
          <Section key={z.zone} title={z.display_name}>
            <Stack vertical>
              {z.markings.map((m) => (
                <Stack.Item key={m.name}>
                  <Stack>
                    <Stack.Item grow>
                      <Button
                        fluid
                        onClick={() => act('change_marking', { zone: z.zone, name: m.name })}
                      >
                        {m.name}
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        style={{ backgroundColor: 
'#'
 + m.color }}
                        onClick={() => act('change_color', { zone: z.zone, name: m.name })}
                      >
                        Color
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="undo"
                        tooltip="Reset color"
                        onClick={() => act('reset_color', { zone: z.zone, name: m.name })}
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="arrow-up"
                        tooltip="Move up"
                        onClick={() => act('move_up', { zone: z.zone, name: m.name })}
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="arrow-down"
                        tooltip="Move down"
                        onClick={() => act('move_down', { zone: z.zone, name: m.name })}
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="trash"
                        color="red"
                        tooltip="Remove"
                        onClick={() => act('remove_marking', { zone: z.zone, name: m.name })}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              ))}
              {z.can_add && (
                <Stack.Item>
                  <Button
                    fluid
                    icon="plus"
                    onClick={() => act('add_marking', { zone: z.zone })}
                  >
                    Add Marking
                  </Button>
                </Stack.Item>
              )}
            </Stack>
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};