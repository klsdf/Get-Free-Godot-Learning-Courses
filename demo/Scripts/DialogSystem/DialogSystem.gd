class_name DialogSystem
extends Node

@onready var dialog_label: Label = $对话框
@onready var tachie : TextureRect = $立绘


static var _instance: DialogSystem
static var Instance: DialogSystem:
	get:
		return _instance


func _ready():
	_instance = self


func speak(content: String):
	dialog_label.text = content
