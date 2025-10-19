extends Control

const FORM = preload("res://addons/MFAppUI/elements/Form.tscn")
const ICON = preload("res://addons/MFAppUI/elements/Icon.tscn")
const FORM_SMALL = preload("res://addons/MFAppUI/elements/Form_Small.tscn")

@onready var desktop: DesktopContainer = $Desktop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	var frm:Form = FORM.instantiate()
	desktop.add_form_element(frm)
	frm.position = Vector2(15.0,15.0)
	
	#frm = FORM.instantiate()
	#self.add_child(frm)
	#frm.position = Vector2(25.0,25.0)

func _on_button_2_button_up() -> void:
	var ico:Icon = ICON.instantiate()
	desktop.add_icon_element(ico)


func _on_button_3_button_up() -> void:
	var frm:Form = FORM_SMALL.instantiate()
	desktop.add_form_element(frm)
	frm.position = Vector2(15.0,15.0)
	
