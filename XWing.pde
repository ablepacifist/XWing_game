class XWing implements Particle {
  float x, y, z; // Position
  ArrayList <Projectile> projectiles;  //projectiles
  //Modes:
  private boolean duelFire; // shoot from two laser cannons at once
  private boolean s_foils; // lock the s_foils, changes the position of the laser cannons
  private boolean topShoot; // change what laser cannon shoots next
  // for drawing
  final float boxWidth = 50;
  final float boxHeight = 50;
  final float wingLength = 75;
  final float wingOffset = 15;
  final float circleDiameter = 15;

  float leftWingEdgeX;
  float rightWingEdgeX;
  float wingTop;
  float wingBottom;
  float wingEdgeY_top;
  float wingEdgeY_bottom;
  float lockedPosition;

  //constructor
  XWing(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    projectiles = new ArrayList<Projectile>();
    topShoot = false;
    duelFire = false;
    //s_foils... ya I know its a mess
    wingEdgeY_bottom =  -boxHeight / 2 - wingOffset;
    wingEdgeY_top = boxHeight / 2 + wingOffset;
    rightWingEdgeX =(-boxWidth / 2 - wingLength);
    leftWingEdgeX =boxWidth / 2 + wingLength;
    wingTop = wingEdgeY_top;
    wingBottom =wingEdgeY_bottom;
    lockedPosition = (wingTop/wingBottom) /2;
    s_foils = false;
  }
  // spawn projectile based on current mode
  void shoot() {
    // note: these projectiles dont have lifespan but are limited in range. they will be pruned elsewhere
    float projectileSpeed = 10;
    if (!s_foils) {
      float shootOffset;
      if (topShoot) {
        shootOffset =wingOffset*3;
        this.topShoot = false;
      } else {
        shootOffset =-wingOffset *3;
        this.topShoot = true;
      }
      if (duelFire) {
        projectiles.add(new Projectile(x+boxWidth+(wingLength/2), y+shootOffset, z, x, y+1, z-1000, projectileSpeed, #DB1D1D, true));
        projectiles.add(new Projectile(x-boxWidth-(wingLength/2), y+shootOffset, z, x, y+1, z-1000, projectileSpeed, #DB1D1D, true));
      } else {
        projectiles.add(new Projectile(x, y, z, x, y+1, z-1000, projectileSpeed, #DB1D1D, true));
      }
    } else {
      if (duelFire) {
        projectiles.add(new Projectile(x+boxWidth+(wingLength/2), y+lockedPosition, z, x, y+1, z-1000, projectileSpeed, #DB1D1D, true));
        projectiles.add(new Projectile(x-boxWidth-(wingLength/2), y-lockedPosition, z, x, y+1, z-1000, projectileSpeed, #DB1D1D, true));
      } else {
        projectiles.add(new Projectile(x, y, z, x, y+1, z-1000, projectileSpeed, #DB1D1D, true));
      }
    }
  }
  //update object (not movement)
  void update() {
    //update projectiles
    for (int i = projectiles.size() -1; i>= 0; i--) {
      Projectile p = projectiles.get(i);
      p.update();
      if (p.isOffScreen()) {
        projectiles.remove(i);
      }
    }
    //s_foils animation
    if (s_foils) {
      wingEdgeY_top = lerp(wingEdgeY_top, lockedPosition, .1);
      wingEdgeY_bottom = lerp(wingEdgeY_bottom, lockedPosition, .1);
    } else {
      wingEdgeY_top = lerp(wingEdgeY_top, wingTop, .1);
      wingEdgeY_bottom = lerp(wingEdgeY_bottom, wingBottom, .1);
    }
  }
  // draw
  void display() {
    noStroke();
    pushMatrix();
    translate(x, y, z);

    // Draw the XWing body
    fill(128);
    beginShape();
    texture(XWingTexture);
    vertex(-boxWidth/2, -boxHeight/2, 0, 0.1, 0.8); // Bottom-left
    vertex(boxWidth/2, -boxHeight/2, 0, 0.9, 0.8);  // Bottom-right
    vertex(boxWidth/2, boxHeight/2, 0, 0.9, 0.1);   // Top-right
    vertex(-boxWidth/2, boxHeight/2, 0, 0.1, 0.1);  // Top-left
    endShape(CLOSE);
    noFill();

    // Draw right side wings
    //bottom
    beginShape();
    texture(XWingTexture);
    vertex(-boxWidth/2, -boxHeight/2, 0, 0.1, 0.8); // Bottom-left of box
    vertex(rightWingEdgeX, wingEdgeY_bottom, 0, 0.05, 0.95); // Far-left bottom
    vertex(-boxWidth / 2, 0, 0, 0.1, 0.4); // Mid-left
    endShape(CLOSE);
    //top
    beginShape();
    texture(XWingTexture);
    vertex(-boxWidth/2,boxHeight/2, 0, 0.1, 0.4); // Top-left of box
    vertex(rightWingEdgeX, wingEdgeY_top, 0, 0.05, 0.95); // Far-left top
    vertex(-boxWidth / 2, 0, 0, 0.1, 0.8); // Mid-left
    endShape(CLOSE);

    // Draw left side wings
    //bottom
    beginShape();
    texture(XWingTexture);
    vertex(boxWidth / 2, -boxHeight / 2, 0, 0.1, 0.8); // Bottom-right of box
    vertex(leftWingEdgeX, wingEdgeY_bottom, 0, 0.05, 0.95); // Far-right bottom
    vertex(boxWidth / 2, 0, 0, 0.1, 0.4); // Mid-right
    endShape(CLOSE);
    //top
    beginShape();
    texture(XWingTexture);
    vertex(boxWidth / 2, boxHeight / 2, 0, 0.1, 0.8); // Top-right of box
    vertex(leftWingEdgeX, wingEdgeY_top, 0, 0.05, 0.95); // Far-right top
    vertex(boxWidth / 2, 0, 0, 0.1, 0.4); // Mid-right
    endShape(CLOSE);

    // Draw the four exhaust ports
    fill(255, 165, 0); // Orange color

    ellipse(-boxWidth / 2, -boxHeight / 2, circleDiameter, circleDiameter); // Bottom-left
    ellipse(boxWidth / 2, -boxHeight / 2, circleDiameter, circleDiameter);  // Bottom-right
    ellipse(boxWidth / 2, boxHeight / 2, circleDiameter, circleDiameter);   // Top-right
    ellipse(-boxWidth / 2, boxHeight / 2, circleDiameter, circleDiameter);  // Top-left

    //draw laser cannons:
    // i didnt do thing because my crappy design actually looks better without them
    fill(#E0CCCC); // color
    //ellipse(boxWidth / 2 + wingLength -10 , -boxHeight / 2 - wingOffset +10/2,circleDiameter/2 ,circleDiameter/2 ); // bottom left cannon

    noFill(); // Disable fill for shapes
    //draw reticle
    drawReticle();
    popMatrix();
    //pew pew
    for (Projectile p : projectiles) {
      p.display();
    }
  }
  //plus reticle. doesnet actually point to where the XWing shoots
  void drawReticle() {
    pushMatrix();
    stroke(#F7E750);
    fill(#F7E750);
    translate(0, height/8, 0);
    beginShape();
    vertex(-1, boxHeight/10, 0); //top-left
    vertex(-1, -boxHeight/10, 0); //  bottom-left
    vertex(1, -boxHeight/10, 0); //bottom-right
    vertex(1, boxHeight/10, 0); //top-right
    endShape();

    beginShape();
    vertex(boxWidth/10, -1, 0);
    vertex(-boxWidth/10, -1, 0);
    vertex(-boxWidth/10, 1, 0);
    vertex(boxWidth/10, 1, 0);

    endShape();
    noFill();
    stroke(255);
    popMatrix();
  }
  //getters/setters
  public float getX() {
    return x;
  }
  public float getY() {
    return y;
  }
  public float getRadius() {
    return 35;
  } // Radius of the bounding sphere
  public float getZ() {
    return z;
  }
  //collision check:
  // using the bounding box method instead of the bounding circle
  public boolean checkCollision(Particle other) {
    // Get the bounds of this
    float minX1 = x -boxWidth/2;
    float maxX1 = x +boxWidth/2;
    float minY1 = y -boxHeight/2;
    float maxY1 = y +boxHeight/2;
    float minZ1 = z -boxWidth/2; // idk, just making something uo
    float maxZ1 = z +boxWidth/2;

    // Get the bounds of the other
    float minX2 = other.getX() - other.getRadius();
    float maxX2 = other.getX() + other.getRadius();
    float minY2 = other.getY() - other.getRadius();
    float maxY2 = other.getY() + other.getRadius();
    float minZ2 = other.getZ() - other.getRadius();
    float maxZ2 = other.getZ() + other.getRadius();

    // Check for overlap in all three axies
    boolean overlapX = minX1 < maxX2 && maxX1 > minX2;
    boolean overlapY = minY1 < maxY2 && maxY1 > minY2;
    boolean overlapZ = minZ1 < maxZ2 && maxZ1 > minZ2;
    if(overlapX && overlapY && overlapZ){
      return true;
    }else{
     return false; 
    }
  }
  //toggle modes:
  public void toggleS_foils() {
    if (s_foils) {
      this.s_foils = false;
    } else {
      this.s_foils=true;
    }
  }
  public boolean getS_foils() {
    return this.s_foils;
  }
  public void toggleFireMode() {
    if (duelFire) {
      this.duelFire = false;
    } else {
      this.duelFire=true;
    }
  }
}
