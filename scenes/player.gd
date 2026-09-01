extends CharacterBody2D

var speed = 300.0
var max_health = 3
var health = max_health
var is_dead = false
var is_invincible = false

func _physics_process(delta):
	if is_dead:
		return
		
	var direction = Input.get_vector("move_left",
	"move_right",
	"move_up",
	"move_down")
	
	velocity = direction * speed
	
	move_and_slide()

func take_damage(amount):
	if is_dead or is_invincible:
		return
		
	health -= amount
	health = clamp(health, 0, max_health)
	
	print("Player HP:", health)
	
	if health <= 0:
		die()
	else:
		start_invincibility()
		
func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		take_damage(1)

func die():
	is_dead = true
	velocity = Vector2.ZERO
	print("Player mati!")

func start_invincibility():
	is_invincible = true
	$InvincibilityTimer.start()
	
func _on_invincibility_timer_timeout() -> void:
	is_invincible = false
