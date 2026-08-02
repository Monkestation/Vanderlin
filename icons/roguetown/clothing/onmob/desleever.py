#!/usr/bin/env python3
"""
DMI Sprite Desleeving Script
Merges directional sprite states (r_, l_ prefixed) back into base states within DMI files.
"""

import os
import sys
import shutil
from PIL import Image, PngImagePlugin
from pathlib import Path
import re

class DMIDesleever:
    def __init__(self):
        self.stats = {
            'files_processed': 0,
            'states_merged': 0,
            'states_removed': 0,
            'errors': 0
        }

    def parse_dmi_metadata(self, img):
        """Parse DMI metadata from PNG info"""
        if 'Description' not in img.info:
            return None

        description = img.info['Description']
        lines = description.strip().split('\n')

        if not lines or not lines[0].startswith('# BEGIN DMI'):
            return None

        metadata = {
            'version': '4.0',
            'width': 32,
            'height': 32,
            'states': []
        }

        current_state = None

        for line in lines[1:]:
            line = line.strip()

            if line.startswith('version ='):
                metadata['version'] = line.split('=')[1].strip()
            elif line.startswith('width ='):
                metadata['width'] = int(line.split('=')[1].strip())
            elif line.startswith('height ='):
                metadata['height'] = int(line.split('=')[1].strip())
            elif line.startswith('state ='):
                if current_state:
                    metadata['states'].append(current_state)
                state_name = line.split('=', 1)[1].strip().strip('"')
                current_state = {
                    'name': state_name,
                    'dirs': 1,
                    'frames': 1,
                    'delays': []
                }
            elif current_state:
                if line.startswith('dirs ='):
                    current_state['dirs'] = int(line.split('=')[1].strip())
                elif line.startswith('frames ='):
                    current_state['frames'] = int(line.split('=')[1].strip())
                elif line.startswith('delay ='):
                    delays_str = line.split('=', 1)[1].strip()
                    current_state['delays'] = [float(x) for x in delays_str.split(',')]

        if current_state:
            metadata['states'].append(current_state)

        return metadata

    def build_dmi_metadata(self, metadata):
        """Build DMI metadata string"""
        lines = ['# BEGIN DMI']
        lines.append(f'version = {metadata["version"]}')
        lines.append(f'\twidth = {metadata["width"]}')
        lines.append(f'\theight = {metadata["height"]}')

        for state in metadata['states']:
            lines.append(f'state = "{state["name"]}"')
            lines.append(f'\tdirs = {state["dirs"]}')
            lines.append(f'\tframes = {state["frames"]}')
            if state.get('delays'):
                delays_str = ','.join(str(d) for d in state['delays'])
                lines.append(f'\tdelay = {delays_str}')

        lines.append('# END DMI')
        return '\n'.join(lines)

    def extract_state_images(self, img, metadata):
        """Extract individual state images from the DMI sprite sheet"""
        width = metadata['width']
        height = metadata['height']

        # Calculate sprites per row
        sprites_per_row = img.width // width

        states_images = {}
        current_index = 0

        for state in metadata['states']:
            total_sprites = state['dirs'] * state['frames']
            sprites = []

            for i in range(total_sprites):
                sprite_index = current_index + i
                row = sprite_index // sprites_per_row
                col = sprite_index % sprites_per_row

                x = col * width
                y = row * height

                sprite = img.crop((x, y, x + width, y + height))
                sprites.append(sprite)

            states_images[state['name']] = sprites
            current_index += total_sprites

        return states_images

    def find_state_variants(self, states):
        """Find base states and their r_, l_ variants"""
        base_states = {}

        for state_name in states:
            # Skip variant states
            if state_name.startswith('r_') or state_name.startswith('l_'):
                continue

            variants = {}

            # Look for right variant
            r_name = f'r_{state_name}'
            if r_name in states:
                variants['r'] = r_name

            # Look for left variant
            l_name = f'l_{state_name}'
            if l_name in states:
                variants['l'] = l_name

            if variants:
                base_states[state_name] = variants

        return base_states

    def merge_state_directions(self, base_state_name, base_sprites, variant_sprites_dict, metadata_states):
        """Merge directional variants by compositing them onto base sprites"""
        # Get base state metadata
        base_state = next((s for s in metadata_states if s['name'] == base_state_name), None)

        if not base_state:
            raise ValueError(f"Could not find metadata for state: {base_state_name}")

        # The base already has directions, we're just adding overlays
        # We need to composite the r_ and l_ sprites onto the base sprites
        # r_ = right arm, l_ = left arm (or vice versa)

        merged_sprites = []
        frames = base_state['frames']
        dirs = base_state['dirs']

        # Process each sprite in the base state
        for i, base_sprite in enumerate(base_sprites):
            # Create a new sprite with base + overlays composited
            merged_sprite = base_sprite.copy()

            # Composite right variant if it exists
            if 'r' in variant_sprites_dict and i < len(variant_sprites_dict['r']):
                r_sprite = variant_sprites_dict['r'][i]
                merged_sprite = Image.alpha_composite(merged_sprite.convert('RGBA'), r_sprite.convert('RGBA'))

            # Composite left variant if it exists
            if 'l' in variant_sprites_dict and i < len(variant_sprites_dict['l']):
                l_sprite = variant_sprites_dict['l'][i]
                merged_sprite = Image.alpha_composite(merged_sprite, l_sprite.convert('RGBA'))

            merged_sprites.append(merged_sprite)

        # Return the same number of directions as the base
        return merged_sprites, dirs

    def rebuild_dmi(self, states_images, metadata):
        """Rebuild DMI sprite sheet from state images"""
        width = metadata['width']
        height = metadata['height']

        # Calculate total sprites needed
        total_sprites = sum(len(sprites) for sprites in states_images.values())

        # Calculate sheet dimensions (try to make it squarish)
        sprites_per_row = 32  # Reasonable default
        rows_needed = (total_sprites + sprites_per_row - 1) // sprites_per_row

        sheet_width = sprites_per_row * width
        sheet_height = rows_needed * height

        # Create new sprite sheet
        new_sheet = Image.new('RGBA', (sheet_width, sheet_height), (0, 0, 0, 0))

        current_index = 0
        for state in metadata['states']:
            if state['name'] not in states_images:
                continue

            sprites = states_images[state['name']]

            for sprite in sprites:
                row = current_index // sprites_per_row
                col = current_index % sprites_per_row

                x = col * width
                y = row * height

                new_sheet.paste(sprite, (x, y))
                current_index += 1

        return new_sheet

    def process_dmi_file(self, dmi_path, dry_run=False):
        """Process a single DMI file and merge variant states"""
        try:
            print(f"\nProcessing: {dmi_path.name}")

            # Load DMI file
            img = Image.open(dmi_path)
            metadata = self.parse_dmi_metadata(img)

            if not metadata:
                print(f"  ✗ Not a valid DMI file (no metadata found)")
                self.stats['errors'] += 1
                return False

            print(f"  Found {len(metadata['states'])} states")

            # Extract all state images
            states_images = self.extract_state_images(img, metadata)

            # Find states that need merging
            base_states = self.find_state_variants(states_images)

            if not base_states:
                print(f"  No variant states found to merge")
                return True

            print(f"  Found {len(base_states)} states with variants:")

            # Merge states
            new_states_images = {}
            new_metadata_states = []
            states_to_remove = set()

            for state in metadata['states']:
                state_name = state['name']

                # Skip variant states (they'll be merged)
                if state_name.startswith('r_') or state_name.startswith('l_'):
                    states_to_remove.add(state_name)
                    continue

                # Check if this state has variants to merge
                if state_name in base_states:
                    variants = base_states[state_name]
                    print(f"    - {state_name}: merging {', '.join(variants.keys())}")

                    # Get variant sprites
                    variant_sprites = {
                        k: states_images[v] for k, v in variants.items()
                    }

                    # Merge directions
                    merged_sprites, new_dirs = self.merge_state_directions(
                        state_name,
                        states_images[state_name],
                        variant_sprites,
                        metadata['states']
                    )

                    new_states_images[state_name] = merged_sprites

                    # Update state metadata
                    new_state = state.copy()
                    new_state['dirs'] = new_dirs
                    new_metadata_states.append(new_state)

                    self.stats['states_merged'] += 1
                    for v in variants.values():
                        states_to_remove.add(v)
                else:
                    # Keep state as-is
                    new_states_images[state_name] = states_images[state_name]
                    new_metadata_states.append(state)

            if dry_run:
                print(f"  [DRY RUN] Would merge {len(base_states)} states and remove {len(states_to_remove)} variants")
                return True

            # Build new metadata
            new_metadata = metadata.copy()
            new_metadata['states'] = new_metadata_states

            # Rebuild sprite sheet
            new_sheet = self.rebuild_dmi(new_states_images, new_metadata)

            # Build metadata string
            metadata_str = self.build_dmi_metadata(new_metadata)

            # Save with metadata
            pnginfo = PngImagePlugin.PngInfo()
            pnginfo.add_text('Description', metadata_str)

            # Backup original
            backup_path = dmi_path.parent / f"{dmi_path.stem}.dmi.backup"
            if not backup_path.exists():
                # Copy the original file as-is
                import shutil
                shutil.copy2(dmi_path, backup_path)
                print(f"  Backup saved: {backup_path.name}")

            # Save new DMI (DMI files are just PNGs with metadata)
            new_sheet.save(dmi_path, format='PNG', pnginfo=pnginfo)

            print(f"  ✓ Merged {len(base_states)} states, removed {len(states_to_remove)} variant states")
            self.stats['states_removed'] += len(states_to_remove)
            self.stats['files_processed'] += 1

            return True

        except Exception as e:
            print(f"  ✗ Error: {e}")
            self.stats['errors'] += 1
            import traceback
            traceback.print_exc()
            return False

    def process_directory(self, directory, recursive=False, dry_run=False):
        """Process all DMI files in a directory"""
        directory = Path(directory)

        if not directory.exists():
            print(f"Directory not found: {directory}")
            return

        # Find all DMI files
        if recursive:
            dmi_files = list(directory.rglob('*.dmi'))
        else:
            dmi_files = list(directory.glob('*.dmi'))

        print(f"Found {len(dmi_files)} DMI files")

        for dmi_file in dmi_files:
            self.process_dmi_file(dmi_file, dry_run)

        self.print_stats()

    def print_stats(self):
        """Print processing statistics"""
        print("\n" + "="*60)
        print("Processing Complete")
        print("="*60)
        print(f"DMI Files Processed: {self.stats['files_processed']}")
        print(f"States Merged: {self.stats['states_merged']}")
        print(f"Variant States Removed: {self.stats['states_removed']}")
        print(f"Errors: {self.stats['errors']}")
        print("="*60)

