import java.util.*;
public class Ai{
  Manager manager;
  private boolean isBlack;
  private boolean isMyTurn;
  
  public Ai(boolean Black, Manager manager){
    this.manager = manager;
    isBlack = Black;
    isMyTurn = (Black)?true:false;
  }
  
  public void run(){
    if(manager.isGameOver)
      return;
    if(manager.isPass)
      return;
    isMyTurn = (manager.black_turn==isBlack)?true:false;
    if(!isMyTurn)
      return;
    if(manager.indicator.bPlayerFrameAnimation)
      return;
    PVector newStonePos = decideStonePos();
    manager.putStone((int)newStonePos.x, (int)newStonePos.y);
    isMyTurn = false;
  }
  
  /*
  
  //// MINIMAX VERSION 1 -- NOT WORKING ////
  
  public PVector decideStonePos(){
    MoveValue bMove = minMax((float)Integer.MIN_VALUE, (float)Integer.MAX_VALUE, 2, false);
    Move move = bMove.returnMove;
    return move.pos;
  }
  
  private MoveValue minMax(float alpha, float beta, int maxDepth, boolean blackturn) {       
      manager.black_turn = blackturn;      
      manager.detectSpaceOpen(blackturn);
      ArrayList<MoveValue> moves = new ArrayList<MoveValue>();
      for(int i = 0; i< NUM_SIDE; i++){
        for(int j = 0; j < NUM_SIDE; j++){
          if(manager.field.isOpen[i][j]){
            float ret = valueOfStonesYouCanGet(i, j, blackturn);
            MoveValue move = new MoveValue(ret, new Move(i, j));
            moves.add(move);
          }
        }
      }
      Iterator<MoveValue> movesIterator = moves.iterator();
      float value = 0;
      boolean isMaximizer = blackturn; 
      if (maxDepth == 0 || manager.isGameOver) {
          float retVal = manager.getScores().y;
          return new MoveValue(retVal);
      }
      MoveValue returnMove;
      MoveValue bestMove = null;
      if (isMaximizer) {           
          while (movesIterator.hasNext()) {
              MoveValue currentMove = movesIterator.next();
              manager.putStone((int)currentMove.returnMove.pos.x, (int)currentMove.returnMove.pos.y);
              returnMove = minMax(alpha, beta, maxDepth - 1, !blackturn);;
              manager.undoMove();
              if ((bestMove == null) || (bestMove.returnValue < returnMove.returnValue)) {
                  bestMove = returnMove;
                  bestMove.returnMove = currentMove.returnMove;
              }
              if (returnMove.returnValue > alpha) {
                  alpha = returnMove.returnValue;
                  bestMove = returnMove;
              }
              if (beta <= alpha) {
                  bestMove.returnValue = beta;
                  bestMove.returnMove = null;
                  return bestMove; // pruning
              }
          }
          return bestMove;
      } else {
          while (movesIterator.hasNext()) {
              MoveValue currentMove = movesIterator.next();
              manager.putStone((int)currentMove.returnMove.pos.x, (int)currentMove.returnMove.pos.y);
              returnMove = minMax(alpha, beta, maxDepth - 1, !blackturn);
              manager.undoMove();
              if ((bestMove == null) || (bestMove.returnValue > returnMove.returnValue)) {
                  bestMove = returnMove;
                  bestMove.returnMove = currentMove.returnMove;
              }
              if (returnMove.returnValue < beta) {
                  beta = returnMove.returnValue;
                  bestMove = returnMove;
              }
              if (beta <= alpha) {
                  bestMove.returnValue = alpha;
                  bestMove.returnMove = null;
                  return bestMove; // pruning
              }
          }
          return bestMove;
      }
      */
  
