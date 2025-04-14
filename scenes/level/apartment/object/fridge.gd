extends Node2D

signal fridge_opened
signal fridge_closed

var timer: StepTimer = StepTimer.new(1)
var animation_alias: StringName = &""
var is_on: bool = false

var is_in_vicinity: bool = false

func _process(delta: float) -> void:
	if Core.game.is_paused:
		return
		
	timer.process(delta)
	
	if _start_open_fridge_animation():
		Core.audio.play_sfx(&"fridge_open")
		is_on = true
	elif _start_close_fridge_animation():
		Core.audio.play_sfx(&"fridge_close")
		is_on = false
	elif timer.requires_update:
		match animation_alias:
			&"open_fridge":
				_open_fridge(timer.current_step)
			&"close_fridge":
				_close_fridge(timer.current_step)
	elif timer.is_complete:
		timer.stop()
		match animation_alias:
			&"open_fridge":
				fridge_opened.emit()
			&"close_fridge":
				fridge_closed.emit()
			
func _start_open_fridge_animation() -> bool:
	if timer.is_active:
		return false
		
	if not is_in_vicinity:
		return false
		
	if is_on:
		return false
		
	if not Input.is_action_just_pressed(&"player_interact"):
		return false
	
	animation_alias = &"open_fridge"
	timer.start()
	return true

	
func _start_close_fridge_animation() -> bool:
	if timer.is_active or not is_on:
		return false
		
	if is_in_vicinity:
		return false

	animation_alias = &"close_fridge"
	timer.start()
	return true


func _open_fridge(step: int) -> void:
	if step == 1:
		%Fridge.set_cell(Vector2i(0, -1), %Fridge.tile_set.get_source_id(0), Vector2i(2, 2))
		%Fridge.set_cell(Vector2i(0, -2), %Fridge.tile_set.get_source_id(0), Vector2i(2, 1))
		%Fridge.set_cell(Vector2i(0, -3), %Fridge.tile_set.get_source_id(0), Vector2i(2, 0))
		%Fridge.set_cell(Vector2i(1, -1), %Fridge.tile_set.get_source_id(0), Vector2i(3, 2))
		%Fridge.set_cell(Vector2i(1, -2), %Fridge.tile_set.get_source_id(0), Vector2i(3, 1))
		%Fridge.set_cell(Vector2i(1, -3), %Fridge.tile_set.get_source_id(0), Vector2i(3, 0))

func _close_fridge(step: int):
	if step == 1:
		%Fridge.set_cell(Vector2i(0, -1), %Fridge.tile_set.get_source_id(0), Vector2i(0, 2))
		%Fridge.set_cell(Vector2i(0, -2), %Fridge.tile_set.get_source_id(0), Vector2i(0, 1))
		%Fridge.set_cell(Vector2i(0, -3), %Fridge.tile_set.get_source_id(0), Vector2i(0, 0))
		%Fridge.set_cell(Vector2i(1, -1), %Fridge.tile_set.get_source_id(0), Vector2i(1, 2))
		%Fridge.set_cell(Vector2i(1, -2), %Fridge.tile_set.get_source_id(0), Vector2i(1, 1))
		%Fridge.set_cell(Vector2i(1, -3), %Fridge.tile_set.get_source_id(0), Vector2i(1, 0))

func _on_area_2d_fridge_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		is_in_vicinity = true

func _on_area_2d_fridge_body_exited(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		is_in_vicinity = false
