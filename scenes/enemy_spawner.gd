extends Node2D

@export var enemy_scene: PackedScene
@export var max_enemies = 3
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
		
	var enemy = enemy_scene.instantiate()
	var spawn_point = spawn_points.pick_random()

	enemy.position = spawn_point.position
	add_child(enemy)
	spawn_interval -= 0.05
	spawn_interval = max(spawn_interval, 0.5)

	$SpawnTimer.wait_time = spawn_interval
