#include "yan_class.h"
// 添加必要的头文件
#include "godot_cpp/variant/string.hpp"

void YanClass::_bind_methods() {
	godot::ClassDB::bind_method(D_METHOD("log_info", "message"), &YanClass::log_info);
}

void YanClass::log_info(const String &p_message) const {
	print_line(vformat("Custom Info: %s", p_message));
}