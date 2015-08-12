

class Particle
{
  PVector location;        // current location
  PVector destination;     // destination
  PVector repel;           // repel vector
  float   rotS, rotC;      // rotation spped sin/cos
  float   velocity;          // velocity 
  float   size;              // size of the particle
  
  boolean inTransit = false; // movement state of the particle
  
  Particle(float x, float y)
  {
    location = new PVector(x,y);
    destination = new PVector(width/2, height/2);  // travelling to center of the screen
    velocity = 0.0;                                // velocity
    size = random(1, 4);
    repel = new PVector();
  }
  
  void explode(float maxSpeed, float rotSpeed)
  {
    repel.set(random(-maxSpeed,+maxSpeed), random(-maxSpeed,+maxSpeed));
    rotSpeed = radians(rotSpeed);
    rotS = sin(rotSpeed);
    rotC = cos(rotSpeed);
  }
  
  void update()
  {    
    //tempV = PVector.lerp(location, destination, velocity);
    //location.set(tempV);
    location.lerp(destination, velocity);
    // add repel vector, which will get smaller and smaller
    location.add(repel);
    repel.mult(0.9);
    //repel.rotate(0.1);
    // "manual" rotation
    float xn = repel.x * rotC - repel.y * rotS;
    float yn = repel.x * rotS + repel.y * rotC;
    repel.set(xn, yn);
  }
  
  void display()
  {
    stroke(255);
    
    //noFill();
    //fill(255 - location.dist(destination));
    //rectMode(CORNER);

    //int sizeScale = (int)random(1,2.5);
    int sizeScale = (int)random(1,2.5);
    strokeWeight(2 * sizeScale);
    //ellipse(location.x, location.y, size*sizeScale, size * sizeScale);
    //rect(location.x, location.y, size * sizeScale, size * sizeScale);
    point(location.x, location.y);
  }
}
