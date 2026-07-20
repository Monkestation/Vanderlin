/**
 *
 * How to Use:
 *   import { TutorialOverlay, TutorialStep } from '../interfaces/_common/TutorialOverlay';
 *
 *   const MY_STEPS: TutorialStep[] = [ ... ];
 *
 *   {showTutorial && (
 *     <TutorialOverlay
 *       steps={MY_STEPS}
 *       stateKey="my_menu_tutorial"
 *       onClose={() => setShowTutorial(false)}
 *     />
 *   )}
 *
 * Each step:
 *   { title, body, highlight?, popupAnchor? }
 *
 * highlight: { top, left, width, height } in % of the overlay area.
 * popupAnchor: 'right' | 'left' | 'bottom' | 'top' | 'center' (default)
 *
 * The parent container must have position: relative and an explicit height.
 */

import { useLocalState } from '../../backend';
import { Box, Button, Stack } from 'tgui-core/components';

export const PP = {
  bg: '#1a130a',
  bgCard: '#000000',
  border: '#500d0d',
  borderBright: '#6b0000',
  headerBg: '#000000',
  text: '#c8b89a',
  textMuted: '#7a6a5a',
  textTitle: '#ddd0b8',
  dot: 'rgba(90,76,76,0.7)',
  green: '#008000',
  red: '#800000',
};

export interface TutorialHighlight {
  top: number;
  left: number;
  width: number;
  height: number;
}

export interface TutorialStep {
  title: string;
  body: string;
  highlight?: TutorialHighlight;
  popupAnchor?: 'right' | 'left' | 'bottom' | 'top' | 'center';
}

interface TutorialOverlayProps {
  steps: TutorialStep[];
  /** Unique key so multiple menus don't share step state. */
  stateKey: string;
  onClose: () => void;
}


const CARD_W = 248;
const CARD_GAP = 10;
const CARET = 8;

function popupStyle(
  anchor: TutorialStep['popupAnchor'],
  hl: TutorialHighlight | undefined
): React.CSSProperties {
  if (!hl || anchor === 'center' || !anchor) {
    return { position: 'absolute', top: '50%', left: '50%',
      transform: 'translate(-50%, -50%)', width: `${CARD_W}px` };
  }
  switch (anchor) {
    case 'right':
      return { position: 'absolute', width: `${CARD_W}px`,
        top: `${hl.top + hl.height / 2}%`,
        left: `calc(${hl.left + hl.width}% + ${CARD_GAP}px)`,
        transform: 'translateY(-50%)' };
    case 'left':
      return { position: 'absolute', width: `${CARD_W}px`,
        top: `${hl.top + hl.height / 2}%`,
        left: `calc(${hl.left}% - ${CARD_W + CARD_GAP}px)`,
        transform: 'translateY(-50%)' };
    case 'bottom':
      return { position: 'absolute', width: `${CARD_W}px`,
        top: `calc(${hl.top + hl.height}% + ${CARD_GAP}px)`,
        left: `${hl.left + hl.width / 2}%`,
        transform: 'translateX(-50%)' };
    case 'top':
      return { position: 'absolute', width: `${CARD_W}px`,
        top: `calc(${hl.top}% - ${CARD_GAP}px)`,
        left: `${hl.left + hl.width / 2}%`,
        transform: 'translate(-50%, -100%)' };
  }
}

function caretStyle(
  anchor: TutorialStep['popupAnchor'],
  hl: TutorialHighlight | undefined
): React.CSSProperties | null {
  if (!hl || !anchor || anchor === 'center') return null;
  const base: React.CSSProperties = { position: 'absolute', width: 0, height: 0 };
  const c = PP.border;
  switch (anchor) {
    case 'right':
      return { ...base, top: '50%', left: `-${CARET}px`, transform: 'translateY(-50%)',
        borderTop: `${CARET}px solid transparent`, borderBottom: `${CARET}px solid transparent`,
        borderRight: `${CARET}px solid ${c}` };
    case 'left':
      return { ...base, top: '50%', right: `-${CARET}px`, transform: 'translateY(-50%)',
        borderTop: `${CARET}px solid transparent`, borderBottom: `${CARET}px solid transparent`,
        borderLeft: `${CARET}px solid ${c}` };
    case 'bottom':
      return { ...base, top: `-${CARET}px`, left: '50%', transform: 'translateX(-50%)',
        borderLeft: `${CARET}px solid transparent`, borderRight: `${CARET}px solid transparent`,
        borderBottom: `${CARET}px solid ${c}` };
    case 'top':
      return { ...base, bottom: `-${CARET}px`, left: '50%', transform: 'translateX(-50%)',
        borderLeft: `${CARET}px solid transparent`, borderRight: `${CARET}px solid transparent`,
        borderTop: `${CARET}px solid ${c}` };
  }
}

