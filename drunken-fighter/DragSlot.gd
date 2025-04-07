extends Slot

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	return self
	
func get_preview():
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = icon
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30,30)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	return preview
	
func _can_drop_data(_pos, data):
	return data is Button
	
func _drop_data(_pos, data):
	var temp = icon
	icon = data.icon
	data.icon = temp
	
	temp = stats
	stats = data.stats
	data.stats = temp
	
	temp = skill
	skill = data.skill
	data.skill = temp
	
	owner.find_child("Weapons").swap(get_index(),data.get_index())
