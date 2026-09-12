# Relic System Guide

## How a relic functions?
Basically a relic component is added onto an item with an input and output system (akin to humors but for general world changes).
The reason for this is that relics can be any type of atom in the game and creating children of each type with duplicated logic is impossible to maintain.
This solves it by centralizing the way a relic handles its inputs and outputs so that code changes are only made in a single place.

## How do I make a relic?
Use the helper proc make_relic(datum/relic_trigger, datum/relic_effect, datum/relic_information), this will generate a relic with those effect. Lore is assumed to be on the item itself
with a generic relic_information datum used as a way to add variance to it.

## Why is there no examples
This is just the base system those will be added at some point in the future.


