PImage p1WonImg, p2WonImg, drawImg;
PImage aiWonImg, aiLoseImg;

void setupGameResult() {
  p1WonImg = loadImage("PLR1won.png");
  p2WonImg = loadImage("PLR2won.png");
  drawImg  = loadImage("DRAWwon.png");
  
  // Loads new asset for ai mode
  aiWonImg = loadImage("YOUWON.png");
  aiLoseImg = loadImage("YOULOSE.png");
}

void drawGameResultScreen() {
  fill(0, 0, 0, 120);
  noStroke();
  rectMode(CORNER);
  rect(0, 0, width, height);

  imageMode(CENTER);
  
  // Logic for AI Mode (gameState == 5) with conditional sounds
  if (gameState == 5) {
    if (winner == 1 && aiWonImg != null) {
      image(aiWonImg, width/2, height/2, 700, 500);
      if (!youWonSound.isPlaying()) youWonSound.loop(); // Plays YOUWONSOUND.mp3
    } 
    else if (winner == 2 && aiLoseImg != null) {
      image(aiLoseImg, width/2, height/2, 700, 500);
      if (!youLoseSound.isPlaying()) youLoseSound.loop(); // Plays YOULOSESOUND.mp3
    } 
    else if (winner == 3 && drawImg != null) {
      image(drawImg, width/2, height/2, 700, 500);
      if (!drawSound.isPlaying()) drawSound.loop(); // Plays ng DRAWSOUND.mp3
    }
  } 
  
  // Logic for Original PvP Mode
  else {
    if (winner == 1 && p1WonImg != null) image(p1WonImg, width/2, height/2, 700, 500);
    else if (winner == 2 && p2WonImg != null) image(p2WonImg, width/2, height/2, 700, 500);
    else if (winner == 3 && drawImg != null) image(drawImg, width/2, height/2, 700, 500);
  }
  
  imageMode(CORNER);
}

void mousePressedGameResult() {
  if (winner != 0) {
    float centerX = width / 2.0;
    float centerY = height / 2.0;
    float restartX = centerX - 150;
    float quitX = centerX + 150;
    float buttonY = centerY + 180;  
    float btnW = 120;
    float btnH = 60;
    
    // RESTART BUTTON LOGIC
    if (mouseX > (restartX - btnW/2) && mouseX < (restartX + btnW/2) && 
        mouseY > (buttonY - btnH/2) && mouseY < (buttonY + btnH/2)) {
      
      // 1. Stops result sound
      if (youWonSound.isPlaying()) youWonSound.stop();
      if (youLoseSound.isPlaying()) youLoseSound.stop();
      if (drawSound.isPlaying()) drawSound.stop();
      
      // 2. Reset Flags
      isResultScreen = false;
      isPvPResultScreen = false;
      
      // 3. Resets background music vol and loop it 
      if (duringGameMusic != null) {
        duringGameMusic.amp(0.5); // Back to normal sound
        duringGameMusic.loop();
      }
      
      // 4. Resets game variables
      boardState = new int[3][3];
      winner = 0;
      turn = 1;
      scoreUpdated = false;
    }
    
    // QUIT BUTTON LOGIC
    else if (mouseX > (quitX - btnW/2) && mouseX < (quitX + btnW/2) && 
             mouseY > (buttonY - btnH/2) && mouseY < (buttonY + btnH/2)) {
      
      // Stops all result sounds before to quit
      if (youWonSound.isPlaying()) youWonSound.stop();
      if (youLoseSound.isPlaying()) youLoseSound.stop();
      if (drawSound.isPlaying()) drawSound.stop();
      
      exit();
    }
  }
}

int checkWinner() {
  for (int r = 0; r < 3; r++) {
    if (boardState[r][0] != 0 && boardState[r][0] == boardState[r][1] && boardState[r][1] == boardState[r][2]) {
      return boardState[r][0];
    }
  }
  for (int c = 0; c < 3; c++) {
    if (boardState[0][c] != 0 && boardState[0][c] == boardState[1][c] && boardState[1][c] == boardState[2][c]) {
      return boardState[0][c];
    }
  }
  if (boardState[0][0] != 0 && boardState[0][0] == boardState[1][1] && boardState[1][1] == boardState[2][2]) return boardState[0][0];
  if (boardState[0][2] != 0 && boardState[0][2] == boardState[1][1] && boardState[1][1] == boardState[2][0]) return boardState[0][2];
  
  for (int r = 0; r < 3; r++) {
    for (int c = 0; c < 3; c++) {
      if (boardState[r][c] == 0) return 0;
    }
  }
  return 3;
}
