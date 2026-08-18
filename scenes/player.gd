extends CharacterBody2D

var speed = 300.0
var max_health = 3
var health = max_health

func _physics_process(delta):
	
	var direction = Input.get_vector("move_left",
	"move_right",
	"move_up",
	"move_down")
	
	velocity = direction * speed
	
	move_and_slide()

func take_damage(amount):
	health -= amount
	
	print("Player HP:", health)

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		take_damage(1)
