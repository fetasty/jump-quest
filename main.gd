extends Node


@onready var game_layer: CanvasLayer = %GameLayer		# Layer for 2d game world
@onready var hud_layer: CanvasLayer = %HudLayer 		# layer for hud ui
@onready var menu_layer: CanvasLayer = %MenuLayer		# layer for menu (pause menu, main menu)


func _ready() -> void:
	# Initialize ui manager
	UiManager.hud_layer = hud_layer
	UiManager.menu_layer = menu_layer
	# Show main menu
	UiManager.change_menu(UiManager.MAIN_MENU)


func close_game_scene() -> void:
	for child in game_layer.get_children():
		child.queue_free()


func change_game_scene(scene_path: String) -> void:
	close_game_scene()
	var scene_src = load(scene_path) as PackedScene
	var scene = scene_src.instantiate()
	scene.name = "World"
	game_layer.add_child(scene)
