import { Button, Section, Stack } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import { BardBuffSection } from './BardBuffSection';
import { BardRhythmSection } from './BardRhythm';

type Buff = {
  path: string;
  name: string;
  desc: string;
  selected: boolean;
};

type Song = {
  name: string;
  desc: string;
  type_path: string;
  known: boolean;
};

type Rhythm = {
  name: string;
  desc: string;
  type_path: string;
  known: boolean;
};

type Data = {
  songs: Song[];
  song_slots_remaining: number;
  rhythms: Rhythm[];
  rhythm_slots_remaining: number;
  can_unlearn: boolean;
  unlearn_cooldown_text: string;
  has_bardic_training: boolean;
  available_buffs?: Buff[];
  buff_slots_max?: number;
  selected_buff_count?: number;
};

export const BardSongbook = () => {
  const { data, act } = useBackend<Data>();
  const {
    songs = [],
    song_slots_remaining,
    rhythms = [],
    rhythm_slots_remaining,
    can_unlearn,
    unlearn_cooldown_text = '',
    has_bardic_training,
    available_buffs = [],
    buff_slots_max = 1,
    selected_buff_count = 0,
  } = data;

  return (
    <Window width={400} height={620} title="Songbook">
      <Window.Content scrollable>
        {has_bardic_training && (
          <BardBuffSection
            buffs={available_buffs}
            slots_max={buff_slots_max}
            selected_count={selected_buff_count}
            act={act}
          />
        )}
        <BardRhythmSection
          rhythms={rhythms}
          slots_remaining={rhythm_slots_remaining}
          can_unlearn={can_unlearn}
          unlearn_cooldown_text={unlearn_cooldown_text}
          act={act}
        />
        <Section
          title={`Songs (${song_slots_remaining} slot${song_slots_remaining !== 1 ? 's' : ''} remaining)`}
        >
          <Stack vertical>
            {songs.map((song) => (
              <Stack.Item key={song.type_path}>
                {song.known ? (
                  <Button
                    fluid
                    tooltip={can_unlearn ? 'Click to unlearn' : unlearn_cooldown_text}
                    tooltipPosition="bottom"
                    color="grey"
                    disabled={!can_unlearn}
                    onClick={() => act('unlearn_song', { type_path: song.type_path })}
                  >
                    {song.name} (known)
                  </Button>
                ) : (
                  <Button
                    fluid
                    tooltip={song.desc}
                    tooltipPosition="bottom"
                    disabled={song_slots_remaining <= 0}
                    onClick={() => act('learn_song', { type_path: song.type_path })}
                  >
                    {song.name}
                  </Button>
                )}
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
