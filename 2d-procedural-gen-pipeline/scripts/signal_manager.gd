extends Node

#a signal bus where we:
#centralise all visual editor signal connections 

var signal_detail : int = 0

signal gen_phase_selected(new_phase: String)     
signal dist_type_selected(new_phase: String)     
signal rand_dist_requested(num_points: int, seed_num: int)

# ----------------------------
# 📣 Emit wrapper with optional debug logging
# ----------------------------
func emit_logged(signal_name: String, arg: Variant = null) -> void:
	if signal_detail >= 1:
		var arg_str := ""
		match typeof(arg):
			TYPE_NIL:
				arg_str = ""
			TYPE_ARRAY:
				arg_str = ", ".join(arg.map(str))
			TYPE_DICTIONARY:
				var pairs := []
				for key in arg.keys():
					pairs.append("%s=%s" % [key, str(arg[key])])
				arg_str = ", ".join(pairs)
			_:
				arg_str = str(arg)

		print("[Signal] %s(%s)" % [signal_name, arg_str])

		if signal_detail >= 2:
			print("--- Signal emit call stack ---")
			print_stack()
			print("------------------------------")

	# Emit signal
	match typeof(arg):
		TYPE_NIL:
			emit_signal(signal_name)
		TYPE_ARRAY:
			var arr: Array = arg
			match arr.size():
				0: emit_signal(signal_name)
				1: emit_signal(signal_name, arr[0])
				2: emit_signal(signal_name, arr[0], arr[1])
				3: emit_signal(signal_name, arr[0], arr[1], arr[2])
				4: emit_signal(signal_name, arr[0], arr[1], arr[2], arr[3])
				_: push_error("SignalBus.emit_logged: Too many arguments in array (%d)" % arr.size())
		TYPE_DICTIONARY:
			var values: Array = arg.values()
			match values.size():
				0: emit_signal(signal_name)
				1: emit_signal(signal_name, values[0])
				2: emit_signal(signal_name, values[0], values[1])
				3: emit_signal(signal_name, values[0], values[1], values[2])
				4: emit_signal(signal_name, values[0], values[1], values[2], values[3])
				_: push_error("SignalBus.emit_logged: Too many arguments in dictionary (%d)" % values.size())
		_:
			emit_signal(signal_name, arg)
