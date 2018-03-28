//remedy

boolean debug = false;
boolean co = true;
boolean ri = true;

int noOfPaths = 3;
// A path object (series of connected points)
Path paths[] = new Path[noOfPaths];
int xCenter;
int yCenter;
int bigR;
int pathW;
float[][] line;
int compartments;
int compV[];
float theta;
// Two vehicles
ArrayList<VehicleZ> vehicles;

void setup() {
  size(1080, 720);
  xCenter = width / 2;
  yCenter = height / 2;
  compartments = 10;
  compV = new int[compartments];
  theta = 2*PI/compartments;
  //rect1 = new Rectangle(450,560, 200, 100);
  bigR = 300;
  pathW = 25;
  // Call a function to generate new Path object
  int pathR = bigR;
  for(int i =0;i<noOfPaths;i++){
    paths[i] = new Path(pathW);
    //x = new Path();
    newPathCircle(paths[i], pathR);
    pathR -= 2 * pathW;
  }
  //rec(5,5,5,5);
  // We are now making random vehicles and storing them in an ArrayList
  vehicles = new ArrayList<VehicleZ>();
  
  for (int i = 0; i < 1; i++) {
    newVehicle(random(width),random(height),co);
    co = co^true;
  }
}

void drawLine(){
  line = new float[compartments][4];

  for(int i = 0; i < compartments; i++){
    line[i][0] = xCenter + (float)((bigR + pathW) * Math.cos(i * theta));
    line[i][1] = yCenter + (float)((bigR + pathW) * Math.sin(i * theta));
    line[i][2] = xCenter + (float)((bigR - pathW) * Math.cos(i * theta));
    line[i][3] = yCenter + (float)((bigR - pathW) * Math.sin(i * theta));
    line(line[i][0], line[i][1], line[i][2], line[i][3]);
  }
}

int findCompartment(VehicleZ v){
  int compartment = -1;
  float mx = v.position.x - xCenter;
  float my = v.position.y - yCenter;
  PVector tempCenter = new PVector(xCenter,yCenter);
  PVector z = PVector.sub(tempCenter,v.position);
  float dist = z.mag();
  float V_theta = (float)Math.atan2(my,mx);
  if(V_theta<0)V_theta+=2*PI;
  V_theta = 2*PI - V_theta;
  //System.out.print(V_theta + " "+dist+" "+(bigR+pathW)+" "+(bigR-pathW));
      
  if(dist<=(bigR+pathW)&&dist>=(bigR-pathW)){
    for(int i =0; i<compartments; i++){
      float start = i*theta;
      float end = (i+1)*theta;
      
      //System.out.print(start+" "+end+" ");
      if(V_theta<end&&V_theta>=start){
         compartment=i;
      }
      
    }
  }  
  //System.out.println();
  return compartment;
}

void draw() {
  background(255);

  //drawLine();
  // Display the path
  for(Path x:paths)
    x.display();
  
  drawLine();
  
  //int count = 0;
  
  for (VehicleZ v : vehicles) {
    /*int i = v.completeRound/2;
    
    if(v.currentTheta==v.initialTheta){
      v.completeRound++;
    }*/
    v.compartmentNo = findCompartment(v);
    Path pathx = paths[0];
    // Path following and separation are worked on in this function
    v.applyBehaviors(vehicles,pathx);
    // Call the generic run method (update, borders, display, etc.)
    v.run();
  }
  // Instructions
  fill(0);
  textAlign(CENTER);
  text(vehicles.get(0).completeRound+" "+vehicles.get(0).compartmentNo,width/2,height-20);

}
void newPathCircle(Path path, float radius){
  //path = new Path();
  float centreX = width/2;
  float centreY = height/2;
  int n = 360;
  float fact = (2*3.14)/n;
  for(int i= 0;i<n;i++){
    float dx = (float)(radius*Math.cos(i*fact));
    float dy = (float)(radius*Math.sin(i*fact));
    
    path.addPoint(centreX+dx,centreY+dy);
  }
}
void newSquarePath(Path path) {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
  path = new Path(pathW);
  float offset = 75;
  path.addPoint(offset,offset);
  path.addPoint(width-offset,offset);
  path.addPoint(width-offset,height-offset);
  path.addPoint(offset,height-offset);
}

void newVehicle(float x, float y, boolean co) {
  float maxspeed = random(2,4);
  float maxforce = 0.3;
  
  vehicles.add(new VehicleZ(new PVector(x,y),maxspeed,maxforce,co));
}

void keyPressed() {
  if (key == 'd') {
    debug = !debug;
  }
  if (key =='r' ){
    vehicles = new ArrayList<VehicleZ>();
    newVehicle(random(width),random(height),co);
  }
}

void mousePressed() {
  newVehicle(mouseX,mouseY,co);
  co = co^true;
}
