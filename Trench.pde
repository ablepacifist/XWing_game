class Trench implements Particle{
int trenchLength = 200; // Length of each trench segment
int numSegments = 10; // Number of trench segments
float trenchPosition = 0; // Separate variable for trench position
float floorSpace = width/2;
float wallHeight = height/2;
// this is called old because I wanted to make it in NDC
// but i had a hard time with that so we'll stick with this
void update(){
    //move trench
  trenchPosition += 3;
}
void display() {
  noFill();

  // loop trench
  if (trenchPosition >= numSegments * trenchLength/2) {
    trenchPosition = 0;
  }

  // Translate the trench backward to simulate movement
  pushMatrix();
  translate(0, 0, trenchPosition);

  // Draw the trench
  noStroke();
  for (int i = -2000; i < numSegments * trenchLength; i += trenchLength) {
    float z = i;
    pushMatrix();
    translate(0, 0, z);

    // Draw floor
    beginShape();
    texture(TrenchTexture);
    vertex(-floorSpace, -floorSpace, 2, 0, 0);
    vertex(floorSpace, -floorSpace, 2, 1, 0);
    vertex(floorSpace, -floorSpace, trenchLength, 1, 1);
    vertex(-floorSpace, -floorSpace, trenchLength, 0, 1);
    endShape(CLOSE);

    // Draw left wall
    beginShape();
    texture(TrenchTexture);
    vertex(-floorSpace, wallHeight, 0, 0,0);
    vertex(-floorSpace, -floorSpace, 0, 1,0);
    vertex(-floorSpace, -floorSpace, trenchLength, 1,1);
    vertex(-floorSpace, wallHeight, trenchLength, 0,1);
    endShape(CLOSE);

    // Draw right wall
    beginShape();
    texture(TrenchTexture);
    vertex(floorSpace, wallHeight, 0, 0,0);
    vertex(floorSpace, -floorSpace, 0, 1,0);
    vertex(floorSpace, -floorSpace, trenchLength, 1,1);
    vertex(floorSpace, wallHeight, trenchLength, 0,1);
    endShape(CLOSE);
    popMatrix();
  }
  popMatrix();
}

//all dummy functions
public float getY(){
  return 88888;
}
public float getX(){
  return 88888;
}
public float getZ(){
 return -88888; 
}
float getRadius(){
 return 0; 
}
boolean checkCollision(Particle other){
 return false; 
}
}

    /*
    // Draw extending floor from top of left wall
     beginShape();
     vertex(width/3, height/2 - width/3, 0);
     vertex(-width/3, height/2 - width/3, 0);
     vertex(-width/3, height /2- width/3, trenchLength);
     vertex(width/3, height/2 - width/3, trenchLength);
     endShape(CLOSE);
     
     // Draw extending floor from top of right wall
     beginShape();
     vertex(width*1.5, height/2 - width/3, 0);
     vertex(width+ width/3, height/2 - width/3, 0);
     vertex(width+ width/3, height/2 - width/3, trenchLength);
     vertex(width*1.5, height/2 - width/3, trenchLength);
     endShape(CLOSE);
     */
