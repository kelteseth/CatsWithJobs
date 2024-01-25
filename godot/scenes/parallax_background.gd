extends Control

@export var influence_value: int = 1
@export var lerp_factor = 0.1 

class ParallaxItem:
	var ref #: RefCounted(ParallaxItem)
	var position: Vector2
	var index: int
	
var mouse_position = Vector2()
var parallaxItemList = []

func _ready():
	set_process_input(true)
	var index = 1
	for child in get_children():
		var c: ParallaxItem = ParallaxItem.new()
		c.ref = child
		c.position = child.position
		c.index = index
		parallaxItemList.append(c)
		index += 1

func _input(event):
	if event is InputEventMouseMotion:
		mouse_position = event.position

func _process(delta):
	for child: ParallaxItem in parallaxItemList:
		var z_factor = child.index * influence_value
		var parallax_effect = (mouse_position - Vector2(get_viewport().size) / 2) * z_factor
		var target_position = child.position + parallax_effect * delta
		child.ref.position = child.ref.position.lerp(target_position, lerp_factor)

