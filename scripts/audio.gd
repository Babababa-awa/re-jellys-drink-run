class_name Audio

var sfx = {}
var music = {}
var ambience = {}
var last = {}

func reset() -> void:
	reset_state()
	reset_audio()
	
func reset_state() -> void:
	stop_music()
	last.clear()
	
func reset_audio() -> void:
	reset_sfx()
	reset_music()
	reset_ambience()
	
func reset_sfx() -> void:
	for name in sfx:
		Core.game.remove_child(sfx[name])
	sfx = {}
	
func reset_music() -> void:
	for name in music:
		Core.game.remove_child(music[name])
	music = {}

func reset_ambience() -> void:
	for name in ambience:
		Core.game.remove_child(ambience[name])
	ambience = {}

func play_music(name: StringName) -> void:
	_play(Core.AudioType.MUSIC, name)

func stop_music(name: StringName = &"") -> void:
	_stop(Core.AudioType.MUSIC, name)
	
func load_music(name: StringName) -> void:
	_load(Core.AudioType.MUSIC, name)
	
func unload_music(name: StringName) -> void:
	_unload(Core.AudioType.MUSIC, name)

func play_sfx(name: StringName, count: int = -1, rand: bool = false):
	if count == 0:
		return
		
	if count != -1:
		var last_name = _get_last_name(Core.AudioType.SFX, name)
		
		if rand:
			var index: int
			
			while true:
				index = randi() % count + 1
				if not last.has(last_name) or last[last_name] != index:
					break
			
			last[last_name] = index	
			name += "_" + str(last[last_name])
		else:
			if not last.has(last_name) or last[last_name] == count:
				last[last_name] = 1
				name += "_1"
			else:
				last[last_name] += 1
				name += "_" + str(last[last_name])
	
	_play(Core.AudioType.SFX, name)

func load_sfx(name: StringName):
	_load(Core.AudioType.SFX, name)

func unload_sfx(name: StringName) -> void:
	_unload(Core.AudioType.SFX, name)
	
func play_ambience(name: StringName) -> void:
	_play(Core.AudioType.AMBIENCE, name)

func stop_ambience(name: StringName = &"") -> void:
	_stop(Core.AudioType.AMBIENCE, name)
	
func load_ambience(name: StringName):
	_load(Core.AudioType.AMBIENCE, name)

func unload_ambience(name: StringName) -> void:
	_unload(Core.AudioType.AMBIENCE, name)
	
func get_volume(type: Core.AudioType) -> float:
	var bus: int = _get_audio_bus_index(type)
	return db_to_linear(AudioServer.get_bus_volume_db(bus))
	
func set_volume(type: Core.AudioType, value: float) -> void:
	var bus: int = _get_audio_bus_index(type)

	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	AudioServer.set_bus_mute(bus, value < 0.05)

func _play(type: Core.AudioType, name: StringName) -> void:
	var audio = _get_audio(type)

	if not audio.has(name):
		_load(type, name)
	
	if type == Core.AudioType.SFX:
		audio[name].play()
	else:
		_stop(type, name)

		if audio[name].playing:
			return
		
		var last_name = _get_last_name(type, name)
		if not last.has(last_name):
			last[last_name] = 0.0
		
		audio[name].play(last[last_name])

func _stop(type: Core.AudioType, name: StringName = &"") -> void:
	var audio = _get_audio(type)
	
	for existing_name in audio:
		if existing_name != name and audio[existing_name].playing:
			if type != Core.AudioType.SFX:
				var last_name = _get_last_name(type, existing_name)
				last[last_name] = audio[existing_name].get_playback_position()
			audio[existing_name].stop()
	
func _load(type: Core.AudioType, name: StringName) -> void:
	var audio = _get_audio(type)
	var path = _get_path(type)
	
	if audio.has(name):
		return
		
	var audio_player = AudioStreamPlayer.new()
	match type:
		Core.AudioType.SFX:
			audio_player.bus = &"SFX"
		Core.AudioType.MUSIC:
			audio_player.bus = &"Music"
		Core.AudioType.AMBIENCE:
			audio_player.bus = &"Ambience"
	
	if ResourceLoader.exists("res://assets/audio/" + path + "/" + name + ".ogg"):
		audio_player.stream = load("res://assets/audio/" + path + "/" + name + ".ogg")
	elif ResourceLoader.exists("res://assets/audio/" + path + "/" + name + ".mp3"):
		audio_player.stream = load("res://assets/audio/" + path + "/" + name + ".mp3")
	else:
		audio_player.stream = load("res://assets/audio/" + path + "/" + name + ".wav")
	
	Core.game.add_child(audio_player)
	
	audio[name] = audio_player
	
func _unload(type: Core.AudioType, name: StringName) -> void:
	var audio = _get_audio(type)
	
	if audio.has(name):
		Core.game.remove_child(audio[name])

func _get_audio(type: Core.AudioType) -> Dictionary:
	match type:
		Core.AudioType.SFX:
			return sfx
		Core.AudioType.MUSIC:
			return music
		Core.AudioType.AMBIENCE:
			return ambience
			
	assert(false, "Invalid Core.AudioType passed.")
	return {} 

func _get_path(type: Core.AudioType) -> String:
	match type:
		Core.AudioType.SFX:
			return "sfx"
		Core.AudioType.MUSIC:
			return "music"
		Core.AudioType.AMBIENCE:
			return "ambience"
			
	assert(false, "Invalid Core.AudioType passed.")
	return ""
	
func _get_last_name(type: Core.AudioType, name: StringName) -> String:
	match type:
		Core.AudioType.SFX:
			return "sfx." + name
		Core.AudioType.MUSIC:
			return "music." + name
		Core.AudioType.AMBIENCE:
			return "ambience." + name
			
	assert(false, "Invalid Core.AudioType passed.")
	return ""

func _get_audio_bus_index(type: Core.AudioType) -> int:
	match type:
		Core.AudioType.SFX:
			return AudioServer.get_bus_index(&"SFX")
		Core.AudioType.MUSIC:
			return AudioServer.get_bus_index(&"Music")
		Core.AudioType.AMBIENCE:
			return AudioServer.get_bus_index(&"Ambience")
			
	assert(false, "Invalid Core.AudioType passed.")
	return 0
