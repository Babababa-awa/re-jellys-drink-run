extends DoorObject

func _init() -> void:
	super._init(3, 0.125)

func _obstruction_action(_lock_state: Core.LockState) -> void:
	Core.speech.say(SpeechValue.new(Core.player, "TALK:barricaded", 2))

func _key_action(lock_state_: Core.LockState) -> void:
	if lock_state_ == Core.LockState.LOCKED:
		Core.speech.say(SpeechValue.new(Core.player, "TALK:locked", 2))
		Core.audio.play_sfx(&"locked_door", 3)
	elif lock_state_ == Core.LockState.UNLOCKED:
		Core.audio.play_sfx(&"unlock", 3)
	elif lock_state_ == Core.LockState.BYPASSED:
		Core.speech.say(SpeechValue.new(Core.player, "TALK:picked", 2))
		Core.audio.play_sfx(&"unlock", 3)
