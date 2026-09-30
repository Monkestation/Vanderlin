import { useState } from 'react';
import { useBackend } from '../backend';
import { Button, LabeledList, Section, Tabs } from 'tgui-core/components';
import { Window } from '../layouts';

type Data = {
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
  rumors: string;
  noble_gossip: string;
  food_prefs: string;
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

export const CharacterSheet = () => {
  const { data, act } = useBackend<Data>();
  const [currentTab, setCurrentTab] = useState('identity');
  const {
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
    rumors = '',
    noble_gossip = '',
    food_prefs = '',
    nsfw_flavor = 'OFF',
    erp_preferences = '',
    headshot_link = '',
    nudeshot_link = '',
    gallery_count = 0,
    gallery_links = '',
  } = data;

  const edit = (key: string) => act('edit_field', { pref_key: key });

  return (
    <Window width={480} height={700} title="Who Are You?">
      <Window.Content>
        <Tabs>
          <Tabs.Tab
            selected={currentTab === 'identity'}
            onClick={() => setCurrentTab('identity')}
          >
            Identity
          </Tabs.Tab>
          <Tabs.Tab
            selected={currentTab === 'class'}
            onClick={() => setCurrentTab('class')}
          >
            Class
          </Tabs.Tab>
          <Tabs.Tab
            selected={currentTab === 'appearance'}
            onClick={() => setCurrentTab('appearance')}
          >
            Appearance
          </Tabs.Tab>
          <Tabs.Tab
            selected={currentTab === 'family'}
            onClick={() => setCurrentTab('family')}
          >
            Family
          </Tabs.Tab>
          <Tabs.Tab
            selected={currentTab === 'descriptors'}
            onClick={() => setCurrentTab('descriptors')}
          >
            Descriptors
          </Tabs.Tab>
        </Tabs>

        {currentTab === 'identity' && (
          <Section title="Identity">
            <LabeledList>
              <LabeledList.Item label="Character Name">
                <span style={editStyle} onClick={() => edit('real_name')}>{character_name}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Pronouns">
                <span style={editStyle} onClick={() => edit('pronouns')}>{pronouns}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Age">
                <span style={editStyle} onClick={() => edit('age')}>{age}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Voice Type">
                <span style={editStyle} onClick={() => edit('voice_type')}>{voice_type}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Accent">
                <span style={editStyle} onClick={() => edit('selected_accent')}>{accent}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Voice Color">
                <span style={{ ...editStyle, color: voice_color }} onClick={() => edit('voice_color')}>{voice_color}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Nickname Color">
                <span style={{ ...editStyle, color: nickname_color }} onClick={() => edit('nickname_color')}>{nickname_color}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Dominant Hand">
                <span style={editStyle} onClick={() => edit('domhand')}>{dominant_hand}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Permadeath">
                <span style={editStyle} onClick={() => edit('permadeath')}>{permadeath}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Examine Music">
                <span style={editStyle} onClick={() => edit('examine_music')}>{examine_music}</span>
              </LabeledList.Item>
            </LabeledList>
            <Button
              mt={1}
              fluid
              icon="star"
              onClick={() => act('open_quirks')}
            >
              Quirks ({quirks_count})
            </Button>
          </Section>
        )}

        {currentTab === 'class' && (
          <Section title="Class">
            <LabeledList>
              <LabeledList.Item label="Player Quality">{pq}</LabeledList.Item>
              <LabeledList.Item label="Triumphs">{triumphs}</LabeledList.Item>
              <LabeledList.Item label="Faith">
                <span style={editStyle} onClick={() => edit('faith')}>{faith}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Patron">
                <span style={editStyle} onClick={() => edit('selected_patron')}>{patron}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Loadout Item 1">{loadout1}</LabeledList.Item>
              <LabeledList.Item label="Loadout Item 2">{loadout2}</LabeledList.Item>
              <LabeledList.Item label="Loadout Item 3">{loadout3}</LabeledList.Item>
            </LabeledList>
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
        )}

        {currentTab === 'appearance' && (
          <Section title="Appearance">
            <LabeledList>
              <LabeledList.Item label="Species">
                <span style={editStyle} onClick={() => edit('species')}>{species}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Culture">
                <span style={editStyle} onClick={() => edit('culture')}>{culture}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Skin Tone">
                <span style={editStyle} onClick={() => edit('skin_tone')}>{skin_tone}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Detail Color">
                <span style={{ ...editStyle, color: detail_color }} onClick={() => edit('detail_color')}>{detail_color}</span>
              </LabeledList.Item>
            </LabeledList>
            <Button
              mt={1}
              fluid
              icon="paint-brush"
              onClick={() => act('open_body_markings')}
            >
              Body Markings ({markings_count})
            </Button>
          </Section>
        )}

        {currentTab === 'family' && (
          <Section title="Family">
            <LabeledList>
              <LabeledList.Item label="Family Type">
                <span style={editStyle} onClick={() => edit('family_mode')}>{family_mode}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Gender Preference">
                <span style={editStyle} onClick={() => edit('gender_choice')}>{gender_pref}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Spouse Preference">
                <span style={editStyle} onClick={() => edit('setspouse')}>{spouse_pref}</span>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}

        {currentTab === 'descriptors' && (
          <Section title="Descriptors">
            <LabeledList>
              <LabeledList.Item label="OOC Notes">
                <span style={editStyle} onClick={() => edit('ooc_notes')}>{ooc_notes || 
'None'
}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Food Preferences">{food_prefs || 
'None'
}</LabeledList.Item>
              <LabeledList.Item label="Rumors">{rumors || 
'None'
}</LabeledList.Item>
              <LabeledList.Item label="Noble Gossip">{noble_gossip || 
'None'
}</LabeledList.Item>
              <LabeledList.Item label="NSFW Flavour">
                <span style={editStyle} onClick={() => edit('nsfw_flavor')}>{nsfw_flavor}</span>
              </LabeledList.Item>
              <LabeledList.Item label="ERP Preferences">
                <span style={editStyle} onClick={() => edit('erp_preferences')}>{erp_preferences || 
'None'
}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Headshot">
                <span style={editStyle} onClick={() => edit('headshot_link')}>{headshot_link || 
'None'
}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Nudeshot">
                <span style={editStyle} onClick={() => edit('nudeshot_link')}>{nudeshot_link || 
'None'
}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Character Gallery">
                <span style={editStyle} onClick={() => edit('character_gallery')}>
                  {gallery_count} image(s){gallery_links ? ': ' + gallery_links : 
''
}
                </span>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};