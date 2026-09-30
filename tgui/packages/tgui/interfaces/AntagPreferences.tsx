import { useBackend } from '../backend';
import { LabeledList, NoticeBox, Section } from 'tgui-core/components';
import { Window } from '../layouts';

type VillainEntry = {
  name: string;
  status: 'banned' | 'locked' | 'available';
  days_remaining?: number;
  enabled?: boolean;
};

type VesselEntry = {
  name: string;
  enabled: boolean;
};

type Data = {
  total_banned: boolean;
  villains: VillainEntry[];
  vessels: VesselEntry[];
};

const toggleStyle = {
  cursor: 'pointer',
  textDecoration: 'underline dotted',
};

export const AntagPreferences = () => {
  const { data, act } = useBackend<Data>();
  const { total_banned, villains = [], vessels = [] } = data;

  return (
    <Window width={400} height={480} title="Antagonist Preferences">
      <Window.Content>
        {total_banned && (
          <NoticeBox danger>
            You are banned from all antagonist roles.
          </NoticeBox>
        )}
        <Section title="Villains">
          <LabeledList>
            {villains.map((v) => (
              <LabeledList.Item key={v.name} label={v.name}>
                {v.status === 'banned' && (
                  <span style={{ color: 'red' }}>BANNED</span>
                )}
                {v.status === 'locked' && (
                  <span>IN {v.days_remaining} DAYS</span>
                )}
                {v.status === 'available' && (
                  <span
                    style={toggleStyle}
                    onClick={() => act('toggle', { toggle_type: v.name })}
                  >
                    {v.enabled ? 'Enabled' : 'Disabled'}
                  </span>
                )}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
        {vessels.length > 0 && (
          <Section title="Vessels">
            <LabeledList>
              {vessels.map((v) => (
                <LabeledList.Item key={v.name} label={v.name}>
                  <span
                    style={toggleStyle}
                    onClick={() => act('toggle', { toggle_type: v.name })}
                  >
                    {v.enabled ? 'Enabled' : 'Disabled'}
                  </span>
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};