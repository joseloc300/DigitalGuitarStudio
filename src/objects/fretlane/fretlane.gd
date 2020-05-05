extends Spatial


const default_mat = preload("res://src/objects/fretlane/fretlane_mat.tres")
const active_mat = preload("res://src/objects/fretlane/fretlane_active_mat.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func activate_lane():
	$CSGBox.material = active_mat

func deactivate_lane():
	$CSGBox.material = default_mat
