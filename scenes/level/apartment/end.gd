extends Node2D

func _ready():
	Global.player.is_pink_drink = true
	Global.player.show_speech_bubble(
		[
			"The End!",
		], 
		-1
	)

func _process(_delta):
	Global.hud.visible = false
