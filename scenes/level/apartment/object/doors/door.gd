extends "res://scenes/object/component/door.gd"

@export_enum("Wooden", "Fire") var door_style: String = "Wooden"

func _reset_door() -> void:
	var offset = 0
	
	match door_style:
		"Fire":
			offset = 6
			
	%Door.set_cell(Vector2i(0, -1))
	%Door.set_cell(Vector2i(0, -2))
	%Door.set_cell(Vector2i(0, -3))
	%Door.set_cell(Vector2i(1, -1), %Door.tile_set.get_source_id(0), Vector2i(0, offset + 2))
	%Door.set_cell(Vector2i(1, -2), %Door.tile_set.get_source_id(0), Vector2i(0, offset + 1))
	%Door.set_cell(Vector2i(1, -3), %Door.tile_set.get_source_id(0), Vector2i(0, offset + 0))
	%Door.set_cell(Vector2i(2, -1))
	%Door.set_cell(Vector2i(2, -2))
	%Door.set_cell(Vector2i(2, -3))

func _start_open_door_animation() -> bool:
	if not super._start_open_door_animation():
		return false
		
	Core.audio.play_sfx(&"door_open")
	return true

func _start_close_door_animation() -> bool:
	if not super._start_close_door_animation():
		return false
		
	Core.audio.play_sfx(&"door_close")
	return true

func _open_door_left(step: int):
	var offset = 0
	
	match door_style:
		"Fire":
			offset = 6
	
	if step == 1:
		%Door.set_cell(Vector2i(1, -1), %Door.tile_set.get_source_id(0), Vector2i(1, offset + 2))
		%Door.set_cell(Vector2i(1, -2), %Door.tile_set.get_source_id(0), Vector2i(1, offset + 1))
		%Door.set_cell(Vector2i(1, -3), %Door.tile_set.get_source_id(0), Vector2i(1, offset + 0))
		%Door.set_cell(Vector2i(2, -1), %Door.tile_set.get_source_id(0), Vector2i(2, offset + 2))
		%Door.set_cell(Vector2i(2, -2), %Door.tile_set.get_source_id(0), Vector2i(2, offset + 1))
		%Door.set_cell(Vector2i(2, -3), %Door.tile_set.get_source_id(0), Vector2i(2, offset + 0))
	else:
		%Door.set_cell(Vector2i(1, -1), %Door.tile_set.get_source_id(0), Vector2i(3, offset + 2))
		%Door.set_cell(Vector2i(1, -2), %Door.tile_set.get_source_id(0), Vector2i(3, offset + 1))
		%Door.set_cell(Vector2i(1, -3), %Door.tile_set.get_source_id(0), Vector2i(3, offset + 0))
		%Door.set_cell(Vector2i(2, -1), %Door.tile_set.get_source_id(0), Vector2i(4, offset + 2))
		%Door.set_cell(Vector2i(2, -2), %Door.tile_set.get_source_id(0), Vector2i(4, offset + 1))
		%Door.set_cell(Vector2i(2, -3), %Door.tile_set.get_source_id(0), Vector2i(4, offset + 0))

func _close_door_left(step: int):
	var offset = 0
	
	match door_style:
		"Fire":
			offset = 6
			
	if step == 1:
		%Door.set_cell(Vector2i(1, -1), %Door.tile_set.get_source_id(0), Vector2i(1, offset + 2))
		%Door.set_cell(Vector2i(1, -2), %Door.tile_set.get_source_id(0), Vector2i(1, offset + 1))
		%Door.set_cell(Vector2i(1, -3), %Door.tile_set.get_source_id(0), Vector2i(1, offset + 0))
		%Door.set_cell(Vector2i(2, -1), %Door.tile_set.get_source_id(0), Vector2i(2, offset + 2))
		%Door.set_cell(Vector2i(2, -2), %Door.tile_set.get_source_id(0), Vector2i(2, offset + 1))
		%Door.set_cell(Vector2i(2, -3), %Door.tile_set.get_source_id(0), Vector2i(2, offset + 0))
	else:
		%Door.set_cell(Vector2i(1, -1), %Door.tile_set.get_source_id(0), Vector2i(0, offset + 2))
		%Door.set_cell(Vector2i(1, -2), %Door.tile_set.get_source_id(0), Vector2i(0, offset + 1))
		%Door.set_cell(Vector2i(1, -3), %Door.tile_set.get_source_id(0), Vector2i(0, offset + 0))
		%Door.set_cell(Vector2i(2, -1))
		%Door.set_cell(Vector2i(2, -2))
		%Door.set_cell(Vector2i(2, -3))

