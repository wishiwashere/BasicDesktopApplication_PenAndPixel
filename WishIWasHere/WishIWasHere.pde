import processing.video.*;

// Importing the Twitter4J library (for sending tweets to Twitter using a users's account, if they have logged in with Twitter)
import twitter4j.*;
import twitter4j.conf.*;

// Capture Library
import processing.video.*;

// Importing the Java library (to create File objects, and ArrayList arrays)
import java.io.File;
import java.util.ArrayList;

/*-------------------------------------- Navigation/Status Variables -------------------------*/
// Setting the default screen to be the LoadingScreen, so that when the app is loaded,
// this is the first screen that is displayed. Since this global variable is available
// throughout the sketch (i.e. within all classes as well as the main sketch) we will
// use this variable to pass in the value of "iconLinkTo" when the icon is clicked on
// within the checkMouseOver() method of the ClickableElement class. The variable will
// then be tested against each of the potential screen names (in the this class's
// switchScreens() function) to decide which class should have the showScreen() method
// called on it i.e. (which screen should be displayed).
public String currentScreen = "LoadingScreen";

// Creating a global variable, which any icon can use to pass the name of the function
// they link to. The value of this variable is set in the Icon class when an icon is clicked
// on, and it's iconLinkTo value begins with a "_". This is a naming convention we created
// so that it is clearer which icons link to screens and which link to functions.
public String callFunction = "";

// Creating a global variable, which can be used to determine if a user has clicked on an
// element. Using a custom variable to store this, as opposed to using the Processing mousePressed
// variable, as we want to differentiate between a mouse being clicked and a mouse being pressed
// (i.e. clicking or scrolling). This variable will be set to true when a mousePressed() event
// occurs, and then reset to false when a element identifies itself as having been clicked on,
// or when a scrolling event is detected.
public Boolean mouseClicked = false;

// Creating public booleans, to monitor which functionalities are currently turned on/off.
// If a user has autoSaveModeOn turned on, as defined by their user preferences, this boolean
// will be true. They can then toggle this functionality on/off in the Settings screen, to choose
// whether saving will be automatically enabled for all images.
// If a user has learningModeOn turned on, as defined by their user preferences, this boolean
// will be true. They can then toggle this functionality on/off in the Settings screen, to choose
// whether they want to see the learning mode suggestions when they use the app or not.
// If a user is logged in to Twitter, then sendToTwitterOn will be changed to true. If they
// then decided to disable/enable sending to Twitter for individual images (in SaveShareScreenA)
// then this boolean will toggle on/off.
// If a user has autoSaveModeOn turned on, then saveThisImageOn will also be set to true. If a user
// then wants to turn off saving for an individual image, they can toggle this functionality on/off
// in SaveShareScreenA, while not affecting their overall autoSaveModeOn setting. Images will only
// ever save to the device when saveThisImageOn is set to true, regardless of whether autoSaveMode
// is on or off (to allow the user to make individual choices for each image).
public Boolean autoSaveModeOn = true;
public Boolean learningModeOn = false;
public Boolean sendToTwitterOn = false;
public Boolean saveThisImageOn = true;
public Boolean twitterLoggedIn = true;

// Creating public booleans, which result screens (such as ShareSaveSuccessfulScreen) will use to
// determine which actions were successfully completed i.e. if the image was shared, saved or
// both. These variables will only ever be set to true when the action has completed successfully
// and reset to false when the user goes back to the CameraLiveViewScreen
public Boolean imageShared = false;
public Boolean imageSaved = false;

// Creating a private boolean, to detect whether an image merge is currently being completed
// i.e. so no new images will be read in from the device's camera, or sent to the removeGreenScreen()
// thread (to reduce the risk of the memory of the device becoming overloaded
private Boolean imageMerging = false;

// Creating a private boolean, to detect whether an image is currently being read in and keyed by
// the removeGreenScreen() thread i.e. so no new images will be read in from the device's camera,
// or sent to the removeGreenScreen() thread (to reduce the risk of the memory of the device becoming
// overloaded
private Boolean readingImage = false;

/*-------------------------------------- XML Data --------------------------------------------*/
// Creating an array of random locations based on the random location XML file in the
// assets folder. Storing these in a separate XML file to the user preferences, so that
// even if a user deletes all of their favourite locations, there will still be random
// locations available to them.
// Each location has a latLng attribute, which represents the latitude
// and longitude of the location, a heading attribute which represents the left/right
// positioning of the view (between 0 and 360) and a pitch attribute which represents
// the up/down angle of the view (between -90 and 90).
// In the original Google Street View URL (from the browser) i.e. the Colosseum
// url was https://www.google.ie/maps/@41.8902646,12.4905161,3a,75y,90.81h,95.88t/data=!3m6!1e1!3m4!1sR8bILL5qdsO7_m5BHNdSvQ!2e0!7i13312!8i6656!6m1!1e1
// the first two numbers after the @ represent the latitude and longitude, the number
// with the h after it represents the heading, and the number with the t after it
// seems to be to do with the pitch, but never works that way in this
// method so I just decided the pitch value based on what looks good
private XML[] randomLocations;

private int currentLocationIndex = 0;

// Creating a variable to store the full XML which will be read in from the user_preferences.xml file
// so that it can later be resaved/reloaded as needed
private XML userPreferencesXML;

// Creating an array to store the XML elements which contain the favourite locations of the user, as
// sourced from the userPreferencesXML data which will be stored in the variable above
public XML[] favouriteLocationsData;

// Creating an array to store the XML elements which contain the settings of the user, such as autosaveModeOn,
// as sourced from the userPreferencesXML data which will be stored in the variable above
private XML[] settingsData;

/*-------------------------------------- Ketai Camera ----------------------------------------*/
// Creating a global variable to store the capture object, so that we can access the live stream
// of images coming in from the device camera. The images from this camera will never be displayed
// in the app, but will instead be passed to the removeGreenScree() method, so any green
// background can be removed so the user can see themselves as if they are in the current location
public Capture camera;

// Creating a global variable to store the number (identifier) of the device camera we want to view
// at any given time. The front facing camera (on a device with more than one camera)
// will be at index 1, and the rear camera will be at index 0. On a device with only
// 1 camera (such as the college Nexus tablets) this camera will always be at index
// 0, regardless of whether it is a front or back camera
public int camNum;

// Creating a variable to store a value of 1 or -1, to decide whether and image should be
// flipped i.e. when using the front facing camera, the x scale should always be -1 to
// avoid things being in reverse
public int cameraScale = -1;

