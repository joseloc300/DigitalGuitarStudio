extends Node

var notes = []
var song_length = 0
var curr_index = 0

var note_count = -1
var chord_count = -1

var arrangement_info = []
var phrases = []
var new_linked_diffs = []
var phrase_iterations = []
var linked_diffs = []
var phrase_properties = []
var chord_templates = []
var fret_hand_mute_templates = []
var ebeats = []

#tone_base, tone_a, etc... missing? prob not important atm

var tones = []
var sections = []
var events = []
var transcription_track = []
var levels = []



var error_parsing = false
var node_type

var parser = XMLParser.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func readArrangement():
	var code = parser.open(Global.selected_arrangement_path)
	print("error code: " + str(code))
	parser.read()
	node_type = parser.get_node_type()
	_parse_song_length()
	_parse_phrase_iterations()
	_parse_chord_templates()
	_parse_sections()
	_parse_levels()

func _parse_song_length():
	while node_type != 1 || parser.get_node_name() != "songLength":
		parser.read()
		node_type = parser.get_node_type()
	
	parser.read()
	node_type = parser.get_node_type()
	if node_type == 3:
		song_length = float(parser.get_node_data())
	
	while node_type != 2 || parser.get_node_name() != "songLength":
		parser.read()
		node_type = parser.get_node_type()

func _parse_phrase_iterations():
	while node_type != 1 || parser.get_node_name() != "phraseIterations":
		parser.read()
		node_type = parser.get_node_type()
	
	var n_phrase_iterations = int(parser.get_named_attribute_value("count"))
	
	while node_type != 2 || parser.get_node_name() != "phraseIterations":
		if !(node_type == 1 && parser.get_node_name() == "phraseIteration"):
			parser.read()
			node_type = parser.get_node_type()
		
		if node_type == 1 && parser.get_node_name() == "phraseIteration":
			var new_phrase_iteration = {}
			new_phrase_iteration.time = float(parser.get_named_attribute_value("time"))
			new_phrase_iteration.phrase_id = int(parser.get_named_attribute_value("phraseId"))
			new_phrase_iteration.variation = parser.get_named_attribute_value("variation")
			new_phrase_iteration.hero_levels = _parse_hero_levels()
			phrase_iterations.append(new_phrase_iteration)
	
	if n_phrase_iterations != phrase_iterations.size():
		print("number of parsed phrase iterations different from stated number of phrase iterations")
		print(str(n_phrase_iterations) + " != " + str(phrase_iterations.size()))

func _parse_hero_levels():
	var hero_levels = []
	var n_hero_levels = 3
	
	
	# prevent skip all nodes due to type and name initial values being same as the ones we look for
	parser.read()
	node_type = parser.get_node_type()
	
	while !(node_type == 1 && parser.get_node_name() == "phraseIteration") and !(node_type == 2 && parser.get_node_name() == "phraseIterations") and !(node_type == 1 && parser.get_node_name() == "heroLevels"):
		parser.read()
		node_type = parser.get_node_type()
	
	if (node_type == 1 and parser.get_node_name() == "phraseIteration") or (node_type == 2 and parser.get_node_name() == "phraseIterations"):
		var name = parser.get_node_name()
		var type = parser.get_node_type()
		return hero_levels
	
	while node_type != 2 || parser.get_node_name() != "heroLevels":
		parser.read()
		node_type = parser.get_node_type()
		
		if node_type == 1 && parser.get_node_name() == "heroLevel":
			var new_hero_level = {}
			new_hero_level.difficulty = int(parser.get_named_attribute_value("difficulty"))
			new_hero_level.hero = int(parser.get_named_attribute_value("hero"))
			hero_levels.append(new_hero_level)
	
	if n_hero_levels != hero_levels.size():
		print("number of parsed hero levels different from stated number of hero levels")
		print(str(n_hero_levels) + " != " + str(hero_levels.size()))
	
	return hero_levels

