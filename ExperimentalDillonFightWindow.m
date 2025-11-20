function[a,b,c,isPlaying]=ExperimentalDillonFightWindow(c)

% Set the flag to indicate the game is active
playGame = true;

% Plays Dillon's fight music
[y,Hz]=audioread("DillonSong.mp3"); % Load the music file
clear sound % Clear any existing sound
sound(y,Hz) % Play the loaded music

% Main game loop
while (playGame == true)

    % Load Battle Window
    fprintf('Loading Battle Window...\n'); % Notify user of game initialization

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
    parrisSprite = 31*32 + 9; % Boss sprite
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
    text1 = text(300, 900, "Dillon Mundo stands before you", "FontSize", 20, "Color", [1, 1, 1]);
    pause(3); % Pause to allow the player to read
    delete(text1); % Remove the text
    text1 = text(300, 900, "FIGHT!!!!!!!", "FontSize", 20, "Color", [1, 1, 1]);
    pause(2); % Pause to emphasize the battle start
    delete(text1); % Remove the text

    % Display and update player hearts on the screen
    heartText = text(30, 1310, "Player Hearts:", "FontSize", 15, "Color", [1, 1, 1]);
    background(21, 5) = heart1; % Player's first heart
    background(21, 6) = heart2; % Player's second heart
    background(21, 7) = heart3; % Player's third heart
    background(21, 8) = heart4; % Player's fourth heart

    % Display and update Dillon's hearts on the screen
    parrisHeartText = text(30, 1250, "Dillon's Hearts:", "FontSize", 15, "Color", [1, 1, 1]);
    background(20,5) = parrisHeart1; % Dillon's first heart
    background(20,6) = parrisHeart2; % Dillon's second heart
    background(20,7) = parrisHeart3; % Dillon's third heart

questionOption = 1;
% Fight Loop
while playerGPA > 0 && bossHP > 0
    % Initialize X markers for the wind attack
