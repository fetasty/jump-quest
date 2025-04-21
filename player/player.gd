class_name Player extends Node2D


var gravity: float
var jump_velocity: float
var max_jumping_time: float
var sprite_scale: float


## temporary state
var velocity: float = 0
var jumping: bool = false

@onready var jump_timer: Timer = %JumpTimer
@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	# TODO test
	gravity = 700
	jump_velocity = -150
	max_jumping_time = 0.5
	sprite_scale = 2.0
	sprite_2d.scale *= sprite_scale
	jump_timer.wait_time = max_jumping_time


func _physics_process(delta: float) -> void:
	if jumping:
		velocity = jump_velocity
	else:
		velocity += gravity * delta  
	position.y += velocity * delta


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jumping = true
		jump_timer.start()
	elif event.is_action_released("jump"):
		jumping = false
		jump_timer.stop()


func _on_jump_timer_timeout() -> void:
	jumping = false
