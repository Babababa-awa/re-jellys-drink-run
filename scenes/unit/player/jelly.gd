extends PlayerPlatformerUnit

@onready var animations: AnimationController = %Animations

var is_knife_selected: bool = false
var is_knife_stab: bool = false
var is_knife_stab_animation: bool = false

var is_umbrella_selected: bool = false

var current_ladder_climbing_delta: float = 0.0
var is_starving: bool = false

@onready var center_shapes: Array[CollisionShape2D] = [
	$Area2DDamage/CollisionShape2D,
	$Area2DItem/CollisionShape2D,
	$Area2DWin/CollisionShape2D,
	$Area2DLose/CollisionShape2D,
]
@onready var top_shapes: Array[CollisionShape2D] = [
	$Area2DHead/CollisionShape2D,
]

func _init() -> void:
	super._init(&"jelly")
	
	alignment = Core.Alignment.BOTTOM_CENTER
		
	actors.add_all({
		&"accessory": ItemsActor.new(self),
		&"speech": SpeechActor.new(self),
	})
	
	jump.jump_crouch_behavior = Core.PlatformerBehavior.CROUCH
	climb.climb_jump_behavior = Core.PlatformerBehavior.JUMP
	climb.climb_crouch_behavior = Core.PlatformerBehavior.FALL
	climb.climb_off_behavior = Core.PlatformerBehavior.FALL
	fall.fall_crouch_behavior = Core.PlatformerBehavior.FALL
	
	#weapons.use_before.connect(_on_weapon_use_before)
	weapons.use_after.connect(_on_weapon_use_after)
	weapons.use_complete.connect(_on_weapon_use_complete)
	
	move.slow_move_speed = 60.0
	move.normal_move_speed = 180.0
	move.fast_move_speed = 200.0
	move.auto_reset_locked_direction_x = true
	
	life.lose_on_kill = true
	
	items.slots = 4
	items.unit_alignment = Core.Alignment.BOTTOM_CENTER
	items.item_alignment = Core.Alignment.BOTTOM_CENTER
	items.item_types = [
		Core.ItemType.FOOD,
		Core.ItemType.HEALTH,
		Core.ItemType.HEALTH_FOOD,
		Core.ItemType.KEY,
		Core.ItemType.LOCK_PICK,
		Core.ItemType.KNIFE,
		Core.ItemType.TOOL,
	] as Array[Core.ItemType]
	items.use_after.connect(_on_item_use_after)
	items.pick_up_after.connect(_on_item_pick_up_after)
	
	health.damage_after.connect(_on_health_damage_after)
	
	var accessory_actor = actors.use(&"accessory")
	
	accessory_actor.use_action_enabled = false
	accessory_actor.use_action_enabled_default = false
	
	accessory_actor.drop_action_enabled = false
	accessory_actor.drop_action_enabled_default = false
	
	accessory_actor.item_types = [
		Core.ItemType.ACCESSORY,
	] as Array[Core.ItemType]
	
func _on_item_use_after(item_value_: ItemValue) -> void:
	if item_value_.type == Core.ItemType.HEALTH: 
		Core.audio.play_sfx(&"sigh")
		
		if item_value_.alias == &"cigarettes":
			Core.speech.say(SpeechValue.new(self, "TALK:cigarettes", 2))
	elif item_value_.type == Core.ItemType.FOOD:
		Core.audio.play_sfx(&"eat")
	elif item_value_.type == Core.ItemType.HEALTH_FOOD:
		Core.audio.play_sfx(&"sigh")

func _on_item_pick_up_after(item_value_: ItemValue) -> void:
	Core.audio.play_sfx(&"item_pickup")
	
func _on_health_damage_after(damage: float) -> void:
	if health.health <= 25.0 and health.health + damage > 25.0:
		Core.audio.play_sfx(&"anxiety")
	else:
		Core.audio.play_sfx(&"sorry", 3)
#func _on_weapon_use_before(use_index_: int) -> void:
	#pass

func _on_weapon_use_after(use_index_: int) -> void:
	var attack = weapons.get_weapon_attack(use_index_)
	if attack != null and attack.type == Core.AttackType.WEAPON and attack.alias == &"knife":
		is_knife_stab = true
		
func _on_weapon_use_complete(use_index_: int) -> void:
	var attack = weapons.get_weapon_attack(use_index_)
	if attack != null and attack.type == Core.AttackType.WEAPON and attack.alias == &"knife":
		is_knife_stab = false
		is_knife_stab_animation = false

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if Core.game_difficulty == Core.GameDifficulty.EASY:
		actors.use(&"climb").climb_off_behavior = Core.PlatformerBehavior.NONE
	else:
		actors.use(&"climb").climb_off_behavior = Core.PlatformerBehavior.FALL
	
	is_knife_stab_animation = false
	current_ladder_climbing_delta = false
	is_starving = false
	
	health.health = 75.0
	hunger.hunger = 75.0
	
func _process(delta_: float) -> void:
	super._process(delta_)
	
	if not is_running():
		return
	
	_update_item_state()
	
	_update_knife()
	
	_update_starving()
	
	_play_sounds(delta_)
	
	_update_sprite_state()
	
	_update_body_collision()

func _update_starving() -> void:
	if is_starving:
		if hunger.hunger > 25.0:
			is_starving = false
		return
		
	if hunger.hunger <= 25.0:
		Core.audio.play_sfx(&"hunger")
		is_starving = true	
	

