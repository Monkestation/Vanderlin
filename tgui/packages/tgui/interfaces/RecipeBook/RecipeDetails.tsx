import { Box } from 'tgui-core/components';
import { Sprite, Badge, HR } from './Primitives';
import type { Recipe } from './types';
import { DetailRepeatable } from './details/DetailRepeatable';
import { DetailBrewing } from './details/DetailBrewing';
import { DetailBlueprint } from './details/DetailBlueprint';
import { DetailContainerCraft } from './details/DetailContainerCraft';
import { DetailMolten } from './details/DetailMolten';
import { DetailAnvil } from './details/DetailAnvil';
import { DetailArtificer } from './details/DetailArtificer';
import { DetailPottery } from './details/DetailPottery';
import { DetailRuneRitual } from './details/DetailRuneRitual';
import { DetailBookEntry } from './details/DetailBookEntry';
import { DetailAlchCauldron } from './details/DetailAlchCauldron';
import { DetailEssenceCombination } from './details/DetailEssenceCombination';
import { DetailEssenceInfusion } from './details/DetailEssenceInfusion';
import { DetailNaturalPrecursor } from './details/DetailNaturalPrecursor';
import { DetailPlantDef } from './details/DetailPlantDef';
import { DetailSurgery } from './details/DetailSurgery';
import { DetailWound } from './details/DetailWound';
import { DetailChimericNode } from './details/DetailChimericNode';
import { DetailChimericTable } from './details/DetailChimericTable';
import { DetailFish } from './details/DetailFish';
import { DetailSnackProcessing } from './details/DetailSnackProcessing';
import { DetailObtainedFrom } from './details/DetailObtainedFrom';
import { DetailSourcePage } from './details/DetailSourcePage';
import { DetailSlapcraft } from './details/DetailSlapcraft';
import { DetailOrderlessSlapcraft } from './details/DetailOrderlessSlapcraft';
import { DetailOrgan } from './details/DetailOrgan';
import { DetailChemicalReaction } from './details/DetailChemicalReaction';
import { DetailDistillation } from './details/DetailDistillation';
import { DetailArcyneCrafting } from './details/DetailArcyneCrafting';

type Props = {
  recipe: Recipe;
  lookup: Map<string, Recipe>;
  pickerMap: Map<string, Recipe[]>;
  allRecipes: Recipe[];
  essenceIndex: Map<string, Recipe[]>;
  onNavigate: (r: Recipe) => void;
  history: Recipe[];
  onBack: () => void;
};

export const RecipeDetail = ({ recipe: r, lookup, pickerMap, allRecipes, essenceIndex, onNavigate, history, onBack }: Props) => {
  const sharedProps = { r, lookup, pickerMap, allRecipes, essenceIndex, nav: onNavigate };

  // please someone tell me a better way then this, I don't wanna look like fucking yandere dev
  const renderBody = () => {
    switch (r.type) {
      case 'repeatable':          return <DetailRepeatable {...sharedProps} />;
      case 'brewing':             return <DetailBrewing {...sharedProps} />;
      case 'blueprint':           return <DetailBlueprint {...sharedProps} />;
      case 'container_craft':     return <DetailContainerCraft {...sharedProps} />;
      case 'molten':              return <DetailMolten {...sharedProps} />;
      case 'anvil':               return <DetailAnvil {...sharedProps} />;
      case 'artificer':           return <DetailArtificer {...sharedProps} />;
      case 'pottery':             return <DetailPottery {...sharedProps} />;
      case 'runeritual':          return <DetailRuneRitual {...sharedProps} />;
      case 'book_entry':          return <DetailBookEntry r={r} />;
      case 'alch_cauldron':       return <DetailAlchCauldron {...sharedProps} />;
      case 'essence_combination': return <DetailEssenceCombination {...sharedProps} />;
      case 'essence_infusion':    return <DetailEssenceInfusion {...sharedProps} />;
      case 'natural_precursor':   return <DetailNaturalPrecursor {...sharedProps} />;
      case 'plant_def':           return <DetailPlantDef r={r} />;
      case 'surgery':             return <DetailSurgery {...sharedProps} />;
      case 'wound':               return <DetailWound r={r} />;
      case 'chimeric_node':       return <DetailChimericNode r={r} />;
      case 'chimeric_table':      return <DetailChimericTable {...sharedProps} />;
      case 'fish':                return <DetailFish r={r} />;
      case 'snack_processing':    return <DetailSnackProcessing {...sharedProps} />;
      case 'obtained_from':       return <DetailObtainedFrom {...sharedProps} />;
      case 'source_page':         return <DetailSourcePage {...sharedProps} />;
      case 'slapcraft':           return <DetailSlapcraft {...sharedProps} />;
      case 'orderless_slapcraft': return <DetailOrderlessSlapcraft {...sharedProps} />;
      case 'organ':               return <DetailOrgan {...sharedProps} />;
      case 'chemical_reaction':   return <DetailChemicalReaction {...sharedProps} />;
      case 'distillation':        return <DetailDistillation {...sharedProps} />;
      case 'arcyne_crafting':     return <DetailArcyneCrafting {...sharedProps} />;
      default:
        return <Box className="RecipeBook__desc">No details available for type: {r.type}</Box>;
    }
  };

  return (
    <Box style={{ padding: '8px 12px', height: '100%', display: 'flex', flexDirection: 'column' }}>
      <Box className="RecipeBook__breadcrumb">
        {history.length > 0 && (
          <span className="RecipeBook__breadcrumb-back" onClick={onBack} title="Go back">
            ← {history[history.length - 1].name}
          </span>
        )}
      </Box>
      <Box className="RecipeBook__detail-title">
        <Sprite icon={r.output_icon} icon_state={r.output_state} size={2} />
        {r.name}
        {r.output_count !== undefined && r.output_count > 1 ? ` ×${r.output_count}` : ''}
      </Box>
      <Badge>{r.category}</Badge>
      <HR />
      <Box overflowY="scroll" style={{ flex: 1 }}>
        {renderBody()}
      </Box>
    </Box>
  );
};
