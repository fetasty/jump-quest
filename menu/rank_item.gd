extends Control


var score: int:
	get:
		return score
	set(value):
		if score != value:
			score = value

var record_time: String:
	get:
		return record_time
	set(value):
		if record_time != value:
			record_time = value

var role: int:
	get:
		return role
	set(value):
		if role != value:
			role = value

var difficulty: int:
	get:
		return difficulty
	set(value):
		if difficulty != value:
			difficulty = value

var round_time: int:
	get:
		return round_time
	set(value):
		if round_time != value:
			round_time = value


@onready var rank_label = %RankLabel
@onready var score_label = %ScoreLabel
@onready var round_time_label = %RoundTimeLabel
@onready var role_container = %Role
@onready var role_texture = %RoleTexture
@onready var difficulty_label = %DifficultyLabel
@onready var record_time_label = %RecordTimeLabel


func _ready() -> void:
	pass


func update_rank_data(rank_data: Dictionary) -> void:
	score = rank_data["score"]
	record_time = rank_data["record_time"]
	role = rank_data["role"]
	difficulty = rank_data["difficulty"]
	round_time = rank_data["round_time"]
