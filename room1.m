function[a,b,c]=room1(b,c)
c=c;

%Sprite values
spriteSize = 16;  
zoomFactor = 5;   
backgroundColor = [10 10 10]; 

% Initialize game engine with sprite sheet
spriteSheetFile = 'ModifiedRetro_pack.png';  
gameEngine = ModifiedSimpleGameEngine(spriteSheetFile, spriteSize, spriteSize, zoomFactor, backgroundColor);

%Map values
PLAYER = 32*4+27;  
GRASS = 8;  
GRASS2 = 7;
TLcorner = 433;
Twall = 434;
TRcorner = 435;
Lwall = 465;
Rwall = 467;
BLcorner = 497;
Bwall = 498;
BRcorner = 499;
DOOR = 929; 
FIRE = 335;
TREE = 35;
Blank = 1;


maze=[
    TLcorner Twall Twall Twall DOOR Twall Twall Twall TRcorner;
    Lwall GRASS2 GRASS GRASS2 GRASS GRASS GRASS GRASS2 Rwall;
    Lwall GRASS GRASS2 GRASS GRASS GRASS2 GRASS2 GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS TREE GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS2 GRASS GRASS GRASS2 Rwall;
    Lwall GRASS FIRE GRASS GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS2 GRASS GRASS GRASS GRASS2 GRASS Rwall;
    BLcorner Bwall Bwall Bwall Bwall Bwall Bwall Bwall BRcorner;];

drawScene(gameEngine,maze)

%starting position
playerPosition = [5,5];
b="0";
while (b=="0")

    pause(.05)
    gameMap=maze;
    % Draw the current room
    gameMap(playerPosition(1), playerPosition(2)) = PLAYER;
    drawScene(gameEngine, gameMap);

  
    % Get player input for movement
    key = getKeyboardInput(gameEngine);
    pause(.005)

     % Calculate new position based on input
    newPosition = playerPosition;
    switch key
        case 'w'  % Move up
            newPosition = playerPosition + [-1, 0];
        case 's'  % Move down
            newPosition = playerPosition + [1, 0];
        case 'a'  % Move left
            newPosition = playerPosition + [0, -1];
        case 'd'  % Move right
            newPosition = playerPosition + [0, 1];
        case 'q'  % Quit game
            a='1';
            b='1';
            continue;
    end
    % Ensure new position is within boundaries and not a wall
    if gameMap(newPosition(1), newPosition(2)) ~= TLcorner && ...
       gameMap(newPosition(1), newPosition(2)) ~= Twall && ...
       gameMap(newPosition(1), newPosition(2)) ~= TRcorner && ...
       gameMap(newPosition(1), newPosition(2)) ~= Lwall && ...
       gameMap(newPosition(1), newPosition(2)) ~= Rwall && ...
       gameMap(newPosition(1), newPosition(2)) ~= BLcorner && ...
       gameMap(newPosition(1), newPosition(2)) ~= Bwall && ...
       gameMap(newPosition(1), newPosition(2)) ~= BRcorner 
        % Update player position
        gameMap(playerPosition(1), playerPosition(2)) = GRASS;
        playerPosition = newPosition;
    end
    if playerPosition == [1,5]
        b = "u";
        a = "room2" ;
        
    end
end 
close