extends BaseNode2D

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	_update()
		
func _update() -> void:
	if Core.player == null:
		visible = false
		return

	var health_actor = Core.player.get_actor_or_null(&"health")
	if health_actor == null:
		visible = false
		return
	
	# 384 = width of bar, -8 with borders, add 4 to work with line offset
	var x = round(376.0 * health_actor.health / health_actor.max_health) + 4
	
	%Line2DCurrent.points[1].x = x
	
