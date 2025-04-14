extends BaseActor
class_name SpeechActor

var unit: BaseCharacterBody2D
var timer = CooldownTimer.new(0.0)

func _init(unit_: BaseCharacterBody2D, enabled_: bool = true) -> void:
	super._init(&"speech", enabled_)
	unit = unit_

func process(delta_: float) -> void:
	super.process(delta_)
	
	if not can_process():
		return
		
	timer.process(delta_)
	
	if timer.is_complete:
		timer.stop()
		var speech_ = unit.get_node_or_null("%Speech")
		if speech_ is BaseSpeech:
			speech_.visible = false

func say(line_: SpeechValue) -> bool:
	var speech_ = unit.get_node_or_null("%Speech")
	if not speech_ is BaseSpeech:
		return false
	
	speech_.set_line(line_.line)
	speech_.set_style(line_.style)
	speech_.set_size(line_.size)
	speech_.set_alignment(line_.alignment)
	speech_.set_orientation(line_.orientation)
	speech_.refresh()
	speech_.visible = true
	
	timer.stop()
	timer.delta = line_.delta
	timer.start()
	return true
