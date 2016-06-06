import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.util.Date; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Othello extends PApplet {

final int SIZE = 50; // width and height size of a square
final int NUM_SIDE = 8; // the number of squares in a row or column
final int NUM_GAME_PHASE  = NUM_SIDE*NUM_SIDE-3;
final int FIELD_WIDTH = SIZE*NUM_SIDE; // width of board size
final int FIELD_HEIGHT = SIZE*NUM_SIDE; // height of board size
final int STONE_SIZE = (int)(SIZE*0.7f); // diameter of stone
final int NONE = 0; // indicate empty square
final int BLACK = 1; // indicate square where black stone put or winner is black
final int WHITE = 2; // indicate square where white stone put or winner is white
final int DRAW = -1; // indicate this game ended in a draw
final int OTHELLO_WHITE = color(256); // white color
final int OTHELLO_BLACK = color(0); // black color
final int OTHELLO_GREEN = color(0, 128, 0); // green color


Manager manager;

int global_t = 0; // this value will show frame count

public void settings(){
  size(10*SIZE, 10*SIZE);
}
public void setup(){
  manager = new Manager(false);
  PFont literation;
  literation = loadFont("LiterationMonoPowerline-Italic-20.vlw");
  textFont(literation);
}

// main program
public void draw(){
    background(40);
    manager.update(global_t);
    global_t++;
}

//mouse event
public void mousePressed(){
    manager.mousePressed(mouseX, mouseY);
}

public void keyPressed(){
  manager.keyPressed(key);
}

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
    float[] weights = {0.2f, 0.5f, 0.3f};
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
      return 1.0f; 
    // edge - :)
    if(x==0 || y==0 || x==NUM_SIDE-1 || y==NUM_SIDE-1)
      return 0.8f;
    // inside of corner - uh oh
    if(x*y==1 || (x==1&&y==NUM_SIDE-2) || (x==NUM_SIDE-2&&y==1) || (x==NUM_SIDE-2&&y==NUM_SIDE-2))
      return 0.0f;
    // next to edge - :(
    if(x==1 || x==NUM_SIDE-2 || y==1 || y==NUM_SIDE-2)
      return 0.1f;
    // else - \u00af\_(\u30c4)_/\u00af
    return 0.5f;
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
public class Buffers{
  ArrayList<PhaseBuffer> buffers;
  int tempPhase = 0;
  public Buffers(){
    buffers = new ArrayList<PhaseBuffer>();
  }
  
  public void save(int[][] theField, int Put_x, int Put_y, boolean Black, int phase){
    tempPhase = phase;
    buffers.add(new PhaseBuffer(theField, new PVector(Put_x, Put_y), Black));
  }
  
  public void save(PhaseBuffer tempStatus, int phase){
    tempPhase = phase;
    buffers.add(tempStatus);
  }
  
  public void optimize(){
    for(int i = buffers.size()-1; i > tempPhase; i--){
      buffers.remove(i);
    }
  }
  public PhaseBuffer get(int phase){
    return buffers.get(phase);
  }
  public PhaseBuffer get(int phase, boolean bPhaseSync){
    if(bPhaseSync)
      tempPhase = phase;
    int[][] rField = new int[NUM_SIDE][NUM_SIDE];
    for(int i = 0; i < NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        rField[i][j] = buffers.get(phase).fieldBuffer[i][j];
      }
    }
    PVector rPutPos = buffers.get(phase).putPosBuffer;
    int rColor = buffers.get(phase).turnColor;
    PhaseBuffer result = new PhaseBuffer(rField, rPutPos, rColor);
    optimize();
    return result;
  }
  public void printPhase(){
    println("print all phase buffers");
    for(int phase = 0; phase <= tempPhase; phase++){
      println("-------------------");
      println("phase: "+phase);
      println("turnColor(black-1, white-2): "+buffers.get(phase).turnColor);
      for(int i = 0; i < NUM_SIDE; i++){
        for(int j = 0; j < NUM_SIDE; j++){
          print(buffers.get(phase).fieldBuffer[j][i]+" ");
          if(j==NUM_SIDE-1)println("");
        }
      }
    }
  }
}

