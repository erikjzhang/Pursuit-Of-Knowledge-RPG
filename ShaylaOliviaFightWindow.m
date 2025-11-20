function [a,b,c] = ShaylaOliviaFightWindow(c)
keepFighting = true;

%boss music
[y,Hz]=audioread("ShaylaOlivaSong.mp3");
clear sound

while(keepFighting)

% Player and Boss Stats
playerGPA = 4; % Player's health
bossHP = 30; % ShaylaOlivia health

% Game window size and sprites
row = 21;
column = 21;
sprite_sheet_contents = zeros(32, 32);
background = ones(row, column);

% Load Game Engine
my_scene = ModifiedSimpleGameEngine('ModifiedRetro_pack.png', 16, 16, 4);

% Placeholder Sprites
robotSprite = 32*30 + 7; % Sprite for lightnings
playerSprite = 32*4 + 27; % Sprite for the player
fullHeartSprite = 32*23-5;
emptyHeartSprite = 32*23-7;

background = ones(row,column);
borderSprite = 32*27 +24 ;

background(1:10) = borderSprite;
background(1:10, 21) = borderSprite;
background(1, 1:21) = borderSprite;
background(10, 1:21) = borderSprite;


Shaylasprite = 31*32 + 8;
Oliviasprite = 31*32 + 7;

background(4, 10) = Shaylasprite;
background(4, 12) = Oliviasprite;
drawScene(my_scene, background);

%play sound
sound(y,Hz)


 text1 = text(200, 1100, "Shayla Frederick and Olivia Briganti Stand Before You", "FontSize", 20, "Color", [1, 1, 1]);
 pause(3);
 delete(text1)

text1 = text(300, 900, "FIGHT!!!!!!!", "FontSize", 20, "Color", [1, 1, 1]);
pause(2); % Pause to emphasize the battle start
delete(text1); % Remove the text

 gpa = text(25, 1310, "Player GPA:", "FontSize", 20, "Color", [1, 1, 1]);
ShaylaOlivia = text(10, 1250, "Shayla/Olivia Health:", "FontSize", 20, "Color", [1, 1, 1]);

background(21,5) = fullHeartSprite;
background(21,6) = fullHeartSprite;
background(21,7) = fullHeartSprite;
background(21,8) = fullHeartSprite;
background(20,9) = fullHeartSprite;
background(20,7) = fullHeartSprite;
background(20,8) = fullHeartSprite;

drawScene(my_scene, background); % Render the game window with the current background

 %set up robot attacks
 robots = background;

% Player position
playerPos = [7, 11]; % Starting position of the player

option = 1;


