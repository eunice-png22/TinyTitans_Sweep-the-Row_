PImage[] aiCardImgs = new PImage[5];
PImage leftArrowImg, rightArrowImg, start2Img; 
int aiCardIndex = 0;
int selectedAI = -1;

int leftArrX  = 370,  leftArrY  = 250, arrW = 60, arrH = 70;
int rightArrX = 650, rightArrY = 250;
float start2BtnX = 550, start2BtnY = 520, start2BtnW = 160, start2BtnH = 80; 
boolean aiMusicStarted = false; 

void setupPlayerVsAI() {
  aiCardImgs[0] = loadImage("eagleAI.png");
  aiCardImgs[1] = loadImage("chickenAI.png");
  aiCardImgs[2] = loadImage("ratAI.png");
  aiCardImgs[3] = loadImage("carabaoAI.png");
  aiCardImgs[4] = loadImage("cockroachAI.png");

  leftArrowImg  = loadImage("leftarrow.png"); 
  rightArrowImg = loadImage("rightarrow.png");
  
  // 2. Updated loader to use "start2.png"
  start2Img = loadImage("start2.png"); 
}

void drawPlayerVsAIScreen() {
  if (!aiMusicStarted) {
    playCharacterSound(aiCardIndex); // Uses loop () sound
    aiMusicStarted = true;           
  }
  
  background(0);
  pushMatrix();
  scale(scaleW, scaleH);
  
  imageMode(CENTER);
  if (aiCardImgs[aiCardIndex] != null) {
    image(aiCardImgs[aiCardIndex], 400, 300, 800, 600);
  }
  
  imageMode(CORNER);
  if (leftArrowImg != null) image(leftArrowImg, leftArrX, leftArrY, arrW, arrH);
  if (rightArrowImg != null) image(rightArrowImg, rightArrX, rightArrY, arrW, arrH);
  
  imageMode(CENTER);
  if (start2Img != null) {
    image(start2Img, start2BtnX, start2BtnY, start2BtnW, start2BtnH);
  }
  
  popMatrix();
}

void mousePressedPlayerVsAI() {
  // 1. Calculate the scaled coordinates 
  float mouseX_scaled = mouseX / scaleW;
  float mouseY_scaled = mouseY / scaleH;
  
  // 2. Logic for the Right Arrow
  if (mouseX_scaled >= rightArrX && mouseX_scaled <= rightArrX + arrW &&
      mouseY_scaled >= rightArrY && mouseY_scaled <= rightArrY + arrH) {
    
    aiCardIndex = (aiCardIndex + 1) % 5;
    playCharacterSound(aiCardIndex);     // Triggers the sound (loop)
  }
  
  // 3. Logic for Left Arrow
  else if (mouseX_scaled >= leftArrX && mouseX_scaled <= leftArrX + arrW &&
           mouseY_scaled >= leftArrY && mouseY_scaled <= leftArrY + arrH) {
    
    aiCardIndex = (aiCardIndex - 1 + 5) % 5; // Loop back (0-4)
    playCharacterSound(aiCardIndex);         // triggers the sound (loop)
  }
  
  // 4. Logic for Start Button
   else if (mouseX_scaled >= start2BtnX && mouseX_scaled <= start2BtnX + start2BtnW &&
           mouseY_scaled >= start2BtnY && mouseY_scaled <= start2BtnY + start2BtnH) {
    
    // Stop the character sound before the transition of the game
    stopAllCharacterSounds();
    
    // Assign random AI character different from player
    do {
      selectedAI = int(random(0, 5));
    } while (selectedAI == aiCardIndex); 
    
    // Stops the intro music before transitioning
    if (music.isPlaying()) {
      music.stop();
    }
    
    // Reset the board state before game start
    boardState = new int[3][3];
    turn = 1;
    winner = 0;
    
    // Switch the state to 5 (During Game AI)
    gameState = 5;
  }
}
