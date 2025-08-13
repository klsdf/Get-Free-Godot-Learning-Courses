#include "yan_class.h"
// 添加必要的头文件
#include "godot_cpp/variant/string.hpp"
#include "godot_cpp/variant/dictionary.hpp"
#include "godot_cpp/classes/script.hpp"
#include "godot_cpp/classes/gd_script.hpp"
#include "godot_cpp/classes/resource_loader.hpp"
#include "godot_cpp/classes/resource_saver.hpp"
#include "godot_cpp/variant/array.hpp"
#include "godot_cpp/variant/packed_string_array.hpp"
#include "godot_cpp/classes/engine.hpp"
#include "godot_cpp/classes/script_language.hpp"
#include "godot_cpp/godot.hpp"
#include <iostream>
#include <sstream>

// 静态成员初始化
std::vector<std::string> YanClass::error_messages;
std::vector<std::string> YanClass::warning_messages;
bool YanClass::error_interception_enabled = false;

// 初始化原始函数指针
void (*YanClass::original_print_error)(const char*, const char*, const char*, int32_t, GDExtensionBool) = nullptr;
void (*YanClass::original_print_warning)(const char*, const char*, const char*, int32_t, GDExtensionBool) = nullptr;
void (*YanClass::original_print_script_error)(const char*, const char*, const char*, int32_t, GDExtensionBool) = nullptr;

// 构造函数
YanClass::YanClass() {
	// 构造函数中不需要特殊处理
}

// 析构函数
YanClass::~YanClass() {
	// 析构时恢复原始错误处理
	if (YanClass::error_interception_enabled) {
		restore_error_interception();
	}
}

// 自定义错误处理函数 - 拦截所有错误
void YanClass::custom_print_error(const char* p_description, const char* p_function, const char* p_file, int32_t p_line, GDExtensionBool p_editor_notify) {
	if (YanClass::error_interception_enabled) {
		// 构建错误消息
		std::stringstream ss;
		ss << "[ERROR] ";
		if (p_description) ss << p_description << " ";
		if (p_function) ss << "in " << p_function << " ";
		if (p_file) ss << "at " << p_file << ":" << p_line;
		
		std::string message = ss.str();
		YanClass::error_messages.push_back(message);
		
		// 输出到控制台
		std::cerr << message << std::endl;

		print_line(String::utf8("成功拦截到了错误!!!!!"));
	}
	
	// 调用原始函数（如果存在）
	if (original_print_error) {
		original_print_error(p_description, p_function, p_file, p_line, p_editor_notify);
	}
}

// 自定义警告处理函数 - 拦截所有警告
void YanClass::custom_print_warning(const char* p_description, const char* p_function, const char* p_file, int32_t p_line, GDExtensionBool p_editor_notify) {
	if (YanClass::error_interception_enabled) {
		// 构建警告消息
		std::stringstream ss;
		ss << "[WARNING] ";
		if (p_description) ss << p_description << " ";
		if (p_function) ss << "in " << p_function << " ";
		if (p_file) ss << "at " << p_file << ":" << p_line;
		
		std::string message = ss.str();
		YanClass::warning_messages.push_back(message);
		
		// 输出到控制台
		std::cout << message << std::endl;
	}
	
	// 调用原始函数（如果存在）
	if (original_print_warning) {
		original_print_warning(p_description, p_function, p_file, p_line, p_editor_notify);
	}
}

// 自定义脚本错误处理函数 - 拦截所有脚本错误
void YanClass::custom_print_script_error(const char* p_description, const char* p_function, const char* p_file, int32_t p_line, GDExtensionBool p_editor_notify) {
	if (YanClass::error_interception_enabled) {
		// 构建脚本错误消息
		std::stringstream ss;
		ss << "[SCRIPT_ERROR] ";
		if (p_description) ss << p_description << " ";
		if (p_function) ss << "in " << p_function << " ";
		if (p_file) ss << "at " << p_file << ":" << p_line;
		
		std::string message = ss.str();
		YanClass::error_messages.push_back(message);
		print_line(String::utf8("成功拦截到了脚本错误!!!!!"));
		// 输出到控制台
		std::cerr << message << std::endl;
	}
	
	// 调用原始函数（如果存在）
	if (original_print_script_error) {
		original_print_script_error(p_description, p_function, p_file, p_line, p_editor_notify);
	}
}

// 设置错误拦截 - 替换 Godot 的错误处理函数
void YanClass::setup_error_interception() {
	// 保存原始的 Godot 错误处理函数指针
	original_print_error = internal::gdextension_interface_print_error;
	original_print_warning = internal::gdextension_interface_print_warning;
	original_print_script_error = internal::gdextension_interface_print_script_error;
	
	// 替换为我们的自定义函数
	internal::gdextension_interface_print_error = custom_print_error;
	internal::gdextension_interface_print_warning = custom_print_warning;
	internal::gdextension_interface_print_script_error = custom_print_script_error;
	
	print_line(String::utf8("已成功替换 Godot 错误处理函数 - 现在可以拦截所有错误和警告！"));
}

