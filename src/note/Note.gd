extends Spatial

const red_material = preload("res://src/note/red_note_mat.tres")
const yellow_material = preload("res://src/note/yellow_note_mat.tres")
const blue_material = preload("res://src/note/blue_note_mat.tres")
const orange_material = preload("res://src/note/orange_note_mat.tres")
const green_material = preload("res://src/note/green_note_mat.tres")
const purple_material = preload("res://src/note/purple_note_mat.tres")

const RED = 1
const YELLOW = 2
const BLUE = 3
const ORANGE = 4
const GREEN = 5
const PURPLE = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(color):
	if color == RED:
		set_color_red()
	elif color == YELLOW:
		set_color_yellow()
	elif color == BLUE:
		set_color_blue()
	elif color == ORANGE:
		set_color_orange()
	elif color == GREEN:
		set_color_green()
	elif color == PURPLE:
		set_color_purple()

func set_color_red():
	$CSGBox.material = red_material

func set_color_yellow():
	$CSGBox.material = yellow_material

func set_color_blue():
	$CSGBox.material = blue_material

func set_color_orange():
	$CSGBox.material = orange_material

func set_color_green():
	$CSGBox.material = green_material

func set_color_purple():
	$CSGBox.material = purple_material
