extends EnemyPlatformerUnit

#TODO: Fix enemy still moving after death, field should auto detect and stop
#when climbing

const EYE_GLANCE_OFFSET: float = 192
const EYE_LOOK_OFFSET: float = 96

func _init() -> void:
	super._init(&"spider")
	
	life.kill_before.connect(_on_life_kill_before)
	life.revive_after.connect(_on_life_revive_after)
	life.kill_cooldown_delta = 0.5
	life.health_on_revive = 100.0
	
	climb.normal_climbing_speed = 80
	
func ready() -> void:
	super.ready()
	
	%Area2DAttack.monitorable = true
	%Area2DAttack.monitoring = true
	%Area2DDamage.monitorable = true
	%Area2DDamage.monitoring = true

func _process(delta_: float) -> void:
	super._process(delta_)
	
	if not is_running():
		return
	
	if not life.is_killed:
		update_sprite_state()
	
func update_sprite_state() -> void:
	if is_moving():
		%Body.play("move")
	else:
		%Body.play("idle")
	
	if Core.player == null:
		%Eyes.play(&"center")
		return
		
	var player_position_ = Core.player.get_align_global_position(Core.Alignment.CENTER_CENTER)
	
	var distance = player_position_.distance_to(global_position)
	
	if distance > EYE_GLANCE_OFFSET:
		%Eyes.play(&"center")	
		return
		
	if distance > EYE_LOOK_OFFSET:
		if player_position_.x + EYE_LOOK_OFFSET < global_position.x:
			%Eyes.play(&"glance_left")
			return
			
		if player_position_.x - EYE_LOOK_OFFSET > global_position.x:
			%Eyes.play(&"glance_right")
			return
			
		if player_position_.y + EYE_LOOK_OFFSET < global_position.y:
			%Eyes.play(&"glance_top")
			return
			
		if player_position_.y - EYE_LOOK_OFFSET > global_position.y:
			%Eyes.play(&"glance_bottom")
			return
		
	%Eyes.play(_get_eye_animation(player_position_))
	
func _get_eye_animation(player_position_: Vector2) -> StringName:
	var direction = (player_position_ - global_position).normalized()
	var angle = direction.angle()

	var deg = rad_to_deg(angle)
	
	# Normalize to 0-360 range
	if deg < 0:
		deg += 360

	if deg >= 337.5 or deg < 22.5:
		return &"right"
	elif deg < 67.5:
		return &"bottom_right"
	elif deg < 112.5:
		return &"bottom"
	elif deg < 157.5:
		return &"bottom_left"
	elif deg < 202.5:
		return &"left"
	elif deg < 247.5:
		return &"top_left"
	elif deg < 292.5:
		return &"top"
	elif deg < 337.5:
		return &"top_right"

	return &"center"

func _on_life_kill_before(_reason: StringName) -> void:
	%Area2DAttack.monitorable = false
	%Area2DAttack.monitoring = false
	%Area2DDamage.monitorable = false
	%Area2DDamage.monitoring = false
	
	%Body.play("dead")
	%Eyes.play("dead")
	Core.audio.play_sfx(&"stab")
	
func _on_life_revive_after(_reason: StringName) -> void:
	%Area2DAttack.monitorable = true
	%Area2DAttack.monitoring = true
	%Area2DDamage.monitorable = true
	%Area2DDamage.monitoring = true
