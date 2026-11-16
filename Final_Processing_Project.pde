/*
 Ostap
 Final Processing Project
 Super Mario game
 TODO: Fix coins
 add more game levels 
 */
import processing.sound.*;

PImage marioRight;
PImage marioLeft;

SoundFile jumpSound;
SoundFile coinSound;
SoundFile winSound;

final int MENU = 0;
final int GAME = 1;
final int SETTINGS = 2;
final int WIN = 3;

int screen = MENU;

final float PLAYER_W = 55;
final float PLAYER_H = 49;

float playerX = 35;
float playerY = 480;
float playerSpeed = 4.2;
float velocityY = 0;
float gravity = 0.62;
float jumpPower = -12.5;

boolean onGround = false;
boolean movingLeft = false;
boolean movingRight = false;
boolean facingRight = true;
boolean hasWon = false;

int score = 0;

float[][] platforms = {
  {0, 540, 600, 60},
  {125, 450, 125, 18},
  {295, 370, 125, 18},
  {455, 290, 105, 18}
};

float[][] coins = {
  {185, 415, 0},
  {350, 335, 0},
  {500, 255, 0}
};

void setup() {
  size(600, 600);
  imageMode(CORNER);
  textAlign(CENTER, CENTER);
  textSize(24);

  marioRight = loadImage("Mario_Running_Right.png");
  marioLeft = loadImage("Mario_Running_Left.png");

  jumpSound = new SoundFile(this, "moutchitos-mario-grabish-14183.mp3");
  coinSound = new SoundFile(this, "coin.mp3");
  winSound = new SoundFile(this, "mori_sound-fx-done-trumpet-510841.mp3");
}

void draw() {
  if (screen == MENU) {
    drawMenu();
  } else if (screen == GAME) {
    drawGame();
  } else if (screen == SETTINGS) {
    drawSettings();
  } else if (screen == WIN) {
    drawWin();
  }
}

void drawMenu() {
  drawSky();

  fill(255, 215, 0);
  textSize(43);
  text("SUPER MARIO", 300, 115);

  drawButton(200, 210, 200, 60, "PLAY");
  drawButton(200, 305, 200, 60, "SETTINGS");
  drawButton(200, 400, 200, 60, "EXIT");

  fill(255);
  textSize(15);
  text("Collect coins and reach the flag!", 300, 510);
}

void drawButton(float x, float y, float w, float h, String label) {
  if (mouseX >= x && mouseX <= x + w &&
      mouseY >= y && mouseY <= y + h) {
    fill(255, 220, 80);
  } else {
    fill(255);
  }

  stroke(80, 40, 20);
  strokeWeight(3);
  rect(x, y, w, h, 10);
  noStroke();

  fill(40, 30, 30);
  textSize(25);
  text(label, x + w/2, y + h/2);
}

void drawSettings() {
  drawSky();

  fill(255);
  textSize(40);
  text("SETTINGS", 300, 115);

  textSize(21);
  text("A / D or LEFT / RIGHT = Move", 300, 240);
  text("SPACE or UP = Jump", 300, 290);
  text("R = Restart the level", 300, 340);
  text("ESC = Return to menu", 300, 390);

  drawButton(200, 465, 200, 60, "BACK");
}

