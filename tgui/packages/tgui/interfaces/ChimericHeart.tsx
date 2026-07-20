import { useBackend, useLocalState } from '../backend';
import { Box, Button, ProgressBar, Section, Stack, Tooltip } from 'tgui-core/components';
import { Window } from '../layouts';
import { TutorialOverlay } from '../interfaces/_common/TutorialOverlay';

const TUTORIAL_STEPS = [
  {
    title: 'Chimeric Organ Interface',
    body: 'This menu lets you inspect and rewire the humor nodes stitched into this chimeric organ. Nodes must be paired an input drives an output.',
    popupAnchor: 'center',
  },
  {
    title: 'Inputs & Outputs',
    body: 'The left column lists input nodes and the right lists output nodes. Each shows its tier and purity. Unpaired nodes are inactive.',
    highlight: { top: 10, left: 0, width: 35, height: 90 },
    popupAnchor: 'right',
  },
  {
    title: 'Pairing Nodes',
    body: 'Click an input to select it, then click a compatible output to pair them. Nodes must be within the maximum tier difference. Incompatible nodes will dim.',
    popupAnchor: 'center',
  },
  {
    title: 'Disconnecting',
    body: 'Click a paired node then use the unlink button to sever the connection. Both nodes return to unpaired status.',
    popupAnchor: 'center',
  },
  {
    title: 'Blood Requirements',
    body: 'The center panel shows how much stored blood each node requires. Unmet requirements will cause the organ to begin failing.',
    highlight: { top: 10, left: 33, width: 34, height: 50 },
    popupAnchor: 'center',
  },
  {
    title: 'Stability',
    body: 'The stability bar shows organ health. At 0% the organ fails and must be repaired before it can function again.',
    highlight: { top: 0, left: 50, width: 50, height: 10 },
    popupAnchor: 'bottom',
  },
];

interface BloodRequirement {
  blood_type: string;
  required: number;
  stored: number;
}

interface InputNode {
  id: string;
  name: string;
  tier: number;
  purity: number;
  partner_id: string | null;
  is_special: boolean;
}

interface OutputNode {
  id: string;
  name: string;
  tier: number;
  purity: number;
  partner_id: string | null;
  is_special: boolean;
}

interface SpecialNode {
  id: string;
  name: string;
  needs_attachment: boolean;
  attachment_type: string | null;
  attached_id: string | null;
}

interface ChimericHeartData {
  organ_name: string;
  failed: boolean;
  failed_percent: number;
  processing: boolean;
  maximum_tier_difference: number;
  inputs: InputNode[];
  outputs: OutputNode[];
  partnerless_inputs: InputNode[];
  partnerless_outputs: OutputNode[];
  special_nodes: SpecialNode[];
  blood_requirements: BloodRequirement[];
}

const areCompatible = (
  inputTier: number,
  outputTier: number,
  maxDiff: number,
) => Math.abs(inputTier - outputTier) <= maxDiff;

const purityColor = (purity: number) => {
  if (purity >= 80) return 'good';
  if (purity >= 50) return 'average';
  return 'bad';
};

const NodeRow = (props: {
  node: InputNode | OutputNode;
  partnerName: string | null;
  selected: boolean;
  compatible: boolean | null;
  onSelect: () => void;
  onDisconnect: () => void;
}) => {
  const { node, partnerName, selected, compatible, onSelect, onDisconnect } = props;
  const isPaired = !!node.partner_id;

  return (
    <Box
      mb={1}
      style={{ opacity: compatible === false ? 0.4 : 1 }}>
      <Button
        fluid
        selected={selected}
        onClick={onSelect}>
        <Stack align="center">
          <Stack.Item grow>
            {node.name}
            {' '}
            <Box as="span" color="label">T{node.tier}</Box>
            {!!node.is_special && (
              <Box as="span" color="purple"> [special]</Box>
            )}
          </Stack.Item>
          {!!isPaired && (
            <Stack.Item>
              <Tooltip content="Disconnect pairing" position="left">
                <Box
                  as="span"
                  onClick={(e) => {
                    e.stopPropagation();
                    onDisconnect();
                  }}>
                  ✕
                </Box>
              </Tooltip>
            </Stack.Item>
          )}
        </Stack>
      </Button>
      <Box ml={1}>
        <Stack align="center" spacing={1}>
          <Stack.Item grow>
            <ProgressBar
              value={node.purity / 100}
              color={purityColor(node.purity)}>
              {node.purity}% purity
            </ProgressBar>
          </Stack.Item>
          <Stack.Item>
            <Box color={isPaired ? 'good' : 'average'}>
              {isPaired ? `⇄ ${partnerName}` : 'unpaired'}
            </Box>
          </Stack.Item>
        </Stack>
      </Box>
    </Box>
  );
};

