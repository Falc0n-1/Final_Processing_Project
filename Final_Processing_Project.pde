/*Final Processing Project!
 Ostap Voloshyn
 */

/*
goomba https://www.pngitem.com/middle/iRwJmiT_goomba-png-goomba-8-bit-transparent-png/
 mario https://ca.pinterest.com/pin/24136547998262793/
 coin https://giphy.com/gifs/IRIXVR-coin-irixvr-irix-vr-KEWPSg4LhpVF8KKv9s
 grassland background https://cl.pinterest.com/pin/678073287681006029/
 desert background https://www.magnific.com/free-photos-vectors/8-bit-desert
 underground background https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/71c8d4c1-f1a9-47f1-855c-030b165278fa/dektmf0-620affda-4aa3-4088-a505-d7b45e2c78e7.gif/v1/fill/w_768,h_384,q_85,strp/crystal_cave_background_by_fellfeline_dektmf0-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9Mzg0IiwicGF0aCI6Ii9mLzcxYzhkNGMxLWYxYTktNDdmMS04NTVjLTAzMGIxNjUyNzhmYS9kZWt0bWYwLTYyMGFmZmRhLTRhYTMtNDA4OC1hNTA1LWQ3YjQ1ZTJjNzhlNy5naWYiLCJ3aWR0aCI6Ijw9NzY4In1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.YAJ9W_Tzhlb-NxV52JVM7-Bhz-tYsNvVF1TIq2OKnq8
 castle background https://www.magnific.com/free-ai-image/8-bit-graphics-pixels-scene-with-castle_137494400.htm#fromView=keyword&page=1&position=0&uuid=881fa994-1603-4626-8a0d-ec4d3cf36dec&track=ais_hybrid&query=8+bit+castle
 winter background https://stock.adobe.com/ca/search?k=pixel+winter
 All sounds are from pixabay
 */
import processing.sound.*;

int screen = 0;

int menu = 0;
int levelSelect = 1;
int game = 2;
int settings = 3;
int win = 4;

int level = 0;

float playerX = 35;
float playerY = 491;
float playerSpeed = 4.2;
float playerWidth = 55;
float playerHeight = 49;

float gravity = 0.62;
float jumpPower = -12.5;
float velocityY = 0;

float previousPlayerY;

boolean onGround = false;
boolean movingLeft = false;
boolean movingRight = false;
boolean jumpRequested = false;

int score = 0;
float groundY = 540;

PImage grasslands;
PImage desert;
PImage underground;
PImage castle;
PImage winter;

PImage marioStanding;
PImage marioLeft;
PImage marioRight;

PImage goomba;
PImage coinImage;

SoundFile jumpSound;
SoundFile coinSound;
SoundFile winSound;

boolean victorySoundPlayed = false;

float[] platformX = new float[12];
float[] platformY = new float[12];
float[] platformW = new float[12];
float[] platformH = new float[12];

int platformCount = 0;

float[] coinX = new float[10];
float[] coinY = new float[10];
boolean[] coinCollected = new boolean[10];

int coinCount = 0;

float enemyX = 320;
float enemyY = 500;
float enemyStartX = 320;

float enemySpeed = 1.5;
float enemyMinX = 200;
float enemyMaxX = 500;

float enemyWidth = 38;
float enemyHeight = 40;

String[] levelNames = {
  "Grassland",
  "Desert",
  "Underground",
  "Castle",
  "Winter"
};

void setup() {

  size(600, 600);

  textAlign(CENTER, CENTER);

  grasslands = loadImage("grasslands.jpeg");
  desert = loadImage("desert.jpg");
  underground = loadImage("underground.jpg");
  castle = loadImage("castle.jpg");
  winter = loadImage("winter background.jpg");

  marioStanding = loadImage("Mario_Standing.png");
  marioLeft = loadImage("Mario_Running_Left.png");
  marioRight = loadImage("Mario_Running_Right.png");

  marioLeft = cropMario(marioLeft);
  marioRight = cropMario(marioRight);

  goomba = loadImage("goomba.png");
  coinImage = loadImage("coin.gif");

  jumpSound = new SoundFile(this, "moutchitos-mario-grabish-14183.mp3");
  coinSound = new SoundFile(this, "coin.mp3");
  winSound = new SoundFile(this, "mori_sound-fx-done-trumpet-510841.mp3");

  jumpSound.amp(0.7);
  coinSound.amp(0.7);
  winSound.amp(0.7);
}

