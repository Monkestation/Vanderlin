import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Section, Stack } from 'tgui-core/components';

const str = (v: unknown): string => {
  if (typeof v !== 'string') {
    return '';
  }
  const s = v.trim();
  return s === '0' || s === '00' ? '' : s;
};

const isUrl = (v: unknown): boolean =>
  typeof v === 'string' && /^https?:\/\//i.test(v.trim());

const TEXT_STYLE = { whiteSpace: 'pre-wrap', wordBreak: 'break-word' } as const;

const ModeButtons = (props: {
  mode: string;
  setMode: (m: string) => void;
  nsfwDisabled: boolean;
}) => (
  <>
    <Button
      selected={props.mode === 'SFW'}
      bold={props.mode === 'SFW'}
      textAlign="center"
      minWidth="60px"
      onClick={() => props.setMode('SFW')}
    >
      SFW
    </Button>
    <Button
      selected={props.mode === 'NSFW'}
      bold={props.mode === 'NSFW'}
      disabled={props.nsfwDisabled}
      textAlign="center"
      minWidth="60px"
      onClick={() => props.setMode('NSFW')}
    >
      NSFW
    </Button>
  </>
);

const Body = (props: { text: string; empty: string }) =>
  props.text ? (
    <Box style={TEXT_STYLE}>{props.text}</Box>
  ) : (
    <Box color="gray">{props.empty}</Box>
  );

export const CharacterExamine = () => {
  const { act, data } = useBackend<any>();
  const [page, setPage] = useState('main');
  const [oocMode, setOocMode] = useState('SFW');
  const [flavorMode, setFlavorMode] = useState('SFW');

  const name = str(data.character_name) || 'Персонаж';
  const headshot = str(data.headshot_link);
  const nudeshot = str(data.nudeshot_link);
  const oocLink = str(data.ooc_extra_link);
  const flavor = str(data.flavortext ?? data.flavor_text);
  const ooc = str(data.ooc_notes);
  const erp = str(data.erp_preferences);

  const rawGallery = data.gallery_links ?? data.gallery ?? '';
  const galleryParts: unknown[] = Array.isArray(rawGallery)
    ? rawGallery
    : String(rawGallery).split(',');
  const gallery: string[] = galleryParts
    .map((x) => String(x).trim())
    .filter((x) => isUrl(x));

  const nsfwFlavorAvailable = isUrl(nudeshot);

  return (
    <Window title={name} width={1000} height={700}>
      <Window.Content>
        <Stack vertical fill>
          {gallery.length > 0 && (
            <>
              <Stack>
                <Stack.Item grow>
                  <Button
                    fluid
                    align="center"
                    fontSize="1.2em"
                    selected={page === 'main'}
                    onClick={() => setPage('main')}
                  >
                    Flavor Text
                  </Button>
                </Stack.Item>
                <Stack.Item grow>
                  <Button
                    fluid
                    align="center"
                    fontSize="1.2em"
                    selected={page === 'gallery'}
                    onClick={() => setPage('gallery')}
                  >
                    Галерея
                  </Button>
                </Stack.Item>
              </Stack>
              <Stack.Divider />
            </>
          )}
          <Stack.Item grow>
            {page === 'gallery' && gallery.length > 0 ? (
              <Section fill scrollable title="Галерея персонажа">
                {gallery.map((url) => (
                  <Box key={url} textAlign="center" mb={1}>
                    <img src={url} style={{ maxWidth: '100%' }} />
                  </Box>
                ))}
              </Section>
            ) : (
              <Stack fill>
                <Stack.Item width="370px">
                  <Stack fill vertical>
                    <Stack.Item align="center">
                      {isUrl(headshot) ? (
                        <img
                          src={headshot}
                          style={{
                            width: '350px',
                            height: '350px',
                            objectFit: 'contain',
                          }}
                        />
                      ) : (
                        <Box
                          width="350px"
                          height="350px"
                          color="gray"
                          style={{
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                          }}
                        >
                          Хэдшота нет.
                        </Box>
                      )}
                    </Stack.Item>
                    <Stack.Item grow>
                      <Section
                        fill
                        scrollable
                        title="OOC Notes"
                        buttons={
                          <ModeButtons
                            mode={oocMode}
                            setMode={setOocMode}
                            nsfwDisabled={!erp}
                          />
                        }
                      >
                        {oocMode === 'SFW' ? (
                          <Body text={ooc} empty="OOC заметок нет." />
                        ) : (
                          <Body text={erp} empty="NSFW заметок нет." />
                        )}
                      </Section>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item grow>
                  <Section
                    fill
                    scrollable
                    title="Flavor Text"
                    buttons={
                      <ModeButtons
                        mode={flavorMode}
                        setMode={setFlavorMode}
                        nsfwDisabled={!nsfwFlavorAvailable}
                      />
                    }
                  >
                    {flavorMode === 'SFW' ? (
                      <>
                        <Body text={flavor} empty="Описание не задано." />
                        {isUrl(oocLink) && (
                          <Button
                            mt={1}
                            icon="link"
                            onClick={() =>
                              act('open_link', { which: 'ooc_extra_link' })
                            }
                          >
                            OOC ссылка
                          </Button>
                        )}
                      </>
                    ) : (
                      <>
                        {!isUrl(nudeshot) && (<Box color="gray">NSFW материалов нет.</Box>)}
                        {isUrl(nudeshot) && (
                          <Box mt={1} textAlign="center">
                            <img src={nudeshot} style={{ maxWidth: '100%' }} />
                          </Box>
                        )}
                      </>
                    )}
                  </Section>
                </Stack.Item>
              </Stack>
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};