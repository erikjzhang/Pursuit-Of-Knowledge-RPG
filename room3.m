function[a,b,c]=room3(b,c)
c=4;
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
if c<2
    DOORYellow = 930;
else
    DOORYellow = DOOR;
end
if c<3
    DOORBlue = 931;
else
    DOORBlue = DOOR;
end
if c<4
    DOORRed = 932;
else
    DOORRed = DOOR;
end
Blank = 1;

maze=[
    TLcorner DOOR Twall Twall DOORYellow Twall  Twall DOORBlue Twall Twall DOORRed TRcorner;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS GRASS Rwall;
    BLcorner Bwall Bwall Bwall DOOR Bwall Bwall Bwall Bwall Bwall Bwall BRcorner;]; 

drawScene(gameEngine,maze)

%starting position
if strcmpi(b,'t')
    playerPosition = [11,5];
elseif strcmpi(b,'Dillon') 
    playerPosition = [2,2];
elseif strcmpi(b,'Daoming')
    playerPosition = [2,5];
elseif strcmpi(b,'Shayla_Olivia')
    playerPosition = [2,8];
end 


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
            isPlaying = false;
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
       gameMap(newPosition(1), newPosition(2)) ~= BRcorner && ... 
       gameMap(newPosition(1), newPosition(2)) ~= 932 && ... 
       gameMap(newPosition(1), newPosition(2)) ~= 931 && ... 
       gameMap(newPosition(1), newPosition(2)) ~= 930 
        % Update player position
        gameMap(playerPosition(1), playerPosition(2)) = GRASS;
        playerPosition = newPosition;
    end
    if playerPosition == [1,2]
        a= "WindPuzzle";
        b = "u";
    elseif playerPosition == [12,5]
        a ="room2";
        b = "t";
    elseif playerPosition == [1,5]
        a = "CircuitPuzzle";
        b = "u";
    elseif playerPosition == [1,8]
        a = "PipePuzzle";
        b = "u";
    elseif playerPosition == [1,11]
        a = "Long_Hallway";
        b = "u";
    end
end 
close
