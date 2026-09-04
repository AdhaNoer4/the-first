extends CharacterBody2D

@export var projectile_scene: PackedScene
@export var speed = 200.0

var max_health = 3
var health = max_health
var is_dead = false
var is_invincible = false

var last_direction = Vector2.RIGHT

func _physics_process(delta):
	if is_dead:
		return
		
	var direction = Input.get_vector("move_left",
	"move_right",
	"move_up",
	"move_down")
	
	if direction != Vector2.ZERO:
		last_direction = direction
	
	velocity = direction * speed
	
	move_and_slide()

func take_damage(amount):
	if is_dead:
		return

	if is_invincible:
		return

	health -= amount

	if health < 0:
		health = 0

	print("Player HP:", health)

	if health <= 0:
		die()
		return

	is_invincible = true
	$InvincibilityTimer.start()
	$BlinkTimer.start()
		
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

	$BlinkTimer.stop()
	modulate.a = 1.0

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()
		#var enemies = get_tree().get_nodes_in_group("enemy")
#
		#for enemy in enemies:
			#enemy.take_damage(1)
	
		
func shoot():
	var projectile = projectile_scene.instantiate()

	projectile.global_position = global_position
	projectile.direction = last_direction
	
	get_parent().add_child(projectile)
	
func blink():
	if is_invincible:
		modulate.a = 0.3
	else:
		modulate.a = 1.0


func _on_blink_timer_timeout() -> void:
	if is_invincible:
		modulate.a = 0.3 if modulate.a == 1.0 else 1.0