  /*
  
  //// MINIMAX VERSION 2, WITHOUT A-B PRUNING ////
  
  
  public int minimax(int depth) {
    if (isMyTurn) {
      return valueMax(depth);
    } else {
      return valueMin(depth);
    }
  }

  private int valueMax(int depth) {
    int best = Integer.MIN_VALUE;
    if (depth <= 0 || manager.isGameOver) {
      return (int)manager.getScores().y;
    }
    manager.detectSpaceOpen(false);
    ArrayList<MoveValue> moves = new ArrayList<MoveValue>();
    for(int i = 0; i< NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        if(manager.field.isOpen[i][j]){
          float ret = valueOfStonesYouCanGet(i, j, false);
          MoveValue move = new MoveValue(ret, new Move(i, j));
          moves.add(move);
        }
      }
    }
    for (MoveValue move : moves) {
      manager.putStone((int)move.returnMove.pos.x, (int)move.returnMove.pos.y);
      int value = valueMin(depth - 1);
      manager.undoMove();
      if (value > best) {
        best = value;
      }
    }
    return best;
  }

  private int valueMin(int depth) {
    int best = Integer.MAX_VALUE;
    if (depth <= 0 || manager.isGameOver) {
      return (int)manager.getScores().x;
    }
    manager.detectSpaceOpen(true);
    ArrayList<MoveValue> moves = new ArrayList<MoveValue>();
    for(int i = 0; i< NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        if(manager.field.isOpen[i][j]){
          float ret = valueOfStonesYouCanGet(i, j, true);
          MoveValue move = new MoveValue(ret, new Move(i, j));
          moves.add(move);
        }
      }
    }
    for (MoveValue move : moves) {
      manager.putStone((int)move.returnMove.pos.x, (int)move.returnMove.pos.y);
      int value = valueMin(depth - 1);
      manager.undoMove();
      if (value < best) {
        best = value;
      }
    }
    return best;
  }
  
  //BUT HOW DO I GET THE MOVE
  
  */
  
  //// ORIGINAL ALGO - NOT MINIMAX, BUT WORKING ////
  
