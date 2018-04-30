import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class HeartRateOSCVisualizer extends PApplet {




OscP5 oscP5;
NetAddress myRemoteLocation;

int palette[] = new int[5];
ArrayList<MyBox> boxes = new ArrayList<MyBox>();

int heartRate;
int bkg;

// Sine Wave Stuff
float theta = 0.0f;
float amplitude = 1;

// Grid Stuff
int res = 20; // how many squares per row/column
int gridSize; // Maximum value of Width vs Height

// Font
PFont dinSmall, din, dinLarge;

// Setup
public void setup() {
  // Size
  //size(1920, 1080, P3D);
  
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
public void draw() {
  background(0);
  pointLight(255, 255, 255, width/2, height/2, 300);
  render(heartRate);
}

// Set up Color Palette;
public void setupPalette() {
  palette[4] = 0xfff55634;
  palette[3] = 0xffebf4b5;
  palette[2] = 0xffb3efe8;
  palette[1] = 0xff5ba8ba;
  palette[0] = 0xff527579;
}

// Set Up Boxes
public void setupBoxes(int res){
  for(int x = 0; x < res; x++){
    for(int y = 0; y < res; y++){
      boxes.add(new MyBox(x,y,gridSize/res,gridSize/res));
    }
  }
}

// OSC Connection Stuff
public void oscEvent(OscMessage theOscMessage) {
  heartRate = theOscMessage.get(2).intValue();
  println(theOscMessage.get(2).intValue());
}

// Basically this draws things
public void render(int hr) {
  // Heart Rate Ellipse
  float normalizedHR = map(hr, 40, 140, -1, 1);

  // Limit this value so it doesn't get to Infinity or Zero or whatever
  float limit = 0.1f;
  if(!(normalizedHR > limit) && !(normalizedHR < -limit)){
    normalizedHR = limit;
  }
  
  // Increment Theta
  theta += 0.02f;
  
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
class MyBox {
  
  // Class Vars
  float posX, posY, posZ, boxW, boxH, size;
  int boxC;
  
  // init Function
  MyBox(int x, int y, int w, int h){
    posX = x;
    posY = y;
    posZ = 0;
    boxW = w;
    boxH = h;
    boxC = 0xffffffff;
  }
  
  // Render Boxes
  public void render(float theta, float amplitude, float normalizedHR){
    float d = dist(gridSize/2, gridSize/2, posX*boxW, posY*boxH);
    float offset = map(d, 0, gridSize, -1, 1);
    float sinValue = sin(theta*(normalizedHR/2)+theta-offset);
    float amplified = sinValue*amplitude*normalizedHR;
    posZ += amplified;
    
    // Color Stepping
    if(abs(amplified) > 0.9f) {
      boxC = palette[4];
    } else if(abs(amplified) > 0.7f){
      boxC = palette[3];
    } else if(abs(amplified) > 0.5f){
      boxC = palette[2];
    } else if(abs(amplified) > 0.3f){
      boxC = palette[1];
    } else if(abs(amplified) > 0.1f){
      boxC = palette[0];
    }
    fill(boxC);
    
    pushMatrix();
      translate(posX*boxW-gridSize/2, posY*boxH-gridSize/2, posZ+100);
      rotate(sinValue*2);
      box(boxW*sinValue,boxH*sinValue,(boxW+boxH/2)*sinValue);
    popMatrix();
  }
  public void printInfo(){
    println("posX: " + posX + "posY: " + posY + "posZ: "+ posZ);
  }
}
  public void settings() {  fullScreen(P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "HeartRateOSCVisualizer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
