// The Rectangle class is the super class which is the super class for all classes in this app (excluding
// the Sketch class, from which it extends from, nor the MainActivity or TwitterLoginActivity classes, which
// handle the activity's of the app, and are not written in Processing). The purpose of this is that all
// classes can inherit the properties and methods of this class.
public class Rectangle {

  // Creating private variables to store the properties of each instance of the Rectangle class, and the
  // class which extend from it. These variables are private so that they can only be accessed within
  // this class i.e. must be set through the constructor of the object, or retrieved/updated using the
  // relevant get/set methods of this class.

  // Creating a series of float variables that will store the x and y positions, as well as the width and
  // height, of each rectangle. These values will be setup in the constructors of this class, with values
  // passed from the relevant subclasses.
  private float rectX;
  private float rectY;
  private float rectWidth;
  private float rectHeight;

  // Creating a variable to store the background color of each rectangle, if they have one. Defaulting this
  // to 0 as it is not possible to set an integer to null. In the show() method of this class,
  // this color will be as the fill for the rectangle's background, if it has been changed to another value
  // i.e. if a subclass using the setBackgroundColor() method to change this value from the default. Generally,
  // only icons that don't have background images, i.e. buttons, or text input areas, ever set a value for this
  // color.
  private int rectCol = 0;

  // Defaulting the rotation of every instance of the Rectangle class to 0. Subclasses can use the setRotation()
  // method to change this value if needed. Storing the rotation value in radians, as this is the expected value
  // when classing the Processing rotate() method, so each time a user passes in a new value for this variable,
  // using the Processing method radians() to explicitly cast the integer value they pass in (which is in degrees)
  // to a radian value, before it is stored in the variable.
  private float rectRotation = 0;


  // Creating a PImage variable, to store the background image of each rectangle. Not all rectangles will have
  // background images, so defaulting this to null so that it can be ignored if they don't. The image will
  // either be set within the constructors of this class (with images passed by subclasses) or by using this
  // class's setImage() method.
  private PImage rectImage = null;

  /*-------------------------------------- Constructor() ---------------------------------------*/
  // This partial-constructor is used by Screen classes, that want to accept all the defaults i.e.
  // to scale to the full size of the device screen they are running on.
  protected Rectangle() {
    // If no x, y, or rotation are passed in, defaulting these to half of the sketch's
    // width and height (i.e. so that the rectangle will appear centered). If no width
    // and height are passed in, defaulting these to the current width and height of
    // the  Passing these default values to the main constructor of this class
    this(appWidth / 2, appHeight / 2, appWidth, appHeight, null);
  }

  // This partial-constructor is used by Screen classes, that want to accept all the defaults i.e.
  // to scale to the full size of the device screen they are running on, as well as setting a
  // background image
  protected Rectangle(PImage img) {
    // If no x, y passed in, defaulting these to half of the sketch's width and height
    // (i.e. so that the rectangle will appear centered). If no width and height are
    // passed in, defaulting these to the current width and height of the  Passing
    // these default values, along with the image that was passed in, to the main constructor
    // of this class
    this(appWidth / 2, appHeight / 2, appWidth, appHeight, img);
  }

  // This partial-constructor is used by classes, that want to specify an x, y, width and height,
  // but not a background image (for example, the ClickableElement class, when it is the super class for
  // TextInput classes)
  protected Rectangle(float x, float y, float w, float h) {
    this(x, y, w, h, null);
  }

  // This is the main constructor of this class, to which all other constructors pass their values to be
  // stored as the instance's properties, as well as by subclasses which want to specify all the properties
  // (for example, the ClickableElement class, when it is the super class for Icon classes)
  protected Rectangle(float x, float y, float w, float h, PImage img) {

    // Storing the values that are passed into the constructor in the private variables of this class,
    // so that they can be accessed by other functions within this class, but not from anywhere outside
    // of this class. Casting each of the float values passed in as floats, as the float datatype is
    // not recognised by the Processing methods in which these values will be used.
    this.rectX = (float)(x);
    this.rectY = (float)(y);
    this.rectWidth = (float)(w);
    this.rectHeight = (float)(h);
    this.rectImage = img;
  }

