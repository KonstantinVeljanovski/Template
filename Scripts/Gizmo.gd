extends Spatial

export (String, "Move", "Rotate", "Scale") var current_gizmo;
export (String, "X","Y","Z","ALL") var selected_axis

var show_gizmo = false

onready var world  = get_parent()
onready var gizmoui = get_tree().get_root().get_node("Master/UI/ARMode/Gizmos")
onready var anim = get_tree().get_root().get_node("Master/UI/AnimationPlayer")

func show_current_gizmo(curr):
	if show_gizmo:
		current_gizmo = curr
		if current_gizmo == "Move":
			$"Translate".visible = true
			$"Rotate".visible = false
			$"Scale".visible = false
			
		elif current_gizmo == "Rotate":
			$"Translate".visible = false
			$"Rotate".visible = true
			$"Scale".visible = false
			
		elif current_gizmo == "Scale":
			$"Translate".visible = false
			$"Rotate".visible = false
			$"Scale".visible = true
		elif current_gizmo == "None":
			$"Translate".visible = false
			$"Rotate".visible = false
			$"Scale".visible = false

func _selectAxis(camera, event, click_position, click_normal, shape_idx, axis):
	if event.is_pressed():
		selected_axis = axis
		print( "Current Axis:" ,selected_axis)

func _input(event):
	if event is InputEventScreenDrag:
		var val_x = event.get_relative().x * .015
		var val_y = event.get_relative().y * .015
		if show_gizmo:
			
			if   current_gizmo == "Scale":				
				 world.set_scale(Vector3(world.scale.x + val_x,world.scale.y + val_x,world.scale.z + val_x))
			elif current_gizmo == "Move":
				if   selected_axis == "X":
					world.translate(Vector3(val_x,0,0))
				elif selected_axis == "Y":
					world.translate(Vector3(0,-val_y,0))
				elif selected_axis == "Z":
					world.translate(Vector3(0,0,val_y))

			elif current_gizmo == "Rotate":
				if   selected_axis == "Z":
					world.rotate(Vector3(0,0,1),val_x)
				elif selected_axis == "Y":
					world.rotate(Vector3(0,1,0),-val_y)
				elif selected_axis == "X":
					world.rotate(Vector3(1,0,0),-val_y)
		
func _on_Gizmo_toggled(button_pressed):
	if button_pressed:
		gizmoui.visible = true
	else:
		gizmoui.visible = false
		$"Translate".visible = false
		$"Rotate".visible = false
		$"Scale".visible = false
	show_gizmo = button_pressed

func _toggleGizmo(value):
	if value:
		show_gizmo = true
		anim.play("toggleGizmo")
	else:
		show_current_gizmo("None")
		show_gizmo = false
		anim.play_backwards("toggleGizmo")