// Creating a global variable, which will always be set to either 90 or -90 degrees, to ensure
// that the live stream images from the camera area always oriented in the right rotation.
// Initialising at -90 degrees, as we will be starting on the front facing camera
public int cameraRotation = -90;

/*----------------------------------- Twitter ------------------------------------------------*/
// Creating variables to store the API keys required for accessing the Twitter API.
private String twitterOAuthConsumerKey = "huoLN2BllLtOzezay2ei07bzo";
private String twitterOAuthConsumerSecret = "k2OgK1XmjHLBMBRdM9KKyu86GS8wdIsv9Wbk9QOdzObXzHYsjb";
private String twitterOAuthAccessToken = "4833019853-PzhGbWL0lulwsER62Ly7VY7P5WQcJT52j0MSIzI";
private String twitterOAuthAccessTokenSecret = "TazSQHl662mp6GIJkzlWRI5LkjOEnQZ4ifof7V3X3t30C";

// Creating a new instance of the Twitter configuration builder, which will later have the
// above API keys stored within it, so that it can be passed to the TwitterFactory to generate
// a new instance of the Twitter class.
private ConfigurationBuilder cb = new ConfigurationBuilder();

// Declaring an instance of the Twitter class, which will be generated by the TwitterFactory class,
// using the above API keys, which will have been setup on the configuration builder class. We
// will then use the twitter instance to update the user's status i.e. send tweets on the user's
// account (if they are logged in with Twitter)
private Twitter twitter;

/*-------------------------------------- Images ----------------------------------------------*/
// Loading in the general background image, which will be used to "wipe" the screen each time the
// switchScreens method is called. The purpose of this is that individual screens do not need to
// contain their own backgrounds, and thus reduces the load on memory.
private PImage generalPageBackgroundImage;

// Creating a public compiledImage variable, which will store the PImage graphic which contains
// the Google Street View image of the background, the keyed image of the user (from the currentImage,
// as declared below), and the "Wish I Was Here" overlay image, which can then be saved and/or shared.
// This image will also be displayed on the ImagePreviewScreen and the SaveShareScreenA screens.
public PImage compiledImage;

// Creating a global image variable, to store the currentImage. Currently, this is
// used to return the keyed image of the user from the removeGreenScreen() thread.
// It is then used on the CameraLiveViewScreen as an image ontop of the Google Street View
// image, and eventually is added to the compiled image to create the final image the user
// will save/send to Twitter
public PImage currentImage;

// Creating a private variable to pass the image from the Ketai Camera into the removeGreenScreen
// thread. The purpose of using this variable, instead of accessing the image directly from the
// Ketai Camera in the removeGreenScreen thread, is that accessing the pixel array of the camera
// seems to produce unexpected results i.e. distortions in the image
private PImage currentFrame;

/*-------------------------------------- Sizing ----------------------------------------------*/
// Declaring global variables, which will contain the width and height of the device's
// display, so that these values can be reused throughout all classes (i.e. to calculate
// more dynamic position/width/height's so that the interface responds to different
// screen sizes
public int appWidth;
public int appHeight;

// Declaring the icon positioning X and Y variables, which will be used globally to ensure that
// the icons on each page all line up with one another. These measurements will all be based on
// percentages of the app's display, and are initialised in the setup function of this sketch
public float iconLeftX;
public float iconRightX;
public float iconCenterX;
public float iconTopY;
public float iconBottomY;
public float iconCenterY;
public float largeIconBottomY;
public float screenTitleY;

// Declaring the icon sizing variables, which will be used globally to ensure that there will be
// consistency between the sizes of icons throughout the app. These measurements will all be based on
// percentages of the app's display, and are initialised in the setup function of this sketch
public float largeIconSize;
public float smallIconSize;
public float homeIconSize;

// Declaring the default text size variables, so that there will be consistency with the sizing
// of all text within the app
float defaultTextSize;
float screenTitleTextSize;

/*-------------------------------------- Screens ---------------------------------------------*/
// Declaring a new instance of each screen in the application, so that they can be accessed by the
// draw function to be displayed when needed. The FavouritesScreen and the AboutScreen have been
// declared as public, as they will need to be accessed from the HomeScreen class, to reset
// their "loaded" boolean to false, so the scrolling of the screens can be reset before the user
// views them again
private CameraLiveViewScreen myCameraLiveViewScreen;
private LoadingScreen myLoadingScreen;


/*-------------------------------------- Saving ------------------------------------------------*/
// Creating a string that will hold the directory path of where the images will be saved to on the
// device's external storage
private String directory = "";

// Creating a string to store the full path, including the directory (declared above) and the
// filename of the most recent image. This path can then be used either to load the image back
// in to attach it as media for a tweet (to send it out to Twitter) or to create a sharing
// intent (so that the user can share the image with another app on their device).
private String saveToPath;

/*-------------------------------------- Google Street View Images ---------------------------*/
// Creating a variable to store the API keys required for accessing the Google Street View Image API,
// and the Google Geocoding API. Setting the key to be equal to our Google Developer browers developer key.
private String googleBrowserApiKey = "AIzaSyB1t0zfCZYiYe_xXJQhkILcXnfxrnUdUyA";

// Creating a string to store the searchAddress (as defined above) in the format required to add it
// as a parameter to the request URL for the Google Geocoding API, which allows us to search for an address
// and receive an XML response containing the relevant location details (latitude, longitude etc) so that
// we can then use these to request a new image from the Google Street View Image API
private String compiledSearchAddress;

// Creating the global googleImage variables, which will be used to generate the request
// URLs for the Google Geocoding API and the Google Street View Image API. Each location
// has a latLng attribute, which represents the latitude and longitude of the location,
// a heading attribute which represents the left/right positioning of the view (between
// 0 and 360) and a pitch attribute which represents the up/down angle of the view
// (between -90 and 90).
// In the original Google Street View URL (from the browser) i.e. the Colosseum
// url was https://www.google.ie/maps/@41.8902646,12.4905161,3a,75y,90.81h,95.88t/
// data=!3m6!1e1!3m4!1sR8bILL5qdsO7_m5BHNdSvQ!2e0!7i13312!8i6656!6m1!1e1
// the first two numbers after the @ represent the latitude and longitude, the number
// with the h after it represents the heading, and the number with the t after it
// seems to be to do with the pitch, but never works that way in this
// method so I just decided the pitch value based on what looks good
public String currentLocationName = "";
public String googleImageLatLng;
public float googleImagePitch;
public float googleImageHeading;
public int googleImageWidth;
public int googleImageHeight;