  /*-------------------------------------- show() ----------------------------------------------*/
  // Creating a method to redraw the object or "show" it on the screen. This method is protected, so that only
  // descendants of this class can access it.
  protected void show() {

    // Storing the current state of the matrix, as we will be translating, scaling and rotating it in order to
    // to add the rectangle in the correct position and orientation. By pushing the matrix, we can revert it back
    // to it's original state once this method has been completed (by using the .popMatrix() method).
    pushMatrix();

    // Translating the position of the matrix be equal to the x and y positions passed into this method. Casting these values
    // to floats (as this is the datatype expected by the Processing translate method). The values coming in to this method
    // are being read in as floats, so by casting them back to floats, we can still implement a Processing method using them.
    translate(this.rectX, this.rectY);

    // Checking if this rectangle has a color which is not equal to the default value we specified previously i.e.
    // does this rectangle require a background color (which will be added by drawing a rectangle which uses this
    // color as it's fill). Not all subclasses will require a background color, it is primarily TextInputs and
    // icons which do not have a background image i.e. buttons.
    if (this.rectCol != 0) {

      // Setting the fill colour of the rectangle to the value specified
      fill(this.rectCol);

      // Adding a stroke to the rectangle, whose weight is relative to the current width of the device. Casting this
      // back to a float, as the result will be a float, and float is not a recognised datatype in Processing methods
      stroke((float) (appWidth * 0.01));

      // Setting the drawing mode of the rectangle to be centered. This way, if a rotation has been applied to the
      // rectangle, it will pivot around it's center point
      rectMode(CENTER);

      // Drawing the rectangle at 0, 0. The actual position on the screen will depend on the matrix's translation,
      // as this will control where the object is drawn
      rect(0, 0, this.rectWidth, this.rectHeight);
    }

    // Checking if this rectangle has a background image specified
    if (this.rectImage != null) {

      // Calling the addImage() method of the this class, to add the image to the screen, passing in the image, along
      // with the width and height of the instance, so that the image will appear the full size of the rectangle in which
      // it exists. Drawing the image at 0, 0. The actual position on the screen will depend on the matrix's translation,
      // as this will control where the image is drawn
      this.addImage(this.rectImage, 0, 0, this.rectWidth, this.rectHeight);
    }

    // Restoring the matrix to it's previous state (which was stored when we called the .pushMatrix() method at the start
    // of this function)
    popMatrix();
  }

  /*-------------------------------------- addText() -------------------------------------------*/
  // Partial addText() method used by text that requires a specific x and y, but will accept the defaults for the other
  // properties
  protected void addText(String text, float textX, float textY) {
    // If no alignment specified, defaulting it to center on the x-axis. If no text size specified, defaulting it to the
    // defaultTextSize variable (as defined in the main sketch). Passing these default values, along with the specified text,
    // x and y to the main addText() method
    this.addText(text, "CENTER", textX, textY, defaultTextSize);
  }

  // Partial addText() method used by text that requires a specific x, y, and text alignment, but will accept the defaults
  // for the other properties
  protected void addText(String text, String align, float textX, float textY) {
    // If no text size specified, defaulting it to the defaultTextSize variable (as defined in the main sketch). Passing
    // this default value, along with the specified text, x, y and text alignment to the main addText() method
    this.addText(text, align, textX, textY, defaultTextSize);
  }

  // Partial addText() method used by text that requires a specific x, y and text size, but will accept the defaults for the
  // other properties
  protected void addText(String text, float textX, float textY, float textSize) {
    // If no alignment specified, defaulting it to center on the x-axis. Passing this default value, along with the specified
    // text, x, y and text size to the main addText() method
    this.addText(text, "CENTER", textX, textY, textSize);
  }

