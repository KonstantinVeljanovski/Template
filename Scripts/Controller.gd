extends Node
export (Array, String) var text
export (Array, AudioStreamOGGVorbis) var audio
export (Array, String) var animations

onready var infoText = get_node("/root/Master/UI/InfoPanel/Container/InfoText")
onready var audioPlayer = get_node("/root/Master/Misc/AudioStreamPlayer")
onready var animationPlayer = get_node("/root/Master/World/3D/Pivot/Model/Augmentation").get_node("AnimationPlayer")

var stepcounter = -1

func _nextStep():
	if !get_node(audioPlayer).is_playing():
		stepcounter = stepcounter + 1
		if stepcounter < text.size():
			get_node(infoText).text = text[stepcounter]
			get_node(audioPlayer).stream = audio[stepcounter]
			get_node(audioPlayer).play() 
			get_node(animationPlayer).play(animations[stepcounter])
			
func _returnHome():
	ApplicationManager._loadScene("Menu.tscn")
