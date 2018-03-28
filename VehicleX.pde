//Remedy

class VehicleX {
  
  ArrayList<PVector> history = new ArrayList<PVector>();
  
  // All the usual stuff
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  PVector Centre;
  // Constructor initialize all values
  VehicleX( PVector l, PVector centre) {
    
    position = l.get();
    r = 7;
    Centre = centre;
    acceleration = PVector.sub(centre,position);
    float radius = acceleration.mag();
    acceleration.normalize();
    acceleration.mult(0.01);
    
    float ax = acceleration.x;
    float ay = acceleration.y;
    float vx = 1;
    float vy = 1;
    if(ay==0){
      vy = 1;
      vx = 0;
    }
    else{
      vy = (-1*vx*ax)/ay;
    }
    velocity = new PVector(vx,vy);
    velocity.normalize();
    velocity.mult((float)Math.sqrt(radius*acceleration.mag()));
    
  }
  
  void run() {
    update();
    display();
  }
  
  // Method to update position
  void update() {
    
    
    // Update velocity
    velocity.add(acceleration);
    
    // Limit speed
    //velocity.limit(maxspeed);
    
    
    position.add(velocity);
    
    acceleration = PVector.sub(Centre,position);
    acceleration.normalize();
    acceleration.mult(0.01);
    
    
    history.add(position.get());
    if(history.size()>1000){
      history.remove(0);
    }
    
  }
  
  void display() {
    
    /*beginShape();
      stroke(0);
      strokeWeight(1);
      noFill();
      for(PVector v: history) {
        vertex(v.x,v.y);
      }
    endShape();*/
    
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + PI/2;
    fill(111,222,121);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(position.x,position.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
    
    
  }
  
  
  
}
