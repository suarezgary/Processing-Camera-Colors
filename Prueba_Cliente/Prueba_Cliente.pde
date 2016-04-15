import processing.net.*;
import g4p_controls.*;

GTextField txf1;
GTextArea txa1,txa2, txa3, txa4;
color rectColor, circleColor, rectHighlight;
Client c;
String input, sep1, sep2;
int rectX, rectY; // Position of square button
char verif;      
int rectSize = 90;     // Diameter of rect
int data1[];
int data2[];
int data3[];


void setup() 
{
  size(450, 360);
  
  rectColor = color(0);
  rectHighlight = color(51);
  //background(204);
  G4P.setGlobalColorScheme(GCScheme.RED_SCHEME);
  
  txf1 = new GTextField(this, 10, 10, 370, 20);
  txf1.tag = "txf1";
  txf1.setDefaultText("");
  
  txa1 = new GTextArea(this, 10, 40, 430, 160);
  txa1.tag = "txa1";
  txa1.setDefaultText("");
  
  txa2 = new GTextArea(this, 10, 200, 430, 50);
  txa2.tag = "txa2";
  txa2.setDefaultText("");
  
  txa3 = new GTextArea(this, 10, 250, 430, 50);
  txa2.tag = "txa2";
  txa2.setDefaultText("");
  
  txa4 = new GTextArea(this, 10, 300, 430, 50);
  txa2.tag = "txa2";
  txa2.setDefaultText("");
  //background(204);
//  stroke(0);
//  frameRate(5); // Slow it down a little
  // Connect to the server's IP address and port
  c = new Client(this, "127.0.0.1", 12345); // Replace with your server's IP and port
}

void draw() 
{

  if (c.available() > 0) {
    input = c.readString();
    sep1 = input.substring(0,1);// Agarra solo el primer caracter del string
    sep2 = input.substring(1);// Agarra todo lo sobrante del string a partir del segundo caracacter
    // println("sep1: " + sep1 + "   sep2: " + sep2); //Prueba para ver como se separa
    if(sep1.equals("1")){
    txa1.setText(c.ip() + ": " + sep2);
    }
    if(sep1.equals("2")){
    data1 = int(split(sep2, ' '));
    txa2.setText("COLOR 1:\n                                           Ubicacion X: "+ data1[0] + " Ubicacion Y: " + data1[1]);
    }
    if(sep1.equals("3")){
    data2 = int(split(sep2, ' '));
    txa3.setText("COLOR 2:\n                                           Ubicacion X: "+ data2[0] + " Ubicacion Y: " + data2[1]);
    }
    if(sep1.equals("4")){
    data3 = int(split(sep2, ' '));
    txa4.setText("COLOR 3:\n                                           Ubicacion X: "+ data3[0] + " Ubicacion Y: " + data3[1]);
    }
    //input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    //data = int(split(input, ' ')); // Split values into an array
    
  }
}

public void handleTextEvents(GEditableTextControl tc, GEvent event) { 
  System.out.print("\n" + tc.tag + "   Event type: ");
  switch(event) {
  case ENTERED:
    System.out.println("ENTER KEY TYPED");
    System.out.println(tc.getText() + "\n");
    c.write(tc.getText());
    //txa1.setText(tc.getText());
    break;
  default:
    System.out.println("UNKNOWN");
  }
}
