%by brandon
function[a,c]=WindPuzzle(c)
c=c;

[y,Hz]=audioread("windPuzzleSong.mp3");
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
DOOR = 32*28+1; 
FIRE = 335;
TREE = 35;
TURBINE_OFF=32*30+4;
TURBINE_ON=32*30+5;
W=32*27+24;
blow=32*31+4;
air=32*31+5;

%Makes a matrix for all the immovable objects
maze=[
    Twall Twall Twall Twall DOOR Twall Twall Twall;
    TURBINE_OFF 1 1 1 1 1 1 W;
    W W W W W 1 1 W;
    1 1 1 1 1 1 1 W;
    W W 1 W 1 1 W W;
    TURBINE_ON 1 1 1 1 1 1 1;
    1 1 W W 1 1 1 1;
    1 1 1 1 1 1 1 1;
    TURBINE_OFF 1 1 1 1 1 1 1;
    1 1 1 1 1 1 1 1;
    1 1 1 1 1 1 1 1;
    Bwall Bwall Bwall Bwall DOOR Bwall Bwall Bwall;];

%makes a matrix for movable objects that goes on top
wind=[
    ones(5,8);
    air air air air blow 1 1 1;
    ones(1,8)
    air air air blow 1 1 1 1;
    ones(1,8)
    air air air blow 1 1 1 1;
    ones(2,8)];


%draws scene
drawScene(gameEngine,maze,wind)