class CSVExporter{
  String[] keys = {"id", "player1", "player2", "winner"};
  Table table = loadTable("gamedata.csv", "header");
  public void addValues(int p1, int p2, int winner){
    TableRow newRow = table.addRow();
    newRow.setInt(keys[0], table.getRowCount()-1);
    newRow.setInt(keys[1], p1);
    newRow.setInt(keys[2], p2);
    String winnerName = "none";
    switch (winner) {
      case BLACK:
        winnerName = "black";
        break;
      case WHITE:
        winnerName = "white";
        break;
      case DRAW :
        winnerName = "draw";
        break;
      default :
        winnerName = "none";
        break;  
    }
    newRow.setString(keys[3], winnerName);
    saveTable(table, "data/gamedata.csv");
  }
}
public class Easing {
  public Easing () {
  }

  public float easeIn(float t, float begin, float end, float duration) {
    t /= duration;
    return end*t*t+begin;
  }

  public float easeOut(float t, float begin, float end, float duration) {
    t /= duration;
    return -end*t*(t-2.0f) + begin;
  }

  public float easeInOut(float t, float begin, float end, float duration) {
    t /= duration/2.f;
    if(t < 1)return end/2.0f*t*t + begin;
    t--;
    return -end/2.f*(t*(t-2.f)-1.f) + begin;
  }
}
// this class will show board graphics
public class Field{

  Stones stones;

  int[][] field;
  PVector[][] fieldPos;
  PVector indexStonePutLast;
  boolean[][] isOpen;
  boolean[][][][] isOpenDir; //1st,2nd are indexes, 3rd,4th are direction vector

  boolean bTurningAnimation = false;

  // constructor
  public Field () {
    stones = new Stones(this);

    field = new int[NUM_SIDE][NUM_SIDE];
    fieldPos = new PVector[NUM_SIDE][NUM_SIDE];
    indexStonePutLast = new PVector(-1, -1);
    isOpen = new boolean[NUM_SIDE][NUM_SIDE];
    isOpenDir = new boolean[NUM_SIDE][NUM_SIDE][3][3];
    for(int i=0; i<NUM_SIDE; ++i){
      for(int j=0; j<NUM_SIDE; ++j){
        field[i][j] = NONE;
        fieldPos[i][j] = new PVector((i*2+1)*SIZE/2+SIZE,(j*2+1)*SIZE/2+SIZE);
        isOpen[i][j] = false;
      }
    }
    // set initial stones
    field[NUM_SIDE/2-1][NUM_SIDE/2-1] = WHITE;
    field[NUM_SIDE/2][NUM_SIDE/2] = WHITE;
    field[NUM_SIDE/2-1][NUM_SIDE/2] = BLACK;
    field[NUM_SIDE/2][NUM_SIDE/2-1] = BLACK;
  }

  // draw all field visuals
  public void draw() {
    // draw board
    rectMode(CORNER);
    colorMode(RGB);
    stroke(0);
    strokeWeight(1);
    fill(OTHELLO_GREEN);
    rect(width*.1f, height*.1f, FIELD_WIDTH, FIELD_HEIGHT);
     // draw board lines
     stroke(30);
     strokeWeight(2);
     for(int i=1; i<NUM_SIDE; i++){
       line(i*SIZE+SIZE,SIZE,i*SIZE+SIZE,height-SIZE);
       line(SIZE, i*SIZE+SIZE, width-SIZE, i*SIZE+SIZE);
     }
     // blink which squares you can put stones
        blinkOpenSpace();
        // blink which square that a stone put last
        blinkLastPut();
    }

