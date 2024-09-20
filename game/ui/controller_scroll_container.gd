# tabletop-club
# Copyright (c) 2020-2024 Benjamin 'drwhut' Beddows.
# Copyright (c) 2021-2024 Tabletop Club contributors (see game/CREDITS.tres).
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

class_name ControllerScrollContainer
extends Control

## A special container for buttons specifically for controllers.
##
## This container acts similarly to a horizontal scroll container, but it only
## detects D-pad inputs from controllers. It also adjusts the currently selected
## button to be in the centre of the container at all times.


## The amount of time that it should take in seconds for the container to fully
## switch to another button.
export(float, 0.1, 5.0) var switch_duration_secs := 1.0

## The margin between buttons.
export(float) var margin := 0.0

## The font used for the button text.
export(Font) var font_override: Font = null setget set_font_override


## The index of the currently selected button.
var selected := -1 setget set_selected


# The parent node for all the buttons.
var _button_parent: Control = null

# The direction that the container is currently spinning in.
# +1 means it is going from left to right, -1 is right to left.
var _direction := 1

# The amount of seconds that have passed since the user wanted to switch which
# button was selected.
var _time_passed_since_switch_secs := 0.0


func _init():
	_button_parent = Control.new()
	_button_parent.anchor_right = 1.0
	_button_parent.anchor_bottom = 1.0
	_button_parent.rect_clip_content = true
	add_child(_button_parent)


func _ready():
	# Exported variables are set just before _ready().
	_time_passed_since_switch_secs = switch_duration_secs


func _process(delta: float):
	# TODO: Don't set positions if we don't need to.
	_time_passed_since_switch_secs += delta
	_set_button_positions()


func _unhandled_input(event: InputEvent):
	# TODO: Use controller inputs.
	if event is InputEventKey:
		if not event.pressed:
			return
		
		if event.scancode == KEY_LEFT:
			selected -= 1
			if selected < 0:
				selected = _button_parent.get_child_count() - 1
			_direction = -1
			_time_passed_since_switch_secs = 0.0
		elif event.scancode == KEY_RIGHT:
			selected += 1
			if selected >= _button_parent.get_child_count():
				selected = 0
			_direction = 1
			_time_passed_since_switch_secs = 0.0


## Add a button to the container.
##
## [b]NOTE:[/b] [param id] is used as the button text as well - if the text
## should be translated, this should be set after the button has been added.
func add_button(id: String, icon: Texture) -> void:
	var button := VerticalButton.new()
	button.name = id
	button.vertical_text = id
	button.texture = icon
	button.font_override = font_override
	
	button.button_mask = 0 # Don't allow mouse clicks.
	button.focus_mode = Control.FOCUS_NONE
	
	var button_size := _button_parent.rect_size.y
	button.rect_min_size = Vector2(button_size, button_size)
	
	_button_parent.add_child(button)
	_set_button_positions()
	
	# If this is the first button to be added, select it immediately.
	if selected < 0:
		selected = 0


## Get the [Button] nodes as a list.
##
## [b]NOTE:[/b] These are direct references, so please don't do anything like
## free them.
func get_buttons() -> Array:
	return _button_parent.get_children()


func set_selected(new_value: int) -> void:
	if new_value < 0 or new_value >= _button_parent.get_child_count():
		push_error("Invalid value '%d' for selected button" % new_value)
		return
	
	selected = new_value
	
	# Since this was set manually in code, display the newly selected button in
	# the centre of the container immediately.
	_time_passed_since_switch_secs = switch_duration_secs
	_set_button_positions()


func set_font_override(new_font: Font) -> void:
	font_override = new_font
	
	# Replace the font for all buttons.
	for element in _button_parent.get_children():
		var button: VerticalButton = element
		button.font_override = new_font


# Set the positions of all buttons, given which button is selected, and how long
# ago the switch was.
func _set_button_positions() -> void:
	if selected < 0:
		return
	
	# Buttons are the same width and height, and their height is the same as the
	# container's.
	# TODO: Account for the fact that buttons might have different widths, so
	# that translations of the text can still be shown fully.
	var container_size := _button_parent.rect_size
	var total_shift_length := container_size.y + margin
	
	# If the selected button recently got switched, we want to show an animation
	# of the container shifting over to the new button.
	var time_deviation := 1.0 - (_time_passed_since_switch_secs / switch_duration_secs)
	var animation_time := max(0.0, time_deviation)
	var offset_abs := total_shift_length * animation_time * animation_time
	var offset := offset_abs * _direction
	
	var true_middle := 0.5 * (container_size.x - container_size.y)
	var selected_button: VerticalButton = _button_parent.get_child(selected)
	selected_button.rect_position = Vector2(true_middle + offset, 0.0)
	
	var num_buttons := _button_parent.get_child_count()
	var position_offset := 0
	for index_offset in range(1, num_buttons):
		# 1, -1, 2, -2, 3, -3, etc.
		position_offset = -position_offset
		if index_offset % 2 == 1:
			position_offset += 1
		
		var true_index := selected + position_offset
		if true_index < 0:
			true_index = num_buttons + true_index
		else:
			true_index %= num_buttons
		var button: VerticalButton = _button_parent.get_child(true_index)
		
		var true_position := true_middle + position_offset * total_shift_length
		button.rect_position = Vector2(true_position + offset, 0.0)
