extends Node2D



@onready var area_2d: Area2D = %Area2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

var shape_width: float
var shape_height: float
var barrier_type: int


func init(width: float, height: float, type: int) -> void:
	shape_width = width
	shape_height = height
	barrier_type = type


func _ready() -> void:
	var shape: RectangleShape2D = collision_shape_2d.shape
	shape.size = Vector2(shape_width, shape_height)
	area_2d.set_meta("barrier_type", barrier_type)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.has_meta(Const.PLAYER_ID):
		queue_free()
