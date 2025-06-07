extends Node2D


signal destroyed

var shape_width: float
var shape_height: float
var barrier_type: int

@onready var area_2d: Area2D = %Area2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

func init(width: float, height: float, type: int) -> void:
	shape_width = width
	shape_height = height
	barrier_type = type


func _ready() -> void:
	var shape: RectangleShape2D = collision_shape_2d.shape
	shape.size = Vector2(shape_width, shape_height)
	area_2d.set_meta("barrier_type", barrier_type)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.has_meta(Const.PLAYER):
		if (
			barrier_type == Barrier.TYPE_GRASS
			or GameState.exist_buff(Buff.BUFF_SHIELD)
			or (barrier_type == Barrier.TYPE_WOOD and GameState.exist_buff(Buff.BUFF_SAW))
		):
			destroyed.emit()
		else:
			var player: Player = area.get_meta(Const.PLAYER)
			player.barrier_collided(barrier_type)