// Declaring the currentLocationImage variable, which will be initialised by loading in an image
// from a request to the Google Street View Image API, using the location data held in the variables
// above. It is then used on the CameraLiveViewScreen as an image below of the keyed image of the
// user (currentImage), and eventually is added to the compiled image to create the final image the user
// will save/send to Twitter
public PImage currentLocationImage = null;


/*-------------------------------------- Setup() ---------------------------------------------*/
public void setup() {

  // The size of the app must be set to a resolution which the camera is capable of capturing (as the 
  // camera setup will be based off of this
  //fullScreen();
  size(640, 360);
  //size(1280, 720);
  //size(1920, 1080);

  // Initialising the appWidth and appHeight variable with the width and height of the device's
  // display, so that these values can be reused throughout all classes (i.e. to calculate
  // more dynamic position/width/height's so that the interface responds to different
  // screen sizes
  appWidth = width;
  appHeight = height;

  println("Main Sketch is being reset");
  /*---------------------------------- XML Data --------------------------------------------*/
  // Initialising the array of random locations based on the random location XML file from our
  // GitHub.io site, so that we can update the random locations for all apps, without having to
  // create a new release for the app. Storing these in a separate XML file to the user preferences,
  // so that even if a user deletes all of their favourite locations, there will still be random
  // locations available to them.
  randomLocations = loadXML("https://wishiwashere.github.io/random_locations.xml").getChildren("location");

  // Loading in the user's preferences by calling this class's loadUserPreferencesXML() method, as this
  // process will need to be completed multiple times later on in the app (i.e. to save/delete favourite
  // locations, update settings such as autosave mode etc.
  loadUserPreferencesXML();

  /*---------------------------------- Camera -----------------------------------------------*/
  // Calling the Capture constructor to initialise the camera with the same
  // width/height of the device, with a frame rate of 12.
  camera = new Capture(this, appWidth, appHeight, 30);
  camera.start();

  println("Camera size is: - " + appWidth + " x " + appHeight);

  /*----------------------------------- Twitter --------------------------------------------*/
  // Checking if we are planning to use the app with a Twitter account
  if (twitterLoggedIn) {

    // If a user is logged in to Twitter, then senToTwitterOn will be changed to true. If they
    // then decided to disable/enable sending to Twitter for individual images (in SaveShareScreenA)
    // then this boolean will toggle on/off.
    sendToTwitterOn = true;

    // Setting the Twitter OAuth Consumer keys to our applications credentials, as sourced from
    // our Twitter developer account
    cb.setOAuthConsumerKey(twitterOAuthConsumerKey);
    cb.setOAuthConsumerSecret(twitterOAuthConsumerSecret);
    cb.setOAuthAccessToken(twitterOAuthAccessToken);
    cb.setOAuthAccessTokenSecret(twitterOAuthAccessTokenSecret);

    // Initialising a new instance of the Twitter class, by passing the configuration builder,
    // which has been set up with the relevant API keys, to the TwitterFactory class. We
    // will then use the twitter instance to update the user's status i.e. send tweets on the user's
    // account (if they are logged in with Twitter)
    twitter = new TwitterFactory(cb.build()).getInstance();
  }

  /*----------------------------------- Images ---------------------------------------------*/

  // Loading in the general background image, which will be used to "wipe" the screen each time the
  // switchScreens method is called. The purpose of this is that individual screens do not need to contain
  // their own backgrounds, and thus reduces the load on memory.
  generalPageBackgroundImage = loadImage("generalPageBackgroundImage.png");

  // Initialising the currentImage to be equal to a plain black image. This is so that if the
  // currentImage get's referred to before the camera has started, it will just contain a plain
  // black screen. Creating this black image by using createImage to make it the full size
  // of the screen, and then setting each pixel in the image to black. This image will be
  // used to return the keyed image of the user from the removeGreenScreen() thread.
  // It is then used on the CameraLiveViewScreen as an image ontop of the Google Street View
  // image, and eventually is added to the compiled image to create the final image the user
  // will save/send to Twitter
  currentImage = createImage(appWidth, appHeight, RGB);
  currentImage.loadPixels();
  for (int i = 0; i < currentImage.pixels.length; i++) {
    // Setting every pixel of the image to be transparent
    currentImage.pixels[i] = color(0, 0, 0, 0);
  }
  currentImage.updatePixels();

  /*---------------------------------- Sizing ----------------------------------------------*/
  // Initialising the icon positioning X and Y variables, which will be used globally to ensure that
  // the icons on each page all line up with one another. These measurements are all based on percentages
  // of the app's display width and height (as defined above)
  iconLeftX = appWidth * 0.1;
  iconRightX = appWidth * 0.9;
  iconCenterX = appWidth * 0.5;
  iconTopY = appHeight * 0.15;
  iconBottomY = appHeight * 0.85;
  iconCenterY = appHeight * 0.5;
  largeIconBottomY = iconBottomY - (largeIconSize / 2);
  screenTitleY = iconTopY;

  // Declaring the icon sizing variables, which will be used globally to ensure that there will be
  // consistency between the sizes of icons throughout the app. These measurements will all be based on
  // percentages of the app's display, and are initialised in the setup function of this sketch
  largeIconSize = appHeight * 0.25;
  smallIconSize = appWidth * 0.08;
  homeIconSize = appHeight * 0.35;

  // Declaring the default text size variables, so that there will be consistency with the sizing
  // of all text within the app
  defaultTextSize = appHeight * 0.05;
  screenTitleTextSize = appHeight * 0.1;

  /*---------------------------------- Screens ---------------------------------------------*/
  // Declaring a new instance of each screen in the application, so that they can be accessed by the
  // draw function to be displayed when needed. The FavouritesScreen and the AboutScreen have been
  // declared as public, as they will need to be accessed from the HomeScreen class, to reset
  // their "loaded" boolean to false, so the scrolling of the screens can be reset before the user
  // views them again. Passing the current instance of the Sketch class (this) to the constructors
  // of each screen, so that they can in turn pass it to their super class (Screen), which will
  // in turn pass it to it's super class (Rectangle). The purpose of this variable is so that
  // we can access the Processing library, along with other global methods and variables of the
  // main sketch class, from all other classes.
  myCameraLiveViewScreen = new CameraLiveViewScreen();
  myLoadingScreen = new LoadingScreen();

  /*---------------------------------- Saving ----------------------------------------------*/
  // Storing a string that tells the app where to store the images externally on the users device.
  // Using the Environment class to determine the path to the external storage directory, as well
  // as the Pictures directory, and then concatenating a name for a new directory ("WishIWasHere")
  // so that images saved from our app will be stored in their own folder.
  directory = "Pictures/";

  // Creating a new File object, using the directory path specified above
  File wishIWasHereDirectory = new File(directory);

  // Checking if this directory already exists
  if (wishIWasHereDirectory.isDirectory() == false) {

    // Since the directory does not already exist, using the File mkdirs() method to create it
    wishIWasHereDirectory.mkdirs();

    println("New directory created - " + directory);
  } else {
    println("Directory already exists");
  }
  
  getRandomLocation();
}

