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
  final color frostedCoverColor = color(180, 150);
  
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
      textSize(SIZE*.6);
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
      stroke(#ff0000);
      strokeWeight(2);
      fill(#ff0000, 30);
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
      fill(#000088);
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
      rect(0, 0, SIZE, 3.5*SIZE);
      rect(width-SIZE, 0, SIZE, 3.5*SIZE);
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
      fill(#ff0000);
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