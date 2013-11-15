public void calculations(int size) {
  int accMode = 2;
  int gyroMode = 2000;
  //println("size:" + size);
  if (inBuffer != null) {
    for (int i = 0;i < (size-1)/6; i++) {
      xAcceleration[i] = (inputDataSigned[6*i]/32768.0)*9.81*accMode;      // versnelling in m/s^2
      zAcceleration[i] = (inputDataSigned[6*i+1]/32768.0)*9.81*accMode;    // in accelero is z in de hoogte, in processing ligt z op het horizontale vlak
      yAcceleration[i] = (inputDataSigned[6*i+2]/32768.0)*9.81*accMode;    // in accelero ligt y op het horizontale vlak, in processing is y in de hoogte
      xGyroscope[i] = (inputDataSigned[6*i+3]/32768.0)*gyroMode;
      zGyroscope[i] = (inputDataSigned[6*i+4]/32768.0)*gyroMode;
      yGyroscope[i] = (inputDataSigned[6*i+5]/32768.0)*gyroMode;
    }
  }
  
  filteredValue = xOEFfilter(yAcceleration[0]);

  for (int i = 0; i < 2; i++) {
    float[] temp = new float[3];
    temp = calculate_vector(xAcceleration[i], yAcceleration[i], zAcceleration[i], yGyroscope[i], xGyroscope[i]);
    sensorData[i].update(temp[0], temp[1], temp[2]);
    //println(sensorData[0].xpos + " " + sensorData[0].ypos + " " + sensorData[0].zpos);
  }

  //xAngle[0] = xAngle[0] + (xGyroscope[0]/32768.0)*timestamp*gyroMode;      // uit vector berekeningen te halen
  xDisplacement[0] = (xStartSpeed[0] * timestamp) + (0.5 * sensorData[0].xpos * sq(timestamp));
  xCoordinate[0]= xCoordinate[0] + xDisplacement[0];
  xStartSpeed[0] = xStartSpeed[0] + timestamp * sensorData[0].xpos;

  //yAngle[0] = yAngle[0] + (zGyroscope[0]/32768.0)*timestamp*gyroMode;
  yDisplacement[0] = (yStartSpeed[0] * timestamp) + (0.5 * sensorData[0].ypos * sq(timestamp));
  yCoordinate[0]= yCoordinate[0] + yDisplacement[0];
  yStartSpeed[0] = yStartSpeed[0] + timestamp * sensorData[0].ypos;

  //zAngle[0] = zAngle[0] + (yGyroscope[0]/32768.0)*timestamp*gyroMode;
  zDisplacement[0] = (zStartSpeed[0] * timestamp) + (0.5 * sensorData[0].zpos * sq(timestamp));
  zCoordinate[0]= zCoordinate[0] + zDisplacement[0];
  zStartSpeed[0] = zStartSpeed[0] + timestamp * sensorData[0].zpos;

  //roll[0] = atan(-xAcceleration[0] / zAcceleration[0]);
  //pitch[0] = atan(yAcceleration[0] / (sqrt(sq(xAcceleration[0]) + sq(zAcceleration[0]))));

  if (enableLogging) {
    addTableRow();
  }
}

int sign(float f) {
  if (f >= 0) return 1;
  if (f < 0) return -1;
  return 0;
}

float[] calculate_vector(float accX, float accY, float accZ, float gyroXZ, float gyroYZ) {
  float[] returnData = new float[3];

  Rxa = accX;
  Rya = accY;
  Rza = accZ;
  RateAxz[n] = radians(gyroXZ);
  RateAyz[n] = radians(gyroYZ);

  Racc.update(Rxa, Rya, Rza);
  RaccN.update(Rxa/Racc.lengte(), Rya/Racc.lengte(), Rza/Racc.lengte());  // Normalisatie van Racc

  Rxe[n-1]=RaccN.xpos;  // gelijk stellen van de werkelijke uitkomst aan de accelerometer
  Rye[n-1]=RaccN.ypos;
  Rze[n-1]=RaccN.zpos;

  Rest[n-1].update(Rxe[n-1], Rye[n-1], Rze[n-1]);
  ////////////////////////////////////////
  if (schakel==0)
  {
    Axz[n-1]=atan2(Rxe[n-1], Rze[n-1]);       // hoek xz uitreken aan de hand van de accelerometer
  }
  Axz[n]=Axz[n-1]+(RateAxz[n]*timestamp2);   // de hoek draaien mbv de gyrometer
  Axz[n-1]=Axz[n];
  if (schakel==0) {
    Ayz[n-1]=atan2(Rye[n-1], Rze[n-1]);       // hoek yz uitreken aan de hand van de accelerometer
  }
  //schakel = 1;
  Ayz[n]=Ayz[n-1]+(RateAyz[n]*timestamp2);  // de hoek draaien mbv de gyrometer
  Ayz[n-1]=Ayz[n];

  ///////////////////////////////////////////////
  Rxg=sin(Axz[n])/sqrt(1+sq(cos(Axz[n]))*sq(tan(Ayz[n]))); // Rxg uitrekenen aan de hand van de hoek xz
  Ryg=sin(Ayz[n])/sqrt(1+sq(cos(Ayz[n]))*sq(tan(Axz[n]))); // Ryg uitrekenen aan de hand van de hoek yz
  Rzg=sign(Rze[n-1])*sqrt(1-sq(Rxg)-sq(Ryg));                   // Rzg uitrekenen aan de hand Rxg en Ryg
  Rgyro.update(Rxg, Ryg, Rzg);
  /////////////////////////////////////////////////
  Rest[n].xpos=(RaccN.xpos+Rgyro.xpos*wGyro)/(1+wGyro);    // De accelero uitkomst met de Gyro vergelijken wGyro bepaalt de verhouding tussen de gyro en de accelero meter
  Rest[n].ypos=(RaccN.ypos+Rgyro.ypos*wGyro)/(1+wGyro);
  Rest[n].zpos=(RaccN.zpos+Rgyro.zpos*wGyro)/(1+wGyro);
  //////////////////////////////////////////////
  R=Rest[n].lengte();
  ///////////////////////////////////////////// RestN uitrekenen Genormaliseert van Rest
  RestN.xpos=Rest[n].xpos/R;
  RestN.ypos=Rest[n].ypos/R;
  RestN.zpos=Rest[n].zpos/R;
  ///////////////////////////////////  Rest Weer in de goede verhouding plaatsen
  Rest[n].xpos=RestN.xpos*Racc.lengte();
  Rest[n].ypos=RestN.ypos*Racc.lengte();
  Rest[n].zpos=RestN.zpos*Racc.lengte();
  //////////////////////////////// Zwaartekracht elimineren
  Rest[n].ypos=Rest[n].ypos-zwaartekracht;

  returnData[0] = Rest[n].xpos;
  returnData[1] = Rest[n].ypos;
  returnData[2] = Rest[n].zpos;

  return returnData;
}

