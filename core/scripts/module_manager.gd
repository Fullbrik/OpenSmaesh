extends Node

const CONFIG_PATH = "user://core/config/modules.res"

var modules : Array[Module] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_config()

func load_config():
	print_debug('Loading config for modules...')
	var config_res = load(CONFIG_PATH)
	if(config_res): # If the resource file is loaded, than read it's values
		load_config_data(config_res as ModulesConfig)
	else: # Otherwise, save and load the default config
		print_debug("Couldn't find config for modules. Saving default config...")
		var defualt = load("res://modules_config.default.tres") as ModulesConfig
		
		# Make sure we have a config directory
		create_directory("user://core/config/")

		assert(ResourceSaver.save(CONFIG_PATH, defualt) == OK, "Couldn't save default config.")
		
		load_config_data(defualt)

func create_directory(dir: String):
	var directory := Directory.new()
	directory.make_dir_recursive(dir)

func load_config_data(config: ModulesConfig):
	for pck_name in config.pcks:
		pass # TODO: Load pck files
	
	for module_folder in config.modules:
		load_module(module_folder)

func load_module(module: String):
	var module_data := load("res://" + module + "/module.tres") as Module
	load_module_data(module_data)

func load_module_data(module: Module):
	assert(module.validate(), "Failed to validate module. Make sure all resources are of the correct type.")
	modules.append(module)

func find_modules() -> Array[String]:
	var module_list : Array[String] = []
	
	print_debug("Starting search for modules...")
	
	# We look in each folder in res://. If that folder has a module.tres in it, we add it too the list
	var dir := Directory.new()
	dir.open("res://")
	
	dir.list_dir_begin()
	var subdir_name = dir.get_next()
	while subdir_name != "":
		print_debug("Looking in folder: ", subdir_name)
		
		if(dir.dir_exists(subdir_name) and dir.file_exists(subdir_name + "/module.tres")):
			print_debug("Found module: ", subdir_name)
			module_list.append(subdir_name)
		
		subdir_name = dir.get_next()
	
	return module_list

