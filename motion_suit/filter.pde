//vars used in the lowpass filtering of the incoming X coordinate
float xLPFy;
float xLPFa;
float xLPFs;
boolean xLPFinitialized;
float dxLPFy;
float dxLPFa;
float dxLPFs;
boolean dxLPFinitialized;
//vars used for the 1 euro filter parameters for the X coordinate
float xOEFfreq;
float xOEFmincutoff;
float xOEFbeta;
float xOEFdcutoff;
float xOEFoldTime = 0.0;
float xOEFnewTime = 0.0;

//lowpass filtering methods
void xLPFsetAlfa(float alfa)
{
  if (alfa < 0.0) {
    xLPFa = 0.0;
  }
  else if (alfa > 1.0) {
    xLPFa
      = 1.0;
  }
  else {
    xLPFa = alfa;
  }
}

void dxLPFsetAlfa(float alfa)
{
  if (alfa < 0.0) {
    dxLPFa = 0.0;
  }
  else if (alfa > 1.0) {
    dxLPFa = 1.0;
  }
  else {
    dxLPFa = alfa;
  }
}

void xLowPassFilter(float alfa, float initval)
{
  xLPFy = initval;
  xLPFs = initval;
  xLPFsetAlfa(alfa);
  xLPFinitialized = false;
}

void dxLowPassFilter(float alfa, float initval)
{
  dxLPFy = initval;
  dxLPFs = initval;
  dxLPFsetAlfa(alfa);
  dxLPFinitialized = false;
}

float xLPFfilter(float value)
{
  float result;
  if (xLPFinitialized) {
    result = xLPFa * value + (1.0 - xLPFa) * xLPFs;
  } 
  else {
    result = value;
    xLPFinitialized = true;
  }
  xLPFy = value;
  xLPFs = result;
  return result;
}

float dxLPFfilter(float value)
{
  float result;
  if (dxLPFinitialized) {
    result = dxLPFa * value + (1.0 - dxLPFa) * dxLPFs;
  } 
  else {
    result = value;
    dxLPFinitialized = true;
  }
  dxLPFy = value;
  dxLPFs = result;
  return result;
}

float xLPFfilterWithAlfa(float value, float alfa)
{
  xLPFsetAlfa(alfa);
  return xLPFfilter(value);
}

float dxLPFfilterWithAlfa(float value, float alfa)
{
  dxLPFsetAlfa(alfa);
  return dxLPFfilter(value);
}

//one euro filtering methods
float xOEFalfa(float cutoff, float frequency)
{
  float te = 1.0/frequency;
  float tau = 1.0/(2*PI*cutoff);
  return 1.0/(1.0+tau/te);
}

void xOneEuroFilter(float freq, float mincutoff, float beta, float dcutoff)
{
  xOEFfreq = freq;
  xOEFmincutoff = mincutoff;
  xOEFbeta = beta;
  xOEFdcutoff = dcutoff;
  xLowPassFilter(xOEFalfa(mincutoff, xOEFfreq), 0.0);
  dxLowPassFilter(xOEFalfa(dcutoff, xOEFfreq), 0.0);
}

float xOEFfilter(float value)
{
  xOEFoldTime = xOEFnewTime;
  xOEFnewTime = millis();
  xOEFfreq = 1.0 / ((xOEFnewTime - xOEFoldTime) / 1000.0);
  float dvalue;
  if (xLPFinitialized) {
    dvalue = (value - xLPFy) * xOEFfreq;
  }
  else {
    dvalue = 0.0;
  }
  float edvalue = dxLPFfilterWithAlfa(dvalue, xOEFalfa(xOEFdcutoff, xOEFfreq));
  float cutoff = xOEFmincutoff + xOEFbeta * abs(edvalue);
  return xLPFfilterWithAlfa(value, xOEFalfa(cutoff, xOEFfreq));
}
