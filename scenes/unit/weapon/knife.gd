extends WeaponUnit

#TODO: Collision and ability to throw knife

@onready var animations: AnimationController = %Animations

var _attack_cooldown: CooldownTimer = CooldownTimer.new()

var _current_attack_value: AttackValue = null
var _current_combo_index = -1
var _combo_sequence = [&"stab", &"stab", &"slice"]
var _queue_weapon_attack: WeaponAttack = null
var _queue_meta: Dictionary = {}
var _queue_delta: float = 0.5

var is_used: bool = false

func _init() -> void:
	super._init(
		&"knife", 
		[
			WeaponAttack.new(&"combo"),
			WeaponAttack.new(&"stab", 0.4),
			WeaponAttack.new(&"slice", 0.4),
		]
	)

func _ready() -> void:
	super._ready()
	
	_disable_attack_area()

func _attack_from_weapon_attack(weapon_attack_: WeaponAttack, meta_: Dictionary = {}) -> void:
	if not _attack_cooldown.is_stopped:
		# Queue an attack if cooldown close to end
		if _attack_cooldown.delta - _attack_cooldown.current_delta < _queue_delta:
			_queue_weapon_attack = weapon_attack_
			_queue_meta = meta_.duplicate()
		return
		
	_queue_weapon_attack = null
	_queue_meta = {}
		
	if weapon_attack_.alias == &"combo":
		_current_combo_index += 1
		if _current_combo_index >= _combo_sequence.size():
			_current_combo_index = 0
		
		attack_from_alias(_combo_sequence[_current_combo_index], meta_)
		return
		 
	if weapon_attack_.alias != &"stab" and weapon_attack_.alias != &"slice":
		return
	
	meta_ = meta_.duplicate()
	meta_.weapon_attack_alias = weapon_attack_.alias
		
	var attack_value_ = AttackValue.new(
		Core.AttackType.WEAPON, 
		alias, 
		meta_
	)
	
	attack_value_.node = self
	
	signal_can_attack = true
	
	attack_before.emit(self, attack_value_)
	
	if signal_can_attack:
		# Reset attacks
		_enable_attack_area(weapon_attack_.alias)
		Core.audio.play_sfx(&"swoosh", 3, true)
		
		_current_attack_value = attack_value_
		_attack_cooldown.delta = weapon_attack_.delta
		_attack_cooldown.start()
		
		attack_after.emit(self, attack_value_)
	
func _process(delta_: float) -> void:
	super._process(delta_)
	
	if not is_running():
		return
		
	_attack_cooldown.process(delta_)
	
	if _attack_cooldown.is_complete:
		_attack_cooldown.stop()
		
		_disable_attack_area(_current_attack_value.meta.weapon_attack_alias)
		
		attack_complete.emit(self, _current_attack_value)
		_current_attack_value = null
		
		if _queue_weapon_attack != null:
			_attack_from_weapon_attack(_queue_weapon_attack, _queue_meta)
		
func reset(reset_type_: Core.ResetType) -> void:
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		_current_combo_index = -1
		_attack_cooldown.reset()
		
		if is_used:
			%Animations.set_texture_variant(&"")
			is_used = false

func _on_area_2d_attack_stab_left_body_entered(body_: Node2D) -> void:
	_update_used(body_)

func _on_area_2d_attack_stab_right_body_entered(body_: Node2D) -> void:
	_update_used(body_)

func _on_area_2d_attack_slice_left_body_entered(body_: Node2D) -> void:
	_update_used(body_)

func _on_area_2d_attack_slice_right_body_entered(body_: Node2D) -> void:
	_update_used(body_)

func _on_area_2d_attack_stab_left_area_entered(area_: Area2D) -> void:
	_update_used(area_)

func _on_area_2d_attack_stab_right_area_entered(area_: Area2D) -> void:
	_update_used(area_)

func _on_area_2d_attack_slice_left_area_entered(area_: Area2D) -> void:
	_update_used(area_)
	
func _on_area_2d_attack_slice_right_area_entered(area_: Area2D) -> void:
	_update_used(area_)

func _update_used(node_: Node) -> void:
	if is_used:
		return
		
	var root_unit = Core.get_root_unit(self)
	if root_unit and root_unit.is_ancestor_of(node_):
		return
		
	%Animations.set_texture_variant(&"blood")
	is_used = true

func set_unit_direction_x(unit_direction_x_: Core.UnitDirection) -> void:
	# Only set if left or right since other directions not supported
	if (unit_direction_x_ == Core.UnitDirection.LEFT or
		unit_direction_x_ == Core.UnitDirection.RIGHT
	):
		super.set_unit_direction_x(unit_direction_x_)

func _enable_attack_area(alias_) -> void:
	if alias_ == &"stab":
		if unit_direction_x == Core.UnitDirection.LEFT:
			%Area2DAttackStabLeft.monitoring = true
			%Area2DAttackStabLeft.monitorable = true
			%Area2DAttackStabLeft.position = Vector2.ZERO
		else:
			%Area2DAttackStabRight.monitoring = true
			%Area2DAttackStabRight.monitorable = true
			%Area2DAttackStabRight.position = Vector2.ZERO
	elif alias_ == &"slice":
		if unit_direction_x == Core.UnitDirection.LEFT:
			%Area2DAttackSliceLeft.monitoring = true
			%Area2DAttackSliceLeft.monitorable = true
			%Area2DAttackSliceLeft.position = Vector2.ZERO
		else:
			%Area2DAttackSliceRight.monitoring = true
			%Area2DAttackSliceRight.monitorable = true
			%Area2DAttackSliceRight.position = Vector2.ZERO
			
func _disable_attack_area(_alias = &"") -> void:
	%Area2DAttackStabLeft.monitoring = false
	%Area2DAttackStabLeft.monitorable = false
	%Area2DAttackStabLeft.position = Core.DEAD_ZONE
	
	%Area2DAttackSliceLeft.monitoring = false
	%Area2DAttackSliceLeft.monitorable = false
	%Area2DAttackSliceLeft.position = Core.DEAD_ZONE
	
	%Area2DAttackStabRight.monitoring = false
	%Area2DAttackStabRight.monitorable = false
	%Area2DAttackStabRight.position = Core.DEAD_ZONE
	
	%Area2DAttackSliceRight.monitoring = false
	%Area2DAttackSliceRight.monitorable = false
	%Area2DAttackSliceRight.position = Core.DEAD_ZONE
