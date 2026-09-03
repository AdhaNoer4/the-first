extends Node2D

@export var enemy_scene: PackedScene
@export var max_enemies = 3
@export var min_spawn_distance = 200.0
@onready var spawn_points = [
	$SpawnPoint1,
	$SpawnPoint2,
	$SpawnPoint3,
	$SpawnPoint4
]
var spawn_interval = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.timeout.connect(spawn_enemy)

func spawn_enemy():
	var player = get_tree().get_first_node_in_group("player")

	if player and player.is_dead:
		$SpawnTimer.stop()
		return

	var current_enemies = get_tree().get_nodes_in_group("enemy").size()

	if current_enemies >= max_enemies:
		return

	var spawn_point = get_valid_spawn_point(player)

	if spawn_point == null:
		return

	var enemy = enemy_scene.instantiate()

	enemy.global_position = spawn_point.global_position

	add_child(enemy)

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
