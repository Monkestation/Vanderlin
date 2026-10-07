import type { ReactNode } from 'react';
import { useBackend } from '../backend';
import { Box, Button, Stack } from 'tgui-core/components';
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
};

const LINE = '1px solid rgba(255, 255, 255, 0.35)';
const HEADER_COLOR = '#6ee7b7';

const frame = { border: LINE };

const headerStyle = {
  textAlign: 'center' as const,
  color: HEADER_COLOR,
  borderBottom: LINE,
};

const editStyle = {
  cursor: 'pointer',
  textDecoration: 'underline dotted',
};

const isHex = (c: string) => /^#*[0-9a-fA-F]{6}$/.test(c);
const hex = (c: string) => `#${c.replace(/^#+/, '')}`;
const short = (text: string, max = 26) =>
  text.length > max ? `${text.slice(0, max)}...` : text;

const swatch = (c: string) =>
  isHex(c) ? (
    <Box
      inline
      mr={0.5}
      style={{
        width: '0.9em',
        height: '0.9em',
        background: hex(c),
        border: LINE,
        verticalAlign: 'middle',
      }}
    />
  ) : null;

const Panel = (props: { title: string; children: ReactNode }) => (
  <Box style={{ ...frame, height: '100%' }}>
    <Box bold py={0.5} style={headerStyle}>
      {props.title}
    </Box>
    <Box p={1}>{props.children}</Box>
  </Box>
);

