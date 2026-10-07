import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Section, Stack } from 'tgui-core/components';

const clean = (v: unknown): string => {
  if (typeof v !== 'string') {
    return '';
  }
  const s = v.trim();
  return s === '0' || s === '00' ? '' : s;
};

const isUrl = (v: unknown): boolean =>
  typeof v === 'string' && /^https?:\/\//i.test(v.trim());

const previewSrc = (v: unknown): string => {
  const s = clean(v);
  if (!s) {
    return '';
  }
  if (s.startsWith('data:') || isUrl(s)) {
    return s;
  }
  return 'data:image/png;base64,' + s;
};

const TEXT_STYLE = { whiteSpace: 'pre-wrap', wordBreak: 'break-word' } as const;

const TextBlock = (props: { text: string; empty: string }) => {
  const { text, empty } = props;
  return text ? (
    <Box style={TEXT_STYLE}>{text}</Box>
  ) : (
    <Box color="gray">{empty}</Box>
  );
};

const Line = (props: { label: string; value: string }) =>
  props.value ? (
    <Box mb={0.5}>
      <Box as="span" color="label">
        {props.label}:{' '}
      </Box>
      {props.value}
    </Box>
  ) : null;

export const CharacterExamine = () => {
  const { act, data } = useBackend<any>();
  const [showNsfw, setShowNsfw] = useState(false);

  const name = clean(data.character_name) || 'Персонаж';
  const headshot = clean(data.headshot_link);
  const nudeshot = clean(data.nudeshot_link);
  const oocLink = clean(data.ooc_extra_link);
  const flavor = clean(data.flavortext);
  const ooc = clean(data.ooc_notes);
  const nsfwFlavor = clean(data.nsfw_flavor);
  const erp = clean(data.erp_preferences);
  const food = clean(data.favourite_food);
  const drink = clean(data.favourite_drink);

  const rawGallery = data.gallery_links ?? data.gallery ?? [];
  const gallery: string[] = Array.isArray(rawGallery)
    ? rawGallery.filter((x: unknown) => isUrl(x))
    : [];

  const mainImage = isUrl(headshot) ? headshot : previewSrc(data.preview_image);

  return (
    <Window title={name} width={960} height={720}>
      <Window.Content scrollable>
        <Stack fill>
          <Stack.Item width="330px">
            <Section
              title={name}
              buttons={
                <Button
                  icon="sync"
                  tooltip="Обновить"
                  onClick={() => act('refresh')}
                />
              }
            >
              <Box textAlign="center" mb={1}>
                {mainImage ? (
                  <img
                    src={mainImage}
                    style={{
                      maxWidth: '300px',
                      maxHeight: '300px',
                      imageRendering: headshot ? 'auto' : 'pixelated',
                    }}
                  />
                ) : (
                  <Box color="gray" py={6}>
                    Изображения нет.
                  </Box>
                )}
              </Box>
              <Line label="Раса" value={clean(data.species)} />
              <Line label="Пол" value={clean(data.gender)} />
              <Line label="Местоимения" value={clean(data.pronouns)} />
              <Line label="Возраст" value={clean(data.age)} />
              <Line label="Вера" value={clean(data.faith)} />
              <Line label="Покровитель" value={clean(data.patron)} />
              <Line label="Любимая еда" value={food} />
              <Line label="Любимый напиток" value={drink} />
              {isUrl(oocLink) && (
                <Button
                  fluid
                  mt={1}
                  icon="link"
                  onClick={() => act('open_link', { which: 'ooc_extra_link' })}
                >
                  OOC ссылка
                </Button>
              )}
              <Button.Checkbox
                fluid
                mt={1}
                checked={showNsfw}
                onClick={() => setShowNsfw(!showNsfw)}
              >
                Показать NSFW
              </Button.Checkbox>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Stack vertical>
              <Stack.Item>
                <Section title="Описание (Flavor Text)">
                  <TextBlock text={flavor} empty="Описание не задано." />
                </Section>
              </Stack.Item>
              <Stack.Item>
                <Section title="OOC заметки">
                  <TextBlock text={ooc} empty="OOC заметок нет." />
                </Section>
              </Stack.Item>
              {gallery.length > 0 && (
                <Stack.Item>
                  <Section title="Галерея">
                    {gallery.map((url) => (
                      <Box key={url} textAlign="center" mb={1}>
                        <img src={url} style={{ maxWidth: '100%' }} />
                      </Box>
                    ))}
                  </Section>
                </Stack.Item>
              )}
              {showNsfw && (
                <>
                  <Stack.Item>
                    <Section title="NSFW описание">
                      <TextBlock
                        text={nsfwFlavor}
                        empty="NSFW описание не задано."
                      />
                    </Section>
                  </Stack.Item>
                  <Stack.Item>
                    <Section title="ERP предпочтения">
                      <TextBlock text={erp} empty="Предпочтения не заданы." />
                    </Section>
                  </Stack.Item>
                  {isUrl(nudeshot) && (
                    <Stack.Item>
                      <Section title="Nudeshot">
                        <Box textAlign="center">
                          <img src={nudeshot} style={{ maxWidth: '100%' }} />
                        </Box>
                      </Section>
                    </Stack.Item>
                  )}
                </>
              )}
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};