const ChimericPanel = (props: { data: ChimericHeartData; act: (action: string, payload?: object) => void }) => {
  const { data, act } = props;
  const {
    failed,
    failed_percent,
    maximum_tier_difference,
    inputs,
    outputs,
    partnerless_inputs,
    partnerless_outputs,
    special_nodes,
    blood_requirements,
  } = data;

  const [selectedInput, setSelectedInput] = useLocalState(
    'selected_input',
    null,
  );
  const [selectedOutput, setSelectedOutput] = useLocalState(
    'selected_output',
    null,
  );
  const [showTutorial, setShowTutorial] = useLocalState(
    'show_chimeric_tutorial',
    false,
  );

  const allInputs = [...inputs, ...partnerless_inputs];
  const allOutputs = [...outputs, ...partnerless_outputs];
  const isSelecting = selectedInput !== null || selectedOutput !== null;

  const getPartnerName = (
    partnerId: string | null,
    fromType: 'input' | 'output',
  ) => {
    if (!partnerId) return null;
    if (fromType === 'input')
      return allOutputs.find((n) => n.id === partnerId)?.name ?? null;
    return allInputs.find((n) => n.id === partnerId)?.name ?? null;
  };

  const handleInputSelect = (id: string) => {
    if (selectedInput === id) {
      setSelectedInput(null);
      return;
    }
    if (selectedOutput) {
      act('connect_nodes', { input_id: id, output_id: selectedOutput });
      setSelectedInput(null);
      setSelectedOutput(null);
      return;
    }
    setSelectedInput(id);
  };

  const handleOutputSelect = (id: string) => {
    if (selectedOutput === id) {
      setSelectedOutput(null);
      return;
    }
    if (selectedInput) {
      act('connect_nodes', { input_id: selectedInput, output_id: id });
      setSelectedInput(null);
      setSelectedOutput(null);
      return;
    }
    setSelectedOutput(id);
  };

  const handleDisconnect = (nodeId: string, nodeType: 'input' | 'output') => {
    act('disconnect_node', { node_id: nodeId, node_type: nodeType });
    setSelectedInput(null);
    setSelectedOutput(null);
  };

  const inputCompatibility = (node: InputNode): boolean | null => {
    if (!selectedOutput) return null;
    const outNode = allOutputs.find((o) => o.id === selectedOutput);
    if (!outNode) return null;
    return areCompatible(node.tier, outNode.tier, maximum_tier_difference);
  };

  const outputCompatibility = (node: OutputNode): boolean | null => {
    if (!selectedInput) return null;
    const inNode = allInputs.find((i) => i.id === selectedInput);
    if (!inNode) return null;
    return areCompatible(inNode.tier, node.tier, maximum_tier_difference);
  };

  return (
    <Stack fill vertical>
      {showTutorial && (
        <TutorialOverlay
          steps={TUTORIAL_STEPS}
          stateKey="chimeric_heart_tutorial"
          onClose={() => setShowTutorial(false)}
        />
      )}

      <Stack.Item>
        <Stack align="center">
          <Stack.Item grow>
            <Stack align="center">
              <Stack.Item color="label">Stability</Stack.Item>
              <Stack.Item grow>
                <ProgressBar
                  value={(100 - failed_percent) / 100}
                  color={
                    failed_percent >= 75
                      ? 'bad'
                      : failed_percent >= 40
                        ? 'average'
                        : 'good'
                  }>
                  {!!failed && 'FAILED'}
                  {100 - failed_percent}%
                </ProgressBar>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Tooltip content="Show tutorial" position="bottom">
              <Button
                compact
                icon="question-circle"
                color="transparent"
                onClick={() => setShowTutorial(true)}
              />
            </Tooltip>
          </Stack.Item>
        </Stack>
      </Stack.Item>

      {isSelecting && (
        <Stack.Item>
          <Stack align="center" >
            <Stack.Item grow color="average">
              {selectedInput
                ? `Input selected: click a compatible output to pair (max tier diff: ±${maximum_tier_difference})`
                : `Output selected: click a compatible input to pair (max tier diff: ±${maximum_tier_difference})`}
            </Stack.Item>
            <Stack.Item>
              <Button
                compact
                color="transparent"
                onClick={() => {
                  setSelectedInput(null);
                  setSelectedOutput(null);
                }}>
                Cancel
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      )}

      <Stack.Item grow>
        <Stack fill>
          <Stack.Item width="33%">
            <Section fill title="Inputs" scrollable>
              {allInputs.length === 0 && (
                <Box color="label" italic>No input nodes.</Box>
              )}
              {allInputs.map((node) => (
                <NodeRow
                  key={node.id}
                  node={node}
                  partnerName={getPartnerName(node.partner_id, 'input')}
                  selected={selectedInput === node.id}
                  compatible={inputCompatibility(node)}
                  onSelect={() => handleInputSelect(node.id)}
                  onDisconnect={() => handleDisconnect(node.id, 'input')}
                />
              ))}
            </Section>
          </Stack.Item>

          <Stack.Item width="34%">
            <Stack fill vertical>
              <Stack.Item>
                <Section title="Blood Requirements">
                  {blood_requirements.length === 0 && (
                    <Box color="label" italic>No blood requirements.</Box>
                  )}
                  {blood_requirements.map((req) => {
                    const ratio = Math.min(req.stored / req.required, 1);
                    const met = req.stored >= req.required;
                    return (
                      <Stack key={req.blood_type} align="center" mb={1}>
                        <Stack.Item width={8} color="label">
                          {req.blood_type}
                        </Stack.Item>
                        <Stack.Item grow>
                          <ProgressBar
                            value={ratio}
                            color={
                              met ? 'good' : ratio > 0.5 ? 'average' : 'bad'
                            }>
                            {req.stored}/{req.required}
                          </ProgressBar>
                        </Stack.Item>
                      </Stack>
                    );
                  })}
                </Section>
              </Stack.Item>

              <Stack.Item>
                <Section title="Special Nodes">
                  {special_nodes.length === 0 && (
                    <Box color="label" italic>No special nodes.</Box>
                  )}
                  {special_nodes.map((sp) => {
                    const attachedName = sp.attached_id
                      ? (allInputs.find((n) => n.id === sp.attached_id)
                          ?.name ??
                         allOutputs.find((n) => n.id === sp.attached_id)
                           ?.name ??
                         null)
                      : null;
                    return (
                      <Box key={sp.id} mb={1}>
                        <Box bold>{sp.name}</Box>
                        {!!sp.needs_attachment && (
                          <Box color="label">
                            {attachedName
                              ? `Anchored → ${attachedName}`
                              : `Awaiting ${sp.attachment_type?.toLowerCase() ?? 'node'} anchor`}
                          </Box>
                        )}
                      </Box>
                    );
                  })}
                </Section>
              </Stack.Item>

              <Stack.Item>
                <Section title="Pairings">
                  {inputs.length === 0 ? (
                    <Box color="label" italic>No paired nodes.</Box>
                  ) : (
                    inputs.map((inp) => {
                      const out = outputs.find((o) => o.id === inp.partner_id);
                      if (!out) return null;
                      return (
                        <Box key={inp.id} mb={0.5}>
                          <Box as="span" color="blue">{inp.name}</Box>
                          {' ⇄ '}
                          <Box as="span" color="red">{out.name}</Box>
                        </Box>
                      );
                    })
                  )}
                  {(partnerless_inputs.length > 0 ||
                    partnerless_outputs.length > 0) && (
                    <Box color="average" mt={1}>
                      {partnerless_inputs.length > 0 && (
                        <Box>
                          {partnerless_inputs.length} input
                          {partnerless_inputs.length !== 1 ? 's' : ''} unpaired
                        </Box>
                      )}
                      {partnerless_outputs.length > 0 && (
                        <Box>
                          {partnerless_outputs.length} output
                          {partnerless_outputs.length !== 1 ? 's' : ''} unpaired
                        </Box>
                      )}
                    </Box>
                  )}
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item width="33%">
            <Section fill title="Outputs" scrollable>
              {allOutputs.length === 0 && (
                <Box color="label" italic>No output nodes.</Box>
              )}
              {allOutputs.map((node) => (
                <NodeRow
                  key={node.id}
                  node={node}
                  partnerName={getPartnerName(node.partner_id, 'output')}
                  selected={selectedOutput === node.id}
                  compatible={outputCompatibility(node)}
                  onSelect={() => handleOutputSelect(node.id)}
                  onDisconnect={() => handleDisconnect(node.id, 'output')}
                />
              ))}
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const ChimericHeart = (props, context) => {
  const { act, data } = useBackend<ChimericHeartData>();

  return (
    <Window title="Chimeric Organ" width={700} height={480}>
      <Window.Content>
        <ChimericPanel data={data} act={act} />
      </Window.Content>
    </Window>
  );
};
