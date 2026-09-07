extends Node2D

@export var health_power_up_scene: PackedScene
var power_up_active = false
@onready var spawn_points = [
	$SpawnPoint1,
	$SpawnPoint2,
	$SpawnPoint3,
	$SpawnPoint4
]


func _ready() -> void:
	$SpawnTimer.timeout.connect(spawn_power_up)


func spawn_power_up():
	if power_up_active:
		return
		
	var power_up = health_power_up_scene.instantiate()

	var spawn_point = spawn_points.pick_random()

	power_up.global_position = spawn_point.global_position

	add_child(power_up)
	
	power_up.picked_up.connect(_on_power_up_picked_up)
	
	power_up_active = true

	print("Health Power-Up spawned!")

func _on_power_up_picked_up():
	power_up_active = false

	print("Power-Up diambil! Spawner siap spawn lagi.")
