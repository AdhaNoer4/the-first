extends CharacterBody2D

var speed = 100.0
var player: Node2D
var max_health = 3
var health = max_health
@onready var game = get_tree().current_scene

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

func take_damage(amount):
	health -= amount
	health = clamp(health, 0, max_health)

	print("Enemy HP:", health)

	if health <= 0:
		die()
	
func die():
	game.add_score(10)
	print("Enemy mati!")
	queue_free()
