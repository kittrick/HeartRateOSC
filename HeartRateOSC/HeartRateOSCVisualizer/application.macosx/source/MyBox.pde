class MyBox {
  
  // Class Vars
  float posX, posY, posZ, boxW, boxH, size;
  color boxC;
  
  // init Function
  MyBox(int x, int y, int w, int h){
    posX = x;
    posY = y;
    posZ = 0;
    boxW = w;
    boxH = h;
    boxC = #ffffff;
  }
  
  // Render Boxes
  void render(float theta, float amplitude, float normalizedHR){
    float d = dist(gridSize/2, gridSize/2, posX*boxW, posY*boxH);
    float offset = map(d, 0, gridSize, -1, 1);
    float sinValue = sin(theta*(normalizedHR/2)+theta-offset);
    float amplified = sinValue*amplitude*normalizedHR;
    posZ += amplified;
    
    // Color Stepping
    if(abs(amplified) > 0.9) {
      boxC = palette[4];
    } else if(abs(amplified) > 0.7){
      boxC = palette[3];
    } else if(abs(amplified) > 0.5){
      boxC = palette[2];
    } else if(abs(amplified) > 0.3){
      boxC = palette[1];
    } else if(abs(amplified) > 0.1){
      boxC = palette[0];
    }
    fill(boxC);
    
    pushMatrix();
      translate(posX*boxW-gridSize/2, posY*boxH-gridSize/2, posZ+100);
      rotate(sinValue*2);
      box(boxW*sinValue,boxH*sinValue,(boxW+boxH/2)*sinValue);
    popMatrix();
  }
  void printInfo(){
    println("posX: " + posX + "posY: " + posY + "posZ: "+ posZ);
  }
}
