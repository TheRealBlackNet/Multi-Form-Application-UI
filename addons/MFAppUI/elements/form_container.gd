extends Control
class_name FormContainer

@onready var icons: GridContainer = $matchIcons/Icons
@onready var form_container: Control = $matchForm/FormContainer

func add_form_element(frm:Form):
	form_container.add_child(frm)

func add_icon_element(ico:Icon):
	icons.add_child(ico)
