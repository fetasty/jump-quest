extends CenterContainer


## Must init before add to scenetree
var buff_res: Buff

@onready var buff_container: Control = %BuffContainer
@onready var buff_texture: TextureRect = %BuffTexture
@onready var time_label: Label = %TimeLabel


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
				time_label.text = "%.2f" % time
				if is_zero_approx(time):
					visible = false
		_:
			pass