/*-------------------------------------- Draw() ----------------------------------------------*/
public void draw() {
  // Clearing the background of the sketch by setting it to black
  background(0);

  // Calling the switchScreens() function to display the right screen by checking the
  // currentScreen variable and calling the showScreen() method on the appropriate screen.
  // The showScreen() method then calls the super class's (Screen) drawScreen() method,
  // which adds the icons and backgrounds to the screen. As each icon is displayed on each
  // call to it's showIcon() method, if a click occurs, it uses the checkMouseOver() method
  // it has inherited from the ClickableElement class, to see if the mouse was over it when
  // the click took place
  switchScreens();

  // Calling the checkFunctionCalls() method, to check if an icon in the sketch has requested
  // a function to be called. It does this by checking the callFunciton variable, and calling
  // the appropriate function if necessary.
  checkFunctionCalls();
}

/*-------------------------------------- mousePressed() --------------------------------------*/
public void mousePressed() {
  // Setting mouseClicked to true, so that clicks can be dealt with separate to scrolling events
  mouseClicked = true;
}

/*-------------------------------------- keyPressed() ----------------------------------------*/
public void keyPressed() {

  // Allowing the user to take an image by pressing the space bar on the keyboard
  if (currentScreen.equals("CameraLiveViewScreen")) {
    if (keyCode == 32) {
      // SPACEBAR
      mergeImages();
    } else if (keyCode == 37) {
      // LEFT ARROW
      getSpecificRandomLocation(-1);
    } else if (keyCode == 39) {
      // RIGHT ARROW
      getSpecificRandomLocation(1);
    }
  }
}

public void onStop() {
  println("STOP - Sketch Stopped");
}

/*-------------------------------------- Camera -------------------------------------------------*/
// Called when a new frame is available from the camera
public void captureEvent(Capture c) {

  // Checking if the Sketch is currently reading in and keying an image (as we only want to handle
  // one image at a time to avoid memory overload
  if (this.readingImage == false) {

    // Setting the readingImage variable to true so that no more images can be read in until
    // this one has been completed
    this.readingImage = true;

    // Adding a try/catch statement around the following, as loading in the image from the Ketai
    // camera, and then calling the removeGreenScreen thread, tends to cause a crash on it's first
    // attempt (because of the spike in memory, an out of memory error occurs). Once the first
    // frame has been keyed successfully, this no longer seems to occur, as the app will have
    // been allocated more memory.
    try {
      // Reading in the newest frame from the Ketai Camera
      camera.read();

      // Getting the current image from the Ketai Camera and storing it in the currentFrame
      // variable, so that it can be read from within the removeGreenScreen thread. The purpose
      // of using this variable, instead of accessing the image directly from the Ketai Camera
      // in the removeGreenScreen thread, is that accessing the pixel array of the camera seems
      // to produce unexpected results i.e. distortions in the image
      currentFrame = camera.get();

      // Calling the removeGreenScreen thread, to remove the green background from the current
      // frame of Ketai Camera, and pass it back to the sketch by setting currentImage to be
      // equal to it's contents
      thread("removeGreenScreen");
    } 
    catch (OutOfMemoryError e) {

      println("Unable to initiate the removeGreenScreen thread - " + e);

      // Resetting the readingImage variable to false, so that even if this frame was unsuccessful
      // in being keyed, the app can continue to try and read in more frames
      readingImage = false;
    }
  }
}

/*-------------------------------------- SwitchScreens() -------------------------------------*/
public void switchScreens() {
  // Adding the general background image. The purpose of this is that individual screens do not
  // need to contain their own backgrounds, and thus reduces the load on memory.
  image(generalPageBackgroundImage, appWidth / 2, appHeight / 2, appWidth, appHeight);
  
  // Checking if the String that is stored in the currentScreen variable
  // (which gets set in the ClickableElement class when an icon is clicked on) is
  // equal to a series of class Names (i.e. HomeScreen), and if it is, then show that screen.
  // The showScreen() method of the current screen needs to be called repeatedly,
  // as this is where additional functionality (such as checking of icons being
  // clicked on etc) are called.
  if (currentScreen.equals("CameraLiveViewScreen")) {
    // Resetting imageSaved, imageShared and compiledImage, in case they have not already
    // been reset
    imageSaved = false;
    imageShared = false;
    compiledImage = null;
    myCameraLiveViewScreen.showScreen();
  } else if (currentScreen.equals("LoadingScreen")) {
    myLoadingScreen.showScreen();
    // Calling the fadeToScreen method, so that if a click occurs while on this screen, the
    // user will be taken to the "CameraLiveViewScreen"
    fadeToScreen("CameraLiveViewScreen");
  } else {
    println("This screen doesn't exist - " + currentScreen);
  }
}

/*-------------------------------------- CheckFunctionCalls() --------------------------------*/
public void checkFunctionCalls() {

  // Checking if any screen's icons are trying to trigger any functions (by passing their
  // iconLinkTo values to the global callFunction variable). In order for an icon to link
  // to a function, as opposed to a Screen, the link must start with "_"
  if (callFunction.equals("")) {
    // No function needs to be called
  } else if (callFunction.equals("_mergeImages")) {
    mergeImages();
  } else {
    println(callFunction + " - This function does not exist / cannot be triggered by this icon");
  }

  // Resetting the callFunction variable so that functions do not get called repeatedly
  callFunction = "";
}