fire = background; % Copy the background to the xMarkers grid
fire(5, 6:8) = fireSprite; % Place X markers in specific rows and columns
fire(5, 12:14) = fireSprite; % Add more X markers in the grid

    % Dillon's Fire Flair loop
    attackTimer = 10; % Duration of the attack (number of iterations)
    while attackTimer > 0 && playerGPA > 0 && bossHP > 0 % Continue while attack is active, player has health, and boss is alive
    
        % Update player hearts on the screen
        background(21, 5) = heart1;
        background(21, 6) = heart2;
        background(21, 7) = heart3;
        background(21, 8) = heart4;
    
        % Update Dillon's hearts on the screen
        background(20, 5) = parrisHeart1;
        background(20, 6) = parrisHeart2;
        background(20, 7) = parrisHeart3;
    
        % Redraw Dillon's sprite in its original position
        background(4, 10) = parrisSprite;
    
        % Render the updated game scene with fire
        drawScene(my_scene, background, fire);
    
        % Move player with keyboard input
        key = getKeyboardInput(my_scene); % Capture player input
        if ~isempty(key) % Check if a key was pressed
            switch key
                case 'w', playerPos(1) = max(playerPos(1) - 1, 1); % Move up, ensuring within bounds
                case 's', playerPos(1) = min(playerPos(1) + 1, row); % Move down, ensuring within bounds
                case 'a', playerPos(2) = max(playerPos(2) - 1, 1); % Move left, ensuring within bounds
                case 'd', playerPos(2) = min(playerPos(2) + 1, column); % Move right, ensuring within bounds
            end
        end
    
        % Prevent player from moving outside the game border
        if (playerPos(1) == 1) % Top border
            playerPos(1) = 2;
        end
        if (playerPos(1) == 10) % Bottom border
            playerPos(1) = 9;
        end
        if (playerPos(2) == 1) % Left border
            playerPos(2) = 2;
        end
        if (playerPos(2) == 21) % Right border
            playerPos(2) = 20;
        end
    
        % Check for collisions with X markers (damage zones)
        if fire(playerPos(1), playerPos(2)) == fireSprite
            delete(text1); % Clear any previous text
    
            % Notify the player of a collision
            text1 = text(400, 1000, "You hit his fire! Losing 1 Heart", "FontSize", 20, "Color", [1, 1, 1]);
    
            % Reduce player's health
            playerGPA = playerGPA - 1;
    
            % Push player forward by 4 spaces to avoid lingering in the X zone
            playerPos = playerPos + [4, 0];
    
            % Update the player's hearts based on the remaining GPA
            if (playerGPA == 3)
                heart4 = emptyHeartSprite; % Remove the fourth heart
            elseif (playerGPA == 2)
                heart3 = emptyHeartSprite; % Remove the third heart
            elseif (playerGPA == 1)
                heart2 = emptyHeartSprite; % Remove the second heart
            elseif (playerGPA == 0)
                heart1 = emptyHeartSprite; % Remove the first heart
            end
        end
    
        % Update the scene for the next frame
        background = ones(row, column); % Reset the background grid
        background(playerPos(1), playerPos(2)) = playerSprite; % Update player's position on the grid
        attackTimer = attackTimer - 1; % Decrement the attack timer
    end

    % Reset text
    delete(text1);

    % Display new attack notification
    text1 = text(300, 1100, "Dillon uses Airplane Attack! Dodge the planes.", "FontSize", 20, "Color", [1, 1, 1]);
    
    % Initialize Airplane Attack parameters
    attackTimer = 80; % Duration of the attack (iterations)
    planeTimer = 0; % Timer for spawning planes
    planeX = 2; % Initial row for planes
    planeRandomY = randi(17)+2; % Random column range for plane paths
    invincibility = 10; % Invincibility period after a hit
    

    % Airplane attack loop
    while attackTimer > 0 && playerGPA > 0 && bossHP > 0 % Run while attack is active and game conditions are met
    
        % Display Dillon's sprite near the airplane
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
                fprintf('You got hit by a plane! Losing 1 Heart.\n');
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
    
    if (playerGPA > 0 && bossHP > 0)

        background(21, 5) = heart1;
        background(21, 6) = heart2;
        background(21, 7) = heart3;
        background(21, 8) = heart4;

        background(20,5) = parrisHeart1;
        background(20,6) = parrisHeart2;
        background(20,7) = parrisHeart3;

        text1 = text(300, 900, "Your Turn! Answer a question to attack Dillon.", "FontSize", 20, "Color", [1, 1, 1]);
        pause(2);
        delete(text1);

        if (questionOption == 1)

             % User's Turn: Answer Questions to Attack
            
            text1 = text(190, 800, "Q1. What was the original term for aerospace engineers?", "FontSize", 20, "Color", [1, 1, 1]);
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
                text1 = text(200, 870, "Correct! You deal -1 Heart to Dillon.", "FontSize", 20, "Color", [1, 1, 1]);
                bossHP = bossHP - 1;
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
            else
                text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
            end

        pause(2);
        delete(text1);
        elseif questionOption == 2
            text1 = text(190, 800, "Q2. Which design do aerospace engineers not work with?", "FontSize", 20, "Color", [1, 1, 1]);
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
            text1 = text(200, 870, "Correct! You deal -1 Heart to Dillon.", "FontSize", 20, "Color", [1, 1, 1]);
            bossHP = bossHP - 1;
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
        else
            text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
        end

        pause(2);
        delete(text1);
        elseif questionOption == 3
            text1 = text(190, 800, "Q3. Which is true about Aerospace Engineers?", "FontSize", 20, "Color", [1, 1, 1]);
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
            text1 = text(200, 870, "Correct! You deal -1 Heart to Dillon.", "FontSize", 20, "Color", [1, 1, 1]);
            bossHP = bossHP - 1;
            questionOption = questionOption+1;
            if (bossHP == 2.0)
                    dillonHeart3 = emptyHeartSprite;
                    background(1:10) = borderSprite;
                    background(1:10, 21) = borderSprite;
                    background(1, 1:21) = borderSprite;
                    background(10, 1:21) = borderSprite;

                    background(20,5) = dillonHeart1;
                    background(20,6) = dillonHeart2;
                    background(20,7) = dillonHeart3;

                    background(4, 10) = dillonSprite;

                    drawScene(my_scene, background);
            elseif (bossHP == 1.0)
                    dillonHeart2 = emptyHeartSprite;
                    background(1:10) = borderSprite;
                    background(1:10, 21) = borderSprite;
                    background(1, 1:21) = borderSprite;
                    background(10, 1:21) = borderSprite;

                    background(20,5) = dillonHeart1;
                    background(20,6) = dillonHeart2;
                    background(20,7) = dillonHeart3;

                    background(4, 10) = dillonSprite;
                    
                    drawScene(my_scene, background);
            end
            pause(2);
        else
            text1 = text(200, 870, "Incorrect! No damage dealt.", "FontSize", 20, "Color", [1, 1, 1]);
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
    background(4, 10) = parrisSprite;
    drawScene(my_scene, background);
    delete(heartText);
    delete(parrisHeartText);
    text1 = text(300, 870, "You lost the battle against Dillon Mundo.", "FontSize", 20, "Color", [1, 1, 1]);
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
    text1 = text(300, 870, "Victory! You defeated Dillon Mundo!", "FontSize", 20, "Color", [1, 1, 1]);
    pause(2);
    text2 = text(250, 920, "Would you like to play the entire game again?", "FontSize", 20, "Color", [1, 1, 1]);
    text4 = text(250, 970, "Or would you like to play against Dillon again?", "FontSize", 20, "Color", [1, 1, 1]);
    text3 = text(300, 1020, "(Enter 1 for entire game, 2 for Dillon, 3 to quit)", "FontSize", 20, "Color", [1, 1, 1]);


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