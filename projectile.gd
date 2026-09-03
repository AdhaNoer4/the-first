extends Area2D

@export var speed = 500.0
@export var damage = 1

var direction = Vector2.RIGHT

func _physics_process(delta):
	position += direction * speed * delta
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(damage)
		queue_free()
