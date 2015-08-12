// Program : Particale System Re-Write 
// Project : Rookie 2013 Fashion Show Twitter Feed
// Author  : Dave Brown

// Revision : Updates and optimization tweaks courtesy of Stefan Marks


// todo : particles based on word length
// todo : check to see what happens when there are no entries in the queue

int fontSize = 60;
int maxParticles = 15000; // seems to be a good amount without slowing down the program too much
int particleScale = 100;

int secondsPerTransition = 10; // amount of time for each transition
int framesPerSecond = 30;
int framesPerTransition = secondsPerTransition * framesPerSecond;
int transitionTime = framesPerTransition;

//String hiddenWord = "THIS IS A TEST";
color hiddenColor = color(1);
int textX;
int textY;
float xScale = 0.60;
float yScale = 1.50;

int index = 0;
int loopTime = 0;

ArrayList<Particle> pArray;
PFont font;
PImage rookieLogo;

PVector testPixel = new PVector();

boolean useLogo = false;


void setup()
{
  size(1920, 1080, P2D);
  frameRate(framesPerSecond); 
  font = createFont("NeueHaasGroteskBlk.ttf", fontSize);  
 // rookieLogo = loadImage("rookie-logo.png");
  rookieLogo = loadImage("rookiebigger.png");
  textFont(font);
  textSize(fontSize);
  textAlign(LEFT, TOP);
  // create the pArray
  pArray = new ArrayList<Particle>();
  
  // populate the particle array with random particles
  for(int i = 0; i < maxParticles; i++)
  {
    float randX = random(0, width); // random screen location
    float randY = random(0, height);
    pArray.add(new Particle(randX, randY));
  }
  
  // initialize the twitterQueue
  queueTweet(tweetText, userName);
  // Connect to twitter stream
  connectTwitter();
  
  tstream.addListener(listener);
    
  if(searchKeyword.length==0) tstream.sample();  
  else tstream.filter(new FilterQuery().track(searchKeyword));
  sketchFullScreen();
}

boolean sketchFullScreen() {
  return true;
}

void draw()
{
  background(0);
  
  // controls the time between drawing the word at a new location
  // reached the end of the time loop
  if(loopTime == 0) 
  {
    ready = !ready;
    formatTweet(getQueueTweet());
    // clear the existing array and populate with current one
    
//    // make a copy of current Particle array
//    ArrayList<Particle> plTemp = new ArrayList(pArray);
//    
//    // clear the pArray
//    pArray.clear();
//    
//    // repopulate it with the data from plTemp up to the weighted max amount of particles
//    
//    // set new maxParticles
//    maxParticles = tweetLength * particleScale;
//    println(maxParticles);
//    int count = 0;
//    pArray.ensureCapacity(maxParticles);
//    while(pArray.size() < maxParticles)
//    {
//      pArray.add(plTemp.get(count));
//      count++;
//    }
//    int temp = pArray.size();
//    println(temp);
//    //pArray.subList(maxParticles, temp).clear();
//    
//    // copy over entries up to the max particles
//    
    
    ////
      // reset the flags on the particles
    for(Particle p : pArray)
    {
      p.inTransit = false;
    }
      // reset the loopTime counter
    loopTime = transitionTime;
  //// set destination for each particle
  
  // if its the image.. make the changes here
    if(wordList.get(0).equals("@SYSTEM") == true)
    { 
      useLogo = true; 
    }
    else
    {
      useLogo = false;
    }
    
    if(useLogo)
    {
      loopTime = (int)framesPerTransition / 3;
      //Len = rookieLogo.width;
      //lines = rookieLogo.height;
      textX = (int)random(0, width - rookieLogo.width);
      textY = (int)random(0, height - rookieLogo.height);
      tint(hiddenColor);
      image(rookieLogo, textX, textY);
    }
    else
    {
      loopTime = framesPerTransition;
      // creates X and Y locations bounded by the word length and screen
      textX = (int)random(0, width - (Len * fontSize) * xScale);
      textY = (int)random(0, height - (lines * fontSize) * yScale);
      // draws text on the screen in the secret colour
      fill(hiddenColor);
      
      int count = 0;
      for(String i : wordList)
      {
        
        text(i, textX, textY + (fontSize * yScale) * count);
        count++;
      }
    }
    // do a pixel comparison of the pixel within the location parameters
    loadPixels();
  }
  
  // motion easing based on remaining frames
  
  // only do this after the first 10 frames have elasped
  // have the particles scatter out by a scaled amount
  if(loopTime == 1)
  {
    final float rotSpeed = random(-10, 10);
    final float explodeSpeed = random(10, 100);
    for ( Particle p : pArray )
    {
      p.explode(explodeSpeed, rotSpeed);
    }
    // new destination has been set...
  }
  else
  {
    for ( Particle p : pArray )
    {
      if(useLogo)
      {
        // for image calculation
        testPixel.set((int)random(textX, textX + rookieLogo.width), (int)random(textY, textY + rookieLogo.height));
      }
      else
      {
        // for word calculation
        // pick a random bounded pixel for comparison
        testPixel.set((int)random(textX, textX + (Len * fontSize) * xScale),
                      (int)random(textY, textY + (lines * fontSize) * yScale));
      }
      // find its location in the pixel buffer
      int pixelLoc = (int)(testPixel.y * width + testPixel.x); 
      // save the color of the pixel
      color pixelColor = pixels[pixelLoc];
      // compare with secret color for a match
      if(pixelColor == hiddenColor)
      {
        // take a copy of particle at indexed location
        Particle foundParticle = pArray.get(index);
        if(!foundParticle.inTransit)
        {
          // particle is currently not moving toggle its moving flag
          foundParticle.inTransit = true;
          // update its destination
          foundParticle.destination.set(testPixel);
          // set random velocity
          foundParticle.velocity = random(0.05, 0.1);
        }
        
        index++;
        index=index % maxParticles; // index will reset at maxParticles
      }
    }
  }
  
  loopTime--;
//  textSize(10);
//  text("Queued Tweets : " + tweetQueue.size(),10,30);
//  textSize(fontSize);
  // draw the particles

  for(Particle p : pArray)
  {
    // display the current location of the particle
    p.update();
    p.display();
  }  
  
  // println(frameRate);
}


