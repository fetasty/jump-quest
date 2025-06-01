extends Node2D

enum {
	TYPE_IRON,
	TYPE_WOOD,
	TYPE_GRASS,
}

const ALL_BODY_RES: Array[Texture2D] = [
	preload("res://art/iron_barrier_body.tres"),
	preload("res://art/wood_barrier_body.tres"),
	preload("res://art/grass_barrier_body.tres"),
]

const ALL_HEAD_RES: Array[Texture2D] = [
	preload("res://art/iron_barrier_head.tres"),
	preload("res://art/wood_barrier_head.tres"),
	preload("res://art/grass_barrier_head.tres"),
]

var type: int
var upper_size: int
var channel_height: float

var body_size: Vector2
var head_size: Vector2
var body_height: float
var head_height: float
var upper_height: float

var body_res: Texture2D:
	get: return ALL_BODY_RES[type]

var head_res: Texture2D:
	get: return ALL_HEAD_RES[type]


@onready var upper_part: Node2D = %UpperPart
@onready var lower_part: Node2D = %LowerPart
@onready var items: Node2D = %Items


func _ready() -> void:
	var all_type_rate = GameState.current_config.barrier_type_rate.reduce(func(acc, v): return acc + v, 0.0)
	var type_rand = randf_range(0.0, all_type_rate)
	type = TYPE_IRON
	for i in range(GameState.current_config.barrier_type_rate.size()):
		if type_rand <= GameState.current_config.barrier_type_rate[i]:
			type = i
			break
		type_rand -= GameState.current_config.barrier_type_rate[i]
	body_size = body_res.get_size()
	head_size = head_res.get_size()
	body_height = body_size.y
	head_height = head_size.y
	var upper_size_rate = randf_range(GameState.current_config.barrier_upper_size_min, GameState.current_config.barrier_upper_size_max)
	var avaliable_height = upper_size_rate * GameState.design_size.y
	upper_size = 0
	upper_height = 0
	if avaliable_height >= head_height:
		upper_size += 1
		avaliable_height -= head_height
		upper_height += head_height
	upper_size += int(avaliable_height / body_height)
	upper_height += (upper_size - 1) * body_height
	channel_height = GameState.current_config.barrier_channel_height
	position = Vector2(GameState.design_size.x + head_size.x, 0.0)
	build_barrier()
	generate_item()


func _physics_process(delta: float) -> void:
	position.x -= GameState.current_config.barrier_speed * delta


func build_barrier() -> void:
	var height = GameState.design_size.y
	var lower_height = height - channel_height - upper_height
	var lower_size = 0
	if lower_height >= head_height:
		lower_size += 1
		lower_height -= head_height
	lower_size += int(lower_height / body_height)
	build_part(true, upper_size)
	build_part(false, lower_size)
	build_collision(upper_size, lower_size)


func build_part(upper: bool, part_size: int) -> void:
	var height = GameState.design_size.y
	var start_height = body_height * 0.5
	var parent = upper_part
	for i in range(0, part_size - 1):
		var body = Sprite2D.new()
		body.name = "Body%d" % i
		body.texture = body_res
		var body_y = start_height + body_height * i
		if not upper: body_y = height - body_y
		body.position = Vector2(0.0, body_y)
		parent.add_child(body)
	if part_size > 0:
		var head = Sprite2D.new()
		head.name = "Head"
		head.texture = head_res
		var head_y = body_height * (part_size - 1) + head_height * 0.5
		if not upper: head_y = height - head_y
		head.position = Vector2(0.0, head_y)
		parent.add_child(head)


func build_collision(upper_size: int, lower_size: int) -> void:
	pass


func generate_item() -> void:
	var is_generate: bool = false
	if randf() <= GameState.current_config.item_generation_rate[type]:
		is_generate = true
	if not is_generate: return
	var total_rate = GameState.current_config.item_type_rate.reduce(func(acc, v): return acc + v, 0.0)
	var rand = randf_range(0.0, total_rate)
	var item_type = -1
	for i in range(GameState.current_config.item_type_rate.size()):
		if rand <= GameState.current_config.item_type_rate[i]:
			item_type = i
			break
		rand -= GameState.current_config.item_type_rate[i]
	# TODO generate item with type [item_type]
