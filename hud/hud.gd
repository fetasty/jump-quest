extends Control

const BUFF_ITEM = preload("res://hud/buff_item.tscn")

@onready var score: Label = %Score
@onready var buff_list: HBoxContainer = %BuffList
@onready var difficulty_label: Label = %Difficulty
@onready var role_texture: TextureRect = %RoleRect
@onready var round_time_label: Label = %RoundTime

func _ready() -> void:
	load_data()
	GameEvent.data_changed.connect(on_data_changed)
	GameEvent.game_started.connect(on_game_started)


func load_data() -> void:
	score.text = str(GameState.score)
	init_buff_ui()
	reset_buff_ui()
	difficulty_label.text = GameState.difficulty_str
	var role = GameState.role_resource
	role_texture.texture = role.texture
	role_texture.size = role.texture.get_size() * role.scale
	role_texture.get_parent().custom_minimum_size = role_texture.size
	round_time_label.text = GameState.round_time_str


func init_buff_ui() -> void:
	for child in buff_list.get_children():
		child.queue_free()
	for i in range(0, Buff.BUFF_COUNT):
		var buff_item = BUFF_ITEM.instantiate()
		var buff_res = ResourceManager.get_buff(i)
		buff_item.name = "Buff%d" % i
		buff_item.buff_res = buff_res
		buff_list.add_child(buff_item)


func reset_buff_ui() -> void:
	for child in buff_list.get_children():
		child.visible  = false


func on_data_changed(key: StringName, value: Variant) -> void:
	match key:
		Const.SCORE:
			score.text = "%s" % value
		Const.DIFFICULTY:
			difficulty_label.text = GameState.difficulty_str
		Const.ROLE:
			role_texture.texture = GameState.role_resource.texture
		Const.ROUND_TIME:
			round_time_label.text = GameState.round_time_str
		Const.GAME_STATE:
			on_game_state_changed(value)
		_:
			pass


func on_game_state_changed(state: int) -> void:
	match state:
		GameState.GAME_STATE_WELCOME, GameState.GAME_STATE_COUNTING_DOWN:
			visible = false
		_:
			visible = true


func on_game_started() -> void:
	reset_buff_ui()
