// this class does all the things
public class Manager  {
  int t;
  int gamePhase = 0;

  Field field;
  Stones stones;

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
        
  }

  // constructor for playing with AI opponent
  public Manager(boolean isOpponentBlack) {
  }

  //this method have to called in main draw()
  public void update(int global_t) {
  }

  //if at least one square is available, return true
  public boolean isThereOpen(){
  }

  //return the number of squares where is stones put
  public int getStonePut() {
  }

  //return now score
  public PVector getScores() {
    //x element is black score, y is white score
  }

  //put stone
  public void putStone(int x, int y) {
    // you cannot play if animation is run
  }

  private void undo() {
  }
  public void keyPressed(int key){
    if(key == ' '){
      this.undo();
    }
    if(key == 'a'){
      println("--analysis--");
      println("game phase: "+this.gamePhase);
      println("black turn: "+this.black_turn);
    }
  }
  // mouse event
  public void mousePressed(int mx, int my){
  }

  // reverse stones
  private void returnStones(int _x, int _y){
    // check all direction
  }

  // recursion method to reverse stones
  private void returnStones(int _x, int _y, boolean _bBlackTurn, int i, int j, boolean isFirstDetect){
  }

  // check whether each directions of all squares are available
  public void detectSpaceOpen(boolean black_turn){
    boolean bBlackTurn = black_turn;
    for(int i = 0; i < NUM_SIDE; i++){
      for (int j = 0; j < NUM_SIDE; j++) {
        this.field.isOpen[i][j] = this.detectSpaceOpen(i, j, bBlackTurn);
      }
    }
  }

  // check whether each directions of a square are available
  private boolean detectSpaceOpen(int _x, int _y, boolean _bBlackTurn){
    //if this square is empty, return false
    if(this.field.field[_x][_y] != NONE)return false;
    boolean bBlackTurn = _bBlackTurn;
    boolean bValid = false;
    // check all directions
    for(int i = -1; i < 2; i++){
      for(int j = -1; j < 2; j++){
        if(i==0 && j==0)continue;
        boolean bTemp = this.detectSpaceOpen(_x, _y, bBlackTurn, i, j, true);
        this.field.isOpenDir[_x][_y][i+1][j+1] = false;
        if(bTemp)this.field.isOpenDir[_x][_y][1+i][1+j] = true;
        bValid |=  bTemp;
      }
    }
    return bValid;
  }

  // recursion method to find directions that stones can reverse
  private boolean detectSpaceOpen(int _x, int _y, boolean _bBlackTurn, int dir_x, int dir_y, boolean isFirstDetect){
    // which color this turn is now
    int tempColor = (_bBlackTurn)?BLACK:WHITE;
    // target index
    _x += dir_x;
    _y += dir_y;
    // if this target is out of board, return false
    if(_x<0 || NUM_SIDE-1<_x || _y<0 || NUM_SIDE-1<_y)return false;
    //if this target is empty, return false
    if(this.field.field[_x][_y] == NONE)return false;
    //if color whose is next to start stone is same, return false
    if(isFirstDetect && this.field.field[_x][_y]  == tempColor)return false;
    //if there is/are a/some stone/stones between stones which is same color, return true
    if(!isFirstDetect && this.field.field[_x][_y] == tempColor)return true;
    //if color of stone which is checked now is same color, call myself(recursion)
    return this.detectSpaceOpen(_x, _y, _bBlackTurn, dir_x, dir_y, false);
  }
}