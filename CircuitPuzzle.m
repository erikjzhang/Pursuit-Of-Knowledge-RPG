%by brandon
function[a,c]=CircuitPuzzle(c)
c=c;

[y,Hz]=audioread("windPuzzleSong.mp3");
clear sound
sound (y,Hz)

%Sprite values
spriteSize = 16;  
zoomFactor = 5;   
backgroundColor = [150 150 150]; 

%establishes a variable for checking progress on puzzle
verify=0;

% Initialize game engine with sprite sheet
spriteSheetFile = 'ModifiedRetro_pack.png';  
gameEngine = ModifiedSimpleGameEngine(spriteSheetFile, spriteSize, spriteSize, zoomFactor, backgroundColor);

%Map values
PLAYER = 32*4+27;  
Twall = 434;
Bwall = 498;
DOOR = 32*28+1; 
TURBINE_OFF=32*30+4;
TURBINE_ON=32*30+5;
W=32*27+24;
blow=32*31+4;
air=32*31+5;
hPushBolt=32*30+1;
vPushBolt=32*31+1;
hOffBolt=32*30+2;
vOffBolt=32*31+2;
hOnBolt=32*30+3;
vOnBolt=32*31+3;

%Makes a matrix for all the objects
maze=[
    Twall Twall Twall Twall DOOR Twall Twall Twall;
    1 1 1 1 1 1 1 vOnBolt;
    1 W W hPushBolt W 1 1 vOffBolt;
    1 1 hPushBolt 1 1 1 1 vOffBolt;
    1 1 W W 1 1 W vOffBolt;
    1 hOffBolt hOffBolt hOffBolt hOffBolt 1 hOffBolt vOffBolt;
    vOffBolt W W W W 1 W W;
    vOffBolt 1 1 1 1 1 1 W;
    vOffBolt 1 1 1 1 1 1 W;
    1 1 vPushBolt 1 1 1 1 W;
    vOnBolt 1 1 1 1 W W W;
    Bwall Bwall Bwall Bwall DOOR Bwall Bwall Bwall];

%draws scene
drawScene(gameEngine,maze)

