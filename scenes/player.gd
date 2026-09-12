extends CharacterBody2D

signal health_changed
signal player_died

@export var projectile_scene: PackedScene
@export var shoot_sound: AudioStream
@export var speed = 200.0
var normal_speed = speed

var max_health = 3
var health = max_health
var is_dead = false
var is_invincible = false

var last_direction = Vector2.RIGHT
var facing_direction = Vector2.DOWN

func _ready():
	pass

func _physics_process(delta):
	if is_dead:
		return
		
	var direction = Input.get_vector("move_left",
	"move_right",
	"move_up",
	"move_down")
	
	if direction != Vector2.ZERO:
		last_direction = direction
	
		# Tentukan arah hadap berdasarkan gerakan
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				facing_direction = Vector2.RIGHT
			else:
				facing_direction = Vector2.LEFT
		else:
			if direction.y > 0:
				facing_direction = Vector2.DOWN
			else:
				facing_direction = Vector2.UP
		
		# Mainkan animasi walk sesuai arah
		if facing_direction == Vector2.UP:
			if $PlayerAnimation.animation != "walk_up":
				$PlayerAnimation.play("walk_up")
		elif facing_direction == Vector2.DOWN:
			if $PlayerAnimation.animation != "walk_down":
				$PlayerAnimation.play("walk_down")
		elif facing_direction == Vector2.LEFT:
			if $PlayerAnimation.animation != "walk_left":
				$PlayerAnimation.play("walk_left")
		elif facing_direction == Vector2.RIGHT:
			if $PlayerAnimation.animation != "walk_right":
				$PlayerAnimation.play("walk_right")

	else:
		# Mainkan animasi idle sesuai arah terakhir
		if facing_direction == Vector2.UP:
			if $PlayerAnimation.animation != "idle_up":
				$PlayerAnimation.play("idle_up")
		elif facing_direction == Vector2.DOWN:
			if $PlayerAnimation.animation != "idle_down":
				$PlayerAnimation.play("idle_down")
		elif facing_direction == Vector2.LEFT:
			if $PlayerAnimation.animation != "idle_left":
				$PlayerAnimation.play("idle_left")
		elif facing_direction == Vector2.RIGHT:
			if $PlayerAnimation.animation != "idle_right":
				$PlayerAnimation.play("idle_right")
		
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
		
	health_changed.emit(health)

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
	player_died.emit()
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
	if is_dead:
		return
	if not $ShootCooldownTimer.is_stopped():
		return
		
	AudioManager.play_sound(shoot_sound)
	
	var projectile = projectile_scene.instantiate()

	projectile.global_position = global_position
	projectile.direction = last_direction
	
	get_parent().add_child(projectile)
	
	$ShootCooldownTimer.start()
	
func blink():
	if is_invincible:
		modulate.a = 0.3
	else:
		modulate.a = 1.0

func _on_blink_timer_timeout() -> void:
	if is_invincible:
		modulate.a = 0.3 if modulate.a == 1.0 else 1.0

func heal(amount):
	if is_dead:
		return

	health += amount
	health = min(health, max_health)

	health_changed.emit(health)

	print("Player healed! HP:", health)

func speed_boost(duration):
	speed = normal_speed * 2.0

	print("SPEED BOOST AKTIF!")

	await get_tree().create_timer(duration).timeout

	speed = normal_speed

	print("SPEED BOOST SELESAI!")
