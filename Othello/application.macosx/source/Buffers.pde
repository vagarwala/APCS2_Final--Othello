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