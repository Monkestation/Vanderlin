import { useBackend } from '../backend';
import { Button, LabeledList, Section } from 'tgui-core/components';
import { Window } from '../layouts';

type Data = {
  random_preferences: boolean;
  favourite_food: string;
  favourite_drink: string;
  hated_food: string;
  hated_drink: string;
};

export const CulinaryPreferences = () => {
  const { data, act } = useBackend<Data>();
  const {
    random_preferences = false,
    favourite_food = 'None',
    favourite_drink = 'None',
    hated_food = 'None',
    hated_drink = 'None',
  } = data;

  return (
    <Window width={420} height={340} title="Culinary Preferences">
      <Window.Content>
        <Section>
          <Button
            fluid
            icon={random_preferences ? 
'toggle-on'
 : 
'toggle-off'
}
            onClick={() => act('toggle_random')}
          >
            Random Preferences: {random_preferences ? 'ON' : 'OFF'}
          </Button>
        </Section>
        <Section title="Preferences">
          <LabeledList>
            <LabeledList.Item label="Favourite Food">
              <Button
                disabled={random_preferences}
                onClick={() => act('pick_favourite_food')}
              >
                {favourite_food}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Favourite Drink">
              <Button
                disabled={random_preferences}
                onClick={() => act('pick_favourite_drink')}
              >
                {favourite_drink}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Hated Food">
              <Button
                disabled={random_preferences}
                onClick={() => act('pick_hated_food')}
              >
                {hated_food}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Hated Drink">
              <Button
                disabled={random_preferences}
                onClick={() => act('pick_hated_drink')}
              >
                {hated_drink}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};