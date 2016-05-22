// This class extends from the Rectangle class, and so inherits the methods and variables this class.
// This class acts as a super class for all clickable elements in the app, such as TextInput and Icon
// classes, so they will all inherit the methods and variables from this class.
public class ClickableElement extends Rectangle {

  // Creating a private variable to store the title of the element. This title will only be used for
  // logging out which element was clicked on
  private String elementTitle = "";

  /*-------------------------------------- Constructor() ------------------------------------------------*/
  // Full Constructor
  // This constructor is used by the Icon class
  public ClickableElement(float x, float y, float w, float h, PImage img, String title) {

    // Calling this class's super class (Rectangle) to create an element with the specified x, y
    // width, height and background image.
    super(x, y, w, h, img);
  }

  // Full Constructor
  // This constructor is used by the TextInput class, as well as the FavouriteTab class
  public ClickableElement(float x, float y, float w, float h, String title) {

    // Calling this class's super class (Rectangle) to create an element with the specified x, y
    // width and height.
    super(x, y, w, h);

    // Setting the title of this element to be equal to the title passed in in the constructor. This
    // title will only be used for logging out which element was clicked on
    this.elementTitle = title;
  }

  /*-------------------------------------- checkMouseOver() ------------------------------------------------*/

  // Creating a protected checkMouseOver() method, which can only be called from descendants of this class.
  // The purpose of this method is that Icons, TextInputs or any other clickable elements in the app, do
  // not need to have the code to check if the mouse was over them when the click occurred, they can just
  // inherit this function and call it when needed. This method returns a boolean value, to indicate whether
  // or not the mouse was over this element when the click occurred.
  protected Boolean checkMouseOver() {

    // Creating a local variable to store the value that will be returned by this method. Defaulting this
    // to false, so that we assume the element was not clicked on, unless proven otherwise in this
    // method.
    Boolean clickedOn = false;

    // Checking if the mouseClicked variable from the main Sketch is currently true. This is a custom variable,
    // as the default mousePressed variable is being used to detect scrolling events, so could not be used here.
    if (mouseClicked) {

      // Checking if the mouse is over this icon (called by the Icon class if a mouse event has occurred
      // while this icon's screen is being displayed). Since the icons are drawn from the center, a bit
      // of additional calculations are required to find out if the mouse was over them (i.e. to see if
      // the mouseX was over this icon, we first have to take half the width from the x from the x position,
      // to get the furthest left point, and then add half of the width to the x position of the icon, to get
      // it's furthest right point. The process is similar for determining the mouseY)
      if ((mouseX > (this.getX() - (this.getWidth() / 2))) &&
        (mouseX < (this.getX() + (this.getWidth() / 2))) &&
        (mouseY > (this.getY() - (this.getHeight() / 2))) &&
        (mouseY < (this.getY() + (this.getHeight() / 2)))) {

        // Logging out the name of the element that was clicked on
        println(this.elementTitle + " was clicked");

        // Setting mouseClicked back to false, so that if the user still has their
        // mouse down after the screen changes, this will not be considered
        // a new click (as otherwise they could inadvertently click on another button)
        mouseClicked = false;

        // Changing the value which will be returned from this function to true, so that
        // the caller of this function will know that this was the element which was clicked on
        clickedOn = true;
      }
    }

    // Returning the result from this function, which will be a boolean value of true or false, so that the caller
    // of this function will know whether this element was clicked on or not
    return clickedOn;
  }
}