func _open_door_right(step: int):
	var offset = 0
	
	match door_style:
		"Fire":
			offset = 6
			
	if step == 1:
		%Door.set_cell(Vector2i(0, -1), %Door.tile_set.get_source_id(0), Vector2i(5, offset + 2))
		%Door.set_cell(Vector2i(0, -2), %Door.tile_set.get_source_id(0), Vector2i(5, offset + 1))
		%Door.set_cell(Vector2i(0, -3), %Door.tile_set.get_source_id(0), Vector2i(5, offset + 0))
		%Door.set_cell(Vector2i(1, -1), %Door.tile_set.get_source_id(0), Vector2i(6, offset + 2))
		%Door.set_cell(Vector2i(1, -2), %Door.tile_set.get_source_id(0), Vector2i(6, offset + 1))
		%Door.set_cell(Vector2i(1, -3), %Door.tile_set.get_source_id(0), Vector2i(6, offset + 0))
	else:
		%Door.set_cell(Vector2i(0, -1), %Door.tile_set.get_source_id(0), Vector2i(7, offset + 2))
		%Door.set_cell(Vector2i(0, -2), %Door.tile_set.get_source_id(0), Vector2i(7, offset + 1))
		%Door.set_cell(Vector2i(0, -3), %Door.tile_set.get_source_id(0), Vector2i(7, offset + 0))
		%Door.set_cell(Vector2i(1, -1), %Door.tile_set.get_source_id(0), Vector2i(8, offset + 2))
		%Door.set_cell(Vector2i(1, -2), %Door.tile_set.get_source_id(0), Vector2i(8, offset + 1))
		%Door.set_cell(Vector2i(1, -3), %Door.tile_set.get_source_id(0), Vector2i(8, offset + 0))

func _close_door_right(step: int):
	var offset = 0
	
	match door_style:
		"Fire":
			offset = 6
			
	if step == 1:
		%Door.set_cell(Vector2i(0, -1), %Door.tile_set.get_source_id(0), Vector2i(5, offset + 2))
		%Door.set_cell(Vector2i(0, -2), %Door.tile_set.get_source_id(0), Vector2i(5, offset + 1))
		%Door.set_cell(Vector2i(0, -3), %Door.tile_set.get_source_id(0), Vector2i(5, offset + 0))
		%Door.set_cell(Vector2i(1, -1), %Door.tile_set.get_source_id(0), Vector2i(6, offset + 2))
		%Door.set_cell(Vector2i(1, -2), %Door.tile_set.get_source_id(0), Vector2i(6, offset + 1))
		%Door.set_cell(Vector2i(1, -3), %Door.tile_set.get_source_id(0), Vector2i(6, offset + 0))
	else:
		%Door.set_cell(Vector2i(0, -1))
		%Door.set_cell(Vector2i(0, -2))
		%Door.set_cell(Vector2i(0, -3))
		%Door.set_cell(Vector2i(1, -1), %Door.tile_set.get_source_id(0), Vector2i(0, offset + 2))
		%Door.set_cell(Vector2i(1, -2), %Door.tile_set.get_source_id(0), Vector2i(0, offset + 1))
		%Door.set_cell(Vector2i(1, -3), %Door.tile_set.get_source_id(0), Vector2i(0, offset + 0))
