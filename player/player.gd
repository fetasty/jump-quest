extends Node2D
class_name Player


signal game_failed(fail_type: int)

## Failure type
enum {
	COLLIDED_TOP_WALL,
	COLLIDED_BOTTOM_WALL,
	COLLIDED_IRON,
	COLLIDED_WOOD,
}

const BUFF_ITEM = preload("res://player/buff_item.tscn")

const ROTATE_ANGLE = 15 # degree

var role_res: Role

## temporary state
var velocity: float = 0
var jumping: bool = false
var is_alive: bool = true

@onready var jump_timer: Timer = %JumpTimer
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var player_area_2d: Area2D = %PlayerArea2D
@onready var item_area_2d: Area2D = %ItemArea2D
@onready var buff_items: Node2D = %BuffItems


func _ready() -> void:
	add_to_group(Const.GROUP_PLAYER)
	position = GameState.design_size * 0.5
	load_data()
	GameEvent.data_changed.connect(on_data_changed)
	player_area_2d.set_meta(Const.PLAYER, self)
	item_area_2d.set_meta(Const.PLAYER, self)


func _process(delta: float) -> void:
	# Update buff status
	GameState.buff_status_process(delta)


func _physics_process(delta: float) -> void:
	if jumping:
		velocity = GameState.current_config.player_jump_speed
	else:
		velocity += GameState.current_config.player_gravity * delta
	if velocity > 0.0:
		sprite_2d.rotation_degrees = ROTATE_ANGLE
	else:
		sprite_2d.rotation_degrees = -ROTATE_ANGLE
	position.y += velocity * delta
	if is_alive:
		if position.y > GameState.bottom_wall_pos:
			is_alive = false
			game_failed.emit.call_deferred(COLLIDED_BOTTOM_WALL)
		elif position.y < GameState.top_wall_pos:
			is_alive = false
			game_failed.emit.call_deferred(COLLIDED_TOP_WALL)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jumping = true
		jump_timer.start(GameState.current_config.max_player_jump_time)
		get_viewport().set_input_as_handled()
		AudioManager.play_sound(role_res.jump_audio_path)
	elif event.is_action_released("jump"):
		jumping = false
		jump_timer.stop()
		get_viewport().set_input_as_handled()


func load_data() -> void:
	role_res = GameState.role_resource
	sprite_2d.texture = role_res.texture
	sprite_2d.scale = Vector2.ONE * role_res.scale


func barrier_collided(barrier_type: int) -> void:
	AudioManager.play_sound(Const.HIT_SOUND)
	game_failed.emit.call_deferred(COLLIDED_IRON if barrier_type == Barrier.TYPE_IRON else COLLIDED_WOOD)


func _on_jump_timer_timeout() -> void:
	jumping = false


func on_data_changed(key: StringName, value: Variant) -> void:
	match key:
		Const.REALTIME_CONFIG:
			load_data()
		Const.ADD_BUFF:
			var item = BUFF_ITEM.instantiate()
			item.init(value["id"])
			buff_items.add_child(item)
		_: pass
