class_name YanSceneController
extends Node

## 当前激活的场景
var current_scene: Node = null

## 所有场景的引用
var scenes: Dictionary = {}

## 游戏场景枚举
enum GameScenes {
	DIALOG,
	MAIN_MENU,
	Game,
}

func _ready():
	"""初始化场景管理器"""
	# 获取所有场景节点的引用
	scenes["SceneMainMenu"] = $SceneMainMenu
	scenes["SceneGame"] = $SceneGame
	scenes["SceneDialog"] = $SceneDialog





func show_scene_by_enum(scene: GameScenes) -> Node:
	"""使用枚举显示场景"""
	match scene:
		GameScenes.MAIN_MENU:
			show_scene("SceneMainMenu")
		GameScenes.Game:
			show_scene("SceneGame")
		GameScenes.DIALOG:
			show_scene("SceneDialog")

	return current_scene


## 显示指定场景，隐藏其他场景
func show_scene(scene_name: String) -> Node:
	"""显示指定场景，隐藏其他所有场景"""
	if not scenes.has(scene_name):
		print("错误：未找到场景: " + scene_name)
		return
	
	# 隐藏所有场景
	for scene_node in scenes.values():
		if scene_node:
			scene_node.visible = false
	
	# 显示指定场景
	scenes[scene_name].visible = true
	current_scene = scenes[scene_name]
	print("切换到场景: " + scene_name)
	return current_scene

## 切换场景（带淡入淡出效果）
func switch_scene(scene_name: String, fade_duration: float = 0.5):
	"""带淡入淡出效果的场景切换"""
	if not scenes.has(scene_name):
		return
	
	# 创建淡出效果
	var tween = create_tween()
	tween.tween_property(current_scene, "modulate:a", 0.0, fade_duration)
	
	# 等待淡出完成后切换场景
	await tween.finished
	show_scene(scene_name)
	
	# 淡入新场景
	tween = create_tween()
	tween.tween_property(current_scene, "modulate:a", 1.0, fade_duration)

## 显示多个场景
func show_scenes(scene_names: Array):
	"""同时显示多个场景"""
	# 先隐藏所有场景
	for scene_node in scenes.values():
		if scene_node:
			scene_node.visible = false
	
	# 显示指定的场景
	for scene_name in scene_names:
		if scenes.has(scene_name) and scenes[scene_name]:
			scenes[scene_name].visible = true
