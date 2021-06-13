extends Control

var files = []


# Called when the node enters the scene tree for the first time.
func _ready():
	scan_songs()


func scan_songs():
	
	var dir = Directory.new()
	dir.open("./backingtracks/")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif dir.current_is_dir() && file != "." && file != "..":
			files.append(file)
			$ItemList.add_item(file)
	
	dir.list_dir_end()


func _on_ItemList_item_selected(index):
	select_song(index)


func select_song(index):
	var filepath
	var name = $ItemList.get_item_text(index)
	
	var audio_path = "./backingtracks/" + name + "/"
		
	var dir = Directory.new()
	dir.open(audio_path)
	dir.list_dir_begin(true)
	
	while true:
		filepath = dir.get_next()
		if filepath == "":
			break
		elif filepath.ends_with(".mp3"):
			audio_path += filepath
			break
	
	dir.list_dir_end()
	
	var file = File.new()
	if file.file_exists(audio_path):
		file.open(audio_path, File.READ)
		
		var audio_stream = AudioStreamMP3.new()
		audio_stream.loop = true
		audio_stream.set_data(file.get_buffer(file.get_len()))
		$AudioStreamPlayer.stream = audio_stream
		$AudioStreamPlayer.play()

