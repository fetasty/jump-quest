extends Sprite2D

const CONFIG = {
	Buff.BUFF_DOUBLE: {
		"texture": preload("res://art/double_buff_item.tres"),
		"scale": 0.4,
		"pos_y": -15.0,
		"rotating": false,
	},
	Buff.BUFF_SAW: {
		"texture": preload("res://art/saw.tres"),
		"scale": 0.45,
		"pos_y": 0.0,
		"rotating": true,
	},
	Buff.BUFF_SHIELD: {
		"texture": preload("res://art/shield.tres"),
		"scale": 0.5,
		"pos_y": 0.0,
		"rotating": false,
	},
}


var _buff_id: int

var flash_tween: Tween = null
var is_flashing: bool = false
var rotating: bool = false


func _ready() -> void:
	var buff_config = CONFIG[_buff_id]
	texture = buff_config["texture"]
	position.y = buff_config["pos_y"]
	scale = Vector2.ONE * buff_config["scale"]
	rotating = buff_config["rotating"]
	GameEvent.data_changed.connect(on_data_changed)


func _process(delta: float) -> void:
	if rotating:
		rotate(delta * PI * 2.0)


func _exit_tree() -> void:
	if flash_tween:
		set_flashing(false)


func init(buff_id: int) -> void:
	self._buff_id = buff_id


func set_flashing(flashing: bool) -> void:
	if flashing and flash_tween == null:
		is_flashing = true
		flash_tween = get_tree().create_tween()
		flash_tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.25)
		flash_tween.tween_property(self, "modulate", Color.WHITE, 0.25)
		flash_tween.set_loops()
		flash_tween.play()
	elif not flashing and flash_tween != null:
		is_flashing = false
		flash_tween.stop()
		flash_tween = null
		modulate = Color.WHITE


func on_data_changed(key: StringName, value: Variant) -> void:
	match key:
		Const.REMOVE_BUFF:
			if value["id"] == _buff_id:
				queue_free()
		Const.BUFF_TIME:
			if value["id"] == _buff_id:
				var time = value["time"]
				if time > 0.0 and time < 2.0 and not is_flashing:
					set_flashing(true)
				if time >= 2.0 and is_flashing:
					set_flashing(false)
