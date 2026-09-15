extends Area2D

@export var speed = 500.0
@export var damage = 1

var direction = Vector2.RIGHT

func _physics_process(delta):
	position += direction * speed * delta
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LifetimeTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(damage)
		
		var knockback_direction = body.global_position - global_position
		body.apply_knockback(knockback_direction, 120.0)
		body.hit_stop_effect()
		
		var impact = preload("res://effects/projectile_impact.tscn").instantiate()
		impact.global_position = global_position
		get_parent().add_child(impact)
		
		queue_free()

func _on_lifetime_timer_timeout() -> void:
	queue_free()
