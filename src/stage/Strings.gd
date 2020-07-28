extends Spatial

onready var note_node = preload("res://src/objects/note_3d/note_3d.tscn")
onready var parser = preload("res://src/music_parser/MusicParser.tscn")

var notes = []
var time = 0
var curr_index = 0

var note_count = -1

var levels
var sections
var phrase_iterations
var chord_templates

var parserObj

var curr_anchor = 0
var curr_difficulty = 0
const scrool_speed = 15

var playback_speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	parserObj = parser.instance()
	parserObj.readArrangement()
	#notes = parserObj.notes
	#note_count = parserObj.note_count
	sections = parserObj.sections
	levels = parserObj.levels
	phrase_iterations = parserObj.phrase_iterations
	chord_templates = parserObj.chord_templates
	$GUI/SpinBox.max_value = levels.size() - 1
	$GUI.set_sections(sections)
	create_notes_2()
	reorder_notes()
	play_music()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	spawn_notes_2()
	update_difficulty()
	move_camera()
	time += delta

func update_difficulty():
	var time_lower_bound = 0
	var time_upper_bound = 0
	
	for i in range(phrase_iterations.size()):
		var phrase_iteration = phrase_iterations[i]
		time_lower_bound = phrase_iteration.time
		if i + 1 < phrase_iterations.size():
			time_upper_bound = phrase_iterations[i + 1].time
		else:
			time_upper_bound = -1		
		
		if time < time_lower_bound or time >= time_upper_bound:
			continue
		
		if phrase_iteration.hero_levels != []:
			curr_difficulty = phrase_iteration.hero_levels[2].difficulty
		else:
			curr_difficulty = 0

func move_camera():
	if curr_anchor >= levels[curr_difficulty].anchors.size():
		return
	$InterpolatedCamera.pause_mode = Node.PAUSE_MODE_STOP
	while curr_anchor < levels[curr_difficulty].anchors.size() && time > levels[curr_difficulty].anchors[curr_anchor].time / playback_speed - 1:
		if levels[curr_difficulty].anchors[curr_anchor].fret >= 2:
			$InterpolatedCamera.set_target($Fret_pos.get_children()[levels[curr_difficulty].anchors[curr_anchor].fret - 1])
		else:
			$InterpolatedCamera.set_target($Fret_pos/Spatial)
		curr_anchor += 1
	
	$InterpolatedCamera.pause_mode = Node.PAUSE_MODE_INHERIT

func create_notes():
	for note in levels[curr_difficulty].notes:
		var noteObj = note_node.instance()
		noteObj.init(note, scrool_speed, playback_speed)
		noteObj.translate( Vector3(-11.5 + note.fret, 1.75 - note.string * 0.25, -90))
		notes.append(noteObj)

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
			var noteObj = note_node.instance()
			noteObj.init(note, scrool_speed, playback_speed)
			noteObj.translate( Vector3(-11.5 + note.fret, 1.75 - note.string * 0.25, -90))
			notes.append(noteObj)
		
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
		var noteObj = note_node.instance()
		noteObj.init_from_chord(chord.time, string, fret, scrool_speed, playback_speed)
		noteObj.translate( Vector3(-11.5 + fret, 1.75 - string * 0.25, -90))
		notes.append(noteObj)
	
	if chord_template.fret_1 != -1:
		string = 1
		fret = chord_template.fret_1
		var noteObj = note_node.instance()
		noteObj.init_from_chord(chord.time, string, fret, scrool_speed, playback_speed)
		noteObj.translate( Vector3(-11.5 + fret, 1.75 - string * 0.25, -90))
		notes.append(noteObj)
	
	if chord_template.fret_2 != -1:
		string = 2
		fret = chord_template.fret_2
		var noteObj = note_node.instance()
		noteObj.init_from_chord(chord.time, string, fret, scrool_speed, playback_speed)
		noteObj.translate( Vector3(-11.5 + fret, 1.75 - string * 0.25, -90))
		notes.append(noteObj)
	
	if chord_template.fret_3 != -1:
		string = 3
		fret = chord_template.fret_3
		var noteObj = note_node.instance()
		noteObj.init_from_chord(chord.time, string, fret, scrool_speed, playback_speed)
		noteObj.translate( Vector3(-11.5 + fret, 1.75 - string * 0.25, -90))
		notes.append(noteObj)
	
	if chord_template.fret_4 != -1:
		string = 4
		fret = chord_template.fret_4
		var noteObj = note_node.instance()
		noteObj.init_from_chord(chord.time, string, fret, scrool_speed, playback_speed)
		noteObj.translate( Vector3(-11.5 + fret, 1.75 - string * 0.25, -90))
		notes.append(noteObj)
	
	if chord_template.fret_5 != -1:
		string = 5
		fret = chord_template.fret_5
		var noteObj = note_node.instance()
		noteObj.init_from_chord(chord.time, string, fret, scrool_speed, playback_speed)
		noteObj.translate( Vector3(-11.5 + fret, 1.75 - string * 0.25, -90))
		notes.append(noteObj)

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

