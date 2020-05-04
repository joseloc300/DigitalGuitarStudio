extends Spatial

onready var fret = preload("res://src/fret/Fret.tscn")

const n_frets = 24
const fret_spacing = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(n_frets):
		var fretObj = fret.instance()
		fretObj.translate(Vector3(i * fret_spacing, 1.1, 0))
		$".".add_child(fretObj)
	
	$".".translate(Vector3(-11, 0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
