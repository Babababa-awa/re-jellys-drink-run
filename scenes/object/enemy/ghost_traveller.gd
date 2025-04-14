extends BaseNode2D

@export var start_direction_x: Core.UnitDirection = Core.UnitDirection.RIGHT
@export var max_travel_width: int = 10
@export var target_player: bool = false
@export var move_speed: float = 80.0
@export var move_speed_modifier: float = 0.0

func _ready() -> void:
	super._ready()
	
	_update_field()
	
	%Ghost.move.normal_move_speed = move_speed + randf_range(-move_speed_modifier, move_speed_modifier)

func _update_field() -> void:
	var offset_x: int = 2
	var offset_y: int = -3
	
	for x in max_travel_width:
		for y in 3:
			%Field.set_cell(
				Vector2i(offset_x + x, offset_y + y), 
				%Field.tile_set.get_source_id(0), 
				Vector2i(0, 0) # Field
			)
			
	offset_x = max_travel_width + 2
	
	for x in 2:
		for y in 3:
			%Field.set_cell(
				Vector2i(offset_x + x, offset_y + y), 
				%Field.tile_set.get_source_id(0), 
				Vector2i(1, 1) # Move left
			)
			
func ready() -> void:
	super.ready()

	%Ghost.set_unit_mode(Core.UnitMode.NORMAL)
	
	if _get_start_direction_x() == Core.UnitDirection.LEFT:
		%Ghost.field.move_left()
	else:
		%Ghost.field.move_right()

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or 
		reset_type_ == Core.ResetType.RESTART
	):
		%Ghost.visible = true
		%Ghost.is_enabled = true
		%Ghost.position = _get_ghost_start_position()
		
		
func stop() -> void:
	super.stop()
	
	%Ghost.is_enabled = false
	%Ghost.visible = false
	%Ghost.position = Core.DEAD_ZONE

func _get_ghost_start_position() -> Vector2:
	return Vector2(
		(2.0 + max_travel_width / 2.0) * Core.FIELD_TILE_SIZE,
		0,
	)
	
func _get_start_direction_x() -> Core.UnitDirection:
	if not target_player or Core.player == null:
		return start_direction_x
		
	if Core.player.global_position.x < (global_position.x + _get_ghost_start_position().x):
		return Core.UnitDirection.LEFT

	return  Core.UnitDirection.RIGHT
