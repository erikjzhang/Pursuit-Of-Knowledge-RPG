function[a,b,c]=room2(b,c)
c=c;
talk=0;

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
BAD_GRADE=32*31+11;

maze=[
    TLcorner Twall Twall Twall DOOR Twall Twall Twall TRcorner;
    Lwall GRASS2 GRASS GRASS2 GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS2 GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS2 GRASS Rwall;
    Lwall GRASS2 GRASS GRASS GRASS2 GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS2 GRASS GRASS2 GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS BAD_GRADE Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS2 GRASS Rwall;
    Lwall GRASS2 GRASS GRASS GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS GRASS GRASS2 Rwall;
    Lwall GRASS2 GRASS GRASS GRASS GRASS GRASS GRASS Rwall;
    Lwall GRASS2 GRASS2 GRASS GRASS2 GRASS GRASS2 GRASS2 Rwall;
    Lwall GRASS GRASS GRASS GRASS GRASS2 GRASS2 GRASS Rwall;
    BLcorner Bwall Bwall Bwall DOOR Bwall Bwall Bwall BRcorner;];
    

drawScene(gameEngine,maze)

%starting position
  
if strcmpi(b,'t')  
    playerPosition = [2,5];
else 
    playerPosition = [14,5];
end 

maze(playerPosition(1),playerPosition(2))=PLAYER;
drawScene(gameEngine,maze)
maze(playerPosition(1),playerPosition(2))=GRASS;

    %checks if there is a tutorial to be had
    if c==0
    pause(.05)
    text1=text(200,475,'Hey, hey you! Wanna learn to fight?','FontWeight','bold','FontSize',15,'Color','black','BackgroundColor','white');
    text2=text(600,525,' ','FontWeight','bold','FontSize',15,'Color','black','BackgroundColor','white');
    pause(3)
    delete(text1)
    delete(text2)
    close
    tutorialFightWindow
    c=1;
    clear sound
    [y,Hz]=audioread("overworldSong.mp3");
    sound (y,Hz)
    %puts the player back in overworld and bad grade says "darn another
    %excellent student"
    maze(playerPosition(1),playerPosition(2))=PLAYER;
    drawScene(gameEngine,maze)
    maze(playerPosition(1),playerPosition(2))=GRASS;
    text1=text(200,475,'Darn, another excellent student...','FontWeight','bold','FontSize',15,'Color','black','BackgroundColor','white');
    text2=text(600,525,' ','FontWeight','bold','FontSize',15,'Color','black','BackgroundColor','white');
    pause(2)
    delete(text1)
    delete(text2)
    end

b="0";
while (b=="0")

    pause(.1)
    gameMap=maze;
    % Draw the current room
    gameMap(playerPosition(1), playerPosition(2)) = PLAYER;
    drawScene(gameEngine,gameMap);

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
       gameMap(newPosition(1), newPosition(2)) ~= BAD_GRADE && ...
       gameMap(newPosition(1), newPosition(2)) ~= BRcorner
        % Update player position
        gameMap(playerPosition(1), playerPosition(2)) = GRASS;
        playerPosition = newPosition;
        %sees if the player tries to talk to bad grade grade
    elseif gameMap(newPosition(1), newPosition(2)) == BAD_GRADE
        if talk <4
            text1=text(200,475,'Darn, another excellent student...','FontWeight','bold','FontSize',15,'Color','black','BackgroundColor','white');
            text2=text(600,525,' ','FontWeight','bold','FontSize',15,'Color','black','BackgroundColor','white');
            pause(2)
            delete(text1)
            delete(text2)
            talk=talk+1;
        elseif talk <7
            text1=text(200,475,'...you know you can leave right?','FontWeight','bold','FontSize',15,'Color','black','BackgroundColor','white');
            text2=text(600,525,' ','FontWeight','bold','FontSize',15,'Color','black','BackgroundColor','white');
            pause(2)
            delete(text1)
            delete(text2)
            talk=talk+1;
        else
            text1=text(200,475,'I see! You need another lesson!','FontWeight','bold','FontSize',15,'Color','black','BackgroundColor','white');
            text2=text(600,525,' ','FontWeight','bold','FontSize',15,'Color','black','BackgroundColor','white');
            pause(2)
            delete(text1)
            delete(text2)
            close
            tutorialFightWindow
            clear sound
            [y,Hz]=audioread("overworldSong.mp3");
            sound (y,Hz)
            talk=0;
        end
    end
    if playerPosition == [1,5]
        a = "room3";
        b = "t";
        
    end
    if playerPosition == [15,5]
        a = "room1";
        b = "u"; 
    end

end 
close