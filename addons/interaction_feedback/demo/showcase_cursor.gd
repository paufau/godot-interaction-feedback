extends Sprite2D

const TEXTURES := {
	Input.CURSOR_ARROW: preload("res://addons/interaction_feedback/demo/cursors/pointer_b.png"),
	Input.CURSOR_POINTING_HAND: preload("res://addons/interaction_feedback/demo/cursors/hand_point.png"),
	Input.CURSOR_DRAG: preload("res://addons/interaction_feedback/demo/cursors/hand_closed.png"),
}
const HOTSPOT := Vector2(21, 12)
const SPRITE_SCALE := 0.5
const SWAY_RATIO := 0.3
const APPROACH_SEC := 0.5
const HOVER_SEC := 1.2
const PRESS_SEC := 0.3
const RELEASE_SEC := 0.9
const LEAVE_SEC := 0.4
const LOOP_SEC := 6.0

var feedback: InteractionFeedback
var start_delay_sec := 0.0
var sway := false

var _time := 0.0


func _ready() -> void:
	centered = false
	offset = - HOTSPOT
	scale = Vector2.ONE * SPRITE_SCALE
	modulate.a = 0.0
	_time = - start_delay_sec


func _process(delta: float) -> void:
	_time += delta

	var target := feedback.get_target() as Control
	var rect := target.get_global_rect()
	var home := rect.end + Vector2(24, 12)
	var hover_point := rect.get_center() + Vector2(0.0, rect.size.y * 0.15)
	var t := fmod(_time, LOOP_SEC) if _time >= 0.0 else -1.0
	var hover_end := APPROACH_SEC + HOVER_SEC + PRESS_SEC + RELEASE_SEC
	var pressed := false
	var alpha := 0.0
	position = home

	if t < 0.0:
		pass # waiting for its turn
	elif t < APPROACH_SEC:
		var u := ease(t / APPROACH_SEC, -2.0)
		position = home.lerp(hover_point, u)
		alpha = u
	elif t < hover_end:
		var held := t - APPROACH_SEC
		position = hover_point

		if sway:
			position.x += sin(TAU * held / (hover_end - APPROACH_SEC)) * rect.size.x * SWAY_RATIO

		pressed = held >= HOVER_SEC and held < HOVER_SEC + PRESS_SEC
		alpha = 1.0
	elif t < hover_end + LEAVE_SEC:
		var u := ease((t - hover_end) / LEAVE_SEC, -2.0)
		position = hover_point.lerp(home, u)
		alpha = 1.0 - u

	modulate.a = alpha
	feedback.set_virtual_pointer(position if rect.has_point(position) else Vector2.INF, pressed)
	texture = TEXTURES.get(target.mouse_default_cursor_shape, TEXTURES[Input.CURSOR_ARROW])
