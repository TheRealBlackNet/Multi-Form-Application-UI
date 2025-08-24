extends Control
class_name Form

@onready var btn_min: TextureButton = $MarginContainer/NinePatchRect/btnMin
@onready var btn_max: TextureButton = $MarginContainer/NinePatchRect/btnMax
@onready var btn_close: TextureButton = $MarginContainer/NinePatchRect/btnClose
@onready var btn_resize: TextureButton = $MarginContainer/NinePatchRect/btnResize
@onready var btn_move: TextureButton = $MarginContainer/NinePatchRect/btnMove

var __resizeToMouse:bool = false
var __MoveToMouse:bool = false
var __MouseOffsetStart:Vector2 = Vector2.ZERO

func _ready() -> void:
	pass # Replace with function body.

func _on_btn_resize_button_up() -> void:
	__resizeToMouse = false

func _on_btn_resize_button_down() -> void:
	__resizeToMouse = true

func _on_btn_move_button_down() -> void:
	self.move_to_front()
	__MoveToMouse = true
	__MouseOffsetStart = get_local_mouse_position()\
			+ self.position\
			- self.global_position

func _on_btn_move_button_up() -> void:
	__MoveToMouse = false

func _process(delta: float) -> void:
	if __resizeToMouse:
		var mousePos:Vector2 = get_local_mouse_position() + self.position
		var newSize:Vector2 = mousePos - self.global_position
		if newSize.x < 60:
			newSize.x = 60
		if newSize.y < 40:
			newSize.y = 40
		self.size = newSize
	elif __MoveToMouse:
		var mousePos:Vector2 = get_local_mouse_position() + self.position
		self.position = mousePos
	if self.position.x < 0:
		self.position.x = 0
	if self.position.y < 0:
		self.position.y = 0
	if self.get_parent_control() != null:
		if self.position.x > self.get_parent_control().size.x:
			self.position.x = self.get_parent_control().size.x - 60
		if self.position.y > self.get_parent_control().size.y:
			self.position.y = self.get_parent_control().size.y - 40

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton\
		and event.button_index == MOUSE_BUTTON_LEFT:
		self.move_to_front()

func _on_btn_min_button_up() -> void:
	self.move_to_front()

func _on_btn_max_button_up() -> void:
	self.move_to_front()
	self.size = self.get_parent_control().size
	self.position = Vector2(0,0)

func _on_btn_close_button_up() -> void:
	self.move_to_front()
	self.queue_free()
