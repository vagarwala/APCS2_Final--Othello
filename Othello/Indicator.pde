public class Indicator{
  Manager manager;
  Easing easing;
  
  boolean isTargetTurnBlack;
  float frameAnimation_t = 0;
  float frameAnimationDuration = 30;
  boolean bPlayerFrameAnimation = false;
  final int frameWidth = 120;
  final int frameHeight = 45;
  PVector playerFramePos;
  final color frostedCoverColor = color(180, 150);
  
  public Indicator (Manager manager){
    this.manager = manager;
    this.easing = new Easing();
    if (this.manager.black_turn){
      this.playerFramePos = new PVector(frameWidth / 2, frameHeight/2 + 3);
    } else{
      this.playerFramePos = new PVector(width-this.frameWidth/2, this.frameHeight/2+3);
    }
  }
  
  public void draw(){
    this.drawPlayer();
    this.drawResult();
  }
  private void drawPlayer() {  
    // color
    textSize(SIZE*.6);
    textAlign(LEFT, TOP);
    fill(OTHELLO_WHITE);
    text("BLACK", 10, 5);
    textAlign(RIGHT, TOP);
    fill(OTHELLO_WHITE);
    text("WHITE", width-10, 5);
    //
    textAlign(CENTER, TOP);
    text("phase:"+this.manager.gamePhase, width/2, 5);
    textAlign(CENTER, BOTTOM);
    text("UNDO (press space)", width/2, height-5);
    // frame
    drawPlayerFrame();
  }
  
  private void drawPlayerFrame(){
  }
  private void animatePlayerTransition(boolean isNextBlack){
  }
  private void drawResult(){
  }
}