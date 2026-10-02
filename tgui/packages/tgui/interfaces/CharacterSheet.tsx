import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';
import { Window } from '../layouts';

type Data = {
  preview_image: string;
  character_name: string;
  pronouns: string;
  age: string;
  voice_type: string;
  accent: string;
  voice_color: string;
  dominant_hand: string;
  nickname_color: string;
  permadeath: string;
  examine_music: string;
  quirks_count: number;
  pq: number;
  triumphs: number;
  faith: string;
  patron: string;
  loadout1: string;
  loadout2: string;
  loadout3: string;
  species: string;
  culture: string;
  skin_tone: string;
  detail_color: string;
  markings_count: number;
  family_mode: string;
  gender_pref: string;
  spouse_pref: string;
  ooc_notes: string;
  ooc_extra_link: string;
  flavortext: string;
  rumors_count: number;
  gossip_count: number;
  favourite_food: string;
  favourite_drink: string;
  nsfw_flavor: string;
  erp_preferences: string;
  headshot_link: string;
  nudeshot_link: string;
  gallery_count: number;
  gallery_links: string;
};

const editStyle = {
  cursor: 'pointer',
  textDecoration: 'underline dotted',
};

const boxBorder = {
  border: '1px solid rgba(255, 255, 255, 0.35)',
};

const dividerStyle = {
  borderLeft: '1px solid rgba(255, 255, 255, 0.35)',
  paddingLeft: '8px',
};

