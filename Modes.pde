// Player character controls
final char KEY_LEFT = 'a';
final char KEY_RIGHT = 'd';
final char KEY_UP = 'w';
final char KEY_DOWN = 's';
final char KEY_SHOOT = ' ';
final char KEY_TOGGLE_FIRE_MODE = 'f';
final char KEY_TOGGLE_EXPLOSION = 'e';
final char KEY_TOGGLE_S_FOILS = 't';
final char KEY_TOGGLE_THE_FORCE = 'p';

// Toggle textures or collisions - useful for testing and debugging
final char KEY_TEXTURE = 't';
final char KEY_COLLISION = 'c';

boolean doTextures = false;
boolean doCollision = false;

// Movement booleans for player character
boolean moveLeft = false;
boolean moveRight = false;
boolean moveUp = false;
boolean moveDown = false;
boolean moveLeftUp = false;
boolean moveLeftDown = false;
boolean moveRightUp = false;
boolean moveRightDown = false;
//other
boolean TOGGLE_EXPLOSIONS = false;

void keyPressed() {
  if (key == KEY_TOGGLE_THE_FORCE) {
    if (forceIsWithYou) {
      forceIsWithYou =false;
    } else {
      forceIsWithYou = true;
    }
  }
  //toggle s_foils
  if (key == KEY_TOGGLE_S_FOILS) {
    redFive.toggleS_foils();
  }
  //toggle fire mode
  if (key == KEY_TOGGLE_FIRE_MODE) {
    redFive.toggleFireMode();
  }
  //toggle explosions
  if (key == KEY_TOGGLE_EXPLOSION) {
    if (TOGGLE_EXPLOSIONS) {
      TOGGLE_EXPLOSIONS =false;
    } else {
      TOGGLE_EXPLOSIONS = true;
    }
  }
  //movements keys
  if (key == KEY_LEFT) {
    moveLeft = true;
  }
  if (key == KEY_RIGHT) {
    moveRight = true;
  }
  if (key == KEY_UP) {
    moveUp = true;
  }
  if (key == KEY_DOWN) {
    moveDown = true;
  }
  if (key == KEY_LEFT && key == KEY_UP) {
    moveLeftUp = true;
  }
  if (key == KEY_LEFT && key == KEY_DOWN) {
    moveLeftDown = true;
  }
  if (key == KEY_RIGHT && key == KEY_UP) {
    moveRightUp = true;
  }
  if (key == KEY_RIGHT && key == KEY_DOWN) {
    moveRightDown = true;
  }
  if (key == ' ') {
    redFive.shoot();
  }
}

void keyReleased() {
  if (key == KEY_LEFT) {
    moveLeft = false;
  }
  if (key == KEY_RIGHT) {
    moveRight = false;
  }
  if (key == KEY_UP) {
    moveUp = false;
  }
  if (key == KEY_DOWN) {
    moveDown = false;
  }
  if (key == KEY_LEFT && key == KEY_UP) {
    moveLeftUp = false;
  }
  if (key == KEY_LEFT && key == KEY_DOWN) {
    moveLeftDown = false;
  }
  if (key == KEY_RIGHT && key == KEY_UP) {
    moveRightUp = false;
  }
  if (key == KEY_RIGHT && key == KEY_DOWN) {
    moveRightDown = false;
  }
}
