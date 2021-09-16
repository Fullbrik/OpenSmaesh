class_name Module extends Resource

@export var name: String = ""
@export var folder: String = ""
@export var characters: Array[Resource] = []

func validate() -> bool:
	for character in characters:
		if not character is CharacterData:
			return false
	
	return true
