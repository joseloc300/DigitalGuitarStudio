extends Spatial

onready var string_3d = preload("res://src/objects/string_3d/string_3d.tscn")

const n_strings = 6
const string_spacing = 0.25
const top_string_height = 1.75

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(n_strings):
		var string_3d_obj = string_3d.instance()
		string_3d_obj.translate(Vector3(0, top_string_height - string_spacing * i, 0))
		string_3d_obj.set_color(i, Global.inverted_strings)
		$".".add_child(string_3d_obj)
	
	
#	$string_0.set_color_red()
#	$string_1.set_color_yellow()
#	$string_2.set_color_blue()
#	$string_3.set_color_orange()
#	$string_4.set_color_green()
#	$string_5.set_color_purple()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