const Row = (props: {
  label: string;
  stacked?: boolean;
  children: ReactNode;
}) => (
  <Box py={0.4} style={{ textAlign: 'center' }}>
    <Box inline={!props.stacked} color="label" mr={props.stacked ? 0 : 0.75}>
      {props.label}:
    </Box>
    {props.children}
  </Box>
);

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
  } = data;

  const edit = (key: string) => act('edit_field', { pref_key: key });

  const field = (key: string, text: string) => (
    <span style={editStyle} onClick={() => edit(key)}>
      {text}
    </span>
  );

  const colorField = (key: string, c: string) => (
    <span style={editStyle} onClick={() => edit(key)}>
      {swatch(c)}
      {isHex(c) ? hex(c) : c}
    </span>
  );

  return (
    <Window width={960} height={960} title="Лист Персонажа">
      <Window.Content scrollable>
        <Stack vertical>
          <Stack.Item>
            <Stack>
              <Stack.Item grow basis={0}>
                <Stack vertical fill>
                  <Stack.Item>
                    <Button
                      fluid
                      icon="user"
                      onClick={() => act('change_character')}
                    >
                      Смена персонажа
                    </Button>
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box
                      style={{ ...frame, height: '100%', textAlign: 'center' }}
                      p={1}
                    >
                      <Box bold>PQ</Box>
                      <Box>{pq}</Box>
                    </Box>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <Stack vertical>
                  <Stack.Item>
                    <Button
                      fluid
                      icon="user-tag"
                      onClick={() => act('open_job_select')}
                    >
                      Выбор Роли
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      fluid
                      color="bad"
                      icon="user-secret"
                      onClick={() => act('open_antag_prefs')}
                    >
                      Антагонист роли
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <Box
                  style={{ ...frame, height: '100%', textAlign: 'center' }}
                  p={1}
                >
                  <Box bold>Триумфы</Box>
                  <Box>{triumphs}</Box>
                </Box>
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item>
            <Stack>
              <Stack.Item grow basis={0}>
                <Stack vertical>
                  <Stack.Item>
                    <Box style={frame} p={1}>
                      <Box bold mb={1} style={{ textAlign: 'center' }}>
                        Просмотр спрайта персонажа
                      </Box>
                      <Box style={frame} p={1}>
                        <Stack align="center">
                          <Stack.Item>
                            <Button
                              icon="arrow-left"
                              style={{ fontSize: '1.6em' }}
                              onClick={() =>
                                act('rotate_preview', { way: 'left' })
                              }
                            />
                          </Stack.Item>
                          <Stack.Item grow style={{ textAlign: 'center' }}>
                            {preview_image && (
                              <img
                                src={`data:image/png;base64,${preview_image}`}
                                style={{
                                  display: 'block',
                                  margin: '0 auto',
                                  height: '192px',
                                  imageRendering: 'pixelated',
                                }}
                              />
                            )}
                            <Box color="label" mt={0.5}>
                              {species}
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              icon="arrow-right"
                              style={{ fontSize: '1.6em' }}
                              onClick={() =>
                                act('rotate_preview', { way: 'right' })
                              }
                            />
                          </Stack.Item>
                        </Stack>
                        <Stack mt={1}>
                          <Stack.Item grow basis={0}>
                            <Button fluid onClick={() => edit('species')}>
                              Раса
                            </Button>
                          </Stack.Item>
                          <Stack.Item grow basis={0}>
                            <Button
                              fluid
                              onClick={() => act('open_customizers')}
                            >
                              Детали персонажа
                            </Button>
                          </Stack.Item>
                        </Stack>
                      </Box>
                    </Box>
                  </Stack.Item>

                  <Stack.Item>
                    <Box style={{ ...frame, display: 'flex' }}>
                      <Box style={{ flex: 1 }}>
                        <Box bold py={0.5} style={headerStyle}>
                          Личность
                        </Box>
                        <Box p={1}>
                          <Row label="Имя">
                            {field('real_name', character_name)}
                          </Row>
                          <Row label="Возраст">{field('age', age)}</Row>
                          <Row label="Местоимение">
                            {field('pronouns', pronouns)}
                          </Row>
                          <Row label="Происхождение">
                            {field('culture', culture)}
                          </Row>
                          <Row label="Религия">{field('faith', faith)}</Row>
                          <Row label="Покровитель">
                            {field('selected_patron', patron)}
                          </Row>
                        </Box>
                      </Box>
                      <Box style={{ flex: 1, borderLeft: LINE }}>
                        <Box bold py={0.5} style={headerStyle}>
                          Тело
                        </Box>
                        <Box p={1}>
                          <Row label="Цвет кожи">
                            {colorField('skin_tone', skin_tone)}
                          </Row>
                          <Row label="Цвет деталей">
                            {colorField('detail_color', detail_color)}
                          </Row>
                          <Row label="Физ. описания">
                            <Button onClick={() => act('open_descriptors')}>
                              Открыть
                            </Button>
                          </Row>
                          <Row label="Тату/Маркировки">
                            <Button onClick={() => act('open_body_markings')}>
                              Открыть ({markings_count})
                            </Button>
                          </Row>
                        </Box>
                      </Box>
                    </Box>
                  </Stack.Item>
                </Stack>
              </Stack.Item>

              <Stack.Item grow basis={0}>
                <Stack vertical>
                  <Stack.Item>
                    <Stack>
                      <Stack.Item grow basis={0}>
                        <Panel title="Голос">
                          <Row label="Цвет голоса">
                            {colorField('voice_color', voice_color)}
                          </Row>
                          <Row label="Тип голоса">
                            {field('voice_type', voice_type)}
                          </Row>
                          <Row label="Цвет никнейма">
                            {colorField('nickname_color', nickname_color)}
                          </Row>
                          <Row label="Акцент">
                            {field('selected_accent', accent)}
                          </Row>
                        </Panel>
                      </Stack.Item>
                      <Stack.Item grow basis={0}>
                        <Panel title="Игровые функции">
                          <Row label="Доминирующая рука">
                            {field('domhand', dominant_hand)}
                          </Row>
                          <Row label="Предпочтение еды">
                            <Button onClick={() => act('open_culinary')}>
                              {favourite_food} / {favourite_drink}
                            </Button>
                          </Row>
                          <Row label="Невозрождаемость">
                            {field('permadeath', permadeath)}
                          </Row>
                        </Panel>
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>

                  <Stack.Item>
                    <Stack>
                      <Stack.Item grow basis={0}>
                        <Panel title="IC Описания">
                          <Row stacked label="Хэдшот персонажа">
                            {field('headshot_link', short(headshot_link || 'None'))}
                          </Row>
                          <Row stacked label="Флэйвор персонажа">
                            {field('flavortext', short(flavortext || 'None'))}
                          </Row>
                          <Row stacked label="NSFW флейвор">
                            {field('nsfw_flavor', nsfw_flavor)}
                          </Row>
                          <Row stacked label="Слухи/сплетни о персонаже">
                            <Button onClick={() => act('open_rumors')}>
                              Слухи ({rumors_count})
                            </Button>
                            <Button onClick={() => act('open_gossip')}>
                              Сплетни ({gossip_count})
                            </Button>
                          </Row>
                          <Row stacked label="Nudeshot">
                            {field('nudeshot_link', short(nudeshot_link || 'None'))}
                          </Row>
                        </Panel>
                      </Stack.Item>
                      <Stack.Item grow basis={0}>
                        <Panel title="OOC Описания">
                          <Row stacked label="OOC Заметки">
                            {field('ooc_notes', short(ooc_notes || 'None'))}
                          </Row>
                          <Row stacked label="OOC доп. изображение">
                            {field('ooc_extra_link', short(ooc_extra_link || 'None'))}
                          </Row>
                          <Row stacked label="ERP Предпочтения">
                            {field('erp_preferences', short(erp_preferences || 'None'))}
                          </Row>
                          <Row stacked label="Музыка при осмотре">
                            {field('examine_music', examine_music)}
                          </Row>
                          <Row stacked label="Галерея персонажа">
                            <Button onClick={() => edit('character_gallery')}>
                              Открыть ({gallery_count})
                            </Button>
                          </Row>
                        </Panel>
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>

                  <Stack.Item>
                    <Stack>
                      <Stack.Item grow basis={0}>
                        <Button fluid icon="eye" onClick={() => act('open_examine')}>
                          Осмотр
                        </Button>
                      </Stack.Item>
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
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item>
            <Stack>
              <Stack.Item grow basis={0}>
                <Panel title="Черты и снаряжение">
                  <Row label="Loadout 1">{loadout1}</Row>
                  <Row label="Loadout 2">{loadout2}</Row>
                  <Row label="Loadout 3">{loadout3}</Row>
                  <Button
                    mt={1}
                    fluid
                    icon="star"
                    onClick={() => act('open_quirks')}
                  >
                    Quirks ({quirks_count})
                  </Button>
                </Panel>
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <Panel title="Семья">
                  <Row label="Тип семьи">
                    {field('family_mode', family_mode)}
                  </Row>
                  <Row label="Предпочтение пола">
                    {field('gender_choice', gender_pref)}
                  </Row>
                  <Row label="Предпочтение супруга">
                    {field('setspouse', spouse_pref)}
                  </Row>
                </Panel>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};