PImage cropMario(PImage img) {

  if (img == null) {
    return null;
  }

  int left = img.width;
  int right = 0;
  int top = img.height;
  int bottom = 0;

  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {

      if (alpha(img.get(x, y)) > 10) {

        if (x < left) {
          left = x;
        }

        if (x > right) {
          right = x;
        }

        if (y < top) {
          top = y;
        }

        if (y > bottom) {
          bottom = y;
        }
      }
    }
  }

  if (right < left || bottom < top) {
    return img;
  }

  return img.get(left, top, right - left + 1, bottom - top + 1);
}

void draw() {

  if (screen == menu) {
    drawMenu();
  } else if (screen == levelSelect) {
    drawLevelSelect();
  } else if (screen == game) {
    drawGame();
  } else if (screen == settings) {
    drawSettings();
  } else if (screen == win) {
    drawWin();
  }
}

void drawMenu() {

  background(100, 180, 255);

  fill(255);
  textSize(55);
  text("Super Mario", 300, 170);

  drawButton("Play", 200, 280, 200, 60);
  drawButton("Settings", 200, 370, 200, 60);
}

void drawLevelSelect() {

  background(100, 180, 255);

  fill(255);
  textSize(40);
  text("Select Level", 300, 90);

  for (int i = 0; i < levelNames.length; i++) {
    drawButton(levelNames[i], 150, 145 + i * 75, 300, 55);
  }

  drawButton("Back", 200, 535, 200, 45);
}

void drawSettings() {

  background(100, 180, 255);

  fill(255);
  textSize(40);
  text("Settings", 300, 180);

  textSize(20);

  text("Move: A / D or Arrow Keys", 300, 270);
  text("Jump: Space or Up", 300, 310);
  text("Restart: R", 300, 350);
  text("Return to Menu: ESC", 300, 390);

  drawButton("Back", 200, 440, 200, 60);
}

void drawWin() {

  background(100, 180, 255);

  fill(255);
  textSize(50);
  text("You Win!", 300, 220);

  textSize(25);
  text("You completed all levels!", 300, 290);

  textSize(20);
  text("Total Coins: " + score, 300, 335);

  drawButton("Main Menu", 200, 390, 200, 60);
}

void drawButton(String label, float x, float y, float w, float h) {

  fill(50, 150, 70);
  rect(x, y, w, h, 12);

  fill(255);
  textSize(22);
  text(label, x + w / 2, y + h / 2);
}

void drawGame() {

  drawBackground();

  previousPlayerY = playerY;

  if (movingLeft) {
    playerX -= playerSpeed;
  }

  if (movingRight) {
    playerX += playerSpeed;
  }

  if (playerX < 0) {
    playerX = 0;
  }

  if (playerX + playerWidth > width) {
    playerX = width - playerWidth;
  }

  velocityY += gravity;
  playerY += velocityY;

  onGround = false;

  for (int i = 0; i < platformCount; i++) {

    if (playerX + playerWidth > platformX[i] &&
      playerX < platformX[i] + platformW[i] &&
      previousPlayerY + playerHeight <= platformY[i] &&
      playerY + playerHeight >= platformY[i] &&
      velocityY >= 0) {

      playerY = platformY[i] - playerHeight;
      velocityY = 0;
      onGround = true;
    }
  }

  if (playerY + playerHeight >= groundY && velocityY >= 0) {

    playerY = groundY - playerHeight;
    velocityY = 0;
    onGround = true;
  }

  if (jumpRequested && onGround) {

    velocityY = jumpPower;
    onGround = false;

    jumpSound.stop();
    jumpSound.play();
  }

  jumpRequested = false;

  if (playerY > height) {
    resetPlayer();
  }

  drawGround();
  drawPlatforms();
  drawCoins();

  if (enemyX >= 0) {

    moveEnemy();
    drawEnemy();

    if (playerX + playerWidth > enemyX &&
      playerX < enemyX + enemyWidth &&
      playerY + playerHeight > enemyY &&
      playerY < enemyY + enemyHeight) {

      resetPlayer();
    }
  }

  drawPlayer();

  textAlign(LEFT, CENTER);

  fill(255);
  textSize(18);

  text("Coins: " + score, 20, 25);
  text("Level: " + levelNames[level], 20, 52);

  textAlign(CENTER, CENTER);

  int remainingCoins = countCoins();

  if (remainingCoins > 0 && playerX + playerWidth >= 550) {

    fill(255);
    textSize(18);
    text("Collect all coins!", 300, 100);
  }

  if (playerX + playerWidth >= 570 && remainingCoins == 0) {

    if (level < 4) {

      level++;
      loadLevel();
    } else {

      screen = win;

      if (!victorySoundPlayed) {
        winSound.play();
        victorySoundPlayed = true;
      }
    }
  }
}

