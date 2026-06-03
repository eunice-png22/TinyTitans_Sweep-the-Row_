PImage duringGameBG, boardImg, p1UpImg, p2UpImg;
float boardX = 400; 
float boardY = 320;
void setupDuringGame() {
  duringGameBG = loadImage("duringgameBG.png");
  p1UpImg      = loadImage("PLR 1 IS UP!.png");
  p2UpImg      = loadImage("PLR 2 IS UP!.png");
}

void drawDuringGameScreen() {
  // 1. Background
  imageMode(CORNER);
  if (duringGameBG != null) image(duringGameBG, 0, 0, 800, 600);
  else background(0);

  imageMode(CENTER);
  // 2. Player 1 UI (left)
  if (selectedP1 != -1) image(charImgs[selectedP1], 168, 293, 80, 80);
  fill(255); textSize(20); textAlign(CENTER, CENTER);
  text("SCORE: " + p1Score, 85, 300);
  
  // 3. Player 2 UI o AI UI (right)
  if (gameState == 5) {
    if (selectedAI != -1) image(charImgs[selectedAI], 630, 293, 80, 80);
  } else {
    if (selectedP2 != -1) image(charImgs[selectedP2], 630, 293, 80, 80);
  }
  fill(255); textSize(20); textAlign(CENTER, CENTER);
  text("SCORE: " + p2Score, 715, 300);

  // 4. Turn indicator
  if (winner == 0) {
    if (turn == 1) image(p1UpImg, 400, 580, 150, 60);
    else           image(p2UpImg, 400, 580, 150, 80);
  }

  // 5. Grid characters
  float cellSize  = 120;
  float boardLeft = boardX - 225 + 48;
  float boardTop  = boardY - 225 + 30;
  for (int r = 0; r < 3; r++) {
    for (int c = 0; c < 3; c++) {
      float x = boardLeft + (c * cellSize) + (cellSize / 2);
      float y = boardTop  + (r * cellSize) + (cellSize / 2);
      
      if (boardState[r][c] == 1 && selectedP1 != -1) {
        image(charImgs[selectedP1], x, y, 100, 100);
      } 
      else if (boardState[r][c] == 2) {
        if (gameState == 5 && selectedAI != -1) {
          image(charImgs[selectedAI], x, y, 100, 100);
        } else if (selectedP2 != -1) {
          image(charImgs[selectedP2], x, y, 100, 100);
        }
      }
    }
  }
  
      // Audio Priority Switch: PvP Exclusive Audio Playback Logic
    if (winner != 0) {
      if (!isPvPResultScreen) {
        if (duringGameMusic != null) {
          duringGameMusic.amp(0.0); // Mute background
          duringGameMusic.stop(); 
        }
        
        // Plays result sound
        if (winner == 1 || winner == 2) {
          youWonSound.amp(1.0);
          youWonSound.loop();
        } else if (winner == 3) {
          drawSound.amp(1.0);
          drawSound.loop();
        }
        isPvPResultScreen = true;
      }
    } else {
      // Resume music if theres no winner
      if (!isPvPResultScreen && duringGameMusic != null && !duringGameMusic.isPlaying()) {
        duringGameMusic.amp(0.5); // back to normal sound
        duringGameMusic.loop();
      }
    }
  
  // 6. Result overlay and Score Update
  if (winner != 0) {
    if (!scoreUpdated) {
      if (winner == 1) p1Score++;
      else if (winner == 2) p2Score++;
      scoreUpdated = true; 
    }
    drawGameResultScreen();
  }

  imageMode(CORNER);
}
