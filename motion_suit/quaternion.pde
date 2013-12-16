class Vector { 
  float xpos, ypos, zpos; 
  Vector (float xpos, float ypos, float zpos) {  
    this.xpos = xpos; 
    this.ypos = ypos;
    this.zpos = zpos;
  }
  float lengte()
  {
    float lengte = sqrt(sq(xpos)+sq(ypos)+sq(zpos));
    return lengte;
  }
  void update(float xpos, float ypos, float zpos)
  {
    this.xpos = xpos; 
    this.ypos = ypos;
    this.zpos = zpos;
  }
}
/////////////////////////////////////////////

class Quaternion {
  float Qw, Qx, Qy, Qz;

  Quaternion (float Qw, float Qx, float Qy, float Qz) {
    this.Qw=Qw;
    this.Qx=Qx;
    this.Qy=Qy;
    this.Qz=Qz;
  }

  float lengte ()
  {
    float lengte = sqrt(sq(Qw)+sq(Qx)+sq(Qy)+sq(Qz));
    return lengte;
  }

  Quaternion NormalizeQ()
  {
    Quaternion result = new Quaternion(Qw/lengte(), Qx/lengte(), Qy/lengte(), Qz/lengte());
    return result;
  }

  void Ve(Vector ve)
  {
    this.Qx=ve.xpos;
    this.Qy=ve.ypos;
    this.Qz=ve.zpos;
  }

  Vector V()
  {
    Vector Qvec = new Vector(Qx, Qy, Qz);
    return Qvec;
  }

  float draaingw()
  {
    return acos(Qw)*2;
  }

  float draaingx()
  {
    return acos(Qw)*2;
  }
}
/////////////////functies

Quaternion Inverse(Quaternion Q)
{
  Quaternion Qi = new Quaternion(Q.Qw, -Q.Qx, -Q.Qy, -Q.Qz);
  return Qi;
}

Quaternion VermenigvuldigQ(Quaternion Qs, Quaternion Qr) // vermenig vuldigen van Quaternion
{
  Quaternion Resultaat=new Quaternion(0, 0, 0, 0); 
  Resultaat.Qw=((Qs.Qw*Qr.Qw)-VermenigvuldigVectoren(Qs.V(), Qr.V()));//Qw = Ws*Wr-Vs*Vr

  //VermenigvuldigV(Qs.Qw,Qr.V())    Ws*Vr
  //VermenigvuldigV(Qr.Qw,Qs.V())    Wr*Vs
  //Kruisproduct(Qr.V(),Qs.V())      VrXVs
  /*
  Resultaat.Ve(VermenigvuldigV(Qs.Qw,Qr.V()));
   println("verm:");
   println(Resultaat.Qx +" " + Resultaat.Qy  +" " + Resultaat.Qz);
   Resultaat.Ve(OptellenV(Resultaat.V(),VermenigvuldigV(Qr.Qw,Qs.V())));
   println(Resultaat.Qx +" " + Resultaat.Qy  +" " + Resultaat.Qz);
   Resultaat.Ve(OptellenV(Resultaat.V(),Kruisproduct(Qr.V(),Qs.V())));
   println(Resultaat.Qx +" " + Resultaat.Qy  +" " + Resultaat.Qz);
   */
  Resultaat.Ve((OptellenV(OptellenV(VermenigvuldigV(Qs.Qw, Qr.V()), VermenigvuldigV(Qr.Qw, Qs.V())), Kruisproduct(Qr.V(), Qs.V()))));//Qv=(Ws*Vr)+(Wr*Vs)+(VrXVs)
  return Resultaat;
}

Vector Kruisproduct(Vector V2, Vector V1)
{
  Vector resultaat=new Vector(0, 0, 0);
  resultaat.xpos=(V1.ypos*V2.zpos)-(V1.zpos*V2.ypos);
  //("hallo");
  //println(V1.ypos+"*"+V2.zpos+"-"+V1.zpos+"*"+V2.ypos);
  //println(resultaat.xpos);
  resultaat.ypos=V1.zpos*V2.xpos-V1.xpos*V2.zpos;
  resultaat.zpos=V1.xpos*V2.ypos-V1.ypos*V2.xpos;  
  return resultaat;
}
/////////////////////////////////////
Vector VermenigvuldigV(float a, Vector V)
{
  Vector result=new Vector(V.xpos*a, V.ypos*a, V.zpos*a);
  return result;
}

float VermenigvuldigVectoren(Vector a, Vector b)
{
  return a.xpos*b.xpos+a.ypos*b.ypos+a.zpos*b.zpos;
}

Vector OptellenV(Vector a, Vector b)
{
  Vector result=new Vector(a.xpos+b.xpos, a.ypos+b.ypos, a.zpos+b.zpos);
  return result;
}

Quaternion Slerping(Vector a, Quaternion b)
{
  Quaternion result = new Quaternion(0, 0, 0, 0);
  result.Ve(a);
  result=VermenigvuldigQ(VermenigvuldigQ(b, result), Inverse(b));
  return result;
}

