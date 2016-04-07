// Methods to set individual components in an integer-encoded color
int setRed(int clr, int newRed){ return color(newRed, green(clr), blue(clr)); }
int setGreen(int clr, int newGreen){ return color(red(clr), newGreen, blue(clr)); }
int setBlue(int clr, int newBlue){ return color(red(clr), green(clr), newBlue); }
