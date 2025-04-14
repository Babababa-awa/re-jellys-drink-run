extends PlayerUnit
class_name PlayerPlatformerUnit

var crouch: BaseActor:
	get:
		return actors.use(&"crouch")
		
var jump: BaseActor:
	get:
		return actors.use(&"jump")
		
var climb: BaseActor:
	get:
		return actors.use(&"climb")
	
var fall: BaseActor:
	get:
		return actors.use(&"fall")

var weapons: BaseActor:
	get:
		return actors.use(&"weapons")
		
var move: BaseActor:
	get:
		return actors.use(&"move")
		
func _init(alias_: StringName) -> void:
	super._init(alias_)
	
	actors.add_all({
		&"crouch": CrouchPlatformerActor.new(self),
		&"jump": JumpPlatformerActor.new(self),
		&"climb": ClimbPlatformerActor.new(self),
		&"fall": FallPlatformerActor.new(self),
		&"weapons": WeaponsActor.new(self),
		&"move": MovePlatformerActor.new(self),
	})
