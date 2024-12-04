class ExplosionParticle implements Particle {
  float x, y, z;
  float xSpeed, ySpeed, zSpeed;
  float lifespan;
  color pColor;

  ExplosionParticle(float x, float y, float z, float xSpeed, float ySpeed, float zSpeed, color pColor) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.xSpeed = xSpeed;
    this.ySpeed = ySpeed;
    this.zSpeed = zSpeed;
    this.pColor = pColor;
    this.lifespan = random(50, 255); // Varied lifespan
  }

  void update() {
    x += xSpeed;
    y += ySpeed;
    z += zSpeed;
    lifespan -= 5;
  }
  void display() {
    noStroke();
    fill(pColor, lifespan);
    pushMatrix();
    translate(x, y, z);
    sphere(2); // Draw particle
    popMatrix();
  }
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

  boolean checkCollision(Particle other) {
    return false;
  }
  
  //other:
    boolean isDead() {
    return lifespan < 0;
  }
    public boolean checkLife() {
    if (isDead()) {
      return false;
    } else
    return true;
  }
}
