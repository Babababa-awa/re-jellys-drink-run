extends EnemyPlatformerUnit

func _init() -> void:
	super._init(&"rrat")
		
	life.kill_before.connect(_on_life_kill_before)
	life.revive_after.connect(_on_life_revive_after)
	life.kill_cooldown_delta = 0.5
	life.health_on_revive = 100.0

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
		%Feet.play("move")
		%Tail.play("move")
	else:
		%Body.play("idle")
		%Feet.play("idle")
		%Tail.play("idle")
		
	if unit_direction_x == Core.UnitDirection.RIGHT:
		%Body.flip_h = false
		%Feet.flip_h = false
		%Tail.flip_h = false
	elif unit_direction_x == Core.UnitDirection.LEFT:
		%Body.flip_h = true
		%Feet.flip_h = true
		%Tail.flip_h = true
	else:
		%Body.flip_h = false
		%Feet.flip_h = false
		%Tail.flip_h = false

func _on_life_kill_before(_reason: StringName) -> void:	
	%Area2DAttack.monitorable = false
	%Area2DAttack.monitoring = false
	%Area2DDamage.monitorable = false
	%Area2DDamage.monitoring = false
	
	%Body.play("dead")
	%Feet.play("dead")
	%Tail.play("dead")
	Core.audio.play_sfx(&"stab")
	
func _on_life_revive_after(_reason: StringName) -> void:	
	%Area2DAttack.monitorable = true
	%Area2DAttack.monitoring = true
	%Area2DDamage.monitorable = true
	%Area2DDamage.monitoring = true
	
