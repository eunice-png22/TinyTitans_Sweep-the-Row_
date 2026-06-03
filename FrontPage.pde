import gifAnimation.*;
import processing.sound.*;

Gif bg;
PImage titleImg, startBtnImg;

SoundFile music, duringGameMusic, selectSound;
SoundFile[] charSelectSounds = new SoundFile[5];

SoundFile youWonSound, youLoseSound, drawSound;

int gameState = 0;
float scaleH, scaleW;
int[][] boardState = new int[3][3]; 
int winner = 0;
int p1Score = 0;
int p2Score = 0;
boolean scoreUpdated = false;

boolean showSettings = false;
PImage settingsImg;

void setup() {
  size(800, 600);
  scaleW = (float)width / 800.0;
  scaleH = (float)height / 600.0;
  
  errorFont = createFont("PressStart2P.ttf", 14); 
  setupCharacterSelect();
  settingsImg = loadImage("gamesettings.png");
  
  music = new SoundFile(this, "INTRO SOUND.mp3");
  music.loop();
  
  // Initialize sound file
  duringGameMusic = new SoundFile(this, "DURING GAME.mp3");
  selectSound = new SoundFile(this, "SELECT SOUND.mp3");

  bg = new Gif(this, "front.gif");
  bg.loop();
  
  duringGameBgAi = loadImage("DuringgameBgAi.png");
  
  titleImg    = loadImage("title.png");
  startBtnImg = loadImage("presstostart.png");
  
  setupGameMode();
  setupCharacterSelect();
  setupPlayerVsAI();
  setupDuringGame();
  setupGameResult();
  setupSounds();
}

void setupSounds() {
  charSelectSounds[0] = new SoundFile(this, "SELECTING AGILA 1.mp3");
  charSelectSounds[1] = new SoundFile(this, "SELECTING MANOK.mp3");
  charSelectSounds[2] = new SoundFile(this, "SELECTING DAGA.mp3");
  charSelectSounds[3] = new SoundFile(this, "SELECTING CARABAO.mp3");
  charSelectSounds[4] = new SoundFile(this, "SELECTING IPIS.mp3");
  
  youWonSound = new SoundFile(this, "YOUWONSOUND.mp3");
  youLoseSound = new SoundFile(this, "YOULOSESOUND.mp3");
  drawSound = new SoundFile(this, "DRAWSOUND.mp3");  
}

void playCharacterSound(int index) {
  // stops all the sound when picking
  for (int i = 0; i < charSelectSounds.length; i++) {
    if (charSelectSounds[i] != null && charSelectSounds[i].isPlaying()) {
      charSelectSounds[i].stop();
    }
  }
  
  // Loops the character sound 
  if (charSelectSounds[index] != null) {
    charSelectSounds[index].loop(); 
  }
}

void draw() {
  // 1. Audio Management
  if (gameState == 0 || gameState == 1) {
    if (!music.isPlaying()) music.loop();
  } else if (gameState != 2) { 
    // I-stop ang music kung hindi tayo sa start screen/mode screen at hindi rin sa char select
    if (music.isPlaying()) music.stop();
  }

  if (gameState == 3 || gameState == 5) {
    if (!duringGameMusic.isPlaying()) {
      stopAllCharacterSounds();
      duringGameMusic.loop();
    }
  } else {
    if (duringGameMusic.isPlaying()) duringGameMusic.stop();
  }

  // 2. Screen Drawing Switch
  switch(gameState) {
    case 0:
      drawStartScreen();
      break;
    case 1:
      drawGameModeScreen();
      break;
    case 2:
      drawCharacterSelectScreen();
      break;
    case 3:
      drawDuringGameScreen();
      if (winner != 0) drawGameResultScreen();
      break;
    case 4:
      drawPlayerVsAIScreen();
      break;
    case 5:
      drawDuringGameAIScreen();
      if (winner != 0) drawGameResultScreen();
      break;
  }
  
  // 3. INVISIBLE SETTINGS UPPER LEFT
  if (gameState == 3 || gameState == 5) {
    if (showSettings) {
      fill(0, 0, 0, 150);
      rect(0, 0, width, height);
      
      if (settingsImg != null) {
        imageMode(CENTER);
        image(settingsImg, width/2, height/2);
        imageMode(CORNER);
      }
    }
  }
} 