// 恢复原始错误处理
void YanClass::restore_error_interception() {
	// 恢复原始的 Godot 错误处理函数
	if (original_print_error) {
		internal::gdextension_interface_print_error = original_print_error;
	}
	if (original_print_warning) {
		internal::gdextension_interface_print_warning = original_print_warning;
	}
	if (original_print_script_error) {
		internal::gdextension_interface_print_script_error = original_print_script_error;
	}
	
	print_line(String::utf8("已恢复原始 Godot 错误处理函数"));
}

void YanClass::_bind_methods() {
	godot::ClassDB::bind_method(D_METHOD("log_info", "message"), &YanClass::log_info);
	godot::ClassDB::bind_method(D_METHOD("get_script_errors", "script"), &YanClass::get_script_errors);
	godot::ClassDB::bind_method(D_METHOD("validate_script_syntax", "code"), &YanClass::validate_script_syntax);
	godot::ClassDB::bind_method(D_METHOD("get_script_compilation_status", "script"), &YanClass::get_script_compilation_status);
	godot::ClassDB::bind_method(D_METHOD("enable_error_interception"), &YanClass::enable_error_interception);
	godot::ClassDB::bind_method(D_METHOD("disable_error_interception"), &YanClass::disable_error_interception);
	godot::ClassDB::bind_method(D_METHOD("get_intercepted_errors"), &YanClass::get_intercepted_errors);
	godot::ClassDB::bind_method(D_METHOD("get_intercepted_warnings"), &YanClass::get_intercepted_warnings);
	godot::ClassDB::bind_method(D_METHOD("clear_intercepted_messages"), &YanClass::clear_intercepted_messages);
	godot::ClassDB::bind_method(D_METHOD("get_latest_error"), &YanClass::get_latest_error);
	godot::ClassDB::bind_method(D_METHOD("get_error_count"), &YanClass::get_error_count);
	godot::ClassDB::bind_method(D_METHOD("get_warning_count"), &YanClass::get_warning_count);
	godot::ClassDB::bind_method(D_METHOD("has_new_errors"), &YanClass::has_new_errors);
	godot::ClassDB::bind_method(D_METHOD("get_error_summary"), &YanClass::get_error_summary);
}

void YanClass::log_info(const String &p_message) const {
	print_line(vformat("Custom Info: %s", p_message));
}

Dictionary YanClass::get_script_errors(const Ref<Script> &p_script) const {
	Dictionary result;
	
	// 检查脚本是否为空
	if (p_script.is_null()) {
		result["valid"] = false;
		result["error"] = String::utf8("脚本对象为空");
		result["error_code"] = -1;
		return result;
	}
	
	// 检查脚本是否有源代码
	if (!p_script->has_source_code()) {
		result["valid"] = false;
		result["error"] = String::utf8("脚本没有源代码");
		result["error_code"] = -2;
		return result;
	}
	
	// 获取源代码
	String source_code = p_script->get_source_code();
	result["source_length"] = source_code.length();
	result["has_source"] = true;
	
	// 尝试重新加载脚本以检查编译错误
	Error reload_result = p_script->reload();
	
	if (reload_result != OK) {
		result["valid"] = false;
		result["error_code"] = reload_result;
		result["error"] = String::utf8("脚本编译失败");
		
		// 获取错误描述
		switch (reload_result) {
			case ERR_PARSE_ERROR:
				result["error_type"] = String::utf8("语法解析错误");
				break;
			case ERR_COMPILATION_FAILED:
				result["error_type"] = String::utf8("编译失败");
				break;
			case ERR_INVALID_DATA:
				result["error_type"] = String::utf8("无效数据");
				break;
			default:
				result["error_type"] = String::utf8("未知错误");
				break;
		}
	} else {
		result["valid"] = true;
		result["error_code"] = OK;
		result["error"] = "";
		result["error_type"] = String::utf8("无错误");
	}
	
	return result;
}

