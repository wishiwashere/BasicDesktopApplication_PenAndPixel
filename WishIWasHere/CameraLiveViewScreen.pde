// This class extends from the Screen class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes. This screen is displayed when a user
// is viewing themselves in a location, and offers them to option to take a picture, save the location
// as a favourite, as well as functionalities specific to this screen (such as switching between cameras)
public class CameraLiveViewScreen extends Screen {

  /*-------------------------------------- Constructor() ------------------------------------------------*/
  // Creating a public constructor for the class so that an instance of it can be declared in the main sketch
  public CameraLiveViewScreen() {
    super();
  }

  // Creating a public showScreen method, which is called by the draw() funciton whenever this
  // screen needs to be displayed
  public void showScreen() {

    // Checking if the mouse is pressed (i.e. the user wants to scroll around the background of this image)
    if (mouseMoved) {

      // Calculating the amount scrolled on the x axis, based on the distance between the previous x position,
      // and the current x position, as well as the amount scrolled on the y axis based on the distance between
      // the previous y position and the current y position.
      float amountScrolledX = dist(0, pmouseX, 0, mouseX);
      float amountScrolledY = dist(0, pmouseY, 0, mouseY);

      // GENERAL NOTES ON HOW GOOGLE STREET VIEW IMAGE IS BEING PANNED
      // Heading refers to the left/right view of the image, between 0 and 360 degrees. Decrementing the googleImageHeading
      // by the amount scrolled on the relevant axis. Using a ternary operator to check that this will not
      // result in a value less than 0 or greater than 359 (the min/max values allowed for the heading of a Google
      // Street View image). If it does, then resetting the heading to the other end of the values, so the
      // user can continue turn around in that direction, otherwise allowing it to equal to the current heading
      // value minus/plus the amount scrolled on the relevant axis.
      // Pitch refers to the up/down view of the image, between -90 and 90 degrees. Incrementing the googleImagePitch
      // by the amount scrolled on the relevant axis. Using a ternary operator to check that this will not result in a
      // value less than -90 or greater than 90 (the min/max values allowed for the pitch). If it does, then stopping
      // the pitch at the min or max i.e. so the user cannot exceed these values, otherwise allowing it to equal to the
      // current pitch value minus/plus the amount scrolled on the relevant axis.
      // As the orientation of the device can change, determining which value to effect based on which axis below

      // Checking which direction the user has scrolled on the X axis based on the previous x position of the
      // mouse, in comparison with the current x position of the mouse.
      if (pmouseX > mouseX) {
        // The previous mouse X was further along than the current mouseX

        // Device is standing upright - so the user wanted to scroll left
        googleImageHeading = (googleImageHeading - amountScrolledX) < 0 ? 359 : googleImageHeading - amountScrolledX;

        // Logging out the current heading of the Google image (for TESTING purposes)
        println("Scrolled left. Heading is now " + googleImageHeading);
      } else {
        // The previous mouse X is less than the current mouse X

        // Device is standing upright - so the user wanted to scroll right
        googleImageHeading = (googleImageHeading + amountScrolledX) > 359 ? 0 : googleImageHeading + amountScrolledX;

        // Logging out the current heading of the Google image (for TESTING purposes)
        println("Scrolled right. Heading is now " + googleImageHeading);
      }


      // Checking which direction the user has scrolled on the Y axis based on the previous y position of the
      // mouse, in comparison with the current y position of the mouse.
      if (pmouseY > mouseY) {
        // The previous mouse Y was further along than the current mouse Y

        // Device is standing upright - so the user wanted to scroll down
        googleImagePitch = (googleImagePitch + amountScrolledY) > 90 ? 90 : googleImagePitch + amountScrolledY;

        // Logging out the current pitch of the Google image (for TESTING purposes)
        println("Scrolled down. Pitch is now " + googleImagePitch);
      } else {
        // The previous mouse Y is less than the current mouse Y

        // Device is standing upright - so the user wanted to scroll up
        googleImagePitch = (googleImagePitch - amountScrolledY) < -90 ? -90 : googleImagePitch - amountScrolledY;

        // Logging out the current pitch of the Google image (for TESTING purposes)
        println("Scrolled up. Pitch is now " + googleImagePitch);
      }

      // Calling the loadGoogleImage method from the main Sketch class, so that a new google image will be
      // loaded in, with the new heading and pitch values specified above.
      loadGoogleImage();

      mouseMoved = false;
    }

    // Adding the currentLocationImage to the CameraLiveViewScreen, so that the user can feel like they are taking a picture
    // in that location. Passing in the currentLocationImage, as sourced from the Google Street View Image API, using the
    // location specified by the user. Setting the rotation of this image to be equal to the orientationRotation of the
    // app, so that the image will be rotated based on which way the user is holding the device, so users can take pictures
    // in both landscape and portrait.
    this.addImage(currentLocationImage, googleImageWidth/2, googleImageHeight/2, googleImageWidth, googleImageHeight);

    // Adding hent keyed image tothe CameraLiveViewScreen, so that the user can see themselves in the location added
    // above. Setting the scaleX of this image to be equal to the cameraScale, which accounts for and corrects the way in which
    // front facing cameras read in images in reverse (so they no longer appear reversed). Setting the rotation of this image
    // to be equal to the cameraRotation, which accounts for and corrects the way in which ketaiCamera reads in images, so the
    // image appears in the correct orientation.
    this.addImage(currentImage, appWidth, appHeight, cameraScale);

    // Calling the super class's (Screen) drawScreen() method, to display each of this screen's icons.
    // This method will then in turn call it's super class's (Rectangle) method, to generate the screen. Calling this
    // method after the Google street view image, and the keyed image have been added to the sketch, so that the icons
    // of this screen will appear on top of these images.
    this.drawScreen();
  }
}