extends "res://scenes/object/component/door.gd"

func _start_open_door_animation() -> bool:
	if not super._start_open_door_animation():
		return false
		
	Core.audio.play_sfx(&"window_open")
	return true

func _start_close_door_animation() -> bool:
	if not super._start_close_door_animation():
		return false
		
	Core.audio.play_sfx(&"window_close")
	return true
	
func _reset_door() -> void:
	var offset = 0
	
	%Window.set_cell(Vector2i(0, -1), %Window.tile_set.get_source_id(0), Vector2i(0, offset + 4))
	%Window.set_cell(Vector2i(0, -2), %Window.tile_set.get_source_id(0), Vector2i(0, offset + 3))
	%Window.set_cell(Vector2i(0, -3), %Window.tile_set.get_source_id(0), Vector2i(0, offset + 2))
	%Window.set_cell(Vector2i(0, -4), %Window.tile_set.get_source_id(0), Vector2i(0, offset + 1))
	%Window.set_cell(Vector2i(0, -5), %Window.tile_set.get_source_id(0), Vector2i(0, offset + 0))

func _open_door(step: int) -> void:
	var offset = 0

	if step == 1:
		%Window.set_cell(Vector2i(0, -1), %Window.tile_set.get_source_id(0), Vector2i(1, offset + 4))
		%Window.set_cell(Vector2i(0, -2), %Window.tile_set.get_source_id(0), Vector2i(1, offset + 3))
		%Window.set_cell(Vector2i(0, -3), %Window.tile_set.get_source_id(0), Vector2i(1, offset + 2))
		%Window.set_cell(Vector2i(0, -4), %Window.tile_set.get_source_id(0), Vector2i(1, offset + 1))
		%Window.set_cell(Vector2i(0, -5), %Window.tile_set.get_source_id(0), Vector2i(1, offset + 0))
	else:
		%Window.set_cell(Vector2i(0, -1), %Window.tile_set.get_source_id(0), Vector2i(2, offset + 4))
		%Window.set_cell(Vector2i(0, -2), %Window.tile_set.get_source_id(0), Vector2i(2, offset + 3))
		%Window.set_cell(Vector2i(0, -3), %Window.tile_set.get_source_id(0), Vector2i(2, offset + 2))
		%Window.set_cell(Vector2i(0, -4), %Window.tile_set.get_source_id(0), Vector2i(2, offset + 1))
		%Window.set_cell(Vector2i(0, -5), %Window.tile_set.get_source_id(0), Vector2i(2, offset + 0))

func _close_door(step: int) -> void:
	var offset = 0

	if step == 1:
		%Window.set_cell(Vector2i(0, -1), %Window.tile_set.get_source_id(0), Vector2i(1, offset + 4))
		%Window.set_cell(Vector2i(0, -2), %Window.tile_set.get_source_id(0), Vector2i(1, offset + 3))
		%Window.set_cell(Vector2i(0, -3), %Window.tile_set.get_source_id(0), Vector2i(1, offset + 2))
		%Window.set_cell(Vector2i(0, -4), %Window.tile_set.get_source_id(0), Vector2i(1, offset + 1))
		%Window.set_cell(Vector2i(0, -5), %Window.tile_set.get_source_id(0), Vector2i(1, offset + 0))
	else:
		%Window.set_cell(Vector2i(0, -1), %Window.tile_set.get_source_id(0), Vector2i(0, offset + 4))
		%Window.set_cell(Vector2i(0, -2), %Window.tile_set.get_source_id(0), Vector2i(0, offset + 3))
		%Window.set_cell(Vector2i(0, -3), %Window.tile_set.get_source_id(0), Vector2i(0, offset + 2))
		%Window.set_cell(Vector2i(0, -4), %Window.tile_set.get_source_id(0), Vector2i(0, offset + 1))
		%Window.set_cell(Vector2i(0, -5), %Window.tile_set.get_source_id(0), Vector2i(0, offset + 0))
