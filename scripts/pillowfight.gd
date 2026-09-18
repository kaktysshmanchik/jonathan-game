extends Control


signal attack_resolved


const MAX_HP := 5

const GIGGLES_IDLE_TIME := 2.0
const THROW_START_DELAY := 0.25

const PILLOW_FLIGHT_TIME := 1.15
const PILLOW_RETURN_TIME := 0.95

# Player must wait until the pillow is at least this far through
# its flight before SPACE successfully blocks it.
const BLOCK_WINDOW_START := 0.80

# Successful block does not guarantee damage.
const RETURN_HIT_CHANCE := 0.40

const ARC_HEIGHT := 170.0
const HIT_REACTION_TIME := 0.85

const PUPPY_WON_TEXTURE := preload(
	"res://assets/backgrounds/puppy_won.png"
)

const GIGGLES_WON_TEXTURE := preload(
	"res://assets/backgrounds/giggles_won.png"
)


@export var puppy_empty_heart: Texture2D
@export var giggles_empty_heart: Texture2D


@onready var background: TextureRect = $Background

@onready var fighters: Control = %Fighters
@onready var countdown_overlay: ColorRect = %CountdownOverlay
@onready var countdown_label: Label = %CountdownLabel

@onready var puppy: AnimatedSprite2D = %Puppy
@onready var giggles: AnimatedSprite2D = %Giggles
@onready var pillow: Sprite2D = %Pillow

@onready var continue_button: Button = %ContinueButton


@onready var puppy_hearts: Array[TextureRect] = [
	$Fighters/HUD/PuppyHP/Heart1,
	$Fighters/HUD/PuppyHP/Heart2,
	$Fighters/HUD/PuppyHP/Heart3,
	$Fighters/HUD/PuppyHP/Heart4,
	$Fighters/HUD/PuppyHP/Heart5
]

@onready var giggles_hearts: Array[TextureRect] = [
	$Fighters/HUD/GigglesHP/Heart1,
	$Fighters/HUD/GigglesHP/Heart2,
	$Fighters/HUD/GigglesHP/Heart3,
	$Fighters/HUD/GigglesHP/Heart4,
	$Fighters/HUD/GigglesHP/Heart5
]


var puppy_full_heart: Texture2D
var giggles_full_heart: Texture2D

var puppy_hp := MAX_HP
var giggles_hp := MAX_HP

var fight_active := false

var pillow_incoming := false
var incoming_progress := 0.0
var block_attempted := false

var pillow_tween: Tween


func _ready() -> void:
	puppy_full_heart = puppy_hearts[0].texture
	giggles_full_heart = giggles_hearts[0].texture

	fighters.visible = false
	countdown_overlay.visible = true
	continue_button.visible = false
	pillow.visible = false

	puppy.play("ready")
	giggles.play("ready")

	refresh_health()

	await run_countdown()

	countdown_overlay.visible = false
	fighters.visible = true

	fight_active = true

	await fight_loop()


func run_countdown() -> void:
	for number in range(5, 0, -1):
		countdown_label.text = "%d\n\nPress SPACE to block" % number
		await get_tree().create_timer(1.0).timeout


func fight_loop() -> void:
	while fight_active:
		puppy.play("ready")
		giggles.play("ready")

		await get_tree().create_timer(GIGGLES_IDLE_TIME).timeout

		if not fight_active:
			return

		await giggles_attack()

		if not fight_active:
			return

		await attack_resolved


func giggles_attack() -> void:
	block_attempted = false
	incoming_progress = 0.0

	giggles.play("throw")

	await get_tree().create_timer(THROW_START_DELAY).timeout

	if not fight_active:
		return

	launch_pillow_at_puppy()


func launch_pillow_at_puppy() -> void:
	pillow_incoming = true

	var start := giggles.position + Vector2(-100.0, -80.0)
	var target := puppy.position + Vector2(80.0, -70.0)

	pillow.position = start
	pillow.rotation = 0.0
	pillow.visible = true

	pillow_tween = create_tween()

	pillow_tween.tween_method(
		Callable(self, "_move_incoming_pillow").bind(start, target),
		0.0,
		1.0,
		PILLOW_FLIGHT_TIME
	)

	pillow_tween.tween_callback(_pillow_hit_puppy)