export const TutorialOverlay = (props: TutorialOverlayProps) => {
  const { steps, stateKey, onClose } = props;
  const [step, setStep] = useLocalState(stateKey, 0);

  const s = Math.min(step, steps.length - 1);
  const current = steps[s];
  const isFirst = s === 0;
  const isLast = s === steps.length - 1;
  const hl = current.highlight;
  const anchor = current.popupAnchor ?? 'center';
  const cardStyle = popupStyle(anchor, hl);
  const caret = caretStyle(anchor, hl);

  const close = () => { setStep(0); onClose(); };

  return (
    <Box style={{
      position: 'absolute', top: 0, left: 0, width: '100%', height: '100%',
      zIndex: 9000, pointerEvents: 'none',
    }}>
      <Box style={{
        position: 'absolute', top: 0, left: 0, width: '100%', height: '100%',
        background: 'rgba(0,0,0,0.62)', pointerEvents: 'all',
      }} />

      {hl && (
        <Box style={{
          position: 'absolute',
          top: `${hl.top}%`, left: `${hl.left}%`,
          width: `${hl.width}%`, height: `${hl.height}%`,
          border: `2px dashed ${PP.borderBright}`,
          boxSizing: 'border-box',
          pointerEvents: 'none',
          zIndex: 9001,
        }} />
      )}

      <Box style={{ ...cardStyle, zIndex: 9002, pointerEvents: 'all' }}>
        {caret && <Box style={caret} />}
        <Box style={{
          background: PP.bgCard,
          border: `2px solid ${PP.border}`,
          boxShadow: '0 4px 18px rgba(0,0,0,0.7)',
          position: 'relative',
        }}>
          <Box style={{
            background: PP.headerBg,
            padding: '6px 28px 6px 10px',
            borderBottom: `2px dotted ${PP.dot}`,
          }}>
            <Box style={{ fontSize: '75%', color: PP.textMuted, marginBottom: '2px', letterSpacing: '0.06em' }}>
              STEP {s + 1} / {steps.length}
            </Box>
            <Box style={{ fontSize: '120%', fontWeight: 'bold', color: PP.textTitle }}>
              {current.title}
            </Box>
            <Box
              style={{ position: 'absolute', top: '6px', right: '8px', cursor: 'pointer',
                color: PP.textMuted, fontSize: '115%', lineHeight: 1, userSelect: 'none' }}
              onClick={close}>
              ✕
            </Box>
          </Box>

          <Box style={{ padding: '10px 12px 0 12px' }}>
            <Box style={{ fontSize: '100%', color: PP.text, lineHeight: '1.5', marginBottom: '10px' }}>
              {current.body}
            </Box>

            <Box style={{ textAlign: 'center', marginBottom: '10px' }}>
              {steps.map((_, i) => (
                <Box key={i} onClick={() => setStep(i)} style={{
                  display: 'inline-block', width: '6px', height: '6px',
                  borderRadius: '50%', margin: '0 3px', verticalAlign: 'middle',
                  cursor: 'pointer',
                  background: i === s ? PP.borderBright : PP.dot,
                }} />
              ))}
            </Box>
          </Box>

          <Box style={{ borderTop: `1px dotted ${PP.dot}`, padding: '8px 12px' }}>
            <Stack justify="space-between" align="center">
              <Stack.Item>
                {!isFirst
                  ? <Button onClick={() => setStep(s - 1)} style={{
                    background: 'transparent', border: `1px solid ${PP.border}`,
                    color: PP.text, padding: '2px 10px', fontSize: '105%' }}>
                    ← Back
                  </Button>
                  : <Box style={{ width: '60px' }} />}
              </Stack.Item>
              <Stack.Item>
                <Button
                  onClick={isLast ? close : () => setStep(s + 1)}
                  style={{
                    background: isLast ? 'rgba(30,60,30,0.6)' : 'rgba(0, 0, 0, 0.6)',
                    border: `1px solid ${isLast ? '#3a6a3a' : PP.border}`,
                    color: isLast ? '#7acc7a' : PP.textTitle,
                    padding: '2px 10px', fontSize: '105%',
                  }}>
                  {isLast ? '✓ Done' : 'Next →'}
                </Button>
              </Stack.Item>
            </Stack>
          </Box>
        </Box>
      </Box>
    </Box>
  );
};
