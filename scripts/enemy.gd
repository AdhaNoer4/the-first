extends CharacterBody2D
signal died

var speed = 100.0
var player: Node2D
var max_health = 3
var health = max_health
@onready var game = get_tree().current_scene

func _ready():
	print("Enemy dibuat")
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

	hit_flash()
	print("Enemy HP:", health)

	if health <= 0:
		die()
	
func die():
	game.add_score(10)
	print("Enemy mati!")
	
	died.emit()
	queue_free()

func hit_flash():
	modulate = Color(1, 0.3, 0.3)
	$HitFlashTimer.start()


func _on_hit_flash_timer_timeout() -> void:
	modulate = Color(1, 1, 1)
