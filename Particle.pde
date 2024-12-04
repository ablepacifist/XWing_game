interface Particle {
  void update();
  void display();
  float getX();
  float getY();
  float getZ();
  float getRadius(); //bounding sphere
  boolean checkCollision(Particle other); // Check collision with another particle
}
