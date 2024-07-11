module sim_top();

reg rw;
reg [6:0] row;
reg [7:0] col;

reg [3:0] col_sel;
reg row_s;
reg col_s;

wire [7:0] out;
reg [7:0] test_val;

mem_row #(.col_count(4))rows(
  .rw(rw),
  .row(row_s),
  .col_sel(col_sel),
  .d_in(test_val),
  .d_out(out)
);

s_mem mem(
  .rw(rw),
  .word_offset(col),
  .seg_select(row),
  .d_in(test_val),
  .d_out(out)
  );

mem_cell m0(
  .col(col_s),
  .row(row_s),
  .rw(rw),
  .d_in(test_val),
  .d_out(out)
  );

task test_cell();
  begin
      col_s <= 0;
      row_s <= 0;
      rw    <= 0;
    $display("Sram cell test");
    #20;
    $display($time, " rw=%b, col=%h, row=%h, d_in=%h, d_out=%h",
      rw, col_s, row_s, test_val, out);
      test_val <= 8'hcd;
      col_s <= 1;
      row_s <= 1;
      rw    <= 1;
    #20;
    $display($time, " rw=%b, col=%h, row=%h, d_in=%h, d_out=%h",
      rw, col_s, row_s, test_val, out);
      col_s <= 0;
      row_s <= 0;
      rw    <= 1;
    #20;
    $display($time, " rw=%b, col=%h, row=%h, d_in=%h, d_out=%h",
      rw, col_s, row_s, test_val, out);
      col_s <= 1;
      row_s <= 1;
      rw    <= 0;
    #20;
      $display($time, " rw=%b, col=%h, row=%h, d_in=%h, d_out=%h",
        rw, col_s, row_s, test_val, out);
      col_s <= 0;
      row_s <= 0;
    #20;
      $display($time, " rw=%b, col=%h, row=%h, d_in=%h, d_out=%h",
        rw, col_s, row_s, test_val, out);
      col_s <= 1;
      row_s <= 1;
      rw    <= 1;
    #20;
      $display($time, " rw=%b, col=%h, row=%h, d_in=%h, d_out=%h",
        rw, col_s, row_s, test_val, out);
  end
endtask

task test_row();
  begin
    $display("Sram row test");
    $display($time, " rw=%b, col=%7b, row=%h, d_in=%h, d_out=%h",
      rw, col_sel, row_s, test_val, out);
      rw <= 1'b1;
      row_s <= 1'b1;
      col_sel[2] <= 1'b1;
    #20;
    $display($time, " rw=%b, col=%7b, row=%h, d_in=%h, d_out=%h",
      rw, col_sel, row_s, test_val, out);
      row_s <= 1'b0;
      col_sel[2] <= 1'b0;
    #20;
    $display($time, " rw=%b, col=%7b, row=%h, d_in=%h, d_out=%h",
      rw, col_sel, row_s, test_val, out);
      test_val <= 8'hd0;
      rw <= 1'b0;
      row_s <= 1'b1;
      col_sel[2] <= 1'b1;
    #20; 
    $display($time, " rw=%b, col=%7b, row=%h, d_in=%h, d_out=%h",
      rw, col_sel, row_s, test_val, out);
      rw <= 1'b1;
      row_s <= 1'b1;
      col_sel[2] <= 1'b1;
    #20;
    $display($time, " rw=%b, col=%7b, row=%h, d_in=%h, d_out=%h",
      rw, col_sel, row_s, test_val, out);
  end
endtask

task test_sram();
  begin
    $display("Sram test");
    #20;
      test_val <= 8'hb2;
      rw <= 1'b1;
      row <= 7'b1100101;
      col <= 8'b11001010;
    #20;
    $display($time, " rw=%b, col=%h, row=%h, d_in=%h, d_out=%h",
      rw, col, row, test_val, out);
      row <= 7'b1100111;
      col <= 8'b11001010;
      rw <= 1'b0;
    #20;
    $display($time, " rw=%b, col=%h, row=%h, d_in=%h, d_out=%h",
      rw, col, row, test_val, out);
      row <= 7'b1100101;
      col <= 8'b11001010;
      rw <= 1'b1;
    #20;
    $display($time, " rw=%b, col=%h, row=%h, d_in=%h, d_out=%h",
      rw, col, row, test_val, out);
      row <= 7'b1100000;
      col <= 8'b11001010;
    #20; 
    $display($time, " rw=%b, col=%h, row=%h, d_in=%h, d_out=%h",
      rw, col, row, test_val, out);
      row <= 7'b1100101;
      col <= 8'b11001010;
      rw <= 1'b1;
    #20; 
    $display($time, " rw=%b, col=%h, row=%h, d_in=%h, d_out=%h",
      rw, col, row, test_val, out);
  end
endtask

initial begin
  test_cell();
  test_row();
  test_sram();
end

endmodule