  public PVector decideStonePos(){
    PVector bestMove = new PVector(-1, -1, -1); // i, j for location, k for evaluation of field[i][j]
    int num_criteria = 3;
    float[] weights = {0.2, 0.5, 0.3};
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
        if(!manager.field.isOpen[i][j])
          continue;
        evaluationValue[i][j][0] += valueOfStandardMoves(i, j);
        if (evaluationValue[i][j][0] == 1)
          return new PVector((int)i, (int)j);
        evaluationValue[i][j][1] += valueOfStonesYouCanGet(i, j, isBlack);
        evaluationValue[i][j][2] += valueOfDegreeOfOpen(i, j);
      }
    }
    //putting those values into the single value
    for(int i = 0; i < NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        if(!manager.field.isOpen[i][j])
          continue;
        for(int k = 0; k < num_criteria; k++){
          evaluationValue[i][j][num_criteria] += weights[k]*evaluationValue[i][j][k];
        }      
      }
    }
    // find max eval -- best move
    for(int i = 0; i< NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        if(!manager.field.isOpen[i][j])
          continue;
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
  
  private float valueOfStonesYouCanGet(int x, int y, boolean Black) {
    int num_stonesYouCanGet = 0;
    float evaluationValue = 0; // evaluation value which will return 
    // check all direction around myself
    for(int i = -1; i < 2; i++){
      for(int j = -1; j < 2; j++){
        if(i == 0 && j == 0)
          continue;
        if(!manager.field.isOpenDir[x][y][i+1][j+1])
          continue;
        // add the number of stones which will reverse if a stone put here(x, y)
        num_stonesYouCanGet += stonesYouCanGet(x+i, y+j, i, j, Black);
      }
    }
    // normalize the number of stones which you could reverse
    evaluationValue = (float)num_stonesYouCanGet/18.f; // max stones which are returned at once is 18
    return evaluationValue;
  }

  // recursion method that is called in addValueOfStonesYouCanGetToEvaluationValue()
  private int stonesYouCanGet(int x, int y, int dir_x, int dir_y, boolean isMyColorBlack) {
    int myColor = (isMyColorBlack)?BLACK: WHITE;
    // end of counting stones
    if(manager.field.field[x][y] == myColor)
      return 0;
    //recursion
    return 1+stonesYouCanGet(x+dir_x, y+dir_y, dir_x, dir_y, isMyColorBlack);
  }
  
  // evaluate based on the theory of a degree of open
  private float valueOfDegreeOfOpen(int x, int y) {
    if(x < 0 || NUM_SIDE-1 < x || y < 0 || NUM_SIDE-1 < y)
      return 0;
    float[][] tempDegreesOfOpen = calculateDegreesOfOpenFromField(manager.field, isBlack);
    // max of the values of the a degree of open
    float max = 0.f;
    for(float[] vals: tempDegreesOfOpen){
      for(float val: vals){
        max = (val>max)?val: max;
      }
    }
    // map values between the range from 0 to 1
    for(int i = 0; i < NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        tempDegreesOfOpen[i][j] /= max;
      }
    }
    return tempDegreesOfOpen[x][y];
  }

  // theory of a degree of open
  //ArrayList<PVector> buffer_openIndex = new ArrayList<PVector>(); // buffer for overlap of indexes of open space,  
  private float[][] calculateDegreesOfOpenFromField(Field fieldObj, boolean isBlackTurn) {
    // values of all space
    float[][] valuesOfAll = new float[NUM_SIDE][NUM_SIDE];
    // initialize
    for(float[] vals: valuesOfAll){
      for (float val : vals) {
        val = 0;
      }
    }
    // end recursion
    if(fieldObj.field.length != NUM_SIDE || fieldObj.field[0].length != NUM_SIDE)
      return valuesOfAll;
    // continue recursion
    for(int i = 0; i < NUM_SIDE; i++){
      for (int j = 0; j < NUM_SIDE; j++) {
        if(!fieldObj.isOpen[i][j])
          continue;
        // initialize buffer
        ArrayList<PVector> buffer_openIndex = new ArrayList<PVector>();
        // check all direction
        for(int _i = -1; _i < 2; _i++){
          for(int _j = -1; _j < 2; _j++){
            if(!fieldObj.isOpenDir[i][j][_i+1][_j+1])
              continue;
            // check next to here(i, j)
            countTheNumberOfSpaceOpen(i+_i, j+_j, _i, _j, isBlackTurn, fieldObj, buffer_openIndex);
          }
        }
        // get raw data of a degree of open
        valuesOfAll[i][j] = buffer_openIndex.size();
      }
    }
    return valuesOfAll;
  }

  // this method will called as recursion in function calculateDegreesOfOpenFromField()
  private void countTheNumberOfSpaceOpen(int x, int y, int dir_x, int dir_y, boolean isMyColorBlack, Field fieldObj, ArrayList<PVector> buffer) {
    int myColor = (isMyColorBlack)?BLACK: WHITE;
    // if this stone color is same as mine, end
    if(myColor == fieldObj.field[x][y])
      return;
    // check around here(x, y)
    for(int i = -1; i < 2; i++){
      for(int j = -1; j < 2; j++){
        int target_x = x+i;
        int target_y = y+j;
        if(target_x<0 || NUM_SIDE-1<target_x || target_y<0 || NUM_SIDE-1<target_y)
          continue;
        if(fieldObj.field[target_x][target_y] != NONE)
          continue;
        boolean bValid = true;
        // check whether or not an overlap is exist
        for(PVector buff: buffer){
          // if there are overlaps, don't count 
          if(!bValid)
            break;
          if(buff.x==target_x && buff.y==target_y)
            bValid &= false;
        }
        // count
        if(bValid)
          buffer.add(new PVector(target_x, target_y));
      }
    }
    // recursion 
    countTheNumberOfSpaceOpen(x+dir_x, y+dir_y, dir_x, dir_y, isMyColorBlack, fieldObj, buffer);
  }
}