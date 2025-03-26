# 🐭 Catch The Mole 🎃

## Game Description
Catch The Mole is an exciting whack-a-mole style game developed using Godot 4, where players test their reflexes by catching moles while avoiding pumpkins.

## 🎮 Game Mechanics
- **Objective**: Click on moles to earn points
- **Avoid**: Clicking on pumpkins costs you a life
- **Lives**: Start with 3 lives
- **Scoring**: 10 points per mole hit

## 🌟 Key Features

### Dynamic Difficulty System
The game implements a sophisticated difficulty progression in `game.gd`:
```gdscript
func increase_difficulty():
    difficulty_level += 1
    
    # Dynamically adjust spawn intervals
    if difficulty_level < 5:
        spawn_interval -= spawn_interval_decrease
    elif difficulty_level < 7:
        spawn_interval -= spawn_interval_decrease_after_level_five
    else:
        spawn_interval -= spawn_interval_decrease_after_level_seven
    
    # Increase pumpkin probability
    pumpkin_chance = min(pumpkin_chance + 0.05, 0.5)
```

### Interesting Code Highlights

1. **Flexible Spawn Mechanism**
In `game.gd`, the spawn system intelligently manages game objects:
```gdscript
func _on_spawn_timer_timeout():
    var free_positions = positions.filter(func(pos): return not pos.get_meta("occupied"))
    var random_position = free_positions[randi() % free_positions.size()]
    
    # Randomly spawn mole or pumpkin based on game difficulty
    if randf() < (1.0 - pumpkin_chance):
        spawn_mole(random_position)
    else:
        spawn_pumpkin(random_position)
```

2. **Score Tracking and High Score Management**
The `Global.gd` script manages global scores with a clever array manipulation technique:
```gdscript
func insert_and_sort_array(arr: Array, new_value: int) -> Array:
    if arr.size() < 10:
        arr.append(new_value)
        arr.sort()
    else:
        var min_value = arr.min()
        if new_value > min_value:
            arr.erase(min_value)
            arr.append(new_value)
            arr.sort()
    return arr
```

### Technical Details
- **Engine**: Godot 4
- **Language**: GDScript
- **Platforms**: Web, Desktop
- **Maximum Difficulty Level**: 15

## 🕹️ Game Controls
- **Left Mouse Click**: Hit moles
- **Escape/Pause**: Pause game
- **R**: Restart game

## 📱 Play Online
[Play Catch The Mole Online](https://www.gamepix.com/play/catch-the-mole)

## 🛠️ Installation
1. Clone the repository
2. Open with Godot 4
3. Run the project

## 🤔 Game Logic Nuances
- Moles appear for progressively shorter durations as difficulty increases
- Pumpkin spawn probability increases with game progression
- Each level introduces subtle changes in game mechanics

## 🏆 Scoring System
- Points awarded for each mole hit
- Levels increase based on score thresholds
- Maintains a top 10 high score list

## 📦 Dependencies
- Godot 4.x
- Custom GPX plugin (for score tracking)

## 🤝 Contributions
Contributions, issues, and feature requests are welcome!

**Enjoy catching those moles!** 🐭👾
