tool

extends Spatial

onready var fret = preload("res://src/objects/fret/Fret.tscn")

const n_frets = 24
const fret_spacing = 1
const fret_height = 1.1
const first_fret_correction = Vector3(-11, 0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(n_frets):
		var fret_obj = fret.instance()
		fret_obj.translate(Vector3(i * fret_spacing, fret_height, 0))
		$".".add_child(fret_obj)
	
	$".".transform.origin = first_fret_correction


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
