# APCS2_Final--Othello

Repository containing files for Vandana Agarwala's APCS Final Project - an implementation of the game Othello.  User vs. AI.  
In order to run:   

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

- misc thoughts/how stuff works will go in Musings.txt as they come

Development Log:  
5/11/16: ... created repo  
5/12/16: I am now familiar with the game :P  
5/14/16: Stones.pde, Field.pde, Othello.pde finished.  Started Manager.pde.  When I figure out how to actually make the AI, I know my black and white stones will flip as desired and the board will look nice. :P  
5/15/16: I made a plan.  The plan is detailed above.
5/16/16: Code backbones done.  Time for the real work to begin :P
