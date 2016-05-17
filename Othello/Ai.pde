public class Ai{
  Manager manager;
  private boolean isBlack;
  private boolean isMyTurn;
  
  public Ai(boolean Black, Manager manager){
    this.manager = manager;
    this.isBlack = Black;
    this.isMyTurn = (Black)?true:false;
  }
  
  public void run(){
    if(this.manager.isGameOver)
      return;
    if(this.manager.isPass)
      return;
    this.isMyTurn = (this.manager.black_turn==this.isBlack)?true:false;
    if(!this.isMyTurn)
      return;
    if(this.manager.indicator.bPlayerFrameAnimation)
      return;
    PVector newStonePos = decideStonePos();
    this.manager.putStone((int)newStonePos.x, (int)newStonePos.y);
    this.isMyTurn = false;
  }
  
  public PVector decideStonePos(){
  }
  
  private float valueOfStandardMovesToEvaluationValue(int x, int y){
  }
  
  private float valueOfStonesYouCanGetToEvaluationValue(int x, int y) {
  }
  
  private float valueOfTheoryOfDegreeOfOpenToEvaluationValue(int x, int y){
  }
}