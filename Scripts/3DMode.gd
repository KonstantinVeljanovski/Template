extends Spatial

var move = Vector2(0,0)

export (String, "Pan", "Tilt", "Zoom") var currentMode;

onready var _master = get_tree().get_root().get_node("Master/AR Controller")

func _changeMode(value):
	currentMode = value
	
func _unhandled_input(event):
	if ApplicationManager._3DMode:	
		if currentMode == "Tilt":
			if event is InputEventScreenDrag:
				move  = event.get_relative()
				$"Orbit/X".rotate(Vector3(0,1,0),-move.x/100)
				$"Orbit/X/Y".rotate(Vector3(1,0,0),-move.y/100)
		elif currentMode == "Zoom":
			if event is InputEventScreenDrag:
				move  = event.get_relative()
				$"Orbit/X/Y/Z".translate(Vector3(0,0,event.relative.y/20))
				if $"Orbit/X/Y/Z".translation.z > 20:
					$"Orbit/X/Y/Z".translate(Vector3(0,0,0))
		elif currentMode == "Pan":
			if event is InputEventScreenDrag:
				move  = event.get_relative()
				$"Orbit/X/Y/Z".translate(Vector3(-(event.relative.x/40),(event.relative.y/40),0))

		if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == BUTTON_WHEEL_UP:
					$"Orbit/X/Y/Z".translate(Vector3(0,0,-1))
				if event.button_index == BUTTON_WHEEL_DOWN:
					$"Orbit/X/Y/Z".translate(Vector3(0,0,1))
