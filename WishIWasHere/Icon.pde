// This class extends from the ClickableElement class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes.
public class Icon extends ClickableElement {

  // Creating private variables to store the icon's link, title, show title and title position properties,
  // so that they can only be accessed within this class (the icon's link and title can be altered using
  // the public get and set methods provided in this class. The iconLinkTo variable specifies which funciton,
  // screen or external link this icon will send the user to. The iconTitle is used to log out to the console
  // which icon was clicked on, and if the showIconTitle variable is set to true, then this title will also
  // appear on the icon. The iconTitle position would then specify where the title should appear on the icon
  // i.e. centered, below the icon image etc.
  private String iconLinkTo;
  private String iconTitle;
  private Boolean showIconTitle;
  private String iconTitlePosition;

  /*-------------------------------------- Constructor() ------------------------------------------------*/

  // Partial Constructor
  // This constructor is used by icons that want to accept the default width and height of a small icon,
  // but do not need to specify their title's alignment values as they will not be displaying it
  // (i.e. icons on the CameraLiveView Screen)
  public Icon(float x, float y, PImage img, String title, Boolean showTitle, String linkTo) {

    // If no width or height specified, defaulting these to the smallIconSize (as defined in the main Sketch class)
    // If no title position specified, then defaulting this to "Middle" i.e. centered on the icon. Then passing these
    // default values, along with the specified parameters, into the full constructor of this class. Also passing
    // the instance of the Sketch class, which was just passed to this constructor, so that this class can also
    // access the Processing library, as well as the global methods and variables of the Sketch class
    this(x, y, smallIconSize, smallIconSize, img, title, showTitle, "Middle", linkTo);
  }

  // Partial Constructor
  // This constructor is used by icons that want to specify all of their properties, but do not need to specify their
  // title's alignment value as they will not be displaying it
  // (i.e. the toggle switches on the Settings screen)
  public Icon(float x, float y, float w, float h, PImage img, String title, Boolean showTitle, String linkTo) {

    // If no title position specified, then defaulting this to "Middle" i.e. centered on the icon. Then passing this
    // default value, along with the specified parameters, into the full constructor of this class. Also passing
    // the instance of the Sketch class, which was just passed to this constructor, so that this class can also
    // access the Processing library, as well as the global methods and variables of the Sketch class
    this(x, y, w, h, img, title, showTitle, "Middle", linkTo);
  }

  // Partial Constructor
  // This constructor is used by icons that want to specify all of their properties, except for the background image parameter
  // (i.e. buttons that only have text on them).
  public Icon(float x, float y, float w, float h, String title, Boolean showTitle, String titlePosition, String linkTo) {

    // If no image specified, then defaulting this to null. Then passing this default value, along with the specified parameters,
    // into the full constructor of this class. Also passing the instance of the Sketch class, which was just passed to this
    // constructor, so that this class can also access the Processing library, as well as the global methods and variables
    // of the Sketch class
    this(x, y, w, h, null, title, showTitle, titlePosition, linkTo);

    // Calling the Rectangle class's setBackgroundColor() method, which this class has inherited through the ClickableElement
    // class, to default all instances of the Icon class, which do not specify a background image, i.e. buttons, to have an
    // opaque white background. This now means that each button, which does not have a background image, will have a white
    // rectangle as their background.
    this.setBackgroundColor(color(255, 255, 255, 255));
  }

  // Full Constructor
  // All of the above constructors both pass their values to this constructor, as well as other icon's in the app that
  // want to pass arguments for all of the specified values
  // (i.e. the icons on the home screen)
  public Icon(float x, float y, float w, float h, PImage img, String title, Boolean showTitle, String titlePosition, String linkTo) {

    // Passing the relevant parameters from the constructor into the constructor of the super class (Rectangle).
    // Also passing the instance of the Sketch class, which was just passed to this constructor, so that the super
    // class can also access the Processing library, as well as the global methods and variables of the Sketch class.
    super(x, y, w, h, img, title);

    // Initialising this class's local sketch variable, with the instance which was passed to the
    // constructor of this class. The purpose of this variable is so that we can access the Processing
    // library, along with other global methods and variables of the main sketch class, from within
    // this class. Every reference to a Processing method/variable, or a public method/variable of
    // the main must be prefixed with this object while within this class.


    // Initialising the iconLinkTo to be equal to the requested link specified in the object's constructor.
    // If this link begins with a letter i.e. "CameraLiveViewScreen" then this will be passed to the global
    // currentScreen variable when the icon is clicked on, so that in the main Sketch we can determine which
    // screen to display. If this link begins with an underscore i.e. "_keepImage" then this will be passed
    // into the global callFunction variable when the icon is clicked on, so that in the main we
    // can determine which function to call. If this link begins with a hyphen i.e. "-returnTo" then setting
    // the currentScreen to be equal to the screen to which this icon should return users to (using the main Sketch's
    // "returnTo" variable" i.e. if the user has arrived at this screen from A, then clicking cancel on this screen
    // should return them to that screen. They may also have come to this screen from the screen B, in which case the
    // cancel button should return them there. The returnTo variable is defined and initialised in the main 
    this.iconLinkTo = linkTo;

    // Initialising the iconTitle to be equal to the requested title. If no title was provided, then an empty string
    // will have been passed in, so we will temporarily store this and figure out later (in the showIcon function)
    // whether or not to display the text (based on the showIconTitle variable below)
    this.iconTitle = title;

    // Initialising the showIconTitle boolean to be equal to the specified value, which will be used later to decide
    // if this page's title will be displayed on the icon or not.
    this.showIconTitle = showTitle;

    // Initialising the titlePosition to be equal to the specified value, which will later be used to position the
    // icon's title (if it is to be displayed, as determined by the showIconTitle variable above) on the icon,
    // below the icon etc.
    this.iconTitlePosition = titlePosition;
  }

