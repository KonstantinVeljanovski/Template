extends Node

#Application Settings
export (Color) var tintColor  = Color(0.0,0.48,0.53,1.0)
onready var title = get_parent().get_node("Master/UI/Background/Label")
#AR Settings
var _3DMode = true;

#Application Functions
func _loadScene(val):
	if ARVRServer.find_interface("ARKit"):
		ARVRServer.find_interface("ARKit").uninitialize()
	if ARVRServer.find_interface("ARCore"):
		ARVRServer.find_interface("ARCore").uninitialize()
	get_tree().change_scene("res://Scenes/" + val)


func _ready():
	if(title):
		title.text = ProjectSettings.get_setting("application/config/name")	
