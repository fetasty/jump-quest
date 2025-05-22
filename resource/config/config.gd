class_name Config
extends Resource

## Barrier moving speed (px/s)
@export var barrier_speed: float

## Barrier generation interval (s)
@export var barrier_spawn_interval: float

## Barrier upper size min
@export var barrier_upper_size_min: int

## Barrier upper size max
@export var barrier_upper_size_max: int

## Player jump speed
@export var player_jump_speed: float

## Maximum player jump time
@export var max_player_jump_time: float

## Player gravity
@export var player_gravity: float

## Item generation rate [iron, wood, grass]
@export var item_generation_rate: Array[float]

## Item type rate [double, saw, shield]
@export var item_type_rate: Array[float]


## Change current config with another [Config] as offset value.
func change(offset: Config) -> void:
	barrier_speed += offset.barrier_speed
	barrier_spawn_interval += offset.barrier_spawn_interval
	barrier_upper_size_min += offset.barrier_upper_size_min
	barrier_upper_size_max += offset.barrier_upper_size_max
	player_jump_speed += offset.player_jump_speed
	max_player_jump_time += offset.max_player_jump_time
	player_gravity += offset.player_gravity
	for i in range(0, item_generation_rate.size()):
		item_generation_rate[i] += offset.item_generation_rate[i]
	for i in range(0, item_type_rate.size()):
		item_type_rate[i] += offset.item_type_rate[i]
