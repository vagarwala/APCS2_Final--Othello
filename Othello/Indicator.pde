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
  private void drawPlayer(){
  }
  
  private void drawPlayerFrame(){
  }
  private animatePlayerTransition(boolean isNextBlack){
  }
  private void drawResult(){
  }
  