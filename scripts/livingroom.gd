extends Control

const TOTAL_CARDS := 12

const PORTRAIT_JONATHAN := "res://assets/portraits/jonathan.png"

@onready var card_counter: Label = %CardCounter
@onready var background_texture: TextureRect = %BackgroundTexture
@onready var dialogue_text: Label = %DialogueText

@onready var jonathan_portrait: TextureRect = %JonathanPortrait
@onready var right_portrait: TextureRect = %GigglesPortrait

@onready var choice_1: Button = %FightButton
@onready var choice_2: Button = %WinButton
@onready var action_button: Button = %ActionButton


func _ready() -> void:
	refresh_card_counter()

	dialogue_text.text = "Living room placeholder."

	jonathan_portrait.texture = load(PORTRAIT_JONATHAN)

	# No portrait yet for the character/entity on the right.
	right_portrait.texture = null

	choice_1.visible = false
	choice_2.visible = false
	action_button.visible = false

	background_texture.visible = false


func refresh_card_counter() -> void:
	card_counter.text = "%d/%d" % [
		GameState.cards_found.size(),
		TOTAL_CARDS
	]
