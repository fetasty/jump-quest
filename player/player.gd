class_name Player extends Node2D


signal collided

var role_res: Role

## temporary state
var velocity: float = 0
var jumping: bool = false
var is_collided: bool = false

@onready var jump_timer: Timer = %JumpTimer
@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	load_data()
	GameEvent.data_changed.connect(on_data_changed)


func _physics_process(delta: float) -> void:
	if jumping:
		velocity = GameState.current_config.player_jump_speed
	else:
		velocity += GameState.current_config.player_gravity * delta
	position.y += velocity * delta
	if position.y < GameState.bottom_wall_pos or position.y > GameState.top_wall_pos:
		if not is_collided:
			is_collided = true
			collided.emit.call_deferred()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jumping = true
		jump_timer.start(GameState.current_config.max_player_jump_time)
	elif event.is_action_released("jump"):
		jumping = false
		jump_timer.stop()


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
