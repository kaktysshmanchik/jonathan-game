extends Control

const TOTAL_CARDS := 12

const PORTRAIT_JONATHAN := "res://assets/portraits/jonathan.png"
const PORTRAIT_GIGGLES := "res://assets/portraits/giggles.png"

const PORTRAIT_JONATHAN_LOVE := "res://assets/portraits/jonathan_love.png"
const PORTRAIT_GIGGLES_LOVE := "res://assets/portraits/giggles_love.png"

const PORTRAIT_JONATHAN_PILLOWFIGHT := "res://assets/portraits/jonathan_pillowfight.png"
const PORTRAIT_GIGGLES_PILLOWFIGHT := "res://assets/portraits/giggles_pillowfight.png"

const BG_MAIN := "res://assets/backgrounds/main.png"
const BG_KISS := "res://assets/backgrounds/kiss.png"
const BG_PILLOWFIGHT := "res://assets/backgrounds/pillowfight.png"
const BG_KISS_BANG := "res://assets/backgrounds/kiss_bang.png"

@onready var dialogue_panel: PanelContainer = %DialoguePanel
@onready var card_counter_panel: PanelContainer = %CardCounterPanel
@onready var outcome_continue_button: Button = %OutcomeContinueButton

@onready var hit_effect: TextureRect = %HitEffect
@onready var hit_blink_timer: Timer = %HitBlinkTimer

const DIALOGUE := {
	"start": {
		"text": "Hiya, puppy. Oh... I thought you were gaming.",
		"mood": "normal",
		"choices": [
			{
				"text": "Hello, gorgeous. No, just finished. What've you been up to?",
				"next": "A"
			},
			{
				"text": "Did you now? Just so you know, I've been working my ass off.",
				"next": "B"
			}
		]
	},

	"A": {
		"text": "Nothing much — just trying to figure out blind Scouse.",
		"mood": "love",
		"choices": [
			{
				"text": "Yeah? Did you burn the kitchen down yet?",
				"next": "A1"
			},
			{
				"text": "Aw, you're trying to make it vegetarian. That's so sweet.",
				"next": "A2"
			}
		]
	},

	"A1": {
		"text": "What? How dare you? Just so you know, I'm not that useless.",
		"mood": "pillowfight",
		"choices": [
			{
				"text": "Of course you're not. I still can't get over your old-lady food. Come on. Let me give you a hand.",
				"next": "A1.1"
			},
			{
				"text": "Could've fooled me. You still can't tell correct pancakes from wrong ones.",
				"next": "A1.2"
			}
		]
	},

	"A1.1": {
		"text": "Oooh... A hand, yeah? Sounds good.",
		"mood": "love",
		"choices": [
			{
				"text": "Go to the kitchen.",
				"outcome": "kitchen"
			}
		]
	},

	"A1.2": {
		"text": "Oh, fuck you and your wrong pancakes. At least I can kick your ass whenever.",
		"mood": "pillowfight",
		"choices": [
			{
				"text": "Bring it on.",
				"outcome": "pillowfight"
			}
		]
	},

	"A2": {
		"text": "Thank you, baby. I've also been thinking about trying to make meat-free borsch, but that'd be weird, no?",
		"mood": "love",
		"choices": [
			{
				"text": "Why? Sounds great. Even though I'm not sure what it is. Come on, show me what you've got.",
				"next": "A2.1"
			},
			{
				"text": "Is that your weird Russian food? I swear you're trying to poison me.",
				"next": "A2.2"
			}
		]
	},

	"A2.1": {
		"text": "Yeah, I've got a thing or two to show you.",
		"mood": "love",
		"choices": [
			{
				"text": "Go to the kitchen.",
				"outcome": "kitchen"
			}
		]
	},

	"A2.2": {
		"text": "Why would I do that? I can smother you with a pillow any time.",
		"mood": "pillowfight",
		"choices": [
			{
				"text": "Bring it on.",
				"outcome": "pillowfight"
			}
		]
	},

	"B": {
		"text": "Ah, I can tell by the heat coming off the controller.",
		"mood": "pillowfight",
		"choices": [
			{
				"text": "Ah, you got me. I did just finish Pawheim.",
				"next": "B1"
			},
			{
				"text": "Nah, your cold soul just makes everything seem hotter than it is.",
				"next": "B2"
			}
		]
	},

	"B1": {
		"text": "Already? Aw, and I was hoping you were gonna show me the final boss.",
		"mood": "love",
		"choices": [
			{
				"text": "Ah, you want to be impressed by my manly manliness? Just try not to get too wet.",
				"next": "B1.1"
			},
			{
				"text": "No worries, I have a save just before the boss. Let's grab a snack, and I'll show you.",
				"next": "B1.2"
			}
		]
	},

	"B1.1": {
		"text": "Oh, you obnoxious creature... Let me teach you a lesson real quick...",
		"mood": "pillowfight",
		"choices": [
			{
				"text": "Bring it on.",
				"outcome": "pillowfight"
			}
		]
	},

	"B1.2": {
		"text": "Yup, sounds great. Although I can't say I'm particularly hungry. Not for food, anyway.",
		"mood": "love",
		"choices": [
			{
				"text": "Go to the kitchen.",
				"outcome": "kitchen"
			}
		]
	},

	"B2": {
		"text": "Mhm. Including you?",
		"mood": "pillowfight",
		"choices": [
			{
				"text": "Oh, definitely. Can't you tell? Come on, I'll show you what's really hot in this house — the oven.",
				"next": "B2.1"
			},
			{
				"text": "Oh no, that's the only thing you're right about.",
				"next": "B2.2"
			}
		]
	},

	"B2.1": {
		"text": "Not hotter than you, but fine. Show me.",
		"mood": "love",
		"choices": [
			{
				"text": "Go to the kitchen.",
				"outcome": "kitchen"
			}
		]
	},

	"B2.2": {
		"text": "You cheeky bastard... I'm gonna kick your ass.",
		"mood": "pillowfight",
		"choices": [
			{
				"text": "Bring it on.",
				"outcome": "pillowfight"
			}
		]
	}
}


