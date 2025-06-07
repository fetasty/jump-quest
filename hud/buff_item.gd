extends CenterContainer


## Must init before add to scenetree
var buff_res: Buff

## Temporary fields
var flash_tween: Tween = null
var is_flashing: bool = false

@onready var buff_container: Control = %BuffContainer
@onready var buff_texture: TextureRect = %BuffTexture
@onready var time_label: Label = %TimeLabel

# TODO Flashing when time is running out

func _ready() -> void:
	buff_texture.texture = buff_res.texture
	GameEvent.data_changed.connect(on_data_changed)
	buff_container.custom_minimum_size = buff_texture.size * buff_texture.scale.x


func set_flashing(flashing: bool) -> void:
	if flashing and flash_tween == null:
		is_flashing = true
		flash_tween = get_tree().create_tween()
		flash_tween.tween_property(buff_texture, "modulate", Color.TRANSPARENT, 0.25)
		flash_tween.tween_property(buff_texture, "modulate", Color.WHITE, 0.25)
		flash_tween.set_loops()
		flash_tween.play()
	elif not flashing and flash_tween != null:
		is_flashing = false
		flash_tween.stop()
		flash_tween = null
		buff_texture.modulate = Color.WHITE


func on_data_changed(key: StringName, value: Variant) -> void:
	match key:
		Const.BUFF_TIME:
			var id = value["id"]
			var time = value["time"]
			if id == buff_res.id:
				time_label.text = "%.1fs" % time
				if is_flashing and time >= 2.0:
					set_flashing(false)
				if not is_flashing and time > 0.0 and time < 2.0:
					set_flashing(true)
				if time <= 0.0:
					set_flashing(false)
					visible = false
				elif not visible:
					visible = true
		_:
			pass
