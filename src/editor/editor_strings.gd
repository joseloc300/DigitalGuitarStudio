extends Node2D

onready var string_2d_scene = preload("res://src/string_2d/string_2d.tscn")

var time_per_string = 2

var n_strings = 6
const string_spacing = 20
const string_set_spacing = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setup_strings(total_time):
	var n_string_sets = ceil(total_time / time_per_string)
	
	for i in range(n_string_sets):
		var string_set = Node2D.new()
		for j in range(n_strings):
			var string = string_2d_scene.instance()
			string.translate(Vector2(0, (n_strings - 1 - j) * string_spacing))
			string_set.add_child(string)
		
		string_set.translate(Vector2(160, 125 + i * string_set_spacing))
		add_child(string_set)
