extends Node2D

@export var damage = 1
@export var fire_rate = 0.3
@export var projectile_speed = 500.0
@export var pellets = 1
@export var spread = 0.0
@export var projectile_scene: PackedScene
@export var shoot_sound: AudioStream

@onready var player = get_parent()
@onready var muzzle_point = player.get_node("MuzzlePoint")
@onready var muzzle_flash = player.get_node("MuzzleFlash")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$WeaponCooldownTimer.wait_time = fire_rate
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shoot():
	if not $WeaponCooldownTimer.is_stopped():
		return

	print("WEAPON SHOOT!")
	
	player.is_shooting = true
	player.play_shoot_animation()
	
	AudioManager.play_sound(shoot_sound)
	muzzle_flash.position = player.facing_direction * 25.0
	muzzle_flash.visible = true
	
	player.shoot_recoil()
	
	var projectile = projectile_scene.instantiate()

	projectile.global_position = muzzle_point.global_position
	projectile.direction = player.last_direction
	
	projectile.damage = damage
	projectile.speed = projectile_speed

	player.get_parent().add_child(projectile)
	$WeaponCooldownTimer.start()
	
	await get_tree().create_timer(0.06).timeout
	muzzle_flash.visible = false
	
	await get_tree().create_timer(0.04).timeout
	player.is_shooting = false
