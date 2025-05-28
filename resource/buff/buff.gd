class_name Buff
extends Resource

enum {
	BUFF_DOUBLE,
	BUFF_SAW,
	BUFF_SHIELD,
	BUFF_COUNT,
}

## The unique buff id
@export var id: int = -1

## The buff texture
@export var texture: Texture2D
