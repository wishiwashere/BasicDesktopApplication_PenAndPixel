// This class extends from the ClickableElement class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes
public class TextInput extends ClickableElement {

  // Creating private variables to store the TextInput's title, value and text alignment properties, so
  // that they can only be accessed within this class (the input's can be altered using the public get and set
  // methods provided in this class. The inputTitle is used to log out to the console which input was clicked on,
  // The inputTextAlign determines the text alignment for the text within this text input.
  private String inputTitle = "";
  private String inputValue = "";
  private String inputTextAlign = "";
  private int textVertAlign;

  // Creating private variables, which will determine the positioning and dimensions of the text box that will
  // be required to display text within this text input. textX1 and textY1 will determine where the top left corner
  // of the text box will be positioned, while textX2 and textY2 will determine where the bottom left corner of
  // the text box will be positioned. Any text added to the inputValue of this input, will be displayed within this
  // text box (using the addTextBox() method of this class). Any text which exceeds the bounds of this box will not be
  // displayed.
  private float textX1;
  private float textY1;
  private float textX2;
  private float textY2;

  // Creating a private variable to store the maximum amount of character allowed in this TextInput. Defaulting this
  // to 400. This value can be adjusted using the get and set methods provided in this class. For example, the TextInput
  // for adding a message to a tweet has a lower limit, to abide by twitter's restrictions on tweet lengths.
  private int maxTextLength = 400;

  /*-------------------------------------- Constructor() ------------------------------------------------*/

  // Partial Constructor
  // This constructor is used by text inputs that require a specific x, y, width, height and title,
  // but will accept left aligned text as default
  public TextInput(float x, float y, float w, float h, String title) {

    // Since no text align value has been passed in, defaulting this to left aligned. Passing this, along
    // with the specified x, y, width, height and title into the full constructor of this class. Also passing
    // the instance of the Sketch class, which was just passed to this constructor, so that this class
    // can also access the Processing library, as well as the global methods and variables of the Sketch class.
    this(x, y, w, h, title, "LEFT");
  }

  // Full Constructor
  // The above constructor passes it's values to this constructor, as well as other TextInput's in the app that
  // want to pass arguments for all of the specified values.
  public TextInput(float x, float y, float w, float h, String title, String align) {

    // Passing the relevant parameters from the constructor into the constructor of the super class (ClickableElement).
    // Also passing the instance of the Sketch class, which was just passed to this constructor, so that the super
    // class can also access the Processing library, as well as the global methods and variables of the Sketch class.
    super(x, y, w, h, title);

    // Initialising this class's local sketch variable, with the instance which was passed to the
    // constructor of this class. The purpose of this variable is so that we can access the Processing
    // library, along with other global methods and variables of the main sketch class, from within
    // this class. Every reference to a Processing method/variable, or a public method/variable of
    // the main must be prefixed with this object while within this class.


    // Calling the Rectangle class's setBackgroundColor() method, which this class had inherited through the
    // ClickableElement class, to default all instances of the TextInput class to have an opaque white background.
    // This now means that each TextInput class will have a white rectangle as their background.
    this.setBackgroundColor(color(255, 255, 255, 255));

    // Initialising the inputTitle to be equal to the requested title. This title will only be used to log out the
    // which TextInput was clicked on, if a click occurs
    this.inputTitle = title;

    // Initialising the text alignment of this TextInput to be equal to the value passed in. This will determine
    // the vertical and horizontal alignment of text within this TextInput text box.
    this.inputTextAlign = align;

    // Initialising the variable which will determine the positioning and dimensions of the text box that will
    // be required to display text within this text input. textX1 and textY1 will determine where the top left corner
    // of the text box will be positioned, while textX2 and textY2 will determine where the bottom left corner of
    // the text box will be positioned. Any text added to the inputValue of this input, will be displayed within this
    // text box (using the addTextBox() method of this class). Any text which exceeds the bounds of this box will not be
    // displayed. Since the TextInput (along with all other descendants of the Rectangle class) will be drawn from it's
    // center point, determining the positioning values for these co-ordinates by either adding or taking away half of
    // the width and height that were passed into this constructor. Using decimal multiplication to achieve this, so as
    // to make the text box just short of the full dimensions of the TextInput, so that text does not appear right up
    // to the edge of the surrounding rectangle i.e. textX1 will be positioned 2% of the width further in than the TextInput's
    // top left corner (almost like padding in HTML)
    this.textX1 = (float)(x - (w * 0.48));
    this.textY1 = (float)(y - (h * 0.45));
    this.textX2 = (float)(x + (w * 0.48));
    this.textY2 = (float)(y + (h * 0.45));

    // Determining the vertical alignment of text text in this text box, based on the value passed in
    if (this.inputTextAlign.equals("LEFT")) {
      // If the horizontal alignment specified was just left aligned, then setting the vertical
      // alignment to CENTER (a constant containing the integer value for aligning text - as defined
      // in the Processing libarary)
      this.textVertAlign = CENTER;
    } else if (inputTextAlign.equals("LEFT-TOP")) {
      // If the horizontal alignment specified was left-top aligned, then setting the vertical
      // alignment to TOP (a constant containing the integer value for aligning text - as defined
      // in the Processing library)
      this.textVertAlign = TOP;
    }
  }

