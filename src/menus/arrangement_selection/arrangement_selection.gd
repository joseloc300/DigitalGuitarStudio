extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	var selected_folder = $OptionButton.text
	print(selected_folder)
	
	var arrangements = []
	
	var dir = Directory.new()
	dir.open(Global.selected_song_path + "/songs/arr/")
	
	dir.list_dir_begin(true)
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif !file.ends_with("_showlights.xml"):
			arrangements.append(file)
	
	dir.list_dir_end()
	
	$Label.text = "Arrangements scanned: " + str(arrangements.size())
	
	$OptionButton.clear()
	
	for i in range(arrangements.size()):
		$OptionButton.add_item(arrangements[i])
	
	$OptionButton.select(0)
	var arrangement_name = $OptionButton.text
	Global.selected_arrangement_path = Global.selected_song_path + "/songs/arr/" + arrangement_name
	
	play_preview()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play_preview():	
	var file = File.new()
	if file.file_exists(Global.preview_path):
		file.open(Global.preview_path, File.READ)
		var audio_stream_ogg = AudioStreamOGGVorbis.new()
		audio_stream_ogg.loop = true
		audio_stream_ogg.set_data(file.get_buffer(file.get_len()))
		$AudioStreamPlayer.stream = audio_stream_ogg
		$AudioStreamPlayer.play(Global.curr_preview_time)

func _on_Button_pressed():
	if $CheckBox.pressed:
		get_tree().change_scene("res://src/editor/editor.tscn")
	else:
		get_tree().change_scene("res://src/stage/Stage.tscn")


func _on_Button2_pressed():
	Global.selected_arrangement_path = ""
	get_tree().change_scene("res://src/menus/song_list/song_list.tscn")


func _on_OptionButton_item_selected(id):
	var arrangement_name = $OptionButton.text
	Global.selected_arrangement_path = Global.selected_song_path + "/songs/arr/" + arrangement_name

