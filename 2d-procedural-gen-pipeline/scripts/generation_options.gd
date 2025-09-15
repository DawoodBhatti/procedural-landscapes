extends OptionButton

#here we emit signals when different phases are selected
#and we also override the default text size for dropdown items

@onready var signals = %SignalManager

func _ready():
	var popup = get_popup()
	popup.theme = preload("res://themes/dropdown_theme.tres")

	# Emit the signal manually for the currently selected item
	var initial_index = get_selected()
	_on_item_selected(initial_index)
	

func _on_item_selected(index: int) -> void:
	#print("Item selected:", %DistOptions.get_item_text(index))
	var selected_item : String = %GenOptions.get_item_text(index)
	signals.emit_logged("gen_phase_selected", selected_item)
