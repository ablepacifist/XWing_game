
//collision logic
void checkCollisions(ArrayList<Particle> particles) {
  for (int i = 0; i < particles.size(); i++) {
    Particle p1 = particles.get(i);
    for (int j = i + 1; j < particles.size(); j++) {
      Particle p2 = particles.get(j);
      if (p1.checkCollision(p2)) {
        // will also check and kill tieFighters
        String type1 = identifyParticle(p1);
        String type2 = identifyParticle(p2);
        // projectile on projectile
        if (p1 instanceof Projectile && p2 instanceof Projectile) {
          removeProjectile((Projectile) p1);
          removeProjectile((Projectile) p2);
          drawables.remove(p1);
          drawables.remove(p2);
        }
        //projectile on XWing
        if (p1 instanceof XWing) {
          if (p1.checkCollision(p2) && (p2 instanceof Projectile)) {
            if (!forceIsWithYou && !((Projectile) p2).isPlayer) {
              gameOver = true;
              println("Collision detected between " + type1 + " at index " + i + " and " + type2 + " at index " + j);
              createExplosion(p2.getX(), p2.getY(), p2.getZ());
            }
          }
          //projectile on exhaust port
        }else if(p2 instanceof ExhaustPorts){
             println("Collision detected between " + type1 + " at index " + i + " and " + type2 + " at index " + j);
            playExplosionGif();
           gameOver = true;
           score +=10;
        }else {
         // println("Collision detected between " + type1 + " at index " + i + " and " + type2 + " at index " + j);
          //collision
        }
      }
    }
  }
}
// figure out which class they belong to
String identifyParticle(Particle p) {
  if (p instanceof XWing) {
    //gameOver = true;
    return "XWing";
  } else if (p instanceof TieFighter) {
    tieFighters.remove(p);
    drawables.remove(p);
    score++;
    createExplosion(p.getX(), p.getY(), p.getZ());
    lastRemovalTime = millis();
    return "TieFighter";
  } else if (p instanceof Projectile) {
    return "Projectile";
  } else if(p instanceof ExhaustPorts){
    return "exhaustPort";
  } else if(p instanceof Trench){
    return "trench";
  }  else{
    return "Unknown Particle";
  }
}
// look for who the projectile belongs and remove it
void removeProjectile(Projectile p) {
  if (p.isPlayer) {
    redFive.projectiles.remove(p);
  } else {
    for (TieFighter tie : tieFighters) {
      tie.projectiles.remove(p);
    }
  }
}
// control the number of enemies
void repopulate() {
  if (time % 10 ==0) {
    numOfTies++;
  }
  if ((millis() - lastRemovalTime) > 2000 && tieFighters.size() < numOfTies) {
    float startX = random(width);
    float startY = random(height);
    float startZ = random(-200, -800);
    TieFighter tf = new TieFighter(startX, startY, startZ);
    tieFighters.add(tf);
    drawables.add(tf);
    lastRemovalTime = millis();
  }
}

//explosion creattion and execution
void createExplosion(float x, float y, float z) {
  if (TOGGLE_EXPLOSIONS) {
    int numParticles = 100; // Number of particles
    for (int i = 0; i < numParticles; i++) {
      float angle = random(TWO_PI);
      float speed = random(1, 5);
      float xSpeed = cos(angle) * speed;
      float ySpeed = sin(angle) * speed;
      float zSpeed = random(-2, 2);
      ExplosionParticle e =new ExplosionParticle(x, y, z, xSpeed, ySpeed, zSpeed, color(255));
      drawables.add(e);
    }
  }
}

//game over :(
void gameOverDisplay() {
  pushMatrix();
  rotate(PI);
  fill(255, 0, 0);
  textSize(50);
  text("GAME OVER", -50, 0, -100);
  fill(255);
  textSize(30);
  text("Score: " + score, -50, 0 + 60, -100);
  popMatrix();
}
//if you destroyed the death star:
void playExplosionGif(){
  createExplosion(0,0,-300);
}
// print/display what the hotkeys are
//also current time
void displayControls() {
  float locX =  width/2- 220;
  float locY = -height/2 - 20;
  float heightOffSet = 20;
  pushMatrix();
  rotate(PI);
  fill(255);
  textSize(20);
  text("Time:"+ time/10, width/2-60, locY, -100);
  text("additional hotkeys:", locX- 220, locY, -100);
  text("\'f\' to toggle fire mode", locX- 220, locY + heightOffSet, -100);
  text("\'e\' to toggle explosions on/off", locX- 220, locY + 2*heightOffSet, -100);
  text("\'t\' to lock s-foils ", locX- 220,  locY + 3*heightOffSet, -100);
   text("\'p\' to become invincible ", locX- 220,  locY + 4*heightOffSet, -100);
  popMatrix();
}
// player movement
void updateMovement(XWing xwing) {
  float speed = movementSpeed;
  if (xwing.getS_foils()) {
    speed = movementSpeed*2;
  }
  float halfBoxWidth = xwing.boxWidth / 2;
  float halfBoxHeight = xwing.boxHeight / 2;

  if (moveLeft && xwing.x + halfBoxWidth < width / 2) {
    xwing.x += speed;
  }
  if (moveRight && xwing.x - halfBoxWidth > -width / 2) {
    xwing.x -= speed;
  }
  if (moveUp && xwing.y - halfBoxHeight > -height / 2) {
    xwing.y -= speed;
  }
  if (moveDown && xwing.y + halfBoxHeight < height / 2) {
    xwing.y += speed;
  }
  if (moveLeft && moveUp && xwing.x + halfBoxWidth < width / 2 && xwing.y - halfBoxHeight > -height / 2) {
    xwing.x += speed / 2;
    xwing.y -= speed / 2;
  }
  if (moveLeft && moveDown && xwing.x + halfBoxWidth < width / 2 && xwing.y + halfBoxHeight < height / 2) {
    xwing.x += speed / 2;
    xwing.y += speed / 2;
  }
  if (moveRight && moveUp && xwing.x - halfBoxWidth > -width / 2 && xwing.y - halfBoxHeight > -height / 2) {
    xwing.x -= speed / 2;
    xwing.y -= speed / 2;
  }
  if (moveRight && moveDown && xwing.x - halfBoxWidth > -width / 2 && xwing.y + halfBoxHeight < height / 2) {
    xwing.x -= speed / 2;
    xwing.y += speed / 2;
  }
}
