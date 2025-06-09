extends Control

# TODO scroll view

const RANK_ITEM: PackedScene = preload("res://menu/rank_item.tscn")

@onready var rank_item_container: Container = %RankItems


func _ready() -> void:
	visibility_changed.connect(on_visible_changed)


func update_rank_data() -> void:
	var sorted_records = GameState.records
	# [{
	# 	"score": int,
	# 	"round_time": int, # ms
	# 	"difficulty": int, # Difficulty.EASY, Difficulty.NORMAL, Difficulty.HARD
	# 	"role": int, # Role.CHICK, Role.DOG, Role.PIG
	# 	"record_datetime": String, # e.g. "2021-05-01 12:00:00"
	# }]
	var child_count = rank_item_container.get_child_count()
	if child_count > sorted_records.size():
		for i in range(child_count - sorted_records.size()):
			rank_item_container.get_child(child_count - 1 - i).queue_free()
	elif child_count < sorted_records.size():
		for i in range(sorted_records.size() - child_count):
			rank_item_container.add_child(RANK_ITEM.instance())
	for i in range(sorted_records.size()):
		var rank_item = rank_item_container.get_child(i)
		rank_item.update_rank_data(sorted_records[i])


func on_visible_changed() -> void:
	if is_visible_in_tree():
		update_rank_data()
