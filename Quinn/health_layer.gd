extends CanvasLayer

func set_player_max_health(max_health):
	$PlayerHealthBar.max_value = max_health
	$PlayerHealthBar.value = $PlayerHealthBar.max_value
	
func set_boss_max_health(max_health):
	$EnemyHealthBar.max_value = max_health
	$EnemyHealthBar.value = $EnemyHealthBar.max_value

func set_player_max_mana(max_mana):
	$PlayerManaBar.max_value = max_mana
	$PlayerManaBar.value = $PlayerMAnaBar.max_value

func update_player_health_bar(value: float):
	$PlayerHealthBar.value = value
func update_boss_health_bar(value:float):
	$EnemyHealthBar.value = value
func update_player_mana_bar(value:float):
	$PlayerManaBar.value = value
