public void createInterface() {
  MyController = new ControlP5(this);                                     // Nieuw controller object
  MyController.addSlider("red_box_x", -100, 100, 128, 20, 100, 10, 100)
    .setValue(0)
      .isUpdate();
  MyController.addSlider("red_box_y", -100, 100, 128, 70, 100, 10, 100)
    .setValue(-10)
      .isUpdate();
  MyController.addSlider("red_box_z", -100, 100, 128, 120, 100, 10, 100)
    .setValue(0)
      .isUpdate();

  MyController.addTextfield("UART_send")                                  // Aanmaken tekstvak
    .setPosition(20, height-60)
      .setSize(200, 40)
        .setFont(createFont("arial", 20))
          .setAutoClear(false);

  MyController.addBang("Send")                                            //Aanmaken knop 'Send', bij indrukken wordt de functie Send aangeroepen
    .setPosition(240, height-60)                                          //Hoe groot het venster ook is, knop komt altijd in dezelfde plaats linksonder, rechts van het tekstvak
      .setSize(80, 40)                                                    //Grootte van de knop
        .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);     //Tekst uitlijnen in het midden van de knop

  MyController.addBang("Close")                                           //Aanmaken knop 'Close', bij indrukken wordt de functie Close aangeroepen
    .setPosition(width-100, 20)                                           //Hoe groot het venster ook is, knop komt altijd in dezelfde plaats rechtsbovenin
      .setSize(80, 40)                                                    //Grootte van de knop
        .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);     //Tekst uitlijnen in het midden van de knop

  MyController.addBang("Reset")                                           //Aanmaken knop 'Reset', bij indrukken wordt de functie Reset aangeroepen
    .setPosition(width-200, 20)                                           //Hoe groot het venster ook is, knop komt altijd in dezelfde plaats rechtsbovenin
      .setSize(80, 40)                                                    //Grootte van de knop
        .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);     //Tekst uitlijnen in het midden van de knop

  MyController.addBang("Screenshot")                                      //Aanmaken knop 'Screenshot', bij indrukken wordt de functie Screenshot aangeroepen
    .setPosition(width-320, 20)                                           //Hoe groot het venster ook is, knop komt altijd in dezelfde plaats rechtsbovenin
      .setSize(100, 40)                                                   //Grootte van de knop
        .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);     //Tekst uitlijnen in het midden van de knop

  MyController.addBang("StartLog")                                      //Aanmaken knop 'StartLog', bij indrukken wordt de functie StartLog aangeroepen
    .setPosition(width-200, 120)                                          //Hoe groot het venster ook is, knop komt altijd in dezelfde plaats rechtsbovenin
      .setSize(80, 40)                                                    //Grootte van de knop
        .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);     //Tekst uitlijnen in het midden van de knop

  MyController.addBang("EndLog")                                          //Aanmaken knop 'Endlog', bij indrukken wordt de functie Endlog aangeroepen
    .setPosition(width-100, 120)                                          //Hoe groot het venster ook is, knop komt altijd in dezelfde plaats rechtsbovenin
      .setSize(80, 40)                                                    //Grootte van de knop
        .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);     //Tekst uitlijnen in het midden van de knop        

  MyController.setAutoDraw(false);
}

