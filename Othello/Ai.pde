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