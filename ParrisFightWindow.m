function[a,b,c,isPlaying]=ParrisFightWindow(c)

% Set the flag to indicate the game is active
playGame = true;

% Plays Dillon's fight music
[y,Hz]=audioread("ParrisSong.mp3"); % Load the music file
clear sound % Clear any existing sound
sound(y,Hz) % Play the loaded music

% Main game loop
while (playGame == true)

    % Player and Boss Stats
    playerGPA = 4.0; % Player's initial health (GPA represents health points)
    bossHP = 3.0; % Dillon's initial health points

    % Game window size and sprite initialization
    row = 21; % Number of rows in the game grid
    column = 21; % Number of columns in the game grid
    sprite_sheet_contents = zeros(32, 32); % Placeholder for sprite sheet contents
    background = ones(row, column); % Initialize the background grid with "1" (default tiles)

    % Sprites for full and empty hearts (health indicators)
    fullHeartSprite = 32*23-5; % Sprite for full heart
    emptyHeartSprite = 32*23-7; % Sprite for empty heart

    % Load Game Engine with specified sprite sheet and settings
    my_scene = ModifiedSimpleGameEngine('ModifiedRetro_pack.png', 16, 16, 4);
    

    % Define placeholder sprites for various game elements
    fireSprite = 32*10 + 16; % Sprite for fire
    lightningSprite = 32*31 + 3; % Sprite for lightnings
    robotSprite = 32*30 + 7; % Sprite for robots
    warningLightningSprite = 32*31 + 1; % Sprite for warning lightning sprite
    planeSprite = 32*30 + 9; % Sprite for planes
    playerSprite = 32*4 + 27; % Sprite for the player character

    % Initialize the game background
    background = ones(row,column); % Reset background grid
    borderSprite = 32*27 +24; % Sprite for border tiles

    % Set up the border of the game grid
    background(1:10) = borderSprite; % Left border
    background(1:10, 21) = borderSprite; % Right border
    background(1, 1:21) = borderSprite; % Top border
    background(10, 1:21) = borderSprite; % Bottom border

    % Set up the boss (Dillon) sprite
    parrisSprite = 31*32 + 6; % Boss sprite
    background(4, 10) = parrisSprite; % Place Dillon at a specific position

    % Airplane Attack Setup
    planes = background; % Initialize the attack grid for planes (currently identical to background)

    % Player's initial position
    playerPos = [7, 11]; % Starting position of the player

    % Initialize health indicators for the player and boss
    heart1 = fullHeartSprite; % Player's heart 1
    heart2 = fullHeartSprite; % Player's heart 2
    heart3 = fullHeartSprite; % Player's heart 3
    heart4 = fullHeartSprite; % Player's heart 4

    parrisHeart1 = fullHeartSprite; % Dillon's heart 1
    parrisHeart2 = fullHeartSprite; % Dillon's heart 2
    parrisHeart3 = fullHeartSprite; % Dillon's heart 3

    % Draw the initial game scene
    drawScene(my_scene, background); % Render the game window with the current background

    % Display introductory text
    text1 = text(300, 900, "Final Boss Fight: Dr. Parris", "FontSize", 20, "Color", [1, 1, 1]);
    pause(3); % Pause to allow the player to read
    delete(text1); % Remove the text
    text1 = text(300, 900, "FIGHT!!!!!!!", "FontSize", 20, "Color", [1, 1, 1]);
    pause(2); % Pause to emphasize the battle start
    delete(text1); % Remove the text

    % Display and update player hearts on the screen
    heartText = text(40, 1310, "Player GPA:", "FontSize", 15, "Color", [1, 1, 1]);
    background(21, 5) = heart1; % Player's first heart
    background(21, 6) = heart2; % Player's second heart
    background(21, 7) = heart3; % Player's third heart
    background(21, 8) = heart4; % Player's fourth heart

    % Display and update Dillon's hearts on the screen
    parrisHeartText = text(15, 1250, "Dr. Parris' Hearts:", "FontSize", 15, "Color", [1, 1, 1]);
    background(20,5) = parrisHeart1; % Parris' first heart
    background(20,6) = parrisHeart2; % Parris' second heart
    background(20,7) = parrisHeart3; % Parris' third heart