%puts player in loop that lets them move around
k=0;
playerPosition=[11,5];
maze(playerPosition(1),playerPosition(2))=PLAYER;
drawScene(gameEngine,maze,wind)
maze(playerPosition(1),playerPosition(2))=1;
while (playerPosition(1) ~= 1 && k~='q')
  
    %get players movement input
    pause(.05)
    k=getKeyboardInput(gameEngine);
    switch (k)
        case 'w'
            %checks if something is in the way
            if (playerPosition(1)-1==0 ||...
                    maze(playerPosition(1)-1,playerPosition(2))==W ||...
                    maze(playerPosition(1)-1,playerPosition(2))==Bwall||...
                    maze(playerPosition(1)-1,playerPosition(2))==Twall||...
                    maze(playerPosition(1)-1,playerPosition(2))==TURBINE_ON ||...
                    maze(playerPosition(1)-1,playerPosition(2))==TURBINE_OFF ||...
                    maze(playerPosition(1)-1,playerPosition(2))==DOOR)
                continue
            else
                %checks if blower can be pushed
            if (wind(playerPosition(1)-1,playerPosition(2))==blow)
                if(maze(playerPosition(1)-2,playerPosition(2))==W ||...
                        maze(playerPosition(1)-2,playerPosition(2))==Twall ||...
                        maze(playerPosition(1)-2,playerPosition(2))==TURBINE_ON ||...
                        maze(playerPosition(1)-2,playerPosition(2))==TURBINE_OFF ||...
                        wind(playerPosition(1)-2,playerPosition(2))==blow)
                    continue
                else
                    %move the blower and player
                    wind(playerPosition(1)-1,playerPosition(2))=1;
                    wind(playerPosition(1)-2,playerPosition(2))=blow;
                    %removes the remaining air effects but leaves particles
                    %belonging to another blower
                    for n=1:playerPosition(2)-1
                        if(wind(playerPosition(1)-1,n)~=blow)
                            wind(playerPosition(1)-1,n)=1;
                        else
                            for m=1:n-1
                                wind(playerPosition(1)-1,m)=air;
                            end
                        end
                        if(wind(playerPosition(1)-2,n)~=blow)
                            wind(playerPosition(1)-2,n)=air;
                        end
                    end
                    playerPosition(1)=playerPosition(1)-1;
                end
            else
                %moves player up 1
                playerPosition(1)=playerPosition(1)-1;
            end
            end
        case 's'
            %checks if something is in the way
            if (playerPosition(1)+1==13 ||...
                    maze(playerPosition(1)+1,playerPosition(2))==W ||...
                    maze(playerPosition(1)+1,playerPosition(2))==Bwall||...
                    maze(playerPosition(1)+1,playerPosition(2))==Twall||...
                    maze(playerPosition(1)+1,playerPosition(2))==TURBINE_ON ||...
                    maze(playerPosition(1)+1,playerPosition(2))==TURBINE_OFF ||...
                    maze(playerPosition(1)+1,playerPosition(2))==DOOR)
                continue
            else
            %Checks if a blower can be pushed
            if (wind(playerPosition(1)+1,playerPosition(2))==blow)
                if(maze(playerPosition(1)+2,playerPosition(2))==W ||...
                        maze(playerPosition(1)+2,playerPosition(2))==Bwall ||...
                        maze(playerPosition(1)+2,playerPosition(2))==TURBINE_OFF ||...
                        maze(playerPosition(1)+2,playerPosition(2))==TURBINE_ON ||...
                        wind(playerPosition(1)+2,playerPosition(2))==blow)
                    continue
                else
                    %moves the blower and air down 1 and player
                    wind(playerPosition(1)+1,playerPosition(2))=1;
                    wind(playerPosition(1)+2,playerPosition(2))=blow;
                    for n=1:playerPosition(2)-1
                        if(wind(playerPosition(1)+1,n)~=blow)
                            wind(playerPosition(1)+1,n)=1;
                        else
                    %removes the remaining air effects but leaves particles
                    %belonging to another blower
                            for m=1:n-1
                                wind(playerPosition(1)+1,m)=air;
                            end
                        end
                        if(wind(playerPosition(1)+2,n)~=blow)
                            wind(playerPosition(1)+2,n)=air;
                        end
                    end
                    playerPosition(1)=playerPosition(1)+1;
                end
            else
                %moves the player down 1
                playerPosition(1)=playerPosition(1)+1;
            end
            end
        case 'a'
            %checks to see if somethng is in the way
             if (playerPosition(2)-1==0 ||...
                    maze(playerPosition(1),playerPosition(2)-1)==W ||...
                    maze(playerPosition(1),playerPosition(2)-1)==Bwall||...
                    maze(playerPosition(1),playerPosition(2)-1)==Twall||...
                    maze(playerPosition(1),playerPosition(2)-1)==TURBINE_ON ||...
                    maze(playerPosition(1),playerPosition(2)-1)==TURBINE_OFF ||...
                    maze(playerPosition(1),playerPosition(2)-1)==DOOR)
                    
                continue
             else
            %checks to see if a blower can be pushed
            if (wind(playerPosition(1),playerPosition(2)-1)==blow)
                if (playerPosition(2)-2~=0)
                if(maze(playerPosition(1),playerPosition(2)-2)==W ||...
                        maze(playerPosition(1),playerPosition(2)-2)==TURBINE_ON ||...
                        maze(playerPosition(1),playerPosition(2)-2)==TURBINE_OFF ||...
                        wind(playerPosition(1),playerPosition(2)-2)==blow)
                    continue
                else
                    %moves the blower and player to the left
                    wind(playerPosition(1),playerPosition(2)-1)=1;
                    wind(playerPosition(1),playerPosition(2)-2)=blow;
                    playerPosition(2)=playerPosition(2)-1;
                end
                end
            else
                playerPosition(2)=playerPosition(2)-1;
            end
            end
        case 'd'
            %checks to see if something is in the way
            if (playerPosition(2)+1==9 ||...
                maze(playerPosition(1),playerPosition(2)+1)==W ||...
                    maze(playerPosition(1),playerPosition(2)+1)==Bwall||...
                    maze(playerPosition(1),playerPosition(2)+1)==Twall||...
                    maze(playerPosition(1),playerPosition(2)+1)==TURBINE_ON ||...
                    maze(playerPosition(1),playerPosition(2)+1)==TURBINE_OFF ||...
                    maze(playerPosition(1),playerPosition(2)+1)==DOOR)
             
                continue
            else
            %Checks if there is a blower and if it's pushable
            if (wind(playerPosition(1),playerPosition(2)+1)==blow)
                if (playerPosition(2)+2~=9)
                if(maze(playerPosition(1),playerPosition(2)+2)==W ||...
                        maze(playerPosition(1),playerPosition(2)+2)==Bwall ||...
                        wind(playerPosition(1),playerPosition(2)+2)==blow)
                    continue
                else
                    %moves the player blower and air right 
                    wind(playerPosition(1),playerPosition(2)+1)=air;
                    wind(playerPosition(1),playerPosition(2)+2)=blow;
                    playerPosition(2)=playerPosition(2)+1;
                end
                end

            else
                %moves the player down 1
                playerPosition(2)=playerPosition(2)+1;
            end
            end
        case 'r' %resets the level
            maze=[
    Twall Twall Twall Twall DOOR Twall Twall Twall;
    TURBINE_OFF 1 1 1 1 1 1 W;
    W W W W W 1 1 W;
    1 1 1 1 1 1 1 W;
    W W 1 W 1 1 W W;
    TURBINE_ON 1 1 1 1 1 1 1;
    1 1 W W 1 1 1 1;
    1 1 1 1 1 1 1 1;
    TURBINE_OFF 1 1 1 1 1 1 1;
    1 1 1 1 1 1 1 1;
    1 1 1 1 1 1 1 1;
    Bwall Bwall Bwall Bwall Bwall Bwall Bwall Bwall;];

            wind=[
    ones(5,8);
    air air air air blow 1 1 1;
    ones(1,8)
    air air air blow 1 1 1 1;
    ones(1,8)
    air air air blow 1 1 1 1;
    ones(2,8)];

            playerPosition=[12,5];
        case 'q'
            isPlaying=0;
    end

    %checks if turbine 1 is on
    if wind(2,1)==air
        maze(2,1)=TURBINE_ON;
    else
        maze(2,1)=TURBINE_OFF;
    end

    %checks if turbine 2 is on
    if wind(6,1)==air
        maze(6,1)=TURBINE_ON;
    else
        maze(6,1)=TURBINE_OFF;
    end

    %checks if turbine 3 is on
    if wind(9,1)==air
        maze(9,1)=TURBINE_ON;
    else
        maze(9,1)=TURBINE_OFF;
    end

    %Check if all turbines are on so the door opens
    if maze(9,1)==TURBINE_ON && maze(6,1)==TURBINE_ON && maze(2,1)==TURBINE_ON
        maze(1,5)=1;
    end


    maze(playerPosition(1),playerPosition(2))=PLAYER;
    drawScene(gameEngine,maze,wind)
    maze(playerPosition(1),playerPosition(2))=1;

end
close
a='DillonFightWindow';