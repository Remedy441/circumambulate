//remedy
import java.util.*;
boolean debug = false;

int noOfPaths = 3;
// A path object (series of connected points)
Path paths[] = new Path[noOfPaths];
int xCenter;
int yCenter;
int bigR;
int pathW;
int pathDel;
float[][] line;
int compartments;
int compVC[];
float theta;
int humans;
int time;
PVector ENTRY,EXIT;
// Two vehicles
ArrayList<VehicleZ> vehicles;

void setup() {
  size(1080, 720);
  
  xCenter = width / 2;
  yCenter = height / 2;
  
  compartments = 10;
  compVC = new int[compartments];
  theta = 2*PI/compartments;
  
  bigR = 300;
  pathW = 40;
  pathDel =5;
  // Call a function to generate new Path object
  int pathR = bigR;
  for(int i =0;i<noOfPaths;i++){
    paths[i] = new Path(pathW);
    newPathCircle(paths[i], pathR);
    pathR -= 2 * pathW;
    pathR -= pathDel;
  }
  
  
  ENTRY = new PVector(xCenter-bigR,yCenter-bigR);
  EXIT = new PVector(xCenter+bigR,yCenter+bigR);
  
  
  // We are now making random vehicles and storing them in an ArrayList
  vehicles = new ArrayList<VehicleZ>();
  humans = 0;
  time = 0;
}

void draw() {
  background(255);
  
  // Display the path
  for(Path x:paths)
    x.display();
  if(time%5==0&&humans<100&&time<5000)
  {
    newVehicle(ENTRY.x,ENTRY.y);
  }
  drawLine();
  drawEntryExit();
  for (VehicleZ v : vehicles) {
    v.currCompartment = findCompartment(v);
    if(v.currCompartment!=v.oldCompartment){
      compVC[v.currCompartment]++;
      compVC[v.oldCompartment]--;
      v.oldCompartment=v.currCompartment;
    }
    Path pathx = paths[0];
    // Path following and separation are worked on in this function
    v.applyBehaviors(vehicles,pathx);
    // Call the generic run method (update, borders, display, etc.)
    v.run();
  }
  
  drawTextBox();
  
  time++;
}

void drawTextBox(){
  
  float X = ENTRY.x+2*(bigR+pathW);
  float Y = ENTRY.y;
  fill(255);
  rect(X,Y,150,300);
  // Instructions
  fill(0);
  textAlign(CENTER);
  text(humans+" "+time,X+45,Y+15);
  for(int i=0;i<compartments;i++){
    text(compVC[i],X+45,Y+25+i*10);
  }
  
}
void drawEntryExit(){
  rect(ENTRY.x,ENTRY.y,25,25);
  rect(EXIT.x,EXIT.y,25,25);
  
  fill(0);
  textAlign(CENTER);
  text("ENTRY",ENTRY.x-45,ENTRY.y+20);
  text("EXIT",EXIT.x+45,EXIT.y+20);
}
void drawLine(){
  line = new float[compartments][4];

  for(int i = 0; i < compartments; i++){
    float z = i*theta;
    line[i][0] = xCenter + (float)((bigR + pathW) * Math.cos(z));
    line[i][1] = yCenter + (float)((bigR + pathW) * Math.sin(z));
    line[i][2] = xCenter + (float)((bigR - pathW) * Math.cos(z));
    line[i][3] = yCenter + (float)((bigR - pathW) * Math.sin(z));
    line(line[i][0], line[i][1], line[i][2], line[i][3]);
  }
}



int findCompartment(VehicleZ v){
  int compartment = 0;
  float mx = v.position.x - xCenter;
  float my = v.position.y - yCenter;
  PVector tempCenter = new PVector(xCenter,yCenter);
  PVector z = PVector.sub(tempCenter,v.position);
  float dist = z.mag();
  float V_theta = (float)Math.atan2(my,mx);
  if(V_theta<0)V_theta+=2*PI;
  V_theta = 2*PI - V_theta;
  if(dist<=(bigR+pathW)&&dist>=(bigR-pathW)){
    for(int i =0; i<compartments; i++){
      float start = i*theta;
      float end = (i+1)*theta;
      if(V_theta<end&&V_theta>=start){
         compartment=i;
      }
    }
  }
  return compartment;
}

void newPathCircle(Path path, float radius){
  
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

void newVehicle(float x, float y) {
  //float maxspeed = random(2,4);
  float maxspeed = 3;
  float maxforce = 0.3;
  VehicleZ z = new VehicleZ(new PVector(x,y),maxspeed,maxforce); 
  vehicles.add(z);
  compVC[z.currCompartment]++;
  humans++;
  
}

void deleteVehicle(int id){
  vehicles.remove(id);
  humans--;
}

void keyPressed() {
  if (key == 'd') {
    debug = !debug;
  }
  if (key =='r' ){
    vehicles = new ArrayList<VehicleZ>();
    Arrays.fill(compVC,0);
    newVehicle(ENTRY.x,ENTRY.y);
    humans = 1;
    time = 5000;
    
  }
  if (key =='n'){
    newVehicle(ENTRY.x,ENTRY.y);
  }
}

void mousePressed() {
  newVehicle(mouseX,mouseY);
}