export const CharacterSheet = () => {
  const { data, act } = useBackend<Data>();
  const {
    preview_image = '',
    character_name = 'Unnamed',
    pronouns = '',
    age = '',
    voice_type = '',
    accent = '',
    voice_color = '#ffffff',
    dominant_hand = '',
    nickname_color = '#ffffff',
    permadeath = 'disabled',
    examine_music = 'None',
    quirks_count = 0,
    pq = 0,
    triumphs = 0,
    faith = '',
    patron = '',
    loadout1 = 'None',
    loadout2 = 'None',
    loadout3 = 'None',
    species = '',
    culture = '',
    skin_tone = '',
    detail_color = '#000000',
    markings_count = 0,
    family_mode = '',
    gender_pref = '',
    spouse_pref = '',
    ooc_notes = '',
    ooc_extra_link = '',
    flavortext = '',
    rumors_count = 0,
    gossip_count = 0,
    favourite_food = 'None',
    favourite_drink = 'None',
    nsfw_flavor = 'OFF',
    erp_preferences = '',
    headshot_link = '',
    nudeshot_link = '',
    gallery_count = 0,
    gallery_links = '',
  } = data;

  const edit = (key: string) => act('edit_field', { pref_key: key });

  return (
    <Window width={900} height={820} title="Who Are You?">
      <Window.Content scrollable>
        <Stack>
          <Stack.Item style={{ width: 
'320px'
 }}>
            <Box style={boxBorder} p={1} mb={1}>
              <Box bold mb={1} style={{ textAlign: 
'center'
 }}>
                Просмотр спрайта персонажа
              </Box>
              <Stack justify="center" align="center">
                <Stack.Item>
                  <Button
                    icon="chevron-left"
                    onClick={() => act('rotate_preview', { way: 'left' })}
                  />
                </Stack.Item>
                <Stack.Item mx={1}>
                  {preview_image && (
                    <img
                      src={
'data:image/png;base64,'
 + preview_image}
                      style={{
                        display: 'block',
                        imageRendering: 'pixelated',
                      }}
                    />
                  )}
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="chevron-right"
                    onClick={() => act('rotate_preview', { way: 'right' })}
                  />
                </Stack.Item>
              </Stack>
              <Stack justify="center" mt={1}>
                <Stack.Item grow basis={0}>
                  <Button
                    fluid
                    onClick={() => edit('species')}
                  >
                    Раса
                  </Button>
                </Stack.Item>
                <Stack.Item grow basis={0}>
                  <Button
                    fluid
                    onClick={() => act('open_body_markings')}
                  >
                    Детали персонажа
                  </Button>
                </Stack.Item>
              </Stack>
              <Box mt={1} style={{ textAlign: 
'center'
 }} color="label">
                {species}
              </Box>
            </Box>

            <Box style={boxBorder} p={1}>
              <Stack>
                <Stack.Item grow basis={0}>
                  <Box bold mb={1} style={{ textAlign: 
'center'
 }}>
                    Личность
                  </Box>
                  <LabeledList>
                    <LabeledList.Item label="Имя">
                      <span style={editStyle} onClick={() => edit('real_name')}>{character_name}</span>
                    </LabeledList.Item>
                    <LabeledList.Item label="Возраст">
                      <span style={editStyle} onClick={() => edit('age')}>{age}</span>
                    </LabeledList.Item>
                    <LabeledList.Item label="Местоим.">
                      <span style={editStyle} onClick={() => edit('pronouns')}>{pronouns}</span>
                    </LabeledList.Item>
                    <LabeledList.Item label="Происх.">
                      <span style={editStyle} onClick={() => edit('culture')}>{culture}</span>
                    </LabeledList.Item>
                    <LabeledList.Item label="Религия">
                      <span style={editStyle} onClick={() => edit('faith')}>{faith}</span>
                    </LabeledList.Item>
                    <LabeledList.Item label="Покров.">
                      <span style={editStyle} onClick={() => edit('selected_patron')}>{patron}</span>
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
                <Stack.Item grow basis={0} style={dividerStyle}>
                  <Box bold mb={1} style={{ textAlign: 
'center'
 }}>
                    Тело
                  </Box>
                  <LabeledList>
                    <LabeledList.Item label="Кожа">
                      <span style={editStyle} onClick={() => edit('skin_tone')}>{skin_tone}</span>
                    </LabeledList.Item>
                    <LabeledList.Item label="Детали">
                      <span style={{ ...editStyle, color: detail_color }} onClick={() => edit('detail_color')}>{detail_color}</span>
                    </LabeledList.Item>
                    <LabeledList.Item label="Тату">
                      <Button
                        onClick={() => act('open_body_markings')}
                      >
                        ({markings_count})
                      </Button>
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>

          <Stack.Item grow>
            <Section title="Голос" style={boxBorder} mb={1}>
              <LabeledList>
                <LabeledList.Item label="Цвет голоса">
                  <span style={{ ...editStyle, color: voice_color }} onClick={() => edit('voice_color')}>{voice_color}</span>
                </LabeledList.Item>
                <LabeledList.Item label="Тип голоса">
                  <span style={editStyle} onClick={() => edit('voice_type')}>{voice_type}</span>
                </LabeledList.Item>
                <LabeledList.Item label="Цвет никнейма">
                  <span style={{ ...editStyle, color: nickname_color }} onClick={() => edit('nickname_color')}>{nickname_color}</span>
                </LabeledList.Item>
                <LabeledList.Item label="Акцент">
                  <span style={editStyle} onClick={() => edit('selected_accent')}>{accent}</span>
                </LabeledList.Item>
              </LabeledList>
            </Section>

            <Section title="Игровые функции" style={boxBorder} mb={1}>
              <LabeledList>
                <LabeledList.Item label="Доминирующая рука">
                  <span style={editStyle} onClick={() => edit('domhand')}>{dominant_hand}</span>
                </LabeledList.Item>
                <LabeledList.Item label="Предпочтение еды">
                  <Button
                    onClick={() => act('open_culinary')}
                  >
                    {favourite_food} / {favourite_drink}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Невозрождаемость">
                  <span style={editStyle} onClick={() => edit('permadeath')}>{permadeath}</span>
                </LabeledList.Item>
                <LabeledList.Item label="Музыка осмотра">
                  <span style={editStyle} onClick={() => edit('examine_music')}>{examine_music}</span>
                </LabeledList.Item>
              </LabeledList>
            </Section>

            <Stack>
              <Stack.Item grow basis={0}>
                <Section title="IC Описания" fill style={boxBorder}>
                  <LabeledList>
                    <LabeledList.Item label="Хэдшот">
                      <span style={editStyle} onClick={() => edit('headshot_link')}>{headshot_link || 
'None'
}</span>
                    </LabeledList.Item>
                    <LabeledList.Item label="Флэйвор">
                      <span style={editStyle} onClick={() => edit('flavortext')}>{flavortext || 
'None'
}</span>
                    </LabeledList.Item>
                    <LabeledList.Item label="NSFW">
                      <span style={editStyle} onClick={() => edit('nsfw_flavor')}>{nsfw_flavor}</span>
                    </LabeledList.Item>
                    <LabeledList.Item label="Слухи">
                      <Button
                        onClick={() => act('open_rumors')}
                      >
                        ({rumors_count})
                      </Button>
                    </LabeledList.Item>
                    <LabeledList.Item label="Nudeshot">
                      <span style={editStyle} onClick={() => edit('nudeshot_link')}>{nudeshot_link || 
'None'
}</span>
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <Section title="OOC Описания" fill style={boxBorder}>
                  <LabeledList>
                    <LabeledList.Item label="Заметки">
                      <span style={editStyle} onClick={() => edit('ooc_notes')}>{ooc_notes || 
'None'
}</span>
                    </LabeledList.Item>
                    <LabeledList.Item label="Доп. ссылка">
                      <span style={editStyle} onClick={() => edit('ooc_extra_link')}>{ooc_extra_link || 
'None'
}</span>
                    </LabeledList.Item>
                    <LabeledList.Item label="ERP">
                      <span style={editStyle} onClick={() => edit('erp_preferences')}>{erp_preferences || 
'None'
}</span>
                    </LabeledList.Item>
                    <LabeledList.Item label="Галерея">
                      <Button
                        onClick={() => edit('character_gallery')}
                      >
                        ({gallery_count})
                      </Button>
                    </LabeledList.Item>
                    <LabeledList.Item label="Сплетни">
                      <Button
                        onClick={() => act('open_gossip')}
                      >
                        ({gossip_count})
                      </Button>
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              </Stack.Item>
            </Stack>

            <Stack mt={1}>
              <Stack.Item grow basis={0}>
                <Button
                  fluid
                  color="good"
                  icon="save"
                  onClick={() => act('save_character')}
                >
                  Сохранить изменения
                </Button>
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <Button
                  fluid
                  color="bad"
                  icon="undo"
                  onClick={() => act('cancel_changes')}
                >
                  Отменить изменения
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>

        <Stack mt={1}>
          <Stack.Item grow basis={0}>
            <Section title="Класс" fill style={boxBorder}>
              <LabeledList>
                <LabeledList.Item label="Player Quality">{pq}</LabeledList.Item>
                <LabeledList.Item label="Триумфы">{triumphs}</LabeledList.Item>
                <LabeledList.Item label="Loadout 1">{loadout1}</LabeledList.Item>
                <LabeledList.Item label="Loadout 2">{loadout2}</LabeledList.Item>
                <LabeledList.Item label="Loadout 3">{loadout3}</LabeledList.Item>
              </LabeledList>
              <Button
                mt={1}
                fluid
                icon="star"
                onClick={() => act('open_quirks')}
              >
                Quirks ({quirks_count})
              </Button>
              <Button
                mt={1}
                fluid
                icon="user-tag"
                onClick={() => act('open_job_select')}
              >
                Change Role
              </Button>
              <Button
                mt={1}
                fluid
                icon="user-secret"
                onClick={() => act('open_antag_prefs')}
              >
                Antagonist Preferences
              </Button>
            </Section>
          </Stack.Item>
          <Stack.Item grow basis={0}>
            <Section title="Семья" fill style={boxBorder}>
              <LabeledList>
                <LabeledList.Item label="Тип семьи">
                  <span style={editStyle} onClick={() => edit('family_mode')}>{family_mode}</span>
                </LabeledList.Item>
                <LabeledList.Item label="Предпочтение пола">
                  <span style={editStyle} onClick={() => edit('gender_choice')}>{gender_pref}</span>
                </LabeledList.Item>
                <LabeledList.Item label="Предпочтение супруга">
                  <span style={editStyle} onClick={() => edit('setspouse')}>{spouse_pref}</span>
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};