  // Full addText() method, which takes in the values specified (some of which may have been defaulted by the partial addText()
  // methods above)
  protected void addText(String text, String align, float textX, float textY, float textSize) {

    // Storing the current state of the matrix, as we will be translating, scaling and rotating it in order to
    // to add the rectangle in the correct position and orientation. By pushing the matrix, we can revert it back
    // to it's original state once this method has been completed (by using the .popMatrix() method).
    pushMatrix();

    // Translating the position of the matrix be equal to the x and y positions passed into this method. Casting these values
    // to floats (as this is the datatype expected by the Processing translate method). The values coming in to this method
    // are being read in as floats, so by casting them back to floats, we can still implement a Processing method using them.
    translate((float)(textX), (float)(textY));

    // Determining the required text alignment for this text, based on the alignment value passed in
    if (align.equals("LEFT")) {
      // Setting the text align to Left on the x axis, and Center on the y so that
      // the text will be drawn from the center point of it's position on the left of
      // the Rectangle
      textAlign(LEFT, CENTER);
    } else if (align.equals("LEFT-TOP")) {
      // Setting the text align to center (on both the x and the y) so that
      // the text will be drawn from the center point of it's position on
      // the Rectangle
      textAlign(LEFT, TOP);
    } else {
      // Setting the text align to center (on both the x and the y) so that
      // the text will be drawn from the center point of it's position on
      // the Rectangle
      textAlign(CENTER, CENTER);
    }

    // Setting the text size to be responsive to the height of the app. Casting this to a float value, as the float
    // datatype is not recognised by the Processing textSize() method.
    textSize((float) (textSize));

    // Setting the fill color for the text to black
    fill(0);

    // Adding the text to the screen, setting the x and y positions to 0, as the actual position on the screen will
    // depend on the matrix's translation, as this will control where the text is drawn
    text(trim(text), 0, 0);

    /// Restoring the matrix to it's previous state (which was stored when we called the .pushMatrix() method at the start
    // of this function)
    popMatrix();
  }

  /*-------------------------------------- addTextBox() ----------------------------------------*/
  // Declaring a protected method, which can only be accessed by descendants of this class, to add a text box to the screen
  protected void addTextBox(String displayText, float x1, float y1, float x2, float y2, int alignHorz, int alignVert) {

    // Storing the current state of the matrix, as we will be translating, scaling and rotating it in order to
    // to add the text box in the correct position and orientation. By pushing the matrix, we can revert it back
    // to it's original state once this method has been completed (by using the .popMatrix() method).
    pushMatrix();

    // Translating the position of the matrix be equal to 0, 0, so as to ensure the matrix is back at it's
    // point of origin
    translate(0, 0);

    // Setting the rectMode (rectangle drawing mode) of the sketch to be determined using Corners, so that the
    // text box can be drawn by specifying the top left corner co-ordinates, and the bottom right corner co-ordinates
    // (as specified in the Processing API when adding a text box)
    rectMode(CORNERS);

    // Setting the fill to black, so that the text will appear black
    fill(0);

    // Setting the text alignment of this text box to be equal to the values passed in for the horizontal x axis,
    // and the vertical y axis, to determine where the text will be displayed within the text box
    textAlign(alignHorz, alignVert);

    // Setting the text size of this text box to be equal to the defaultTextSize, as defined in the main Sketch class.
    // This is a relative value, and will depend on the size of the device that the app is running on.
    textSize(defaultTextSize);

    // Adding the text box to the screen using the Processing text() method, passing in the positioning and dimensions
    // of the text box that will be required to display text within this text input. x1 and y1 will determine
    // where the top left corner of the text box will be positioned, while x2 and y2 will determine where the
    // bottom left corner of the text box will be positioned. Any text added to this text box will be
    // displayed within this text box. Any text which exceeds the bounds of this box will not be displayed.
    text(displayText, (float)(x1), (float)(y1), (float)(x2), (float)(y2));

    // Restoring the matrix to it's previous state (which was stored when we called the .pushMatrix() method at the start
    // of this function)
    popMatrix();
  }

  /*-------------------------------------- addImage() ------------------------------------------*/
  // Partial addImage() method, which is used by images that require a specific rotation, but will accept
  // the defaults for every other property. This is mainly used by the CameraLiveViewScreen to add the
  // current Google street view image to the rotating it based upon the device's orientation.
  protected void addImage(PImage img, float imgWidth, float imgHeight) {
    // If no image width or height passed in, defaulting the width and height to be equal to that of
    // the image (i.e. it's default resolution). Passing these default values, along with the image
    // and rotation, to the full addImage() method
    this.addImage(img, appWidth/2, appHeight/2, imgWidth, imgHeight, 1);
  }

