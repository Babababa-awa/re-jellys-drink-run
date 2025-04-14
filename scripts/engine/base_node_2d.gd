extends Node2D
class_name BaseNode2D

var is_enabled: bool = true
var is_started: bool = false
var is_ready: bool = false
var modes: StringNameSet
var alignment: Core.Alignment = Core.Alignment.TOP_LEFT

var scale_default: Vector2 = Vector2.ONE

signal started(reset_type_: Core.ResetType)

func _init() -> void:
	modes = StringNameSet.new()

func _ready() -> void:
	scale_default = scale
	
func reset(reset_type_: Core.ResetType) -> void:
	if (reset_type_ == Core.ResetType.START or 
		reset_type_ == Core.ResetType.RESTART
	):
		scale = scale_default
		
		is_started = false
		is_ready = false
		modes.filter(func(mode): return Core.GLOBAL_MODES.has(mode))

func start() -> void:
	reset(Core.ResetType.START)
	
	is_started = true
		
	for child in get_children(): 
		if child is BaseNode2D or child is BaseCharacterBody2D:
			child.start()
			
	started.emit(Core.ResetType.START)

func restart() -> void:	
	reset(Core.ResetType.RESTART)
	
	is_started = true
	
	for child in get_children():
		if child is BaseNode2D or child is BaseCharacterBody2D:
			child.restart()
		
	started.emit(Core.ResetType.RESTART)
	
func refresh() -> void:
	reset(Core.ResetType.REFRESH)
	
	for child in get_children():
		if child is BaseNode2D or child is BaseCharacterBody2D:
			child.refresh()
	
	started.emit(Core.ResetType.REFRESH)

func stop() -> void:
	is_started = false
	is_ready = false
	
	for child in get_children():
		if child is BaseNode2D or child is BaseCharacterBody2D:
			child.stop()

func _process(_delta: float) -> void:
	# We redundantly check is_ready here so overriding wont allow calling
	# it after alrady being ready
	if not is_ready:
		_handle_ready()

func _physics_process(_delta: float) -> void:
	pass

func _handle_ready() -> void:
	if is_ready:
		return
		
	if not Core.game.is_enabled:
		return

	if not is_started:
		return

	if position == Core.DEAD_ZONE:
		return

	is_ready = true
	ready()

func ready() -> void:
	pass

func is_running() -> bool:
	if not Core.game.is_enabled:
		return false

	if not is_enabled or not is_started or not is_ready:
		return false

	return true

func add_mode(mode_: StringName, add_to_children: bool = false) -> void:
	modes.add(mode_)
	
	if add_to_children:
		for child in get_children():
			if child is BaseNode2D or child is BaseCharacterBody2D:
				child.add_mode(mode_)
	
func remove_mode(mode_: StringName, remove_from_children: bool = false) -> void:
	modes.remove(mode_)
	
	if remove_from_children:
		for child in get_children():
			if child is BaseNode2D or child is BaseCharacterBody2D:
				child.remove_mode(mode_)
	
func get_align_position(alignment_: Core.Alignment) -> Vector2:
	return position + Core.get_align_offset(get_rect(), alignment_)
	
func get_align_global_position(alignment_: Core.Alignment) -> Vector2:
	return global_position + Core.get_align_offset(get_rect(), alignment_)

func get_align_offset(alignment_: Core.Alignment) -> Vector2:
	return Core.get_align_offset(get_rect(), alignment_)
	
func get_rect() -> Rect2:
	var bounds_area = get_node_or_null("%Area2DRect")
	
	if bounds_area != null:
		return Core.get_collision_rect(bounds_area)
	
	return Rect2()