void drawStartScreen() {
  image(bg, 0, 0, width, height);
  image(titleImg,    100, 150, 600, 300);
  image(startBtnImg, 250, 430, 300, 100);
}


void playSelectSound() {
  if (selectSound.isPlaying()) selectSound.stop();
  selectSound.play();
}

void mousePressed() {
  // 1. Check is clickable settings button for a toggle
  if ((gameState == 3 || gameState == 5) && 
      mouseX >= 30 && mouseX <= 80 && mouseY >= 30 && mouseY <= 80) {
    playSelectSound();
    showSettings = !showSettings;
    return;
  }

  // 2. Handles the settings menu 
  if (showSettings) {
    // Buttons: CONTINUE (x ≈ 400, y ≈ 250), RESTART (x ≈ 400, y ≈ 320), QUIT (x ≈ 400, y ≈ 390)
    if (mouseX >= 325 && mouseX <= 475 && mouseY >= 225 && mouseY <= 415) {
      if (mouseY >= 225 && mouseY <= 275) {
        showSettings = false; // Continue
      } else if (mouseY >= 295 && mouseY <= 345) {
        p1Score = 0; // Restart
        p2Score = 0; 
        for (int r = 0; r < 3; r++) {
          for (int c = 0; c < 3; c++) {
            boardState[r][c] = 0;
          }
        }
        winner = 0;
        turn = 1;
        scoreUpdated = false;
        showSettings = false;
      } else if (mouseY >= 365 && mouseY <= 415) {
        System.exit(0);
      }
      playSelectSound(); 
    }
    return;
  }

  // 3. Original game logic (if setting is closed)
  if (gameState == 0) {
    if (mouseX > 250 && mouseX < 550 && mouseY > 430 && mouseY < 530) {
      playSelectSound(); // Feedback to Start Screen
      gameState = 1;
    }
  } 
  else if (gameState == 1) {
    mousePressedGameMode();
  } 
  else if (gameState == 2) {
    playSelectSound(); // Feedback for Character Select 
    mousePressedCharacterSelect();
  } 
  else if (gameState == 4) {
    playSelectSound(); // Feedback for Player vs AI menu
    mousePressedPlayerVsAI();
  } 
  else if (gameState == 5 || gameState == 3) {
    if (winner != 0) {
      playSelectSound(); // Feedback for Game Result buttons
      mousePressedGameResult();
    } else {
      if (gameState == 5) {
        playSelectSound(); // Feedback for grid click (AI Mode) 
        mousePressedDuringGameAI();
      } else {
        mousePressedDuringGame(); // Feedback for grid click (PvP Mode) 
      }
    }
  }
}

void mousePressedDuringGame() {
  if (gameState != 3) return;
  
  float cellSize = 120;
  float boardLeft = boardX - 225 + 48; 
  float boardTop  = boardY - 225 + 30;

  for (int r = 0; r < 3; r++) {
    for (int c = 0; c < 3; c++) {
      float x = boardLeft + (c * cellSize) + (cellSize / 2);
      float y = boardTop  + (r * cellSize) + (cellSize / 2);
      
      // Checking if mouse click is inside the cell 
      if (dist(mouseX, mouseY, x, y) < cellSize / 2 && boardState[r][c] == 0) {
        
        // Restart sound of the gamebg 
        playSelectSound();
        
        boardState[r][c] = turn;
        turn = (turn == 1) ? 2 : 1;
        winner = checkWinner();
        
        println("Cell clicked: " + r + "," + c + ". Next turn: " + turn);
        
        // Return so that loop will top after move
        return; 
      }
    }
  }
}

void transitionToGameState(int newState) {
  music.stop();
  duringGameMusic.stop();

  // 2. Stops all the character sound before new game state
  for (int i = 0; i < charSelectSounds.length; i++) {
    if (charSelectSounds[i] != null) {
      charSelectSounds[i].stop(); 
    }
  }

  // 3. Reset new state 
  gameState = newState;

  // 4. Triggers the correct sound for it
  if (gameState == 3 || gameState == 5) {
    duringGameMusic.loop();
  } else if (gameState == 0 || gameState == 1) {
    music.loop();
  }
}

void stopAllCharacterSounds() {
  for (int i = 0; i < charSelectSounds.length; i++) {
    if (charSelectSounds[i] != null && charSelectSounds[i].isPlaying()) {
      charSelectSounds[i].stop();
    }
  }
}
