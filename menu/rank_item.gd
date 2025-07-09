extends Control


var score: int = 99:
	get:
		return score
	set(value):
		if score != value:
			score = value
			update_score()

var record_time: String = "2025-06-21 16:45:30":
	get:
		return record_time
	set(value):
		if record_time != value:
			record_time = value
			update_record_time()

var role: int = Role.DOG:
	get:
		return role
	set(value):
		if role != value:
			role = value
			update_role()

var difficulty: int = Difficulty.NORMAL:
	get:
		return difficulty
	set(value):
		if difficulty != value:
			difficulty = value
			update_difficulty()

var round_time: int = 9999:
	get:
		return round_time
	set(value):
		if round_time != value:
			round_time = value
			update_round_time()

var rank: int = 1:
	get:
		return rank
	set(value):
		if rank != value:
			rank = value
			update_rank()


@onready var rank_label = %RankLabel
@onready var score_label = %ScoreLabel
@onready var round_time_label = %RoundTimeLabel
@onready var role_container = %Role
@onready var role_texture = %RoleTexture
@onready var difficulty_label = %DifficultyLabel
@onready var record_time_label = %RecordTimeLabel
@onready var margin_container: MarginContainer = %MarginContainer


func _ready() -> void:
	update_rank()
	update_score()
	update_round_time()
	update_role()
	update_difficulty()
	update_record_time()


func update_rank_data(rank_data: Dictionary) -> void:
	score = rank_data["score"]
	record_time = rank_data["record_datetime"]
	role = rank_data["role"]
	difficulty = rank_data["difficulty"]
	round_time = rank_data["round_time"]


func update_rank() -> void:
	if rank_label:
		rank_label.text = str(rank)


func update_score() -> void:
	if score_label:
		score_label.text = str(score)


func update_round_time() -> void:
	if round_time_label:
		round_time_label.text = Tools.time_interval_to_string(round_time)

func update_role() -> void:
	if role_texture:
		var res = ResourceManager.get_role(role)
		role_texture.texture = res.texture
		role_texture.size = res.texture.get_size()
		role_texture.pivot_offset = role_texture.size * 0.5
		role_texture.scale = Vector2.ONE * res.scale
		role_container.size = role_texture.size * role_texture.scale
		#role_texture.position = role_container.size * 0.5


func update_difficulty() -> void:
	if difficulty_label:
		difficulty_label.text = Tools.difficulty_to_str(difficulty)


func update_record_time() -> void:
	if record_time_label:
		record_time_label.text = record_time
