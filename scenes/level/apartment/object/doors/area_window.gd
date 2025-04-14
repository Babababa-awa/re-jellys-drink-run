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
	var offset = 5
	
	for i in range(0, 4):
		%Window.set_cell(Vector2i(i, -1), %Window.tile_set.get_source_id(0), Vector2i(0 + i, offset + 4))
		%Window.set_cell(Vector2i(i, -2), %Window.tile_set.get_source_id(0), Vector2i(0 + i, offset + 3))
		%Window.set_cell(Vector2i(i, -3), %Window.tile_set.get_source_id(0), Vector2i(0 + i, offset + 2))
		%Window.set_cell(Vector2i(i, -4), %Window.tile_set.get_source_id(0), Vector2i(0 + i, offset + 1))
		%Window.set_cell(Vector2i(i, -5), %Window.tile_set.get_source_id(0), Vector2i(0 + i, offset + 0))
		
func _open_door(step: int) -> void:
	var offset = 5

	if step == 1:
		for i in range(0, 4):
			%Window.set_cell(Vector2i(i, -1), %Window.tile_set.get_source_id(0), Vector2i(4 + i, offset + 4))
			%Window.set_cell(Vector2i(i, -2), %Window.tile_set.get_source_id(0), Vector2i(4 + i, offset + 3))
			%Window.set_cell(Vector2i(i, -3), %Window.tile_set.get_source_id(0), Vector2i(4 + i, offset + 2))
			%Window.set_cell(Vector2i(i, -4), %Window.tile_set.get_source_id(0), Vector2i(4 + i, offset + 1))
			%Window.set_cell(Vector2i(i, -5), %Window.tile_set.get_source_id(0), Vector2i(4 + i, offset + 0))
	else:
		for i in range(0, 4):
			%Window.set_cell(Vector2i(i, -1), %Window.tile_set.get_source_id(0), Vector2i(8 + i, offset + 4))
			%Window.set_cell(Vector2i(i, -2), %Window.tile_set.get_source_id(0), Vector2i(8 + i, offset + 3))
			%Window.set_cell(Vector2i(i, -3), %Window.tile_set.get_source_id(0), Vector2i(8 + i, offset + 2))
			%Window.set_cell(Vector2i(i, -4), %Window.tile_set.get_source_id(0), Vector2i(8 + i, offset + 1))
			%Window.set_cell(Vector2i(i, -5), %Window.tile_set.get_source_id(0), Vector2i(8 + i, offset + 0))

func _close_door(step: int) -> void:
	var offset = 5

	if step == 1:
		for i in range(0, 4):
			%Window.set_cell(Vector2i(i, -1), %Window.tile_set.get_source_id(0), Vector2i(4 + i, offset + 4))
			%Window.set_cell(Vector2i(i, -2), %Window.tile_set.get_source_id(0), Vector2i(4 + i, offset + 3))
			%Window.set_cell(Vector2i(i, -3), %Window.tile_set.get_source_id(0), Vector2i(4 + i, offset + 2))
			%Window.set_cell(Vector2i(i, -4), %Window.tile_set.get_source_id(0), Vector2i(4 + i, offset + 1))
			%Window.set_cell(Vector2i(i, -5), %Window.tile_set.get_source_id(0), Vector2i(4 + i, offset + 0))
	else:
		for i in range(0, 4):
			%Window.set_cell(Vector2i(i, -1), %Window.tile_set.get_source_id(0), Vector2i(0 + i, offset + 4))
			%Window.set_cell(Vector2i(i, -2), %Window.tile_set.get_source_id(0), Vector2i(0 + i, offset + 3))
			%Window.set_cell(Vector2i(i, -3), %Window.tile_set.get_source_id(0), Vector2i(0 + i, offset + 2))
			%Window.set_cell(Vector2i(i, -4), %Window.tile_set.get_source_id(0), Vector2i(0 + i, offset + 1))
			%Window.set_cell(Vector2i(i, -5), %Window.tile_set.get_source_id(0), Vector2i(0 + i, offset + 0))
