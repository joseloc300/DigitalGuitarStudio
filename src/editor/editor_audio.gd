extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_song():
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
		stream = audio_stream_ogg
