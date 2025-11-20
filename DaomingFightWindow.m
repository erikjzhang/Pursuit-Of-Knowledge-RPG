function [a,b,c] = DaomingFightWindow(c)
keepFighting = true;

%boss music
[y,Hz]=audioread("DaomingSong.mp3");
clear sound
sound(y,Hz)


while(keepFighting)

% Player and Boss Stats
playerGPA = 4; % Player's health
bossHP = 30; % Daoming health

% Game window size and sprites
row = 21;
column = 21;
sprite_sheet_contents = zeros(32, 32);
background = ones(row, column);

% Load Game Engine
my_scene = ModifiedSimpleGameEngine('ModifiedRetro_pack.png', 16, 16, 4);

% Placeholder Sprites
lightningSprite = 32*31 + 3; % Sprite for lightnings
warningLightningSprite = 32*31 + 1;
playerSprite = 32*4 + 27; % Sprite for the player
fullHeartSprite = 32*23-5;
emptyHeartSprite = 32*23-7;

background = ones(row,column);
borderSprite = 32*27 +24 ;

background(1:10) = borderSprite;
background(1:10, 21) = borderSprite;
background(1, 1:21) = borderSprite;
background(10, 1:21) = borderSprite;



Daomingsprite = 31*32 + 10;

background(4, 11) = Daomingsprite;
drawScene(my_scene, background);



 text1 = text(300, 1100, "Daoming Liu Stands Before You", "FontSize", 20, "Color", [1, 1, 1]);
 pause(3);
 delete(text1)

text1 = text(300, 900, "FIGHT!!!!!!!", "FontSize", 20, "Color", [1, 1, 1]);
pause(2); % Pause to emphasize the battle start
delete(text1); % Remove the text

 gpa = text(25, 1310, "Player GPA:", "FontSize", 20, "Color", [1, 1, 1]);
 daoming = text(20, 1250, "Daoming Health:", "FontSize", 20, "Color", [1, 1, 1]);

background(21,5) = fullHeartSprite;
background(21,6) = fullHeartSprite;
background(21,7) = fullHeartSprite;
background(21,8) = fullHeartSprite;
background(20,8) = fullHeartSprite;
background(20,6) = fullHeartSprite;
background(20,7) = fullHeartSprite;

drawScene(my_scene, background); % Render the game window with the current background

 %set up lightning attacks
 lightning = background;

% Player position
playerPos = [7, 11]; % Starting position of the player


lightningAnte = 1;

