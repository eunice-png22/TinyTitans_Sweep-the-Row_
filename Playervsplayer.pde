int selectedP1 = -1;
int selectedP2 = -1;
boolean p1Locked = false;
boolean p2Locked = false;

PImage[] charImgs = new PImage[5];
PImage[] nameImgs = new PImage[5];
PImage charBoard, selectBtnImg;
PImage p1Img, p2Img, vsImg, startImg;

String errorMessage = "";
int errorTimer = 0;
PFont errorFont;

int[] gx = new int[5];
int[] gy = new int[5];
int cellW = 110, cellH = 110;

int startBtnX = 400 - 70;
int startBtnY = 460;
int startBtnW = 150, startBtnH = 100;

boolean isPvPResultScreen = false;

void setupCharacterSelect() {
  charImgs[0] = loadImage("eagle.png");
  charImgs[1] = loadImage("chicken.png");
  charImgs[2] = loadImage("rat.png");
  charImgs[3] = loadImage("carabao.png");
  charImgs[4] = loadImage("cockroach.png");

  nameImgs[0] = loadImage("AGILA.png");
  nameImgs[1] = loadImage("MANOK.png");
  nameImgs[2] = loadImage("DAGA.png");
  nameImgs[3] = loadImage("KALABAW.png");
  nameImgs[4] = loadImage("IPIS.png");

  charBoard    = loadImage("charboard2.png");
  selectBtnImg = loadImage("selectbutton.png");
  p1Img        = loadImage("player1.png");
  p2Img        = loadImage("player2.png");
  vsImg        = loadImage("vs.png");
  startImg     = loadImage("start.png");
}

void drawCharacterSelectScreen() {
  background(0);
  stroke(255, 0, 0); 
  noFill();
  rectMode(CORNER);
  
  // Render the background (make sure 'bg' is a valid image)
  if (bg != null) {
    image(bg, 0, 0, 800, 600);
  }

  // --- Character Board Drawing ---
  int cW = 550, cH = 500;
  int cX = 140;
  int cY = 50;
  if (charBoard != null) {
    image(charBoard, cX, cY, cW, cH);
  } else {
    fill(30, 80, 120, 200);
    stroke(160, 220, 255);
    strokeWeight(2);
    rect(cX, cY, cW, cH, 10);
    noStroke();
  }

  // --- Character Icons Drawing ---
  int boardCenterX = cX + cW / 2;
  int row1Y = cY + 220;
  int row2Y = cY + 310;
  gx[0] = boardCenterX - 160; gy[0] = row1Y;
  gx[1] = boardCenterX;       gy[1] = row1Y;
  gx[2] = boardCenterX + 160; gy[2] = row1Y;
  gx[3] = boardCenterX - 80;  gy[3] = row2Y;
  gx[4] = boardCenterX + 80;  gy[4] = row2Y;

  for (int i = 0; i < 5; i++) {
    imageMode(CENTER);
    if (charImgs[i] != null) {
      if      (i == 1) image(charImgs[i], gx[i], gy[i], 120, 130);
      else if (i == 4) image(charImgs[i], gx[i], gy[i], 120, 200);
      else if (i == 0) image(charImgs[i], gx[i], gy[i], 130, 150);
      else if (i == 2) image(charImgs[i], gx[i], gy[i], 120, 108);
      else             image(charImgs[i], gx[i], gy[i], 120, 120);
    }
    imageMode(CORNER);
  }

  // --- Player Slots at Start Button ---
  drawPlayerSlot(1, 100, 300, selectedP1, p1Locked);
  drawPlayerSlot(2, 700, 300, selectedP2, p2Locked);

  imageMode(CENTER);
  if (p1Img != null) image(p1Img, 100, 140, 240, 90);
  if (vsImg != null) image(vsImg, 400, 105, 160, 90);
  if (p2Img != null) image(p2Img, 700, 140, 240, 90);
  imageMode(CORNER);

  if (p1Locked && p2Locked) {
    if (startImg != null) {
      image(startImg, startBtnX, startBtnY, startBtnW, startBtnH);
    } else {
      fill(0, 180, 60);
      stroke(0, 255, 80);
      strokeWeight(2);
      rect(startBtnX, startBtnY, startBtnW, startBtnH, 8);
      noStroke();
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(18);
      text("START", 400, startBtnY + startBtnH / 2);
    }
  }

  // --- UI Error Message Prompt ---
  if (errorTimer > 0) {
    fill(255, 0, 0); // Pula
    textAlign(CENTER, CENTER);
    
    // First check if the font is not null before using it to avoid an error
    if (errorFont != null) {
      textFont(errorFont);
    }
    
    textSize(20);
    text(errorMessage, 400, 550); // Render the text below the screen
    errorTimer--;
  }
}

