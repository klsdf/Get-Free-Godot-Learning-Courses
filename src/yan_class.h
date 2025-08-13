#pragma once

#include "godot_cpp/classes/ref_counted.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include "godot_cpp/variant/variant.hpp"
#include "godot_cpp/variant/dictionary.hpp"
#include "godot_cpp/classes/script.hpp"
#include "godot_cpp/variant/array.hpp"
#include "godot_cpp/variant/packed_string_array.hpp"
#include <vector>
#include <string>

using namespace godot;

class YanClass : public RefCounted {
	GDCLASS(YanClass, RefCounted)

protected:
	static void _bind_methods();

private:
	// 静态成员用于存储错误信息
	static std::vector<std::string> error_messages;
	static std::vector<std::string> warning_messages;
	static bool error_interception_enabled;
	
	// 保存原始的 Godot 错误处理函数指针
	static void (*original_print_error)(const char*, const char*, const char*, int32_t, GDExtensionBool);
	static void (*original_print_warning)(const char*, const char*, const char*, int32_t, GDExtensionBool);
	static void (*original_print_script_error)(const char*, const char*, const char*, int32_t, GDExtensionBool);
	
	// 自定义错误处理函数
	static void custom_print_error(const char* p_description, const char* p_function, const char* p_file, int32_t p_line, GDExtensionBool p_editor_notify);
	static void custom_print_warning(const char* p_description, const char* p_function, const char* p_file, int32_t p_line, GDExtensionBool p_editor_notify);
	static void custom_print_script_error(const char* p_description, const char* p_function, const char* p_file, int32_t p_line, GDExtensionBool p_editor_notify);
	
	// 设置和恢复错误拦截
	void setup_error_interception();
	void restore_error_interception();

public:
	YanClass();
	~YanClass() override;

	/**
	 * 记录信息到控制台
	 * @param p_message 要记录的消息
	 */
	void log_info(const String &p_message) const;
	
	/**
	 * 获取脚本编译错误的详细信息
	 * @param p_script 要检查的脚本对象
	 * @return 包含错误信息的字典
	 */
	Dictionary get_script_errors(const Ref<Script> &p_script) const;
	
	/**
	 * 验证脚本语法并返回详细错误信息
	 * @param p_code 要验证的源代码
	 * @return 包含验证结果的字典
	 */
	Dictionary validate_script_syntax(const String &p_code) const;
	
	/**
	 * 获取脚本编译状态的详细信息
	 * @param p_script 要检查的脚本对象
	 * @return 包含编译状态的字典
	 */
	Dictionary get_script_compilation_status(const Ref<Script> &p_script) const;
	
	/**
	 * 启用错误拦截
	 */
	void enable_error_interception() const;
	
	/**
	 * 禁用错误拦截
	 */
	void disable_error_interception() const;
	
	/**
	 * 获取所有拦截的错误信息
	 * @return 错误信息数组
	 */
	Array get_intercepted_errors() const;
	
	/**
	 * 获取所有拦截的警告信息
	 * @return 警告信息数组
	 */
	Array get_intercepted_warnings() const;
	
	/**
	 * 清空所有拦截的错误和警告信息
	 */
	void clear_intercepted_messages() const;
	
	/**
	 * 获取最新的错误信息
	 * @return 最新错误信息
	 */
	String get_latest_error() const;
	
	/**
	 * 获取错误数量
	 * @return 错误数量
	 */
	int get_error_count() const;
	
	/**
	 * 获取警告数量
	 * @return 警告数量
	 */
	int get_warning_count() const;
	
	/**
	 * 检查是否有新的错误
	 * @return 是否有新错误
	 */
	bool has_new_errors() const;
	
	/**
	 * 获取所有错误和警告的汇总信息
	 * @return 汇总信息字典
	 */
	Dictionary get_error_summary() const;
};
