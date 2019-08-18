extends Spatial

onready var note = preload("res://src/note/Note.tscn")

var notes = []
const timedelta = 2.0
var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time >= timedelta:
		time -= timedelta
		var note_string = randi() % 6 + 1
		var note_fret = -(randi() % 8) + 8
		var noteObj = note.instance()
		noteObj.init(note_string)
		noteObj.translate( Vector3(-9.0 + note_fret * 2.0, note_string * 0.5, -10.0))
		$Notes.add_child(noteObj)