%puts player in loop that lets them move around
k=0;
playerPosition=[11,5];
maze(playerPosition(1),playerPosition(2))=PLAYER;
drawScene(gameEngine,maze)
maze(playerPosition(1),playerPosition(2))=1;
while (playerPosition(1) ~= 1 && k~='q')
  
    %get players movement input
    k=getKeyboardInput(gameEngine);
    pause(.05)
    switch (k)
        case 'w'
            %checks if something is in the way
            if (playerPosition(1)-1==0 ||...
                    maze(playerPosition(1)-1,playerPosition(2))==W ||...
                    maze(playerPosition(1)-1,playerPosition(2))==Bwall||...
                    maze(playerPosition(1)-1,playerPosition(2))==Twall||...
                    maze(playerPosition(1)-1,playerPosition(2))==hOnBolt ||...
                    maze(playerPosition(1)-1,playerPosition(2))==hOffBolt ||...
                    maze(playerPosition(1)-1,playerPosition(2))==vOnBolt ||...
                    maze(playerPosition(1)-1,playerPosition(2))==vOffBolt ||...
                    maze(playerPosition(1)-1,playerPosition(2))==DOOR)
                continue
            else
                %checks if bolt can be pushed
            if (maze(playerPosition(1)-1,playerPosition(2))==hPushBolt||...
                    maze(playerPosition(1)-1,playerPosition(2))==vPushBolt)
                if(maze(playerPosition(1)-2,playerPosition(2))==W ||...
                        maze(playerPosition(1)-2,playerPosition(2))==Twall ||...
                        maze(playerPosition(1)-2,playerPosition(2))==vOffBolt ||...
                        maze(playerPosition(1)-2,playerPosition(2))==vOnBolt ||...
                        maze(playerPosition(1)-2,playerPosition(2))==hOffBolt ||...
                        maze(playerPosition(1)-2,playerPosition(2))==hOnBolt||...
                        maze(playerPosition(1)-2,playerPosition(2))==vPushBolt ||...
                        maze(playerPosition(1)-2,playerPosition(2))==hPushBolt ||...
                        maze(playerPosition(1)-2,playerPosition(2))==DOOR)
                    continue
                else
                    %moves the bolt and player up
                    if maze(playerPosition(1)-1,playerPosition(2))==hPushBolt
                        maze(playerPosition(1)-2,playerPosition(2))=hPushBolt;
                    else
                        maze(playerPosition(1)-2,playerPosition(2))=vPushBolt;
                    end
                    maze(playerPosition(1)-1,playerPosition(2))=1;
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
                    maze(playerPosition(1)+1,playerPosition(2))==vOffBolt||...
                    maze(playerPosition(1)+1,playerPosition(2))==vOnBolt||...
                    maze(playerPosition(1)+1,playerPosition(2))==hOffBolt||...
                    maze(playerPosition(1)+1,playerPosition(2))==hOnBolt||...
                    maze(playerPosition(1)+1,playerPosition(2))==DOOR)
                continue
            else
            %Checks if a bolt can be pushed
            if (maze(playerPosition(1)+1,playerPosition(2))==hPushBolt||...
                    maze(playerPosition(1)+1,playerPosition(2))==vPushBolt)
                if(maze(playerPosition(1)+2,playerPosition(2))==W ||...
                        maze(playerPosition(1)+2,playerPosition(2))==Bwall ||...
                        maze(playerPosition(1)+2,playerPosition(2))==vOffBolt ||...
                        maze(playerPosition(1)+2,playerPosition(2))==vOnBolt ||...
                        maze(playerPosition(1)+2,playerPosition(2))==hOffBolt ||...
                        maze(playerPosition(1)+2,playerPosition(2))==hOnBolt ||...
                        maze(playerPosition(1)+2,playerPosition(2))==hPushBolt ||...
                        maze(playerPosition(1)+2,playerPosition(2))==vPushBolt ||...
                        maze(playerPosition(1)+2,playerPosition(2))==DOOR)
                    continue
                else
                    %moves the bolt
                    if maze(playerPosition(1)+1,playerPosition(2))==hPushBolt
                        maze(playerPosition(1)+2,playerPosition(2))=hPushBolt;
                    else
                        maze(playerPosition(1)+2,playerPosition(2))=vPushBolt;
                    end
                    maze(playerPosition(1)+1,playerPosition(2))=1;
                    playerPosition(1)=playerPosition(1)+1;
                end
            else
                %moves the player down 1
                playerPosition(1)=playerPosition(1)+1;
            end
            end
        case 'a'
            %checks to see if something is in the way
             if (playerPosition(2)-1==0 ||...
                    maze(playerPosition(1),playerPosition(2)-1)==W ||...
                    maze(playerPosition(1),playerPosition(2)-1)==Bwall||...
                    maze(playerPosition(1),playerPosition(2)-1)==Twall||...
                    maze(playerPosition(1),playerPosition(2)-1)==vOnBolt||...
                    maze(playerPosition(1),playerPosition(2)-1)==vOffBolt||...
                    maze(playerPosition(1),playerPosition(2)-1)==hOnBolt||...
                    maze(playerPosition(1),playerPosition(2)-1)==hOffBolt||...
                    maze(playerPosition(1),playerPosition(2)-1)==DOOR)
                    
                continue
             else
            %checks to see if a bolt can be pushed
            if (maze(playerPosition(1),playerPosition(2)-1)==vPushBolt||...
                    maze(playerPosition(1),playerPosition(2)-1)==hPushBolt)
                if (playerPosition(2)-2~=0)
                if(maze(playerPosition(1),playerPosition(2)-2)==W ||...
                        maze(playerPosition(1),playerPosition(2)-2)==vOffBolt ||...
                        maze(playerPosition(1),playerPosition(2)-2)==vOnBolt ||...
                        maze(playerPosition(1),playerPosition(2)-2)==hOffBolt ||...
                        maze(playerPosition(1),playerPosition(2)-2)==hOnBolt)
                    continue
                else
                    %moves the bolt
                    if maze(playerPosition(1),playerPosition(2)-1)==hPushBolt
                        maze(playerPosition(1),playerPosition(2)-2)=hPushBolt;
                    else
                        maze(playerPosition(1),playerPosition(2)-2)=vPushBolt;
                    end
                    maze(playerPosition(1),playerPosition(2)-1)=1;
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
                    maze(playerPosition(1),playerPosition(2)+1)==hOnBolt||...
                    maze(playerPosition(1),playerPosition(2)+1)==hOffBolt||...
                    maze(playerPosition(1),playerPosition(2)+1)==vOnBolt||...
                    maze(playerPosition(1),playerPosition(2)+1)==vOffBolt||...
                    maze(playerPosition(1),playerPosition(2)+1)==DOOR)
             
                continue
            else
            %Checks if there is a bolt and if it's pushable
            if (maze(playerPosition(1),playerPosition(2)+1)==hPushBolt||...
                    maze(playerPosition(1),playerPosition(2)+1)==vPushBolt)
                if (playerPosition(2)+2~=9)
                if(maze(playerPosition(1),playerPosition(2)+2)==W ||...
                        maze(playerPosition(1),playerPosition(2)+2)==Bwall ||...
                        maze(playerPosition(1),playerPosition(2)+2)==hOffBolt||...
                        maze(playerPosition(1),playerPosition(2)+2)==hOnBolt||...
                        maze(playerPosition(1),playerPosition(2)+2)==vOffBolt||...
                        maze(playerPosition(1),playerPosition(2)+2)==vOnBolt)
                    continue
                else
                    if maze(playerPosition(1),playerPosition(2)+1)==hPushBolt
                        maze(playerPosition(1),playerPosition(2)+2)=hPushBolt;
                    else
                        maze(playerPosition(1),playerPosition(2)+2)=vPushBolt;
                    end
                    maze(playerPosition(1),playerPosition(2)+1)=1;
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
    1 1 1 1 1 1 1 vOnBolt;
    1 W W hPushBolt W 1 1 vOffBolt;
    1 1 hPushBolt 1 1 1 1 vOffBolt;
    1 1 W W 1 1 W vOffBolt;
    1 hOffBolt hOffBolt hOffBolt hOffBolt 1 hOffBolt vOffBolt;
    vOffBolt W W W W 1 W W;
    vOffBolt 1 1 1 1 1 1 W;
    vOffBolt 1 1 1 1 1 1 W;
    1 1 vPushBolt 1 1 1 1 W;
    vOnBolt 1 1 1 1 W W W;
    Bwall Bwall Bwall Bwall DOOR Bwall Bwall Bwall];

            verify=0;

            playerPosition=[11,5];
        case 'q'
            isPlaying=0;
    end

    %checks if a pushable circuit is in place
   if maze(10,1)==vPushBolt
       maze(10,1)=vOffBolt;
       verify=verify+1;
   elseif maze(6,1)==hPushBolt
       maze(6,1)=hOffBolt;
       verify=verify+1;
   elseif maze(6,6)==hPushBolt
       maze(6,6)=hOffBolt;
       verify=verify+1;
   end

    %Check if the circuit is complete so the door can open
    if verify==3
        maze= [Twall Twall Twall Twall 1 Twall Twall Twall;
    1 1 1 1 1 1 1 vOnBolt;
    1 W W 1 W 1 1 vOnBolt;
    1 1 1 1 1 1 1 vOnBolt;
    1 1 W W 1 1 W vOnBolt;
    hOnBolt hOnBolt hOnBolt hOnBolt hOnBolt hOnBolt hOnBolt vOnBolt;
    vOnBolt W W W W 1 W W;
    vOnBolt 1 1 1 1 1 1 W;
    vOnBolt 1 1 1 1 1 1 W;
    vOnBolt 1 1 1 1 1 1 W;
    vOnBolt 1 1 1 1 W W W;
    Bwall Bwall Bwall Bwall DOOR Bwall Bwall Bwall];
    end

    maze(playerPosition(1),playerPosition(2))=PLAYER;
    drawScene(gameEngine,maze)
    maze(playerPosition(1),playerPosition(2))=1;

end
close
a='DaomingFightWindow';