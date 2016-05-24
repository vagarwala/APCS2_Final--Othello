import java.util.Date;
class CSVExporter{
  String[] keys = {"id", "player1", "player2", "winner"};
  Table table = loadTable("gamedata.csv", "header");
  public void addValues(int p1, int p2, int winner){
    TableRow newRow = this.table.addRow();
    newRow.setInt(this.keys[0], this.table.getRowCount()-1);
    newRow.setInt(this.keys[1], p1);
    newRow.setInt(this.keys[2], p2);
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
    newRow.setString(this.keys[3], winnerName);
    saveTable(this.table, "data/gamedata.csv");
  }
}