% Fight Loop
while playerGPA > 0 && bossHP > 0
    
    background = ones(row,column);
    lightning = background;
    text1 = text(300, 1100, "Daoming throws a lightning attack at you!", "FontSize", 20, "Color", [1, 1, 1]);
    attackTimer = 105;
    
    lightningTurn = 0;
    invincibility = 0;
    lightningOneTimer = 0;
    lightningTwoTimer = 0;
    lightningOneEnd = 0;
    lightningTwoEnd = 0;

    pause(3)


    while attackTimer > 0 && playerGPA > 0 && bossHP > 0

        delete(text1);
        text1 = text(300, 1100, "Avoid the yellow bolts! Red warns you!", "FontSize", 20, "Color", [1, 1, 1]);

        background(1:10) = borderSprite;
        background(1:10, 21) = borderSprite;
        background(1, 1:21) = borderSprite;
        background(10, 1:21) = borderSprite;
        if bossHP == 30
           background(20,8) = fullHeartSprite;
           background(20,7) = fullHeartSprite;
           background(20,6) = fullHeartSprite;
        elseif bossHP == 20
           background(20,6) = fullHeartSprite;
           background(20,7) = fullHeartSprite;
           background(20,8) = emptyHeartSprite;
        elseif bossHP == 10
           background(20,6) = fullHeartSprite;
           background(20,7) = emptyHeartSprite;
           background(20,8) = emptyHeartSprite;
        end
        if (playerGPA == 4)
            background(21,5) = fullHeartSprite;
            background(21,6) = fullHeartSprite;
            background(21,7) = fullHeartSprite;
            background(21,8) = fullHeartSprite;
        elseif playerGPA == 3 
            background(21,5) = fullHeartSprite;
            background(21,6) = fullHeartSprite;
            background(21,7) = fullHeartSprite;
            background(21,8) = emptyHeartSprite;
        elseif playerGPA == 2
            background(21,5) = fullHeartSprite;
            background(21,6) = fullHeartSprite;
            background(21,7) = emptyHeartSprite;
            background(21,8) = emptyHeartSprite;
        elseif playerGPA == 1
            background(21,5) = fullHeartSprite;
            background(21,6) = emptyHeartSprite;
            background(21,7) = emptyHeartSprite;
            background(21,8) = emptyHeartSprite;
        elseif playerGPA == 0
            background(21,5) = emptyHeartSprite;
            background(21,6) = emptyHeartSprite;
            background(21,7) = emptyHeartSprite;
            background(21,8) = emptyHeartSprite;
        end
        
        



        % Move player with keyboard input
        key = getKeyboardInput(my_scene);
        if ~isempty(key) % Check if a key is pressed
            switch key
                case 'w', playerPos(1) = max(playerPos(1) - 1, 1); % Move up
                case 's', playerPos(1) = min(playerPos(1) + 1, row); % Move down
                case 'a', playerPos(2) = max(playerPos(2) - 1, 1); % Move left
                case 'd', playerPos(2) = min(playerPos(2) + 1, column); % Move right
            end
        end

        if (playerPos(1) == 1)
            playerPos(1) = 2;
        end

        if (playerPos(1) == 10)
            playerPos(1) = 9;
        end

        if (playerPos(2) == 1)
            playerPos(2) = 2;
        end

        if (playerPos(2) == 21)
            playerPos(2) = 20;
        end
        
        %reduces invincibility timer
        if invincibility ~= 0
            invincibility = invincibility -1;
        end

        % Check for collisions with lightning
        if lightning(playerPos(1), playerPos(2)) == lightningSprite
            if invincibility == 0
                playerGPA = playerGPA - 1;
                invincibility = 10;
            end
         
        end

        %TO DO


        if lightningOneEnd > 0
            if lightningOneEnd == 1
                lightning(2:9,lightningOneRow) = 1;
            end
            lightningOneEnd = lightningOneEnd -1;
        end

        if (lightningTurn == 0)
            lightningOneRow = playerPos(2);
            lightning(2:9,lightningOneRow) = warningLightningSprite;
            if lightningAnte == 1
                lightningOneTimer = 10;
            elseif lightningAnte == 2
                lightningOneTimer = 8;
            elseif lightningAnte == 3
                lightningOneTimer = 6;
            end
            lightningTurn = 2;
        end
        
        if lightningOneTimer > 0
            if lightningOneTimer == 1
                lightning(2:9,lightningOneRow) = lightningSprite;
                lightningOneEnd = 5;
                lightningTurn = 1;
            end
            lightningOneTimer = lightningOneTimer -1;
        end




        if lightningTwoEnd > 0
            if lightningTwoEnd == 1
                lightning(2:9,lightningTwoRow) = 1;
            end
            lightningTwoEnd = lightningTwoEnd -1;
        end


        if (lightningTurn == 1)
             lightningTwoRow = playerPos(2);
            lightning(2:9,lightningTwoRow) = warningLightningSprite; 
            if lightningAnte == 1
                lightningTwoTimer = 10;
            elseif lightningAnte == 2
                lightningTwoTimer = 8;
            elseif lightningAnte == 3
                lightningTwoTimer = 6;
            end
            lightningTurn = 2;
        end

        if lightningTwoTimer > 0
            if lightningTwoTimer == 1
                lightning(2:9,lightningTwoRow) = lightningSprite;
                lightningTwoEnd = 5;
                lightningTurn = 0;
            end
            lightningTwoTimer = lightningTwoTimer -1;
        end




        

        %draw scene
        drawScene(my_scene, background, lightning);


        % Update scene
        background = ones(row, column); % Reset background
        background(playerPos(1), playerPos(2)) = playerSprite;
        attackTimer = attackTimer - 1;
    end

    delete(text1);
    
    if (playerGPA > 0 && bossHP > 0)

        text1 = text(100, 900, "Your Turn! Answer a question to attack Daoming!.", "FontSize", 20, "Color", [1, 1, 1]);
        pause(2);
        delete(text1);

        
        %User's Turn: Answer Questions to Attack
        if (lightningAnte == 1)

             
            
            text1 = text(50, 740, "Which are true: ", "FontSize", 20, "Color", [1, 1, 1]);
            text7 = text(30, 810, "i) Computer engineers work with hardware ii) They work with software ", "FontSize", 20, "Color", [1, 1, 1]);
            text2 = text(200, 880, "(Press the specific key for the correct answer)", "FontSize", 20, "Color", [1, 1, 1]);
            text3 = text(50, 1000, "A) i and ii", "FontSize", 20, "Color", [1, 1, 1]);
            text4 = text(800, 1000, "B) Neither", "FontSize", 20, "Color", [1, 1, 1]);
            text5 = text(50, 1100, "C) i", "FontSize", 20, "Color", [1, 1, 1]);
            text6 = text(800, 1100, "D) ii", "FontSize", 20, "Color", [1, 1, 1]);

            answered = false;
            while(~answered)
                key = getKeyboardInput(my_scene);
                if (~isempty(key))
                    switch key
                        case 'a', answer = 'a';
                            answered = true;
                        case 'b', answer = 'B';
                            answered = true;
                        case 'c', answer = 'c';
                            answered = true;
                        case 'd', answer = 'd';
                            answered = true;
                    end
                end

            end
            delete(text1);
            delete(text2);
            delete(text3);
            delete(text4);
            delete(text5);
            delete(text6);
            delete(text7);

        if strcmpi(answer, 'a')
            text1 = text(200, 870, "Correct! You deal -1 Heart to Daoming.", "FontSize", 20, "Color", [1, 1, 1]);
            bossHP = bossHP - 10;
            pause(2);
            delete(text1)
            lightningAnte = lightningAnte + 1;
        else
            text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
            pause(2)
            delete(text1)
        end
        elseif lightningAnte == 2
            text1 = text(190, 800, "Which DON'T electrical and computer engineers work with", "FontSize", 20, "Color", [1, 1, 1]);
            text2 = text(200, 870, "(Press the specific key for the correct answer)", "FontSize", 20, "Color", [1, 1, 1]);
            text3 = text(50, 1000, "A) Internet", "FontSize", 20, "Color", [1, 1, 1]);
            text4 = text(800, 1000, "B) Robots", "FontSize", 20, "Color", [1, 1, 1]);
            text5 = text(50, 1100, "C) Medical Devices", "FontSize", 20, "Color", [1, 1, 1]);
            text6 = text(800, 1100, "D) Ceramics", "FontSize", 20, "Color", [1, 1, 1]);

            answered = false;
            while(~answered)
                key = getKeyboardInput(my_scene);
                if (~isempty(key))
                    switch key
                        case 'a', answer = 'a';
                            answered = true;
                        case 'b', answer = 'b';
                            answered = true;
                        case 'c', answer = 'c';
                            answered = true;
                        case 'd', answer = 'd';
                            answered = true;
                    end
                end

            end
            delete(text1);
            delete(text2);
            delete(text3);
            delete(text4);
            delete(text5);
            delete(text6);
            
        if strcmpi(answer, 'd')
            text1 = text(200, 870, "Correct! You deal -1 Heart to Daoming.", "FontSize", 20, "Color", [1, 1, 1]);
            bossHP = bossHP - 10;
            pause(2);
            delete(text1)
            lightningAnte = lightningAnte + 1;
        else
            text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
            pause(2)
            delete(text1)
        end
        elseif lightningAnte == 3
            text1 = text(40, 800, "True or False: Electrical and Computer engineers can't help the environment", "FontSize", 18, "Color", [1, 1, 1]);
            text2 = text(200, 870, "(Press the specific key for the correct answer)", "FontSize", 20, "Color", [1, 1, 1]);
            text3 = text(60, 1050, "A) True", "FontSize", 20, "Color", [1, 1, 1]);
            text4 = text(800, 1050, "B) False", "FontSize", 20, "Color", [1, 1, 1]);

            answered = false;
            while(~answered)
                key = getKeyboardInput(my_scene);
                if (~isempty(key))
                    switch key
                        case 'a', answer = 'a';
                            answered = true;
                        case 'b', answer = 'B';
                            answered = true;
                    end
                end

            end
            delete(text1);
            delete(text2);
            delete(text3);
            delete(text4);
            
        if strcmpi(answer, 'b')
            text1 = text(200, 870, "Correct! You deal -1 Heart to Daoming.", "FontSize", 20, "Color", [1, 1, 1]);
            bossHP = bossHP - 10;
            pause(2);
            delete(text1)
            lightningAnte = lightningAnte + 1;
        else
            text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
            pause(2)
            delete(text1)
        end
        end
    end