var current_choices: Array = []
var current_outcome: String = ""


@onready var card_counter: Label = %CardCounter
@onready var background_texture: TextureRect = %BackgroundTexture
@onready var dialogue_text: Label = %DialogueText

@onready var jonathan_portrait: TextureRect = %JonathanPortrait
@onready var giggles_portrait: TextureRect = %GigglesPortrait

# These are now generic dialogue-choice slots.
@onready var choice_1: Button = %FightButton
@onready var choice_2: Button = %WinButton

# We don't need this anymore, but leaving it here means
# you don't have to delete the node from the scene yet.
@onready var action_button: Button = %ActionButton


func _ready() -> void:
	refresh_card_counter()

	action_button.visible = false
	outcome_continue_button.visible = false

	show_dialogue("start")


func refresh_card_counter() -> void:
	card_counter.text = "%d/%d" % [GameState.cards_found.size(), TOTAL_CARDS]


func show_dialogue(dialogue_id: String) -> void:
	dialogue_panel.visible = true
	card_counter_panel.visible = true
	outcome_continue_button.visible = false

	var dialogue: Dictionary = DIALOGUE[dialogue_id]

	dialogue_text.text = dialogue["text"]

	set_background(BG_MAIN)

	set_portrait_mood(dialogue.get("mood", "normal"))

	current_choices = dialogue["choices"]

	show_choices()


func show_choices() -> void:
	setup_choice_button(choice_1, 0)
	setup_choice_button(choice_2, 1)


func setup_choice_button(button: Button, index: int) -> void:
	if index >= current_choices.size():
		button.visible = false
		button.disabled = true
		return

	button.visible = true
	button.disabled = false
	button.text = current_choices[index]["text"]


func choose(index: int) -> void:
	if index >= current_choices.size():
		return

	var choice: Dictionary = current_choices[index]

	if choice.has("next"):
		show_dialogue(choice["next"])
		return

	if choice.has("outcome"):
		show_outcome(choice["outcome"])
		return

	# Used by the final placeholder choices.
	if choice.has("action"):
	handle_action(choice["action"])
	return

