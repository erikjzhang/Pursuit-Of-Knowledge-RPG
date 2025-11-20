function [] = tutorialFightWindow(~)
keepFighting = true;

[y,Hz]=audioread("tutorialSong.mp3");
clear sound
sound(y,Hz)

while(keepFighting)

% Player and Boss Stats
playerGPA = 4; % Player's health
bossHP = 10; % C- health

% Game window size and sprites
row = 21;
column = 21;
sprite_sheet_contents = zeros(32, 32);
background = ones(row, column);

% Load Game Engine
my_scene = ModifiedSimpleGameEngine('ModifiedRetro_pack.png', 16, 16, 4);

% Placeholder Sprites
bossSprite = 0;  % Placeholder for Dillon's sprite
pellotSprite = 32*30 + 11; % Sprite for planes
playerSprite = 32*4 + 27; % Sprite for the player
fullHeartSprite = 32*23-5;
emptyHeartSprite = 32*23-7;

background = ones(row,column);
borderSprite = 32*27 +24 ;

background(1:10) = borderSprite;
background(1:10, 21) = borderSprite;
background(1, 1:21) = borderSprite;
background(10, 1:21) = borderSprite;

drawScene(my_scene, background);

CSprite = 31*32 + 11;

background(4, 11) = CSprite;
drawScene(my_scene, background);


 text1 = text(300, 1100, "Oh No! You've Encountered a Bad Grade!", "FontSize", 20, "Color", [1, 1, 1]);
 pause(3);
 delete(text1)

background(21,5) = fullHeartSprite;
background(21,6) = fullHeartSprite;
background(21,7) = fullHeartSprite;
background(21,8) = fullHeartSprite;
background(20,8) = fullHeartSprite;

 gpa = text(25, 1310, "Player GPA", "FontSize", 20, "Color", [1, 1, 1]);
  badGrade = text(25, 1250, "Bad Grade Health", "FontSize", 20, "Color", [1, 1, 1]);

% Airplane Attack Setup
pellot = background; % Set up pellot for attack

% Player position
playerPos = [7, 11]; % Starting position of the player


