class_name Typewriter
extends Node

## 打字机：逐字显示文本的独立工具类
## 设计原因：
## - 与对话系统解耦，任何脚本只需传入 Label 与文本即可使用。
## - 提供跳过能力，便于与“下一句”按钮复用：第一次按下加速/补全当前句，第二次按下切到下一句。

## 每秒显示的字符数量（建议 20~40）
@export var chars_per_second: float = 30.0

## 标点额外停顿（毫秒），用于句号/逗号/叹号/问号等
@export var punctuation_extra_delay_ms: int = 80

## 正在打字的状态标记
var _is_typing: bool = false

## 当前目标 Label
var _target_label: Label

## 当前完整文本
var _full_text: String = ""

## 已显示到的索引
var _current_index: int = 0

## 打字完成信号
signal finished

func is_typing() -> bool:
	"""是否正在逐字显示"""
	return _is_typing

func skip() -> void:
	"""立即补全当前文本并结束打字"""
	if not _is_typing:
		return
	if _target_label:
		_target_label.text = _full_text
	_is_typing = false
	_current_index = _full_text.length()
	finished.emit()

func reset() -> void:
	"""重置内部状态"""
	_is_typing = false
	_target_label = null
	_full_text = ""
	_current_index = 0

func type_text(target: Label, text: String) -> void:
	"""开始逐字显示文本

	- target: 目标 Label
	- text:   完整文本

	设计原因：
	- 不返回协程句柄，直接在内部管理状态，便于外界通过 is_typing/skip 查询与控制。
	"""
	# 若上一次还在进行，则先补全
	if _is_typing:
		skip()

	_target_label = target
	_full_text = text
	_current_index = 0
	_is_typing = true
	if _target_label:
		_target_label.text = ""

	var base_interval := 0.0
	if chars_per_second > 0.0:
		base_interval = 1.0 / chars_per_second
	else:
		base_interval = 0.0

	while _is_typing and _current_index < _full_text.length():
		var ch := _full_text[_current_index]
		_current_index += 1
		if _target_label:
			_target_label.text = _full_text.substr(0, _current_index)

		# 计算延时：基础间隔 + 标点额外停顿
		var delay := base_interval
		if ch in [",", "，", ".", "。", "!", "！", "?", "？", ";", "；", ":", "："]:
			delay += float(punctuation_extra_delay_ms) / 1000.0

		if delay <= 0.0:
			await get_tree().process_frame
		else:
			await get_tree().create_timer(delay).timeout

	# 循环自然结束或被 skip()
	if _is_typing:
		# 逐字自然走完
		_is_typing = false
	finished.emit()


