class_name LevelLockSet

var locks: Array[LevelLockValue]

func _init(data_: BaseDataLoader) -> void:
	for level in data_.get_data(Core.DataType.LEVEL):
		if not level.has("locks"):
			continue
			
		for lock_ in level.locks:
			locks.push_back(LevelLockValue.new(
				lock_.alias,
				lock_.type,
				lock_.mode,
				lock_.has("unlocked") and lock_.unlocked,
				lock_.has("bypassable") and lock_.bypassable,
				lock_.meta if lock_.has("meta") else {}
			))
			

func has_lock(alias_: StringName) -> bool:
	for lock_ in locks:
		if lock_.alias == alias_:
			return true
			
	return false

func get_lock(alias_: StringName) -> LevelLockValue:
	for lock_ in locks:
		if lock_.alias == alias_:
			return lock_
			
	return null
