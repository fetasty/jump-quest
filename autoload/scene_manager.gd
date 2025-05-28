extends Node

## Manage all UI display and hiding

const MAIN_MENU = &"res://menu/main_menu.tscn"
const GAME_SCENE = &"res://game/game.tscn"

var hud_layer: CanvasLayer
var menu_layer: CanvasLayer
var game_layer: CanvasLayer


func close_menu() -> void:
	for child in menu_layer.get_children():
		child.queue_free()


func change_menu(menu_path: String) -> void:
	close_menu()
	var menu_src = load(menu_path) as PackedScene
	var menu = menu_src.instantiate()
	menu.name = "Menu"
	menu_layer.add_child(menu)


func show_hud() -> void:
	hud_layer.visible = true


func hide_hud() -> void:
	hud_layer.visible = false


func close_game_scene() -> void:
	for child in game_layer.get_children():
		child.queue_free()


func change_game_scene(scene_path: String) -> void:
	close_game_scene()
	var scene_src = load(scene_path) as PackedScene
	var scene = scene_src.instantiate()
	scene.name = "World"
	game_layer.add_child(scene)
