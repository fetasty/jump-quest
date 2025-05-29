extends CenterContainer


## Must init before add to scenetree
var buff_res: Buff

@onready var buff_container: Control = %BuffContainer
@onready var buff_texture: TextureRect = %BuffTexture
@onready var time_label: Label = %TimeLabel

# TODO Flashing when time is running out

func _ready() -> void:
	buff_texture.texture = buff_res.texture
	GameEvent.data_changed.connect(on_data_changed)
	buff_container.custom_minimum_size = buff_texture.size * buff_texture.scale.x


func on_data_changed(key: StringName, value: Variant) -> void:
	match key:
		Const.BUFF:
			var id = value.id
			var time = value.time
			if id == buff_res.id:
				if time > 1.0:
					time_label.text = "%ds" % int(time)
				else:
					time_label.text = "%.2fs" % time
				if time <= 0.0:
					visible = false
				elif not visible:
					visible = true
		_:
			pass