questionOption = 1;
lightningAnte = 1;

% First Fight Loop
while playerGPA > 0 && bossHP > 0
    % Reset text
    delete(text1);

    % Display new attack notification
    text1 = text(300, 1100, "Dr. Parris uses Airplane Attack! Dodge the planes.", "FontSize", 20, "Color", [1, 1, 1]);
    
    % Initialize Airplane Attack parameters
    attackTimer = 80; % Duration of the attack (iterations)
    planeTimer = 0; % Timer for spawning planes
    planeX = 2; % Initial row for planes
    planeRandomY = randi(17)+2; % Random column range for plane paths
    invincibility = 10; % Invincibility period after a hit
    
    playerPos(1) = 9;

    % Airplane attack loop
    while attackTimer > 0 && playerGPA > 0 && bossHP > 0 % Run while attack is active and game conditions are met
    
        
        % Display Parris' sprite near the airplane
        background(2, planeRandomY+1) = parrisSprite;
    
        % Reset and update planes
        planes(:, :) = background; % Reset plane positions
        planes(planeX, 2:planeRandomY) = planeSprite; % Add planes on the left side of the column
        planes(planeX, planeRandomY+2:20) = planeSprite; % Add planes on the right side of the column
    
        % Draw borders
        background(1:10) = borderSprite;
        background(1:10, 21) = borderSprite;
        background(1, 1:21) = borderSprite;
        background(10, 1:21) = borderSprite;
    
        % Display player and boss hearts
        background(21, 5) = heart1;
        background(21, 6) = heart2;
        background(21, 7) = heart3;
        background(21, 8) = heart4;
    
        background(20, 5) = parrisHeart1;
        background(20, 6) = parrisHeart2;
        background(20, 7) = parrisHeart3;
    
        % Render the updated game scene with planes
        drawScene(my_scene, background, planes);
    
        % Move player based on keyboard input
        key = getKeyboardInput(my_scene); % Capture key press
        if ~isempty(key) % Check if a key is pressed
            switch key
                case 'w', playerPos(1) = max(playerPos(1) - 1, 1); % Move up within bounds
                case 's', playerPos(1) = min(playerPos(1) + 1, row); % Move down within bounds
                case 'a', playerPos(2) = max(playerPos(2) - 1, 1); % Move left within bounds
                case 'd', playerPos(2) = min(playerPos(2) + 1, column); % Move right within bounds
            end
        end
    
        % Prevent player from crossing borders
        if (playerPos(1) == 1), playerPos(1) = 2; end % Top border
        if (playerPos(1) == 10), playerPos(1) = 9; end % Bottom border
        if (playerPos(2) == 1), playerPos(2) = 2; end % Left border
        if (playerPos(2) == 21), playerPos(2) = 20; end % Right border
    
        % Decrement invincibility timer
        if invincibility ~= 0
            invincibility = invincibility - 1;
        end
    
        % Check for collisions with planes
        if planes(playerPos(1), playerPos(2)) == planeSprite
            if invincibility == 0 % Only process collision if invincibility is off
                playerGPA = playerGPA - 1; % Decrease GPA (health)
    
                % Update player's hearts based on remaining GPA
                if (playerGPA == 3.0)
                    heart4 = emptyHeartSprite;
                elseif (playerGPA == 2.0)
                    heart3 = emptyHeartSprite;
                elseif (playerGPA == 1.0)
                    heart2 = emptyHeartSprite;
                elseif (playerGPA == 0.0)
                    heart1 = emptyHeartSprite;
                end
    
                % Reset invincibility timer after getting hit
                invincibility = 10;
            end
        end
    
        % Reset planes and randomize their positions after reaching the bottom
        if (planeX == 9)
            planeX = 2; % Reset row position
            planeRandomY = randi(17)+2; % Randomize column range
        end
    
        % Manage plane movement rate based on question difficulty
        if (questionOption == 1) % Easy difficulty
            if (planeTimer == 0)
                planeX = planeX + 1;
                planes(planeX+1, 2:20) = planeSprite; % Generate planes
                planeTimer = 5; % Slow movement rate
            else
                planeTimer = planeTimer - 1;
            end
        elseif (questionOption == 2) % Medium difficulty
            if (planeTimer == 0)
                planeX = planeX + 1;
                planes(planeX+1, 2:20) = planeSprite; % Generate planes
                planeTimer = 3; % Moderate movement rate
            else
                planeTimer = planeTimer - 1;
            end
        elseif (questionOption == 3) % Hard difficulty
            if (planeTimer == 0)
                planeX = planeX + 1;
                planes(planeX+1, 2:20) = planeSprite; % Generate planes
                planeTimer = 2; % Fast movement rate
            else
                planeTimer = planeTimer - 1;
            end
        end
    
        % Reset background and update player's position
        background = ones(row, column); % Reset background
        background(playerPos(1), playerPos(2)) = playerSprite; % Update player sprite position
    
        % Decrease attack timer for each iteration
        attackTimer = attackTimer - 1;
    end

    % Clear out the displayed text
    delete(text1);

    background = ones(row,column);
    lightning = background;
    text1 = text(300, 1100, "Dr. Parris throws a lightning attack at you!", "FontSize", 20, "Color", [1, 1, 1]);
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
        
        background(21, 5) = heart1;
        background(21, 6) = heart2;
        background(21, 7) = heart3;
        background(21, 8) = heart4;

        background(20,5) = parrisHeart1;
        background(20,6) = parrisHeart2;
        background(20,7) = parrisHeart3;


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

            % Update player's hearts based on remaining GPA
                if (playerGPA == 3.0)
                    heart4 = emptyHeartSprite;
                elseif (playerGPA == 2.0)
                    heart3 = emptyHeartSprite;
                elseif (playerGPA == 1.0)
                    heart2 = emptyHeartSprite;
                elseif (playerGPA == 0.0)
                    heart1 = emptyHeartSprite;
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
                lightningOneTimer = 11;
            elseif lightningAnte == 2
                lightningOneTimer = 9;
            elseif lightningAnte == 3
                lightningOneTimer = 7;
            end
            lightningTurn = 2;
        end
        
        if lightningOneTimer > 0
            if lightningOneTimer == 1
                lightning(2:9,lightningOneRow) = lightningSprite;
                lightningOneEnd = 4;
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
                lightningTwoTimer = 11;
            elseif lightningAnte == 2
                lightningTwoTimer = 9;
            elseif lightningAnte == 3
                lightningTwoTimer = 7;
            end
            lightningTurn = 2;
        end

        if lightningTwoTimer > 0
            if lightningTwoTimer == 1
                lightning(2:9,lightningTwoRow) = lightningSprite;
                lightningTwoEnd = 4;
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

    background = ones(row,column);
    robots = background;
    text1 = text(300, 1100, "Dr.Parris creates robots to attack you!", "FontSize", 20, "Color", [1, 1, 1]);
    attackTimer = 105;
    
    invincibility = 0;

    pause(3)
    
    robotTimer = 0;
    robotsSpawned = false;


    while attackTimer > 0 && playerGPA > 0 && bossHP > 0

        delete(text1);
        
        text1 = text(300, 1100, "Run away from the robots!", "FontSize", 20, "Color", [1, 1, 1]);

        background(21, 5) = heart1;
        background(21, 6) = heart2;
        background(21, 7) = heart3;
        background(21, 8) = heart4;

        background(20,5) = parrisHeart1;
        background(20,6) = parrisHeart2;
        background(20,7) = parrisHeart3;

        background(1:10) = borderSprite;
        background(1:10, 21) = borderSprite;
        background(1, 1:21) = borderSprite;
        background(10, 1:21) = borderSprite;
        if questionOption == 1
            robotAnte = 1;
        elseif questionOption == 2
            robotAnte = 2;
        elseif questionOption == 3
            robotAnte = 3;
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

        % Check for collisions with robots
        if robots(playerPos(1), playerPos(2)) == robotSprite
            if invincibility == 0
                playerGPA = playerGPA - 1;
                invincibility = 10;
            end

            % Update player's hearts based on remaining GPA
                if (playerGPA == 3.0)
                    heart4 = emptyHeartSprite;
                elseif (playerGPA == 2.0)
                    heart3 = emptyHeartSprite;
                elseif (playerGPA == 1.0)
                    heart2 = emptyHeartSprite;
                elseif (playerGPA == 0.0)
                    heart1 = emptyHeartSprite;
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

        background(21, 5) = heart1;
        background(21, 6) = heart2;
        background(21, 7) = heart3;
        background(21, 8) = heart4;

        background(20,5) = parrisHeart1;
        background(20,6) = parrisHeart2;
        background(20,7) = parrisHeart3;

        text1 = text(60, 900, "Your Turn! Answer 3 consecutive questions to attack Dr. Parris.", "FontSize", 20, "Color", [1, 1, 1]);
        pause(3);
        delete(text1);

        if (questionOption == 1)

             % User's Turn: Answer Questions to Attack
            
            text1 = text(190, 800, "What was the original term for aerospace engineers?", "FontSize", 20, "Color", [1, 1, 1]);
            text2 = text(200, 870, "(Press the specific key for the correct answer)", "FontSize", 20, "Color", [1, 1, 1]);
            text3 = text(50, 1000, "A) Meteorological engineering", "FontSize", 20, "Color", [1, 1, 1]);
            text4 = text(800, 1000, "B) Aeronautical engineering", "FontSize", 20, "Color", [1, 1, 1]);
            text5 = text(50, 1100, "C) Airplane engineering", "FontSize", 20, "Color", [1, 1, 1]);
            text6 = text(800, 1100, "D) Atmosphere engineering", "FontSize", 20, "Color", [1, 1, 1]);

            answered = false;
            while(answered == false)
                key = getKeyboardInput(my_scene);
                if ~isempty(key)
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



            if strcmpi(answer, 'B')
                text1 = text(200, 870, "Correct!", "FontSize", 20, "Color", [1, 1, 1]);
                pause(2);

                delete(text1);

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
                delete(text7);

                if strcmpi(answer, 'a')
                    answer = "";
                    text1 = text(200, 870, "Correct!", "FontSize", 20, "Color", [1, 1, 1]);
                    pause(2);
                    delete(text1);

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
                                case 'b', answer = 'b';
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
                        text1 = text(200, 870, "Correct! You deal -1 Heart to Dr. Parris", "FontSize", 20, "Color", [1, 1, 1]);
                        bossHP = bossHP - 1;
                        lightningAnte = lightningAnte + 1;
                        robotAnte = robotAnte+1;
                        questionOption = questionOption+1;

                        if (bossHP == 2.0)
                            parrisHeart3 = emptyHeartSprite;
                            background(1:10) = borderSprite;
                            background(1:10, 21) = borderSprite;
                            background(1, 1:21) = borderSprite;
                            background(10, 1:21) = borderSprite;
        
                            background(20,5) = parrisHeart1;
                            background(20,6) = parrisHeart2;
                            background(20,7) = parrisHeart3;
                            background(4, 10) = parrisSprite;
                            drawScene(my_scene, background);
                        elseif (bossHP == 1.0)
                            parrisHeart2 = emptyHeartSprite;
                            background(1:10) = borderSprite;
                            background(1:10, 21) = borderSprite;
                            background(1, 1:21) = borderSprite;
                            background(10, 1:21) = borderSprite;
        
                            background(20,5) = parrisHeart1;
                            background(20,6) = parrisHeart2;
                            background(20,7) = parrisHeart3;
                            background(4, 10) = parrisSprite;
                            drawScene(my_scene, background);
                        end
                        pause(2);
                        delete(text1)
                    else
                        text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
                        pause(2);
                        delete(text1);
                    end

                else
                    text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
                    pause(2);
                    delete(text1);
                end
                
            else
                text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
                pause(2);
                delete(text1);
            end

        pause(2);
        delete(text1);
        
        elseif (questionOption == 2)

             % User's Turn: Answer Questions to Attack
            
            text1 = text(190, 800, "Which design do aerospace engineers not work with?", "FontSize", 20, "Color", [1, 1, 1]);
            text2 = text(200, 870, "(Press the specific key for the correct answer)", "FontSize", 20, "Color", [1, 1, 1]);
            text3 = text(50, 1000, "A) Satelites", "FontSize", 20, "Color", [1, 1, 1]);
            text4 = text(800, 1000, "B) Missiles", "FontSize", 20, "Color", [1, 1, 1]);
            text5 = text(50, 1100, "C) Aircraft Carriers", "FontSize", 20, "Color", [1, 1, 1]);
            text6 = text(800, 1100, "D) Helicopters", "FontSize", 20, "Color", [1, 1, 1]);

            answered = false;
            while(answered == false)
                key = getKeyboardInput(my_scene);
                if ~isempty(key)
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
                answer = "";
                text1 = text(200, 870, "Correct!", "FontSize", 20, "Color", [1, 1, 1]);
                pause(2);

                delete(text1);

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
                    answer = "";
                    text1 = text(200, 870, "Correct!", "FontSize", 20, "Color", [1, 1, 1]);
                    pause(2);
                    delete(text1);

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
                        text1 = text(200, 870, "Correct! You deal -1 Heart to Dr. Parris", "FontSize", 20, "Color", [1, 1, 1]);
                        bossHP = bossHP - 1;
                        lightningAnte = lightningAnte + 1;
                        robotAnte = robotAnte+1;
                        questionOption = questionOption+1;

                        if (bossHP == 2.0)
                            parrisHeart3 = emptyHeartSprite;
                            background(1:10) = borderSprite;
                            background(1:10, 21) = borderSprite;
                            background(1, 1:21) = borderSprite;
                            background(10, 1:21) = borderSprite;
        
                            background(20,5) = parrisHeart1;
                            background(20,6) = parrisHeart2;
                            background(20,7) = parrisHeart3;
                            background(4, 10) = parrisSprite;
                            drawScene(my_scene, background);
                        elseif (bossHP == 1.0)
                            parrisHeart2 = emptyHeartSprite;
                            background(1:10) = borderSprite;
                            background(1:10, 21) = borderSprite;
                            background(1, 1:21) = borderSprite;
                            background(10, 1:21) = borderSprite;
        
                            background(20,5) = parrisHeart1;
                            background(20,6) = parrisHeart2;
                            background(20,7) = parrisHeart3;
                            background(4, 10) = parrisSprite;
                            drawScene(my_scene, background);
                        end
                        pause(2);
                        delete(text1)
                    else
                        text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
                        pause(2);
                        delete(text1);
                    end

                else
                    text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
                    pause(2);
                    delete(text1);
                end
                
            else
                text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
                pause(2);
                delete(text1);
            end

        pause(2);
        delete(text1);

        elseif (questionOption == 3)

             % User's Turn: Answer Questions to Attack
            
            text1 = text(190, 800, "Which is true about Aerospace Engineers?", "FontSize", 20, "Color", [1, 1, 1]);
            text2 = text(200, 870, "(Press the specific key for the correct answer)", "FontSize", 20, "Color", [1, 1, 1]);
            text3 = text(50, 1000, "A) They are in low demand", "FontSize", 20, "Color", [1, 1, 1]);
            text4 = text(600, 1000, "B) They don't work with electronics", "FontSize", 20, "Color", [1, 1, 1]);
            text5 = text(50, 1100, "C) They are a top earning", "FontSize", 20, "Color", [1, 1, 1]);
            text7 = text(50, 1150, "engineer", "FontSize", 20, "Color", [1, 1, 1]);
            text6 = text(600, 1100, "D) They don't need a bachelor's degree", "FontSize", 20, "Color", [1, 1, 1]);

            answered = false;
            while(answered == false)
                key = getKeyboardInput(my_scene);
                if ~isempty(key)
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
            delete(text7);



            if strcmpi(answer, 'c')
                answer = "";
                text1 = text(200, 870, "Correct!", "FontSize", 20, "Color", [1, 1, 1]);
                pause(2);

                delete(text1);

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
                            case 'b', answer = 'b';
                                answered=true;
                        end
                    end
                end
                delete(text1);
                delete(text2);
                delete(text3);
                delete(text4);
                delete(text5);
                delete(text6);

                if strcmpi(answer, 'b')
                    answer = "";
                    text1 = text(200, 870, "Correct!", "FontSize", 20, "Color", [1, 1, 1]);
                    pause(2);
                    delete(text1);

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
                        text1 = text(200, 870, "Correct! You deal -1 Heart to Dr. Parris", "FontSize", 20, "Color", [1, 1, 1]);
                        bossHP = bossHP - 1;
                        lightningAnte = lightningAnte + 1;
                        robotAnte = robotAnte+1;
                        questionOption = questionOption+1;

                        if (bossHP == 2.0)
                            parrisHeart3 = emptyHeartSprite;
                            background(1:10) = borderSprite;
                            background(1:10, 21) = borderSprite;
                            background(1, 1:21) = borderSprite;
                            background(10, 1:21) = borderSprite;
        
                            background(20,5) = parrisHeart1;
                            background(20,6) = parrisHeart2;
                            background(20,7) = parrisHeart3;
                            background(4, 10) = parrisSprite;
                            drawScene(my_scene, background);
                        elseif (bossHP == 1.0)
                            parrisHeart2 = emptyHeartSprite;
                            background(1:10) = borderSprite;
                            background(1:10, 21) = borderSprite;
                            background(1, 1:21) = borderSprite;
                            background(10, 1:21) = borderSprite;
        
                            background(20,5) = parrisHeart1;
                            background(20,6) = parrisHeart2;
                            background(20,7) = parrisHeart3;
                            background(4, 10) = parrisSprite;
                            drawScene(my_scene, background);
                        end
                        pause(2);
                        delete(text1)
                    else
                        text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
                        pause(2);
                        delete(text1);
                    end

                else
                    text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
                    pause(2);
                    delete(text1);
                end
                
            else
                text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
                pause(2);
                delete(text1);
            end

            pause(2);
            delete(text1);
        end
    end
    background = ones(row, column); % Reset background
    background(1:10) = borderSprite;
    background(1:10, 21) = borderSprite;
    background(1, 1:21) = borderSprite;
    background(10, 1:21) = borderSprite;
