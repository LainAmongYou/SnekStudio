extends BasicSubWindow

var _mods_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_get_app_root()._load_mods()
	
	var dir_access = DirAccessWithMods.new()

	var mod_scene_files = []

	var mod_dirs = dir_access.get_directory_list("res://Mods")
	for mod_dir in mod_dirs:
		var file_list = dir_access.get_file_list("res://Mods/" + mod_dir)
		for filename in file_list:
			if filename.ends_with("tscn"):
				mod_scene_files.append("res://Mods/" + mod_dir + "/" + filename)
				break			

	for mod_file in mod_scene_files:
		var mod_entry = {}
		mod_entry["name"] = mod_file.get_file().get_basename()
		mod_entry["path"] = mod_file
		_mods_list.append(mod_entry)
		%Mods_List.add_item(mod_entry["name"])

func _get_mods_node():
	# FIXME: Make a better way to get this data.
	return get_node("../../../Mods")

func _on_button_add_mod_pressed():
	
	var selected_index = %Mods_List.get_selected_items()
	if len(selected_index) > 0:
		var mod_script = load(_mods_list[selected_index[0]]["path"])
		var mod = mod_script.instantiate()
		_get_mods_node().add_child(mod)
		mod.scene_init()
		get_node("../ModsWindow").update_mods_list()
	
	


func _on_button_cancel_pressed():
	hide()
