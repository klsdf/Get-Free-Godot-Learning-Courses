extends Control

## 开始场景控制器
## 负责处理三个按钮的点击事件和场景切换逻辑

func _ready():
	"""初始化开始场景"""
	# 获取场景管理器引用

	
	# 连接按钮信号
	_connect_button_signals()
	
	print("开始场景已初始化")

## 连接所有按钮的信号
func _connect_button_signals():
	"""连接三个按钮的点击信号"""
	var button_start = YanGF.Util.find_local_node_by_name(self, "ButtonStart")
	var button_setting = YanGF.Util.find_local_node_by_name(self, "ButtonSetting")
	var button_exit = YanGF.Util.find_local_node_by_name(self, "ButtonExit")
	
	if button_start:
		button_start.pressed.connect(_on_start_button_pressed)

	
	if button_setting:
		button_setting.pressed.connect(_on_setting_button_pressed)

	
	if button_exit:
		button_exit.pressed.connect(_on_exit_button_pressed)

## 开始游戏按钮点击事件
func _on_start_button_pressed():
	"""开始游戏按钮被点击"""

	var scene_controller = GameController.Instance.scene_controller

	scene_controller.show_scene_by_enum(scene_controller.GameScenes.DIALOG)
	DialogSystem.Instance.speak_multiple_dialogs(Storys.story_1)	
	

	

## 第二个按钮点击事件
func _on_setting_button_pressed():
	"""第二个按钮被点击"""
	print("第二个按钮被点击")
	
	GameController.Instance.scene_controller.show_scene("对话系统")
	print("已切换到对话系统场景")

## 第三个按钮点击事件
func _on_exit_button_pressed():
	"""第三个按钮被点击"""
	get_tree().quit()


## 场景显示时的回调
func _on_scene_shown():
	"""当场景被显示时调用"""
	print("开始场景已显示")
	# 可以在这里添加一些初始化逻辑

## 场景隐藏时的回调
func _on_scene_hidden():
	"""当场景被隐藏时调用"""
	print("开始场景已隐藏")
	# 可以在这里添加一些清理逻辑
