float timestamp2;
int oldTime, newTime;

void serialEvent(Serial myPort) {
  int bitCheck, temp;

  oldTime = newTime;
  newTime = millis();
  timestamp2 = (newTime - oldTime)/1000.0;

  if (!firstReceive) {
    bufferSize = myPort.available();
    inBuffer = myPort.readString();
    //println(inBuffer);
    inputData = int(split(inBuffer, ','));
    int size = inputData.length;
    for (int i = 0; i < size-1;) {
      for (int j= 0; j < 4; j++) {
        bitCheck = inputData[i+j] & 0x80000000;      //quaternions have a different sign bit
        if (bitCheck == 0x80000000) {
          temp = inputData[i+j] & 0x7FFFFFFF;
          inputDataSigned[i+j] = (-2147483648.0 + temp) / 10000000.0;
        }
        else
        {
          inputDataSigned[i+j] = inputData[i+j] / 10000000.0;
        }
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
    calculations(size);
  }
  else {
    myPort.clear();
    firstReceive = false;
  }
}

