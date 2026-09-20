extends Control

@export var button_click_sound: AudioStream

@onready var bgm = $BGM
@onready var audio_settings = $AudioSettings
@onready var close_button = $AudioSettings/VBoxContainer/CloseButton
@onready var music_button = $AudioSettings/VBoxContainer/MusicButton
@onready var sfx_button = $AudioSettings/VBoxContainer/SFXButton
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animate_title()
	
	var audio_settings_data = AudioManager.load_audio_settings()
	
	music_button.button_pressed = audio_settings_data["music_enabled"]
	sfx_button.button_pressed = audio_settings_data["sfx_enabled"]
	
	close_button.pressed.connect(close_audio_settings)
	music_button.toggled.connect(toggle_music)
	sfx_button.toggled.connect(toggle_sfx)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	play_button_sound()
	SceneTransition.fade_to_scene("res://scenes/game.tscn")
   
func play_button_sound():
	AudioManager.play_sound(button_click_sound)

func _on_settings_button_pressed() -> void:
	play_button_sound()
	audio_settings.visible = true

func _on_exit_button_pressed() -> void:
	play_button_sound()
	await get_tree().create_timer(0.15).timeout
	get_tree().quit()

func close_audio_settings():
	play_button_sound()
	audio_settings.visible = false

func toggle_music(enabled: bool):
	AudioManager.set_music_enabled(enabled)
	AudioManager.save_audio_settings(
		enabled,
		sfx_button.button_pressed
	)

func toggle_sfx(enabled: bool):
	AudioManager.set_sfx_enabled(enabled)
	AudioManager.save_audio_settings(
		music_button.button_pressed,
		enabled
	)

func button_hover(button: Button):
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.05, 1.05), 0.1)

func button_exit(button: Button):
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2.ONE, 0.1)

func _on_play_button_mouse_entered() -> void:
	button_hover($PlayButton)

func _on_play_button_mouse_exited() -> void:
	button_exit($PlayButton)

func _on_settings_button_mouse_entered() -> void:
	button_hover($SettingsButton)

func _on_settings_button_mouse_exited() -> void:
	button_exit($SettingsButton)

func _on_exit_button_mouse_entered() -> void:
	button_hover($ExitButton)
func _on_exit_button_mouse_exited() -> void:
	button_exit($ExitButton)

func animate_title():
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property($Title, "scale", Vector2(1.05, 1.05), 1.0)
	tween.tween_property($Title, "scale", Vector2.ONE, 1.0)
