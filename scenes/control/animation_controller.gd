extends Node2D
class_name AnimationController

var _texture_paths: Dictionary = {}

func play(
	animation_name_: StringName,
	unit_direction_: Core.UnitDirection,
	suffixes_: Array[StringName] = [],
) -> void:
	var animation_names_ = _get_animation_names(
		animation_name_,
		unit_direction_,
		suffixes_
	)
		
	for child in get_children():
		if not child is AnimatedSprite2D:
			continue
			
		var empty: bool = true

		for current_animation_name_ in animation_names_:
			if child.sprite_frames.has_animation(current_animation_name_.name):
				child.flip_h = current_animation_name_.flip_h
				child.flip_v = current_animation_name_.flip_v
				child.play(current_animation_name_.name)
				empty = false
				break
		
		if empty and child.sprite_frames.has_animation(&"empty"):
			child.play(&"empty")
			
func _get_animation_names(
	animation_name_: StringName,
	unit_direction_: Core.UnitDirection,
	suffixes_: Array[StringName] = []
) -> Array:
	var directions = Core.PLAY_DIRECTIONS[unit_direction_]
	
	var animation_names_: Array = []
	var animation_suffix_names_: Dictionary = {}
	
	for suffix_ in suffixes_:
		animation_suffix_names_[suffix_] = []

	for direction in directions:
		var flip_h: bool = false
		var flip_v: bool = false
		
		if direction == &"x" or direction == &"xy":
			match unit_direction_:
				Core.UnitDirection.LEFT:
					flip_h = true
				Core.UnitDirection.LEFT_UP:
					flip_h = true
				Core.UnitDirection.LEFT_DOWN:
					flip_h = true
				Core.UnitDirection.UP_LEFT:
					flip_h = true
				Core.UnitDirection.DOWN_LEFT:
					flip_h = true
			
		if direction == &"y" or direction == &"xy":
			match unit_direction_:
				Core.UnitDirection.UP:
					flip_v = true
				Core.UnitDirection.UP_LEFT:
					flip_v = true
				Core.UnitDirection.UP_RIGHT:
					flip_v = true
				Core.UnitDirection.LEFT_UP:
					flip_v = true
				Core.UnitDirection.RIGHT_UP:
					flip_v = true
					
		if animation_name_ == direction:
			animation_names_.push_back({
				"name": animation_name_,
				"flip_h": flip_h,
				"flip_v": flip_v,
			})
			
			for suffix_ in suffixes_:
				animation_suffix_names_[suffix_].push_back({
					"name": animation_name_ + &"_" + suffix_,
					"flip_h": flip_h,
					"flip_v": flip_v,
				})
		else:
			animation_names_.push_back({
				"name": animation_name_ + &"_" + direction,
				"flip_h": flip_h,
				"flip_v": flip_v,
			})
			
			for suffix_ in suffixes_:
				animation_suffix_names_[suffix_].push_back({
					"name": animation_name_ + &"_" + direction + &"_" + suffix_,
					"flip_h": flip_h,
					"flip_v": flip_v,
				})
	
	
	var result_animation_names: Array = []
	
	for suffix_ in suffixes_:
		result_animation_names.append_array(animation_suffix_names_[suffix_])
	
	result_animation_names.append_array(animation_names_)
		
	return result_animation_names

func set_texture_variant(variant_alias_: StringName) -> void:
	return
	
	for child in get_children():
		if not child is AnimatedSprite2D:
			continue
		
		var path: String
		
		#var frames = child.sprite_frames
		#TODO Iterate over all frames of all aniamtoins and update texture....
		#TODO Do i just recreate all the animates again?
		# Get list of animations on ready, and populate variant versions of 
		# the animations Then when switch variant is called, it can switch to 
		# whatever animation is currently playing and set the frame to match
		
		#for animation_name_ in frames.animations_names:
			#frames.set_frame_texture(animation_name_, frame_index_, new_texture_)
		
		#if _texture_paths.has(child.get_instance_id()):
			#path = _texture_paths[child.get_instance_id()]
		#else:
			#path = frame.texture.resource_path
			#_texture_paths[child.get_instance_id()] = path
			#
		#if variant_alias_ == &"":
			#if frame.texture.resource_path != path:
				#frame.texture = load(path)
			#continue
			#
		#var variant_path = Core.add_suffix_to_path(path, variant_alias_)
		#
		#if FileAccess.file_exists(variant_path):
			#frame.texture = load(variant_path)
		#elif frame.texture.resource_path != path:
			#frame.texture = load(path)
