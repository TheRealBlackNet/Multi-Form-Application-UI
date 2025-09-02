extends Control
class_name Form

enum FormState {NORMAL, MAXIMIZED, MINIMIZED, HIDDEN, TASK, TRAY }
enum BehaviorClose {FREE, HIDE, EVENT}
enum BehaviorMinMax {RESIZE, FIXED, EVENT}
enum BehaviorMove {MOVE, FIXED, EVENT}

signal  got_maximized(to_normal: bool)
signal  got_minimized(to_normal: bool)
signal  got_closed(removed:bool)
signal  got_hidden()
signal  got_focus()

@export var BehaviorCloseAction:BehaviorClose = BehaviorClose.FREE
@export var BehaviorMoveAction:BehaviorMove = BehaviorMove.MOVE

@export var BehaviorResizeAction:BehaviorMinMax = BehaviorMinMax.RESIZE
@export var BehaviorMinMaxAction:BehaviorMinMax = BehaviorMinMax.RESIZE

var __resizeToMouse:bool = false
var __MoveToMouse:bool = false
var __MouseOffsetStart:Vector2 = Vector2.ZERO

var __last_position_small:Vector2 = Vector2.ZERO
var __last_size_small:Vector2 = Vector2.ZERO
var __current_mode:FormState = FormState.NORMAL

@onready var nine_patch_rect_max: NinePatchRect = $NinePatchRectMax
@onready var nine_patch_rect_min: NinePatchRect = $NinePatchRectMin
@onready var btn_min: TextureButton = $btnMin
@onready var btn_max: TextureButton = $btnMax
@onready var btn_move: TextureButton = $btnMove
@onready var btn_close: TextureButton = $btnClose
@onready var btn_resize: TextureButton = $btnResize
@onready var form_text: Label = $formText

func _ready() -> void:
	pass # Replace with function body.

func _on_btn_resize_button_up() -> void:
	__resizeToMouse = false

func _on_btn_resize_button_down() -> void:
	__resizeToMouse = true

func _on_btn_move_button_down() -> void:
	self.move_to_front()
	__MoveToMouse = true
	__MouseOffsetStart = self.global_position - get_global_mouse_position()

func _on_btn_move_button_up() -> void:
	__MoveToMouse = false

func _process(delta: float) -> void:
	if __resizeToMouse:
		var mousePos:Vector2 = get_global_mouse_position()
		var newSize:Vector2 = mousePos - self.global_position
		if newSize.x < 60: ### TODO VALUES EXPORT
			newSize.x = 60
		if newSize.y < 40:
			newSize.y = 40
		self.size = newSize
	elif __MoveToMouse:
		var mousePos:Vector2 = get_local_mouse_position()\
			+ self.position\
			+ __MouseOffsetStart
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
		_do_focus()

func _on_btn_max_button_up() -> void:
	_do_focus()
	if __current_mode == FormState.MAXIMIZED:
		self.size = __last_size_small
		self.position = __last_position_small
		__current_mode = FormState.NORMAL
	elif __current_mode == FormState.NORMAL:
		__last_position_small = self.position
		__last_size_small = self.size
		self.size = self.get_parent_control().size
		self.position = Vector2(0,0)      
		__current_mode = FormState.MAXIMIZED
	
	got_maximized.emit(__current_mode == FormState.MAXIMIZED)


func _on_btn_min_button_up() -> void:
	_do_focus()
	nine_patch_rect_max.hide()
	nine_patch_rect_min.show()
	# TODO


func _on_btn_close_button_up() -> void:
	_do_focus()
	if BehaviorCloseAction ==  BehaviorClose.FREE:
		got_closed.emit(true)
		self.queue_free()
	elif BehaviorCloseAction ==  BehaviorClose.HIDE:
		got_closed.emit(false)
		self.hide()
	else:
		got_closed.emit(false)

func _do_focus():
	self.move_to_front()
	got_focus.emit()
