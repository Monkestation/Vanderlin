import { useState } from 'react';
import { useBackend } from '../backend';
import { LabeledList, Section, Tabs } from 'tgui-core/components';
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
  pq: number;
  faith: string;
  patron: string;
  species: string;
  culture: string;
  family_mode: string;
  gender_pref: string;
  spouse_pref: string;
  ooc_notes: string;
  rumors: string;
  noble_gossip: string;
  food_prefs: string;
  nsfw_flavor: string;
  erp_preferences: string;
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
    pq = 0,
    faith = '',
    patron = '',
    species = '',
    culture = '',
    family_mode = '',
    gender_pref = '',
    spouse_pref = '',
    ooc_notes = '',
    rumors = '',
    noble_gossip = '',
    food_prefs = '',
    nsfw_flavor = 'OFF',
    erp_preferences = '',
  } = data;

  const edit = (key: string) => act('edit_field', { pref_key: key });

  return (
    <Window width={480} height={560} title="Who Are You?">
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
          </Section>
        )}

        {currentTab === 'class' && (
          <Section title="Class">
            <LabeledList>
              <LabeledList.Item label="Player Quality">{pq}</LabeledList.Item>
              <LabeledList.Item label="Faith">
                <span style={editStyle} onClick={() => edit('faith')}>{faith}</span>
              </LabeledList.Item>
              <LabeledList.Item label="Patron">
                <span style={editStyle} onClick={() => edit('selected_patron')}>{patron}</span>
              </LabeledList.Item>
            </LabeledList>
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
            </LabeledList>
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
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};