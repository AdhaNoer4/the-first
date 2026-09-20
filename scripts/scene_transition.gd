extends Control

@onready var fade = $Fade
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade.modulate.a = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fade_to_scene(scene_path: String):
	fade.modulate.a = 0.0

	var fade_out = create_tween()
	fade_out.set_trans(Tween.TRANS_QUAD)
	fade_out.set_ease(Tween.EASE_IN)
	fade_out.tween_property(fade, "modulate:a", 1.0, 0.3)

	await fade_out.finished

	get_tree().change_scene_to_file(scene_path)

	await get_tree().process_frame

	var fade_in = create_tween()
	fade_in.set_trans(Tween.TRANS_QUAD)
	fade_in.set_ease(Tween.EASE_OUT)
	fade_in.tween_property(fade, "modulate:a", 0.0, 0.3)
