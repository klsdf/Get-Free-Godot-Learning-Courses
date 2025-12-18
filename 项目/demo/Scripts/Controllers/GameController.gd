class_name GameController
extends Node

@onready var scene_controller: YanSceneController = $SceneController
var story_controller: StoryController



## 单例实例
static var _instance: GameController

## 单例访问器
static var Instance: GameController:
	get:
		if not _instance:
			_instance = GameController.new()
		return _instance


func _ready():
	_instance = self
	scene_controller.show_scene_by_enum(scene_controller.GameScenes.MAIN_MENU)

	story_controller = StoryController.new()