% Fight Loop
while playerGPA > 0 && bossHP > 0
    
    background = ones(row,column);
    robots = background;
    text1 = text(300, 1100, "Shayla and Olivia create robots to attack you!", "FontSize", 20, "Color", [1, 1, 1]);
    attackTimer = 105;
    
    invincibility = 0;

    pause(3)
    
    robotTimer = 0;
    robotsSpawned = false;


    while attackTimer > 0 && playerGPA > 0 && bossHP > 0

        delete(text1);
        text1 = text(300, 1100, "Run away from the robots!", "FontSize", 20, "Color", [1, 1, 1]);

        background(1:10) = borderSprite;
        background(1:10, 21) = borderSprite;
        background(1, 1:21) = borderSprite;
        background(10, 1:21) = borderSprite;
        if bossHP == 30
            robotAnte = 1;
           background(20,9) = fullHeartSprite;
           background(20,8) = fullHeartSprite;
           background(20,7) = fullHeartSprite;
        elseif bossHP == 20
            robotAnte = 2;
           background(20,7) = fullHeartSprite;
           background(20,8) = fullHeartSprite;
           background(20,9) = emptyHeartSprite;
        elseif bossHP == 10
            robotAnte = 3;
           background(20,7) = fullHeartSprite;
           background(20,8) = emptyHeartSprite;
           background(20,9) = emptyHeartSprite;
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
        if robots(playerPos(1), playerPos(2)) == robotSprite
            if invincibility == 0
                playerGPA = playerGPA - 1;
                invincibility = 10;
            end
        end
         
        

        %Robots attack
        if robotTimer == 0
            if ~robotsSpawned
                robot1Y = randi(19)+1;
                robot1X = randi(8)+1;
                robots(robot1X,robot1Y) = robotSprite;
                if robotAnte == 2 || robotAnte == 3
                    robot2Y = randi(19)+1;
                    robot2X = randi(8)+1;
                    robots(robot2X,robot2Y) = robotSprite;
                end
                if robotAnte == 3
                    robot3Y = randi(19)+1;
                    robot3X = randi(8)+1;
                    robots(robot3X,robot3Y) = robotSprite;
                end
                robotsSpawned = true;
                
            end
            
            robots(robot1X,robot1Y) = 1;

            if robot1Y < playerPos(2)
                robot1Y = robot1Y +1;
            elseif robot1Y > playerPos(2)
                robot1Y = robot1Y - 1;
            end

            if robot1X < playerPos(1)
                robot1X = robot1X +1;
            elseif robot1X > playerPos(1)
                robot1X = robot1X - 1;
            end

            if robotAnte == 2 || robotAnte == 3
                robots(robot2X,robot2Y) = 1;
            
                if robot2Y < playerPos(2)
                    robot2Y = robot2Y +1;
                elseif robot2Y > playerPos(2)
                    robot2Y = robot2Y - 1;
                end

                if robot2X < playerPos(1)
                    robot2X = robot2X +1;
                elseif robot2X > playerPos(1)
                    robot2X = robot2X - 1;
                end
            end


            if robotAnte == 3
                robots(robot3X,robot3Y) = 1;
                if robot3Y < playerPos(2)
                    robot3Y = robot3Y +1;
                elseif robot3Y > playerPos(2)
                    robot3Y = robot3Y - 1;
                end

                if robot3X < playerPos(1)
                    robot3X = robot3X +1;
                elseif robot3X > playerPos(1)
                    robot3X = robot3X - 1;
                end
            end

            

            if robotAnte == 2 || robotAnte == 3
                if robot1X == robot2X && robot1Y == robot2Y
                    robot2X = robot2X -1;
                end
            end
            if robotAnte == 3
                if robot1X == robot3X && robot1Y == robot3Y
                    robot3Y = robot3Y -1;
                end
                if robot2X == robot3X && robot2Y == robot3Y
                    robot3Y = robot3Y - 1;
                end
            end
           
            
            
            robots(robot1X,robot1Y) = robotSprite;
            if robotAnte == 2 || robotAnte == 3
                robots(robot2X,robot2Y) = robotSprite;
            end
            if robotAnte == 3
                robots(robot3X,robot3Y) = robotSprite;
            end
            
            

            if robotAnte == 1
               robotTimer = 10;
            elseif robotAnte == 2
                robotTimer = 7;
            else
                robotTimer = 4;
            end



        end
        
        robotTimer = robotTimer -1;

        %draw scene
        drawScene(my_scene, background, robots);


        % Update scene
        background = ones(row, column); % Reset background
        background(playerPos(1), playerPos(2)) = playerSprite;
        attackTimer = attackTimer - 1;
    end

    delete(text1);
    
    if (playerGPA > 0 && bossHP > 0)

        text1 = text(100, 900, "Your Turn! Answer a question to attack Shayla and Olivia.", "FontSize", 20, "Color", [1, 1, 1]);
        pause(2);
        delete(text1);

        
        %User's Turn: Answer Questions to Attack
        if (option == 1)

             
            
            text1 = text(50, 730, "True or False: There are plenty of research opportunities", "FontSize", 20, "Color", [1, 1, 1]);
            text5 = text(60, 800, "for industrial and systems engineers", "FontSize", 20, "Color", [1, 1, 1]);
            text2 = text(200, 870, "(Press the specific key for the correct answer)", "FontSize", 20, "Color", [1, 1, 1]);
            text3 = text(50, 1050, "A) True", "FontSize", 20, "Color", [1, 1, 1]);
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
            delete(text5);
            
        if strcmpi(answer, 'a')
            option = option + 1;
            text1 = text(200, 870, "Correct! You deal -1 Heart to Shayla and Olivia.", "FontSize", 20, "Color", [1, 1, 1]);
            bossHP = bossHP - 10;
            pause(2);
            delete(text1)
        else
            text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
            pause(2)
            delete(text1)
        end
        elseif option == 2
            text1 = text(190, 800, "Where can an industrial and systems engineer be employed?", "FontSize", 20, "Color", [1, 1, 1]);
            text2 = text(200, 870, "(Press the specific key for the correct answer)", "FontSize", 20, "Color", [1, 1, 1]);
            text3 = text(50, 1000, "A) Laboratory", "FontSize", 20, "Color", [1, 1, 1]);
            text4 = text(800, 1000, "B) Theme Parks", "FontSize", 20, "Color", [1, 1, 1]);
            text5 = text(50, 1100, "C) Manufacturing", "FontSize", 20, "Color", [1, 1, 1]);
            text6 = text(800, 1100, "D) All of the above", "FontSize", 20, "Color", [1, 1, 1]);

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
            option = option + 1;
            text1 = text(200, 870, "Correct! You deal -1 Heart to Shayla and Olivia.", "FontSize", 20, "Color", [1, 1, 1]);
            bossHP = bossHP - 10;
            pause(2);
            delete(text1)
        else
            text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
            pause(2)
            delete(text1)
        end
        elseif option == 3
            text1 = text(20, 800, "What is the average wage of an industrial and systems engineer per year in Ohio?", "FontSize", 18, "Color", [1, 1, 1]);
            text2 = text(200, 870, "(Press the specific key for the correct answer)", "FontSize", 20, "Color", [1, 1, 1]);
            text3 = text(50, 1000, "A) 40k", "FontSize", 20, "Color", [1, 1, 1]);
            text4 = text(800, 1000, "B) 60k", "FontSize", 20, "Color", [1, 1, 1]);
            text5 = text(50, 1100, "C) 80k", "FontSize", 20, "Color", [1, 1, 1]);
            text6 = text(800, 1100, "D) 100k", "FontSize", 20, "Color", [1, 1, 1]);

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
            
        if strcmpi(answer, 'c')
            text1 = text(200, 870, "Correct! You deal -1 Heart to Shayla & Olivia.", "FontSize", 20, "Color", [1, 1, 1]);
            bossHP = bossHP - 10;
            pause(2);
            delete(text1)
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
    delete(ShaylaOlivia);
    background(7, 10) = Shaylasprite;
    background(7, 12) = Oliviasprite;
    background(21,5) = emptyHeartSprite;
    background(21,6) = emptyHeartSprite;
    background(21,7) = emptyHeartSprite;
    background(21,8) = emptyHeartSprite;

     drawScene(my_scene, background);
       text1 = text(300, 900, "You lost the battle against Shayla and Olivia.", "FontSize", 20, "Color", [1, 1, 1]);
else
    clear sound
    delete(ShaylaOlivia);
    delete(gpa);
    background(7, 11) = playerSprite;
    drawScene(my_scene, background);
   text1 = text(300, 900, "You won the battle against Shayla and Olivia.", "FontSize", 20, "Color", [1, 1, 1]);

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
b="Shayla_Olivia";
c=4;
end