extends Control

@onready var form_container: FormContainer = $FormContainer


const FORM = preload("res://addons/MFAppUI/elements/Form.tscn")
const ICON = preload("res://addons/MFAppUI/elements/Icon.tscn")
const FORM_SMALL = preload("res://addons/MFAppUI/elements/Form_Small.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_2_button_up() -> void:
	var frm:Form = FORM.instantiate()
	form_container.add_form_element(frm)
	frm.position = Vector2(15.0,15.0)


func _on_button_3_button_up() -> void:
	var frm:Form = FORM_SMALL.instantiate()
	form_container.add_form_element(frm)
	frm.position = Vector2(15.0,15.0)
