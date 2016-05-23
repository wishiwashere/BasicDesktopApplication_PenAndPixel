// This class extends from the Screen class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes. This screen is displayed when the user
// comes back from logging in to Twitter, or chooses not to log in to Twitter. It acts as a welcome
// screen for the app.
public class LoadingScreen extends Screen {

  // Creating a private variable to store the image which will be displayed as part of this screen
  private PImage loadingScreenImage;

  // Creating a public constructor for the class so that an instance of it can be declared in the main sketch
  public LoadingScreen() {

    super();

    // Initialising this class's private loadingScreenImage variable by loading the image in from the assets
    // folder, so that it can be displayd when this screen is called.
    loadingScreenImage = loadImage("loadingScreenImage.png");
  }

  // Creating a public showScreen method, which is called by the draw() funciton whenever this
  // screen needs to be displayed
  public void showScreen() {
    
    // Calling the super class's (Screen) drawScreen() method, to display each of this screen's icons.
    // This method will then in turn call it's super class's (Rectangle) method, to generate the screen.
    this.drawScreen();

    // Setting the image mode to center, so the image will appear centered on screen
    imageMode(CENTER);

    // Adding this screen's private loadingScreenImage, so it will appear as part of this screen. Calculating
    // the x, y, width and height based on the current width and height of the device this app is running on.
    image(this.loadingScreenImage, appWidth/2, appHeight/2, appWidth, appHeight);
  }
}