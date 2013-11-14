public void createLogTable() {
  table = new Table();
  table.addColumn("inputData", Table.INT);
  table.addColumn("inputDataSigned", Table.FLOAT);
  table.addColumn("yAcceleration[0]", Table.FLOAT);
  table.addColumn("yStartSpeed[0]", Table.FLOAT);
  table.addColumn("red_box_y", Table.FLOAT);
}

public void addTableRow() {
  TableRow row = table.addRow();
  // Set the values of that row
  row.setInt("axis_input[0]", inputData[0]);
  row.setFloat("axis_input_signed[0]", inputDataSigned[0]);
  row.setFloat("yAcceleration[0]", yAcceleration[0]);
  row.setFloat("yStartSpeed[0]", yStartSpeed[0]);
  row.setFloat("red_box_y", red_box_y);
}