    // indicate which squares you can put stones
    private void blinkOpenSpace(){
    rectMode(CENTER);
    //blink color
    float ele_red = 128.f*sin(global_t*.07f)+128.f;
    stroke(128, 0, 0, 255);
    strokeWeight(2);
    fill((int)ele_red, 0, 0, 80);
    // if a square is available, blink
    for(int i = 0; i < NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        if(isOpen[i][j]){
          rect(fieldPos[i][j].x, fieldPos[i][j].y, SIZE, SIZE);
        }
      }
    }
  }

  // indicate which square that stone put
  private void blinkLastPut() {
    if(indexStonePutLast.x==-1||indexStonePutLast.y==-1)
      return;
    rectMode(CENTER);
    // blink color
    float ele_blue = 128.f*cos(global_t*.07f)+128.f;
    stroke(0, 0, 128, 255);
    strokeWeight(2);
    fill(0, 0, (int)ele_blue, 80);
    // draw a square which is a stone put last
    int stonelast_x  = (int)fieldPos[(int)indexStonePutLast.x][(int)indexStonePutLast.y].x;
    int stonelast_y  = (int)fieldPos[(int)indexStonePutLast.x][(int)indexStonePutLast.y].y;
    rect(stonelast_x, stonelast_y, SIZE, SIZE);
  }
}
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
  final int frostedCoverColor = color(180, 150);
  
  public Indicator (Manager manager){
    this.manager = manager;
    easing = new Easing();
    if (this.manager.black_turn){
      playerFramePos = new PVector(frameWidth / 2, frameHeight/2 + 3);
    } else{
      playerFramePos = new PVector(width-frameWidth/2, frameHeight/2+3);
    }
  }
  
  public void draw(){
    drawPlayer();
    drawResult();
  }
  private void drawPlayer() {  
    // color
    if (!manager.isGameOver){
      textSize(SIZE*.6f);
      textAlign(LEFT, TOP);
      fill(OTHELLO_WHITE);
      text("BLACK", 10, 5);
      textSize(25);
      text((int)manager.getScores().x, 130, 8);
      textAlign(CENTER, TOP);
      if (manager.isGameOver){
      }
      else if(manager.getScores().x > manager.getScores().y){
        textSize(20);
        text("winning by " + (int)(manager.getScores().x - manager.getScores().y), 250, 10);
      }else if (manager.getScores().x < manager.getScores().y){
        textSize(20);
        text("losing by " + (int)(manager.getScores().y - manager.getScores().x), 250, 10);
      } else{
        textSize(20);
        text("tied", 250, 10);
      }
      textAlign(RIGHT, TOP);
      fill(OTHELLO_WHITE);
      textSize(25);
      text((int)manager.getScores().y, width-130, 8);
      textSize(30);
      text("WHITE", width-10, 5);
      //
      textAlign(CENTER, BOTTOM);
      if (manager.isGameOver)
        text("Press r to reset.", width/2, height-5);
      else
        text("UNDO (press space)", width/2, height-5);
    // frame
    }
    drawPlayerFrame();
  }
  
  private void drawPlayerFrame() {
    // trigger frame animation when this turn have to pass
    if(manager.isPass)
      bPlayerFrameAnimation = true;
    // animate frame transition
    if(bPlayerFrameAnimation)
      animatePlayerTransition(isTargetTurnBlack);
    // frame
    if(!manager.isGameOver){
      rectMode(CENTER);
      stroke(0xffff0000);
      strokeWeight(2);
      fill(0xffff0000, 30);
      rect(playerFramePos.x, playerFramePos.y, frameWidth, frameHeight);
    }
    // if this turn have to pass, announce this
    if(manager.isPass){
      // frost background
      rectMode(CENTER);
      fill(frostedCoverColor);
      noStroke();
      rect(width/2, height/2, width, height/2);
      // text
      textAlign(CENTER);
      textSize(50);
      fill(0xff000088);
      stroke(0);
      strokeWeight(2);
      text("Pass", width/2, height/2);
    }
  }
  
  private void animatePlayerTransition(boolean isNextBlack) {
    // for a rainy day
    if(!bPlayerFrameAnimation)
      return;
    // when next player is black
    if(isNextBlack){
      // easing
      float newFrameX = easing.easeOut(frameAnimation_t, (float)width-(float)frameWidth/2, -(float)width+(float)frameWidth, frameAnimationDuration);
      playerFramePos.x = newFrameX;
    }
    // when next player is white
    else if(!isNextBlack){
      //easing
      float newFrameX = easing.easeInOut(frameAnimation_t, (float)frameWidth/2, (float)width-(float)frameWidth, frameAnimationDuration);
      playerFramePos.x = newFrameX;
    }
    // finish easing
    if(frameAnimationDuration <= frameAnimation_t){
      frameAnimation_t = 0.f;
      bPlayerFrameAnimation = false;
      manager.isPass = false;
    }
    // update parameter
    else frameAnimation_t++;
  }
  
  private void drawResult() {
    // for a rainy day
    if(!manager.isGameOver)
      return;
    if(!bPlayerFrameAnimation){
      String resultWinner = "Winner: ";
      // set color of the winner
      if(manager.winner == BLACK)
        resultWinner += "BLACK";
      else if(manager.winner == WHITE)
        resultWinner += "WHITE";
      else if(manager.winner == DRAW)
        resultWinner += "DRAW";
      // frost background
      rectMode(CORNER);
      fill(frostedCoverColor);
      noStroke();
      rect(SIZE, SIZE, 8*SIZE, 8*SIZE);
      fill(color(180, 200));
      rect(0, 0, SIZE, 3.5f*SIZE);
      rect(width-SIZE, 0, SIZE, 3.5f*SIZE);
      // draw winner
      textSize(25);
      textAlign(LEFT, TOP);
      fill(OTHELLO_BLACK);
      text((int)manager.getScores().x, 10, 10);
      String message;
      message = "BLACK";
      for(int i = 1; i <= message.length(); i++){
        text(message.substring(i-1,i), 19, 21 + i *23);
      }
      textAlign(RIGHT, TOP);
      text((int)manager.getScores().y, width - 10, 10);
      message = "WHITE";
      for(int i = 1; i <= message.length(); i++){
        text(message.substring(i-1,i), width - 18, 21 + i *23);
      }
      textAlign(CENTER, TOP);
      textSize(30);
      fill(0xffff0000);
      text(resultWinner, width/2, 10);
      text("Press r to reset.", width/2, height - SIZE + 10);
      /*//draw scores
      textSize(40);
      if(manager.winner==BLACK)
        textSize(50);
      else
        textSize(40);
      textAlign(LEFT);
      fill(0);
      text((int)manager.getScores().x, width/3, height/2+50);
      if(manager.winner == WHITE)
        textSize(50);
      else
        textSize(40);
      textAlign(RIGHT);
      fill(255);
      text((int)manager.getScores().y, 2*width/3, height/2+50);
      
      textAlign(CENTER);
      textSize(20);
      fill(#880000);
      text("Press r to reset.", width/2, height/2 + 100);
      */
    }
  }
}
// this class does all the things
public class Manager  {
  int t;
  int gamePhase = 0;

