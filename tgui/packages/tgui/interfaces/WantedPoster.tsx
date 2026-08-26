import { useBackend } from '../backend';
//import { useLocalState } from '../backend';
import { Box, Button, DmIcon, Icon, Input, Section, Table, Stack, Flex } from 'tgui-core/components';
import { Window } from '../layouts';


const PAGES = {
  display_outlaws: () => DisplayOutlaws,
  approve_outlaw: () => ApproveOutlaws,
};

type Data = {
  current_menu: string;
  outlaw_power: number;
  outlaws: Outlaw[];
  requested_outlaws: RequestOutlaw[];
}

type Outlaw = {
  name: string;
  icon: string;
  reason: string;
}

type RequestOutlaw = {
  name: string;
  icon: string;
  reason: string;
  requestee: string;
}

type WantedPosterProps = {
  outlaw: Outlaw;
};

type RequestPosterProps = {
  request: RequestOutlaw;
}

export const WantedPoster = (props) => {
  const { data } = useBackend<Data>();
  const { current_menu} = data;
  //const PageComponent = PAGES[current_menu]();

  return (
    <Window
      title="Wanted Poster"
      width={600}
      height={600}
    >
      <Window.Content scrollable>
        <DisplayOutlaws />
      </Window.Content>
    </Window>
  );
};



//<Box style={{ flex: 1, height: '100%', overflow: 'visible', display: 'flex', flexDirection: 'column'}}>
//      {outlaws.map((outlaw, outlawIdx) => (
//        <div style={{text-align: 'center', background: 'orange'}}>
//          DEAD OR ALIVE
//          </Box>
//          (outlaw.name)
//        </div>
//    ))}
//    </Box>

const DisplayOutlaws = (props) => {
  const { act, data } = useBackend<Data>();
  const { outlaws } = data;
  // use modulo (%) to later have it so for every 3, we add a new row.
  // DEAD OR ALIVE
  // ICON
  // NAME
  return(
    <>
    <Section>
      <Button
        icon="id-card"
        width="30vw"
        textAlign="center"
        fontSize="1.5rem"
        p="1rem"
        mt="5rem"
        onClick={() => act('make_outlaw')}
      >
        Make Outlaw
      </Button>
    </Section>
    <Section>
      Broken thing goes here
    </Section>
    </>

  );
};

const ApproveOutlaws = (props) => {
  const { act, data } = useBackend<Data>();
  const { requested_outlaws } = data;
  return(
    <Section>
      {requested_outlaws.map((name, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold>{name}</Flex.Item>
            </Flex>
          );
        })}
    </Section>

  );
};


const OutlawPoster = (props: WantedPosterProps) =>{
  const { outlaw } = props;

};

