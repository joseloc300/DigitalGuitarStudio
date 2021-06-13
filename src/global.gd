tool

extends Node

# Constansts
const DEFAULT_GRAPHIC_SETTINGS = {
	
}

const DEFAULT_AUDIO_SETTINGS = {
	master_volume = 0.5,
	music_volume = 0.5,
	sfx_volume = 1.0
}

const DEFAULT_GAMEPLAY_SETTINGS = {
	video_delay_ms = 0,
	inverted_strings = false
}

# Settings
var graphic_settings = DEFAULT_GRAPHIC_SETTINGS
var audio_settings = DEFAULT_AUDIO_SETTINGS
var gameplay_settings = DEFAULT_GAMEPLAY_SETTINGS

# Load paths
var selected_song_path = ""
var selected_arrangement_path = ""
var preview_path = ""
var curr_preview_time = ""

# Lists
var songs = {}
var backing_tracks = {}
