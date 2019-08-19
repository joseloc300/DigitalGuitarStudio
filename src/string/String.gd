extends Spatial

const red_material = preload("res://src/string/red_string_mat.tres")
const yellow_material = preload("res://src/string/yellow_string_mat.tres")
const blue_material = preload("res://src/string/blue_string_mat.tres")
const orange_material = preload("res://src/string/orange_string_mat.tres")
const green_material = preload("res://src/string/green_string_mat.tres")
const purple_material = preload("res://src/string/purple_string_mat.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_color_red():
	$CSGCylinder.material = red_material

func set_color_yellow():
	$CSGCylinder.material = yellow_material

func set_color_blue():
	$CSGCylinder.material = blue_material

func set_color_orange():
	$CSGCylinder.material = orange_material

func set_color_green():
	$CSGCylinder.material = green_material

func set_color_purple():
	$CSGCylinder.material = purple_material
