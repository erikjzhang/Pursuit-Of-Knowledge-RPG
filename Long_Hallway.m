function [a,c] = Long_Hallway(c)
c=c;
 
[y,Hz]=audioread("Long_Hallway_Song.mp3");
clear sound
sound (y,Hz)

%Sprite values
spriteSize = 16;  
zoomFactor = 5;   
backgroundColor = [150 150 150]; 

% Initialize game engine with sprite sheet
spriteSheetFile = 'ModifiedRetro_pack.png';  
gameEngine = ModifiedSimpleGameEngine(spriteSheetFile, spriteSize, spriteSize, zoomFactor, backgroundColor);

%Map values
PLAYER = 32*4+27;  
Twall = 434;
Bwall = 498;
DOOR = 32*28+1; 
OpenDOOR=32*29+1;
TURBINE_OFF=32*30+4;
TURBINE_ON=32*30+5;
W=32*27+24;
Floor = 32*6+13;
Path = 41;
Fire = 32*10+16;


%establishes player position and matrix
playerPositon=[32,5];
man = [ones(9,9)];
man(5,5)=PLAYER;

%Builds the full hallway matrix
BigMaze=[
    W W W W W W W W W
    W W W W W W W W W
    W W W W W W W W W
    Twall Twall Twall Twall OpenDOOR Twall Twall Twall Twall
    Fire Fire Fire Fire Path Fire Fire Fire Fire
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Fire Floor Path Floor Fire Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Fire Floor Path Floor Fire Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Fire Floor Path Floor Fire Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Fire Floor Path Floor Fire Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Fire Floor Path Floor Fire Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Floor Floor Floor Floor Path Floor Floor Floor Floor
    Bwall Bwall Bwall Bwall DOOR Bwall Bwall Bwall Bwall
    W W W W W W W W W
    W W W W W W W W W
    W W W W W W W W W];


%Builds the part of the hallway visible
SmallMaze=BigMaze(playerPositon(1)-4:playerPositon(1)+4,:);

drawScene(gameEngine,SmallMaze,man)
newPosition=playerPositon;
while (playerPositon(1)~=5)
    key=getKeyboardInput(gameEngine);
    switch (key)
        case ('w') %if w is pressed, player appears to move up
            newPosition(1)=playerPositon(1)-1;
        case('s') %if s is pressed, player appears to move down
            newPosition(1)=playerPositon(1)+1;
        case('a') %if a is pressed, player appears to move left
            newPosition(2)=playerPositon(2)-1;
        case('d') %if d is pressed, player appears to move right
            newPosition(2)=playerPositon(2)+1;
    end

    %checks to see that the player can move there
    if (newPosition(2)==0 ||...
            newPosition(2)==10 ||...
            BigMaze(newPosition(1),newPosition(2))== Bwall ||...
            BigMaze(newPosition(1),newPosition(2))== Twall ||...
            BigMaze(newPosition(1),newPosition(2))== DOOR ||...
            BigMaze(newPosition(1),newPosition(2))== Fire)
    else
        man(5,playerPositon(2))= 1;
        playerPositon=newPosition;
        man(5,playerPositon(2))= PLAYER;
        SmallMaze=BigMaze(playerPositon(1)-4:playerPositon(1)+4,:);
    end

    %redraws the scene

    drawScene(gameEngine,SmallMaze,man)
end

%establishes variables to go fight Dr.Parris
a='ParrisFightWindow';
b='t';
