import { useBackend } from '../backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { Window } from '../layouts';

type Data = {
  entries: string[];
  max_entries: number;
  title: string;
};

export const TextListMenu = () => {
  const { data, act } = useBackend<Data>();
  const { entries = [], max_entries = 0, title = 'List' } = data;

  return (
    <Window width={420} height={400} title={title}>
      <Window.Content scrollable>
        <Section title={`
${title} (
${entries.length}/
${max_entries})`}>
          <Stack vertical>
            {entries.map((entry, index) => (
              <Stack.Item key={index}>
                <Stack>
                  <Stack.Item grow>
                    <Box>{entry}</Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="pen"
                      onClick={() => act('edit', { index })}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="trash"
                      color="red"
                      onClick={() => act('remove', { index })}
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            ))}
            {entries.length < max_entries && (
              <Stack.Item>
                <Button
                  fluid
                  icon="plus"
                  onClick={() => act('add')}
                >
                  Add Entry
                </Button>
              </Stack.Item>
            )}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};