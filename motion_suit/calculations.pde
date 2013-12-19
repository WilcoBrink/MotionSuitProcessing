public void calculations(int size) {
  int accMode = 2;
  int gyroMode = 2000;
  //println("size:" + size);
  if (inBuffer != null) {
    for (int i = 0;i < (size-1)/7; i++) {
      xAcceleration[i] = (inputDataSigned[7*i+4]/32768.0)*accMode;    // versnelling in g
      yAcceleration[i] = (inputDataSigned[7*i+5]/32768.0)*accMode;    // in accelero is z in de hoogte, in processing ligt z op het horizontale vlak
      zAcceleration[i] = (inputDataSigned[7*i+6]/32768.0)*accMode;    // in accelero ligt y op het horizontale vlak, in processing is y in de hoogte
    }
  }

  float[] gravity = new float[3];
  float[] euler = new float[3];

  //calculate gravity vector
  gravity[0] = 2 * (inputDataSigned[1]*inputDataSigned[3] - inputDataSigned[0]*inputDataSigned[2]);
  gravity[1] = 2 * (inputDataSigned[0]*inputDataSigned[1] + inputDataSigned[2]*inputDataSigned[3]);
  gravity[2] = inputDataSigned[0]*inputDataSigned[0] - inputDataSigned[1]*inputDataSigned[1] - inputDataSigned[2]*inputDataSigned[2] + inputDataSigned[3]*inputDataSigned[3];
  println(gravity);
  
  //drawLine(armRightWrist.x, armRightWrist.y, armRightWrist.z, armRightWrist.x + xAcceleration[0]*30, armRightWrist.y + yAcceleration[0]*30, armRightWrist.z + zAcceleration[0]*30, 0.5, cRed);
  xLinearAcceleration[0] = xAcceleration[0] - gravity[0];
  yLinearAcceleration[0] = yAcceleration[0] - gravity[1];
  zLinearAcceleration[0] = zAcceleration[0] - gravity[2];
  //drawLine(armRightWrist.x, armRightWrist.y, armRightWrist.z, armRightWrist.x + xLinearAcceleration[0]*30, armRightWrist.y + yLinearAcceleration[0]*30, armRightWrist.z + zLinearAcceleration[0]*30, 0.5, cYellow);

  // calculate Euler angles
  euler[0] = atan2(2*inputDataSigned[1]*inputDataSigned[2] - 2*inputDataSigned[0]*inputDataSigned[3], 2*inputDataSigned[0]*inputDataSigned[0] + 2*inputDataSigned[1]*inputDataSigned[1] - 1);
  euler[1] = -asin(2*inputDataSigned[1]*inputDataSigned[3] + 2*inputDataSigned[0]*inputDataSigned[2]);
  euler[2] = atan2(2*inputDataSigned[2]*inputDataSigned[3] - 2*inputDataSigned[0]*inputDataSigned[1], 2*inputDataSigned[0]*inputDataSigned[0] + 2*inputDataSigned[3]*inputDataSigned[3] - 1);
  //println(euler);

  //z-axis
  yaw[0] = -1 * atan2(2*inputDataSigned[1]*inputDataSigned[2] - 2*inputDataSigned[0]*inputDataSigned[3], 2*inputDataSigned[0]*inputDataSigned[0] + inputDataSigned[1]*inputDataSigned[1] - 1);
  //y-axis
  pitch[0] = atan(gravity[0] / sqrt(gravity[1]*gravity[1] + gravity[2]*gravity[2]));
  //x-axis
  roll[0] = -1 * atan(gravity[1] / sqrt(gravity[0]*gravity[0] + gravity[2]*gravity[2]));
  armRightWrist.Update(-25.0, -10.0, 0.0, yaw[0], pitch[0], roll[0]);

  /*xDisplacement[0] = (xStartSpeed[0] * timestamp) + (0.5 * sensorData[0].xpos * sq(timestamp));
   xCoordinate[0]= xCoordinate[0] + xDisplacement[0];
   xStartSpeed[0] = xStartSpeed[0] + timestamp * sensorData[0].xpos;
   
   yDisplacement[0] = (yStartSpeed[0] * timestamp) + (0.5 * sensorData[0].ypos * sq(timestamp));
   yCoordinate[0]= yCoordinate[0] + yDisplacement[0];
   yStartSpeed[0] = yStartSpeed[0] + timestamp * sensorData[0].ypos;
   
   zDisplacement[0] = (zStartSpeed[0] * timestamp) + (0.5 * sensorData[0].zpos * sq(timestamp));
   zCoordinate[0]= zCoordinate[0] + zDisplacement[0];
   zStartSpeed[0] = zStartSpeed[0] + timestamp * sensorData[0].zpos;*/

  dataQuaternion = new Quaternion(inputDataSigned[0], inputDataSigned[1], inputDataSigned[2], inputDataSigned[3]);
  resultQuaternion=Slerping(Accelerometer[0], dataQuaternion);

  vectortje[0] = resultQuaternion.V().xpos;
  vectortje[1] = resultQuaternion.V().ypos;
  vectortje[2] = resultQuaternion.V().zpos;
  //println(vectortje);

  if (enableLogging) {
    addTableRow();
  }
}

