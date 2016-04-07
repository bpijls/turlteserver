class LineSegment{
  PVector p0, p1;
  int lineColor;
  int lineWeight;
  
  LineSegment(PVector p0, PVector p1, int lineColor, int lineWeight){
    this.p0 = new PVector(p0.x, p0.y);
    this.p1 = new PVector(p1.x, p1.y);
    this.lineColor = lineColor;
    this.lineWeight = lineWeight;
  }
  
  void draw(){    
    stroke(lineColor);
    strokeWeight(this.lineWeight);
    line(p0.x, p0.y, p1.x, p1.y);
  }
}
