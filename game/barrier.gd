extends Node2D

signal score_pos_reached
signal exited_viewport(barrier: Node2D)

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

const COLLIDER: PackedScene = preload("res://game/barrier_collider.tscn")
const ITEM: PackedScene = preload("res://game/item.tscn")

var type: int
var upper_size: int
var channel_height: float

var body_size: Vector2
var head_size: Vector2
var body_height: float
var head_height: float
var upper_height: float

var is_score_calculated: bool

var body_res: Texture2D:
	get: return ALL_BODY_RES[type]

var head_res: Texture2D:
	get: return ALL_HEAD_RES[type]


@onready var upper_part: Node2D = %UpperPart
@onready var lower_part: Node2D = %LowerPart
@onready var items: Node2D = %Items


func _ready() -> void:
	reset()


func _process(_delata: float) -> void:
	if not is_score_calculated and position.x <= GameState.score_pos:
		is_score_calculated = true
		score_pos_reached.emit()
	if position.x < -head_size.x * 2:
		exited_viewport.emit(self)


func _physics_process(delta: float) -> void:
	position.x -= GameState.current_config.barrier_speed * delta


func reset() -> void:
	# reset position
	position = Vector2(GameState.design_size.x + head_size.x, 0.0)
	# clear barrier parts and collisions
	# TODO reuse existing barrier parts
	for child in upper_part.get_children():
		child.queue_free()
		upper_part.remove_child(child)
	for child in lower_part.get_children():
		child.queue_free()
		lower_part.remove_child(child)
	for child in items.get_children():
		child.queue_free()
		items.remove_child(child)
	# reset flags
	is_score_calculated = false
	# rebuild barrier
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
	build_barrier()
	generate_item()


func build_barrier() -> void:
	var height = GameState.design_size.y
	var lower_height = height - channel_height - upper_height
	var lower_size = 0
	if lower_height >= head_height:
		lower_size += 1
		lower_height -= head_height
	lower_size += int(lower_height / body_height)
	build_part(true, upper_size)
	build_collider(true, upper_size)
	build_part(false, lower_size)
	build_collider(false, lower_size)


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


func build_collider(upper: bool, part_size: int) -> void:
	var height = GameState.design_size.y
	if part_size > 0:
		# Head collider
		var head_collider = COLLIDER.instantiate()
		head_collider.set_meta(Const.BARRIER_TYPE, type)
		head_collider.name = "HeadCollider"
		head_collider.init(head_size.x, head_size.y, type)
		head_collider.position = Vector2(0.0, body_height * (part_size - 1) + head_height * 0.5)
		if upper:
			upper_part.add_child(head_collider)
		else:
			head_collider.position.y = height - head_collider.position.y
			lower_part.add_child(head_collider)
	if part_size > 1:
		# Body collider
		var body_collider = COLLIDER.instantiate()
		body_collider.set_meta(Const.BARRIER_TYPE, type)
		body_collider.name = "BodyCollider"
		var total_body_height = body_height * (part_size - 1)
		body_collider.init(body_size.x, total_body_height, type)
		body_collider.position = Vector2(0.0, total_body_height * 0.5)
		if upper:
			upper_part.add_child(body_collider)
		else:
			body_collider.position.y = height - body_collider.position.y
			lower_part.add_child(body_collider)


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
	# TODO generate item with type [item_type], test
	var item = ITEM.instantiate()
	item.buff_id = item_type
	item.position = Vector2(0.0, GameState.design_size.y * randf_range(0.4, 0.6))
	items.add_child(item)
