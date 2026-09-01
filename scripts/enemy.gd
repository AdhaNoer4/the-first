extends CharacterBody2D

var speed = 100.0
var player: Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player:
		if player.is_dead:
			velocity = Vector2.ZERO
			return
		var direction = global_position.direction_to(player.global_position)

		velocity = direction * speed

		move_and_slide()