void drawGame() {
  drawSky();

  noStroke();
  for (int i = 0; i < platforms.length; i++) {
    fill(135, 75, 35);
    rect(platforms[i][0], platforms[i][1],
         platforms[i][2], platforms[i][3]);

    fill(70, 190, 65);
    rect(platforms[i][0], platforms[i][1],
         platforms[i][2], 7);
  }

  if (movingLeft) {
    playerX -= playerSpeed;
    facingRight = false;
  }
  if (movingRight) {
    playerX += playerSpeed;
    facingRight = true;
  }

  playerX = constrain(playerX, 0, width - PLAYER_W);

  float oldBottom = playerY + PLAYER_H;
  velocityY += gravity;
  playerY += velocityY;
  onGround = false;

  if (velocityY >= 0) {
    for (int i = 0; i < platforms.length; i++) {
      float px = platforms[i][0];
      float py = platforms[i][1];
      float pw = platforms[i][2];

      boolean overlaps = playerX + PLAYER_W > px &&
                         playerX < px + pw;
      boolean crossedTop = oldBottom <= py &&
                           playerY + PLAYER_H >= py;

      if (overlaps && crossedTop) {
        playerY = py - PLAYER_H;
        velocityY = 0;
        onGround = true;
      }
    }
  }

  stroke(90, 55, 20);
  strokeWeight(5);
  line(565, 205, 565, 540);
  noStroke();
  fill(255, 50, 50);
  triangle(565, 208, 565, 260, 525, 234);

  if (facingRight) {
    image(marioRight, playerX, playerY, PLAYER_W, PLAYER_H);
  } else {
    image(marioLeft, playerX, playerY, PLAYER_W, PLAYER_H);
  }

  fill(255);
  textSize(23);
  textAlign(LEFT, CENTER);
  text("COINS: " + score, 20, 30);
  textAlign(CENTER, CENTER);

  fill(255);
  textSize(14);
  text("Move: A/D or arrows     Jump: SPACE     Restart: R", 300, 575);

  if (playerX + PLAYER_W >= 550) {
    screen = WIN;
    winSound.stop();
    winSound.play();
  }


  if (playerY > height + 100) {
    resetGame();
  }
}

void drawWin() {
  drawSky();

  fill(255, 220, 0);
  textSize(48);
  text("YOU WIN!", 300, 190);

  fill(255);
  textSize(28);
  text("Coins collected: " + score + " / " + coins.length, 300, 275);

  drawButton(200, 365, 200, 60, "PLAY AGAIN");
  drawButton(200, 455, 200, 60, "MAIN MENU");
}

void drawSky() {
  background(100, 185, 255);

  noStroke();
  fill(255);
  ellipse(100, 95, 65, 35);
  ellipse(130, 90, 65, 45);
  ellipse(160, 98, 65, 32);

  ellipse(410, 145, 65, 35);
  ellipse(440, 138, 65, 45);
  ellipse(470, 146, 65, 32);
}

void resetGame() {
  playerX = 35;
  playerY = 480;
  velocityY = 0;
  onGround = false;
  score = 0;

  for (int i = 0; i < coins.length; i++) {
    coins[i][2] = 0;
  }
}

void mousePressed() {
  if (screen == MENU) {
    if (mouseX >= 200 && mouseX <= 400 &&
        mouseY >= 210 && mouseY <= 270) {
      resetGame();
      screen = GAME;
    } else if (mouseX >= 200 && mouseX <= 400 &&
               mouseY >= 305 && mouseY <= 365) {
      screen = SETTINGS;
    } else if (mouseX >= 200 && mouseX <= 400 &&
               mouseY >= 400 && mouseY <= 460) {
      exit();
    }
  } else if (screen == SETTINGS) {
    if (mouseX >= 200 && mouseX <= 400 &&
        mouseY >= 465 && mouseY <= 525) {
      screen = MENU;
    }
  } else if (screen == WIN) {
    if (mouseX >= 200 && mouseX <= 400 &&
        mouseY >= 365 && mouseY <= 425) {
      resetGame();
      screen = GAME;
    } else if (mouseX >= 200 && mouseX <= 400 &&
               mouseY >= 455 && mouseY <= 515) {
      screen = MENU;
    }
  }
}

void keyPressed() {
  if (key == 'a' || key == 'A' || keyCode == LEFT) {
    movingLeft = true;
  }

  if (key == 'd' || key == 'D' || keyCode == RIGHT) {
    movingRight = true;
  }

  if (screen == GAME &&
      (key == ' ' || keyCode == UP) &&
      onGround) {
    velocityY = jumpPower;
    onGround = false;
    jumpSound.stop();
    jumpSound.play();
  }

  if (screen == GAME && (key == 'r' || key == 'R')) {
    resetGame();
  }

  if (key == ESC) {
    key = 0;
    screen = MENU;
    movingLeft = false;
    movingRight = false;
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
