extends OptionButton

#we created a theme override and applied it to our dropdown menus
#to resize the text

# Attach this to your OptionButton node
func _ready():
	var popup = get_popup()
	popup.theme = preload("res://dropdown_theme.tres")  # Use your actual theme path
