// Importeren libraries
import processing.opengl.*;
import processing.serial.*;                                              // Met Processing meegeleverde serial library  (in Processing 2.0+ moet de library van Processing 1.5.1 gebruikt worden)
import peasy.*;                                                          // Library voor camerabesturing  (http://mrfeinberg.com/peasycam/)
import controlP5.*;                                                      // Library voor knoppen, schuifbalken, tekstvakken, enz  (http://www.sojamo.de/libraries/controlP5/)

// Declareren objecten
PeasyCam cam;
PMatrix3D currCameraMatrix;
PGraphics3D g3;
ControlP5 MyController;
Serial myPort;

// Gebruikte kleuren
color cWhite = #FFFFFF;
color cRed = #FF0000;
color cGreen = #00FF00;
color cBlue = #0000FF;
color cYellow = #FFFF00;

// Gebruikte lettertypen
PFont font;

// Coordinaten meetpunten
float red_box_x, red_box_y, red_box_z = 0.0;
float[] xCoordinate = new float[20];
float[] yCoordinate = new float[20];
float[] zCoordinate = new float[20];
float[] yaw = new float[20];
float[] roll = new float[20];
float[] pitch = new float[20];

// Variabelen gebruikt voor berekeningen
float[] xAcceleration = new float[20];
float[] yAcceleration = new float[20];
float[] zAcceleration = new float[20];
float[] xGyroscope = new float[20];
float[] yGyroscope = new float[20];
float[] zGyroscope = new float[20];
float[] xDisplacement = new float[20];
float[] yDisplacement = new float[20];
float[] zDisplacement = new float[20];
float[] xAngle = new float[20];
float[] yAngle = new float[20];
float[] zAngle = new float[20];
float[] xStartSpeed = new float[20];
float[] yStartSpeed = new float[20];
float[] zStartSpeed = new float[20];

/////////////////////
//int n = 1;
//float R=0;
//float wGyro=5;
//int schakel = 0;
//float zwaartekracht=9.81;

float timestamp = 0.05;             // in seconden

// Variabelen voor UART
String inBuffer;                    // Input string from serial port
int bufferSize = 0;
String UART_send = "";              // String from text input field
int lf = 10;                        // ASCII linefeed
boolean device_connected = false;   // 'Flag' voor device connected
boolean firstReceive = true;

// Variabelen voor inkomende data
int[] inputData = new int[7];
float[] inputDataSigned = new float[7];

// Variabelen voor datalogging
Table table;
String datalogFileName;
boolean enableLogging = false;

// Objecten voor weergave lichaamsdelen
Sensor armRightWrist, armRightElbow, armRightShoulder;
Sensor armLeftWrist, armLeftElbow, armLeftShoulder;
Sensor legRightFoot, legRightKnee, legRightHip;
Sensor legLeftFoot, legLeftKnee, legLeftHip;
Sensor chestHip, chestBreast;
Limb armRightUpper, armRightLower;
Limb armLeftUpper, armLeftLower;
Limb legRightUpper, legRightLower;
Limb legLeftUpper, legLeftLower;
Limb chestRightHip, chestLeftHip, chestCentral, chestRightShoulder, chestLeftShoulder;

//boolean sketchFullScreen() {                                            // Functie die het programma fullscreen laat draaien
//  return true;
//}

void setup() {
  //size(displayWidth, displayHeight, P3D);                               // Venstergrootte gelijk aan resolutie scherm, maak gebruik van 3D renderer
  size(1280, 720, P3D);
  g3 = (PGraphics3D)g;
  font = createFont("Arial", 16, true);                                   // Arial, 16 punten, anti-aliasing aan

  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(500);
  cam.setYawRotationMode();
  
  createInterface();

  createLogTable();

  initBody();

  //println(Serial.list());
  if (Serial.list().length==0) {
    device_connected = false;
  }
  else {
    myPort = new Serial(this, Serial.list()[0], 9600);
    device_connected = true;
    myPort.bufferUntil(lf);
    myPort.clear();
  }
}

void draw() {
  background(0);

  pushMatrix();
  //translate(xCoordinate[0], yCoordinate[0], zCoordinate[0]);
  rotateX(pitch[0]);
  rotateY(yaw[0]);
  rotateZ(roll[0]);
  fill(0, 255, 255);
  box(10);
  popMatrix();

  armRightElbow.y = red_box_y;
  armRightElbow.z = red_box_z;

  updateBody();      // hoort eigenlijk in 'communication' na aanroepen van de calculations functie!!!

  drawBody();

  gui();
}

void drawLine(float x1, float y1, float z1, float x2, float y2, float z2, float weight, color strokeColour)
{
  PVector p1 = new PVector(x1, y1, z1);
  PVector p2 = new PVector(x2, y2, z2);
  PVector v1 = new PVector(x2-x1, y2-y1, z2-z1);
  float rho = sqrt(pow(v1.x, 2)+pow(v1.y, 2)+pow(v1.z, 2));
  float phi = acos(v1.z/rho);
  float the = atan2(v1.y, v1.x);
  v1.mult(0.5);

  pushMatrix();
  translate(x1, y1, z1);
  translate(v1.x, v1.y, v1.z);
  rotateZ(the);
  rotateY(phi);
  noStroke();
  fill(strokeColour);
  box(weight, weight, p1.dist(p2)*1.2);
  popMatrix();
}

