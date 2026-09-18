extends Control


const TOTAL_CARDS := 12

const BG_KISS := preload(
	"res://assets/backgrounds/kiss_after_pillowfight.png"
)

const BG_BANG := preload(
	"res://assets/backgrounds/bang_after_pillowfight.png"
)

const PORTRAIT_JONATHAN := preload(
	"res://assets/portraits/jonathan.png"
)

const PORTRAIT_GIGGLES := preload(
	"res://assets/portraits/giggles.png"
)


@onready var background_texture: TextureRect = %BackgroundTexture

@onready var card_counter: Label = %CardCounter

@onready var dialogue_text: Label = %DialogueText

@onready var jonathan_portrait: TextureRect = %JonathanPortrait
@onready var giggles_portrait: TextureRect = %GigglesPortrait

@onready var choice_button: Button = %FightButton
@onready var choice_2: Button = %WinButton
@onready var action_button: Button = %ActionButton

@onready var hit_effect: TextureRect = %HitEffect

@onready var outcome_continue_button: Button = %OutcomeContinueButton


var stage := 0
var blinking := false


func _ready() -> void:
	refresh_card_counter()

	background_texture.texture = BG_KISS
	background_texture.visible = true

	jonathan_portrait.texture = PORTRAIT_JONATHAN
	giggles_portrait.texture = PORTRAIT_GIGGLES

	choice_2.visible = false
	action_button.visible = false
	outcome_continue_button.visible = false
	hit_effect.visible = false

	dialogue_text.text = "What's on your mind, puppy?"

	choice_button.text = "Nothing new..."
	choice_button.visible = true

	choice_button.pressed.connect(_on_choice_pressed)


func refresh_card_counter() -> void:
	card_counter.text = "%d/%d" % [
		GameState.cards_found.size(),
		TOTAL_CARDS
	]


func _on_choice_pressed() -> void:
	if stage == 0:
		show_bang()
	elif stage == 1:
		go_to_living_room()


func show_bang() -> void:
	stage = 1

	background_texture.texture = BG_BANG

	dialogue_text.text = "What was that?!"
	choice_button.text = "I'd better check."

	if not blinking:
		blinking = true
		blink_hit_effect()


func blink_hit_effect() -> void:
	for i in range(6):
		if not is_inside_tree():
			return

		hit_effect.visible = true
		await get_tree().create_timer(0.12).timeout

		hit_effect.visible = false
		await get_tree().create_timer(0.12).timeout

	blinking = false


func go_to_living_room() -> void:
	get_tree().change_scene_to_file(
		"res://scenes/livingroom.tscn"
	)
