extends Spatial

const red_mat = preload("res://src/objects/string_3d/red_string_mat.tres")
const yellow_mat = preload("res://src/objects/string_3d/yellow_string_mat.tres")
const blue_mat = preload("res://src/objects/string_3d/blue_string_mat.tres")
const orange_mat = preload("res://src/objects/string_3d/orange_string_mat.tres")
const green_mat = preload("res://src/objects/string_3d/green_string_mat.tres")
const purple_mat = preload("res://src/objects/string_3d/purple_string_mat.tres")

const mats = [red_mat, yellow_mat, blue_mat, orange_mat, green_mat, purple_mat]
const inverted_index_correction = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_color(color, inverted):
	if inverted:
		$cylinder.material = mats[inverted_index_correction - color]
	else:
		$cylinder.material = mats[color]
