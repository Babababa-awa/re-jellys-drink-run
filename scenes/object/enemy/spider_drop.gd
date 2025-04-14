extends BaseNode2D

@export var max_drop_height: int = 6

func _ready() -> void:
	super._ready()
	
	_update_field()
	
	%Spider.life.kill_after.connect(_on_life_kill_after)
	
func _update_field() -> void:
	var offset_x: int = -1
	var offset_y: int = 0
	
	for y in max_drop_height:
		for x in 2:
			%Field.set_cell(
				Vector2i(offset_x + x, offset_y + y), 
				%Field.tile_set.get_source_id(0), 
				Vector2i(0, 0)
			)
			
	offset_y = max_drop_height
	
	for y in 2:
		for x in 2:
			%Field.set_cell(
				Vector2i(offset_x + x, offset_y + y), 
				%Field.tile_set.get_source_id(0), 
				Vector2i(1, 3) # Move up
			)
			
func ready() -> void:
	super.ready()

	%Spider.set_unit_mode(Core.UnitMode.CLIMBING)
	%Spider.field.move_down()

			
func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or 
		reset_type_ == Core.ResetType.RESTART
	):
		%Spider.visible = true
		%Spider.is_enabled = true
		%Spider.position = Vector2.ZERO
		
		
func stop() -> void:
	super.stop()
	
	%Spider.is_enabled = false
	%Spider.visible = false
	%Spider.position = Core.DEAD_ZONE
	
func _process(delta_: float) -> void:
	super._process(delta_)
		
	if not is_running():
		return
		
	if %Spider.life.is_killed:
		return
		
	%Line2DWeb.points[1].y = %Spider.position.y
	
func _on_life_kill_after(_reason: StringName) -> void:
	stop()
