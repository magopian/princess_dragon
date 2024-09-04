extends Node

signal new_score(score: int, coin: Area2D)

var score: int = 0


func add_point(coin: Area2D):
	score += 1
	new_score.emit(score, coin)
