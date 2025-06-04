class_name Player extends Node2D


signal game_failed(fail_type: int)

## Failure type
enum {
	COLLIDED_TOP_WALL,
	COLLIDED_BOTTOM_WALL,
	COLLIDED_IRON,
	COLLIDED_WOOD,
}

var role_res: Role

## temporary state
var velocity: float = 0
var jumping: bool = false
var is_alive: bool = true

@onready var jump_timer: Timer = %JumpTimer
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var player_area_2d: Area2D = %PlayerArea2D
@onready var item_area_2d: Area2D = %ItemArea2D


func _ready() -> void:
	load_data()
	GameEvent.data_changed.connect(on_data_changed)


func _physics_process(delta: float) -> void:
	if jumping:
		velocity = GameState.current_config.player_jump_speed
	else:
		velocity += GameState.current_config.player_gravity * delta
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
	elif event.is_action_released("jump"):
		jumping = false
		jump_timer.stop()
		get_viewport().set_input_as_handled()


func load_data() -> void:
	role_res = GameState.role_resource
	sprite_2d.texture = role_res.texture
	sprite_2d.scale = Vector2.ONE * role_res.scale


func _on_jump_timer_timeout() -> void:
	jumping = false


func on_data_changed(key: StringName, _value: Variant) -> void:
	match key:
		Const.REALTIME_CONFIG:
			load_data()
		_: pass


func _on_player_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_item_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
