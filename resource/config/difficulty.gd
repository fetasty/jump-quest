class_name Difficulty
extends Resource

enum {
	EASY,
	NORMAL,
	HARD,
}

## Difficulty id [EASY, NORMAL, HARD]
@export var id: int

## The basic config of current difficulty.
@export var basic_config: Config

## The dynamic config of current difficulty.
@export var dynamic_config: DynamicConfig
