extends Control
class_name FormContainer

@onready var icons: GridContainer = $matchIcons/Icons
@onready var form_container: Control = $matchForm/FormContainer

func add_form_element(frm:Form):
	form_container.add_child(frm)

func add_form_element_setMinMoving(frm:Form):
	form_container.add_child(frm)
	frm.got_minimized.connect(move_min)

func add_icon_element(ico:Icon):
	icons.add_child(ico)

func move_min(me:Form,to_normal: bool):
	#me.size = Vector2(me.minSize.x,me.minSize.y)
	#me.position = Vector2(15, 
	#	me.get_parent_control().size.y-me.minSizeOffSet)
	var margin:int = 5
	var posX = me.position.x
	var posY = me.position.y
	var searching:bool = true;

	while searching:
		searching = false
		for frm:Form in form_container.get_children(false):
			if me == frm: ## me is on first position:
				continue
			if frm.position.x == posX\
				and frm.position.y == posY: ## some other is on pos
				posX = posX + margin + me.size.x
				if posX + me.size.x > self.size.x: ## min is to long
					posY = posY - margin - me.size.y
					posX = margin
				searching = true
	
	me.position = Vector2(posX,posY)
