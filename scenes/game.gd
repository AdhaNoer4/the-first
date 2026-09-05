extends Node2D

@onready var player = $Player
@onready var health_label = $UI/HealthLabel
@onready var health_bar = $UI/HealthBar
@onready var score_label = $UI/ScoreLabel
@onready var restart_button = $UI/GameOverContainer/GameOverBox/RestartButton
@onready var game_over_label = $UI/GameOverContainer/GameOverBox/GameOverLabel

var score = 0


func _ready():
	player.health_changed.connect(update_health)
	player.player_died.connect(show_game_over)

	restart_button.pressed.connect(restart_game)
	
	game_over_label.visible = false
	restart_button.visible = false
	
	update_health(player.health)
	update_score()


func add_score(amount):
	score += amount

	update_score()

	print("Score:", score)


func update_health(value):
	health_label.text = "HP: " + str(value)
	health_bar.value = value

func update_score():
	score_label.text = "SCORE: " + str(score).pad_zeros(4)


func restart_game():
	get_tree().reload_current_scene()

func show_game_over():
	game_over_label.text = "GAME OVER\nSCORE: " + str(score)
	game_over_label.visible = true
	restart_button.visible = true
