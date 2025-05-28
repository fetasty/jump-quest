extends Control

const BUFF_ITEM = preload("res://game/buff_item.tscn")

@onready var score: Label = %Score
@onready var buff_list: HBoxContainer = %BuffList
@onready var difficulty_label: Label = %Difficulty
@onready var role_texture: TextureRect = %RoleRect
@onready var round_time_label: Label = %RoundTime

func _ready() -> void:
	load_data()
	GameEvent.data_changed.connect(on_data_changed)


func load_data() -> void:
	score.text = str(GameState.score)
	init_buff_ui()
	difficulty_label.text = GameState.difficulty_str
	var role = ResourceManager.get_role(GameState.role)
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


func on_data_changed(key: StringName, value: Variant) -> void:
	match key:
		Const.SCORE:
			score.text = "%s" % value
		Const.DIFFICULTY:
			difficulty_label.text = GameState.difficulty_str
		Const.ROLE:
			role_texture.texture = ResourceManager.get_role(value).texture
		Const.ROUND_TIME:
			round_time_label.text = GameState.round_time_str
		_:
			pass