void drawPlayerSlot(int pNum, int x, int y, int sel, boolean locked) {
  imageMode(CENTER);

  if (sel != -1 && charImgs[sel] != null) {
    float bob = sin(frameCount * 0.05) * 4;
    int portraitSize = (sel == 1) ? 210 : 180;
    image(charImgs[sel], x, y - 30 + bob, portraitSize, portraitSize);
  }

  if (sel != -1 && nameImgs[sel] != null) {
    image(nameImgs[sel], x, y + 100, 200, 50);
  }

  imageMode(CORNER);

  if (!locked) {
    int btnW = 180, btnH = 100;
    int btnX = x - btnW / 2;
    int btnY = y + 130;

    if (selectBtnImg != null) {
      image(selectBtnImg, btnX, btnY, btnW, btnH);
    } else {
      fill(60, 60, 180);
      stroke(180, 180, 255);
      strokeWeight(2);
      rect(btnX, btnY, btnW, btnH, 8);
      noStroke();
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(18);
      text("SELECT", x, btnY + btnH / 2);
    }
  }
}

void mousePressedCharacterSelect() {
  // 1. Logic for clicking Character Icons
  for (int i = 0; i < 5; i++) {
    int w = 120, h = 120;
    if       (i == 1) { w = 130; h = 130; } 
    else if (i == 4) { w = 200; h = 200; } 
    else if (i == 0) { w = 150; h = 150; } 
    else if (i == 2) { w = 120; h = 110; } 

    // Check if the mouse click is inside the character icon
    if (mouseX >= gx[i] - w/2 && mouseX <= gx[i] + w/2 &&
        mouseY >= gy[i] - h/2 && mouseY <= gy[i] + h/2) {
      
      // Stops the INTRO SOUND if pressing the character
      if (music.isPlaying()) {
        music.stop();
      }

      if (!p1Locked) {
        selectedP1 = i;
        playCharacterSound(selectedP1);
      } else if (!p2Locked) {
        if (i == selectedP1) {
          errorMessage = "YOU CANNOT SELECT THE SAME CHARACTER, PLEASE CHOOSE ANOTHER";
          errorTimer = 40; 
        } else {
          selectedP2 = i;
          playCharacterSound(selectedP2);
        }
      }
      return;
    }
  }
  
  // 2. Logic for Lock Buttons
  int btnW = 140, btnH = 46;
  int p1BtnX = 100 - btnW / 2;
  int p1BtnY = 300 + 130;
  if (!p1Locked && selectedP1 != -1 &&
      mouseX >= p1BtnX && mouseX <= p1BtnX + btnW &&
      mouseY >= p1BtnY && mouseY <= p1BtnY + btnH) {
    p1Locked = true;
    playSelectSound(); 
    return;
  }

  int p2BtnX = 700 - btnW / 2;
  int p2BtnY = 300 + 130;
  if (!p2Locked && selectedP2 != -1 &&
      mouseX >= p2BtnX && mouseX <= p2BtnX + btnW &&
      mouseY >= p2BtnY && mouseY <= p2BtnY + btnH) {
    p2Locked = true;
    playSelectSound(); // Sound to lock
    return;
  }

  // 3. Logic for Start Button
  if (p1Locked && p2Locked &&
      mouseX >= startBtnX && mouseX <= startBtnX + startBtnW &&
      mouseY >= startBtnY && mouseY <= startBtnY + startBtnH) {
    
    for (int r = 0; r < 3; r++)
      for (int c = 0; c < 3; c++)
        boardState[r][c] = 0;
    turn = 1;
    winner = 0;
    transitionToGameState(3);
    playSelectSound(); // Sound to start 
  }
}

void resetCharacterSelect() {
  selectedP1 = -1;
  selectedP2 = -1;
  p1Locked   = false;
  p2Locked   = false;
}
