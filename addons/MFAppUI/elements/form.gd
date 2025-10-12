extends Control
class_name Form

enum FormState {NORMAL, MAXIMIZED, MINIMIZED, HIDDEN_TASK_TRAY }
enum BehaviorClose {FREE, HIDE, EVENT, NONE}
enum BehaviorMinMax {RESIZE, FIXED}
enum BehaviorMove {MOVE, FIXED}

signal  got_maximized(me:Form, to_normal: bool)
signal  got_minimized(me:Form,to_normal: bool)
signal  got_resized(me:Form)
signal  is_resizing(me:Form)
signal  got_moved(me:Form)
signal  is_moving(me:Form)
signal  got_closed(me:Form,removed:bool)
signal  got_hidden(me:Form)
signal  got_focus(me:Form)

const minSize:Vector2 = Vector2(200,50)
const minSizeOffSetY:int = minSize.y + 10
const minSizeOffSetX:int = 15

@export var BehaviorCloseAction:BehaviorClose = BehaviorClose.FREE

@export var BehaviorMoveAction:BehaviorMove = BehaviorMove.MOVE
@export var BehaviorResizeAction:BehaviorMinMax = BehaviorMinMax.RESIZE
@export var BehaviorMinMaxAction:BehaviorMinMax = BehaviorMinMax.RESIZE



@export var min_size:Vector2i = Vector2i(60,60)
@export var max_size:Vector2i = Vector2i(999999,999999)

var __resizeToMouse:bool = false
var __MoveToMouse:bool = false
var __MouseOffsetStart:Vector2 = Vector2.ZERO

var __last_position_small:Vector2 = Vector2.ZERO
var __last_size_small:Vector2 = Vector2.ZERO
var __current_mode:FormState = FormState.NORMAL


@onready var nine_patch_rect_max: NinePatchRect = $NinePatchRectMax
@onready var nine_patch_rect_min: NinePatchRect = $NinePatchRectMin
@onready var internal_form_drop_space: MarginContainer = $InternalFormDropSpace

@onready var btn_min: TextureButton = $btnMin
@onready var btn_max: TextureButton = $btnMax
@onready var btn_move: TextureButton = $btnMove
@onready var btn_close: TextureButton = $btnClose
@onready var btn_resize: TextureButton = $btnResize
@onready var form_text: Label = $formText


func _ready() -> void:
	setIconVisibility()

func setIconVisibility():
	if BehaviorResizeAction == BehaviorMinMax.RESIZE:
		btn_resize.show()
	elif BehaviorResizeAction == BehaviorMinMax.FIXED:
		btn_resize.hide()
	
	if BehaviorMinMaxAction == BehaviorMinMax.RESIZE:
		btn_min.show()
		btn_max.show()
	elif BehaviorMinMaxAction == BehaviorMinMax.FIXED:
		btn_min.hide()
		btn_max.hide()
	
	if BehaviorCloseAction == BehaviorClose.NONE:
		btn_close.hide()
	else:
		btn_close.show()

func keepSizes(newSize:Vector2)-> void:
	# not to small
	if newSize.x < min_size.x:
		newSize.x = min_size.x
	if newSize.y < min_size.y:
		newSize.y = min_size.y
	# not to big
	if newSize.x > max_size.x:
		newSize.x = max_size.x
	if newSize.y > max_size.y:
		newSize.y = max_size.y
	# max keep it smaller then the screen
	if newSize.x > self.get_parent_control().size.x:
		newSize.x = self.get_parent_control().size.x
	if newSize.y > self.get_parent_control().size.y:
		newSize.y = self.get_parent_control().size.y

func keepPosition()-> void:
	if self.position.x < 0:
		self.position.x = 0
	if self.position.y < 0:
		self.position.y = 0
	if self.get_parent_control() != null:
		if self.position.x > self.get_parent_control().size.x - self.size.x:
			self.position.x = self.get_parent_control().size.x - self.size.x
		if self.position.y > self.get_parent_control().size.y - self.size.y:
			self.position.y = self.get_parent_control().size.y - self.size.y

func _process(delta: float) -> void:
	if __resizeToMouse:
		var mousePos:Vector2 = get_global_mouse_position()
		var newSize:Vector2 = mousePos - self.global_position
		keepSizes(newSize)
		self.size = newSize
	elif __MoveToMouse:
		var mousePos:Vector2 = get_local_mouse_position()\
			+ self.position\
			+ __MouseOffsetStart
		self.position = mousePos 
		keepPosition()


