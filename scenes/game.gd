extends BaseGame
class_name Game

var rain: bool = true
var is_lightning: bool = true
var is_outside: bool = true

func start_select() -> void:
	hide_uis(Global.UIType.MENU)
	current_level.start_select()

func _process(delta):
	super._process(delta)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
