extends Node2D

var is_on_matress: bool = false

func _process(_delta: float) -> void:
	if is_on_matress and Input.is_action_just_pressed(&"player_jump"):
		Core.audio.play_sfx(&"boing")

func _on_area_2d_matress_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		is_on_matress = true


func _on_area_2d_matress_body_exited(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		is_on_matress = false
