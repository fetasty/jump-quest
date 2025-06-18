class_name Role extends Resource

enum {
	CHICK = 0,
	DOG = 1,
	PIG = 2,
}

@export var id: int = -1
@export var texture: Texture2D
@export var scale: float
@export var jump_audio_path: String
