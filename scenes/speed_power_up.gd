extends Area2D

signal picked_up

@export var pickup_sound: AudioStream

var start_position: Vector2
var time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = position
	print("Speed Power-Up siap!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta

	position.y = start_position.y + sin(time * 3.0) * 5.0

	var pulse = 1.0 + sin(time * 4.0) * 0.08
	scale = Vector2(pulse, pulse)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.speed_boost(5.0)
		AudioManager.play_sound(pickup_sound)
		picked_up.emit()
		await get_tree().create_timer(0.2).timeout
		queue_free()
