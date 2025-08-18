class_name DialogScript
"""对话的脚本

设计原因：
- 将每一句对话的附加信息（立绘、播放回调）和文本一起封装，便于在系统内统一处理。
- 提供链式设置方法，提升剧情脚本的可读性与编写效率。
"""

## 对话文本内容
var content: String

## 该句对应的立绘纹理（可选）
var tachie: Texture2D

## 播放该句时触发的回调（可选）
var callback: Callable

func _init(content: String):
    """构造函数
    - content: 对话文本
    设计原因：默认允许不传立绘与回调，降低使用门槛。
    """
    self.content = content

func set_tachie(texture: Texture2D) -> DialogScript:
    """链式：为该句设置立绘纹理并返回自身"""
    self.tachie = texture
    return self


func set_callback(callback: Callable) -> DialogScript:
    """链式：设置播放回调并返回自身"""
    self.callback = callback
    return self
