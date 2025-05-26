extends Node

const MODULE = &"resource_manager"
const ROLE_FOLDER = &"res://resource/role"
const DIFFICULTY_FOLDER = &"res://resource/config/difficulty"

var role_map: Dictionary = {}
var difficulty_map: Dictionary = {}

func _ready() -> void:
	Logger.info("resource_manager ready")
	load_roles()


func get_role(id: int) -> Role:
	if role_map.has(id):
		return role_map[id]
	else:
		Logger.error("Get role by id %s failed!" % id, MODULE)
		return null


func get_role_map() -> Dictionary:
	return role_map


func get_difficulty(id: int) -> Difficulty:
	if difficulty_map.has(id):
		return difficulty_map[id]
	else:
		Logger.error("Get difficulty by id %s failed!" % id, MODULE)
		return null


func visit_res_folder(path: String, f: Callable) -> void:
	var dir = DirAccess.open(path)
	var err = DirAccess.get_open_error()
	if err != OK:
		Logger.error("Open folder %s failed!" % path, MODULE, err)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"): # 只加载 .tres 文件
			var resource_path = path.path_join(file_name)
			f.call(resource_path)

		file_name = dir.get_next()


func load_one_role(res_path: String) -> void:
	var role_data: Role = load(res_path)
	if role_data and not role_data.id < 0:
		if role_map.has(role_data.id):
			Logger.error("Duplicate role id found: %s in file: %s" % [role_data.id, res_path], MODULE)
		else:
			role_map[role_data.id] = role_data
	else:
		Logger.error("Load role from file %s failed!" % res_path, MODULE)


func load_one_difficulty(res_path: String) -> void:
	var res_data: Difficulty = load(res_path)
	if res_data and not res_data.id < 0:
		if difficulty_map.has(res_data.id):
			Logger.error("Duplicate difficulty id found: %s in file: %s" % [res_data.id, res_path], MODULE)
		else:
			difficulty_map[res_data.id] = res_data


func load_roles() -> void:
	role_map.clear()
	visit_res_folder(ROLE_FOLDER, load_one_role)
	difficulty_map.clear()
	visit_res_folder(DIFFICULTY_FOLDER, load_one_difficulty)
