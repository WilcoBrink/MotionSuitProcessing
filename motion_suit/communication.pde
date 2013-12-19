float oldTime, newTime;
int totaalBuffer, serialPackets = 0;

void serialEvent(Serial myPort) {
  int bitCheck, temp;

  oldTime = newTime;
  newTime = millis();
  timestamp = (newTime - oldTime)/1000.0;
  serialPackets += 1;

  if (!firstReceive) {
    bufferSize = myPort.available();
    inBuffer = myPort.readString();
    totaalBuffer += bufferSize;
    //println(inBuffer);
    inputData = int(split(inBuffer, ','));
    int size = inputData.length;
    for (int i = 0; i < size-1;) {
      for (int j= 0; j < 4; j++) {
        inputDataSigned[i+j] = inputData[i+j] / 10000000.0;
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

    for (int i = 0; i < (size-1)/7; i++)
    {
      Accelerometer[0].update(4,5,6);
      //Accelerometer[i].update(inputDataSigned[(7*i)+4], inputDataSigned[(7*i)+5], inputDataSigned[(7*i)+6]);
    }

    calculations(size);
  }
  else {
    myPort.clear();
    firstReceive = false;
  }
}

