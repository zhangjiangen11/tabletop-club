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

extends Control

## The bar shown at the top of the in-game UI, when a controller is being used.


onready var _controller_scroll: ControllerScrollContainer = $ViewportContainer/Viewport/ControllerScrollContainer


func _ready():
	_controller_scroll.add_button("objects", preload("res://icons/pawn_icon.svg"))
	_controller_scroll.add_button("games", preload("res://icons/collection_icon.svg"))
	_controller_scroll.add_button("room", preload("res://icons/table_icon.svg"))
	_controller_scroll.add_button("notebook", preload("res://icons/notebook_icon.svg"))
	_controller_scroll.add_button("undo", preload("res://icons/undo_icon.svg"))
	_controller_scroll.add_button("redo", preload("res://icons/undo_icon_flipped.svg"))
	_controller_scroll.add_button("load", preload("res://icons/load_icon.svg"))
	_controller_scroll.add_button("save", preload("res://icons/save_icon.svg"))
	_controller_scroll.add_button("menu", preload("res://icons/menu_icon.svg"))
