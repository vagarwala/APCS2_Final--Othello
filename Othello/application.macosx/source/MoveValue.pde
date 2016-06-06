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