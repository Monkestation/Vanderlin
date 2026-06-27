import { useState } from 'react';
import {
  Button,
  TextArea,
  Section,
  Stack,
  Input,
  Dropdown,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  byond: string;
  ckey: string;
  round_id: string;
  map: string;
}

// Labels should match a label on the github
const LABELS = [
  "Antagonist",
  "Medical",
  "Interface",
  "Mapping",
  "Other",
]

const SEVERITY_NONE = "Not set"

const SEVERITIES = [
  "Critical",
  "Major",
  "Minor",
  "Trivial",
  SEVERITY_NONE,
]

export const sanitizeMultiline = (toSanitize: string) => {
  return toSanitize.replace(/(\n|\r\n){3,}/, '\n\n');
};

export const BugReport = () => {
  const { act, data } = useBackend<Data>();
  const {
    byond,
    ckey,
    round_id,
    map,
  } = data;

  const [title, setTitle] = useState('');
  const [input, setInput] = useState('');
  const [severity, setSeverity] = useState(SEVERITY_NONE);
  const [labels, setLabels] = useState<string[]>([]);

  const updateLabel = (value: string) => {
    const newLabel = [...labels]
    if (newLabel.includes(value)) {
      newLabel.splice(newLabel.indexOf(value));
    } else {
      newLabel.push(value);
    }
    setLabels(newLabel);
  }

  const onTypeInput = (value: string) => {
    if (value === input) {
      return;
    }
    setInput(sanitizeMultiline(value));
  };

  const onTypeTitle = (value: string) => {
    if (value === title) {
      return;
    }
    setTitle(value);
  }

  return (
    <Window
      title="Bug Report"
      width={600}
      height={400}
    >
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item height={'85%'}>
            <Stack fill>
              <Stack.Item width={'25%'}>
                <Section fill title="Extra info">
                  <Stack vertical>
                    <Stack.Item>
                      Ckey: {ckey}
                    </Stack.Item>
                    <Stack.Item>
                      Byond: {byond}
                    </Stack.Item>
                    <Stack.Item>
                      Round ID: {round_id ? round_id : "Unknown"}
                    </Stack.Item>
                    <Stack.Item>
                      Map: {map}
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Section fill title="Content">
                  <Input
                    autoFocus
                    autoSelect
                    fluid
                    mb={1}
                    onChange={onTypeTitle}
                    placeholder="Your title..."
                    value={title}
                  />
                  <TextArea
                    fluid
                    height={'90%'}
                    maxLength={1024}
                    onChange={onTypeInput}
                    placeholder="Type your report..."
                    value={input}
                  />
                </Section>
              </Stack.Item>
              <Stack.Item width={'25%'}>
                <Stack fill vertical>
                  <Stack.Item height={'70%'}>
                    <Section fill title="Labels">
                      {LABELS.map((value, i) => (
                        <Button
                          key={i}
                          color={labels.includes(value) ? "good" : null}
                          onClick={() => updateLabel(value)}
                        >
                          {value}
                        </Button>
                      ))}
                    </Section>
                  </Stack.Item>
                  <Stack.Item height={'30%'}>
                    <Section fill title="Severity">
                      <Dropdown
                        options={SEVERITIES}
                        selected={severity}
                        onSelected={(value) => setSeverity(value)}
                      />
                    </Section>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item height={'5%'}>
            <Section fill>
              <Button
                color="good"
                textAlign="center"
                fluid
                onClick={() => act('submit', {
                  user_data: data,
                  report_title: title,
                  report_body: input,
                  labels: labels,
                  severity: severity,
                })}
                px={4}
              >
                Submit
              </Button>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  )
}