/*-------------------------------------- KeepImage() -----------------------------------------*/
public void keepImage() {

  // Checking if the saveThisImageOn boolean is true. If a user has autoSaveModeOn turned on,
  // then saveThisImageOn will also be set to true. If a user then wants to turn off saving for
  // an individual image, they can toggle this functionality on/off in SaveShareScreenA, while
  // not affecting their overall autoSaveModeOn setting. Images will only ever save to the device
  // when saveThisImageOn is set to true, regardless of whether autosaveMode is on or off (to
  // allow the user to make individual choices for each image).
  if (saveThisImageOn) {

    println("KEEP IMAGE - This image was saved. autoSaveModeOn = " + autoSaveModeOn + " and saveThisImageOn = " + saveThisImageOn);

    // Saving the image to the photo gallery. This method returns a boolean value, to indicate whether the image was saved
    // successfully or not
    if (saveImageToPhotoGallery()) {
      println("Saved Image!!");
      if (sendToTwitterOn) {
        sendTweet();
      }
    } else {
      println("Failed to save image");
    }
  } else {
    // The user does not want to save the image
    println("KEEP IMAGE - This image was not saved. autoSaveModeOn = " + autoSaveModeOn + " and saveThisImageOn = " + saveThisImageOn);
  }
}
/*-------------------------------------- SaveImageToPhotoGallery() ---------------------------*/
public Boolean saveImageToPhotoGallery() {

  // Creating a local boolean, to store the result of whether or not this attempt to save the image
  // to the user's photo gallery has been successful or not, so that it can be returned from this method
  Boolean successfull = false;

  // Creating temporary strings, to store the current date and time values, with a zero preceeding them
  // if they are less then 10 (for naming consistency)
  String currentDay = day() < 10 ? "0" + day() : "" + day();
  String currentMonth = month() < 10 ? "0" + month() : "" + month();
  String currentHour = hour() < 10 ? "0" + hour() : "" + hour();
  String currentMinute = minute() < 10 ? "0" + minute() : "" + minute();
  String currentSecond = second() < 10 ? "0" + second() : "" + second();

  // Generating a new filename for this image, based on the current time. Storing this path in the saveToPath
  // variable, so that this can be used to save the image, and also used to pass to the share intent, should
  // the user choose to share this image with another app on their device
  saveToPath = directory + "WishIWasHere-" + currentDay + currentMonth + year() + "-" + currentHour + currentMinute + currentSecond + ".jpg";

  // Saving the compiledImage to the path specified above
  if (compiledImage.save(saveToPath)) {

    println("Successfully saved image to - " + saveToPath);

    // Setting the result of this method to be true. The result will then be returned from this method
    successfull = true;

    // Setting the global imageSaved boolean to true, so that the screens that follow can determine
    // whether or not the image has been saved
    imageSaved = true;
  } else {
    println("Failed to save image");

    // Setting the global imageSaved boolean to false, so that the screens that follow can determine
    // whether or not the image has been saved
    imageSaved = false;
  }

  // Returning the result of this method i.e. to specify whether the image has been successfully saved to the
  // user's photo gallery
  return successfull;
}

/*-------------------------------------- FadeToScreen() --------------------------------------*/
public void fadeToScreen(String nextScreen) {
  // This method is used by Screen's that do not inherently have any interactions associated with
  // them, so that the next screen can be triggered the next time a mouse click occurs or will
  // otherwise disappear after 50 frames
  if (frameCount % 100 == 0 || mouseClicked || keyPressed) {
    
    // Setting the global currentScreen method to be equal to the nextScreen (passed into this function)
    currentScreen = nextScreen;
    
    // Resetting the mouse clicked and pressed booleans to false, so that no accidental clicks can
    // occur while the screen is being changed
    mouseClicked = false;
    mousePressed = false;
    
  }
}

/*-------------------------------------- SwitchLearningMode() --------------------------------*/
public void switchLearningMode() {
  // Toggling the value of learningModeOn between true and false i.e. making it equal to the
  // opposite of what it currently is
  learningModeOn = !learningModeOn;

  // Saving the user_preferences.xml file to the app's internal storage, so the user's updated preferences
  // can persist between app sessions
  saveUserPreferencesXML();

  // Checking what the current status of learningModeOn is

  println("LRN - Learning mode is now: " + learningModeOn);
}

/*-------------------------------------- SendTweet() -----------------------------------------*/
public void sendTweet() {

  // Checking if the user want to send this image to Twitter or not. This variable will only ever
  // be set to true if the user has already logged in with their Twitter account. A user can then
  // toggle this functionality on/off for each image they take in the app (i.e. so not all images
  // have to be shared online
  if (twitterLoggedIn && sendToTwitterOn) {



    // Acessing the current value of the TextInput on SaveShareScreenB i.e. the message the user would
    // like to add to their tweet
    //String message = mySaveShareScreenB.messageInput.getInputValue();
    String message = "Having fun at Pen and Pixel 2016";

    // Wrapping the sending of this tweet in a try/catch, to catch any TwitterExceptions that may be thrown
    try {

      // Creating a new status object, which will contain the user's message (as declared above) along with the
      // #WishIWasHere hashtag. The user's input into the TextInput on SaveShareScreenB had a maximum character
      // length applied to it, so that this message will never exceed the Twitter limit of 144 characters (including
      // the hashtag we are concatenating)
      StatusUpdate status = new StatusUpdate(message + " #WishIWasHere" + " #PenAndPixel2016");

      // Loading the image we just saved to the app's internal storage, back in as a File object,
      // as this is the required method to attach an image to a tweet
      File twitterImage = new File(sketchPath(saveToPath));

      // Setting the media of the Twitter status to be equal to the image we just loaded back in
      status.setMedia(twitterImage);

      // Calling the updateStatus() method on the Twitter object, which was generated by the TwitterFactory class
      // when this app was loaded. All of the consumer keys (of our app) and access tokens (of the user's account)
      // were passed to the constructor of this class, so that the Twitter API will accept tweets coming from this
      // app on behalf of the user
      twitter.updateStatus(status);

      // Setting the global imageShared variable to true, so that the screens which appear following this will
      // be able to determine if the user shared the image or not
      this.imageShared = true;
    } 
    catch (TwitterException te) {

      println("Unable t send tweet " + te);

      // Setting the global imageShared variable to false, so that the screens which appear following this will
      // be able to determine if the user shared the image or not
      this.imageShared = true;
    }
  } else {
    println("Twitter - No twitter account logged in");
  }
}