func _parse_chord_templates():
	while node_type != 1 || parser.get_node_name() != "chordTemplates":
		parser.read()
		node_type = parser.get_node_type()
	
	var n_chord_templates = int(parser.get_named_attribute_value("count"))
	
	while node_type != 2 || parser.get_node_name() != "chordTemplates":
		parser.read()
		node_type = parser.get_node_type()
		
		if node_type == 1 && parser.get_node_name() == "chordTemplate":
			var new_chord_template = {}
			new_chord_template.display_name = parser.get_named_attribute_value("displayName")
			new_chord_template.chord_name = parser.get_named_attribute_value("chordName")
			new_chord_template.fret_0 = int(parser.get_named_attribute_value("fret0"))
			new_chord_template.fret_1 = int(parser.get_named_attribute_value("fret1"))
			new_chord_template.fret_2 = int(parser.get_named_attribute_value("fret2"))
			new_chord_template.fret_3 = int(parser.get_named_attribute_value("fret3"))
			new_chord_template.fret_4 = int(parser.get_named_attribute_value("fret4"))
			new_chord_template.fret_5 = int(parser.get_named_attribute_value("fret5"))
			new_chord_template.finger_0 = int(parser.get_named_attribute_value("finger0"))
			new_chord_template.finger_1 = int(parser.get_named_attribute_value("finger1"))
			new_chord_template.finger_2 = int(parser.get_named_attribute_value("finger2"))
			new_chord_template.finger_3 = int(parser.get_named_attribute_value("finger3"))
			new_chord_template.finger_4 = int(parser.get_named_attribute_value("finger4"))
			new_chord_template.finger_5 = int(parser.get_named_attribute_value("finger5"))
			chord_templates.append(new_chord_template)
	
	if n_chord_templates != chord_templates.size():
		print("number of parsed chord templates different from stated number of chord templates")
		print(str(n_chord_templates) + " != " + str(chord_templates.size()))

func _parse_sections():
	while node_type != 1 || parser.get_node_name() != "sections":
		parser.read()
		node_type = parser.get_node_type()
	
	var n_sections = int(parser.get_named_attribute_value("count"))
	
	while node_type != 2 || parser.get_node_name() != "sections":
		parser.read()
		node_type = parser.get_node_type()
		
		if node_type == 1 && parser.get_node_name() == "section":
			var new_section = {}
			var name = parser.get_named_attribute_value("name")
			var number = parser.get_named_attribute_value("number")
			var start_time = float(parser.get_named_attribute_value("startTime"))
			new_section.name = name + number
			new_section.start_time = start_time
			sections.append(new_section)
	
	if n_sections != sections.size():
		print("number of parsed sections different from stated number of sections")
		print(str(n_sections) + " != " + str(sections.size()))

func _parse_levels():
	while node_type != 1 || parser.get_node_name() != "levels":
		parser.read()
		node_type = parser.get_node_type()
	
	var n_levels = int(parser.get_named_attribute_value("count"))
	
	while node_type != 2 || parser.get_node_name() != "levels":
		parser.read()
		node_type = parser.get_node_type()
		
		if node_type == 1 && parser.get_node_name() == "level":
			var new_level= {}
			var difficulty = int(parser.get_named_attribute_value("difficulty"))
			var notes = _parse_notes()
			var chords = _parse_chords()
			var anchors = _parse_anchors()
			var hand_shapes = _parse_hand_shapes()
			new_level.difficulty = difficulty
			new_level.notes = notes
			new_level.chords = chords
			new_level.anchors = anchors
			levels.append(new_level)
	
	if n_levels != levels.size():
		print("number of parsed levels different from stated number of levels")
		print(str(n_levels) + " != " + str(levels.size()))

func _parse_notes():
	var notes = []
	
	while node_type != 1 || parser.get_node_name() != "notes":
		parser.read()
		node_type = parser.get_node_type()
	
	var n_notes = int(parser.get_named_attribute_value("count"))
	
	while node_type != 2 || parser.get_node_name() != "notes":
		parser.read()
		node_type = parser.get_node_type()
		
		if node_type == 1 && parser.get_node_name() == "note":
			var new_note = _parse_note()
			notes.append(new_note)
	
	if n_notes != notes.size():
		print("number of parsed notes different from stated number of notes")
		print(str(n_notes) + " != " + str(notes.size()))
	
	return notes

