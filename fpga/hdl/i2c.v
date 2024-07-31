module i2c(
  inout sda,
  input scl
);

reg out;
reg out_en;

localparam idle         = 3'b000;
localparam addr         = 3'b001;
localparam read         = 3'b010;
localparam write_seg    = 3'b011;
localparam write_off    = 3'b100;

reg [2:0] cur_state, next_state;

reg [4:0] count;

reg [7:0] in_buf, out_buf;

reg [7:0] seg_ptr, word_off;

wire [7:0] out_w;

reg rw;

reg [7:0] data [255:0] [255:0];

assign out_w = out_buf;

task init_sram();
  integer i,j;

  begin
    for(i=0; i<256; i=i+1) begin
      for(j=0; j<256; j=j+1) begin
        if( j%2 == 0 ) begin
          data[i][j] <= 8'h55;
        end else begin
          data[i][j] <= 8'haa;
        end
      end
    end
  end
endtask

task init_data();
  begin
    cur_state     <= idle;
    next_state    <= idle;
    seg_ptr       <= 8'h00;
    word_off      <= 8'h00;
    count         <= 4'b0000;
    out           <= 1'b0;
    out_en        <= 1'b0;
  end
endtask

assign sda = out_en ? out : 1'bz;

initial begin
  init_sram();
  init_data();
  rw <= 0;
end

always @(negedge sda) begin
  if ( scl ) begin
    next_state  <= addr;
    out_en      <= 1'b0;
  end

end

always @(posedge sda) begin
  if ( scl ) begin
    init_data();
    next_state <= idle;
  end

end

always @(negedge scl) begin
  cur_state   = next_state;

  if(cur_state == read) begin
    if(count <= 4'b0111) begin
      out_en <= 1'b1;
      out    <= out_w[7 - count];
    end else begin 
      out_en <= 1'b0;
    end
  end else if(cur_state != idle) begin
    if(count == 4'b1000) begin
      out_en    <= 1'b1;
      out       <= 1'b0;
    end else begin
      out_en    <= 1'b0;
    end
  end
end

always @(posedge scl) begin
  case( cur_state )
    addr       : begin
      if(count <= 4'b0111) begin
        in_buf[7 - count]   <= sda;
        count                = count + 1;

      end else begin
        if( in_buf == 8'h60 ) begin
          next_state <= write_seg;
        end

        if( in_buf == 8'ha0 ) begin
          next_state <= write_off;
        end

        if( in_buf == 8'ha1 ) begin
          next_state <= read;
          out_buf    <= data[seg_ptr][word_off];
        end

        count = 0;
      end
    end

    write_seg  : begin
      if(count <= 4'b0111) begin
        in_buf[7 - count]   <= sda;
        count           = count + 1;
      end else begin
        out_en     <= 1'b0;
        seg_ptr    <= in_buf;
        count      <= 4'b0000;
        next_state <= idle;
      end
    end

    write_off  : begin
      if(count <= 4'b0111) begin
        in_buf[7 - count]   <= sda;
        count           = count + 1;
      end else begin
        word_off        <= in_buf;
        count           <= 4'b0000;
        out_en          <= 1'b0;
        next_state      <= idle;
      end
    end

    read       : begin
      if ( count <= 4'b0111 ) begin
        count = count + 1;
      end else begin
        if( !sda ) begin
          count     <= 4'b0000; 
          word_off  = word_off + 1;
          out_buf   <= data[seg_ptr][word_off];
        end else begin
          init_data();
        end
      end
    end

    idle        : begin
      out_en <= 1'b0;
    end

  endcase
end

endmodule
