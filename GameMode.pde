PImage dialogFrame, selectText, btnPVP, btnAI;
int pvpX, pvpY, pvpW, pvpH;
int aiX,  aiY,  aiW,  aiH;

void setupGameMode() {
  dialogFrame = loadImage("textbox.png");
  selectText  = loadImage("gamemode.png");
  btnPVP      = loadImage("player.png");
  btnAI       = loadImage("ai.png");
}

void drawGameModeScreen() {
  image(bg, 0, 0, width, height);
  int dlgW = 600, dlgH = 420;
  int dlgX = width  / 2 - dlgW / 2;
  int dlgY = height / 2 - dlgH / 2;
  if (dialogFrame != null) image(dialogFrame, dlgX, dlgY, dlgW, dlgH);
  int headerW = 460, headerH = 210;
  int headerX = width / 2 - headerW / 2;
  int headerY = dlgY + 90;
  if (selectText != null) image(selectText, headerX, headerY, headerW, headerH);
  int bW = 210, bH = 110, gap = 20;
  int bY = dlgY + dlgH - bH - 30;
  pvpX = width / 2 - bW - gap / 2; pvpY = bY; pvpW = bW; pvpH = bH;
  aiX  = width / 2 + gap / 2;      aiY  = bY; aiW  = bW; aiH  = bH;
  if (btnPVP != null) image(btnPVP, pvpX, pvpY, pvpW, pvpH);
  if (btnAI  != null) image(btnAI,  aiX,  aiY,  aiW,  aiH);
  strokeWeight(3);
  noFill();
  if (mouseX >= pvpX && mouseX <= pvpX + pvpW && mouseY >= pvpY && mouseY <= pvpY + pvpH) {
    stroke(255, 255, 255, 160);
    rect(pvpX, pvpY, pvpW, pvpH, 4);
  }
  if (mouseX >= aiX && mouseX <= aiX + aiW && mouseY >= aiY && mouseY <= aiY + aiH) {
    stroke(255, 255, 255, 160);
    rect(aiX, aiY, aiW, aiH, 4);
  }
  noStroke();
}

void mousePressedGameMode() {
  if (mouseX >= pvpX && mouseX <= pvpX + pvpW && mouseY >= pvpY && mouseY <= pvpY + pvpH) {
    println("PLAYER VS PLAYER selected!");
    gameState = 2;
  }
  
  if (mouseX >= aiX && mouseX <= aiX + aiW && mouseY >= aiY && mouseY <= aiY + aiH) {
    println("PLAYER VS AI selected!");
    aiMusicStarted = false; // Resets the flag to play music
    gameState = 4;
  }
}
