# Pursuit for Knowledge: A MATLAB RPG

## Introduction

Pursuit for Knowledge is a top-down, 2D role-playing game built entirely in MATLAB. Developed as a software design capstone, it features boss battles against the course TAs and the professor, all powered by a custom object-oriented game engine that renders graphics, manages game states, and handles real-time user input without external gaming libraries. This project was awarded 4th place at the Fundamentals of Engineering Design Showcase in AU2024.

## Technical Implementation 🛠

- **Object-Oriented Design**  
  Built upon a custom `ModifiedSimpleGameEngine` class that inherits from MATLAB’s `handle` class to manage sprite properties, transparency rendering, and zoom scaling.

- **Matrix-Based Rendering**  
  Graphics are rendered by manipulating 3D arrays (`Height x Width x RGB`), effectively treating the game window as a dynamic matrix of pixel data.

- **Finite State Machine**  
  The main game loop (`RPG_Network.m`) utilizes a `switch`–`case` state machine to manage scene transitions, room navigation, and combat scenarios.

- **Collision Detection**  
  Implements custom logic to calculate sprite coordinate overlaps in real time, enabling “bullet hell” style mini-games and obstacle navigation.

## Gameplay features 🎮

- **Turn-Based & Real-Time Combat**  
  Hybrid combat system combining quiz-based logic battles with real-time dodging mechanics.

- **Interactive Puzzles**  
  Includes logic gate “Circuit Puzzles” and pathfinding challenges.

- **Audio Integration**  
  Synchronized background music and sound effects using MATLAB’s audio processing functions.


## Installation

1. Install MATLAB (R202x or later recommended).
2. Clone or download this repository.
3. Ensure all `.m` files (including `ModifiedSimpleGameEngine.m` and `RPG_Network.m`) are on your MATLAB path.
4. Place asset files (sprites, audio, etc.) in the directories referenced by the engine scripts.


## Quick start

1. Open MATLAB in the project directory.
2. Run the main script:

   ```matlab
   RPG_Network