% Fight Loop
while playerGPA > 0 && bossHP > 0

    text1 = text(300, 1100, "C- uses Bad Grade! Dodge the pellot!", "FontSize", 20, "Color", [1, 1, 1]);
    attackTimer = 105;
    pellotTimer = 0;
    pellotX = randi(6)+2;
    pellotY = 2;
    invincibility = 0;


    while attackTimer > 0 && playerGPA > 0 && bossHP > 0

        pellot = background; % Reset pellot positions
        pellot(pellotX,pellotY) = pellotSprite;
        background(1:10) = borderSprite;
        background(1:10, 21) = borderSprite;
        background(1, 1:21) = borderSprite;
        background(10, 1:21) = borderSprite;
        background(20,8) = fullHeartSprite;
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
        
        

        drawScene(my_scene, background, pellot);

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

        % Check for collisions with pellots
        if pellot(playerPos(1), playerPos(2)) == pellotSprite
            if invincibility == 0
                playerGPA = playerGPA - 1;
                invincibility = 10;
            end
         
        end


        if (pellotTimer == 0)
            pellotY= pellotY+1;
            pellot(pellotY, 2:20) = pellotSprite; % Randomly generate pellot
            pellotTimer = 5;
        else
            pellotTimer = pellotTimer-1;
        end

        

        

        % Update scene
        background = ones(row, column); % Reset background
        background(playerPos(1), playerPos(2)) = playerSprite;
        attackTimer = attackTimer - 1;
    end

    delete(text1);
    
    if (playerGPA > 0 && bossHP > 0)

        text1 = text(100, 900, "Your Turn! Answer a question to attack the bad grade.", "FontSize", 20, "Color", [1, 1, 1]);
        pause(2);
        delete(text1);

        option = randi(3);
        %User's Turn: Answer Questions to Attack
        if (option == 1)

             
            
            text1 = text(190, 800, "What letter am I?", "FontSize", 20, "Color", [1, 1, 1]);
            text2 = text(200, 870, "(Press the specific key for the correct answer)", "FontSize", 20, "Color", [1, 1, 1]);
            text3 = text(50, 1000, "A) D", "FontSize", 20, "Color", [1, 1, 1]);
            text4 = text(800, 1000, "B) C", "FontSize", 20, "Color", [1, 1, 1]);
            text5 = text(50, 1100, "C) A", "FontSize", 20, "Color", [1, 1, 1]);
            text6 = text(800, 1100, "D) B", "FontSize", 20, "Color", [1, 1, 1]);

            answered = false;
            while(~answered)
                key = getKeyboardInput(my_scene);
                if (~isempty(key))
                    answered = true;
                    switch key
                        case 'a', answer = 'a';
                        case 'b', answer = 'B';
                        case 'c', answer = 'c';
                        case 'd', answer = 'd';
                        otherwise, answered = false;
                    end
                end

            end
            delete(text1);
            delete(text2);
            delete(text3);
            delete(text4);
            delete(text5);
            delete(text6);
            
        if strcmpi(answer, 'B')
            text1 = text(200, 870, "Correct! You deal 10 damage to C-.", "FontSize", 20, "Color", [1, 1, 1]);
            bossHP = bossHP - 10;
            pause(2);
            delete(text1)
        else
            text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
            pause(2)
            delete(text1)
        end
        elseif option == 2
            text1 = text(190, 800, "What color am I?", "FontSize", 20, "Color", [1, 1, 1]);
            text2 = text(200, 870, "(Press the specific key for the correct answer)", "FontSize", 20, "Color", [1, 1, 1]);
            text3 = text(50, 1000, "A) Red", "FontSize", 20, "Color", [1, 1, 1]);
            text4 = text(800, 1000, "B) Blue", "FontSize", 20, "Color", [1, 1, 1]);
            text5 = text(50, 1100, "C) Green", "FontSize", 20, "Color", [1, 1, 1]);
            text6 = text(800, 1100, "D) Yellow", "FontSize", 20, "Color", [1, 1, 1]);

            answered = false;
            while(~answered)
                key = getKeyboardInput(my_scene);
                if (~isempty(key))
                    answered = true;
                    switch key
                        case 'a', answer = 'a';
                        case 'b', answer = 'b';
                        case 'c', answer = 'c';
                        case 'd', answer = 'd';
                        otherwise, answered = false;
                    end
                end

            end
            delete(text1);
            delete(text2);
            delete(text3);
            delete(text4);
            delete(text5);
            delete(text6);
            
        if strcmpi(answer, 'a')
            text1 = text(200, 870, "Correct! You deal 10 damage to C-.", "FontSize", 20, "Color", [1, 1, 1]);
            bossHP = bossHP - 10;
            pause(2);
            delete(text1)
        else
            text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
            pause(2)
            delete(text1)
        end
        elseif option == 3
            text1 = text(190, 800, "What class is this?", "FontSize", 20, "Color", [1, 1, 1]);
            text2 = text(200, 870, "(Press the specific key for the correct answer)", "FontSize", 20, "Color", [1, 1, 1]);
            text3 = text(50, 1000, "A) Calculus", "FontSize", 20, "Color", [1, 1, 1]);
            text4 = text(800, 1000, "B) Physics", "FontSize", 20, "Color", [1, 1, 1]);
            text5 = text(50, 1100, "C) Medical Science", "FontSize", 20, "Color", [1, 1, 1]);
            text6 = text(800, 1100, "D) Engineering", "FontSize", 20, "Color", [1, 1, 1]);

            answered = false;
            while(~answered)
                key = getKeyboardInput(my_scene);
                if (~isempty(key))
                    answered = true;
                    switch key
                        case 'a', answer = 'a';
                        case 'b', answer = 'B';
                        case 'c', answer = 'c';
                        case 'd', answer = 'd';
                        otherwise, answered = false;
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
            text1 = text(200, 870, "Correct! You deal 10 damage to C-.", "FontSize", 20, "Color", [1, 1, 1]);
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
    delete(badGrade);
    background(21,5) = emptyHeartSprite;
    background(21,6) = emptyHeartSprite;
    background(21,7) = emptyHeartSprite;
    background(21,8) = emptyHeartSprite;
    background(7, 11) = CSprite;
     drawScene(my_scene, background);
       text1 = text(300, 900, "You lost the battle against the bad grade.", "FontSize", 20, "Color", [1, 1, 1]);
else
    delete(badGrade);
    delete(gpa);
    background(7, 11) = playerSprite;
     drawScene(my_scene, background);
   text1 = text(300, 900, "You won the battle against the bad grade.", "FontSize", 20, "Color", [1, 1, 1]);

end
pause(3)

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
end