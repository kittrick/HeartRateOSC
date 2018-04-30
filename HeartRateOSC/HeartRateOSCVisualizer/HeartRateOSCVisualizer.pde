import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int heartRate;
int bkg;

// Sine Wave Stuff
float theta = 0.0;
float amplitude = 75.0;
float period = 500.0;
float sinValue = 0.0;

void setup() {
  bkg = 255;
  size(800,800);
  frameRate(50);
  /* start oscP5, listening for incoming messages at port 7761 */
  oscP5 = new OscP5(this,7761);
  myRemoteLocation = new NetAddress("127.0.0.1",7761);
  noStroke();
}

void draw() {
  fill(bkg,sinValue,255-bkg,20);
  rect(0,0,width,height);
  render(heartRate);
  textSize(30);
  text("Your Heart Rate: "+heartRate+"BPM" ,width/2-160,height-80);
}

void oscEvent(OscMessage theOscMessage) {
  heartRate = theOscMessage.get(2).intValue();
  println(theOscMessage.get(2).intValue());
}


void render(int hr) {
  float normalizedHR = hr-60;
  ellipseMode(CENTER);
  bkg = int(map(normalizedHR,-10,10,0,255));
  theta += normalizedHR/70;
  sinValue = sin(theta)*amplitude;
  fill(255);
  ellipse(width/2, height/2, normalizedHR*10+sinValue, normalizedHR*10+sinValue);
}
