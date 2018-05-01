import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import processing.sound.*;

SoundFile file;
Minim minim;
AudioInput ai;
ddf.minim.analysis.FFT fft;
String audioName;
String path;
boolean Keypressed = false;
boolean chase;
particle [] parts;
int numparticles; 
int ppr; 
int screen; 
float spacing=0.8; 
int dark=20; 
color darkness=color(dark,dark,dark,0); 
float segments = 100;
float r= 100;
float cx,cy;


void setup()
{
  audioName = "Gerudo.mp3";
  size(1024, 500);
  if (Keypressed)
  {
     audioName = "90s.mp3";
  strokeWeight(3);
  loadPixels();
  screen = width*height;
  numparticles=int(screen/(spacing*spacing));
  ppr = int(width/spacing);
  parts = new particle[numparticles];
  for(int i=0; i<numparticles; i++)
    {
      parts[i]=new particle((i*spacing)%width,i/ppr*spacing);
      path = sketchPath(audioName);
   file = new SoundFile(this, path);
    }
  }
  else
  {
    minim = new Minim(this);
  ai = minim.getLineIn(Minim.MONO, width, 44100, 16);
  fft = new ddf.minim.analysis.FFT(width, 44100);
  path = sketchPath(audioName);
   file = new SoundFile(this, path);
  cx = width/2;
  cy = height/2;
  }
     file.play();
}

void pont(float X, float Y)
{
  color C = pixels[(int(X)+int(Y)*width)%screen];
  pixels[(int(X)+int(Y)*width)%screen]=max(#000000,C-darkness);
}

class particle
{
  float posx, posy, xinit, yinit;
  float speedx, speedy;
  particle(float X, float Y) 
  {
    posx=xinit=X;
    posy=yinit=Y;
  }
  
  void home()
  {
    chase(xinit,yinit,1);
  }
  
  void chase(float mx,float my,float force)
  {
    float dx=(posx-mx);
    float dy=(posy-my);
    force/=(dx*dx+dy*dy);
    if (abs(dx)<1&&abs(dy)<1)
    {
    speedx=speedy=force=0;
  } 
  else
  {
    speedx-=(dx*force);
    speedy-=(dy*force);
    }
  }
  
  void show()
  {
    speedx*=0.99;
    speedy*=0.99;
    posx+=speedx;
    posy+=speedy;
    posx=constrain(posx,0,width);
    posy=constrain(posy,0,height);
    pont(posx,posy);
  }
}

void keyPressed()
{
  if( key == TAB)
  {
  Keypressed = !Keypressed;
  }
}

void draw()
{
  if (Keypressed)
  {
   for (int i=0; i<screen; i++){pixels[i]=#ffffff;
  }
  chase = mousePressed;
  for(int i=0; i<numparticles; i++)
    {
    if(chase){parts[i].chase(mouseX,mouseY,-2);
  }
    else {parts[i].home();
     }
    parts[i].show();
    }
updatePixels();
  }
  else
  {
     background(0);
  colorMode(HSB);
  for(int i = 0; i < ai.bufferSize(); i++)
    {
        stroke(map(i,0,ai.bufferSize(),0,255),255,255);
        float x = cx + cos(i) * r;
        float y = cy + sin(i) * r;
        float fx = cx + cos(i) * (r + (ai.left.get(i))*50);
        float fy = cy + sin(i) * (r + (ai.left.get(i))*50);
        line(x,y,fx,fy);
    }
  
  fft.window(ddf.minim.analysis.FFT.HAMMING);
  fft.forward(ai.left);
  
  for(int i = 0; i < fft.specSize(); i++)
  {
   stroke(map(i,0,ai.bufferSize(),0,255),255,255);
   
   float x = cx + cos(i) * r;
   float y = cy + sin(i) * r;
   float fx = cx + cos(i) * (r + (fft.getBand(i)*5));
   float fy = cy + sin(i) * (r + (fft.getBand(i)*5));
    
   line(x,y,fx,fy);
  } 
}
}
  
