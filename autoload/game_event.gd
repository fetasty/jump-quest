extends Node

## Manage all events related to cross-module communication

## Any game data have changed
@warning_ignore("unused_signal") signal data_changed(key: StringName, value: Variant)
