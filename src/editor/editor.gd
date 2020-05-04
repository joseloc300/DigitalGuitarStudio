extends Node2D

onready var note_2d_node = preload("res://src/objects/note_2d/note_2d.tscn")

var time = 0
var time_acum = 0

var levels
var sections
var phrase_iterations
var chord_templates


var notes = []



var curr_note_index = 0

var curr_anchor = 0
var curr_difficulty = 0

var can_move_line = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$MusicParser.readArrangement()
	sections = $MusicParser.sections
	levels = $MusicParser.levels
	phrase_iterations = $MusicParser.phrase_iterations
	chord_templates = $MusicParser.chord_templates
	$strings.setup_strings($MusicParser.song_length)
	create_notes_2()
	reorder_notes()
	$CanvasLayer/GUI/SpinBox.max_value = levels.size() - 1
	$CanvasLayer/GUI.set_sections(sections)
	$AudioStreamPlayer.load_song()
	time = 0
	time_acum = 0
	$AudioStreamPlayer.play()
	can_move_line = true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	time_acum += delta
	if can_move_line:
		move_line()
	move_camera()
	
	#spawn_notes()

func move_line():
	if time_acum > $strings.time_per_string:
		$Line2D.position = Vector2(160 + 960 * (time_acum - 2) / 2, 120 + floor(time / 2) * $strings.string_set_spacing)
	else:
		$Line2D.position = Vector2(160 + 960 * time_acum / 2, 120 + floor(time / 2) * $strings.string_set_spacing)

func move_camera():
	if time_acum > $strings.time_per_string:
		$Camera2D.translate(Vector2(0, $strings.string_set_spacing))
		time_acum -= $strings.time_per_string

func create_notes():
	for note in levels[curr_difficulty].notes:
		var noteObj = note_2d_node.instance()
		noteObj.init(note)
		notes.append(noteObj)
		$notes.add_child(noteObj)

func create_notes_2():
	var time_lower_bound = 0
	var time_upper_bound = 0
	
	for i in range(phrase_iterations.size()):
		var phrase_iteration = phrase_iterations[i]
		time_lower_bound = phrase_iteration.time
		if i + 1 < phrase_iterations.size():
			time_upper_bound = phrase_iterations[i + 1].time
		else:
			time_upper_bound = -1		
		
		var curr_difficulty = 0
		if phrase_iteration.hero_levels != []:
			curr_difficulty = phrase_iteration.hero_levels[2].difficulty
		
		for note in levels[curr_difficulty].notes:
			if note.time < time_lower_bound:
				continue
			elif time_upper_bound != -1 and note.time >= time_upper_bound:
				break
			var noteObj = note_2d_node.instance()
			noteObj.init(note)
			notes.append(noteObj)
			$notes.add_child(noteObj)
		
		for chord in levels[curr_difficulty].chords:
			if chord.time < time_lower_bound:
				continue
			elif time_upper_bound != -1 and chord.time >= time_upper_bound:
				break
			
			instance_chord_notes(chord)
		
		

func instance_chord_notes(chord):
	var chord_template = chord_templates[chord.chord_id]
	var string = -1
	var fret = -1
	if chord_template.fret_0 != -1:
		string = 0
		fret = chord_template.fret_0
		var noteObj = note_2d_node.instance()
		noteObj.init_from_chord(chord.time, string, fret)
		notes.append(noteObj)
		$notes.add_child(noteObj)
	
	if chord_template.fret_1 != -1:
		string = 1
		fret = chord_template.fret_1
		var noteObj = note_2d_node.instance()
		noteObj.init_from_chord(chord.time, string, fret)
		notes.append(noteObj)
		$notes.add_child(noteObj)
	
	if chord_template.fret_2 != -1:
		string = 2
		fret = chord_template.fret_2
		var noteObj = note_2d_node.instance()
		noteObj.init_from_chord(chord.time, string, fret)
		notes.append(noteObj)
		$notes.add_child(noteObj)
	
	if chord_template.fret_3 != -1:
		string = 3
		fret = chord_template.fret_3
		var noteObj = note_2d_node.instance()
		noteObj.init_from_chord(chord.time, string, fret)
		notes.append(noteObj)
		$notes.add_child(noteObj)
	
	if chord_template.fret_4 != -1:
		string = 4
		fret = chord_template.fret_4
		var noteObj = note_2d_node.instance()
		noteObj.init_from_chord(chord.time, string, fret)
		notes.append(noteObj)
		$notes.add_child(noteObj)
	
	if chord_template.fret_5 != -1:
		string = 5
		fret = chord_template.fret_5
		var noteObj = note_2d_node.instance()
		noteObj.init_from_chord(chord.time, string, fret)
		notes.append(noteObj)
		$notes.add_child(noteObj)

func reorder_notes():
	var not_sorted = true
	
	while(not_sorted):	
		var switched = false
		for i in range(notes.size() - 1):
			for j in range(i, notes.size() - 1):
				if notes[j + 1].time < notes[j].time:
					switched = true
					var temp = notes[j]
					notes[j] = notes[j + 1]
					notes[j + 1] = temp
		
		not_sorted = switched

func reset_notes():
	can_move_line = false
	
	notes.clear()
	for n in $notes.get_children():
		$notes.remove_child(n)
		n.queue_free()
	
	create_notes_2()
	
	can_move_line = true

func reset_camera():
	$Camera2D.smoothing_enabled = false
	$Camera2D.position = Vector2(0, floor(time / 2) * $strings.string_set_spacing)
	$Camera2D.smoothing_enabled = true

func _on_OptionButton_item_selected(id):
	for section in sections:
		if $CanvasLayer/GUI/OptionButton.text == section.name:
			$AudioStreamPlayer.seek(section.start_time)
			time = section.start_time
			time_acum = fmod(time, 2.0)
			reset_notes()
			reset_camera()
			break


func _on_SpinBox_value_changed(value):
	curr_difficulty = value
	reset_notes()
