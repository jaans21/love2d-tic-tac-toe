# Tic-Tac-Toe in Lua with LÖVE2D

A modern Tic-Tac-Toe game with graphical interface developed in Lua using the LÖVE2D framework.

## Features

- **Modern graphical interface** with colors and visual effects
- **Smooth screen transitions** with fade, slide, and zoom effects
- **Integrated sound system** with sound effects for all interactions
- **Optional background music** with independent audio controls
- **Fullscreen support** and window resizing
- **Visual animations**:
  - Smooth piece scaling when placed
  - Animated highlight for winning line
  - Victory particles and confetti
  - Fluid transitions between states
- **Multiple game modes**:
  - Human vs Human
  - Human vs AI (Artificial Intelligence)
- **Customizable boards**:
  - 3x3 (classic)
  - 4x4 (intermediate)
  - 5x5 (advanced)
  - Custom size (3x3 up to 15x15)
- **Smart AI** using the Minimax algorithm
- **Interactive menu** with mouse navigation
- **Intuitive controls**
- **Sound effects** for clicks, moves, victories, and ties

## Requirements

- **LÖVE2D** (Love2D) version 11.4 or higher
- Operating system: Windows, macOS, or Linux

## Installation

1. **Download LÖVE2D**:
   - Visit: https://love2d.org/
   - Download the appropriate version for your operating system
   - Install LÖVE2D following the instructions

2. **Run the game**:
   - **Method 1**: Drag the game folder onto the LÖVE2D executable
   - **Method 2**: From command line:
     ```bash
     love .
     ```
   - **Method 3**: On Windows, you can create a .bat file:
     ```batch
     @echo off
     "C:\Program Files\LOVE\love.exe" .
     pause
     ```

## How to Play

### Main Menu
1. **Select game mode**:
   - "Play vs Human": Two human players take turns
   - "Play vs AI": Play against the computer

2. **Choose board size**:
   - 3x3: The classic Tic-Tac-Toe
   - 4x4: Intermediate version (need 4 in a row)
   - 5x5: Advanced version (need 5 in a row)
   - Custom: Custom size (3x3 up to 15x15)

3. **Additional settings**:
   - Button "[SND] Sound: ON/OFF": Enable or disable sound effects
   - Button "[MUS] Music: ON/OFF": Enable or disable background music
   - Button "[FS] Fullscreen": Switch between windowed and fullscreen mode

### During the Game
- **Make a move**: Click on any empty cell
- **Objective**: Get a complete line (horizontal, vertical, or diagonal)
- **Turns**: Players alternate (X always goes first)
- **Return to menu**: Click "Menu" or press ESC

### Controls
- **Mouse**: Navigate menus and make moves
- **ESC**: Return to main menu
- **F11**: Toggle fullscreen/windowed
- **S**: Toggle sound ON/OFF
- **M**: Toggle music ON/OFF
- **T**: Change theme (light/dark)
- **Space**: Start game (from menu)
- **R**: Restart game (game over screen)
- **Left click**: Select options and make moves
- **Resize window**: Drag window borders to change size

### Visual Transitions
- **Fade transition**: Smooth fade when starting the game
- **Zoom transition**: Zoom effect when finishing a game
- **Slide transition**: Lateral slide when returning to menu
- **Optimized duration**: 0.4-second transitions with smooth easing
- **No interruptions**: Controls are locked during transitions

### Sound Effects
- **Button click**: Sound when clicking any menu button
- **Button hover**: Subtle sound when hovering over buttons
- **Game move**: Sound when placing X or O on the board
- **Victory**: Special celebration sound when winning
- **Tie**: Neutral sound when there's a tie
- **Sound control**: You can enable/disable all sounds from the menu

### Background Music
- **Ambient music**: Relaxing melody that plays in loop
- **Independent control**: Music can be enabled/disabled separately from sound effects
- **Optimized volume**: Balanced audio level that doesn't interfere with gameplay
- **Programmatic generation**: No external audio files required

### Fullscreen and Resizing
- **Fullscreen**: Press F11 or use the menu button to toggle
- **Resizing**: Window can be resized by dragging the borders
- **Auto scaling**: Interface automatically adapts to window size
- **Proportions**: Game board maintains correct proportions

## Game Rules

1. **Objective**: Be the first to get a complete line of your symbol
2. **Winning line**: Can be horizontal, vertical, or diagonal
3. **Turns**: Players alternate, X always starts
4. **Tie**: If board fills without a winner, it's a tie
5. **Board sizes**:
   - 3x3: Need 3 in a row
   - 4x4: Need 4 in a row
   - 5x5: Need 5 in a row

## Artificial Intelligence

The AI implements the **Minimax** algorithm with the following features:
- Evaluates all possible moves
- Chooses the best available move
- Adaptive difficulty based on board size
- Depth limitation to maintain performance

## Code Structure

- `main.lua`: Main game logic
- `conf.lua`: LÖVE2D configuration
- `settings.lua`: Game settings and constants
- Various modules: `game_state.lua`, `graphics.lua`, `input.lua`, etc.

## Customization

You can easily modify:
- **Colors**: Change values in the theme system
- **Sizes**: Modify window and UI dimensions in settings
- **AI Difficulty**: Adjust minimax depth
- **Boards**: Add more sizes by modifying the menu

## Credits

Developed in Lua using the LÖVE2D framework.
- Graphics engine: LÖVE2D (https://love2d.org/)
- Language: Lua
- AI Algorithm: Minimax

## License

This project is open source. You can use, modify, and distribute freely.

---

Enjoy playing Tic-Tac-Toe!
