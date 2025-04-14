extends Resource
class_name Item

@export var icon: Texture2D
@export var name: String

@export_enum("Weapon", "Throwables", "Scrolls")
var type = "Weapon"

@export_multiline var description: String
@export var durability: int = 10 # Default durability value
