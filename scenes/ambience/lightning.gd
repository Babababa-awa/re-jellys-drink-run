extends BaseNode2D

@onready var lightning: Array[Sprite2D] = [
	%Sprite2DLightning1,
	%Sprite2DLightning2,
]

var is_lightning: bool = false
var _lightning_index: int = -1
var _lightning_alpha_delta: float = 0.0

var lightning_cooldown_delta: float = 15.0
var lightning_hide_delta: float = 0.4
var _lightning_cooldown: CooldownTimer

func _init() -> void:
	super._init()
	
	_lightning_cooldown = CooldownTimer.new(lightning_cooldown_delta)
	_lightning_cooldown.add_step(&"show", lightning_cooldown_delta - lightning_hide_delta)

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	_lightning_cooldown.reset()
	
	# Add variation
	_lightning_cooldown.delta = lightning_cooldown_delta + randf_range(-5.0, 5.0)
	_lightning_cooldown.set_step_delta(&"show", _lightning_cooldown.delta - lightning_hide_delta)
	
	hide_lightning()
	
	is_lightning = false
	_lightning_index = -1
	_lightning_alpha_delta = 0.0

func _process(delta_: float) -> void:
	super._process(delta_)
	
	if not is_running():
		return
		
	_lightning_cooldown.process(delta_)
	
	if _lightning_cooldown.start():
		pass
	elif _lightning_cooldown.is_on_step(&"show"):
		show_lightning()
	elif _lightning_cooldown.is_complete:
		hide_lightning()
		_lightning_cooldown.stop()
		# Add variation
		_lightning_cooldown.delta = lightning_cooldown_delta + randf_range(-5.0, 5.0)
		_lightning_cooldown.set_step_delta(&"show", _lightning_cooldown.delta - lightning_hide_delta)
	elif is_lightning:
		_lightning_alpha_delta += delta_
		
		var alpha_delta_ = _lightning_alpha_delta
		
		if _lightning_alpha_delta > lightning_hide_delta / 2:
			alpha_delta_ = (lightning_hide_delta / 2) - (_lightning_alpha_delta - (lightning_hide_delta / 2))

		var alpha_ = max(0.0, min(1.0, alpha_delta_ / (lightning_hide_delta / 2)))
		
		lightning[_lightning_index].modulate.a = alpha_

func is_running() -> bool:
	if not super.is_running():
		return false
	
	if not Core.game.is_lightning:
		# Wait for last cooldown to finish
		if not _lightning_cooldown.is_active and not _lightning_cooldown.is_complete:
			return false
		
	return true

func hide_lightning() -> void:
	for sprite in lightning:
		sprite.visible = false
	
	is_lightning = true
			
func show_lightning() -> void:
	_lightning_index += 1
	if _lightning_index	>= lightning.size():
		_lightning_index = 0
			
			
	is_lightning = true
	lightning[_lightning_index].modulate.a = 0
	_lightning_alpha_delta = 0.0
	lightning[_lightning_index].visible = true
	Core.audio.play_sfx(&"thunder", 3)
