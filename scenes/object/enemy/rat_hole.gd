extends BaseNode2D

@export var start_direction: Core.UnitDirection = Core.UnitDirection.RIGHT
@export var target_player: bool = false
@export var respawn_delta: float = 4.0
@export var move_speed: float = 80.0
@export var move_speed_modifier: float = 0.0

var _direction: Core.UnitDirection = Core.UnitDirection.RIGHT

# To line up with rat exit animation
const CENTER_POSITION: Vector2 = Vector2(144, 0)
const RAT_START_OFFSET: Vector2 = Vector2(22.0, 0)

var _respawn_cooldown: CooldownTimer = CooldownTimer.new()

func _ready() -> void:
	super._ready()

	_respawn_cooldown.delta = respawn_delta
	%RratExit.animation_finished.connect(_on_animation_finished)
	%Rrat.life.kill_after.connect(_on_life_kill_after)
	%Rrat.move.normal_move_speed = move_speed + randf_range(-move_speed_modifier, move_speed_modifier)

func ready() -> void:
	%Rrat.set_unit_mode(Core.UnitMode.NORMAL)
	
func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or 
		reset_type_ == Core.ResetType.RESTART
	):
		%Rrat.is_enabled = false
		%Rrat.visible = false
		%RratExit.stop()
		%RratExit.visible = false
		
		_start_rat()
		
func stop() -> void:
	super.stop()
	
	%Rrat.is_enabled = false
	%Rrat.visible = false
	%RratExit.stop()
	%RratExit.visible = false

func _start_rat() -> void:
	_update_direction()
		
	%RratExit.play(&"default")
	%RratExit.visible = true
		
func _on_animation_finished():
	%RratExit.visible = false
	
	%Rrat.is_enabled = true
	
	if %Rrat.life.is_killed:
		%Rrat.move.normal_move_speed = move_speed + randf_range(-move_speed_modifier, move_speed_modifier)
		%Rrat.life.revive()
	
	if _direction == Core.UnitDirection.RIGHT:
		%Rrat.position = CENTER_POSITION + RAT_START_OFFSET
		%Rrat.field.move_right()
	else:
		%Rrat.position = CENTER_POSITION - RAT_START_OFFSET
		%Rrat.field.move_left()
	
	%Rrat.visible = true

func _on_life_kill_after(_reason: StringName) -> void:
	_respawn_cooldown.start()

func _process(delta_: float) -> void:
	super._process(delta_)
	
	if not is_running():
		return
	
	if not _respawn_cooldown.is_active:
		return
	
	_respawn_cooldown.process(delta_)
	
	if _respawn_cooldown.is_complete:
		_respawn_cooldown.stop()
		_start_rat()

func _update_direction() -> void:
	_direction = start_direction
	
	if target_player and Core.player != null:
		if Core.player.global_position.x < (global_position.x + CENTER_POSITION.x):
			_direction = Core.UnitDirection.LEFT
		else:
			_direction = Core.UnitDirection.RIGHT
	
	if _direction == Core.UnitDirection.LEFT:
		%RratExit.flip_h = true
	else:
		%RratExit.flip_h = false
