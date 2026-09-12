import { useState } from 'react';
import {
  Button,
  Divider,
  Dropdown,
  Input,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type FieldDescriptor = {
  key: string;
  label: string;
  type: 'text' | 'number' | 'typepath';
  base?: string;
  placeholder?: string;
  required?: boolean;
  min?: number;
};

type TypeSchema = {
  ticket_type: string;
  label: string;
  fa_icon: string;
  color: string;
  fields: FieldDescriptor[];
};

type TicketTemplate = {
  label: string;
  fa_icon: string;
  color: string;
  ticket_type: string;
  fields: Record<string, string>;
};

type Data = {
  type_schemas: TypeSchema[];
  typepath_options: Record<string, string[]>;
  templates: TicketTemplate[];
  prefill_ckey?: string;
};

export const AdminTicketGranter = () => {
  const { data, act } = useBackend<Data>();
  const { type_schemas = [], typepath_options = {}, templates = [] } = data;

  const [selectedType, setSelectedType] = useState<string>(
    type_schemas[0]?.ticket_type ?? '',
  );
  const [targetCkey, setTargetCkey] = useState(data.prefill_ckey ?? '');
  const [ticketName, setTicketName] = useState('');
  const [ticketDesc, setTicketDesc] = useState('');
  const [grantReason, setGrantReason] = useState('');
  const [payloadValues, setPayloadValues] = useState<Record<string, string>>({});
  const [submitted, setSubmitted] = useState(false);

  const schema = type_schemas.find((s) => s.ticket_type === selectedType);

  const handleTypeChange = (newType: string) => {
    setSelectedType(newType);
    setPayloadValues({});
  };

  const handleUseTemplate = (tpl: TicketTemplate) => {
    const { name, description, grant_reason, ...rest } = tpl.fields;

    setSelectedType(tpl.ticket_type);
    if (name !== undefined) setTicketName(name);
    if (description !== undefined) setTicketDesc(description);
    if (grant_reason !== undefined) setGrantReason(grant_reason);
    setPayloadValues(rest);
  };

  const handlePayloadChange = (key: string, val: string) => {
    setPayloadValues((prev) => ({ ...prev, [key]: val }));
  };

  const missingFields = (schema?.fields ?? [])
    .filter((f) => f.required && !payloadValues[f.key])
    .map((f) => f.label);

  const anyTouched = !!targetCkey || !!ticketName || Object.keys(payloadValues).length > 0;

  const canSubmit =
    !!targetCkey.trim() &&
    !!ticketName.trim() &&
    !!selectedType &&
    missingFields.length === 0;

  const handleGrant = () => {
    if (!canSubmit) return;
    setSubmitted(true);
    act('grant_ticket', {
      target_ckey: targetCkey.trim(),
      ticket_type: selectedType,
      name: ticketName.trim(),
      description: ticketDesc.trim(),
      grant_reason: grantReason.trim(),
      ...payloadValues,
    });
    setTimeout(() => {
      setSubmitted(false);
      setTargetCkey('');
      setTicketName('');
      setTicketDesc('');
      setGrantReason('');
      setPayloadValues({});
    }, 1500);
  };

  return (
    <Window height={640} title="Admin Ticket Granter" width={520}>
      <Window.Content scrollable>
        <Stack vertical fill>
        {templates.length > 0 && (
            <Section title="Templates">
              <Stack wrap>
                {templates.map((tpl) => (
                  <Stack.Item key={tpl.label} mb={1} mr={1}>
                    <Button
                      icon={tpl.fa_icon}
                      style={{ borderLeft: `3px solid ${tpl.color}`, minWidth: '150px' }}
                      onClick={() => handleUseTemplate(tpl)}
                    >
                      {tpl.label}
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          )}
          <Section title="Ticket Type">
            <Stack wrap>
              {type_schemas.map((s) => (
                <Stack.Item key={s.ticket_type} mb={1} mr={1}>
                  <Button
                    icon={s.fa_icon}
                    selected={selectedType === s.ticket_type}
                    style={{ borderLeft: `3px solid ${s.color}`, minWidth: '130px' }}
                    onClick={() => handleTypeChange(s.ticket_type)}
                  >
                    {s.label}
                  </Button>
                </Stack.Item>
              ))}
            </Stack>
          </Section>

          <Section title="Target & Details">
            <LabeledList>
              <LabeledList.Item label="Target Ckey">
                <Input
                  fluid
                  placeholder="player_ckey"
                  value={targetCkey}
                  onChange={(val) => setTargetCkey(val)}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Ticket Name">
                <Input
                  fluid
                  placeholder="e.g. Artificer Boost"
                  value={ticketName}
                  onChange={(val) => setTicketName(val)}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Description">
                <TextArea
                  fluid
                  height={3}
                  placeholder="Shown to the player in trade/use panels…"
                  value={ticketDesc}
                  onChange={(val) => setTicketDesc(val)}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Grant Reason">
                <Input
                  fluid
                  placeholder="Logged to game log"
                  value={grantReason}
                  onChange={(val) => setGrantReason(val)}
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>

          {schema && schema.fields.length > 0 && (
            <Section title={`${schema.label}`}>
              <LabeledList>
                {schema.fields.map((field) => (
                  <LabeledList.Item
                    key={field.key}
                    label={
                      field.required ? (
                        <>
                          {field.label}{' '}
                          <span style={{ color: 'var(--color-bad)' }}>*</span>
                        </>
                      ) : (
                        field.label
                      )
                    }
                  >
                    {field.type === 'typepath' && field.base ? (
                      <Dropdown
                        options={(typepath_options[field.base] ?? []).map((p) => ({
                          value: p,
                          displayText: p,
                        }))}
                        placeholder={field.placeholder ?? 'Select a type…'}
                        selected={payloadValues[field.key] ?? ''}
                        width="100%"
                        onSelected={(val: string) => handlePayloadChange(field.key, val)}
                      />
                    ) : field.type === 'number' ? (
                      <NumberInput
                          fluid
                          minValue={field.min ?? 0}
                          maxValue={9999}
                          step={1}
                          value={Number(payloadValues[field.key]) || (field.min ?? 0)}
                          onChange={(val: number) =>
                            handlePayloadChange(field.key, String(val))
                          }
                        />
                    ) : (
                      <Input
                        fluid
                        placeholder={field.placeholder}
                        value={payloadValues[field.key] ?? ''}
                        onChange={(val: string) => handlePayloadChange(field.key, val)}
                      />
                    )}
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          )}

          {anyTouched && !canSubmit && (
            <NoticeBox danger>
              {!targetCkey.trim() && <div>Target ckey is required.</div>}
              {!ticketName.trim() && <div>Ticket name is required.</div>}
              {missingFields.map((f) => (
                <div key={f}>Required field missing: {f}</div>
              ))}
            </NoticeBox>
          )}

          <Divider />

          <Section>
            <Stack align="center" justify="space-between">
              <Stack.Item>
                {schema && targetCkey && (
                  <span style={{ color: 'var(--color-label)', fontSize: '12px' }}>
                    Granting: <b>{schema.label}</b> → <b>{targetCkey}</b>
                  </span>
                )}
              </Stack.Item>
              <Stack.Item>
                <Button
                  color={submitted ? 'good' : 'green'}
                  disabled={!canSubmit || submitted}
                  icon={submitted ? 'check' : 'gift'}
                  onClick={handleGrant}
                >
                  {submitted ? 'Granted!' : 'Grant Ticket'}
                </Button>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack>
      </Window.Content>
    </Window>
  );
};
