module sim_top();

wire scl, sda;
reg scl_b, sda_b, out_en;
assign scl = scl_b;
assign sda = out_en ? sda_b : 1'bz;

i2c isq(.sda(sda),.scl(scl));

task automatic start_i2c();
  begin
    out_en    <= 1'b1;
    scl_b     <= 1'b1;
    sda_b     <= 1'b1;
    #5;
  
    sda_b     <= 1'b0;
    #5;
  end
endtask

task automatic write_i2c(reg [7:0]addr, reg[7:0] data);
  integer i;
  begin
    out_en <= 1'b1;
    for(i=0; i<8; i=i+1)begin
      scl_b <= 1'b0;
      sda_b <= addr[7-i];
      #10;

      scl_b <= 1'b1;
      #10;
    end

    scl_b   <= 1'b0;
    out_en  <= 1'b0;
    #10;

    scl_b <= 1'b1;
    #10;

    for(i=0; i<8; i=i+1)begin
      scl_b <= 1'b0;
      sda_b <= data[7-i];
      out_en  <= 1'b1;
      #10;

      scl_b <= 1'b1;
      #10;
    end

    scl_b   <= 1'b1;
    #10;

    scl_b <= 1'b0;
    out_en  <= 1'b0;
    #10;
  end
endtask

task automatic read_i2c(reg [7:0]addr, integer count);
  integer i,j;
  reg [7:0] data;

  begin

    $display("count:%h", count);
    
    for(i=0; i<8; i=i+1)begin
      scl_b <= 1'b0;
      sda_b <= addr[7-i];
      #10;

      scl_b <= 1'b1;
      #10;
    end

    scl_b <= 1'b0;
    sda_b <= 1'b0;
    #10;

    scl_b <= 1'b1;
    #10;
    out_en <= 1'b0;

    for(j=0; j<count-1; j=j+1) begin
      out_en  <= 1'b0;

      for(i=0; i<8; i=i+1)begin
        scl_b <= 1'b0;
        #10;

        scl_b <= 1'b1;
        data[7-i] = sda;
        #10;
      end
      $display("data:%h",data);

      scl_b   <= 1'b0;
      sda_b   <= 1'b0;
      out_en  <= 1'b1;
      #10;

      scl_b   <= 1'b1;
      #10;
    end

    out_en  <= 1'b0;

    for(i=0; i<8; i=i+1)begin
      scl_b <= 1'b0;
      #10;

      scl_b <= 1'b1;
      data[7-i] = sda;
      #10;
    end
    $display("data:%h",data);


    scl_b   <= 1'b0;
    sda_b   <= 1'b1;
    out_en  <= 1'b1;
    #10;

    scl_b   <= 1'b1;
    #10;
    out_en  <= 1'b0;
  end
endtask

task test_i2c();
  begin
    start_i2c();
    write_i2c(8'h60, 8'hcc);
    start_i2c();
    read_i2c(8'ha1, 4);
  end
endtask

initial begin
  $monitor($time, " sda:%b, scl:%b, out_en:%b", sda, scl, out_en);
  test_i2c();
end

endmodule
