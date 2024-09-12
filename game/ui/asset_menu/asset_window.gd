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

extends WindowDialog

## A window which displays directories of assets that the user can choose from.


## Fired when the user has selected an asset.
signal asset_selected(asset_entry)


## The top-level directory that this window uses.
## This is used to specify which types of assets the user can choose from.
export(String) var category := ""

## The default directory path that the window will start at.
## [b]NOTE:[/b] This is appended to [member category] to make the full path.
export(String) var default_path := "/%ALL_PACKS%"


## The directory path that is currently being shown to the user.
var current_path: String setget set_current_path


onready var _asset_breadcrumb: AssetBreadcrumb = $MainContainer/BreadcrumbScrollContainer/AssetBreadcrumb
onready var _asset_grid: AssetGrid = $MainContainer/AssetScrollContainer/AssetGrid


func _ready():
	# TEMP
	var ttc_pack := preload("res://assets/default_pack/ttc_pack.tres")
	ttc_pack.reset_dictionary()
	AssetDB.add_pack(ttc_pack)
	AssetDB.commit_changes()
	
	call_deferred("popup_centered")
	
	# This should generate the content for the default directory, as the AssetDB
	# should have the default asset pack already added at the start of the game.
	set_current_path("/" + category + default_path)
	
	AssetTree.connect("tree_generated", self, "_on_AssetTree_tree_generated")


# TEMP
func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_released():
			return
		
		if event.scancode == KEY_L:
			_asset_grid.layout = AssetGrid.GridLayout.LIST
		elif event.scancode == KEY_I:
			_asset_grid.layout = AssetGrid.GridLayout.ICON
		elif event.scancode == KEY_MINUS:
			if _asset_grid.zoom == 0:
				return
			_asset_grid.zoom -= 1
		elif event.scancode == KEY_EQUAL:
			if _asset_grid.zoom == 3:
				return
			_asset_grid.zoom += 1


func set_current_path(new_value: String) -> void:
	var asset_node := AssetTree.get_asset_node(new_value)
	if asset_node == null:
		push_error("Cannot set path to '%s', node does not exist" % new_value)
		return
	
	current_path = new_value
	
	_asset_breadcrumb.set_dir(current_path)
	_asset_grid.asset_node = asset_node
	_asset_grid.refresh()


func _on_AssetTree_tree_generated():
	if AssetTree.get_asset_node(current_path) == null:
		# The node we were displaying no longer exists, so revert back to the
		# default path.
		set_current_path("/" + category + default_path)
	else:
		# The node still exists, but it's contents may have changed.
		_asset_grid.refresh()


func _on_AssetBreadcrumb_dir_selected(dir_path: String):
	set_current_path(dir_path)


func _on_AssetGrid_asset_selected(asset_entry: AssetEntry):
	emit_signal("asset_selected", asset_entry)


func _on_AssetGrid_node_selected(node_id: String):
	var new_path := current_path + "/" + node_id
	var asset_node := AssetTree.get_asset_node(new_path)
	if asset_node == null:
		push_error("Cannot set path to '%s', node does not exist" % new_path)
		return
	
	current_path = new_path
	_asset_breadcrumb.append_dir(new_path)
	_asset_grid.asset_node = asset_node
	_asset_grid.refresh()
