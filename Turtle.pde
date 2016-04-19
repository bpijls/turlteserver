class Turtle {
  PVector position, startPosition, endPosition, direction;  
  boolean moving = false;
  SpriteSheet spriteSheet;
  float t = 0.0;
  String name;
  ArrayList<LineSegment> lines = new ArrayList<LineSegment>();
  int lineColor = color(255);
  int lineWeight = 3;
  float angle;  
  boolean showUI = false;
  boolean showHelp = false;

  Turtle(String name) {    
    spriteSheet = new SpriteSheet("turtle@X4N4.png");
    spriteSheet.pause();
    float x = random(0, width-spriteSheet.frameWidth), 
      y = random(0, height - spriteSheet.frameHeight); 
    position = new PVector(x, y);
    startPosition = new PVector(x, y);
    direction = new PVector(0, 1);
    endPosition = new PVector(x, y);

    this.name = name;    
    if (this.name == null)
      this.name = "blub";
  }

  void parseCommands(StringDict commands) {
    if (commands.hasKey("x")) moveX(Integer.parseInt(commands.get("x")));
    if (commands.hasKey("y")) moveY(Integer.parseInt(commands.get("y")));
    if (commands.hasKey("r")) lineColor = setRed(lineColor, Integer.parseInt(commands.get("r")));
    if (commands.hasKey("g")) lineColor = setGreen(lineColor, Integer.parseInt(commands.get("g")));
    if (commands.hasKey("b")) lineColor = setBlue(lineColor, Integer.parseInt(commands.get("b")));
    if (commands.hasKey("w")) lineWeight = Integer.parseInt(commands.get("w"));
    if (commands.hasKey("name")) name = commands.get("name");    
    if (commands.hasKey("c")) if (commands.get("c").equals("true")) lines.clear();
    if (commands.hasKey("h")) showHelp = commands.get("h").equals("true") ? true : false;
    if (commands.hasKey("u")) showUI = commands.get("u").equals("true") ? true : false;

    name = name.substring(0, 16);
    if (name.equals("")) name = "NoName Troll";
  }

  void update() {

    if (moving) {
      position = PVector.add(startPosition, PVector.mult(PVector.sub(endPosition, startPosition), t));
      t += 0.02;
      direction = PVector.sub(endPosition, startPosition);
      direction.normalize();
      this.angle = atan2(direction.y, direction.x) + PI/2;
    }

    if (t > 1.0) {
      t = 0;
      moving = false;
      lines.add(new LineSegment(startPosition, endPosition, lineColor, lineWeight));
      startPosition.set(endPosition.x, endPosition.y);
      spriteSheet.pause();
    }
  }

  void moveX(float x) {
    endPosition.x = x;
    moveTo(endPosition);
  }

  void moveY(float y) {
    endPosition.y = y;
    moveTo(endPosition);
  }

  void moveTo(PVector endPosition) {        
    this.endPosition.x = constrain(this.endPosition.x, 0, width);
    this.endPosition.y = constrain(this.endPosition.y, 0, height);

    // if already moving, stop and start a new line segment
    if (moving)
      lines.add(new LineSegment(startPosition, position, lineColor, lineWeight));

    this.startPosition = new PVector(position.x, position.y);
    t = 0.0;
    this.endPosition = endPosition;
    moving = true;
    spriteSheet.play();

    position.x = constrain(position.x, 0, width);
    position.y = constrain(position.y, 0, height);
  }    

  void draw() {
    this.lineWeight = constrain(this.lineWeight, 0, 20);

    for (LineSegment lineSeg : lines)
      lineSeg.draw();

    stroke(lineColor);

    strokeWeight(lineWeight);
    line(startPosition.x, startPosition.y, position.x, position.y);
    pushMatrix(); 
    {
      translate(position.x, position.y );     
      pushMatrix();
      {
        rotate(angle);      
        translate(spriteSheet.frameWidth/2, spriteSheet.frameHeight/2);

        spriteSheet.update();
        spriteSheet.draw();
        pushMatrix();
        {
          rotate(-angle);
          text(name, -spriteSheet.frameWidth/2 - textWidth(name)/2, -20);
        }
        popMatrix();
      }    
      popMatrix();
    }
    popMatrix();
  }
}