  Field field;
  Stones stones;
  Indicator indicator;
  Ai ai;
  CSVExporter csv;
  Buffers buffer;

  boolean isOpponentAi = false;
  boolean isOpponentBlack = false;

  PVector indexStonePutLast = new PVector(-1, -1);
  boolean black_turn = true;
  boolean isGameOver = false;
  boolean isPass = false;
  boolean isSaved = false;

  int winner = NONE; // decide at end of the game

  // constructor
  public Manager () {
    t = 0;
    field = new Field();
    stones = new Stones(field);
    indicator = new Indicator(this);
    csv = new CSVExporter();
    buffer = new Buffers();

    detectSpaceOpen(black_turn); // initialize which square you can put
    
    isOpponentAi = false;
    // save this state
    int[][] tField = new int[NUM_SIDE][NUM_SIDE];  
    for(int i = 0; i < NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        tField[i][j] = field.field[i][j];
      }
    }
    buffer.save(new PhaseBuffer(tField, new PVector(-1, -1), black_turn), gamePhase);

  }

  // constructor for playing with AI opponent
  public Manager(boolean isOpponentBlack) {
    this();
    // AI part
    isOpponentAi = true;
    this.isOpponentBlack = isOpponentBlack;
    ai = new Ai(this.isOpponentBlack, this);
  }

  //this method have to called in main draw()
  public void update(int global_t) {
    t = global_t;
    field.draw();
    stones.draw();
    indicator.draw();
    if(isOpponentAi)
      ai.run();
    if(isGameOver && !isSaved){
      csv.addValues((int)getScores().x, (int)getScores().y, winner);
      isSaved = true;
    }
  }
  
  public int[][] clone(){
    int[][] ret = new int[NUM_SIDE][NUM_SIDE];
    for(int i = 0; i < NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        ret[i][j] = field.field[i][j];
      }
    }
    return ret;
  }
    

  //if at least one square is available, return true
  public boolean isThereOpen(){
    for(boolean[] b_array: field.isOpen){
      for(boolean b: b_array){
        if(b)
          return true;
      }
    }
    return false; // if no square is available
  }

  //return the number of squares where is stones put
  public int getStonePut() {
    int stoneCount = 0;
    for(int i = 0; i < NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        if(field.field[i][j] != NONE)stoneCount++;
      }
    }
    return stoneCount;
  }

  //return now score
  public PVector getScores() {
    //x element is black score, y is white score
    int blackCount = 0;
    int whiteCount = 0;
    for(int i = 0; i < NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        if(field.field[i][j] == BLACK)blackCount++;
        else if(field.field[i][j] == WHITE)whiteCount++;
      }
    }
    return new PVector(blackCount, whiteCount);
  }

  //put stone
  public void putStone(int x, int y) {
    // you cannot play if animation is run
    if(indicator.bPlayerFrameAnimation)
      return;
    if(field.field[x][y]==NONE){
      if(field.isOpen[x][y]){
        gamePhase++;
        // black turn
        if(black_turn){
          // set stone
          field.field[x][y] = BLACK;
          // set stone pos
          indexStonePutLast.set(x, y);
          field.indexStonePutLast.set(x, y);
          //reverse stones
          returnStones(x, y);
          // set direction of animation of frame
          indicator.isTargetTurnBlack = false;
          // change turn
          black_turn = false;
        }
        //white turn
        else if(!black_turn){
          //set stone
          field.field[x][y] = WHITE;
          // set stone pos
          indexStonePutLast.set(x, y);
          field.indexStonePutLast.set(x, y);
          // reverse stones
          returnStones(x, y);
          // set direction of animation of frame
          indicator.isTargetTurnBlack = true;
          // change turn
          black_turn = true;
        }
        // save this state
        println("gamephase", gamePhase);
        int[][] tField = new int[NUM_SIDE][NUM_SIDE];
        for(int i = 0; i < NUM_SIDE; i++){
          for(int j = 0; j < NUM_SIDE; j++){
            tField[i][j] = field.field[i][j];
          }
        }
        boolean rBlack = black_turn;

        PhaseBuffer temp = new PhaseBuffer(tField, new PVector(x, y), rBlack);
        buffer.save(temp, gamePhase);
        buffer.printPhase();
        // trigger a animation of frame
        indicator.bPlayerFrameAnimation = true;
      }
      
    }
    // find available squares
    detectSpaceOpen(black_turn);

    // judge whether game is over or not.
    // if all square is filled.
    if(getStonePut() == NUM_SIDE*NUM_SIDE){
      // decide which player is the winner
      if(getScores().x>getScores().y)winner = BLACK;
      else if(getScores().x<getScores().y)winner = WHITE;
      else winner = DRAW;
      // trigger of event of gameover 
      isGameOver = true;
    }
    // if not all square is filled.
    else if(getScores().x*getScores().y==0 && getScores().mag()!=0){
      // judge which player is the winner
      if(getScores().x>getScores().y)winner = BLACK;
      else if(getScores().x<getScores().y)winner = WHITE;
      else winner = DRAW;
      // trigger of event of gameover
      isGameOver = true;
    }
    // judge whether this turn have to pass
    else{
      if(!isThereOpen()){
        // pass process
        isPass = true;
        black_turn = !black_turn;
        indicator.isTargetTurnBlack = black_turn;
      }    
    }
    // trigger for processing of AI
    if(isOpponentAi)
      ai.isMyTurn = (ai.isBlack==black_turn)?true: false;
  }
  private void undoMove() {
    if(indicator.bPlayerFrameAnimation)
      return;
    if(gamePhase < 1 || gamePhase > buffer.buffers.size())
      return;
    
    gamePhase--;
    
    PhaseBuffer b = buffer.get(gamePhase, true);
    for(int i = 0; i < NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        field.field[i][j] = b.fieldBuffer[i][j];
      }
    }
    indexStonePutLast.set(b.putPosBuffer);
    field.indexStonePutLast.set(b.putPosBuffer);
    println("turncolor",b.turnColor);
    black_turn = (b.turnColor == BLACK)? true: false;
    indicator.isTargetTurnBlack = black_turn;
    indicator.bPlayerFrameAnimation = true;
    detectSpaceOpen(black_turn);
    println("black_turn: "+black_turn);
    isGameOver = false;
  }
  
  private void undo() {
    if(indicator.bPlayerFrameAnimation)
      return;
    if(gamePhase < 1 || gamePhase > buffer.buffers.size())
      return;
    else if(gamePhase == 1){
      gamePhase--;
      println("deff = 1");
    }
    else if (gamePhase > 1 && gamePhase < buffer.buffers.size()){
      gamePhase-=2;
      println("deff = 2");
    }
    
    PhaseBuffer b = buffer.get(gamePhase, true);
    for(int i = 0; i < NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        field.field[i][j] = b.fieldBuffer[i][j];
      }
    }
    indexStonePutLast.set(b.putPosBuffer);
    field.indexStonePutLast.set(b.putPosBuffer);
    println("turncolor",b.turnColor);
    black_turn = (b.turnColor == BLACK)? true: false;
    indicator.isTargetTurnBlack = black_turn;
    indicator.bPlayerFrameAnimation = true;
    detectSpaceOpen(black_turn);
    println("black_turn: "+black_turn);
    isGameOver = false;
  }
  
  private void reset(){
    if(indicator.bPlayerFrameAnimation)return;
    if(gamePhase < 1 || gamePhase > buffer.buffers.size())
      return;
    gamePhase=0;
    PhaseBuffer b = buffer.get(gamePhase, true);
    for(int i = 0; i < NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        field.field[i][j] = b.fieldBuffer[i][j];
      }
    }
    indexStonePutLast.set(b.putPosBuffer);
    field.indexStonePutLast.set(b.putPosBuffer);
    println("turncolor",b.turnColor);
    black_turn = (b.turnColor == BLACK)? true: false;
    indicator.isTargetTurnBlack = black_turn;
    indicator.bPlayerFrameAnimation = true;
    detectSpaceOpen(black_turn);
    println("black_turn: "+black_turn);
    isGameOver = false;
  }
  
  public void keyPressed(int key){
    if(key == ' '){
      undo();
    }
    if (key == 'r'){
      reset();
    }
    if(key == 'a'){
      println("--analysis--");
      println("game phase: "+gamePhase);
      println("black turn: "+black_turn);
    }
  }
  // mouse event
  public void mousePressed(int mx, int my){
    if(isOpponentAi && ai.isMyTurn)return;
    // put stones on the field
    // whether mouse click is in valid area 
    if(field.fieldPos[0][0].x-SIZE/2 < mx 
      && mx < field.fieldPos[NUM_SIDE-1][0].x+SIZE/2
      && field.fieldPos[0][0].y-SIZE/2 < my
      && my < field.fieldPos[0][NUM_SIDE-1].y+SIZE/2){
      
      // convert mouse position to index of square
    int x = (mouseX-SIZE)/SIZE;
    int y = (mouseY-SIZE)/SIZE;

      // put stone on x, y
      putStone(x, y);
    }
  }

  // reverse stones
  private void returnStones(int _x, int _y){
    // check all direction
    for(int i = -1; i < 2; i++){
      for(int j = -1; j < 2; j++){
        if(i == 0 && j==0)
          continue;
        if(field.isOpenDir[_x][_y][i+1][j+1])
          returnStones(_x, _y, black_turn, i, j, true);
      }
    }
  }

  // recursion method to reverse stones
  private void returnStones(int _x, int _y, boolean _bBlackTurn, int i, int j, boolean isFirstDetect){
    boolean bBlackTurn = _bBlackTurn;
    int myColor = (_bBlackTurn)?BLACK:WHITE;
    int hisColor = (_bBlackTurn)?WHITE:BLACK;
    if(!isFirstDetect && field.field[_x][_y] == hisColor){
      // put stone
      field.field[_x][_y] = myColor;
      // trigger reverse animation
      stones.bAnimation[_x][_y] = true;
    }
    // if this stone is the same color as this player's color, end this method
    else if(!isFirstDetect && field.field[_x][_y] == myColor)
      return;
    // else, call myself again
    returnStones(_x+i, _y+j, _bBlackTurn, i, j, false);
  }

  // check whether each directions of all squares are available
  public void detectSpaceOpen(boolean black_turn){
    boolean BlackTurn = black_turn;
    for(int i = 0; i < NUM_SIDE; i++){
      for (int j = 0; j < NUM_SIDE; j++) {
        field.isOpen[i][j] = detectSpaceOpen(i, j, BlackTurn);
      }
    }
  }

  // check whether each directions of a square are available
  private boolean detectSpaceOpen(int _x, int _y, boolean _BlackTurn){
    //if this square is empty, return false
    if(field.field[_x][_y] != NONE)
      return false;
    boolean BlackTurn = _BlackTurn;
    boolean bValid = false;
    // check all directions
    for(int i = -1; i < 2; i++){
      for(int j = -1; j < 2; j++){
        if(i==0 && j==0)
          continue;
        boolean bTemp = detectSpaceOpen(_x, _y, BlackTurn, i, j, true);
        field.isOpenDir[_x][_y][i+1][j+1] = false;
        if(bTemp)
          field.isOpenDir[_x][_y][1+i][1+j] = true;
        bValid |=  bTemp;
      }
    }
    return bValid;
  }

  // recursion method to find directions that stones can reverse
  private boolean detectSpaceOpen(int _x, int _y, boolean _BlackTurn, int dir_x, int dir_y, boolean isFirstDetect){
    // which color this turn is now
    int tempColor = (_BlackTurn)?BLACK:WHITE;
    // target index
    _x += dir_x;
    _y += dir_y;
    // if this target is out of board, return false
    if(_x<0 || NUM_SIDE-1<_x || _y<0 || NUM_SIDE-1<_y)
      return false;
    //if this target is empty, return false
    if(field.field[_x][_y] == NONE)
      return false;
    //if color whose is next to start stone is same, return false
    if(isFirstDetect && field.field[_x][_y]  == tempColor)
      return false;
    //if there is/are a/some stone/stones between stones which is same color, return true
    if(!isFirstDetect && field.field[_x][_y] == tempColor)
      return true;
    //if color of stone which is checked now is same color, call myself(recursion)
    return detectSpaceOpen(_x, _y, _BlackTurn, dir_x, dir_y, false);
  }
}
  private class Move{
    public PVector pos = new PVector();
    public Move(int x, int y){
      pos.x = x;
      pos.y = y;
    }
  }
  
  private class MoveValue {

    public float returnValue;
    public Move returnMove;

    public MoveValue() {
        returnValue = 0;
    }

    public MoveValue(float returnValue) {
        this.returnValue = returnValue;
    }

    public MoveValue(float returnValue, Move returnMove) {
        this.returnValue = returnValue;
        this.returnMove = returnMove;
    }

  }