  /*-------------------------------------- showTextInput() ------------------------------------------------*/

  // Creating a public showTextInput function, which can be called anywhere in the code
  // to display the TextInput, and add any text that has been specified
  public void showTextInput() {

    // Calling the show() method (which was inherited from the Rectangle class so that this TextInput will be
    // displayed on screen
    this.show();

    // Checking if the length of the value is greater than 0 i.e. is there text to be added to this TextInput
    if (this.inputValue.length() > 0) {

      // Calling the Rectangle class's addTextBox() method, as inherited through the ClickableElement
      // class. Passing in the current input value of the input, along with the x and y dimensions for
      // this text box. Also passing in a left alignment (for the text on the X axis, as we have no
      // text inputs with horizontal alignments other than left) and the vertical text alignment, as
      // defined in this TextInput's constructor.
      this.addTextBox(this.inputValue, this.textX1, this.textY1, this.textX2, this.textY2, LEFT, this.textVertAlign);
    }

    // Checking if the mouse was clicked, using a custom variable defined in the main Sketch (to
    // differentiate between mouse clicked and mouse pressed (i.e. clicking or scrolling)
    if (mouseClicked) {

      // Checking if the mouse was over this TextInput when the click occurred (using the checkMouseOver() method
      // inherited from the ClickableElement class). This method returns a boolean value, to confirm if the
      // mouse was over the TextInput when the click occurred.
      if (this.checkMouseOver()) {

        // Setting the currentTextInput variable in the main which stores TextInput objects, to
        // be equal to this TextInput so that any text which is entered while this input is in focus,
        // will be added to it.
        currentTextInput = this;

        // Clearing the value of currentTextInputValue, which stores the value of the current text input,
        // so that text from previous TextInput's will not be carried over to this one. If this input already
        // had a value when the user clicked on it, this will be added again in the main by accessing
        // it's current value using the get method on the currentTextInput variable defined above.
        currentTextInputValue = "";

        // Logging out that this TextInput was clicked on.
        println("The " + this.inputTitle + " text input was clicked on");
      }
    }
  }

  // Get method which returns the current value of the text entered into in this input
  public String getInputValue() {
    return this.inputValue;
  }

  // Set method to set the current value of the text entered into this input
  public void setInputValue(String val) {
    this.inputValue = val;
  }

  // Get method which returns the maximum number of characters allowed into this input
  public int getMaxTextLength() {
    return maxTextLength;
  }

  // Set method to set the maximum amount of characters allowed into this input
  public void setMaxTextLength(int maxLength) {
    maxTextLength = maxLength;
  }

  // Clear method which clears the current value of this input
  public void clearInputValue() {
    this.inputValue = "";
  }
}