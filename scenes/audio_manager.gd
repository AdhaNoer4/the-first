extends Node

@onready var players = [
	$SFXPlayer1,
	$SFXPlayer2,
	$SFXPlayer3,
	$SFXPlayer4
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_sound(sound: AudioStream):
	for player in players:
		if player.playing == false:
			player.stream = sound
			player.play()
			return

func set_music_enabled(enabled: bool):
	var bus = AudioServer.get_bus_index("BGM")
	AudioServer.set_bus_mute(bus, not enabled)

func set_sfx_enabled(enabled: bool):
	var bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(bus, not enabled)

func save_audio_settings(music_enabled: bool, sfx_enabled: bool):
	var config = ConfigFile.new()

	config.set_value("audio", "music_enabled", music_enabled)
	config.set_value("audio", "sfx_enabled", sfx_enabled)

	config.save("user://settings.cfg")

func load_audio_settings():
	var config = ConfigFile.new()

	if config.load("user://settings.cfg") == OK:
		var music_enabled = config.get_value("audio", "music_enabled", true)
		var sfx_enabled = config.get_value("audio", "sfx_enabled", true)

		set_music_enabled(music_enabled)
		set_sfx_enabled(sfx_enabled)

		return {
			"music_enabled": music_enabled,
			"sfx_enabled": sfx_enabled
		}

	return {
		"music_enabled": true,
		"sfx_enabled": true
	}