public class PhaseBuffer  {
  int phase;
  boolean isPushed;
  int fieldBuffer[][];
  PVector putPosBuffer;
  int turnColor;
  
  public void setField(int field[][]) {
    fieldBuffer = field;
  }
  public void setPutPos(PVector pos) {
    putPosBuffer.set(pos);
  }

  public int[][] getField() {
    return fieldBuffer;
  }
  public PVector getPutPos() {
    return putPosBuffer;
  }
  
  
  public PhaseBuffer () {
    isPushed = false;
    fieldBuffer = new int[NUM_SIDE][NUM_SIDE];
    for(int i = 0; i < NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        fieldBuffer[i][j] = -1;
      }
    }
    putPosBuffer = new PVector(-1, -1);
    turnColor = NONE;
  }

  public PhaseBuffer(int[][] tempField, PVector lastPutPos, int tempColor) {
    fieldBuffer = tempField;
    putPosBuffer = lastPutPos;
    turnColor = tempColor;
  }

  public PhaseBuffer(int[][] tempField, PVector lastPutPos, boolean isBlackTurn) {
    int tempColor = (isBlackTurn)? BLACK:WHITE;
    fieldBuffer = tempField;
    putPosBuffer = lastPutPos;
    turnColor = tempColor;
  }
  public void save(int[][] tempField, int temp_x, int temp_y, boolean tempBlack) {
    fieldBuffer = tempField;
    putPosBuffer.set(temp_x, temp_y);
    turnColor = (tempBlack)? BLACK: WHITE;
  }
  public void save(PhaseBuffer tempStatus) {
    isPushed = true;
    fieldBuffer = tempStatus.fieldBuffer;
    putPosBuffer = tempStatus.putPosBuffer;
    turnColor = tempStatus.turnColor;
  }
  public void clear() {
    isPushed = false;
    for(int i = 0; i < NUM_SIDE; i++){
      for(int j = 0; j < NUM_SIDE; j++){
        fieldBuffer[i][j] = NONE;
      }
    }
    putPosBuffer.set(-1, -1);
    turnColor = NONE;
  }

}
// this class will show stones graphics 
public class Stones  {
  Field field;

