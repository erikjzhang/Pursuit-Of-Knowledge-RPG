function [a,c] = PipePuzzle(c)
c=c;

[y, Hz] = audioread("windPuzzleSong.mp3");
clear sound
sound(y, Hz);

% Sprite values
spriteSize = 16;  
zoomFactor = 5;   
backgroundColor = [10 10 10]; 

verify=0;

% Adjusted sprite indices
PLAYER = 32*4+27;    
Twall = 434;     
Bwall = 498;     
DOOR = 32*28+1;      
W = 70;         
PIPE_H = 12*32+10;    
PIPE_V = 12*32+13;    
PIPE_FIXED_H = 12*32+12; 
PIPE_FIXED_V = 32*12+15; 
EMPTY = 1;       
LAKE = 4*32+13;
BUCKET = 25*32+16; 

% Initialize game engine with sprite sheet
spriteSheetFile = 'ModifiedRetro_pack.png';  
gameEngine = ModifiedSimpleGameEngine(spriteSheetFile, spriteSize, spriteSize, zoomFactor, backgroundColor);

% Map definition
maze = [
    Twall Twall Twall Twall DOOR Twall Twall Twall;
    BUCKET EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY;
    PIPE_FIXED_V EMPTY EMPTY EMPTY PIPE_V EMPTY EMPTY W;
    PIPE_FIXED_V EMPTY EMPTY W EMPTY EMPTY EMPTY W;
    EMPTY EMPTY EMPTY PIPE_V EMPTY EMPTY EMPTY EMPTY;
    PIPE_FIXED_V EMPTY EMPTY EMPTY PIPE_H EMPTY EMPTY EMPTY;
    PIPE_FIXED_V EMPTY  EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY;
    EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY;
    PIPE_FIXED_H PIPE_FIXED_H PIPE_FIXED_H PIPE_FIXED_H  EMPTY PIPE_FIXED_H PIPE_FIXED_V EMPTY;
    EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY PIPE_FIXED_V EMPTY;
    EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY PIPE_FIXED_V EMPTY;
    W EMPTY EMPTY EMPTY EMPTY EMPTY PIPE_FIXED_V EMPTY;
    W W EMPTY EMPTY EMPTY EMPTY LAKE W;
    Bwall Bwall Bwall Bwall DOOR Bwall Bwall Bwall];

% Player starting position
playerPosition = [11, 5];
maze(playerPosition(1), playerPosition(2)) = PLAYER;

% Draw initial scene
drawScene(gameEngine, maze);

% Gameplay loop
k = 0;
while ((playerPosition(1) ~= 1) && (k ~= 'q'))
    % Get player input
    k = getKeyboardInput(gameEngine);
    pause(0.05);

    % Determine movement
    [maze, playerPosition] = handleMovement(k, maze, playerPosition, ...
        W, Bwall, Twall, PIPE_H, PIPE_V, DOOR, PIPE_FIXED_H, PIPE_FIXED_V, PLAYER, EMPTY, BUCKET, LAKE);

    % Check pipe placement conditions
    [maze, verify] = checkPipePlacement(maze, PIPE_H, PIPE_V, PIPE_FIXED_H, PIPE_FIXED_V,verify);

    % Check if puzzle is solved
    if verify == 3
        maze = [
    Twall Twall Twall Twall EMPTY Twall Twall Twall;
    BUCKET EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY;
    PIPE_FIXED_V EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY W;
    PIPE_FIXED_V EMPTY EMPTY W EMPTY EMPTY EMPTY W;
    PIPE_FIXED_V EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY;
    PIPE_FIXED_V EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY;
    PIPE_FIXED_V EMPTY  EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY;
    PIPE_FIXED_V EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY;
    PIPE_FIXED_H PIPE_FIXED_H PIPE_FIXED_H PIPE_FIXED_H PIPE_FIXED_H PIPE_FIXED_H PIPE_FIXED_V EMPTY;
    EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY PIPE_FIXED_V EMPTY;
    EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY PIPE_FIXED_V EMPTY;
    W EMPTY EMPTY EMPTY EMPTY EMPTY PIPE_FIXED_V EMPTY;
    W W EMPTY EMPTY EMPTY EMPTY LAKE W;
    Bwall Bwall Bwall Bwall DOOR Bwall Bwall Bwall];
    end

    % Update and redraw scene
    maze(playerPosition(1), playerPosition(2)) = PLAYER;
    drawScene(gameEngine, maze);
    maze(playerPosition(1), playerPosition(2)) = EMPTY;
