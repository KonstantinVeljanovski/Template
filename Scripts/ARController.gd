extends Spatial

onready var anchor_scene = load("res://CustomNodes/Anchor.tscn")
export (String, "ARCore", "ARKit") var arSDK;

onready var AROrigin = get_node("WorldOrigin")
onready var ARCamera = get_node("WorldOrigin/ARVRCamera")
onready var ARMode = get_tree().get_root().get_node("Master/UI/ARMode")
onready var _3DRMode = get_tree().get_root().get_node("Master/UI/3DMode")

var ARServer = null
var trackingAnchors = true

func tracker_added(tracker_name, tracker_type, tracker_id):
	if !ApplicationManager._3DMode:
		if trackingAnchors:
			if tracker_type == ARVRServer.TRACKER_ANCHOR:
				var new_anchor = anchor_scene.instance()
				new_anchor.anchor_id = tracker_id
				new_anchor.set_name("anchor_" + str(tracker_id))
				new_anchor.get_node("Area").connect("input_event",self,"_placeAugmentation")
				AROrigin.add_child(new_anchor)

func tracker_removed(tracker_name, tracker_type, tracker_id):
	if !ApplicationManager._3DMode:
		if tracker_type == ARVRServer.TRACKER_ANCHOR:
			var anchor = AROrigin.get_node("anchor_" + str(tracker_id))
			if anchor:
				anchor.queue_free()

func _ready():
	
	ARVRServer.connect("tracker_added", self, "tracker_added")
	ARVRServer.connect("tracker_removed", self, "tracker_removed")
	ARServer = ARVRServer.find_interface(arSDK)
	
func _process(delta):
	if !ApplicationManager._3DMode:
		if ARServer:
			if ARServer.initialize():
				get_viewport().arvr = true
				get_viewport().get_camera().environment.background_camera_feed_id = ARServer.get_camera_feed_id()
				if arSDK == "ARKit":
					ARServer.ar_is_anchor_detection_enabled = true
		ARMode.visible = true
		_3DRMode.visible = false
	else:
		get_viewport().arvr = false
		$"../World/3D/Gizmos".show_current_gizmo("None")
		$"../World/3D/Gizmos".show_gizmo = false
		ARMode.visible = false
		_3DRMode.visible = true
	
func _placeAugmentation(camera, event,click_position,click_normal,shape_idx):
	if event is InputEventScreenTouch:
		get_parent().get_node("World/3D").visible = true
		get_parent().get_node("World/3D").translation = click_position

func _toggleAnchors(value: bool):
	trackingAnchors = value
	for node in AROrigin.get_children():
			if node is ARVRAnchor:
				node.visible = value

func _toggleAR(button_pressed):
	if button_pressed:
		ARCamera.current = true
		get_parent().get_node("World/3D/Pivot/Orbit/X/Y/Z/3DMode").current = false
		ApplicationManager._3DMode = false
		_toggleAnchors(true)
	else:
		ARCamera.current = false
		get_parent().get_node("World/3D/Pivot/Orbit/X/Y/Z/3DMode").current = true
		ApplicationManager._3DMode = true
		_toggleAnchors(false)
	pass 