func handle_action(action: String) -> void:
	match action:
		"kiss_bang":
			show_kiss_bang()

		"go_livingroom":
			stop_hit_blink()

			get_tree().change_scene_to_file(
				"res://scenes/livingroom.tscn"
			)
			

func show_kiss_bang() -> void:
	set_background(BG_KISS_BANG)

	dialogue_panel.visible = true
	card_counter_panel.visible = true
	outcome_continue_button.visible = false

	set_portrait_mood("love")

	dialogue_text.text = "What was that?!"

	current_choices = [
		{
			"text": "I'd better check.",
			"action": "go_livingroom"
		}
	]

	show_choices()
	start_hit_blink()
	
	func start_hit_blink() -> void:
	hit_effect.visible = true
	hit_blink_timer.start()


func stop_hit_blink() -> void:
	hit_blink_timer.stop()
	hit_effect.visible = false


func _on_hit_blink_timer_timeout() -> void:
	hit_effect.visible = not hit_effect.visible
func show_outcome(outcome: String) -> void:
	match outcome:
		"kitchen":
			show_kitchen_outcome()

		"pillowfight":
			show_pillowfight_outcome()


func show_kitchen_outcome() -> void:
	current_outcome = "kitchen"

	set_background(BG_KISS)

	dialogue_panel.visible = false
	card_counter_panel.visible = false
	outcome_continue_button.visible = false

	await get_tree().create_timer(3.0).timeout

	outcome_continue_button.visible = true


func show_pillowfight_outcome() -> void:
	current_outcome = "pillowfight"

	set_background(BG_PILLOWFIGHT)

	dialogue_panel.visible = false
	card_counter_panel.visible = false
	outcome_continue_button.visible = false

	await get_tree().create_timer(3.0).timeout

	outcome_continue_button.visible = true


func set_portrait_mood(mood: String) -> void:
	match mood:
		"love":
			set_portraits(
				PORTRAIT_JONATHAN_LOVE,
				PORTRAIT_GIGGLES_LOVE
			)

		"pillowfight":
			set_portraits(
				PORTRAIT_JONATHAN_PILLOWFIGHT,
				PORTRAIT_GIGGLES_PILLOWFIGHT
			)

		_:
			set_portraits(
				PORTRAIT_JONATHAN,
				PORTRAIT_GIGGLES
			)


func set_background(path: String) -> void:
	var texture := load_texture(path)

	background_texture.texture = texture
	background_texture.visible = texture != null


func set_portraits(
	jonathan_path: String,
	giggles_path: String
) -> void:
	jonathan_portrait.texture = load_texture(jonathan_path)
	giggles_portrait.texture = load_texture(giggles_path)


func load_texture(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		return load(path) as Texture2D

	return null


# Your existing scene already connects FightButton to this.
# It's now simply "choice number one".
func _on_fight_button_pressed() -> void:
	choose(0)


# Same thing: this is just "choice number two".
func _on_win_button_pressed() -> void:
	choose(1)


# Still connected in your scene, but the button stays hidden.
func _on_action_button_pressed() -> void:
	pass


func _on_outcome_continue_button_pressed() -> void:
	outcome_continue_button.visible = false

	match current_outcome:
		"kitchen":
			show_post_kiss_question()

		"pillowfight":
			get_tree().change_scene_to_file(
				"res://scenes/pillowfight.tscn"
			)


func show_post_kiss_question() -> void:
	stop_hit_blink()

	dialogue_panel.visible = true
	card_counter_panel.visible = true
	outcome_continue_button.visible = false

	set_background(BG_KISS)
	set_portrait_mood("love")

	dialogue_text.text = "What's on your mind, puppy?"

	current_choices = [
		{
			"text": "Nothing new...",
			"action": "kiss_bang"
		}
	]

	show_choices()
	

func _on_hit_blink_timer_timeout() -> void:
	pass # Replace with function body.
