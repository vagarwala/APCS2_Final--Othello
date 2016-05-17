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
    PVector bestMove = new PVector(-1, -1, -1); // i, j for location, k for evaluation of field[i][j]
    int num_criteria = 3;
    float[] weights = {0.3, 0.3, 0.3};
    float evaluationValue[][][] = new float[NUM_SIDE][NUM_SIDE][num_criteria+1];
    //initialize to 0
    for (float[][] eValues2:evaluationValue){
      for(float[] eValues:eValues2){
        for(float eValue:eValues){
          eValue = 0;
        }
      }
    }
    //go through evaluations
    for (int i = 0; i < NUM_SIDE; i++){
      for (int j = 0; j < NUM_SIDE; j++){
        if(!this.manager.field.isOpen[i][j])
          continue;
        evaluationValue[i][j][0] += this.valueOfStandardMoves(i, j);
        evaluationValue[i][j][1] += this.valueOfStonesYouCanGet(i, j);
        evaluationValue[i][j][2] += this.valueOfDegreeOfOpen(i, j);
      }
    }
    //putting those values into the single value
    for(int i = 0; i < NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        if(!this.manager.field.isOpen[i][j])
          continue;
        for(int k = 0; k < num_criteria; k++){
          evaluationValue[i][j][num_criteria] += weights[k]*evaluationValue[i][j][k];
        }      
      }
    }
    // find max eval -- best move
    for(int i = 0; i< NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        if(!this.manager.field.isOpen[i][j])continue;
        if(evaluationValue[i][j][num_criteria]>bestMove.z){
          bestMove.x = i;
          bestMove.y = j;
          bestMove.z = evaluationValue[i][j][num_criteria];
        }
      }
    }
    return new PVector((int)bestMove.x, (int)bestMove.y);
  }
  
  private float valueOfStandardMoves(int x, int y){
    // corner - yay!
    if(x+y==0 || x*y==(NUM_SIDE-1)*(NUM_SIDE-1) || (x==0&&y==NUM_SIDE-1) || (x==NUM_SIDE-1&&y==0))
      return 1.0; 
    // edge - :)
    if(x==0 || y==0 || x==NUM_SIDE-1 || y==NUM_SIDE-1)
      return 0.8;
    // inside of corner - uh oh
    if(x*y==1 || (x==1&&y==NUM_SIDE-2) || (x==NUM_SIDE-2&&y==1) || (x==NUM_SIDE-2&&y==NUM_SIDE-2))
      return 0.0;
    // next to edge - :(
    if(x==1 || x==NUM_SIDE-2 || y==1 || y==NUM_SIDE-2)
      return 0.1;
    // else - ¯\_(ツ)_/¯
    return 0.5;
  }
  
  private float valueOfStonesYouCanGet(int x, int y) {
    return 0.0;
  }
  
  private float valueOfDegreeOfOpen(int x, int y){
    return 0.0;
  }
}