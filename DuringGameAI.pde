float boardAIX = 400; 
float boardAIY = 320;
PImage duringGameBgAi;
float aiMoveTimer = 0;
boolean isWaitingForAI = false;
int turn = 1;
PFont nirmalaFont; 
boolean resultSoundTriggered = false;
boolean isResultScreen = false;

void setupDuringGameAI() {
  duringGameBgAi = loadImage("DuringgameBgAi.png");
  nirmalaFont = loadFont("NirmalaUI-Bold-20.vlw");
  
  if (nirmalaFont == null) {
    println("ERROR: Font can't load, make sure to put the file inside data folder");
  }
  
  if (duringGameBgAi == null) {
    println("Error: Can't find file inside data folder");
  }
}

void drawDuringGameAIScreen() {
  imageMode(CORNER);
  
  // 1. Draw background image
  if (duringGameBgAi != null) {
    image(duringGameBgAi, 0, 0, width, height);
  } else {
    background(255, 0, 0); 
    println("DEBUG: duringGameBgAi is still null!");
  }
  
  // Logic indicator
  if (winner == 0) {
    textAlign(CENTER, CENTER);
    if (nirmalaFont != null) {
      textFont(nirmalaFont);
    }
    textSize(35);
    if (turn == 1) {
      fill(0, 0, 255);
      text("YOUR TURN", 400, 580);
    } else {
      fill(255, 0, 0);
      text("YOUR OPPONENT IS UP", 400, 580);
    }
  }
  
  // Audio Priority Switch
  if (winner != 0) {
      if (!isResultScreen) {
        if (duringGameMusic != null) {
          duringGameMusic.amp(0.0); // Mute background
          duringGameMusic.stop(); 
        }
        
        // Plays result sound
        if (winner == 1) {
          youWonSound.amp(1.0);
          youWonSound.loop();
        } else if (winner == 2) {
          youLoseSound.amp(1.0);
          youLoseSound.loop();
        } else if (winner == 3) {
          drawSound.amp(1.0);
          drawSound.loop();
        }
      isResultScreen = true;
    }
  } else {
    // Resumes music when theres no winner
    if (!isResultScreen && duringGameMusic != null && !duringGameMusic.isPlaying()) {
      duringGameMusic.amp(0.5);
      duringGameMusic.loop();
  }
}
  
  // 1-second AI delay
  if (isWaitingForAI) {
    if (millis() - aiMoveTimer >= 1000) {
      makeAIMove();
      winner = checkWinner();
      
      if (winner != 0 && !scoreUpdated) {
        if (winner == 1) p1Score++;
        else if (winner == 2) p2Score++;
        scoreUpdated = true;
      }
      isWaitingForAI = false;
      turn = 1;
    }
  }
  
  // Character Icons Display
  if (selectedP1 != -1 && selectedP1 < charImgs.length) {
    imageMode(CENTER);
    image(charImgs[selectedP1], 210, 270, 70, 70);
    imageMode(CORNER);
  }
  
  // Score Display
  fill(255); 
  textSize(18); 
  textAlign(CENTER, CENTER);
  text("SCORE: " + p1Score, 85, 300);
  
  if (gameState == 5) {
    if (selectedAI != -1) image(charImgs[selectedAI], 590, 270, 70, 70);
  } else {
    if (selectedP2 != -1) image(charImgs[selectedP2], 590 , 270, 70, 70);
  }
  text("AI SCORE: " + p2Score, 715, 300);
  
  // Grid rendering logic
  float cellSize = 120;
  float boardLeft = boardAIX - 180;
  float boardTop  = boardAIY - 180;
  for (int r = 0; r < 3; r++) {
    for (int c = 0; c < 3; c++) {
      float x = boardLeft + (c * cellSize) + (cellSize / 2);
      float y = boardTop  + (r * cellSize) + (cellSize / 2);
      
      imageMode(CENTER);
      if (boardState[r][c] == 1) {
        if (aiCardIndex >= 0 && aiCardIndex < charImgs.length) {
          image(charImgs[aiCardIndex], x, y, 100, 100);
        }
      } 
      else if (boardState[r][c] == 2) {
        if (selectedAI >= 0 && selectedAI < charImgs.length) {
          image(charImgs[selectedAI], x, y, 100, 100);
        }
      }
      imageMode(CORNER);
    }
  }
}

void mousePressedDuringGameAI() {
  if (gameState != 5 || winner != 0 || isWaitingForAI || turn != 1) return;
  int r = (mouseY - 150) / 100;
  int c = (mouseX - 250) / 100;
  if (r >= 0 && r < 3 && c >= 0 && c < 3 && boardState[r][c] == 0) {
    boardState[r][c] = 1;
    winner = checkWinner();
    if (winner == 0) {
      isWaitingForAI = true;
      turn = 2;
      aiMoveTimer = millis();
    } else {
      if (winner == 1 && !scoreUpdated) {
        p1Score++;
        scoreUpdated = true;
      }
    }
  }
}

void makeAIMove() {
  ArrayList<Integer> emptyCells = new ArrayList<Integer>();
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (boardState[i][j] == 0) emptyCells.add(i * 3 + j);
    }
  }
  if (emptyCells.size() > 0) {
    int randomChoice = emptyCells.get(int(random(emptyCells.size())));
    boardState[randomChoice / 3][randomChoice % 3] = 2;
  }
}
