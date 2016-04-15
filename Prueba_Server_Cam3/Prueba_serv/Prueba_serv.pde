import processing.video.*;
import processing.net.*;
import g4p_controls.*;
//////////////////////////////////////VARIABLES//////////////////////////////////////////////
//Variable for capture device
Capture video;
color colorBase;
color colorBase2;
color colorBase3;
float r1, g1, b1;
float r2, g2, b2;
float r3, g3, b3;
float r4, g4, b4;
float d1, d2, d3;
int posX, posY, cont, centerX, centerY, posX1, posY1, cont1, centerX1, centerY1, posX2, posY2, cont2, centerX2, centerY2;
int loc1, loc2, loc3;
int contador_enviar=0;


// Variables Para Network
GTextField txf1;
GTextArea txa1;
Server s;
Client c;
String input;

//////////////////////////// SETUP ////////////////////////////////////////////////////////////7
void setup() {
  
  size(1090,480);
  background(240, 240, 200);
  
  // Inciaciones de Camara //
  video = new Capture(this, video.list()[0]);
  video.start();
  
  colorBase = color(255, 0, 0);
  colorBase2 = color(0, 255, 0);
  colorBase3 = color(0, 0, 255);
  
  smooth();
  
  //// Iniciaciones Networking //
  
  G4P.setGlobalColorScheme(GCScheme.RED_SCHEME);
  
  txf1 = new GTextField(this, 650, 10, 370, 20);
  txf1.tag = "txf1";
  txf1.setDefaultText("");
  
  txa1 = new GTextArea(this, 650, 40, 430, 160);
  txa1.tag = "txa1";
  txa1.setDefaultText("");
  
  s = new Server(this, 12345); // Start a simple server on a port
  
  // FIN de Setup //
  
}

void draw() {
  //////////////////////////// DRAW CAMARA DETECCION COLOR //////////////////////////
  r2 = (colorBase >> 16) & 0xFF;
  g2 = (colorBase >> 8) & 0xFF;
  b2 = colorBase & 0xFF;
  
  r3 = (colorBase2 >> 16) & 0xFF;
  g3 = (colorBase2 >> 8) & 0xFF;
  b3 = colorBase2 & 0xFF;
  
  r4 = (colorBase3 >> 16) & 0xFF;
  g4 = (colorBase3 >> 8) & 0xFF;
  b4 = colorBase3 & 0xFF;
  
  //println(frameRate);
  
  if ( video.available() ) {
    video.read();
  }
  
  //loadPixels();
  video.loadPixels();
  
  image(video, 0, 0);
    
  //pos primer color
  posX = 0;
  posY = 0;
  cont = 1;
  
  centerX = 0;
  centerY = 0;
  
  //pos segundo color
  posX1 = 0;
  posY1 = 0;
  cont1 = 1;
  
  centerX1 = 0;
  centerY1 = 0;
  
  //pos tercer color
  posX2 = 0;
  posY2 = 0;
  cont2 = 1;
  
  centerX2 = 0;
  centerY2 = 0;
  
  for ( int x = 0; x < video.width; x++ ) {
    for ( int y = 0; y < video.height; y++ ) {
      
      int loc = x + y * video.width;
      
      color colorPix = video.pixels[loc];
      
      r1 = (colorPix >> 16) & 0xFF;
      g1 = (colorPix >> 8) & 0xFF;
      b1 = colorPix & 0xFF;
      
      d1 = dist(r1, g1, b1, r2, g2, b2);
      d2 = dist(r1, g1, b1, r3, g3, b3);
      d3 = dist(r1, g1, b1, r4, g4, b4);
      
      if ( d1 < 10 ) {
        
        posX = posX + x;
        posY = posY + y;
        cont = cont + 1;
        //stroke(100);
        //point(x, y);
        
      }
      if ( d2 < 10 ) {
        
        posX1 = posX1 + x;
        posY1 = posY1 + y;
        cont1 = cont1 + 1;
        //stroke(255);
        //point(x, y);
        
      }
      if ( d3 < 10 ) {
        
        posX2 = posX2 + x;
        posY2 = posY2 + y;
        cont2 = cont2 + 1;
        //stroke(175);
        //point(x, y);
        
      }
    }
  }
  
  //pto central del primer color
  centerX = posX / cont;
  centerY = posY / cont;
  fill(240, 127, 0);
  ellipse(centerX, centerY, 6, 6);
  
  //pto central del segundo color
  centerX1 = posX1 / cont1;
  centerY1 = posY1 / cont1;
  fill(240, 0, 127);
  ellipse(centerX1, centerY1, 6, 6);
  
  //pto central del segundo color
  centerX2 = posX2 / cont2;
  centerY2 = posY2 / cont2;
  fill(0, 200, 200);
  ellipse(centerX2, centerY2, 6, 6);
  // Envio de posición por red
  contador_enviar++;
  if(contador_enviar==15){
    s.write("2" + centerX + " " + centerY);
  }
    if(contador_enviar==30){
    s.write("3" + centerX1 + " " + centerY1);
  }
    if(contador_enviar==45){
    s.write("4" + centerX2 + " " + centerY2);
    contador_enviar=0;
  }
  
  //updatePixels();
  video.updatePixels();
  
  //////////// DRAW DE NETWORK //////////////////////////
    c = s.available();
    if (c != null) {
    input = c.readString();
    //input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    //data = int(split(input, ' ')); // Split values into an array
    //if(c.ip()==192.168.1.111){
    txa1.setText(c.ip() + ": " + input);
    //}
  }
  
}
/////////////////////////// EVENTOS DE PRESIONAR MOUSE ///////////////////////////
void mousePressed() {
  
  loadPixels();
  
  if ( mouseButton == LEFT && (mouseX<640) && (mouseY<480)) {
    
    if ( key == '1' ) {
      loc1 = mouseX + mouseY * width;
      colorBase = pixels[loc1];
      
    }
    if ( key == '2' ) {
      loc2 = mouseX + mouseY * width;
      colorBase2 = pixels[loc2];
    
    }
    if ( key == '3' ) {
      loc3 = mouseX + mouseY * width;
      colorBase3 = pixels[loc3];
    }

  }
}

///////////////////////// EVENTOS de TEXTO //////////////////////////////

public void handleTextEvents(GEditableTextControl tc, GEvent event) { 
  System.out.print("\n" + tc.tag + "   Event type: ");
  switch(event) {
  case ENTERED:
    System.out.println("ENTER KEY TYPED");
    System.out.println(tc.getText() + "\n");
    s.write("1" + tc.getText());
    //txa1.setText(tc.getText());
    break;
  default:
    //System.out.println("UNKNOWN");
  }
}
