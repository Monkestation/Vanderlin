import { Button, Section, Stack } from 'tgui-core/components';

type Rhythm = {
  name: string;
  desc: string;
  type_path: string;
  known: boolean;
};

type Props = {
  rhythms: Rhythm[];
  slots_remaining: number;
  can_unlearn: boolean;
  unlearn_cooldown_text: string;
  act: (action: string, payload?: object) => void;
};

export const BardRhythmSection = (props: Props) => {
  const { rhythms, slots_remaining, can_unlearn, unlearn_cooldown_text, act } = props;

  return (
    <Section
      title={`Rhythms (${slots_remaining} slot${slots_remaining !== 1 ? 's' : ''} remaining)`}
    >
      <Stack vertical>
        {rhythms.map((rhythm) => (
          <Stack.Item key={rhythm.type_path}>
            {rhythm.known ? (
              <Button
                fluid
                tooltip={can_unlearn ? 'Click to unlearn' : unlearn_cooldown_text}
                tooltipPosition="bottom"
                color="grey"
                disabled={!can_unlearn}
                onClick={() =>
                  act('unlearn_rhythm', {
                    type_path: rhythm.type_path,
                  })
                }
              >
                {rhythm.name} (known)
              </Button>
            ) : (
              <Button
                fluid
                tooltip={rhythm.desc}
                tooltipPosition="bottom"
                disabled={slots_remaining <= 0}
                onClick={() =>
                  act('learn_rhythm', {
                    type_path: rhythm.type_path,
                  })
                }
              >
                {rhythm.name}
              </Button>
            )}
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};
