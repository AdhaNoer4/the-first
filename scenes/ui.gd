extends CanvasLayer


@onready var health_label = $HealthLabel
@onready var game_over_label = $GameOverLabel
@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if player:
		health_label.text = "HP: " + str(player.health)
		if player.health <= 0:
			game_over_label.visible = true