/*-------------------------------------- RemoveGreenScreen() ---------------------------------*/
public void removeGreenScreen() {
  // Can change this variable to "high" to apply the full green screen keying
  // to the image (currently, the standard definition runs much faster and 
  // gives a cleaner result to the final image)
  String keyingQuality = "standard";
  int greenPixels = 0;

  // Creating a local keyedImage variable, within which the image of the user, minus the green
  // screen background, will be created below
  PImage keyedImage;

  try {
    //println("Starting removing Green Screen in " + keyingQuality + " quality at frame " + frameCount);

    // Changing the colour mode to HSB, so that I can work with the hue, satruation and
    // brightness of the pixels. Setting the maximum hue to 360, and the maximum saturation
    // and brightness to 100.
    colorMode(HSB, 360, 100, 100);

    // Defaulting the keyedImage the full currentFrame image, so that only green pixels have to
    // be individually altered and unaffected pixels will already exist in the keyed image
    keyedImage = currentFrame.get();

    // Loading in the pixel arrays of the keyed image
    keyedImage.loadPixels();

    // Looping through each pixel of keyedImage, to check for any green and remove it
    for (int i = 0; i < keyedImage.pixels.length; i++) {

      // Getting the hue, saturation and brightness values of the current pixel
      float pixelHue = hue(currentFrame.pixels[i]);

      // If the hue of this pixel falls anywhere within the range of green in the colour spectrum,
      // then this pixel may be green
      if (pixelHue > 60 && pixelHue < 180) {

        // Since we do not yet know if this is a green pixel, accessing the saturation and brightness
        // of it's color so that we can carry out more specific checks on this pixel
        float pixelSaturation = saturation(currentFrame.pixels[i]);
        float pixelBrightness = brightness(currentFrame.pixels[i]);

        if (keyingQuality.equals("high")) {
          // Creating variables to store the hue of the pixels surrounding the current pixel.
          // Defaulting these the be equal to the current pixels hue, and only changing them if
          // the current pixel is away from the edge of the picture
          float pixelHueToLeft = pixelHue;
          float pixelHueToRight = pixelHue;
          float pixelHueAbove = pixelHue;
          float pixelHueBelow = pixelHue;


          // If the current pixel is not near the edge of the image, changing the values of the variables
          // for the pixels around it to get their hue values
          if (i > currentFrame.width + 1 && i < currentFrame.pixels.length - currentFrame.width - 1) {
            pixelHueToLeft = hue(currentFrame.pixels[i - 1]);
            pixelHueToRight = hue(currentFrame.pixels[i + 1]);
            pixelHueAbove = hue(currentFrame.pixels[i - appWidth]);
            pixelHueBelow = hue(currentFrame.pixels[i + appWidth]);
          }

          // If the saturation and brightness are above 30, then this is a green pixel
          if (pixelSaturation > 30 && pixelBrightness > 30)
          {
            // If the hue of the pixel is between 90 and 100, this is not fully green, but with a tinge 
            if (pixelHue > 90 && pixelHue < 100) {
              // This seems to effect the girl's hair on the left
              // Lowering the hue, saturation and opacity, to reduce the intensity of the colour
              keyedImage.pixels[i] = color(pixelHue * 0.3, pixelSaturation * 0.4, pixelBrightness, 200);
            } else if (pixelHue > 155) {
              // Increasing the hue, and reducing the saturation
              keyedImage.pixels[i] = color(pixelHue * 1.2, pixelSaturation * 0.5, pixelBrightness, 255);
            } else if (pixelHue < 115) {
              // Reducting the hue and saturation. Fixes the girl's hair (in greenScreenImage1) but adds in some of
              // the green screeen in greenScreenImage2)
              keyedImage.pixels[i] = color(pixelHue * 0.4, pixelSaturation * 0.5, pixelBrightness, 255);
            } else {
              // If the pixels around this pixel are in the more intense are of green, then assume this is part of the green screen
              if (pixelHueToLeft > 90 && pixelHueToLeft < 150 && pixelHueToRight > 90 && pixelHueToRight < 150 && pixelHueAbove > 90 && pixelHueAbove < 150 && pixelHueBelow > 90 && pixelHueBelow < 150) {
                // Set this pixel in the keyedImage to be transparent (Removing the main areas of the green)
                keyedImage.pixels[i] = color(0, 0, 0, 0);
              } else if (pixelHue > 130) {
                // This seems to be the edges around the girl
                // Increasing the hue, reducing the saturation and displaying the pixel at half opacity
                keyedImage.pixels[i] = color(pixelHue * 1.1, pixelSaturation * 0.5, pixelBrightness, 150);
              } else {
                // Set this pixel in the keyedImage to be transparent (Removing the main areas of the green)
                keyedImage.pixels[i] = color(0, 0, 0, 0);
              }
            }
          } else {
            // Even though this pixel falls within the green range of the colour spectrum, it's saturation and brightness
            // are low enough that it is unlikely to be a part of the green screen, but may just be an element of the scene
            // that is picking up a glow off the green screen. Lowering the hue and saturation to remove the green tinge 
            // from this pixel.
            keyedImage.pixels[i] = color(pixelHue * 0.6, pixelSaturation * 0.3, pixelBrightness);
          }
        } else {
          // If the saturation and brightness are above 30, then this is a green pixel
          if (pixelSaturation > 30 && pixelBrightness > 20) {

            // Set this pixel in the keyedImage to be transparent (Removing the main areas of the green)
            keyedImage.pixels[i] = color(0, 0, 0, 0);
          } else {

            // Even though this pixel falls within the green range of the colour spectrum, it's saturation and brightness
            // are low enough that it is unlikely to be a part of the green screen, but may just be an element of the scene
            // that is picking up a glow off the green screen. Lowering the hue and saturation to remove the green tinge
            // from this pixel.
            keyedImage.pixels[i] = color(pixelHue * 0.6, pixelSaturation * 0.3, pixelBrightness);
          }
        }

        if (learningModeOn) {
          greenPixels++;
        }
      }
    }

    // Updating the pixel arrays of the keyed image
    keyedImage.updatePixels();

    // Resetting the color mode to RGB. Resetting each of the colour channels to 8bits each i.e. true color (24bit)
    colorMode(RGB, 255, 255, 255);

    // Passing the keyed image back to the main thread by setting the currentImage to be equal to the
    // resulting image of the green screen keying above
    currentImage = keyedImage.get();

    // Resetting the keyedImage and currentFrame to null, as they are no longer needed
    keyedImage = null;
    currentFrame = null;

    // Resetting the readingImage variable to false, so that the next frame can be read in from the device camera
    readingImage = false;

    if ((greenPixels < (appWidth * appHeight * 0.10)) && learningModeOn) {
      // Triggering the Toast pop up (declared in the main activity) to encourage the user to reframe the
      // image as it currently has less that 10% green in it
      println("Not enough green in the image");
      println("Threshold = " + (appWidth * appHeight * 0.10) + "; greenPixels = " + greenPixels);
    } else {
      //println("Plenty of green in the image");
      //println("Threshold = " + (appWidth * appHeight * 0.10) + "; greenPixels = " + greenPixels);
    }


    //println("Finished removing Green Screen at frame " + frameCount);
  } 
  catch (OutOfMemoryError e) {

    println("Green screen keying could not be completed - " + e);

    // Resetting the keyedImage and currentFrame to null, as they are no longer needed
    keyedImage = null;
    currentFrame = null;

    // Resetting the readingImage variable to false, so that even if this frame failed to be processing,
    // the next frame can be read in from the device camera and the thread can attempt the keying again
    this.readingImage = false;
  }
}

