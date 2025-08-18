class_name 开场剧情
extends Control


var button_next: Button
var button_skip: Button


## 剧情文本标签
var dialog_label: Label

## 剧情内容数组
var story_lines: Array[String] = [
	"天下之苦Unity久矣...",
    "Unity仗着自己庞大的用户群体, 和先发的壁垒\n越来越不把开发者当人看",
    "开发者敢怒不敢言",
    "所有人都在等待一个机会\n一个可以反抗unity的机会.",
    "2014年12月14日, godot 1.0 发布. ",
    "从此,吸引了无数开发者加入其阵营.",
    "然而unity的地位一时仍不可撼动.",
    "其中, unity最邪恶\n吃相最难看的行为\n莫过于成立unity大学了.",
    "unity大学不仅学费极其高昂,而且培训时间短\n很难让小白学到东西",
    "开发者们为了反抗unity大学, 成立了godot大学",
    "godot大学不仅完全免学费,\n里面更是有无数美少女学生\n",
    "你作为一个新生, 也是第一届godot大学的学生",
    "即将在此度过一段美好的校园生活",
    "你将会和美少女同学一起上课, 学习gdscript",
    "除了学业外, 你们还会度过有趣的校园祭和各种校园活动",
    "准备好了吗,属于你的校园生活即将开始!",
    ",,,,,",
    "本来是这样设定的...",
    "但是, 遗憾的是\n 上述内容均不会在本游戏内出现....",
    "啊, 失礼了"
]

## 当前剧情索引
var current_story_index: int = 0

## 剧情播放完成信号
signal story_completed


## 打字机效果相关变量
var is_typing: bool = false  # 是否正在打字
var current_typing_text: String = ""  # 当前正在打字的文本
var typing_speed: float = 0.05  # 打字速度（秒/字符）
var typing_timer: Timer  # 打字计时器


func _ready():
	"""初始化开场剧情"""
	# 查找并获取必要的节点
	button_next = find_node_by_name(self, "ButtonNext")
	dialog_label = find_node_by_name(self, "DialogLabel")
	button_skip = find_node_by_name(self, "ButtonSkip")
	
	# 创建打字机计时器
	typing_timer = Timer.new()
	typing_timer.wait_time = typing_speed
	typing_timer.timeout.connect(_on_typing_timer_timeout)
	add_child(typing_timer)
	
	# 连接按钮信号
	if button_next:
		button_next.button_down.connect(_on_next_button_pressed)
		print("下一个按钮信号已连接")
	else:
		print("错误：未找到 ButtonNext 按钮")

	if button_skip:
		button_skip.button_down.connect(_on_skip_button_pressed)
		print("跳过按钮信号已连接")
	else:
		print("错误：未找到 ButtonSkip 按钮")
	
	# 初始化剧情显示
	_show_current_story()
	
	print("开场剧情已初始化")

func _on_skip_button_pressed():
	"""跳过按钮被点击"""
	print("跳过按钮被点击")
	
	_on_story_completed()


## 递归查找指定名称的节点
func find_node_by_name(root: Node, target_name: String) -> Node:
	"""递归遍历所有子节点，查找指定名称的节点"""
	if root.name == target_name:
		return root
	
	# 遍历所有子节点
	for child in root.get_children():
		var result = find_node_by_name(child, target_name)
		if result:
			return result
	
	return null

## 显示当前剧情
func _show_current_story():
	"""显示当前剧情内容，使用打字机效果"""
	if dialog_label and current_story_index < story_lines.size():
		# 开始打字机效果
		_start_typing_effect(story_lines[current_story_index])
		print("开始播放剧情: " + story_lines[current_story_index])
	
	# 更新按钮文本
	if button_next:
		if current_story_index < story_lines.size() - 1:
			button_next.text = "下一个"
		else:
			button_next.text = "开始游戏"

## 开始打字机效果
func _start_typing_effect(text: String):
	"""开始打字机效果，逐字显示文本"""
	if is_typing:
		# 如果正在打字，立即完成当前文本
		_complete_typing()
	
	# 重置打字机状态
	is_typing = true
	current_typing_text = ""
	dialog_label.text = ""
	
	# 开始计时器
	typing_timer.start()

## 打字机计时器超时事件
func _on_typing_timer_timeout():
	"""打字机计时器超时，显示下一个字符"""
	if not is_typing:
		return
	
	var target_text = story_lines[current_story_index]
	
	if current_typing_text.length() < target_text.length():
		# 添加下一个字符
		current_typing_text += target_text[current_typing_text.length()]
		dialog_label.text = current_typing_text
	else:
		# 文本显示完成
		_complete_typing()

## 完成打字机效果
func _complete_typing():
	"""完成打字机效果"""
	is_typing = false
	typing_timer.stop()
	
	# 确保显示完整文本
	var target_text = story_lines[current_story_index]
	dialog_label.text = target_text
	
	print("剧情显示完成: " + target_text)

## 下一个按钮点击事件
func _on_next_button_pressed():
	"""下一个按钮被点击，播放下一个剧情"""
	print("下一个按钮被点击")
	
	# 如果正在打字，立即完成
	if is_typing:
		_complete_typing()
		return
	
	# 播放下一个剧情
	_play_next_story()

## 播放下一个剧情
func _play_next_story():
	"""播放下一个剧情内容"""
	current_story_index += 1
	
	if current_story_index < story_lines.size():
		# 还有剧情要播放
		_show_current_story()
		print("播放剧情 " + str(current_story_index + 1) + "/" + str(story_lines.size()))
	else:
		# 所有剧情播放完成
		_on_story_completed()

## 剧情播放完成
func _on_story_completed():
	"""所有剧情播放完成"""
	print("所有剧情播放完成！")
	
	# 发送剧情完成信号
	story_completed.emit()
	
	# 可以在这里添加一些完成后的逻辑
	# 比如自动切换到下一个场景
	_complete_intro()

## 完成开场剧情
func _complete_intro():
	"""完成开场剧情后的处理"""
	# 隐藏当前场景
	visible = false
	
	# 或者通知父节点切换场景
	var parent = get_parent()
	if parent and parent.has_method("on_intro_completed"):
		parent.on_intro_completed()

## 重置剧情进度
func reset_story():
	"""重置剧情进度，重新开始"""
	current_story_index = 0
	if is_typing:
		_complete_typing()
	_show_current_story()
	print("剧情进度已重置")

## 跳转到指定剧情
func jump_to_story(index: int):
	"""跳转到指定索引的剧情"""
	if index >= 0 and index < story_lines.size():
		current_story_index = index
		if is_typing:
			_complete_typing()
		_show_current_story()
		print("跳转到剧情: " + str(index + 1))
	else:
		print("错误：无效的剧情索引: " + str(index))

## 获取当前剧情进度
func get_story_progress() -> float:
	"""获取当前剧情进度（0.0 到 1.0）"""
	if story_lines.size() > 0:
		return float(current_story_index + 1) / float(story_lines.size())
	return 0.0

## 设置打字速度
func set_typing_speed(speed: float):
	"""设置打字机效果的速度（秒/字符）"""
	typing_speed = speed
	if typing_timer:
		typing_timer.wait_time = typing_speed

## 跳过打字机效果
func skip_typing():
	"""跳过当前打字机效果，立即显示完整文本"""
	if is_typing:
		_complete_typing()