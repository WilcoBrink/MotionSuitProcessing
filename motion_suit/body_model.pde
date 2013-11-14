public void initBody() {
  armRightWrist = new Sensor(-35.0, 0.0, 00.0, 0.0, 0.0, 0.0);
  armRightElbow = new Sensor(-25.0, 0.0, 0.0, 0.0, 0.0, 0.0);
  armRightShoulder = new Sensor(-15.0, 0.0, 0.0, 0.0, 0.0, -20.0);

  armRightUpper = new Limb(armRightShoulder, armRightElbow);
  armRightLower = new Limb(armRightElbow, armRightWrist);

  armLeftWrist = new Sensor(35.0, 0.0, 0.0, 0.0, 0.0, 0.0);
  armLeftElbow = new Sensor(25.0, 0.0, 0.0, 0.0, 0.0, 0.0);
  armLeftShoulder = new Sensor(15.0, 0.0, 0.0, 0.0, 0.0, 20.0);

  armLeftUpper = new Limb(armLeftShoulder, armLeftElbow);
  armLeftLower = new Limb(armLeftElbow, armLeftWrist);
}

public void updateBody() {
  armRightUpper.Update(armRightShoulder, armRightElbow);
  armRightLower.Update(armRightElbow, armRightWrist);
  armLeftUpper.Update(armLeftShoulder, armLeftElbow);
  armLeftLower.Update(armLeftElbow, armLeftWrist);
}

public void drawBody() {
  drawArmRight();
  drawArmLeft();
}

public void drawArmRight() {
  armRightWrist.Display();
  armRightElbow.Display();
  armRightShoulder.Display();
  armRightUpper.Display();
  armRightLower.Display();
}

public void drawArmLeft() {
  armLeftWrist.Display();
  armLeftElbow.Display();
  armLeftShoulder.Display();
  armLeftUpper.Display();
  armLeftLower.Display();
}

