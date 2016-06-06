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