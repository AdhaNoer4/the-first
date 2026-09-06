extends Node2D

@export var enemy_scene: PackedScene
@export var fast_enemy_chance = 0.3
@export var tank_enemy_chance = 0.2
@export var max_enemies = 3
@export var min_spawn_distance = 200.0
@onready var spawn_points = [
	$SpawnPoint1,
	$SpawnPoint2,
	$SpawnPoint3,
	$SpawnPoint4
]
var spawn_interval = 2.0
var enemy_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.timeout.connect(spawn_enemy)

func spawn_enemy():
	var player = get_tree().get_first_node_in_group("player")

	if player and player.is_dead:
		$SpawnTimer.stop()
		return

	if enemy_count >= max_enemies:
		return

	var spawn_point = get_valid_spawn_point(player)

	if spawn_point == null:
		return

	var enemy = enemy_scene.instantiate()
	
	var random_type = randf()

	if random_type < tank_enemy_chance:
		enemy.max_health = 5
		enemy.health = enemy.max_health
		enemy.speed = 60.0
		enemy.set_enemy_type("tank")
		print("TANK ENEMY SPAWNED")

	elif random_type < tank_enemy_chance + fast_enemy_chance:
		enemy.max_health = 1
		enemy.health = enemy.max_health
		enemy.speed = 180.0
		enemy.set_enemy_type("fast")
		print("FAST ENEMY SPAWNED")

	else:
		enemy.max_health = 1
		enemy.health = enemy.max_health
		enemy.speed = 100.0
		enemy.set_enemy_type("normal")
		print("NORMAL ENEMY SPAWNED")
		
	enemy.global_position = spawn_point.global_position

	add_child(enemy)
	enemy.died.connect(_on_enemy_died)
	enemy_count += 1
	print("Enemy Spawned. Count:", enemy_count)
	
	spawn_interval -= 0.05
	spawn_interval = max(spawn_interval, 0.5)

	$SpawnTimer.wait_time = spawn_interval
	
func get_valid_spawn_point(player):
	var available_points = spawn_points.duplicate()

	available_points.shuffle()

	for spawn_point in available_points:
		var distance = spawn_point.global_position.distance_to(player.global_position)

		if distance >= min_spawn_distance:
			return spawn_point

	return null

func _on_enemy_died():
	enemy_count -= 1
	print("Enemy Died. Count:", enemy_count)

func increase_difficulty(wave):
	spawn_interval = max(2.0 - ((wave - 1) * 0.2), 0.5)
	$SpawnTimer.wait_time = spawn_interval
	
	print("Difficulty meningkat!")
	print("Wave:", wave)
	print("Spawn Interval:", spawn_interval)

func increase_max_enemies(wave):
	max_enemies = 2 + wave
	print("Max Enemy:", max_enemies)

func increase_enemy_chances(wave):
	fast_enemy_chance = min(0.3 + ((wave - 1) * 0.05), 0.5)
	tank_enemy_chance = min(0.2 + ((wave - 1) * 0.05), 0.4)

	print("Fast Chance:", fast_enemy_chance)
	print("Tank Chance:", tank_enemy_chance)