void drawBackground() {

  if (level == 0 && grasslands != null) {
    image(grasslands, 0, 0, width, height);
  } else if (level == 1 && desert != null) {
    image(desert, 0, 0, width, height);
  } else if (level == 2 && underground != null) {
    image(underground, 0, 0, width, height);
  } else if (level == 3 && castle != null) {
    image(castle, 0, 0, width, height);
  } else if (level == 4 && winter != null) {
    image(winter, 0, 0, width, height);
  } else {
    background(100, 180, 255);
  }
}

void drawImageFit(PImage img, float x, float y, float w, float h) {

  if (img != null) {

    float scale = min(w / img.width, h / img.height);

    float newW = img.width * scale;
    float newH = img.height * scale;

    image(img, x + (w - newW) / 2,
      y + (h - newH) / 2, newW, newH);
  }
}

void drawGround() {

  if (level == 0) {
    fill(70, 160, 60);
  } else if (level == 1) {
    fill(190, 130, 65);
  } else if (level == 2) {
    fill(65, 60, 90);
  } else if (level == 3) {
    fill(90, 45, 45);
  } else {
    fill(220, 240, 255);
  }

  rect(0, groundY, 600, 60);
}

void addPlatform(float x, float y, float w, float h) {

  platformX[platformCount] = x;
  platformY[platformCount] = y;
  platformW[platformCount] = w;
  platformH[platformCount] = h;

  platformCount++;
}

void drawPlatforms() {

  for (int i = 0; i < platformCount; i++) {

    if (level == 0) {
      fill(100, 70, 40);
    } else if (level == 1) {
      fill(190, 125, 55);
    } else if (level == 2) {
      fill(95, 85, 120);
    } else if (level == 3) {
      fill(100, 45, 45);
    } else {
      fill(190, 225, 245);
    }

    rect(platformX[i], platformY[i],
      platformW[i], platformH[i]);
  }
}

void drawPlayer() {

  PImage currentMario = marioStanding;

  if (movingLeft) {
    currentMario = marioLeft;
  } else if (movingRight) {
    currentMario = marioRight;
  }

  if (currentMario != null) {
    image(currentMario, playerX, playerY, playerWidth, playerHeight);
  } else {
    fill(220, 30, 30);
    rect(playerX, playerY, playerWidth, playerHeight);
  }
}

void addCoin(float x, float y) {

  coinX[coinCount] = x;
  coinY[coinCount] = y;
  coinCollected[coinCount] = false;

  coinCount++;
}

void drawCoins() {

  for (int i = 0; i < coinCount; i++) {

    if (!coinCollected[i]) {

      if (coinImage != null) {
        drawImageFit(coinImage, coinX[i] - 11,
          coinY[i] - 11, 22, 22);
      } else {
        fill(255, 220, 0);
        ellipse(coinX[i], coinY[i], 22, 22);
      }

      if (playerX + playerWidth > coinX[i] - 11 &&
        playerX < coinX[i] + 11 &&
        playerY + playerHeight > coinY[i] - 11 &&
        playerY < coinY[i] + 11) {

        coinCollected[i] = true;
        score++;

        coinSound.stop();
        coinSound.play();
      }
    }
  }
}

int countCoins() {

  int remaining = 0;

  for (int i = 0; i < coinCount; i++) {

    if (!coinCollected[i]) {
      remaining++;
    }
  }

  return remaining;
}

void drawEnemy() {

  if (goomba != null) {
    drawImageFit(goomba, enemyX, enemyY, enemyWidth, enemyHeight);
  } else {
    fill(110, 35, 35);
    rect(enemyX, enemyY, enemyWidth, enemyHeight);
  }
}

void moveEnemy() {

  enemyX += enemySpeed;

  if (enemyX + enemyWidth >= enemyMaxX) {
    enemySpeed = -abs(enemySpeed);
  }

  if (enemyX <= enemyMinX) {
    enemySpeed = abs(enemySpeed);
  }
}

