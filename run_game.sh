#!/bin/bash
echo "Starting Tic-Tac-Toe Game..."
echo ""
echo "Make sure LOVE2D is installed on your system."
echo "If you get an error, install LOVE2D:"
echo "  Ubuntu/Debian: sudo apt install love"
echo "  Fedora: sudo dnf install love"
echo "  Arch: sudo pacman -S love"
echo "  macOS: brew install love"
echo ""
read -p "Press Enter to continue..."
love .
read -p "Press Enter to exit..."
