public class PhaseBuffer  {
  int phase;
  boolean isPushed;
  int fieldBuffer[][];
  PVector putPosBuffer;
  int turnColor;
  
  public void setField(int field[][]) {
    this.fieldBuffer = field;
  }
  public void setPutPos(PVector pos) {
    this.putPosBuffer.set(pos);
  }

  public int[][] getField() {
    return this.fieldBuffer;
  }
  public PVector getPutPos() {
    return this.putPosBuffer;
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