void loadLevel() {

  platformCount = 0;
  coinCount = 0;

  if (level == 0) {

    addPlatform(105, 465, 110, 18);
    addPlatform(270, 405, 110, 18);
    addPlatform(420, 465, 105, 18);

    addCoin(160, 440);
    addCoin(325, 380);
    addCoin(475, 440);
    addCoin(250, 515);

    enemyStartX = 370;
    enemyMinX = 300;
    enemyMaxX = 490;
    enemySpeed = 1.5;
  } else if (level == 1) {

    addPlatform(75, 455, 95, 18);
    addPlatform(215, 390, 90, 18);
    addPlatform(355, 325, 95, 18);
    addPlatform(485, 420, 75, 18);

    addCoin(120, 430);
    addCoin(260, 365);
    addCoin(400, 300);
    addCoin(520, 395);
    addCoin(330, 515);

    enemyStartX = 300;
    enemyMinX = 230;
    enemyMaxX = 500;
    enemySpeed = 1.9;
  } else if (level == 2) {

    addPlatform(65, 465, 85, 18);
    addPlatform(180, 405, 85, 18);
    addPlatform(300, 345, 85, 18);
    addPlatform(425, 405, 85, 18);
    addPlatform(485, 315, 75, 18);

    addCoin(105, 440);
    addCoin(220, 380);
    addCoin(340, 320);
    addCoin(465, 380);
    addCoin(520, 290);
    addCoin(275, 515);

    enemyStartX = 330;
    enemyMinX = 220;
    enemyMaxX = 520;
    enemySpeed = 2.3;
  } else if (level == 3) {

    addPlatform(85, 460, 80, 18);
    addPlatform(200, 390, 80, 18);
    addPlatform(315, 320, 80, 18);
    addPlatform(430, 390, 80, 18);
    addPlatform(490, 290, 70, 18);

    addCoin(125, 435);
    addCoin(240, 365);
    addCoin(355, 295);
    addCoin(470, 365);
    addCoin(525, 265);
    addCoin(285, 515);
    addCoin(390, 515);

    enemyStartX = 350;
    enemyMinX = 210;
    enemyMaxX = 520;
    enemySpeed = 2.7;
  } else if (level == 4) {

    addPlatform(55, 465, 75, 18);
    addPlatform(155, 400, 75, 18);
    addPlatform(255, 335, 75, 18);
    addPlatform(355, 400, 75, 18);
    addPlatform(455, 335, 75, 18);

    addCoin(90, 440);
    addCoin(190, 375);
    addCoin(290, 310);
    addCoin(390, 375);
    addCoin(490, 310);
    addCoin(235, 515);
    addCoin(425, 515);

    enemyStartX = 330;
    enemyMinX = 190;
    enemyMaxX = 520;
    enemySpeed = 3.2;
  }

  resetPlayer();
}

void resetPlayer() {

  for (int i = 0; i < coinCount; i++) {

    if (coinCollected[i]) {
      score--;
      coinCollected[i] = false;
    }
  }

  playerX = 35;
  playerY = groundY - playerHeight;

  velocityY = 0;

  onGround = false;

  movingLeft = false;
  movingRight = false;
  jumpRequested = false;

  enemyX = enemyStartX;
}

void resetGame() {

  level = 0;
  score = 0;

  victorySoundPlayed = false;

  loadLevel();
}

void startLevel(int selectedLevel) {

  level = selectedLevel;
  score = 0;

  victorySoundPlayed = false;

  loadLevel();

  screen = game;
}

void mousePressed() {

  if (screen == menu) {

    if (mouseX > 200 && mouseX < 400 &&
      mouseY > 280 && mouseY < 340) {
      screen = levelSelect;
    }

    if (mouseX > 200 && mouseX < 400 &&
      mouseY > 370 && mouseY < 430) {
      screen = settings;
    }
  } else if (screen == levelSelect) {

    for (int i = 0; i < levelNames.length; i++) {

      if (mouseX > 150 && mouseX < 450 &&
        mouseY > 145 + i * 75 &&
        mouseY < 200 + i * 75) {
        startLevel(i);
      }
    }

    if (mouseX > 200 && mouseX < 400 &&
      mouseY > 535 && mouseY < 580) {
      screen = menu;
    }
  } else if (screen == settings) {

    if (mouseX > 200 && mouseX < 400 &&
      mouseY > 440 && mouseY < 500) {
      screen = menu;
    }
  } else if (screen == win) {

    if (mouseX > 200 && mouseX < 400 &&
      mouseY > 390 && mouseY < 450) {

      resetGame();
      screen = menu;
    }
  }
}

void keyPressed() {

  if (screen == game) {

    if (key == 'a' || key == 'A' || keyCode == LEFT) {
      movingLeft = true;
    }

    if (key == 'd' || key == 'D' || keyCode == RIGHT) {
      movingRight = true;
    }

    if (key == ' ' || keyCode == UP) {
      jumpRequested = true;
    }

    if (key == 'r' || key == 'R') {
      resetPlayer();
    }

    if (key == ESC) {

      key = 0;

      movingLeft = false;
      movingRight = false;
      jumpRequested = false;

      screen = menu;
    }
  }
}

void keyReleased() {

  if (key == 'a' || key == 'A' || keyCode == LEFT) {
    movingLeft = false;
  }

  if (key == 'd' || key == 'D' || keyCode == RIGHT) {
    movingRight = false;
  }
}
