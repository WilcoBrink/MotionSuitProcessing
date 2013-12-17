float timestamp2 = 0.05;      //in seconds
float oldTime, newTime;
int totaalBuffer;


void serialEvent(Serial myPort) {
  int bitCheck, temp;

  oldTime = newTime;
  newTime = millis();
  timestamp2 = (newTime - oldTime)/1000.0;

  if (!firstReceive) {
    bufferSize = myPort.available();
    inBuffer = myPort.readString();
    totaalBuffer += bufferSize;
    //println(inBuffer);
    inputData = int(split(inBuffer, ','));
    int size = inputData.length;
    for (int i = 0; i < size-1;) {
      for (int j= 0; j < 4; j++) {
        /*bitCheck = inputData[i+j] & 0x80000000;      //quaternions have a different sign bit
        if (bitCheck == 0x80000000) {
          temp = inputData[i+j] & 0x7FFFFFFF;
          inputDataSigned[i+j] = (-2147483648.0 + temp) / 1000000.0;
        }
        else
        {*/
          inputDataSigned[i+j] = inputData[i+j] / 1000000.0;
        //}
      }
      i += 4;
      for (int j = 0; j < 3; j++) {
        bitCheck = inputData[i+j] & 0x8000;
        if (bitCheck == 0x8000) {
          temp = inputData[i+j] & 0x7FFF;
          inputDataSigned[i+j] = -32768.0 + temp;
        }
        else
        {
          inputDataSigned[i+j] = inputData[i+j];
        }
      }
      i += 3;
    }
   
    for (int i=0;i<1;i++)
    {
       //Accelerometer[i].update(inputDataSigned[4+(i*7)],inputDataSigned[5+(i*7)],inputDataSigned[6+(i*7)]);
       Accelerometer[0].update(4,5,6);
    }
    
    calculations(size);
  }
  else {
    myPort.clear();
    firstReceive = false;
  }
}