  /*-------------------------------------- showIcon() ------------------------------------------------*/

  // Creating a public showIcon function, which can be called anywhere in the code to display the icon,
  // and add any text that has been specified
  public void showIcon() {

    // Calling the show() method (which was inherited from the Rectangle class) so that this icon will be displayed on screen
    this.show();

    // Checking if this icon's title should be displayed on the icon
    if (this.showIconTitle && this.iconTitle.length() > 0)
    {
      // Checking if this icon's title should be displayed centered on it, or below it
      if (this.iconTitlePosition.equals("Middle")) {

        // Calling the super class's (Rectangle) addText method, to add the title to
        // the icon. Passing in the String containing the title for the icon, the current
        // x and y positions of the icon itself, and the font size (which is relative
        // to the icon's current width (using the getWidth() which was also inherited
        // from the Rectangle class)
        this.addText(this.iconTitle, this.getX(), this.getY(), this.getHeight() * 0.6);
      } else if (this.iconTitlePosition.equals("Below")) {

        // Calling the super class's (Rectangle) addText method, to add the title to
        // the icon. Passing in the String containing the title for the icon, the current
        // x and y positions of the icon itself, but adding 60% of the height of the
        // icon to the y position, so the text will appear below it, as well as the font size
        // (which is relative to the icon's current width (using the getWidth() which was
        // also inherited from the Rectangle class)
        this.addText(this.iconTitle, this.getX(), this.getY() + (this.getHeight() * 0.6), this.getWidth() * 0.2);
      }
    }

    // Checking if the mouse was clicked, using a custom variable defined in the main Sketch (to
    // differentiate between mouse clicked and mouse pressed (i.e. clicking or scrolling)
    if (mouseClicked) {

      // Checking if the mouse was over this icon when the click occurred (using the checkMouseOver() method
      // inherited from the ClickableElement class). This method returns a boolean value, to confirm if the
      // mouse was over the icon when the click occurred.
      if (this.checkMouseOver()) {

        // Since this icon has been detected as having been clicked on, resetting the mouseClicked variable
        // from the main Sketch to be equal to false (so that no further clicks will be detected on this
        // one click event)
        mouseClicked = false;

        // Checking if this icon has a link associated with it
        if (this.iconLinkTo.length() > 0)
        {
          // Checking if the iconTitle contains "http" i.e. if it is an external link
          if (this.iconLinkTo.indexOf("http") > -1) {
            // This is an EXTERNAL link
            // Passing the icon's link into the link() method, so that it can be treated as
            // an external link i.e. to a website
            link(this.iconLinkTo);

            // Logging out what site the user will now be taken to
            println("Going to " + this.iconLinkTo);
          } else if (this.iconLinkTo.indexOf("_") == 0) {

            // This is a call to a function within the app. Setting the callFunction variable,
            // from the main Sketch class, to equal to this link. The function will then be
            // called from within the draw() method of the main 
            callFunction = this.iconLinkTo;

            // Logging out what function will now be called
            println("Calling the " + this.iconLinkTo + "() function");
          } else if (this.iconLinkTo.indexOf("-") == 0) {

            // Setting the currentScreen to be equal to the screen to which this icon should
            // return to i.e. if the user has arrived at this screen from screen A, then clicking
            // cancel on this screen should return them to that screen. They may also have come
            // to this screen from the Settings screen, in which case the cancel button should
            // return them there. The returnTo variable is defined and initialised in the main
            // 
            //currentScreen = returnTo;

            // Logging out what screen the user will now be taken back to
            println("Returning to the " + this.iconLinkTo + "screen");
          } else {
            // This is an INTERNAL link
            // Setting the global currentScreen variable to be equal to the link contained within
            // the icon that was clicked on (so it can be used in the main Sketch to determine
            // which screen to display)
            currentScreen = this.iconLinkTo;

            // Logging out what screen the user will now be taken to
            println("Going to the " + this.iconLinkTo);
          }
        }
      }
    }
  }

  /*-------------------------------------- get() and set() ------------------------------------------------*/

  // Public set method to update the value of the iconLinkTo property of the icon
  public void setIconLinkTo(String link) {
    iconLinkTo = link;
  }

  // Public set method to update the value of the iconTitle property of the icon
  public void setIconTitle(String title) {
    iconTitle = title;
  }
}