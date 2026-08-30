#
# The class is used to monitor and notify about properties external modification
#
# This is necessary to prevent unexpected parameter changes
# when they are changed from code outside of the animation controller
#

class_name ExternalModificationGuard
extends RefCounted

var _last_write := {}
var _warned := false


func record(channel: FeedbackChannel, written: Variant) -> void:
	_last_write[channel] = written


func reset() -> void:
	_last_write.clear()


func check(target: CanvasItem) -> void:
	if _warned or not OS.is_debug_build():
		return

	for channel: FeedbackChannel in _last_write:
		var written: Variant = _last_write[channel]

		if written == null or channel.equals(channel.capture_base(target), written):
			continue

		_warned = true

		push_warning(
			(
				(
					"%s is being changed outside InteractionFeedback while an effect "
					+"drives it. Route changes through InteractionFeedback (e.g. "
					+"base_position) instead of writing the property directly."
				)
				% target.name
			)
		)

		return
