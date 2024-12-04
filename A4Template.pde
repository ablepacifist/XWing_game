//object lists
XWing redFive; // Luke's call sign
ArrayList<TieFighter> tieFighters;
ArrayList<Particle> drawables; // Implementing z buffer
ArrayList<Particle> toRemove = new ArrayList<Particle>();
ExhaustPorts exhaustPort;
//game logic
int lastRemovalTime;
int time;
boolean gameOver;
boolean stageTwo;
//game play
int numOfTies = 5;
final int stageTime = 180000;
float movementSpeed = 2;
boolean forceIsWithYou = false ; // if true become invincible
int score;
//textures:
 PImage TieWingTexture;
 PImage TrenchTexture;
 PImage XWingTexture;

void setup() {
  System.out.println("begin init...");
  size(600, 600, P3D); // Set the canvas size
  noFill(); // Disable fill for shapes
  stroke(255); // Set stroke color to white
  strokeWeight(2); // Adjusted stroke weight for better visibility
  background(0); // Set background color
  
    // Set the view frustum
   
  float fov = PI / 3.0;
  float aspect = float(width) / float(height);
  float near = 1;
  float far = 10000;
  float top = -(near * tan(fov / 2));
  float bottom = -top;
  float right = top * aspect;
  float left = -right;
  
  // Set the view frustum
  frustum(left, right, bottom, top, near, far);
  
  // Set up the camera
  float cameraX = 0;
  float cameraY = 0;
  float cameraZ = 500; // Camera looking along the z-axis
  float centerX = 0;
  float centerY = 0;
  float centerZ = 0;
  float upX = 0;
  float upY = 1;
  float upZ = 0;

  // Set the camera position
  camera(cameraX, cameraY, cameraZ, centerX, centerY, centerZ, upX, upY, upZ);

  //textures:
      TieWingTexture = loadImage("TieFighterWing.jpg");
        TrenchTexture = loadImage("Trench_wall.jpg");
        XWingTexture = loadImage("textures.png");
    if (TieWingTexture == null || TrenchTexture == null || XWingTexture ==null) {
        println("Texture loading failed!");
    } else {
        println("Texture loaded successfully!");
    }

  textureMode(NORMAL);
  // Init z buffer
  drawables = new ArrayList<Particle>();

  // Init XWing:
  redFive = new XWing(0, 0, 0);
  drawables.add(redFive);

  // Init enemy fighters
  tieFighters = new ArrayList<TieFighter>();
  for (int i = 0; i < numOfTies; i++) {
    float startX = random(width / 2);
    float startY = random(height / 2);
    float startZ = random(-200, -800);
    TieFighter tf = new TieFighter(startX, startY, startZ);
    tieFighters.add(tf);
    drawables.add(tf);
  }

  // Other init
  drawables.add(new Trench());
  exhaustPort = new ExhaustPorts();
  time = 0;
  score = 0;
  stageTwo = false;
  gameOver = false;
  System.out.println("end initialization");
}

void draw() {
  background(200);
noLights();//??
  
  time++;
  background(0); // Clear the background each frame
  updateMovement(redFive);

  // Game logic
  if (!gameOver) {
    displayControls();
    if (!stageTwo) {
      repopulate();
      if (millis() > stageTime && !stageTwo) {// add/sub a zero
        stageTwo = true;
      }
    }else{
     exhaustPort.display();
     exhaustPort.update();
     
    }
//check for explosion pruning:
    for (Particle obj : drawables) {
      if(obj instanceof ExplosionParticle){
        ExplosionParticle lookAt = (ExplosionParticle) obj;
        if(!(lookAt.checkLife())){
          toRemove.add(lookAt);
        }
      }else{// check for objects that have hit the exhaust port wall
       if(exhaustPort != null && !(obj instanceof Trench) &&  exhaustPort.getZ() >= obj.getZ()){
         if(obj instanceof XWing){
           gameOver= true;
         }
         if(!(obj instanceof Projectile)){
           toRemove.add(obj);
         }
       }
      }
    }
    for(Particle obj : toRemove){
      drawables.remove(obj);
    }

    // Execute update order
    for (Particle obj : drawables) {
      obj.update();
    }

    // Add projectiles to zbuffer
    drawables.addAll(redFive.projectiles);
    for (TieFighter tf : tieFighters) {
      drawables.addAll(tf.projectiles);
    }

    // Sort list
    drawables.sort((a, b) -> Float.compare(b.getZ(), a.getZ()));

    // Execute draw order
    for (Particle obj : drawables) {
      obj.display();
    }

    // Check for collisions
      drawables.add(exhaustPort);
    checkCollisions(drawables);

    // Clear projectiles from the drawables list for the next frame
    drawables.removeAll(redFive.projectiles);
    for (TieFighter tf : tieFighters) {
      drawables.removeAll(tf.projectiles);
    }
  } else {
    // game over
        for (Particle obj : drawables) {
      if(obj instanceof Trench || obj instanceof ExplosionParticle){
        obj.update();
          obj.display();
      }
    }
    gameOverDisplay();
  }
  
}