end

close;
a='ShaylaOliviaFightWindow';
end

% Handle player movement and pushing pipes
function [maze, playerPosition] = handleMovement(k, maze, playerPosition, ...
    W, Bwall, Twall, PIPE_H, PIPE_V, DOOR, PIPE_FIXED_H, PIPE_FIXED_V, PLAYER, EMPTY, BUCKET, LAKE)
    movement = [0, 0];
    switch k
        case 'w', movement = [-1, 0];
        case 's', movement = [1, 0];
        case 'a', movement = [0, -1];
        case 'd', movement = [0, 1];
        case 'r', maze = [
    Twall Twall Twall Twall DOOR Twall Twall Twall;
    BUCKET EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY;
    PIPE_FIXED_V EMPTY EMPTY EMPTY PIPE_V EMPTY EMPTY W;
    PIPE_FIXED_V EMPTY EMPTY W EMPTY EMPTY EMPTY W;
    EMPTY EMPTY EMPTY PIPE_V EMPTY EMPTY EMPTY EMPTY;
    PIPE_FIXED_V EMPTY EMPTY EMPTY PIPE_H EMPTY EMPTY EMPTY;
    PIPE_FIXED_V EMPTY  EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY;
    EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY;
    PIPE_FIXED_H PIPE_FIXED_H PIPE_FIXED_H PIPE_FIXED_H  EMPTY PIPE_FIXED_H PIPE_FIXED_V EMPTY;
    EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY PIPE_FIXED_V EMPTY;
    EMPTY EMPTY EMPTY EMPTY EMPTY EMPTY PIPE_FIXED_V EMPTY;
    W EMPTY EMPTY EMPTY EMPTY EMPTY PIPE_FIXED_V EMPTY;
    W W EMPTY EMPTY EMPTY EMPTY LAKE W;
    Bwall Bwall Bwall Bwall DOOR Bwall Bwall Bwall];
            
            verify = 0;
        case 'q', isPlaying = 0;
    end

    newPosition = playerPosition + movement;
    if newPosition(1) <= 0 || newPosition(2) <= 0 || ...
       newPosition(1) > size(maze, 1) || newPosition(2) > size(maze, 2) || ...
       any(maze(newPosition(1), newPosition(2)) == [W, Bwall, Twall, PIPE_FIXED_H, PIPE_FIXED_V, DOOR, BUCKET, LAKE])
        return;
    end

    % Check if the player is pushing a pipe
    if maze(newPosition(1), newPosition(2)) == PIPE_H || maze(newPosition(1), newPosition(2)) == PIPE_V
        pushPosition = newPosition + movement;
        if pushPosition(1) > 0 && pushPosition(2) > 0 && ...
           pushPosition(1) <= size(maze, 1) && pushPosition(2) <= size(maze, 2) && ...
           maze(pushPosition(1), pushPosition(2)) == EMPTY
            maze(pushPosition(1), pushPosition(2)) = maze(newPosition(1), newPosition(2)); % Move pipe
            maze(newPosition(1), newPosition(2)) = EMPTY; % Clear old position
        else
            return;
        end
    end

    % Move player
    playerPosition = newPosition;

end

% Check pipe placement

function [maze, verify] = checkPipePlacement(maze, PIPE_H, PIPE_V, PIPE_FIXED_H, PIPE_FIXED_V,verify)
    
    if maze(8, 1) == PIPE_V
        maze(8, 1) = PIPE_FIXED_V;
        verify = verify + 1;
    
    elseif maze(5, 1) == PIPE_V
        maze(5, 1) = PIPE_FIXED_V;
        verify = verify + 1;
    
    elseif maze(9, 5) == PIPE_H
        maze(9, 5) = PIPE_FIXED_H;
        verify = verify + 1;
    end


end 
