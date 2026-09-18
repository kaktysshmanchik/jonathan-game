extends Control


@onready var fighters: Control = %Fighters
@onready var countdown_overlay: ColorRect = %CountdownOverlay
@onready var countdown_label: Label = %CountdownLabel

@onready var puppy: AnimatedSprite2D = %Puppy
@onready var giggles: AnimatedSprite2D = %Giggles


func _ready() -> void:
	fighters.visible = false
	countdown_overlay.visible = true

	puppy.play("ready")
	giggles.play("ready")

	await run_countdown()

	countdown_overlay.visible = false
	fighters.visible = true


func run_countdown() -> void:
	for number in range(5, 0, -1):
		countdown_label.text = "%d\n\nPress SPACE to block" % number
		await get_tree().create_timer(1.0).timeout
