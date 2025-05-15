extends Control

const ROLE_SELECT_ITEM = preload("res://menu/role_select_item.tscn")

@onready var roles: HBoxContainer = $VBoxContainer/Roles

func _ready() -> void:
	var role_map = ResourceManager.get_role_map()
	for k in role_map:
		var role = role_map[k] as Role
		var item = ROLE_SELECT_ITEM.instantiate()
		item.role_texture = role.texture
		item.texture_scale = role.scale
		item.role_id = role.id
		roles.add_child(item)


func _on_confirm_pressed() -> void:
	hide()
