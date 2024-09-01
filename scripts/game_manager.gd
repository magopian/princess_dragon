extends Node

signal new_score

var score: int = 0


func add_point():
	score += 1
	new_score.emit(score)
