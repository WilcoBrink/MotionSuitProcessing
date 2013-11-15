public void initBody() {
  armRightWrist = new Sensor(-35.0, 0.0, 0.0, 0.0, 0.0, 0.0);
  armRightElbow = new Sensor(-25.0, 0.0, 0.0, 0.0, 0.0, 0.0);
  armRightShoulder = new Sensor(-15.0, 0.0, 0.0, 0.0, 0.0, -20.0);

  armRightUpper = new Limb(armRightShoulder, armRightElbow);
  armRightLower = new Limb(armRightElbow, armRightWrist);

  armLeftWrist = new Sensor(35.0, 0.0, 0.0, 0.0, 0.0, 0.0);
  armLeftElbow = new Sensor(25.0, 0.0, 0.0, 0.0, 0.0, 0.0);
  armLeftShoulder = new Sensor(15.0, 0.0, 0.0, 0.0, 0.0, 20.0);

  armLeftUpper = new Limb(armLeftShoulder, armLeftElbow);
  armLeftLower = new Limb(armLeftElbow, armLeftWrist);
  
  legRightFoot = new Sensor(-10.0, 40.0, 0.0, 0.0, 0.0, 0.0);
  legRightKnee = new Sensor(-10.0, 30.0, 0.0, 0.0, 0.0, 0.0);
  legRightHip = new Sensor(-10.0, 20.0, 0.0, 0.0, 0.0, 0.0);
  
  legRightLower = new Limb(legRightFoot, legRightKnee);
  legRightUpper = new Limb(legRightKnee, legRightHip);
  
  legLeftFoot = new Sensor(10.0, 40.0, 0.0, 0.0, 0.0, 0.0);
  legLeftKnee = new Sensor(10.0, 30.0, 0.0, 0.0, 0.0, 0.0);
  legLeftHip = new Sensor(10.0, 20.0, 0.0, 0.0, 0.0, 0.0);
  
  legLeftLower = new Limb(legLeftFoot, legLeftKnee);
  legLeftUpper = new Limb(legLeftKnee, legLeftHip);
  
  chestHip = new Sensor(0.0, 10.0, 0.0, 0.0, 0.0, 0.0);
  chestBreast = new Sensor(0.0, -5.0, 0.0, 0.0, 0.0, 0.0);
  
  chestRightHip = new Limb(chestHip, legRightHip);
  chestLeftHip = new Limb(chestHip, legLeftHip);
  chestCentral = new Limb(chestHip, chestBreast);
  chestRightShoulder = new Limb(chestBreast, armRightShoulder);
  chestLeftShoulder = new Limb(chestBreast, armLeftShoulder);
}

public void updateBody() {
  armRightUpper.Update(armRightShoulder, armRightElbow);
  armRightLower.Update(armRightElbow, armRightWrist);
  armLeftUpper.Update(armLeftShoulder, armLeftElbow);
  armLeftLower.Update(armLeftElbow, armLeftWrist);
  legRightLower.Update(legRightFoot, legRightKnee);
  legRightUpper.Update(legRightKnee, legRightHip);
  legLeftLower.Update(legLeftFoot, legLeftKnee);
  legLeftUpper.Update(legLeftKnee, legLeftHip);
  chestRightHip.Update(chestHip, legRightHip);
  chestLeftHip.Update(chestHip, legLeftHip);
  chestCentral.Update(chestHip, chestBreast);
  chestRightShoulder.Update(chestBreast, armRightShoulder);
  chestLeftShoulder.Update(chestBreast, armLeftShoulder);
}

public void drawBody() {
  drawArmRight();
  drawArmLeft();
  drawLegRight();
  drawLegLeft();
  drawChest();
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

public void drawLegRight() {
  legRightFoot.Display();
  legRightKnee.Display();
  legRightHip.Display();
  legRightUpper.Display();
  legRightLower.Display();
}

public void drawLegLeft() {
  legLeftFoot.Display();
  legLeftKnee.Display();
  legLeftHip.Display();
  legLeftUpper.Display();
  legLeftLower.Display();
}

public void drawChest() {
  chestHip.Display();
  chestBreast.Display();
  chestRightHip.Display();
  chestLeftHip.Display();
  chestCentral.Display();
  chestRightShoulder.Display();
  chestLeftShoulder.Display();
}
