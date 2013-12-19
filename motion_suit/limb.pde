class Limb {
  float x1, y1, z1;
  float x2, y2, z2;
  float xMiddle, yMiddle, zMiddle;

  // Constructor
  Limb(Sensor point1, Sensor point2) {
    this.x1 = point1.x;
    this.y1 = point1.y;
    this.z1 = point1.z;
    this.x2 = point2.x;
    this.y2 = point2.y;
    this.z2 = point2.z;

    xMiddle = (x1 + x2)/2;
    yMiddle = (y1 + y2)/2;
    zMiddle = (z1 + z2)/2;
  }

  void Update(Sensor point1, Sensor point2) {
    this.x1 = point1.x;
    this.y1 = point1.y;
    this.z1 = point1.z;
    this.x2 = point2.x;
    this.y2 = point2.y;
    this.z2 = point2.z;

    xMiddle = (x1 + x2)/2;
    yMiddle = (y1 + y2)/2;
    zMiddle = (z1 + z2)/2;
  }

  void Display() {
    /*pushMatrix();
     
     beginShape(TRIANGLES);
     fill(0, 0, 255);
     // Bovenste helft
     vertex(x1, y1, z1);
     vertex(xMiddle, yMiddle-1, zMiddle-1);
     vertex(xMiddle, yMiddle+1, zMiddle-1);
     
     vertex(x1, y1, z1);
     vertex(xMiddle, yMiddle+1, zMiddle-1);
     vertex(xMiddle, yMiddle+1, zMiddle+1);
     
     vertex(x1, y1, z1);
     vertex(xMiddle, yMiddle-1, zMiddle+1);
     vertex(xMiddle, yMiddle+1, zMiddle+1);
     
     vertex(x1, y1, z1);
     vertex(xMiddle, yMiddle-1, zMiddle-1);
     vertex(xMiddle, yMiddle-1, zMiddle+1);
     
     // Onderste helft
     vertex(x2, y2, z2);
     vertex(xMiddle, yMiddle-1, zMiddle-1);
     vertex(xMiddle, yMiddle+1, zMiddle-1);
     
     vertex(x2, y2, z2);
     vertex(xMiddle, yMiddle+1, zMiddle-1);
     vertex(xMiddle, yMiddle+1, zMiddle+1);
     
     vertex(x2, y2, z2);
     vertex(xMiddle, yMiddle-1, zMiddle+1);
     vertex(xMiddle, yMiddle+1, zMiddle+1);
     
     vertex(x2, y2, z2);
     vertex(xMiddle, yMiddle-1, zMiddle-1);
     vertex(xMiddle, yMiddle-1, zMiddle+1);
     endShape();
     
     popMatrix();*/

    drawLine(x1, y1, z1, x2, y2, z2, 1.0, cBlue);
  }
}

