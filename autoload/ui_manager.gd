extends Node

## Manage all UI display and hiding

const MAIN_MENU = &"res://menu/main_menu.tscn"

var hud_layer: CanvasLayer
var menu_layer: CanvasLayer


func close_menu() -> void:
	for child in menu_layer.get_children():
		child.queue_free()


func change_menu(menu_path: String) -> void:
	close_menu()
	var menu_src = load(menu_path) as PackedScene
	var menu = menu_src.instantiate()
	menu.name = "Menu"
	menu_layer.add_child(menu)
