clear
clc
clear sound

b=0;
c=1;
isPlaying=1;

%Pulls up a drawing explaining the story and loads in audio file
%Makes a loading screen
sprite=ModifiedSimpleGameEngine('ModifiedRetro_pack.png',16,16,3);
lore=[ones(15,26)];
drawScene(sprite,lore)
text(50,75,'Welcome, I am glad you are here','FontWeight','bold','FontSize',15,'Color','white');
pause(.1)
text(100,145,'You are so close to completing ENGR 1181, but someone stands in your way...','FontWeight','bold','FontSize',15,'Color','white');
pause(.1)
text(100,185,'Dr. Parris (a wonderful professor) has declared you cannot pass his class,','FontWeight','bold','FontSize',15,'Color','white');
pause(.1)
text(100,225,'"Your grade has taken too many hits and I cannot go against The Council"','FontWeight','bold','FontSize',15,'Color','white');
pause(.1)
text(100,265,'"To prove your worth you must challenge all four of my TAs in a- ','FontWeight','bold','FontSize',15,'Color','white');
pause(.1)
text(50,370,'PURSUIT FOR KNOWLEDGE','FontWeight','bold','FontSize',40,'Color','white');
pause(.1)
text(100,475,'Perhaps then you can approach me about changing your grade" ','FontWeight','bold','FontSize',15,'Color','white');
pause(.1)
text(100,525,'He turns his back on you and leaves you to ponder his offer','FontWeight','bold','FontSize',15,'Color','white');
pause(.1)
[y,Hz]=audioread("overworldSong.mp3");
text(200,600,'PRESS SPACE TO CONTINUE','FontWeight','bold','FontSize',15,'Color','white');
key='0';
while(key~=' ')
    key=getKeyboardInput(sprite);
end
close

%Makes a loading screen
sprite=ModifiedSimpleGameEngine('ModifiedRetro_pack.png',16,16,2);
loading=[ones(2,12);
    1,32*30+31,32*31+21,32*30+20,32*30+23,32*30+28,32*31+20,32*30+26,32*29+31,32*29+31,32*29+31,1
    ones(2,12)];
drawScene(sprite,loading)

%plays a song for overworld
clear sound
sound(y,Hz)

%Starts the player in the first room
[roomX,roomY,c]=room1(b,c);

%Takes the player to the room requested by the function
while(isPlaying)
    switch roomX
        case 'room1'
            [roomX,roomY,c]=room1(roomY,c);
        case 'room2'
            [roomX,roomY,c]=room2(roomY,c);
        case 'room3'
            [roomX,roomY,c]=room3(roomY,c);
        case 'WindPuzzle'
            [roomX,c]=WindPuzzle(c);
        case 'DillonFightWindow'
            [roomX,roomY,c]=DillonFightWindow(c);
        case 'CircuitPuzzle'
            [roomX,c]=CircuitPuzzle(c);
        case 'DaomingFightWindow'
            [roomX,roomY,c]=DaomingFightWindow(c);
        case 'PipePuzzle'
            [roomX,c]=PipePuzzle(c);
        case 'ShaylaOliviaFightWindow'
            [roomX,roomY,c]=ShaylaOliviaFightWindow(c);
        case 'Long_Hallway'
            [roomX,c]=Long_Hallway(c);
        case 'ParrisFightWindow'
            [roomX,roomY,c,isPlaying]=ParrisFightWindow(c);

    end
end
clear sound
close

clear
clc

c=5;
if c==5
    sprite=ModifiedSimpleGameEngine('ModifiedRetro_pack.png',16,16,5);
    lore=[ones(15,26)];
    drawScene(sprite,lore)
    text1 = text(750,450,'You WON!!!','FontWeight','bold','FontSize',40,'Color','white');
    text2 = text(450,550,'You passed ENGR 1181!!!','FontWeight','bold','FontSize',40,'Color','white');
end