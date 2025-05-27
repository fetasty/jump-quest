extends Control

const BUFF_ITEM = preload("res://game/buff_item.tscn")

@onready var score: Label = %Score
@onready var buff_list: HBoxContainer = %BuffList

# TODO difficulty show, role show, live time show

func _ready() -> void:
	# TODO just test
	var buff_map = ResourceManager.get_buff_map()
	for buff_id in buff_map:
		var buff = BUFF_ITEM.instantiate()
		buff.name = "Buff%s" % buff_id
		buff.buff_res = buff_map[buff_id]
		buff_list.add_child(buff)
