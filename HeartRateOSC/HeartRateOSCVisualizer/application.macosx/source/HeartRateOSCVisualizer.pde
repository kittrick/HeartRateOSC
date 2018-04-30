import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

color palette[] = new color[5];
ArrayList<MyBox> boxes = new ArrayList<MyBox>();

int heartRate;
int bkg;

// Sine Wave Stuff
float theta = 0.0;
float amplitude = 1;

// Grid Stuff
int res = 20; // how many squares per row/column
int gridSize; // Maximum value of Width vs Height

// Font
PFont dinSmall, din, dinLarge;

// Setup
void setup() {
  // Size
  //size(1920, 1080, P3D);
  fullScreen(P3D);
  gridSize = max(width,height);
  
  // Start oscP5, listening for incoming messages at port 7761
  oscP5 = new OscP5(this,7761);
  myRemoteLocation = new NetAddress("127.0.0.1",7761);
  
  // Setup Styles
  setupPalette();
  setupBoxes(res);
  bkg = 255;
  noStroke();
}

// Draw function
void draw() {
  background(0);
  pointLight(255, 255, 255, width/2, height/2, 300);
  render(heartRate);
}

// Set up Color Palette;
void setupPalette() {
  palette[4] = #f55634;
  palette[3] = #ebf4b5;
  palette[2] = #b3efe8;
  palette[1] = #5ba8ba;
  palette[0] = #527579;
}

// Set Up Boxes
void setupBoxes(int res){
  for(int x = 0; x < res; x++){
    for(int y = 0; y < res; y++){
      boxes.add(new MyBox(x,y,gridSize/res,gridSize/res));
    }
  }
}

// OSC Connection Stuff
void oscEvent(OscMessage theOscMessage) {
  heartRate = theOscMessage.get(2).intValue();
  println(theOscMessage.get(2).intValue());
}

// Basically this draws things
void render(int hr) {
  // Heart Rate Ellipse
  float normalizedHR = map(hr, 40, 140, -1, 1);

  // Limit this value so it doesn't get to Infinity or Zero or whatever
  float limit = 0.1;
  if(!(normalizedHR > limit) && !(normalizedHR < -limit)){
    normalizedHR = limit;
  }
  
  // Increment Theta
  theta += 0.02;
  
  // Render!
  pushMatrix();
    translate(width/2, height/2);
    rotateZ(theta/10);
    // Grid of Colored Boxes
    for(int i = 0; i < boxes.size(); i++){
      boxes.get(i).render(theta, amplitude, normalizedHR);
    }
  popMatrix();
  
  // Text
  noLights();
  fill(255);
  din = createFont("DIN Condensed Bold.ttf", 33);
  textFont(din);
  text("HEART RATE", width/2-50, height/2-90, 200);
  dinLarge = createFont("DIN Condensed Bold.ttf", 170);
  textFont(dinLarge);
  text(hr, width/2-50, height/2+42, 200);
  dinSmall = createFont("DIN Condensed Bold.ttf", 16);
  textFont(dinSmall);
  text("BPM", width/2+75, height/2+40, 200);
}
