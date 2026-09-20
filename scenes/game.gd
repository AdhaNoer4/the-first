extends Node2D

@export var game_over_sound: AudioStream

@onready var player = $Player
@onready var health_label = $UI/HealthLabel
@onready var health_bar = $UI/HealthBar
@onready var score_label = $UI/ScoreLabel
@onready var restart_button = $UI/GameOverContainer/GameOverBox/RestartButton
@onready var game_over_label = $UI/GameOverContainer/GameOverBox/GameOverLabel
@onready var enemy_spawner = $EnemySpawner
@onready var wave_label = $UI/WaveLabel
@onready var main_menu_button = $UI/GameOverContainer/GameOverBox/MainMenuButton

@onready var audio_settings = $UI/AudioSettings
@onready var music_button = $UI/AudioSettings/VBoxContainer/MusicButton
@onready var sfx_button = $UI/AudioSettings/VBoxContainer/SFXButton
@onready var close_button = $UI/AudioSettings/VBoxContainer/CloseButton
@onready var pause_container = $UI/PauseContainer
@onready var pause_settings_button = $UI/PauseContainer/CenterContainer/PauseBox/PauseSettingsButton
@onready var pause_main_menu_button = $UI/PauseContainer/CenterContainer/PauseBox/PauseMainMenuButton

var score = 0
var wave = 1
var is_paused = false

func _ready():
	player.health_changed.connect(update_health)
	player.player_died.connect(show_game_over)
	restart_button.pressed.connect(restart_game)
	$WaveTimer.timeout.connect(next_wave)
	pause_settings_button.pressed.connect(open_pause_settings)
	pause_main_menu_button.pressed.connect(_on_pause_main_menu_pressed)
	
	game_over_label.visible = false
	restart_button.visible = false
	main_menu_button.visible = false
	
	pause_container.visible = false
	is_paused = false
	get_tree().paused = false
	
	update_health(player.health)
	update_score()
	update_wave()
	
	print("WAVE:", wave)
	print(AudioManager)
	
	close_button.pressed.connect(close_audio_settings)
	music_button.toggled.connect(toggle_music)
	sfx_button.toggled.connect(toggle_sfx)
	
	audio_settings.visible = false
	
	var audio_settings_data = AudioManager.load_audio_settings()

	music_button.button_pressed = audio_settings_data["music_enabled"]
	sfx_button.button_pressed = audio_settings_data["sfx_enabled"]

func add_score(amount):
	score += amount

	update_score()

	print("Score:", score)

func update_health(value):
	health_label.text = "HP: " + str(value)
	health_bar.value = value

func update_score():
	score_label.text = "SCORE: " + str(score).pad_zeros(4)

func update_wave():
	wave_label.text = "WAVE " + str(wave)
	
func next_wave():
	wave += 1
	print("WAVE:", wave)
	
	update_wave()
	
	enemy_spawner.increase_difficulty(wave)
	enemy_spawner.increase_max_enemies(wave)
	enemy_spawner.increase_enemy_chances(wave)

func restart_game():
	get_tree().reload_current_scene()

func show_game_over():
	game_over_label.text = "GAME OVER\nSCORE: " + str(score)
	game_over_label.visible = true
	restart_button.visible = true
	main_menu_button.visible = true
	
	$BGM.stop()
	
	AudioManager.play_sound(game_over_sound)

func close_audio_settings():
	audio_settings.visible = false
	if is_paused:
		pause_container.visible = true
		
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

func _on_main_menu_button_pressed() -> void:
	SceneTransition.fade_to_scene("res://scenes/main_menu.tscn")

func toggle_pause():
	if is_paused:
		resume_game()
	else:
		pause_game()
		
func pause_game():
	is_paused = true
	pause_container.visible = true
	get_tree().paused = true
	
func resume_game():
	is_paused = false
	pause_container.visible = false
	get_tree().paused = false

func _on_resume_button_pressed() -> void:
	resume_game()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func open_pause_settings():
	pause_container.visible = false
	audio_settings.visible = true

func _on_pause_main_menu_pressed() -> void:
	get_tree().paused = false
	is_paused = false
	SceneTransition.fade_to_scene("res://scenes/main_menu.tscn")
