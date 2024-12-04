class Projectile implements Particle {
  float x, y, z;
  float speed;
  float dirX, dirY, dirZ;
  color pColor;
  int lifeSpan;
  int beamLength = 50;
  boolean isPlayer;

  //construction
  Projectile(float x, float y, float z, float targetX, float targetY, float targetZ, float speed, int pColor, boolean isPlayer) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.speed = speed;
    this.pColor = pColor;
    this.lifeSpan = 0;
    this.isPlayer = isPlayer;

    // Calculate direction vector
    float dist = dist(targetX, targetY, targetZ, x, y, z);
    this.dirX = (targetX - x) / dist;
    this.dirY = (targetY - y) / dist;
    this.dirZ = (targetZ - z) / dist;
  }

  void update() {
    x += dirX * speed;
    y += dirY * speed;
    z += dirZ * speed;
    lifeSpan++;
    //testing:
    // println("X:"+x+", Y:"+y+", Z:"+z);
  }

  void display() {
    pushMatrix();
    translate(x, y, z);
    noStroke();
    fill(pColor+ (100-lifeSpan %100));
    //draw for xwing or tiefighter
    if (isPlayer) {
      //Xwing
      drawRectProj();
    } else {
      //TieFighter
      sphere(5+2* sin(radians(lifeSpan*10)));
    }
    popMatrix();
    stroke(255);
    strokeWeight(2); 
  }
  
  //getters
  public float getX() {
    return x;
  }
  public float getY() {
    return y;
  }
  public float getRadius() {
    return 5;
  } // Radius of the bounding sphere
  public float getZ() {
    return z;
  }
  //collision check:
  public boolean checkCollision(Particle other) {
    if (other instanceof XWing && isPlayer) {
      return false; // prevent collision with the parent XWing
    } else if (other instanceof TieFighter && !isPlayer) {
      return false; // prevent collision with the parent TieFighter
    }
    float distance = dist(x, y, z, other.getX(), other.getY(), other.getZ());
    return distance < (this.getRadius() + other.getRadius());
  }

// draw xwing projectile
private void drawRectProj() {
  fill(pColor);
  float size = 9+2* sin(radians(lifeSpan*10));
  // Draw the 3D beam using vertices
  float halfSize = size/2;

  beginShape(QUADS);
  // Front face
  vertex(-halfSize, -halfSize, 0);
  vertex(halfSize, -halfSize, 0);
  vertex(halfSize, halfSize, 0);
  vertex(-halfSize, halfSize, 0);
  // Back face
  vertex(-halfSize, -halfSize, -beamLength);
  vertex(halfSize, -halfSize, -beamLength);
  vertex(halfSize, halfSize, -beamLength);
  vertex(-halfSize, halfSize, -beamLength);
  // Top face
  vertex(-halfSize, -halfSize, 0);
  vertex(halfSize, -halfSize, 0);
  vertex(halfSize, -halfSize, -beamLength);
  vertex(-halfSize, -halfSize, -beamLength);
  // Bottom face
  vertex(-halfSize, halfSize, 0);
  vertex(halfSize, halfSize, 0);
  vertex(halfSize, halfSize, -beamLength);
  vertex(-halfSize, halfSize, -beamLength);
  // Left face
  vertex(-halfSize, -halfSize, 0);
  vertex(-halfSize, halfSize, 0);
  vertex(-halfSize, halfSize, -beamLength);
  vertex(-halfSize, -halfSize, -beamLength);
  // Right face
  vertex(halfSize, -halfSize, 0);
  vertex(halfSize, halfSize, 0);
  vertex(halfSize, halfSize, -beamLength);
  vertex(halfSize, -halfSize, -beamLength);
  endShape();
}

// returns true if off the screen
boolean isOffScreen() {
  return x < -width || x > width || y < -height || y > height || z < -1890 || z > 1800;
}
}
