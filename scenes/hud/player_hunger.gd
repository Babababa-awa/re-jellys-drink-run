extends BaseNode2D

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	_update()
		
func _update() -> void:	
	if Core.player == null:
		visible = false
		return

	var hunger_actor = Core.player.get_actor_or_null(&"hunger")
	if hunger_actor == null:
		visible = false
		return

	visible = true
	
	# 384 = width of bar, -8 with borders, add 4 to work with line offset
	var x = round(376.0 * hunger_actor.hunger / hunger_actor.max_hunger) + 4
	
	%Line2DCurrent.points[1].x = x
	