func _parse_note():
	var new_note = {}
	new_note.time = float(parser.get_named_attribute_value("time"))
	new_note.link_next = int(parser.get_named_attribute_value("linkNext"))
	new_note.accent = int(parser.get_named_attribute_value("accent"))
	new_note.bend = int(parser.get_named_attribute_value("bend"))
	new_note.fret = int(parser.get_named_attribute_value("fret"))
	new_note.hammer_on = int(parser.get_named_attribute_value("hammerOn"))
	new_note.harmonic = int(parser.get_named_attribute_value("harmonic"))
	new_note.hopo = int(parser.get_named_attribute_value("hopo"))
	new_note.ignore = int(parser.get_named_attribute_value("ignore"))
	new_note.left_hand = int(parser.get_named_attribute_value("leftHand"))
	new_note.mute = int(parser.get_named_attribute_value("mute"))
	new_note.palm_mute = int(parser.get_named_attribute_value("palmMute"))
	new_note.pluck = int(parser.get_named_attribute_value("pluck"))
	new_note.pull_off = int(parser.get_named_attribute_value("pullOff"))
	new_note.slap = int(parser.get_named_attribute_value("slap"))
	new_note.slide_to = int(parser.get_named_attribute_value("slideTo"))
	new_note.string = int(parser.get_named_attribute_value("string"))
	new_note.sustain = float(parser.get_named_attribute_value("sustain"))
	new_note.tremolo = int(parser.get_named_attribute_value("tremolo"))
	new_note.harmonic_pinch = int(parser.get_named_attribute_value("harmonicPinch"))
	new_note.pick_direction = int(parser.get_named_attribute_value("pickDirection"))
	new_note.right_hand = int(parser.get_named_attribute_value("rightHand"))
	new_note.slide_unpitch_to = int(parser.get_named_attribute_value("slideUnpitchTo"))
	new_note.tap = int(parser.get_named_attribute_value("tap"))
	new_note.vibrato = int(parser.get_named_attribute_value("vibrato"))
	new_note.bend_values = []
	
	if new_note.bend == 1:
		while node_type != 1 || parser.get_node_name() != "bendValues":
			parser.read()
			node_type = parser.get_node_type()
		
		while node_type != 2 || parser.get_node_name() != "bendValues":
			parser.read()
			node_type = parser.get_node_type()
			
			if node_type == 1 && parser.get_node_name() == "bendValue":
				var new_bend_value = {}
				new_bend_value.time = float(parser.get_named_attribute_value("time"))
				new_bend_value.step = int(parser.get_named_attribute_value("step"))
				new_bend_value.unk5 = int(parser.get_named_attribute_value("unk5"))
				new_note.bend_values.append(new_bend_value)
	
	return new_note

# if there are problems check if its necessary to parse chord notes when they appear
func _parse_chords():
	var chords = []
	
	while node_type != 1 || parser.get_node_name() != "chords":
		parser.read()
		node_type = parser.get_node_type()
	
	var n_chords = int(parser.get_named_attribute_value("count"))
	
	if n_chords == 0:
		return chords
	
	while node_type != 2 || parser.get_node_name() != "chords":
		parser.read()
		node_type = parser.get_node_type()
		
		if node_type == 1 && parser.get_node_name() == "chord":
			var new_chord = {}
			new_chord.time = float(parser.get_named_attribute_value("time"))
			new_chord.link_next = int(parser.get_named_attribute_value("linkNext"))
			new_chord.accent = int(parser.get_named_attribute_value("accent"))
			new_chord.chord_id = int(parser.get_named_attribute_value("chordId"))
			new_chord.fret_hand_mute = int(parser.get_named_attribute_value("fretHandMute"))
			new_chord.high_density = int(parser.get_named_attribute_value("highDensity"))
			new_chord.ignore = int(parser.get_named_attribute_value("ignore"))
			new_chord.palm_mute = int(parser.get_named_attribute_value("palmMute"))
			new_chord.hopo = int(parser.get_named_attribute_value("hopo"))
			new_chord.strum = parser.get_named_attribute_value("strum")
			chords.append(new_chord)
	
	if n_chords != chords.size():
		print("number of parsed chords different from stated number of chords")
		print(str(n_chords) + " != " + str(chords.size()))
	
	return chords

func _parse_anchors():
	var anchors = []
	
	while node_type != 1 || parser.get_node_name() != "anchors":
		parser.read()
		node_type = parser.get_node_type()
	
	var n_anchors = int(parser.get_named_attribute_value("count"))
	
	while node_type != 2 || parser.get_node_name() != "anchors":
		parser.read()
		node_type = parser.get_node_type()
		
		if node_type == 1 && parser.get_node_name() == "anchor":
			var new_anchor = {}
			new_anchor.time = float(parser.get_named_attribute_value("time"))
			new_anchor.fret = int(parser.get_named_attribute_value("fret"))
			new_anchor.width = int(parser.get_named_attribute_value("width"))
			anchors.append(new_anchor)
	
	if n_anchors != anchors.size():
		print("number of parsed anchors different from stated number of anchors")
		print(str(n_anchors) + " != " + str(anchors.size()))
	
	return anchors

func _parse_hand_shapes():
	pass

# deprecated
func _reorder_notes():
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
