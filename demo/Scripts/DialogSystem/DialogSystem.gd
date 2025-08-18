class_name DialogSystem
extends Control

@export var dialog_label: Label
@export var tachie : TextureRect 

@export var button_next: Button 

## 可选：打字机组件（解耦，按需赋值或脚本创建）
@export var typewriter: Typewriter

static var _instance: DialogSystem
static var Instance: DialogSystem:
	get:
		return _instance

# 对话相关变量
var current_dialog_block: DialogBlock  # 存储多句话的队列
var current_dialog_index: int = 0     # 当前播放的对话索引
var is_playing_dialog: bool = false   # 是否正在播放对话

func _ready():
	_instance = self
	# 连接按钮点击事件
	button_next.pressed.connect(_on_next_button_pressed)
	# 初始化时隐藏按钮
	button_next.visible = false

func speak(content: String):
	"""播放单句话"""
	dialog_label.text = content
	button_next.visible = false



func speak_multiple_dialogs(dialog_block: DialogBlock):
	"""播放多句话，通过按钮逐句播放"""
	# 清空之前的对话队列
	current_dialog_block = dialog_block
	
	# 重置索引和状态
	current_dialog_index = 0
	is_playing_dialog = true
	
	# 显示第一句话
	if current_dialog_block.size() > 0:
		_show_dialog_at_index(0)
		button_next.visible = true


	
	else:
		# 如果没有对话内容，隐藏按钮
		button_next.visible = false
		is_playing_dialog = false

func _on_next_button_pressed():
	"""按钮点击事件处理"""
	# 若正在打字，则优先补全当前句，而不是切到下一句
	if typewriter and typewriter.is_typing():
		typewriter.skip()
		return
	if not is_playing_dialog or current_dialog_block.scripts.is_empty():
		return
	
	# 播放下一句话
	current_dialog_index += 1
	
	if current_dialog_index < current_dialog_block.scripts.size():
		# 还有更多对话
		_show_dialog_at_index(current_dialog_index)
	else:
		# 对话播放完毕
		button_next.visible = false
		is_playing_dialog = false
		# 可以在这里触发对话结束事件
		_on_dialog_finished()

func _show_dialog_at_index(index: int) -> void:
	"""展示指定索引的对话，应用立绘与回调；若配置了打字机，则逐字显示"""
	var script: DialogScript = current_dialog_block.scripts[index]
	# 应用立绘（允许为空）
	tachie.texture = script.tachie
	# 文本：打字机优先，否则直接赋值
	if typewriter:
		typewriter.type_text(dialog_label, script.content)
	else:
		dialog_label.text = script.content
	# 本句回调（如果存在）
	if script.callback and not script.callback.is_null():
		script.callback.call()

func _on_dialog_finished():
	"""对话播放完毕时的回调函数"""
	# 这里可以添加对话结束后的逻辑
	# 比如触发下一个事件、显示选项等
	print("对话播放完毕")



func clear_dialog():
	"""清空对话队列"""
	current_dialog_block.scripts.clear()
	current_dialog_index = 0
	is_playing_dialog = false
	button_next.visible = false
	dialog_label.text = ""

func get_current_dialog() -> String:
	"""获取当前显示的对话内容"""
	return dialog_label.text

func get_remaining_dialogs() -> int:
	"""获取剩余未播放的对话数量"""
	return max(0, current_dialog_block.scripts.size() - current_dialog_index - 1)

func is_dialog_playing() -> bool:
	"""检查是否正在播放对话"""
	return is_playing_dialog