end



% End of Battle

background = ones(row, column); % Reset background
    
    

if playerGPA <= 0
    delete(daoming);
    background(7, 11) = Daomingsprite;
    background(21,5) = emptyHeartSprite;
    background(21,6) = emptyHeartSprite;
    background(21,7) = emptyHeartSprite;
    background(21,8) = emptyHeartSprite;

    drawScene(my_scene, background);
       text1 = text(300, 900, "You lost the battle against Daoming Liu.", "FontSize", 20, "Color", [1, 1, 1]);
else
    clear sound
    delete(daoming);
    delete(gpa);
    background(7, 11) = playerSprite;
    drawScene(my_scene, background);
   text1 = text(300, 900, "You won the battle against Daoming.", "FontSize", 20, "Color", [1, 1, 1]);

end
pause(5)

delete(text1)
if playerGPA <= 0
   text1 = text(300, 900, "Do you want to keep fighting?", "FontSize", 20, "Color", [1, 1, 1]);
   text1 = text(300, 1000, "A. Yes", "FontSize", 20, "Color", [1, 1, 1]);
   text1 = text(300, 1100, "B. No", "FontSize", 20, "Color", [1, 1, 1]);

            answered = false;
            while(~answered)
                key = getKeyboardInput(my_scene);
                if (~isempty(key))
                    answered = true;
                    switch key
                        case 'a', answer = 'a';
                            keepFighting = true;
                        case 'b', answer = 'b';
                            keepFighting = false;
                        otherwise, answered = false;
                    end
                end

            end
            close
else 
    keepFighting = false;
end

end
close
a="room3";
b="Daoming";
c=3;
end