def main():
    print("="*60)
    print("DMI Sprite Desleeving Tool")
    print("="*60)
    print()

    desleever = DMIDesleever()

    if len(sys.argv) < 2:
        print("Usage:")
        print("  Single file: desleeve.py <file.dmi>")
        print("  Directory:   desleeve.py <directory> [options]")
        print("\nOptions:")
        print("  --recursive, -r    Process subdirectories")
        print("  --dry-run          Show what would be changed without modifying files")
        print("\nDrag and drop a DMI file or folder onto this script to run.")
        print("\nNote: Original files are backed up as .dmi.backup")
        input("\nPress Enter to exit...")
        return

    target = sys.argv[1]
    recursive = '--recursive' in sys.argv or '-r' in sys.argv
    dry_run = '--dry-run' in sys.argv

    print(f"Target: {target}")
    print(f"Recursive: {recursive}")
    print(f"Dry run: {dry_run}")
    print()

    target_path = Path(target)

    if not target_path.exists():
        print(f"ERROR: Path does not exist: {target_path}")
        input("\nPress Enter to exit...")
        return

    if dry_run:
        print("*** DRY RUN MODE - No files will be modified ***\n")

    try:
        if target_path.is_file():
            if target_path.suffix.lower() == '.dmi':
                print("Processing single DMI file...\n")
                success = desleever.process_dmi_file(target_path, dry_run)
                desleever.print_stats()
                if not success:
                    print("\nProcessing failed - check errors above")
            else:
                print(f"ERROR: {target} is not a DMI file (extension: {target_path.suffix})")
        elif target_path.is_dir():
            print(f"Processing directory: {target_path}")
            if recursive:
                print("(Recursive mode enabled)")
            print()
            desleever.process_directory(target_path, recursive, dry_run)
        else:
            print(f"ERROR: {target} is not a valid file or directory")
    except Exception as e:
        print(f"\nFATAL ERROR: {e}")
        import traceback
        traceback.print_exc()

    print("\n")
    input("Press Enter to exit...")

if __name__ == "__main__":
    main()