/*-------------------------------------- MergeImages() ---------------------------------------*/
public void mergeImages() {
  try {
    // Setting imageMerging to true, so that no new frames will be read in while this process
    // is taking place (as the user has just taken a photo and so does not require any new
    // frames to be read in)
    imageMerging = true;

    // Creating a temporary PImage variable to load in the overlay graphic, which will be used to add
    // our app icon to the merged image.
    PImage overlayImage = loadImage("overlay.png");

    // Creating a new PGraphic, so that the relevant images can be "drawn" onto it, so that they
    // can be compiled into one image (for saving and sharing). Up until now, these images
    // were only displayed on top of one another, so the user could preview the final output.
    // Initialising this graphic to match the width and height of the Google street view image,
    // as this will have been determined (in the loadGoogleImage() method) to fill the device's
    // screen, based on the current orientation of the device.
    PGraphics mergedImage = createGraphics(googleImageWidth, googleImageHeight);

    // GOOGLE STREET VIEW IMAGE
    // Setting the imageMode of the merged image to be centered, so that the image can be "drawn" onto
    // it from a central point. Then adding the currentLocationImage (i.e. the Google Street View Image
    // of the current location) to the mergedImage graphic, with an x and y position, which is centered
    // based on half of the width and height of the googleImageWidth and googleImageHeight variables.
    mergedImage.beginDraw();
    mergedImage.imageMode(CENTER);
    mergedImage.image(currentLocationImage, googleImageWidth / 2, googleImageHeight / 2, googleImageWidth, googleImageHeight);

    // KEYED IMAGE OF USER
    // pushMatrix() - Storing the current state of the matrix, as we will be translating, scaling and rotating it in order to
    // to add the image in the correct position and orientation within the mergedImage PGraphic.
    // By pushing the matrix, we can revert it back to it's original state once this method has been completed
    // (by using the .popMatrix() method).
    // translate() - Translating the matrix of the mergedImage graphic, to be equal to the center of the image, based on half
    // of the width and height of the googleImageWidth and googleImageHeight variables, so that the image will
    // be centered within this new graphic, regardless of it's rotation.
    // scale() - Scaling the currentImage on the X axis, using the cameraScale, which will contain a value of 1 or -1
    // (based on whether the image should be flipped horizontally i.e. when using the front facing camera, the
    // x scale should always be -1 to avoid things being viewed in reverse)
    // image() - adding the currentImage (i.e. the keyed image of the user) to the mergedImage graphic, with an x and
    // y position of 0, as the position of the image within the mergedImage will have been determined by the translate()
    // method.
    // popMatrix() - Restoring the matrix of the mergedImage to it's previous state (which was stored when we called the
    // .pushMatrix() method at the start of this function)
    mergedImage.pushMatrix();
    mergedImage.translate(googleImageWidth / 2, googleImageHeight / 2);
    mergedImage.scale(cameraScale, 1);
    mergedImage.image(currentImage, 0, 0, appWidth, appHeight);
    mergedImage.popMatrix();

    // OVERLAY "WISH I WAS HERE" ICON IMAGE
    // Adding the overlayImage, which contains our app logo, to the mergedImage. This logo will always appear in the lower
    // right hand corner of the final image, in both portrait and landscape mode, so determining it's x and y positions
    // based on the mergedImage width and height, minus a percentage of the device width, to provide a margin around the
    // edge of the ico
    mergedImage.image(overlayImage, mergedImage.width - (appHeight * 0.15), mergedImage.height - (appHeight * 0.1), appHeight * 0.275, appHeight * 0.15);
    mergedImage.endDraw();

    // Setting the compiled image to be equal to the image stored in the PImage graphic created above. This contains
    // the Google Street View image of the background, the keyed image of the user, and the "Wish I Was Here" overlay
    // image, which can then be saved and/or shared. This image will also be displayed on the ImagePreviewScreen and
    // the SaveShareScreenA screens.
    compiledImage = mergedImage.get();

    // Resetting the local mergedImage and overlayImage variables to null as they are no longer needed
    mergedImage = null;
    overlayImage = null;

    keepImage();
  } 
  catch (OutOfMemoryError e) {
    println("Could not save image - " + e);

    // Resetting image merging to false, as this image was not able to be merged
    imageMerging = false;
  }

  // Resetting imageMerging and readingImage to false, so that when the user returns to the CameraLiveViewScreen
  // later on, the camera will immediately being reading in new frames
  imageMerging = false;
  readingImage = false;
}

/*-------------------------------------- GetRandomLocation() ---------------------------------*/
public void getRandomLocation() {

  // Setting the currentScreen to be equal to the SearchingScreen, so that this will be displayed while a
  // random location is found, and a request is made to the loadGoogleImage() method, to request a new Google
  // Street View Image, based on this location. Calling the switchScreens() method, so that this screen will
  // be displayed immediately
  switchScreens();

  println("Getting a random location");

  // Determing a random index value, based on the amount of locations stored in the randomLocations XML file
  int randomIndex = round(random(randomLocations.length - 1));

  // Setting the google image location variables, based on the relevant values from the random location
  // we are accessing, using the random index generated above
  googleImageLatLng = randomLocations[randomIndex].getString("latLng");
  googleImageHeading = Float.parseFloat(randomLocations[randomIndex].getString("heading"));
  googleImagePitch = Float.parseFloat(randomLocations[randomIndex].getString("pitch"));
  currentLocationName = randomLocations[randomIndex].getString("name");

  println("Random location selected: " + currentLocationName);

  // Calling the loadGoogleImage() method, to load in the random location's image, with the relevant
  // properties using the new values assigned above.
  loadGoogleImage();
}

/*-------------------------------------- GetRandomLocation() ---------------------------------*/
public void getSpecificRandomLocation(int direction) {

  // Reloading the randomLocations XML (so that if we add new locations during the event, they will be automatically
  // added here
  randomLocations = loadXML("https://wishiwashere.github.io/random_locations.xml").getChildren("location");
  
  String printMessage = "";
  
  // Determing an index value, based on the amount of locations stored in the randomLocations XML file
  if (direction == 1) {
    currentLocationIndex = currentLocationIndex + direction > randomLocations.length - 1 ? 0 : currentLocationIndex + direction;
    printMessage = "Getting next random location";
  } else if (direction == -1) {
    currentLocationIndex = currentLocationIndex + direction < 0 ? randomLocations.length - 1: currentLocationIndex + direction;
    printMessage = "Getting previous random location";
  }

  // Setting the google image location variables, based on the relevant values from the random location
  // we are accessing, using the random index generated above
  googleImageLatLng = randomLocations[currentLocationIndex].getString("latLng");
  googleImageHeading = Float.parseFloat(randomLocations[currentLocationIndex].getString("heading"));
  googleImagePitch = Float.parseFloat(randomLocations[currentLocationIndex].getString("pitch"));
  currentLocationName = randomLocations[currentLocationIndex].getString("name");

  println(printMessage + " - " + currentLocationName);
  
  // Calling the loadGoogleImage() method, to load in the random location's image, with the relevant
  // properties using the new values assigned above.
  loadGoogleImage();
}

