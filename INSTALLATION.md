# LÖVE2D Installation and Setup

## Windows Installation

### Option 1: Direct download
1. Go to https://love2d.org/
2. Download "Windows 64-bit" or "Windows 32-bit" according to your system
3. Extract the ZIP file to a folder (e.g.: C:\Program Files\LOVE\)
4. Run the `run_game.bat` file included in this project

### Option 2: Package Manager (Scoop)
```powershell
# Install Scoop (if you don't have it)
iwr -useb get.scoop.sh | iex

# Install LÖVE2D
scoop install love
```

### Option 3: Package Manager (Chocolatey)
```powershell
# Install Chocolatey (if you don't have it)
# Run as administrator
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install LÖVE2D
choco install love
```

## macOS Installation

### Option 1: Direct download
1. Go to https://love2d.org/
2. Download "macOS 64-bit"
3. Mount the .dmg file and drag LÖVE to Applications
4. Run from Terminal: `open -a love .`

### Option 2: Homebrew
```bash
# Install Homebrew (if you don't have it)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install LÖVE2D
brew install love
```

## Linux Installation

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install love
```

### Fedora
```bash
sudo dnf install love
```

### Arch Linux
```bash
sudo pacman -S love
```

## Running the Game

Once LÖVE2D is installed, you can run the game in several ways:

### Method 1: Drag and drop
Drag the game folder onto the LÖVE2D executable

### Method 2: Command line
```bash
# From the game folder
love .

# Or specifying the path
love /path/to/game/tic-tac-toe/
```

### Method 3: Batch file (Windows) / Shell script (Linux/macOS)
- Windows: Run the included `run_game.bat` file
- Linux/macOS: Run the included `run_game.sh` file

## Troubleshooting

### Error: "LÖVE2D not found"
- Verify that LÖVE2D is installed correctly
- Make sure it's in the system PATH
- Try running `love --version` in terminal

### Error: "Window doesn't appear"
- Verify that `main.lua` and `conf.lua` files are in the folder
- Check for syntax errors in the code

### Slow performance
- Close other applications
- Verify that your system supports OpenGL 2.1 or higher

### Audio problems
- LÖVE2D requires OpenAL for audio
- On Linux: `sudo apt install libopenal1`

## Advanced Customization

### Change resolution
Modify in `conf.lua`:
```lua
t.window.width = 1024
t.window.height = 768
```

### Fullscreen mode
Modify in `conf.lua`:
```lua
t.window.fullscreen = true
```

### Change colors
Modify in `settings.lua` the color tables:
```lua
-- Theme colors can be customized in the theme module
-- See theme.lua for available color schemes
```

## Useful Resources

- [Official LÖVE2D Documentation](https://love2d.org/wiki/Main_Page)
- [Lua Tutorial](https://www.lua.org/pil/contents.html)
- [LÖVE2D Forums](https://love2d.org/forums/)
- [Game Examples](https://github.com/love2d-community/awesome-love2d)
