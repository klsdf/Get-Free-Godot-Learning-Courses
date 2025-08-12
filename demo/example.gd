extends Node


func _ready() -> void:
	var example := ExampleClass.new()
	example.print_type(example)
	example.print_error("自定义Error")

	var yan := YanClass.new()
	yan.log_info("自定义Info")
