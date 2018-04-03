//remedy

class VehicleZ {
  
  int colors[][] = {
  {0,255,0},
  {255,0,0},
  {0,0,255},
  {255,255,0},
  {255,0,255},
  {0,255,255},
  {45,46,47},
  {87,78,89},
  {67,34,34},
  {76,56,43},
  };
  // All the usual stuff
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  int groupId;
  int currCompartment;
  int oldCompartment;
    // Constructor initialize all values
  VehicleZ( PVector l, float ms, float mf, int gid) {
    
    position = l.get();
    r = 6;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    currCompartment = 0;
    oldCompartment = 0;
    
    groupId = gid;
  }

  // A function to deal with path following and separation
  void applyBehaviors(ArrayList vehicles, int radii[]) {
    
    //Goal Force
    PVector f1 = new PVector(0,0);
    if(random(1,10)<3)
      f1 = goalF();
    //Wall Force
    PVector f2 = wallF(radii[0],radii[1]);
    
    // Separate from other boids force
    PVector s = separate(vehicles);
    
    //Weightage of each force
    f1.mult(1);
    f2.mult(2);
     s.mult(1);
    
    //Apply each Force
    applyForce(f1);
    applyForce(f2);
    applyForce(s);
    
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }



  // Main "run" function
  public void run() {
    update();
    render();
  }


  PVector goalF(){
    PVector force;
    PVector center = new PVector(width/2,height/2);
    PVector forceC = PVector.sub(center,position);
    float cRadius = forceC.mag();
    forceC.normalize();
    PVector forceT = forceC;
    forceT.rotate(HALF_PI);
    float factor = (float)Math.sqrt((maxspeed*maxspeed)/2.0*cRadius);
    forceC.mult(factor);
    forceT.mult(factor);
    force = PVector.add(forceC,forceT);
    return force;
  }
  
  PVector wallF(float inner, float outer){
    PVector force = new PVector(0,0);
    PVector center = new PVector(width/2,height/2);
    PVector dir = PVector.sub(center,position);
    float dist = dir.mag();
    if(dist>=outer){
      force = dir;
    }
    else if(dist<=inner){
      dir.rotate(PI);
      force = dir;
    }
    return force;
  }
  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList boids) {
    float desiredseparation = r*2;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (int i = 0 ; i < boids.size(); i++) {
      VehicleZ other = (VehicleZ) boids.get(i);
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }


  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void render() {
    // Simpler boid is just a circle
    fill(colors[groupId][0],colors[groupId][1],colors[groupId][2]);
    stroke(0);
    pushMatrix();
    translate(position.x, position.y);
    ellipse(0, 0, r, r);
    popMatrix();
  }
}
