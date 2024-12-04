class TieFighter implements Particle {
  float x, y, z; // Current position
  float targetX, targetY, targetZ; // Target position to move to
  //movement:
  float speed = 0.01; // Lerping speed
  float theta = 0;
  //modes:
  boolean doABarrelRoll;
  //projectiles
  ArrayList <Projectile> projectiles;
  float lastShotTime = 0;
  float shotInterval = 19000;
  float separationDist =100;
  // draw stuff
  final float circleDiameter = 50;
  final float wingWidth = 75; // Width of the wings
  final float wingHeight = 100; // Height of the wings
  //z axis stuff
  float minZ = -500;
  float maxZ = -1800;
  float zRange = maxZ - minZ;
  float zOffset = zRange / numOfTies;

  //constructor
  TieFighter(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.theta = 0;
    this.doABarrelRoll = false;
    projectiles = new ArrayList<Projectile>();
    lastShotTime = random(1, 9500);
    setNewTarget();
  }
  // fire a projectile from current position to the given position (usually player position)
  void shoot(float targetX, float targetY, float targetZ) {
    //do an animation when shooting:
    this.doABarrelRoll = true;
    // these projectiles have a life span in time
    if (time > 100) {
      float projectileSpeed = 5;
      projectiles.add(new Projectile(x, y, z, targetX, targetY, targetZ, projectileSpeed, #23E831, false));
    }
  }

  //ya i know...
  void update() {
    update(redFive.x, redFive.y, redFive.z);
  }
  //the real update
  void update(float enemyX, float enemyY, float enemyZ) {
    x = lerp(x, targetX, speed);
    y = lerp(y, targetY, speed);
    z = lerp(z, targetZ, speed);
    //constantly move
    if (dist(x, y, z, targetX, targetY, targetZ) < 5) {
      setNewTarget();
    }
    // Separation logic to avoid getting too close to other Tie Fighters
    for (Particle other : drawables) {
      if (other instanceof TieFighter && other != this) {
        float distance = dist(x, y, z, other.getX(), other.getY(), other.getZ());
        if (distance < separationDist) {
          float repulsion =(separationDist -distance)/separationDist;
          x += (x - other.getX()) * repulsion;
          y += (y - other.getY()) * repulsion;
          z += (z - other.getZ()) * repulsion;
        }
      }
    }
    //update projectiles
    for (int i = projectiles.size() - 1; i >= 0; i--) {
      Projectile p = projectiles.get(i);
      p.update();
      if (p.isOffScreen()) {
        projectiles.remove(i);
      }
    }
    // shoot again?
    if (millis() - lastShotTime > shotInterval * random(.5, 2.1)) {
      shoot(enemyX, enemyY, enemyZ);
      lastShotTime = millis();
    }
  }

  //select new target to move to
  void setNewTarget() {
    targetX = random(-width/2, width/2);
    targetY = random(-height/2, height/2);
    targetZ = minZ + zOffset * tieFighters.size() + random(-zOffset / 2, zOffset / 2);
  }

  //draw
  void display() {
    pushMatrix();
    translate(x, y, z);

    //barrel roll logic "animation"
    if (doABarrelRoll) {
      doABarrelRoll();
    }
    if (theta >= TWO_PI) {
      theta = 0;
      doABarrelRoll = false;
    }

    // Draw the cockpit
    fill(0);
    strokeWeight(2);
    ellipse(0, 0, circleDiameter, circleDiameter);
    noFill();

    // Draw the white lines on the circle to make the * symbol
    stroke(255);
    line(-circleDiameter/2, 0, circleDiameter/2, 0); // Horizontal line
    line(0, -circleDiameter /2, 0, circleDiameter/2); // Vertical line
    line(-circleDiameter/2 *0.707, -circleDiameter/2 *0.707,
      circleDiameter/2 *0.707, circleDiameter/2 *0.707); // Diagonal line top-left to bottom-right
    line(-circleDiameter /2 *0.707, circleDiameter /2 *0.707,
      circleDiameter/2 *0.707, -circleDiameter/2 *0.707); // Diagonal line bottom-left to top-right


    //texture mapping:
    float u1 = 40.0 / 200;
    float v1 = 20.0 / 200;
    float u2 = 160.0 / 200;
    float v2 = 180.0 / 200;

    // Left wing
    noFill();
    noStroke();
    pushMatrix();
    translate(-circleDiameter /2, 0, 0);
    rotateY(HALF_PI);
    beginShape();
    texture(TieWingTexture);
    vertex(-wingHeight/2, -wingWidth/2, 0, u1, v1);
    vertex(wingHeight/2, -wingWidth/2, 0, u2, v1);
    vertex(wingHeight/2, wingWidth/2, 0, u2, v2);
    vertex(-wingHeight/2, wingWidth/2, 0, u1, v2);
    endShape(CLOSE);
    popMatrix();

    // Right wing
    pushMatrix();
    translate(circleDiameter / 2, 0, 0);
    rotateY(HALF_PI);
    beginShape();
    texture(TieWingTexture);
    vertex(-wingHeight/2, -wingWidth/2, 0, u1, v1);
    vertex(wingHeight/2, -wingWidth/2, 0, u2, v1);
    vertex(wingHeight/2, wingWidth/2, 0, u2, v2);
    vertex(-wingHeight/2, wingWidth/2, 0, u1, v2);
    endShape(CLOSE);
    popMatrix();
    //end draw tie Fighter
    popMatrix();
    //display projectiles:
    for (Projectile p : projectiles) {
      p.display();
    }
  }

  //getters
  public float getX() {
    return x;
  }
  public float getY() {
    return y;
  }
  public float getRadius() {
    return circleDiameter/2;
  } // Radius of the bounding sphere
  public float getZ() {
    return z;
  }
  //collision check:
  public boolean checkCollision(Particle other) {
    return false;
  }
  //other:
  public void explosion() {
    //idk. thinking about a special explosion for tie fighters. will get to it if I get to it
  }
  void doABarrelRoll() {
    theta+= .05;
    rotateZ(theta);
  }
}