  // Partial addImage() method which is used by images that require a specific scaleX and rotation,
  // but will accept the defaults for every other property. This is mainly used by the CameraLiveViewScreen
  // to add the current keyed image to the rotating it based upon the ketaiCamera's orientation
  // (which is used to resolve the issue with live camera view images being read in in the wrong orientation,
  // by the ketaiCamera).
  protected void addImage(PImage img, float imgWidth, float imgHeight, int scaleX) {
    // If no x, y, defaulting these to be centered in the app. Passing these default values to the full
    // addImage() method, along with the image, scaleX and rotation values, to the full addImage() method
    this.addImage(img, appWidth/2, appHeight/2, imgWidth, imgHeight, scaleX);
  }

  // Partial addImage() method is used by images that require a specific x and y, but will accept the defaults
  // for every other property.
  protected void addImage(PImage img, int imgX, int imgY) {
    // If no image width or height passed in, defaulting the width and height to be equal to that of the image
    // (i.e. it's default resolution). If no rotation passed in, defaulting this to be the current rotation of the
    // class in which this image exists. Casting this rotation value to an int, as this is the datatype expected
    // by the addImage() method. Passing these default values, along with the image, x and y to the full addImage()
    // method
    this.addImage(img, imgX, imgY, img.width, img.height, 1);
  }

  // Partial addImage() method which is used by images that require a specific width and height, but will accept
  // the defaults for every other property
  protected void addImage(PImage img, float imgX, float imgY, float imgWidth, float imgHeight) {
    // If no rotation passed in, defaulting this to be the current rotation of the class in which this image exists.
    // Casting this rotation value to an int, as this is the datatype expected by the addImage() method. Passing
    // these default values, along with the image, x, y, width and height, to the full addImage() method.
    this.addImage(img, imgX, imgY, imgWidth, imgHeight, 1);
  }

  // Full addImage() method which is used by images that require specific values for each of the parameters, as well as
  // by image which have had some of these values defaulted by the partial addImage() methods above.
  protected void addImage(PImage img, float imgX, float imgY, float imgWidth, float imgHeight, int scaleX) {

    // Storing the current state of the matrix, as we will be translating, scaling and rotating it in order to
    // to add the image in the correct position and orientation. By pushing the matrix, we can revert it back to
    // it's original state once this method has been completed (by using the .popMatrix() method).
    pushMatrix();

    // Translating the position of the matrix be equal to the x and y positions passed into this method. Casting these values
    // to floats (as this is the datatype expected by the Processing translate method). The values coming in to this method
    // are being read in as floats, so by casting them back to floats, we can still implement a Processing method using them.
    translate((float) (imgX), (float) (imgY));

    // Flipping the image horizontally (if it has a scaleX value specified) i.e. using this for the images coming in from the
    // ketaiCamera, so that it better represents the camera it is using (on front facing cameras, the image will be flipped
    // so that things don't appear in reverse.
    scale(scaleX, 1);

    // Setting the imageMode to center so that the image will be drawn from the center point of it's position on the page. This
    // is so images that have been rotated around their center point.
    imageMode(CENTER);

    // Adding the image to the screen, setting the x and y positions to 0, as the actual position on the screen will depend
    // on the matrix's translation. Setting the width and height of the image to be equal to the values passed into the function
    //image(img, 0, 0, (float)(imgWidth), (float)(imgHeight));

    // Restoring the matrix to it's previous state (which was stored when we called the .pushMatrix() method at the start
    // of this function)
    popMatrix();
  }

  /*-------------------------------------- get() and set() -------------------------------------*/
  // Get method that returns the instance's x position
  protected float getX() {
    return rectX;
  }

  // Get method that returns the instance's y position
  protected float getY() {
    return rectY;
  }

  // Set method that alters the instance's y position
  protected void setY(float y) {
    rectY = y;
  }

  // Get method that returns the instance's width
  public float getWidth() {
    return this.rectWidth;
  }

  // Get method that returns the instance's height
  protected float getHeight() {
    return this.rectHeight;
  }

  // Set method that updates the current background image of this instance
  protected void setImage(PImage img) {
    this.rectImage = img;
  }

  // Get method that returns this instance's current rotation
  protected float getRotation() {
    return this.rectRotation;
  }

  // Set method that updates the rotation of this instance
  protected void setRotation(int r) {
    rectRotation = radians(r);
  }

  // Set method that updates the background color of this instance
  public void setBackgroundColor(int col) {
    this.rectCol = col;
  }
}