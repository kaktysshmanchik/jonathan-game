extends Control

const TOTAL_CARDS := 12

const PORTRAIT_JONATHAN := "res://assets/portraits/jonathan.png"
const PORTRAIT_GIGGLES := "res://assets/portraits/giggles.png"

const PORTRAIT_JONATHAN_PILLOWFIGHT := "res://assets/portraits/jonathan_pillowfight.png"
const PORTRAIT_GIGGLES_PILLOWFIGHT := "res://assets/portraits/giggles_pillowfight.png"

const PORTRAIT_JONATHAN_LOVE := "res://assets/portraits/jonathan_love.png"
const PORTRAIT_GIGGLES_LOVE := "res://assets/portraits/giggles_love.png"

const BG_PILLOWFIGHT := "res://assets/backgrounds/pillowfight.png"
const BG_KISS := "res://assets/backgrounds/kiss.png"

enum PlayroomState {
	INTRO,
	FIGHT,
	WIN
}

var current_state: PlayroomState = PlayroomState.INTRO

@onready var card_counter: Label = %CardCounter
@onready var background_texture: TextureRect = %BackgroundTexture
@onready var speaker_label: Label = %SpeakerLabel
@onready var dialogue_text: Label = %DialogueText
@onready var jonathan_portrait: TextureRect = %JonathanPortrait
@onready var giggles_portrait: TextureRect = %GigglesPortrait

@onready var fight_button: Button = %FightButton
@onready var win_button: Button = %WinButton
@onready var action_button: Button = %ActionButton


func _ready() -> void:
	refresh_card_counter()
	setup_intro()


func refresh_card_counter() -> void:
	card_counter.text = "%d/%d" % [GameState.cards_found.size(), TOTAL_CARDS]


func setup_intro() -> void:
	current_state = PlayroomState.INTRO
	speaker_label.text = "Giggles"
	dialogue_text.text = "Jonathan is chilling in the playroom. Giggles approaches.\n\nChoose WIN or FIGHT."
	background_texture.visible = false
	set_portraits(PORTRAIT_JONATHAN, PORTRAIT_GIGGLES)
	show_intro_choices()


func setup_fight_branch() -> void:
	current_state = PlayroomState.FIGHT
	speaker_label.text = "Giggles"
	dialogue_text.text = "Giggles picked violence. Pillow fight mode activated."
	set_background(BG_PILLOWFIGHT)
	set_portraits(PORTRAIT_JONATHAN_PILLOWFIGHT, PORTRAIT_GIGGLES_PILLOWFIGHT)
	show_action_choice("BRING IT ON")


func setup_win_branch() -> void:
	current_state = PlayroomState.WIN
	speaker_label.text = "Giggles"
	dialogue_text.text = "Correct answer. Reward branch. Kiss scene placeholder."
	set_background(BG_KISS)
	set_portraits(PORTRAIT_JONATHAN_LOVE, PORTRAIT_GIGGLES_LOVE)
	show_action_choice("CONTINUE")


func show_intro_choices() -> void:
	fight_button.visible = true
	fight_button.disabled = false

	win_button.visible = true
	win_button.disabled = false

	action_button.visible = false
	action_button.disabled = true


func show_action_choice(button_text: String) -> void:
	fight_button.visible = false
	fight_button.disabled = true

	win_button.visible = false
	win_button.disabled = true

	action_button.visible = true
	action_button.disabled = false
	action_button.text = button_text


func set_background(path: String) -> void:
	var texture := load_texture(path)
	background_texture.texture = texture
	background_texture.visible = texture != null


func set_portraits(jonathan_path: String, giggles_path: String) -> void:
	jonathan_portrait.texture = load_texture(jonathan_path)
	giggles_portrait.texture = load_texture(giggles_path)


func load_texture(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		return load(path) as Texture2D
	return null


func _on_fight_button_pressed() -> void:
	setup_fight_branch()


func _on_win_button_pressed() -> void:
	setup_win_branch()


func _on_action_button_pressed() -> void:
	match current_state:
		PlayroomState.FIGHT:
			dialogue_text.text = "Placeholder: BRING IT ON pressed. Nothing happens yet."
		PlayroomState.WIN:
			dialogue_text.text = "Placeholder: CONTINUE pressed. Nothing happens yet."