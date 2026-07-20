'''
Usage:
    $ python ss13_genchangelog.py html/changelogs/

ss13_genchangelog.py - Generate changelog from YAML.

Copyright 2013 Rob "N3X15" Nelson <nexis@7chan.org>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
'''

from __future__ import print_function
import yaml, os, glob, sys, re, time, argparse
from datetime import datetime, date, timedelta
from time import time

today = date.today()

fileDateFormat = "%Y-%m"

opt = argparse.ArgumentParser()
opt.add_argument('ymlDir', help='The directory of YAML changelogs we will use.')

args = opt.parse_args()
archiveDir = os.path.join(args.ymlDir, 'archive')

all_changelog_entries = {}

# Do not change the order, add to the bottom of the array if necessary
validPrefixes = [
    'bugfix',
    'wip',
    'qol',
    'soundadd',
    'sounddel',
    'rscadd',
    'rscdel',
    'imageadd',
    'imagedel',
    'spellcheck',
    'experiment',
    'balance',
    'code_imp',
    'refactor',
    'config',
    'admin',
    'server',
    'sound',
    'image',
    'map',
]

def dictToTuples(inp):
    return [(k, v) for k, v in inp.items()]

print('Reading changelogs...')
for fileName in glob.glob(os.path.join(args.ymlDir, "*.yml")):
    name, ext = os.path.splitext(os.path.basename(fileName))
    if name.startswith('.'): continue
    if name == 'example': continue
    fileName = os.path.abspath(fileName)
    formattedDate = today.strftime(fileDateFormat)
    monthFile = os.path.join(archiveDir, formattedDate + '.yml')
    print(' Reading {}...'.format(fileName))
    cl = {}
    with open(fileName, 'r',encoding='utf-8') as f:
        cl = yaml.load(f, Loader=yaml.SafeLoader)
    currentEntries = {}
    if os.path.exists(monthFile):
        with open(monthFile,'r',encoding='utf-8') as f:
            currentEntries = yaml.load(f, Loader=yaml.SafeLoader)
    if today not in currentEntries:
        currentEntries[today] = {}
    author_entries = currentEntries[today].get(cl['author'], [])
    if len(cl['changes']):
        new = 0
        for change in cl['changes']:
            if change not in author_entries:
                (change_type, _) = dictToTuples(change)[0]
                if change_type not in validPrefixes:
                    print('  {0}: Invalid prefix {1}'.format(fileName, change_type), file=sys.stderr)
                    sys.exit(1)
                author_entries += [change]
                new += 1
        currentEntries[today][cl['author']] = author_entries
        if new > 0:
            print('  Added {0} new changelog entries.'.format(new))

    if cl.get('delete-after', False):
        if os.path.isfile(fileName):
            print('  Deleting {0} (delete-after set)...'.format(fileName))
            os.remove(fileName)

    with open(monthFile, 'w', encoding='utf-8') as f:
        yaml.dump(currentEntries, f, default_flow_style=False)
