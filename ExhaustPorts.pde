class ExhaustPorts implements Particle{
  float x,y,z; //port position
  float diameter= 2*5; // the exhaust ports are only two meters wide... bigger than the womp rats back home
  ExhaustPorts(){
    this.x = 0;
    this.y = 0;
    this.z = -38880;
  }
  
  void update(){
    if(this.z < -10000){
this.z = lerp(this.z,redFive.z+50,.005);
    }else{
     this.z+=3 ;
    }
  }
  void display(){
    pushMatrix();
strokeWeight(2);
fill(#B7B1B1);
translate(x,y,z);
    //draw wall
    beginShape();
    texture(TrenchTexture);
    vertex(-width/2, -height/2, 0, 0, 0); // Bottom-left
    vertex(width/2, -height/2, 0, 1, 0);  // Bottom-right
    vertex(width/2, height/2, 0, 1, 1);   // Top-right
    vertex(-width/2, height/2, 0, 0, 1);  // Top-left
    endShape(CLOSE);
    //draw the port itself
    translate(0,0,1);
    sphere(diameter*2);
    fill(0);
    translate(0,0,10);
    sphere(diameter*2/1.2);
     popMatrix();
     noStroke();
  }
  float getX(){
    return this.x;
  }
  float getY(){
    return this.y;
  }
  float getZ(){
    return this.z;
  }
  float getRadius(){
    return this. diameter;
  }//bounding sphere
  // Check collision with another particle
  boolean checkCollision(Particle other){
    if(other instanceof XWing && this.z == redFive.z){
      return true;
    }
    if (other instanceof ExhaustPorts) {
      return false; //prevent hitting parent self
    }
    float distance = dist(x, y, z, other.getX(), other.getY(), other.getZ());
    return distance < (this.getRadius() + other.getRadius());
  }
}
