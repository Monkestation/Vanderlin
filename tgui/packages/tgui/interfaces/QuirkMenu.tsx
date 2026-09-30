import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';
import { Window } from '../layouts';

type QuirkEntry = {
  name: string;
  desc: string;
  value: number;
  selected: boolean;
  can_add: boolean;
};

type Data = {
  balance: number;
  boon_count: number;
  max_boons: number;
  categories: Record<string, QuirkEntry[]>;
};

export const QuirkMenu = () => {
  const { data, act } = useBackend<Data>();
  const {
    balance = 0,
    boon_count = 0,
    max_boons = 0,
    categories = {},
  } = data;

  return (
    <Window width={520} height={620} title="Quirk Selection">
      <Window.Content scrollable>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Point Balance">
              <Box color={balance < 0 ? 
'bad'
 : 
'good'
} bold>
                {balance}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Boons">
              {boon_count} / {max_boons}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {Object.entries(categories).map(([category, entries]) => (
          <Section key={category} title={category}>
            <LabeledList>
              {entries.map((q) => (
                <LabeledList.Item key={q.name} label={q.name}>
                  <Box inline color="label" mr={1}>
                    ({q.value > 0 ? 
'+'
 : 
''
}
                    {q.value})
                  </Box>
                  <Button
                    color={q.selected ? 
'red'
 : 
'good'
}
                    disabled={!q.selected && !q.can_add}
                    onClick={() =>
                      act(q.selected ? 'remove_quirk' : 'add_quirk', {
                        name: q.name,
                      })
                    }
                  >
                    {q.selected ? 'Remove' : 'Add'}
                  </Button>
                  <Box mt={0.5} color="label" fontSize="0.9em">
                    {q.desc}
                  </Box>
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};