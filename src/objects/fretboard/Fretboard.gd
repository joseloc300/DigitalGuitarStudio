extends Spatial

onready var string_3d = preload("res://src/objects/string_3d/string_3d.tscn")
onready var fret = preload("res://src/objects/fret/Fret.tscn")

const n_strings = 6
const string_spacing = 0.25
const top_string_height = 1.75

const n_frets = 24
const fret_spacing = 1
const fret_height = 1.1
const first_fret_correction = Vector3(-11, 0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	setup_strings()
	setup_frets()


func setup_strings():
	for i in range(n_strings):
		var string_3d_obj = string_3d.instance()
		string_3d_obj.translate(Vector3(0, top_string_height - string_spacing * i, 0))
		string_3d_obj.set_color(i, Global.gameplay_settings.inverted_strings)
		$"strings".add_child(string_3d_obj)

func setup_frets():
	for i in range(n_frets):
		var fret_obj = fret.instance()
		fret_obj.translate(Vector3(i * fret_spacing, fret_height, 0))
		$"frets".add_child(fret_obj)
	
	$"frets".transform.origin = first_fret_correction
