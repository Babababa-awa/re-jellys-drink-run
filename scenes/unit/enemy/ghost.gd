extends EnemyPlatformerUnit

func _init() -> void:
	super._init(&"ghost")
	
	# Gravity does not apply to ghosts
	fall.is_enabled = false
	fall.is_enabled_default = false

	life.is_enabled = false
	life.is_enabled_default = false
	
func _process(delta_: float) -> void:
	super._process(delta_)
	
	if not is_running():
		return
		
	update_sprite_state()
	
func update_sprite_state() -> void:
	if unit_direction_x == Core.UnitDirection.RIGHT:
		%Body.play("move")
		%Body.flip_h = false
	elif unit_direction_x == Core.UnitDirection.LEFT:
		%Body.play("move")
		%Body.flip_h = true
	else:
		%Body.play("idle")
		%Body.flip_h = false
		