func spawn_notes(delta):
	time += delta
	while curr_index < notes.size() and notes[curr_index].time <= time:
		#var note_string = randi() % 6
		#var note_fret = -(randi() % 3) + 3
		var noteObj = note_node.instance()
		noteObj.init(notes[curr_index].string, notes[curr_index].sustain)
		noteObj.translate( Vector3(-11.5 + notes[curr_index].fret, 1.75 - notes[curr_index].string * 0.25, -90.0))
		$Notes.add_child(noteObj)
		curr_index += 1

func spawn_notes_2():
	while curr_index < notes.size() and notes[curr_index].time <= time + 6:
		var time_diff = time + 6 - notes[curr_index].time
		notes[curr_index].translate(Vector3(0, 0, time_diff * scrool_speed))
		$Notes.add_child(notes[curr_index])
		curr_index += 1

func play_music():
	var filepath
	var music_path = Global.selected_song_path + "/audio/windows/"
		
	var dir = Directory.new()
	dir.open(music_path)
	dir.list_dir_begin(true)
	
	while true:
		filepath = dir.get_next()
		if filepath == "":
			break
		elif !filepath.ends_with("_preview_fixed.ogg") && filepath.ends_with("_fixed.ogg"):
			music_path += filepath
			break
	
	dir.list_dir_end()
	
	var file = File.new()
	if file.file_exists(music_path):
		file.open(music_path, File.READ)
		var audio_stream_ogg = AudioStreamOGGVorbis.new()
		audio_stream_ogg.set_data(file.get_buffer(file.get_len()))
		$AudioStreamPlayer.stream = audio_stream_ogg
		$AudioStreamPlayer.play()

func reset_notes():
	notes.clear()
	create_notes_2()
	
	$Notes.pause_mode = Node.PAUSE_MODE_STOP
	for n in $Notes.get_children():
		$Notes.remove_child(n)
		n.queue_free()
	$Notes.pause_mode = Node.PAUSE_MODE_INHERIT
	
	var index = 0
	for note in notes:
		curr_index = index
		if note.time >= time:
			break
		index += 1
	
	index = 0
	for anchor in levels[curr_difficulty].anchors:
		curr_anchor = index
		if anchor.time / playback_speed >= time:
			break
		index += 1
	
	update_difficulty()

func _on_OptionButton_item_selected(id):
	for section in sections:
		if $GUI/OptionButton.text == section.name:
			var new_time = section.start_time - 2
			$AudioStreamPlayer.seek(new_time * playback_speed)
			time = new_time
			reset_notes()
			break


func _on_SpinBox_value_changed(value):
	curr_difficulty = value
	reset_notes()


func _on_HSlider_value_changed(value):
	playback_speed = value / 100.0
	$GUI/Label.text = "Playback speed = " + str(value) + "%"
	$AudioStreamPlayer.pitch_scale = playback_speed
	var effect = AudioServer.get_bus_effect(0, 0)
	effect.pitch_scale = 1 / playback_speed
	reset_notes()