func _move_incoming_pillow(
	progress: float,
	start: Vector2,
	target: Vector2
) -> void:
	incoming_progress = progress
	move_pillow(progress, start, target)


func move_pillow(
	progress: float,
	start: Vector2,
	target: Vector2
) -> void:
	var position_on_line := start.lerp(target, progress)

	position_on_line.y -= sin(progress * PI) * ARC_HEIGHT

	pillow.position = position_on_line

	# Two full rotations during one flight.
	pillow.rotation = progress * TAU * 2.0


func _unhandled_input(event: InputEvent) -> void:
	if not fight_active:
		return

	if (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.keycode == KEY_SPACE
	):
		space_pressed()


func space_pressed() -> void:
	# Puppy reacts every time SPACE is pressed during the fight.
	puppy.play("throw")

	if not pillow_incoming:
		return

	# Only the first attempt during this throw counts.
	if block_attempted:
		return

	block_attempted = true

	# Too early.
	if incoming_progress < BLOCK_WINDOW_START:
		return

	# Successful block.
	pillow_incoming = false

	if pillow_tween != null:
		pillow_tween.kill()

	launch_return_pillow()


func launch_return_pillow() -> void:
	var puppy_hits := randf() < RETURN_HIT_CHANCE

	var start := pillow.position
	var target: Vector2

	if puppy_hits:
		target = giggles.position + Vector2(-70.0, -70.0)
	else:
		# Flies past Giggles.
		target = giggles.position + Vector2(260.0, -180.0)

	pillow_tween = create_tween()

	pillow_tween.tween_method(
		Callable(self, "_move_return_pillow").bind(start, target),
		0.0,
		1.0,
		PILLOW_RETURN_TIME
	)

	if puppy_hits:
		pillow_tween.tween_callback(_pillow_hit_giggles)
	else:
		pillow_tween.tween_callback(_return_pillow_missed)


func _move_return_pillow(
	progress: float,
	start: Vector2,
	target: Vector2
) -> void:
	move_pillow(progress, start, target)


func _pillow_hit_puppy() -> void:
	if not fight_active:
		return

	pillow_incoming = false
	pillow.visible = false

	puppy_hp -= 1
	puppy_hp = max(puppy_hp, 0)

	refresh_health()

	puppy.play("hit")

	# Giggles' "smug" is her smug/victory reaction.
	giggles.play("smug")

	if puppy_hp <= 0:
		await get_tree().create_timer(HIT_REACTION_TIME).timeout
		await end_fight(false)
		return

	await finish_round()


func _pillow_hit_giggles() -> void:
	if not fight_active:
		return

	pillow.visible = false

	giggles_hp -= 1
	giggles_hp = max(giggles_hp, 0)

	refresh_health()

	giggles.play("hit")
	puppy.play("smug")

	if giggles_hp <= 0:
		await get_tree().create_timer(HIT_REACTION_TIME).timeout
		await end_fight(true)
		return

	await finish_round()


func _return_pillow_missed() -> void:
	pillow.visible = false

	await get_tree().create_timer(0.4).timeout

	if not fight_active:
		return

	puppy.play("ready")
	giggles.play("ready")

	attack_resolved.emit()


func finish_round() -> void:
	await get_tree().create_timer(HIT_REACTION_TIME).timeout

	if not fight_active:
		return

	puppy.play("ready")
	giggles.play("ready")

	attack_resolved.emit()


func refresh_health() -> void:
	for index in range(MAX_HP):
		if index < puppy_hp:
			puppy_hearts[index].texture = puppy_full_heart
		else:
			puppy_hearts[index].texture = puppy_empty_heart

		if index < giggles_hp:
			giggles_hearts[index].texture = giggles_full_heart
		else:
			giggles_hearts[index].texture = giggles_empty_heart


func end_fight(puppy_won: bool) -> void:
	fight_active = false
	pillow_incoming = false

	if pillow_tween != null:
		pillow_tween.kill()

	pillow.visible = false
	fighters.visible = false
	countdown_overlay.visible = false
	continue_button.visible = false

	if puppy_won:
		background.texture = PUPPY_WON_TEXTURE
	else:
		background.texture = GIGGLES_WON_TEXTURE

	await get_tree().create_timer(3.0).timeout

	continue_button.visible = true
