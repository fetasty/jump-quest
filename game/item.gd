class_name Item
extends Node2D

## init before add to scene tree
var buff_id: int


@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var item_area: Area2D = %Area2D


func _ready() -> void:
	var buff_res: Buff = ResourceManager.get_buff(buff_id)
	sprite_2d.texture = buff_res.texture
	item_area.set_meta(Const.BUFF_ID, buff_id)


func _on_area_2d_area_entered(area_2d: Area2D) -> void:
	if area_2d.has_meta(Const.PLAYER):
		var buff_res = ResourceManager.get_buff(buff_id)
		GameState.apply_buff(buff_id, buff_res.time)
		queue_free()
