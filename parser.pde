// create the text break component

boolean ready = false;
// characters per line

// lines counter;
int lines = 0;

int charsPerLine = 45;
int Len = charsPerLine; // set legnth based on max characters per line of a tweet
int maxTweetLength = 140;
int tweetLength = 0;

int maxLines = (maxTweetLength / charsPerLine) + 1;

StringList wordList = new StringList();
StringList tweetQueue = new StringList();

static int maxQueuedTweets = 150;


// each tweet comes in and is tested against total word length...
void formatTweet(String tweet)
{
  wordList.clear(); // clears the word Arraylist
  String tempString = "";
 
  if(ready)
  {
    // reset the line counter for next use;
    lines = 1; 
    // get total length of tweet
    tweetLength = tweet.length();  

    // build the string for the first line up to the total length of each line
    
    // cut the tweet into individual words using ' ' as delimeter
    String[] cutString =split(tweet, ' ');
    
    // PROCESS //
    // add each word to the temp string.... line will equal 1
    // check for max string length ... if exceed goto next line
    // if end of tweet and lines still = 0... add the tempstring to 
    
    // add the username here
    wordList.append(cutString[0]); // adds the name
    lines++;                       // moves to next line
    
    for(int i = 1 ; i < cutString.length; i++)
    {
      if(tempString.length() + cutString[i].length() + 1 > charsPerLine)
      { 
        // commit the temp string to the arraylist
        // add the word to the temp string
        wordList.append(tempString);
        tempString = ""; // reset the string
        lines++;
      }
      
      // add words to the string builder
      tempString += cutString[i] + " ";    
      
    }
    // commit the last line
    wordList.append(tempString);
    ready = !ready;
  }
  
  // debug
  println(lines); 
  int count = 1;
  
  for(String s : wordList)
  {
    println("Line : " + count + " > " + s);
    count++;
  }
}


void queueTweet(String qTweet, String uName)
{
  // adds the username and tweet to the queue
  if(tweetQueue.size() < maxQueuedTweets)
  {
    String temp = "@" + uName + " " + qTweet;
    tweetQueue.append(temp);  
  }
}

String getQueueTweet()
{  
  // always give the top of the queue, then remove from the queue
  // check that tweet queue isnt empty first 
  String temp = tweetQueue.get(0);
  tweetLength = temp.length();
  tweetQueue.remove(0);
  if(tweetQueue.size() == 0) //  if the queue is empty
  {
    tweetText = "<";
    userName = "SYSTEM";
    queueTweet(tweetText, userName);
  }
  return temp;
}


// take a screenshot on keypress
void keyPressed()
{
  PImage saveFile = createImage(width, height, RGB);
  loadPixels();
  saveFile.pixels = pixels;
  saveFile.save("screenShot" + day() + "." + month() + "." + year() + "-" + hour() + "." + minute() + "." + second() + ".png");
  if(sketchFullScreen()) { !sketchFullScreen(); }
}
