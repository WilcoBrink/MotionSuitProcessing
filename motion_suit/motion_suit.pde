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

float filteredValue;

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
Vector Racc = new Vector(0.0, 0.0, 0.0);
Vector RaccN = new Vector(0, 0, 0);
Vector[] Rest = new Vector[2];
Vector RestN = new Vector(0, 0, 0);
Vector Rgyro = new Vector(0.0, 0.0, 0.0);
Vector[] sensorData = new Vector[20];

float Rxa, Rya, Rza, Rxg, Ryg, Rzg = 0;// coordinaten toevoegen

float[] Rxe=new float[2];
float[] Rye=new float[2];
float[] Rze=new float[2];

float[] Axz=new float[2];                   // Hoek xz
float[] Ayz=new float[2];                     // Hoek yz
float[] RateAxz=new float[2];                  // Draaing uit Gyro
float[] RateAyz=new float[2];                  // Draaing uit Gyro
int n = 1;
float R=0;
float wGyro=5;
int schakel = 0;
float zwaartekracht=9.81;

float timestamp = 0.05;             // in seconden

// Variabelen voor UART
String inBuffer;                    // Input string from serial port
int bufferSize = 0;
String UART_send = "";              // String from text input field
int lf = 10;                        // ASCII linefeed
boolean device_connected = false;   // 'Flag' voor device connected
boolean firstReceive = true;

// Variabelen voor inkomende data
int[] inputData = new int[6];
float[] inputDataSigned = new float[6];

// Variabelen voor datalogging
Table table;
String datalogFileName;
boolean enableLogging = false;

// Objecten voor weergave lichaamsdelen
Sensor armRightWrist, armRightElbow, armRightShoulder;
Sensor armLeftWrist, armLeftElbow, armLeftShoulder;
Limb armRightUpper, armRightLower;
Limb armLeftUpper, armLeftLower;

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

  Rest[n]=new Vector(Rxe[n], Rye[n], Rze[n]);
  Rest[n-1]=new Vector(Rxe[n-1], Rye[n-1], Rze[n-1]);
  sensorData[0] = new Vector(0.0, 0.0, 0.0);
  
  xOneEuroFilter(10.0, 0.1, 0.1, 0.1);

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
  rotateX(radians(xAngle[0]));
  rotateY(radians(-yAngle[0]));
  rotateZ(radians(zAngle[0]));
  fill(0, 255, 255);
  box(10);
  popMatrix();

  armRightElbow.y = red_box_y;
  armRightElbow.z = red_box_z;

  updateBody();      // hoort eigenlijk in 'communication' na aanroepen van de calculations functie!!!

  drawBody();

  //println(sensorData[0].xpos + " " + sensorData[0].ypos + " " + sensorData[0].zpos);
  drawLine(armRightWrist.x, armRightWrist.y, armRightWrist.z, armRightWrist.x + sensorData[0].xpos, armRightWrist.y + sensorData[0].ypos, armRightWrist.z + sensorData[0].zpos, 1.0, cWhite);
  drawLine(armRightWrist.x, armRightWrist.y, armRightWrist.z, armRightWrist.x + Racc.xpos, armRightWrist.y + Racc.ypos, armRightWrist.z + Racc.zpos, 1.0, cYellow);
  drawLine(armRightWrist.x, armRightWrist.y, armRightWrist.z, armRightWrist.x + (Rgyro.xpos*10), armRightWrist.y + (Rgyro.ypos*10), armRightWrist.z + (Rgyro.zpos*10), 1.0, cRed);

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

