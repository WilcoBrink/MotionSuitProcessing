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
    for(int i = 0; i < size-1; i++) {
     bitCheck = inputData[i] & 0x8000;      //quaternions have a different sign bit
     if(bitCheck == 0x8000) {
     temp = inputData[i] & 0x7FFF;
     inputDataSigned[i] = -32768.0 + temp;
     }
     else
     {
       inputDataSigned[i] = inputData[i];
     }
     }
    calculations(size);
  }
  else {
    myPort.clear();
    firstReceive = false;
  }
}

