#!/usr/bin/env python3
"""
DMI Icon Halver
Takes DMI states whose names contain _FRONT or _ADJ and splits each sprite
horizontally into two new states:
  - <base>_right_<suffix>  (first 16 pixels / left half)
  - <base>_left_<suffix>   (last 16 pixels / right half)

Example:
  antenna_fuzzball1_FRONT_2  -->  antenna_fuzzball1_right_FRONT_2
								  antenna_fuzzball1_left_FRONT_2
"""

import sys
import re
import shutil
from pathlib import Path
from PIL import Image, PngImagePlugin


SPLIT_RE = re.compile(r'^(.*?)(_FRONT|_ADJ)(.*?)$')
HALF_WIDTH = 16          # pixels per half


def parse_dmi_metadata(img):
	if 'Description' not in img.info:
		return None
	description = img.info['Description']
	lines = description.strip().split('\n')
	if not lines or not lines[0].startswith('# BEGIN DMI'):
		return None

	metadata = {'version': '4.0', 'width': 32, 'height': 32, 'states': []}
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
			current_state = {'name': state_name, 'dirs': 1, 'frames': 1, 'delays': []}
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


def build_dmi_metadata(metadata):
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


def extract_state_images(img, metadata):
	"""Return dict of state_name -> [sprite, ...]"""
	w, h = metadata['width'], metadata['height']
	spr_per_row = img.width // w
	states_images = {}
	idx = 0
	for state in metadata['states']:
		total = state['dirs'] * state['frames']
		sprites = []
		for i in range(total):
			si = idx + i
			row, col = si // spr_per_row, si % spr_per_row
			sprite = img.crop((col * w, row * h, col * w + w, row * h + h))
			sprites.append(sprite)
		states_images[state['name']] = sprites
		idx += total
	return states_images


def rebuild_dmi(states_images, metadata, sprites_per_row=32):
	w, h = metadata['width'], metadata['height']
	total = sum(len(v) for v in states_images.values())
	rows = (total + sprites_per_row - 1) // sprites_per_row
	sheet = Image.new('RGBA', (sprites_per_row * w, rows * h), (0, 0, 0, 0))
	idx = 0
	for state in metadata['states']:
		name = state['name']
		if name not in states_images:
			continue
		for sprite in states_images[name]:
			row, col = idx // sprites_per_row, idx % sprites_per_row
			sheet.paste(sprite, (col * w, row * h))
			idx += 1
	return sheet


def split_name(name):
	"""
	Return (right_name, left_name) or None if the state name doesn't match.
	Inserts _right / _left before the _FRONT or _ADJ keyword.

	'antenna_fuzzball1_FRONT_2'
	  -> ('antenna_fuzzball1_right_FRONT_2', 'antenna_fuzzball1_left_FRONT_2')
	"""
	m = SPLIT_RE.match(name)
	if not m:
		return None
	base, keyword, suffix = m.group(1), m.group(2), m.group(3)
	return (f'{base}_right{keyword}{suffix}',
			f'{base}_left{keyword}{suffix}')


def halve_sprites(sprites, sprite_width):
	"""
	For every sprite split it into two full-size (sprite_width x height) canvases:
	  right_sprite: first HALF_WIDTH pixels placed on the left, rest transparent
	  left_sprite:  second HALF_WIDTH pixels placed on the right, rest transparent
	Returns (right_sprites, left_sprites).
	"""
	half = HALF_WIDTH
	right_sprites, left_sprites = [], []
	for spr in sprites:
		spr = spr.convert('RGBA')
		h = spr.height

		right_canvas = Image.new('RGBA', (sprite_width, h), (0, 0, 0, 0))
		right_canvas.paste(spr.crop((0, 0, half, h)), (0, 0))
		right_sprites.append(right_canvas)

		left_canvas = Image.new('RGBA', (sprite_width, h), (0, 0, 0, 0))
		left_canvas.paste(spr.crop((half, 0, sprite_width, h)), (half, 0))
		left_sprites.append(left_canvas)

	return right_sprites, left_sprites