func _play_sounds(delta_: float) -> void:
	if unit_movement == Core.UnitMovement.CLIMBING and is_moving():
		if current_ladder_climbing_delta > 0.5:
			current_ladder_climbing_delta = 0.0

		if current_ladder_climbing_delta == 0.0:
			Core.audio.play_sfx(&"metal_step", 4)

		current_ladder_climbing_delta += delta_
	else:
		current_ladder_climbing_delta = 0.0

func _update_item_state() -> void:
	if items.is_selected_slot_empty():
		if is_knife_selected:
			%Weapons.uses.clear()
			
		is_knife_selected = false
		is_umbrella_selected = false
		return
		
	var selected_item_type = items.get_selected_item_type()
	
	if selected_item_type == Core.ItemType.KNIFE:
		if not is_knife_selected:
			%Weapons.uses.push_back(AttackValue.new(
				Core.AttackType.WEAPON,
				&"knife"
			))
		is_knife_selected = true
		is_umbrella_selected = false
		return
	elif is_knife_selected:
		is_knife_selected = false
		%Weapons.uses.clear()
	
	if (selected_item_type == Core.ItemType.TOOL and 
		items.get_selected_item().alias == &"umbrella"
	):
		is_umbrella_selected = true
	else:
		is_umbrella_selected = false


#func _on_actor_state_changed(
	#actor: BaseActor,
	#state: ActorState,
	#previous_state: ActorState,
#) -> void:
	##if actor.alias == &"health":
		##if state.has(Core.ActorState.STOP):
			##if alias == &"pippa":
				##Core.audio.play_sfx(&"player/" + alias + &"_die", 4, true)
			##else:
				##Core.audio.play_sfx(&"player/" + alias + &"_die", 3, true)
		##elif state.has(Core.ActorState.UPDATE, &"damage"):
			##if actor.health != 0:
				##Core.audio.play_sfx(&"player/" + alias + &"_hit", 3, true)
				
func _update_sprite_state() -> void:
	if is_knife_stab_animation:
		return
		
	var suffixes_: Array[StringName] = []
	
	if move == null:
		play(&"idle", Core.UnitDirection.NONE)
		animations.set_flip_h(false)
		return
	
	if unit_movement == Core.UnitMovement.CLIMBING:
		if is_moving():
			#TODO: Fix climbing up animations
			if unit_direction == Core.UnitDirection.UP:
				play(&"climb", Core.UnitDirection.DOWN)
			else:
				play(&"climb", unit_direction)
		else:
			play(&"climb", Core.UnitDirection.NONE)
		return
	
	if is_knife_stab:
		suffixes_.push_back(&"stab")
		is_knife_stab_animation = true
		move.lock_unit_direction_x()
		set_unit_direction_x(move.locked_direction_x)
	elif is_knife_selected:
		suffixes_.push_back(&"knife")
	
	if unit_direction_x == Core.UnitDirection.NONE:
		if unit_stance == Core.UnitStance.CROUCH:
			play(&"crouch", Core.UnitDirection.NONE, suffixes_)
		elif unit_movement == Core.UnitMovement.JUMPING:
			play(&"jump", Core.UnitDirection.NONE, suffixes_)
		else:
			play(&"idle", Core.UnitDirection.NONE, suffixes_)
	else:
		if unit_stance == Core.UnitStance.CROUCH:
			play(&"crouch", unit_direction_x, suffixes_)
		elif unit_movement == Core.UnitMovement.JUMPING:
			play(&"jump", unit_direction_x, suffixes_)
		elif is_moving():
			if unit_speed == Core.UnitSpeed.SLOW:
				play(&"move_slow", unit_direction_x, suffixes_)
			elif unit_speed == Core.UnitSpeed.FAST:
				play(&"move_fast", unit_direction_x, suffixes_)
			else:
				play(&"move", unit_direction_x, suffixes_)
		else:
			play(&"idle", unit_direction_x, suffixes_)

func play(
	animation_name_: StringName, 
	unit_direction_: Core.UnitDirection, 
	suffixes_: Array[StringName] = [],
) -> void:
	%Animations.play(animation_name_, unit_direction_, suffixes_)
	
	if is_knife_selected:
		%Knife.animations.play(animation_name_, unit_direction_, suffixes_)
	
func _update_knife() -> void:
	if not is_knife_selected:
		%Knife.visible = false
		return
	
	%Knife.visible = true
		
	if unit_direction_x == Core.UnitDirection.RIGHT:
		if unit_stance == Core.UnitStance.CROUCH:
			%Knife.position = Vector2(4, -7)
		else:
			%Knife.position = Vector2(0, -20)
	elif unit_direction_x == Core.UnitDirection.LEFT:
		if unit_stance == Core.UnitStance.CROUCH:
			%Knife.position = Vector2(-4, -7)
		else:
			%Knife.position = Vector2(0, -20)
	else:
		if unit_stance == Core.UnitStance.CROUCH:
			%Knife.position = Vector2(-6, -6)
		else:
			%Knife.position = Vector2(-8, -21)

func _update_body_collision():
	if unit_stance == Core.UnitStance.CROUCH:
		for shape in center_shapes:
			shape.position = Vector2(0, -16)
			shape.shape.size = Vector2(8, 32)
			
		for shape in top_shapes:
			shape.position = Vector2(0, -32.75)
	else:
		for shape in center_shapes:
			shape.position = Vector2(0, -24)
			shape.shape.size = Vector2(8, 48)
		
		for shape in top_shapes:
			shape.position = Vector2(0, -48.75)

func _on_area_2d_head_body_entered(_body: Node2D) -> void:
	Core.audio.play_sfx(&"bonk")
