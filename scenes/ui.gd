extends CanvasLayer


@onready var health_label = $HealthLabel
@onready var game_over_label = $GameOverLabel
@onready var restart_button = $RestartButton
@onready var score_label = $ScoreLabel
@onready var game = get_tree().current_scene
@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if player:
		health_label.text = "HP: " + str(player.health)
		
		if player.health <= 0:
			game_over_label.visible = true
			restart_button.visible = true

	score_label.text = "SCORE: " + str(game.score)
	
func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
