class_name SelectableItemList extends GridContainer

class Item extends Object:
	@export var text : String
	@export var value : bool
	
	var label : Label
	var check_box : CheckBox
	
	func _init(text: String, value: bool, label: Label, check_box: CheckBox):
		# We set these first so we can update the text and value later with it updating in the UI
		self.label = label
		self.check_box = check_box
		
		self.text = text
		self.value = value
		
		update_nodes()
		
	func free():
		label.queue_free()
		check_box.queue_free()
	
	func update_nodes():
		label.text = self.text
		check_box.pressed = self.value

signal on_add_item(item)
signal on_remove_item(index)
signal on_item_value_changed(item)

var items : Array[Item] = []

func _init():
	columns = 2

func _ready() -> void:
	pass

func add_item(text: String, value: bool = false):
	# Create label
	var label : Label = Label.new()
	label.name = "Label" + str(items.size())
	label.size_flags_horizontal |= SIZE_EXPAND
	self.add_child(label)
	
	# Create checkbox
	var check_box : CheckBox = CheckBox.new()
	check_box.name = "CheckBox" + str(items.size())
	self.add_child(check_box)
	
	var item = Item.new(text, value, label, check_box)
	items.append(item)
	
	# Bind events so we can update the values and everything
	check_box.connect("toggled", _value_toggled, [item, items.size() - 1])
	
	emit_signal("on_add_item", item)

func remove_item(index: int):
	var item : Object = items[index]
	items.remove(index)
	item.free()
	emit_signal("on_remove_item", index)

func _value_toggled(value: bool, item: Item, index: int):
	item.value = value
	emit_signal("on_item_value_changed", item)
