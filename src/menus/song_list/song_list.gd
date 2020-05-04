extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var files = []

# Called when the node enters the scene tree for the first time.
func _ready():
	scan_songs()
	scan_art()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func scan_songs():
	
	var dir = Directory.new()
	dir.open("./songs/")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif dir.current_is_dir() && file != "." && file != "..":
			files.append(file)
	
	dir.list_dir_end()


func scan_art():
	for song in files:
		var art_path = "./songs/" + song + "/gfxassets/album_art/"
		
		var dir = Directory.new()
		dir.open(art_path)
		dir.list_dir_begin(true)
		
		while true:
			var file = dir.get_next()
			if file == "":
				break
			elif file.ends_with("_256.png"):
				art_path += file
				break
		
		dir.list_dir_end()
		
		var art = Image.new()
		art.load(art_path)
		
		var tex = ImageTexture.new()
		tex.create_from_image(art)
		
		#$ScrollContainer/ItemList.add_item(song, art, true)
		$ItemList.add_item(song, tex, true)
	
	$ItemList.select(0)
	select_song(0)
	


func _on_Button2_pressed():
	Global.selected_song_path = ""
	get_tree().change_scene("res://src/menus/main_menu/main_menu.tscn")


func _on_ItemList_item_selected(index):
	select_song(index)

func select_song(index):
	var filepath
	var name = $ItemList.get_item_text(index)
	
	var preview_path = "./songs/" + name + "/audio/windows/"
	Global.selected_song_path = "./songs/" + name
		
	var dir = Directory.new()
	dir.open(preview_path)
	dir.list_dir_begin(true)
	
	while true:
		filepath = dir.get_next()
		if filepath == "":
			break
		elif filepath.ends_with("_preview_fixed.ogg"):
			preview_path += filepath
			break
	
	dir.list_dir_end()
	
	var file = File.new()
	if file.file_exists(preview_path):
		file.open(preview_path, File.READ)
		
		Global.preview_path = preview_path
		var audio_stream_ogg = AudioStreamOGGVorbis.new()
		audio_stream_ogg.loop = true
		audio_stream_ogg.set_data(file.get_buffer(file.get_len()))
		$AudioStreamPlayer.stream = audio_stream_ogg
		$AudioStreamPlayer.play()

func _on_Button_pressed():
	Global.curr_preview_time = $AudioStreamPlayer.get_playback_position()
	get_tree().change_scene("res://src/menus/arrangement_selection/arrangement_selection.tscn")
