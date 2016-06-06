# APCS2_Final--Othello

Repository containing files for Vandana Agarwala's APCS Final Project - an implementation of the game Othello.  User vs. AI.  
In order to play:   
- open APCS/MKS22X/Final Project/Othello
- open Othello.pde
- Press the 'play' button to run.
- While you are playing, you are black and you play first.  The spots you have available to you will be indicated by a gently flashing red light.  Clicking on the tile you would like to place a disk allows you to play there.
- At the top, you can see whose turn it is, the current scores, and the margin of difference from your point of view (e.g. "losing by 3").  The game will tell you when you are forced to pass and the screen will change when the game is over.
- Note that there is a glitch: when one player passes, you must click the screen one more time before it shows you your available positions and you can play again.
- 

Team Name: Order From Chaos  
Project Name: Othello  

Project Plan/Outline:  
- implement minimax (?) algorithm for AI
- demo version should be working fairly well
- final version should work well and look nice and beat my family members :))  
Goals for Demo/Final version:
- working version, looking decent
- small kinks are acceptable
- GUI and edge cases can be improved & fixed between demo and final
- saving previous versions (for undo functionality)  can be implemented after demo version if I don't have time before then.  
Specific plan (Files):
- Othello.pde: basically a wrapper class for Manager.
- Manager.pde: does all the legwork
- Ai.pde: figure out the best move
- PhaseBuffer.pde: saving this particular configuration of the game
- Buffers.pde: saving all the previous states (for undo button)
- CSVExporter.pde: saving results of each game played to a spreadsheet
- Easing.pde: things will look nice.  e.g. open spots will kind of flash
- Field.pde: board graphics.
- Indicator.pde: indicates whose turn it is.  Also, will put a frame over the screen for things like the winner and when one player is forced to pass.
- Stones.pde: The stones themselves will look nice
  
- misc thoughts/how stuff works will go in Musings.rtf as they come

Development Log:  
5/11/16: ... created repo  
5/12/16: I am now familiar with the game :P  
5/14/16: Stones.pde, Field.pde, Othello.pde finished.  Started Manager.pde.  When I figure out how to actually make the AI, I know my black and white stones will flip as desired and the board will look nice. :P  
5/15/16: I made a plan.  The plan is detailed above.  
5/16/16: Code backbones done.  Time for the real work to begin :P  
5/17/16: AI planned out, time to start coding it. But tonight I'm studying for APUSH and sleeping :P  
5/18/16: Coded the first component -- efficiency of move.  
5/19/16: haha physics will be my death what is this I understand everything but the test is still hard and I don't even know why  
5/20/16: putStone function almost completed  
5/21/16: completed putStone  
5/22/16: hi sorry I forgot to commit and push this ever but this is a working demo version although quite undeveloped...  
5/23/16: Completed PhaseBuffer and Buffer.  There was a lot of downtime at the concert.  
5/24/16: Completed CSVExporter and undo() and reset(); very easy.  Okay now I really need to get on that AI....  
5/25/16 - 5/26/16: finished my original AI plan... more on that in Musings.rtf.  
5/26/16: implemented Mr. Brooks' suggestions (UI-related), mostly about score reporting and board obscuring things.  
5/27/16: implemented Mr. Brooks' additional UI suggestions  
5/28/16-5/30-16: I'M SORRY I DIDN'T WORK OVER MEMORIAL DAY WEEKEND I LITERALLY DID NO WORK ON ANYTHING :(  
5/31/16 - 6/1/16: considered doing a machine-learning type algorithm because I'm really not motivated to start writing my minimax algorithm but now I'm actually going to start.  
6/2/16: started writing minimax algorithm
6/3/16: finished writing my first minimax algorithm but it seems to be exploring one branch fully down to the depth, deciding the game is over, and being like yay i win! so idk  
6/4/16: ARML :)  
6/5/16: still not sure why my first minimax doesn't work????  
6/6/16: trying again, just rewriting