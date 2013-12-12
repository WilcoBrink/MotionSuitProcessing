public void calculations(int size) {
  int accMode = 2;
  int gyroMode = 2000;
  //println("size:" + size);
  if (inBuffer != null) {
    for (int i = 0;i < (size-1)/7; i++) {
      xAcceleration[i] = (inputDataSigned[7*i+4]/32768.0)*9.81*accMode;      // versnelling in m/s^2
      yAcceleration[i] = (inputDataSigned[7*i+5]/32768.0)*9.81*accMode;    // in accelero is z in de hoogte, in processing ligt z op het horizontale vlak
      zAcceleration[i] = (inputDataSigned[7*i+6]/32768.0)*9.81*accMode;    // in accelero ligt y op het horizontale vlak, in processing is y in de hoogte
      //xGyroscope[i] = (inputDataSigned[6*i+3]/32768.0)*gyroMode;
      //zGyroscope[i] = (inputDataSigned[6*i+4]/32768.0)*gyroMode;
      //yGyroscope[i] = (inputDataSigned[6*i+5]/32768.0)*gyroMode;
    }
  }
  
  //filteredValue = xOEFfilter(yAcceleration[0]);

  /*xDisplacement[0] = (xStartSpeed[0] * timestamp) + (0.5 * sensorData[0].xpos * sq(timestamp));
  xCoordinate[0]= xCoordinate[0] + xDisplacement[0];
  xStartSpeed[0] = xStartSpeed[0] + timestamp * sensorData[0].xpos;

  yDisplacement[0] = (yStartSpeed[0] * timestamp) + (0.5 * sensorData[0].ypos * sq(timestamp));
  yCoordinate[0]= yCoordinate[0] + yDisplacement[0];
  yStartSpeed[0] = yStartSpeed[0] + timestamp * sensorData[0].ypos;

  zDisplacement[0] = (zStartSpeed[0] * timestamp) + (0.5 * sensorData[0].zpos * sq(timestamp));
  zCoordinate[0]= zCoordinate[0] + zDisplacement[0];
  zStartSpeed[0] = zStartSpeed[0] + timestamp * sensorData[0].zpos;*/

  if (enableLogging) {
    addTableRow();
  }
}

