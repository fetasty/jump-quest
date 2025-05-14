extends Control

signal guide_confirmed

var _guide_player_jump_speed: float = -170.0
var _guide_player_gravity: float = 900.0
var _guide_player_jump_y: float = 150.5

var _guide_player_velocity: float = 0.0
var _guide_player_jump_time: float = 0.0

@onready var guide_player: TextureRect = $Guide1/GuidePlayer
@onready var guide_button: CheckButton = $GuideButton
@onready var guide_1_title: Label = $Guide1/Guide1Title
@onready var guide_1_button: Label = $Guide1/NinePatchRect/Guide1Button


## Should show guide after launch game
var show_guide: bool = true:
	set(value):
		if show_guide != value:
			show_guide = value
			GameEvent.data_changed.emit(Const.SHOW_GUIDE, value)
	get:
		return show_guide


func _ready() -> void:
	# TODO
	match OS.get_name():
		"Android", "iOS":
			guide_1_title.text = tr("1. 点击屏幕跳跃")
			guide_1_button.text = tr("Touch")
		_:
			pass
	_guide_player_jump_y = guide_player.position.y
	show_guide = SaveLoadManager.get_value(Const.SHOW_GUIDE, true)
	guide_button.button_pressed = show_guide
	visible = show_guide


func _process(delta: float) -> void:
	if _guide_player_jump_time > 0:
		_guide_player_jump_time -= delta
		_guide_player_velocity = _guide_player_jump_speed
	else:
		_guide_player_velocity += delta * _guide_player_gravity
	guide_player.position.y += _guide_player_velocity * delta
	if guide_player.position.y > _guide_player_jump_y:
		_guide_player_jump_time = 0.2


func _on_button_pressed() -> void:
	self.visible = false
	guide_confirmed.emit()


func _on_guide_button_toggled(toggled_on: bool) -> void:
	show_guide = toggled_on
