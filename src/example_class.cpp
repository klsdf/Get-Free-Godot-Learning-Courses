#include "example_class.h"
// 添加必要的头文件
#include "godot_cpp/variant/string.hpp"

void ExampleClass::_bind_methods() {
	godot::ClassDB::bind_method(D_METHOD("print_type", "variant"), &ExampleClass::print_type);
	// 绑定新方法
	godot::ClassDB::bind_method(D_METHOD("print_error", "message"), &ExampleClass::print_error);
}

void ExampleClass::print_type(const Variant &p_variant) const {
	print_line(vformat("Type: %d", p_variant.get_type()));
}


void ExampleClass::print_error(const String &p_message) const {
	print_line(vformat("Custom Error: %s", p_message));
}