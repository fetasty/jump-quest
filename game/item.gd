class_name Item
extends Node2D

## init before add to scene tree
var buff_id: int

## on ready
var item_area: Area2D
var sprite_2d: Sprite2D


func _ready() -> void:
	# TODO init
	var buff_res: Buff = ResourceManager.get_buff(buff_id)
	sprite_2d.texture = buff_res.texture
	item_area.set_meta(Const.BUFF_ID, buff_id)


func _on_area_2d_area_entered(area_2d: Area2D) -> void:
	if area_2d.has_meta(Const.PLAYER_ID):
		queue_free()
