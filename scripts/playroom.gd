extends Control

const TOTAL_CARDS := 12

@onready var card_counter: Label = %CardCounter
@onready var speaker_label: Label = %SpeakerLabel
@onready var dialogue_text: RichTextLabel = %DialogueText
@onready var win_button: Button = %WinButton
@onready var fight_button: Button = %FightButton


func _ready() -> void:
	refresh_card_counter()
	show_line(
		"Giggles",
		"Jonathan is chilling in the playroom. Giggles pads closer with a question.\n\nAnswer correctly and Jonathan gets the reward. Get it wrong and it turns into a fight."
	)


func refresh_card_counter() -> void:
	card_counter.text = "%d/%d" % [GameState.cards_found.size(), TOTAL_CARDS]


func show_line(speaker: String, line: String) -> void:
	speaker_label.text = speaker
	dialogue_text.text = line


func _on_win_button_pressed() -> void:
	show_line(
		"System",
		"Placeholder WIN branch selected.\n\nThis is where the success dialogue and reward flow will go."
	)
	lock_choice()


func _on_fight_button_pressed() -> void:
	show_line(
		"System",
		"Placeholder FIGHT branch selected.\n\nThis is where the combat transition will go."
	)
	lock_choice()


func lock_choice() -> void:
	win_button.disabled = true
	fight_button.disabled = true
