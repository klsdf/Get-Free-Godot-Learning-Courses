class_name DialogBlock
"""对话组（可链式构建）

设计原因：
- 提供链式 API，以接近自然语言的方式编写剧情。
- 允许在添加每句后继续设置该句的立绘与回调，提升可读性与效率。
"""

## 该组内的所有对话脚本
var scripts: Array[DialogScript]

func _init(p_scripts: Array[DialogScript] = []):
    """构造函数
    - scripts: 可选的初始脚本数组

    设计原因：允许空构造，便于作为 Builder 使用。
    """
    self.scripts = p_scripts

func size() -> int:
    """返回组内脚本数量"""
    return scripts.size()

func is_empty() -> bool:
    """是否为空"""
    return scripts.is_empty()

func add(content: String) -> DialogBlock:
    """链式：添加一句对话并返回自身"""
    var s := DialogScript.new(content)
    scripts.append(s)
    return self

func tachie(tex: Texture2D) -> DialogBlock:
    """链式：为最近一次 add 的那句设置立绘并返回自身

    设计原因：紧跟 add 使用，语义清晰：add(...).tachie(...)
    """
    if scripts.size() > 0:
        scripts[scripts.size() - 1].set_tachie(tex)
    return self

func tachie_path(path: String) -> DialogBlock:
    """链式：通过路径设置最近一句的立绘并返回自身"""
    if scripts.size() > 0:
        var tex := load(path)
        if tex is Texture2D:
            scripts[scripts.size() - 1].set_tachie(tex)
    return self

func on_play(callback: Callable) -> DialogBlock:
    """链式：为最近一句设置播放时回调并返回自身"""
    if scripts.size() > 0:
        scripts[scripts.size() - 1].set_callback(callback)
    return self