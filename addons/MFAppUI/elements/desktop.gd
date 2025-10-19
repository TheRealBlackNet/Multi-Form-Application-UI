extends Control
class_name DesktopContainer

@onready var form_container: FormContainer = $BG/FormContainer
@onready var task_min_app_container: HBoxContainer = $TaskBar/TaskMinAppContainer

const TASK_BAR_MIN_APP = preload("res://addons/MFAppUI/elements/TaskBarMinApp.tscn")
var FORM_MIN_APP_MAP:Dictionary = {}

func add_form_element(frm:Form):
	form_container.add_form_element(frm)
	#form_container.add_form_element_setMinMoving(frm)
	
	frm.BehaviorCloseAction = Form.BehaviorClose.FREE
	var minApp:TaskBarMinApp = TASK_BAR_MIN_APP.instantiate();
	task_min_app_container.add_child(minApp)
	minApp.tooltip_text = frm.form_text.text

	frm.got_closed.connect(remove_min_app);
	FORM_MIN_APP_MAP[frm] = minApp

func remove_min_app(me:Form,removed:bool):
	var minApp:TaskBarMinApp = FORM_MIN_APP_MAP[me]
	if minApp:
		minApp.queue_free()
		FORM_MIN_APP_MAP[me] = null

func add_icon_element(ico:Icon):
	form_container.add_icon_element(ico)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