Dictionary YanClass::validate_script_syntax(const String &p_code) const {
	Dictionary result;
	
	// 检查源代码是否为空
	if (p_code.is_empty()) {
		result["valid"] = false;
		result["error"] = String::utf8("源代码为空");
		result["error_code"] = -1;
		return result;
	}
	
	result["source_length"] = p_code.length();
	result["has_source"] = true;
	
	// 创建临时GDScript对象进行语法验证
	Ref<GDScript> temp_script;
	temp_script.instantiate();
	
	if (temp_script.is_null()) {
		result["valid"] = false;
		result["error"] = String::utf8("无法创建临时脚本对象");
		result["error_code"] = -3;
		return result;
	}
	
	// 设置源代码
	temp_script->set_source_code(p_code);
	
	// 尝试编译
	Error compile_result = temp_script->reload();
	
	if (compile_result != OK) {
		result["valid"] = false;
		result["error_code"] = compile_result;
		result["error"] = String::utf8("语法验证失败");
		
		// 获取详细的错误类型
		switch (compile_result) {
			case ERR_PARSE_ERROR:
				result["error_type"] = String::utf8("语法解析错误");
				result["suggestion"] = String::utf8("请检查代码语法，确保括号匹配、分号正确等");
				break;
			case ERR_COMPILATION_FAILED:
				result["error_type"] = String::utf8("编译失败");
				result["suggestion"] = String::utf8("请检查代码逻辑和类型使用");
				break;
			case ERR_INVALID_DATA:
				result["error_type"] = String::utf8("无效数据");
				result["suggestion"] = String::utf8("请检查变量声明和数据类型");
				break;
			default:
				result["error_type"] = String::utf8("未知错误");
				result["suggestion"] = String::utf8("请检查代码完整性");
				break;
		}
	} else {
		result["valid"] = true;
		result["error_code"] = OK;
		result["error"] = "";
		result["error_type"] = String::utf8("语法正确");
		result["suggestion"] = String::utf8("代码语法验证通过");
	}
	
	return result;
}

Dictionary YanClass::get_script_compilation_status(const Ref<Script> &p_script) const {
	Dictionary result;
	
	// 基础信息
	if (p_script.is_null()) {
		result["exists"] = false;
		result["valid"] = false;
		return result;
	}
	
	result["exists"] = true;
	result["script_class"] = p_script->get_class();
	result["script_path"] = p_script->get_path();
	
	// 检查是否有源代码
	if (p_script->has_source_code()) {
		String source_code = p_script->get_source_code();
		result["has_source"] = true;
		result["source_length"] = source_code.length();
		result["source_lines"] = source_code.split("\n").size();
		
		// 尝试编译以获取状态
		Error reload_result = p_script->reload();
		result["compilation_status"] = reload_result;
		result["compilation_success"] = (reload_result == OK);
		
		if (reload_result != OK) {
			result["error_message"] = String::utf8("编译失败");
			result["error_code"] = reload_result;
		} else {
			result["error_message"] = String::utf8("编译成功");
			result["error_code"] = OK;
		}
	} else {
		result["has_source"] = false;
		result["compilation_status"] = -1;
		result["compilation_success"] = false;
		result["error_message"] = String::utf8("没有源代码");
	}
	
	return result;
}

void YanClass::enable_error_interception() const {
	YanClass::error_interception_enabled = true;
	
	// 设置错误拦截
	const_cast<YanClass*>(this)->setup_error_interception();
	
	print_line(String::utf8("错误拦截已启用 - 现在可以拦截所有 Godot 错误和警告！"));
}

void YanClass::disable_error_interception() const {
	YanClass::error_interception_enabled = false;
	
	// 恢复原始错误处理
	const_cast<YanClass*>(this)->restore_error_interception();
	
	print_line(String::utf8("错误拦截已禁用 - 已恢复原始 Godot 错误处理"));
}

Array YanClass::get_intercepted_errors() const {
	Array result;
	for (const auto& error : YanClass::error_messages) {
		result.append(String(error.c_str()));
	}
	return result;
}

Array YanClass::get_intercepted_warnings() const {
	Array result;
	for (const auto& warning : YanClass::warning_messages) {
		result.append(String(warning.c_str()));
	}
	return result;
}

void YanClass::clear_intercepted_messages() const {
	YanClass::error_messages.clear();
	YanClass::warning_messages.clear();
	print_line(String::utf8("已清空所有拦截的消息"));
}

String YanClass::get_latest_error() const {
	if (YanClass::error_messages.empty()) {
		return "";
	}
	return String(YanClass::error_messages.back().c_str());
}

int YanClass::get_error_count() const {
	return static_cast<int>(YanClass::error_messages.size());
}

int YanClass::get_warning_count() const {
	return static_cast<int>(YanClass::warning_messages.size());
}

bool YanClass::has_new_errors() const {
	return !YanClass::error_messages.empty();
}

Dictionary YanClass::get_error_summary() const {
	Dictionary result;
	
	result["error_count"] = get_error_count();
	result["warning_count"] = get_warning_count();
	result["has_errors"] = has_new_errors();
	
	// 获取最新的几个错误
	Array recent_errors;
	int count = std::min(5, static_cast<int>(YanClass::error_messages.size()));
	for (int i = YanClass::error_messages.size() - count; i < YanClass::error_messages.size(); ++i) {
		recent_errors.append(String(YanClass::error_messages[i].c_str()));
	}
	result["recent_errors"] = recent_errors;
	
	// 获取最新的几个警告
	Array recent_warnings;
	count = std::min(5, static_cast<int>(YanClass::warning_messages.size()));
	for (int i = YanClass::warning_messages.size() - count; i < YanClass::warning_messages.size(); ++i) {
		recent_warnings.append(String(YanClass::warning_messages[i].c_str()));
	}
	result["recent_warnings"] = recent_warnings;
	
	return result;
}