void gui() {
  currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  MyController.draw();
  g3.camera = currCameraMatrix;

  textFont(font, 16);
  fill(255);
  text("Program running for: " + frameCount/60 + " seconds", 10, 20, 150, 60);
  text("red_box_x: " + red_box_x, 250, 20);
  text("red_box_y: " + red_box_y, 250, 40);
  text("red_box_z: " + red_box_z, 250, 60);
  text("xAcceleration: " + xAcceleration[0]/9.81 + " g", 250, 80);
  text("yAcceleration: " + yAcceleration[0]/9.81 + " g", 250, 100);
  text("zAcceleration: " + zAcceleration[0]/9.81 + " g", 250, 120);
  text("xLinearAcceleration: " + xLinearAcceleration[0] + " g", 500, 80);
  text("yLinearAcceleration: " + yLinearAcceleration[0] + " g", 500, 100);
  text("zLinearAcceleration: " + zLinearAcceleration[0] + " g", 500, 120);
  text("yaw[0]: " + degrees(yaw[0]), 250, 140);
  text("pitch[0]: " + degrees(pitch[0]), 250, 160);
  text("roll[0]: " + degrees(roll[0]), 250, 180);
  text("xCoordinate[0]: "+ xCoordinate[0], 250, 200);
  text("yCoordinate[0]: "+ yCoordinate[0], 250, 220);
  text("zCoordinate[0]: "+ zCoordinate[0], 250, 240);
  text("timestamp: " + timestamp*1000.0 + " ms", 250, 260);

  text("bufferSize: " + bufferSize, 10, 280);
  text("totaal buffer: " + totaalBuffer, 110, 280);
  text("received: " + inBuffer, 10, 300);
  text("inputData[0]: " + inputData[0], 10, 320);
  text("inputData[1]: " + inputData[1], 10, 340);
  text("inputData[2]: " + inputData[2], 10, 360);
  text("inputData[3]: " + inputData[3], 10, 380);
  text("inputData[4]: " + inputData[4], 10, 400);
  text("inputData[5]: " + inputData[5], 10, 420);
  text("inputData[6]: " + inputData[6], 10, 440);
  text("inputDataSigned[0]: " + inputDataSigned[0], 10, 460);
  text("inputDataSigned[1]: " + inputDataSigned[1], 10, 480);
  text("inputDataSigned[2]: " + inputDataSigned[2], 10, 500);
  text("inputDataSigned[3]: " + inputDataSigned[3], 10, 520);
  text("inputDataSigned[4]: " + inputDataSigned[4], 10, 540);
  text("inputDataSigned[5]: " + inputDataSigned[5], 10, 560);
  text("inputDataSigned[6]: " + inputDataSigned[6], 10, 580);

  if (device_connected) {
    fill(0, 200, 0);
    text("Serial port "+Serial.list()[0]+" connected!", 500, height-40);
  }
  else
  {
    fill(255, 0, 0);
    text("No serial port found! Please check the connection!", 500, height-40);
  }

  if (enableLogging) {
    fill(255);
    text("Data is being logged in file: installfolder/" + datalogFileName, width-360, 180, 320, 50);
  }
  else
  {
    fill(255);
    text("Data logging not active.", width-320, 180);
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class)) {
    /*println("controlEvent: accessing a string from controller '"
     +theEvent.getName()+"': "
     +theEvent.getStringValue()
     );*/
    myPort.write(MyController.get(Textfield.class, "UART_send").getText()+"\r\n");
  }
}

public void UART_send(String theText) {
  // automatically receives results from controller input
  //println("a textfield event for controller 'textValue' : "+theText);
}

// Functies die worden aangeroepen bij het aanklikken gui knoppen
public void Send() {
  //println("Data zenden via UART");
  if (device_connected) {
    myPort.write(MyController.get(Textfield.class, "UART_send").getText()+"\r\n");
  }
  else
  {
    text("No serial port found! Data not sent", 20, height-80);
  }
  MyController.get(Textfield.class, "UART_send").clear();
}

public void Close() {
  if (enableLogging) {
    saveTable(table, datalogFileName);
  }
  if (device_connected) {
    myPort.clear();
    myPort.stop();
  }
  exit();
}

public void Reset() {
  xCoordinate[0] = 0.0;
  xStartSpeed[0] = 0.0;
  xAcceleration[0] = 0.0;
  yCoordinate[0] = 0.0;
  yStartSpeed[0] = 0.0;
  yAcceleration[0] = 0.0;
  zCoordinate[0] = 0.0;
  zStartSpeed[0] = 0.0;
  zAcceleration[0] = 0.0;
}

public void Screenshot() {
  saveFrame("screenshots/screenshot-#####.png");
}

public void StartLog() {
  datalogFileName = "logfiles/datalog" + year() + day() + month() + "-" + hour() + minute() + second() + ".csv";
  enableLogging = true;
}

public void EndLog() {
  enableLogging = false;
  saveTable(table, datalogFileName);
  table.clearRows();
}

