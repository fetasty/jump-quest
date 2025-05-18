extends Control

const ROLE_SELECT_ITEM_GROUP = &"role_select_item"
const SELECT_ITEM_FUNC = &"select_item"

## Must be setted before add to scene tree
var role_id: int
var role_texture: Texture2D
var texture_scale: float

@onready var role: TextureRect = %Role
@onready var select_border: TextureRect = %Select


func _ready() -> void:
	add_to_group(ROLE_SELECT_ITEM_GROUP)
	role.size = role_texture.get_size()
	role.pivot_offset = role.size * 0.5
	role.texture = role_texture
	role.position = (size - role.size) * 0.5
	role.scale = Vector2.ONE * texture_scale * 3.0
	select_border.visible = (GameState.role == role_id)


func select_item(id: int) -> void:
	select_border.visible = (id == role_id)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			get_tree().call_group(ROLE_SELECT_ITEM_GROUP, SELECT_ITEM_FUNC, role_id)
			GameState.role = role_id