  boolean[][] bAnimation = new boolean[NUM_SIDE][NUM_SIDE];
  int[][] animationTime = new int[NUM_SIDE][NUM_SIDE]; // process time of animation
  final int animationEndTime = 20; // duration of animation

  // constructor
  public Stones (Field field) {
    this.field = field;
    //initialize process time
    for (int[] at_1 : animationTime) {
      for (int at_2 : at_1) {
        at_2 = 0;  
      }
    }
  }

  // draw visuals
  public void draw() {
    // draw stones
    noStroke();
    // draw stones with gradation
    for(int i=0; i<NUM_SIDE; i++){
      for(int j=0; j<NUM_SIDE; j++){
        // animate reversing stones
        if(bAnimation[i][j])animateTurning(i, j);
        else {
          if(field.field[i][j]==BLACK){
                fill(0,30);
              }else if(field.field[i][j]==WHITE){
                fill(255,30);
              }
              for(int k = 1; k < STONE_SIZE; k++){ 
                if(field.field[i][j]!=NONE)
                  ellipse(field.fieldPos[i][j].x, field.fieldPos[i][j].y, k, k);
              }
            }
          }
        }
  }

  //animate a stone turning
  private void animateTurning(int _i, int _j){
    // for a rainy day
    if(!bAnimation[_i][_j])
      return;
    // return false, if empty
    if(field.field[_i][_j] == NONE)
      return;
    boolean isNextBlack = (field.field[_i][_j]==BLACK)?true:false;

    noStroke();
    // change color 
    if(isNextBlack){
      if(animationTime[_i][_j] < animationEndTime/2)
        fill(OTHELLO_WHITE, 30);
      else fill(OTHELLO_BLACK, 30);  
    }
    else if(!isNextBlack){
      if(animationTime[_i][_j] < animationEndTime/2)
        fill(OTHELLO_BLACK, 30);
      else fill(OTHELLO_WHITE, 30);
    }
    // draw turn
    for(int k = 0; k < STONE_SIZE; k++){
      pushMatrix();
      translate(field.fieldPos[_i][_j].x, field.fieldPos[_i][_j].y);
      rotate(-PI/6);
      ellipse(0, 0, (float)k*cos(PI*(float)animationTime[_i][_j]/(float)animationEndTime), k);  
      popMatrix();
    }
    // forward time
    animationTime[_i][_j]++;
    // finish animation when time is over
    if (animationTime[_i][_j] >= animationEndTime)endAnimation(_i, _j);
  }

  //end up turning animation, and this function called in only animateTurning()
  private void endAnimation(int _i, int _j){
    bAnimation[_i][_j] = false;
    animationTime[_i][_j] = 0;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Othello" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
