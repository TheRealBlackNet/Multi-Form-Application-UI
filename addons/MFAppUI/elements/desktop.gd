extends Control
class_name DesktopContainer

@onready var form_container: FormContainer = $BG/FormContainer

func add_form_element(frm:Form):
	form_container.add_form_element(frm)
	#form_container.add_form_element_setMinMoving(frm)

func add_icon_element(ico:Icon):
	form_container.add_icon_element(ico)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
