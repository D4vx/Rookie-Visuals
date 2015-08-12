String[] searchKeyword = {"#rookie13", "#AUTrookie"};

String tweetText = "this is a test tweet more to test with this particular method of writing a long ass tweet hahah it will be interesting to see how this pans out";
String userName;
/// This is where you enter your Oauth info
static String OAuthConsumerKey = "6S3yUwXt39a2tObbuhKgew";
static String OAuthConsumerSecret = "K3qyM4jGa1h5CHC0NsntHae57CdaozkJY6ybu6BOf4";
// This is where you enter your Access Token info
static String AccessToken = "453432604-EGc0xwvZCKwCSecwk51uFPTCjfL6nF9eOHB88mld";
static String AccessTokenSecret = "xlD67VS7WP9LV54P4gHf0AJ3ITS7fSJ4ogKlDg76XNanw";

// Sets the instance of a twitter stream
TwitterStream tstream = new TwitterStreamFactory().getInstance();

int logoCount = 0;
int insert = 5;

void connectTwitter() {
  tstream.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  tstream.setOAuthAccessToken(accessToken);
}


// Loading up the access token
private static AccessToken loadAccessToken() {
  return new AccessToken(AccessToken, AccessTokenSecret);
}



StatusListener listener = new StatusListener() {
  
  public void onStatus(Status status) {
    //println("-"+x+" @" + status.getUser().getScreenName() + " - " + status.getText());
    //displayTw(status);
    
    // periodically add the rookie logo into the mix
    // randomly between 4 and 8 tweets.. add the rookie logo
    //int insert = (int)random(4,8);

    if(logoCount == insert) 
    {
      tweetText = "<";
      userName = "SYSTEM";
      logoCount = 0;
    }
    else
    {
      tweetText = status.getText();
      userName = status.getUser().getScreenName();
      logoCount++;
    }
    
    logoCount = logoCount % 6;
    queueTweet(tweetText, userName); 
  }

  public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
    //System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
  }
  public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
    // System.out.println("Got track limitation notice:" + numberOfLimitedStatuses);
  }
  public void onScrubGeo(long userId, long upToStatusId) {
    //System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
  }
  
  public void onStallWarning(StallWarning warning) {
    //System.out.println("Got stall warning:" + warning);
  }

  public void onException(Exception ex) {
    ex.printStackTrace();
  }
};
