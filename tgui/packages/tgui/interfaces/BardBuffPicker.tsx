import { useBackend } from '../backend';
import { Window } from '../layouts';
import { BardBuffSection } from './BardBuffSection';

type Buff = {
  path: string;
  name: string;
  desc: string;
  selected: boolean;
};

type Data = {
  available_buffs: Buff[];
  buff_slots_max: number;
  selected_buff_count: number;
};

export const BardBuffPicker = () => {
  const { data, act } = useBackend<Data>();
  const {
    available_buffs = [],
    buff_slots_max = 1,
    selected_buff_count = 0,
  } = data;

  return (
    <Window width={360} height={280} title="Bardic Buffs">
      <Window.Content>
        <BardBuffSection
          buffs={available_buffs}
          slots_max={buff_slots_max}
          selected_count={selected_buff_count}
          act={act}
        />
      </Window.Content>
    </Window>
  );
};
