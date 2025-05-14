extends Node

const MODULE = &"resource_manager"
const ROLE_FOLDER = &"res://resource/role"

var role_map: Dictionary = {}


func _ready() -> void:
	pass


func get_role(id: int) -> Role:
	if role_map.has(id):
		return role_map[id]
	else:
		Logger.error("Get role by id %s failed!" % id, MODULE)
		return null


func get_role_map() -> Dictionary:
	return role_map


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


func load_roles() -> void:
	role_map.clear()
	visit_res_folder(ROLE_FOLDER, load_one_role)
