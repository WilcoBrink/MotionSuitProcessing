class Sensor {
  public float x, y, z, yaw, pitch, roll;      // X, Y and Z coordinates

  // Constructor
  Sensor(float x, float y, float z, float yaw, float pitch, float roll) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.roll = roll;
    this.pitch = pitch;
    this.yaw = yaw;
  }

  void Display() {
    pushMatrix();
    translate(x, y, z);
    rotateX(yaw);
    rotateY(pitch);
    rotateZ(roll);
    fill(0, 255, 0);
    box(1);
    popMatrix();
  }
}

