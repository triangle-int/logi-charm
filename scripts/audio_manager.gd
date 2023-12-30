extends Node2D

func button_press():
	$ButtonPressPlayer.play()

func lamp_activated():
	$LampPlayer.play()

func component_signal_emitted():
	$ComponentSignalPlayer.play()

func lose():
	$LosePlayer.play()
