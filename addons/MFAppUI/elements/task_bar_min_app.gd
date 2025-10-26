extends Control
class_name TaskBarMinApp

signal  got_clicked(me:TaskBarMinApp, linkedForm:Form)

var __linkedForm:Form = null
var __title:String
@onready var form_text: Label = $FormText

func _on_button_button_up() -> void:
	got_clicked.emit(self, __linkedForm)

func _ready() -> void:
	form_text.text = __title


static func create(\
		argTitle:String,\
		argForm:Form,\
		argInstance:TaskBarMinApp) -> TaskBarMinApp:
	argInstance.__title = argTitle
	argInstance.__linkedForm = argForm
	return argInstance
