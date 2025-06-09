extends GPUParticles2D

## Particle color, init before adding to scene tree
var color: Color = Color.YELLOW


func _ready():
	var particle_material = process_material as ParticleProcessMaterial
	particle_material.color = color
