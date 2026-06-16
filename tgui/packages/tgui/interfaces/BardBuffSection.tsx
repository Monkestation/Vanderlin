import { Button, Section, Stack } from 'tgui-core/components';

type Buff = {
  path: string;
  name: string;
  desc: string;
  selected: boolean;
};

type Props = {
  buffs: Buff[];
  slots_max: number;
  selected_count: number;
  act: (action: string, payload?: object) => void;
};

export const BardBuffSection = (props: Props) => {
  const { buffs, slots_max, selected_count, act } = props;
  const slots_remaining = slots_max - selected_count;

  return (
    <Section
      title={`Bardic Buffs (${slots_remaining} slot${slots_remaining !== 1 ? 's' : ''} remaining)`}
    >
      <Stack vertical>
        {buffs.map((buff) => {
          const atCap = slots_remaining <= 0 && !buff.selected;
          return (
            <Stack.Item key={buff.path}>
              <Button
                fluid
                color={buff.selected ? 'green' : atCap ? 'grey' : undefined}
                disabled={atCap}
                tooltip={
                  buff.selected
                    ? `${buff.desc}, click to deselect`
                    : atCap
                      ? `No slots remaining (${slots_max} max at your skill level)`
                      : buff.desc
                }
                tooltipPosition="bottom"
                onClick={() => act('toggle_buff', { path: buff.path })}
              >
                {buff.name}
                {buff.selected ? ' ✓' : ''}
              </Button>
            </Stack.Item>
          );
        })}
      </Stack>
    </Section>
  );
};
