class_name BaseEnemy extends CharacterBody2D

var origin_speed: float
var stunned: bool = false
@onready var timer: Timer
@onready var stun_time: float = 3
@onready var animated_sprite_2d: AnimatedSprite2D


func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(un_stun)
	animated_sprite_2d = self.get_node("AnimatedSprite2D")
	self.add_to_group("Enemy")


func stun() -> void:
	if not timer.time_left:
		do_stun()
	timer.start(stun_time)


func do_stun() -> void:
	stunned = true
	if "SPEED" in self:
		origin_speed = self.SPEED
		self.SPEED = 0
	if animated_sprite_2d:
		animated_sprite_2d.stop()
		animated_sprite_2d.play("stunned")


func un_stun() -> void:
	stunned = false
	if "SPEED" in self:
		self.SPEED = origin_speed
	if animated_sprite_2d:
		animated_sprite_2d.play("default")