/*-------------------------------------- LoadGoogleImage() -----------------------------------*/
public void loadGoogleImage() {

  // Using ternary operators to determine the width and height of the google image we are about to load in.
  // If the device orientation is equal to 0, then the device is standing upright, and the image will need
  // to be the width of the app, and the height of the app. Conversely, if the device orientation is equal to
  // anything else (which will only ever be -90 or 90 degrees) then the user is trying to take a landscape
  // picture, and so the width of the background image will need to be equal to the height of the device,
  // and the height of the image will be equal to the width of the device, as the background will be rotated
  // to accomodate the user's change in orientation, and will need to change dimensions in order to fill the
  // screen
  googleImageWidth = appWidth;
  googleImageHeight = appHeight;

  // Loading in a new Google Street view image, by making a request to the Google Street View Image API, which
  // includes the location's latitude, longitude, heading (left to right viewpoint), pitch (up and down viewpoint)
  // our browser API key (so that we have permission to access this API) along with the required width and height
  // for the resulting image (as defined above, based on the device's current orientation)
  currentLocationImage = loadImage("https://maps.googleapis.com/maps/api/streetview?location=" + googleImageLatLng + "&pitch=" + googleImagePitch + "&heading=" + googleImageHeading + "&key=" + googleBrowserApiKey + "&size=" + googleImageWidth + "x" + googleImageHeight, "png");

  println("Image successfully loaded");

  // Checking if the user is currently on the camera live view screen, and if not, then sending them there,
  // so they can view themselves in front  of the new background image which was just loaded in
  if (currentScreen.equals("CameraLiveViewScreen") == false) {

    // Sending the user to the CameraLiveViewScreen
    currentScreen = "CameraLiveViewScreen";
  }
}

/*-------------------------------------- LoadUserPreferencesXML() ----------------------------*/
public void loadUserPreferencesXML() {

  // Creating a new File object, which contains the path to where the user's preferences will
  // have been stored locally within the app
  File localUserPreferencesPath = new File(sketchPath("data/user_preferences.xml"));

  // Checking if this path already exists i.e. does the user already have preferences stored within
  // the app, or is this their first time using the app
  if (localUserPreferencesPath.exists()) {
    // Since this path already exists, then loading in the user's previously saved preferences
    // from the app's local files
    userPreferencesXML = loadXML(sketchPath("data/user_preferences.xml"));
  } else {
    // Since the user does not already have preferences stored within the app, loading in the
    // preferences from the default user_preferences.xml file, on our GitHub.io site, so that
    // we can update the user's default favourite locations remotely. This file will only
    // be loaded in the first time the user opens the app so that it can be used to generate the
    // default preferences for this user, and will be the template for their locally stored
    // preferences within the app
    userPreferencesXML = loadXML("https://wishiwashere.github.io/user_preferences.xml");
  }

  // Logging out the current contents of the user preferences XML file (for TESTING purposes)
  println("USER PREFERENCES = " + userPreferencesXML);

  // Setting the global favouriteLocationsData array to store all of the location elements
  // stored in the user preferences file
  favouriteLocationsData = userPreferencesXML.getChildren("location");

  // Setting the settingsData array to store all of the setting elements stored in the user
  // preferences file (such as autoSaveMode and learningMode on/off)
  settingsData = userPreferencesXML.getChildren("setting");

  // Looping through all of the settingsData elements from the user preferences XML file
  for (int i = 0; i < settingsData.length; i++) {

    // Finding the relevant elements which contain the value for the autoSaveMode and
    // learningMode settings, so that their values can be used to initialise (or update)
    // the current settings in the app
    if (settingsData[i].getString("name").equals("autoSaveMode")) {

      // Parsing in the "on" value of this element as a boolean, and updating the status
      // of the autoSaveModeOn global variable
      autoSaveModeOn = Boolean.parseBoolean(settingsData[i].getString("on"));

      // Also updating the status of the saveThisImageOn global variable, so that a user can
      // then toggle this variable on/off to make individual choices about saving or not saving
      // each image, without effecting their autoSaveModeOn setting
      saveThisImageOn = autoSaveModeOn;
    } else if (settingsData[i].getString("name").equals("learningMode")) {

      // Parsing in the "on" value of this element as a boolean, and updating the status
      // of the learningModeOn global variable
      learningModeOn = Boolean.parseBoolean(settingsData[i].getString("on"));
    }
  }
  println("LRN - Loaded user preferences - learningMode = " + learningModeOn);
}

/*-------------------------------------- SaveUserPreferencesXML() ----------------------------*/
public void saveUserPreferencesXML() {

  // Looping through all of the settings data of the app
  for (int i = 0; i < userPreferencesXML.getChildren("setting").length; i++) {

    // Finding the relevant elements which contain the value for the autoSaveMode and learningMode settings,
    // so that it's value can be updated to reflect the current setting in the app. Looping through all of
    // the settings data of the app (from within the userPreferences XML file
    if (userPreferencesXML.getChildren("setting")[i].getString("name").equals("autoSaveMode")) {

      // Storing the current "on" value of this element an attribute on the autoSaveModeOn element
      userPreferencesXML.getChildren("setting")[i].setString("on", autoSaveModeOn.toString());

      println("LRN - Settings updated - autoSaveMode = " + userPreferencesXML.getChildren("setting")[i]);
    } else if (userPreferencesXML.getChildren("setting")[i].getString("name").equals("learningMode")) {

      // Storing the current "on" value of this element an attribute on the learningModeOn element
      userPreferencesXML.getChildren("setting")[i].setString("on", learningModeOn.toString());

      println("LRN - Settings updated - learningMode = " + userPreferencesXML.getChildren("setting")[i]);
    }
  }

  // Saving the current userPreferencesXML variable in the app's local user_preferences.xml file
  // so that the user's settings (and favourite locations) can be persisted between app sessions
  saveXML(userPreferencesXML, "data/user_preferences.xml");

  // Loading the XML data back in, so that the changes that have just been made to the user_preferences.xml
  // file will also be reflected in the relevant variable within the app aswell
  loadUserPreferencesXML();
}