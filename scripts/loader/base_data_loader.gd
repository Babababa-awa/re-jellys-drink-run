class_name BaseDataLoader

var has_loaded: bool = false
var level_alias: StringName
var _data: Dictionary = {}

func _init(level_alias_: StringName) -> void:
	level_alias = level_alias_

func load() -> void:
	assert(has_loaded == false, "Data has already been loaded.")
	
	has_loaded = true
	
func get_data(data_type: Core.DataType) -> Array[Dictionary]:
	if _data[data_type] is Dictionary:
		return [_data[data_type]]
		
	return _data[data_type]

func get_from_alias(data_type: Core.DataType, alias: StringName) -> Dictionary:
	if _data[data_type] is Dictionary:
		if _data[data_type].alias == alias:
			return _data[data_type]
	else:
		for value in _data[data_type]:
			if value.alias == alias:
				return value
				
	assert(false, "Data not found. (" + str(data_type) + ", " + alias + ")")
	return {}

func _load_data(data_type: Core.DataType, base_path: String) -> Array[Dictionary]:
	var data: Array[Dictionary] = []
	
	var dir = DirAccess.open(base_path)
	
	assert(dir != null, "Data directory is empty.")

	dir.list_dir_begin()
	
	var file_name = dir.get_next()

	while file_name != "":
		if dir.current_is_dir():
			var sub_map = _load_data(data_type, base_path + "/" + file_name)
			data.append_array(sub_map)  # Merge results
		elif file_name.ends_with(".json"):
			var json = _load_json_data(data_type, base_path + "/" + file_name)
			if not json.is_empty():
				data.push_back(json)
				
		file_name = dir.get_next()

	dir.list_dir_end()
	
	return data
	
func _load_json_data(data_type: Core.DataType, file: String) -> Dictionary:
	var json = _load_json_file(file)
	
	if not json.is_empty():
		if not json.has("alias"):
			json.alias = file.get_basename().get_file()
		json = _format_data(data_type, json)
		
	return json

func _load_json_file(file: String) -> Dictionary:
	var handle = FileAccess.open(file, FileAccess.READ)
	if not handle:
		return {}
	
	var contents = handle.get_as_text()
	handle.close()

	var json = JSON.new()
	
	if json.parse(contents) != OK:
		return {}
	
	return json.data

func _format_data(_data_type: Core.DataType, json_data: Dictionary) -> Dictionary:
	return json_data