func _do_focus():
	self.move_to_front()
	got_focus.emit(self)

func _on_btn_resize_button_up() -> void:
	__resizeToMouse = false
	got_resized.emit(self)

func _on_btn_resize_button_down() -> void:
	if BehaviorResizeAction == BehaviorMinMax.RESIZE:
		__resizeToMouse = true
	is_resizing.emit(true)

func _on_btn_move_button_down() -> void:
	self.move_to_front()
	if BehaviorMoveAction == BehaviorMove.MOVE:
		__MoveToMouse = true

	__MouseOffsetStart = self.global_position - get_global_mouse_position()
	is_moving.emit(self)

func _on_btn_move_button_up() -> void:
	__MoveToMouse = false
	got_moved.emit(self)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton\
		and event.button_index == MOUSE_BUTTON_LEFT:
		_do_focus()

func _on_btn_close_button_up() -> void:
	_do_focus()
	if BehaviorCloseAction ==  BehaviorClose.FREE:
		got_closed.emit(self, true)
		self.queue_free()
	elif BehaviorCloseAction ==  BehaviorClose.HIDE:
		self.hide()
		got_closed.emit(self, false)
		got_hidden.emit(self)
	else:
		got_closed.emit(self, false)


func _on_btn_max_button_up() -> void:
	_do_focus()
	_stateFromTo(__current_mode, FormState.MAXIMIZED)


func _on_btn_min_button_up() -> void:
	_do_focus()
	_stateFromTo(__current_mode, FormState.MINIMIZED)


func _saveFormPosSize():
	__last_position_small = self.position
	__last_size_small = self.size

func _loadFormPosSize():
	self.size = __last_size_small
	self.position = __last_position_small

func _toMinButton():
	nine_patch_rect_max.hide()
	nine_patch_rect_min.show()
	internal_form_drop_space.hide()
	btn_resize.hide()

func _toNormalButton():
	nine_patch_rect_max.show()
	nine_patch_rect_min.hide()
	internal_form_drop_space.show()
	btn_resize.show()

func _toMaxForm():
	self.size = self.get_parent_control().size
	self.position = Vector2(0,0)


func _toMinForm():
	self.size = Vector2(minSize.x,minSize.y)
	self.position = Vector2(minSizeOffSetX,\
		self.get_parent_control().size.y-minSizeOffSetY)


func _stateFromTo(current:FormState, next:FormState):
	##
	# MAX
	##
	if next == FormState.MAXIMIZED:
		if current == FormState.MAXIMIZED:
			_loadFormPosSize()
			__current_mode = FormState.NORMAL
			
		elif current == FormState.MINIMIZED:
			_toNormalButton()
			_toMaxForm()
			__current_mode = FormState.MAXIMIZED
			
		elif current == FormState.NORMAL:
			_saveFormPosSize()
			_toMaxForm()
			__current_mode = FormState.MAXIMIZED
		else:
			self.show()
			_toNormalButton()
			_toMaxForm()
		got_maximized.emit(self, __current_mode == FormState.NORMAL)
	##
	# MIN
	##
	elif next == FormState.MINIMIZED:
		if current == FormState.MINIMIZED:
			_toNormalButton()
			_loadFormPosSize()
			__current_mode = FormState.NORMAL
			
		elif current == FormState.NORMAL:
			_saveFormPosSize()
			_toMinButton()
			_toMinForm()
			__current_mode = FormState.MINIMIZED
			
		elif current == FormState.MAXIMIZED:
			_toMinButton()
			_toMinForm()
			__current_mode = FormState.MINIMIZED
		else:
			self.show()
			_toMinButton()
			_toMinForm()
		got_minimized.emit(self, __current_mode == FormState.NORMAL)
	##
	# NORMAL only from hidden
	##
	elif next == FormState.NORMAL:
		self.show()
		_toNormalButton()
		_loadFormPosSize()
		__current_mode = FormState.NORMAL
	##
	# HIDDEN_TASK_TRAY (special handling window disktop)
	##
	elif next == FormState.HIDDEN_TASK_TRAY:
		self.hide()
