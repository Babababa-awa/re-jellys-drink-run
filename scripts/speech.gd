class_name Speech

var _queue: Array[SpeechValue] = []
var _queue_delta: float = 0.0

func reset() -> void:
	_queue.clear()
	_queue_delta = 0.0

func process(delta_: float) -> void:
	if _queue.size() == 0:
		return
		
	_queue_delta -= delta_
	if _queue_delta <= 0.0:
		_queue.pop_front()
		if _queue.size() != 0:
			_queue_delta = _queue[0].delta
			say(_queue[0], false)

func say(line_: SpeechValue, queue_: bool = false) -> void:
	if queue_:
		_queue.push_back(line_)
		if _queue.size() == 1:
			_queue_delta = line_.delta
			say(line_)
		return
	
	if line_.target is BaseCharacterBody2D:
		var speech_actor = line_.target.get_actor_or_null(&"speech")
		if speech_actor != null:
			if (speech_actor.say(line_)):
				return

	#TODO: Fallback or general overlay system?
