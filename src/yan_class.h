#pragma once

#include "godot_cpp/classes/ref_counted.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include "godot_cpp/variant/variant.hpp"

using namespace godot;

class YanClass : public RefCounted {
	GDCLASS(YanClass, RefCounted)

protected:
	static void _bind_methods();

public:
	YanClass() = default;
	~YanClass() override = default;

	void log_info(const String &p_message) const;
};