end



% End of Battle
if playerGPA <= 0
    background = ones(row, column); % Reset background
    background(4, 11) = parrisSprite;
    drawScene(my_scene, background);
    delete(heartText);
    delete(parrisHeartText);
    text1 = text(300, 870, "You lost the battle against Dr. Parris.", "FontSize", 20, "Color", [1, 1, 1]);
    pause(2);
    text2 = text(300, 920, "Would you like to play again?", "FontSize", 20, "Color", [1, 1, 1]);
    text3 = text(300, 970, "(Enter 1 for yes and 2 for no)", "FontSize", 20, "Color", [1, 1, 1]);


    var = false;
    while(var == false)
        key = getKeyboardInput(my_scene);
        if ~isempty(key)
            switch key
                case "1", keepPlaying = 1;
                    var = true;
                case "2", keepPlaying = 0;
                    var = true;
            end
        end
    end

    delete(text1);
    delete(text2);
    delete(text3);
else
    background = ones(row, column); % Reset background
    playerPos = [7, 11];
    background(playerPos(1), playerPos(2)) = playerSprite;
    delete(heartText);
    delete(parrisHeartText);
    drawScene(my_scene, background);
    text1 = text(300, 870, "Victory! You defeated Dr. Parris!", "FontSize", 20, "Color", [1, 1, 1]);
    pause(2);
    text2 = text(250, 920, "Would you like to play the entire game again?", "FontSize", 20, "Color", [1, 1, 1]);
    text4 = text(250, 970, "Or would you like to play against Dr. Parris again?", "FontSize", 20, "Color", [1, 1, 1]);
    text3 = text(300, 1020, "(Enter 1 for entire game, 2 for Dr. Parris, 3 to quit)", "FontSize", 20, "Color", [1, 1, 1]);


    var = false;
    while(var == false)
        key = getKeyboardInput(my_scene);
        if ~isempty(key)
            switch key
                case "1", isPlaying = 1;
                    var = true;
                    c = 0;
                    %plays overworld music
                    [y,Hz]=audioread('overworldSong.mp3');
                    clear sound
                    sound(y,Hz)

                    keepPlaying = 0;
                case "2", keepPlaying = 1;
                    var = true;

                case "3", isPlaying = 0;
                    keepPlaying = 0;
                    var = true;
                    c = 5;
            end
        end
    end
    delete(text1);
    delete(text2);
    delete(text3);
    delete(text4)
end

if (keepPlaying == 0)
    playGame = false;
end

close
end
a = "room1";
b = "1";
clear sound