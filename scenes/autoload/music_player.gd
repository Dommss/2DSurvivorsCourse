extends AudioStreamPlayer

@export var streams: Array[AudioStreamMP3]


func _ready():
	on_timer_timeout()
	finished.connect(on_finished)
	$Timer.timeout.connect(on_timer_timeout)

func on_finished():
	$Timer.start()


func on_timer_timeout():
	var chosen_track = streams.pick_random()
	stream = chosen_track
	play()
