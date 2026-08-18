# Interaction Feedback

![Static Badge](https://img.shields.io/badge/engine-Godot_4.7+-478CBF)
![Static Badge](https://img.shields.io/badge/effects-stackable-81B622)

<img src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/featured.png" />

Plug-n-play UI animations for `Control` or `Node2D` nodes

<table>
	<tr>
		<td width="33%"><img alt="Scale" src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/buttons/scale.gif" /></td>
		<td width="33%"><img alt="Offset" src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/buttons/offset.gif" /></td>
		<td width="33%"><img alt="Modulation" src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/buttons/modulation.gif" /></td>
	</tr>
	<tr>
		<td><img alt="Pulse" src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/buttons/pulse.gif" /></td>
		<td><img alt="Wobble" src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/buttons/wobble.gif" /></td>
		<td><img alt="Shake on press" src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/buttons/shakeonpress.gif" /></td>
	</tr>
	<tr>
		<td><img alt="Sticky" src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/buttons/sticky.gif" /></td>
		<td><img alt="Elastic" src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/buttons/elastic.gif" /></td>
		<td><img alt="Squishy" src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/buttons/squishy.gif" /></td>
	</tr>
	<tr>
		<td><img alt="Heartbeat" src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/buttons/heartbeat.gif" /></td>
		<td><img alt="Floating" src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/buttons/floating.gif" /></td>
		<td><img alt="Offset + scale + z" src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/buttons/offsetscalez.gif" /></td>
	</tr>
</table>

Open `addons/interaction_feedback/demo/demo.tscn` to click through all of them

## Usage

1. Install the addon from source (copy `addons` folder to your project directory)
1. Enable the plugin in your Project Settings
1. Add an `InteractionFeedback` node as a child of a Button node
1. Add an effect node as children of `InteractionFeedback` (e.g: `FeedbackScaleEffect`)

<table>
	<tr>
		<td width="50%"><img alt="Scene tree with InteractionFeedback and effect nodes" src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/scene.png" /></td>
		<td width="50%"><img alt="FeedbackShakeEffect in the inspector" src="https://raw.githubusercontent.com/paufau/godot-interaction-feedback/refs/heads/main/assets/shake_node_inspector.png" /></td>
	</tr>
	<tr>
		<td align="center">Node setup</td>
		<td align="center">Fine tune per effect</td>
	</tr>
</table>

...or do same thing from code:

```gdscript
var feedback := InteractionFeedback.attach(button)
feedback.add_effect(FeedbackScaleEffect.new())
feedback.add_effect(FeedbackShakeEffect.new())
```

## Effects

| Node                     | What it does                   |
| ------------------------ | ------------------------------ |
| `FeedbackScaleEffect`    | Scales the node                |
| `FeedbackOffsetEffect`   | Shifts position                |
| `FeedbackModulateEffect` | Controls the visual modulation |
| `FeedbackZLevelEffect`   | Raises `z_index`               |
| `FeedbackPulseEffect`    | Looping scale property         |
| `FeedbackWobbleEffect`   | Looping rotation property      |
| `FeedbackShakeEffect`    | One rotation kick              |
| `FeedbackStickyEffect`   | Leans toward the pointer       |
| `FeedbackHapticEffect`   | Vibrates the device            |

> Note: On touch screens hover effects are skipped by default, since there is no pointer to hover with. Override per node with `touch_mode`

## Author

- [Pavel Pakseev](https://www.linkedin.com/in/pavel-pakseev/)

## Sponsor & Support

⭐ _Star_ ⭐ the repo if it saved you time

You can also support me here:

<a href='https://ko-fi.com/Y8Y315L7NK' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi2.png?v=6' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
