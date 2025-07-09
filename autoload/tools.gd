class_name Tools

static var TR_OBJ: Object = Object.new()

static func time_interval_to_string(ms_time: int) -> String:
		var ms = ms_time % 1000
		@warning_ignore_start("integer_division")
		var s = (ms_time / 1000) % 60
		var m = (ms_time / 60000) % 60
		var h = (ms_time / 3600000) % 24
		var d = ms_time / 86400000
		@warning_ignore_restore("integer_division")
		var parts = []
		# TODO International
		if d > 0:
			parts.append(str(d) + TR_OBJ.tr("d"))
		if h > 0:
			parts.append(str(h) + TR_OBJ.tr("h"))
		if m > 0:
			parts.append(str(m) + TR_OBJ.tr("m"))
		parts.append(("%.3f" % (s + ms * 0.001)) + TR_OBJ.tr("s"))
		return "".join(parts)


static func difficulty_to_str(difficulty: int) -> String:
		# TODO International
		match difficulty:
			Difficulty.EASY: return TR_OBJ.tr("Easy")
			Difficulty.NORMAL: return TR_OBJ.tr("Normal")
			_: return TR_OBJ.tr("Hard")
