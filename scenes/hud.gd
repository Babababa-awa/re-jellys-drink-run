extends BaseNode2D

const COOLDOWN_DELTA: float = 0.25
var cooldown: CooldownTimer

var available_space: Vector2

func _init() -> void:
	super._init()
	
	cooldown = CooldownTimer.new(COOLDOWN_DELTA)
	# Items need to update more often
	cooldown.add_step(&"items", COOLDOWN_DELTA / 2)
	
func _ready() -> void:
	super._ready()
	
	get_viewport().connect(&"size_changed", _on_screen_resized)
	_reposition()
	
func _process(delta_: float) -> void:
	super._process(delta_)

	if not is_running():
		return
		
	cooldown.process(delta_)
			
	if cooldown.start():
		pass # No update until second step
	elif cooldown.is_on_step(&"items"):
		%PlayerItems.refresh()
	elif cooldown.is_complete:
		cooldown.stop()
		%PlayerAnxiety.refresh()
		%PlayerHunger.refresh()
		%PlayerItems.refresh()
		
func _on_screen_resized():
	_reposition()

func _reposition() -> void:
	available_space = Vector2(get_viewport().size) / scale
	
	var offset = Vector2(available_space.x - 16.0 - 384.0, 16.0)
	%PlayerAnxiety.position = offset
#
	offset = Vector2(16.0, 16.0)
	%PlayerHunger.position = offset
	
	offset = Vector2(16.0, available_space.y - 16.0)
	%PlayerItems.position = offset
