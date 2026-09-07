class_name InteractionFeedbackTestEnv
extends RefCounted

var target: Control
var feedback: InteractionFeedback


static func build(suite, effect: FeedbackEffect) -> InteractionFeedbackTestEnv:
	var env := InteractionFeedbackTestEnv.new()

	env.target = suite.auto_free(Button.new()) as Control
	suite.add_child(env.target)

	env.feedback = InteractionFeedback.attach(env.target, false)
	env.feedback.add_effect(effect)

	return env