def process_dmi(dmi_path: Path, dry_run=False):
	print(f'\nProcessing: {dmi_path.name}')

	img = Image.open(dmi_path)
	metadata = parse_dmi_metadata(img)
	if not metadata:
		print('  Not a valid DMI file (no metadata found)')
		return False

	sprite_width = metadata['width']
	if sprite_width < HALF_WIDTH * 2:
		print(f'  Sprite width ({sprite_width}px) is too narrow to split at {HALF_WIDTH}px')
		return False

	print(f'  Sprite size: {sprite_width}×{metadata["height"]}  |  States: {len(metadata["states"])}')

	states_images = extract_state_images(img, metadata)

	new_states_meta = []
	new_states_images = {}
	split_count = 0

	for state in metadata['states']:
		name = state['name']
		names = split_name(name)

		if names is None:
			new_states_meta.append(state)
			new_states_images[name] = states_images[name]
			continue

		right_name, left_name = names

		if dry_run:
			print(f'  [DRY RUN]  {name}  (kept)  +  {right_name}  +  {left_name}')
			split_count += 1
			continue

		print(f'  Splitting  {name}  (kept)  +  {right_name}  +  {left_name}')
		right_sprites, left_sprites = halve_sprites(states_images[name], sprite_width)

		state_base = {
			'dirs':   state['dirs'],
			'frames': state['frames'],
			'delays': state.get('delays', []),
		}

		new_states_meta.append(state)
		new_states_images[name] = states_images[name]

		new_states_meta.append({**state_base, 'name': right_name})
		new_states_images[right_name] = right_sprites

		new_states_meta.append({**state_base, 'name': left_name})
		new_states_images[left_name] = left_sprites

		split_count += 1

	if dry_run:
		print(f'  Would split {split_count} state(s).')
		return True

	if split_count == 0:
		print('  No matching states found (looking for _FRONT or _ADJ in state names).')
		return True

	new_metadata = {
		'version': metadata['version'],
		'width':   sprite_width,        # keep original dimensions (this only splits not offsets)
		'height':  metadata['height'],
		'states':  new_states_meta,
	}

	new_sheet = rebuild_dmi(new_states_images, new_metadata)

	meta_str = build_dmi_metadata(new_metadata)
	pnginfo = PngImagePlugin.PngInfo()
	pnginfo.add_text('Description', meta_str)

	backup = dmi_path.parent / f'{dmi_path.stem}.dmi.backup'
	if not backup.exists():
		shutil.copy2(dmi_path, backup)
		print(f'  Backup saved: {backup.name}')

	new_sheet.save(dmi_path, format='PNG', pnginfo=pnginfo)
	print(f'  ✓ Saved — kept {split_count} original state(s) and added _right / _left pairs')
	return True


def main():
	print('=' * 60)
	print('DMI Icon Halver')
	print('Splits _FRONT / _ADJ states into _right and _left halves')
	print('=' * 60)

	if len(sys.argv) < 2:
		print('\nUsage:')
		print('  Single file:  dmi_halver.py <file.dmi>')
		print('  Directory:    dmi_halver.py <directory> [--recursive]')
		print('\nOptions:')
		print('  --recursive, -r    Process subdirectories')
		print('  --dry-run          Preview changes without modifying files')
		input('\nPress Enter to exit...')
		return

	target    = Path(sys.argv[1])
	recursive = '--recursive' in sys.argv or '-r' in sys.argv
	dry_run   = '--dry-run'   in sys.argv

	if not target.exists():
		print(f'ERROR: Path does not exist: {target}')
		input('\nPress Enter to exit...')
		return

	if dry_run:
		print('\n*** DRY RUN MODE — no files will be modified ***\n')

	if target.is_file():
		if target.suffix.lower() == '.dmi':
			process_dmi(target, dry_run)
		else:
			print(f'ERROR: {target} is not a .dmi file')
	elif target.is_dir():
		pattern = '**/*.dmi' if recursive else '*.dmi'
		files = list(target.glob(pattern))
		print(f'Found {len(files)} DMI file(s)')
		for f in files:
			process_dmi(f, dry_run)
	else:
		print(f'ERROR: {target} is not a valid file or directory')

	print()
	input('Press Enter to exit...')


if __name__ == '__main__':
	main()
