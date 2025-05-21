class_name Difficulty extends Resource

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

## Level change interval (s)
@export var level_change_interval: Array[float]

## Level change value of barrier moving speed
@export var level_change_barrier_speed: Array[float]

## Level change value of barrier spawn interval
@export var level_change_barrier_spawn_interval: Array[float]

## Level change value of player jump speed
@export var level_change_player_jump_speed: Array[float]

## Level change value of player max jump time
@export var level_change_player_max_jump_time: Array[float]

## Level change value of player gravity
@export var level_change_player_gravity: Array[float]
