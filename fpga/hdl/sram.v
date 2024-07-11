module sel
  #(parameter in_bits=8,
    parameter out_bits=256
  )
  ( input wire [in_bits-1:0] in,
    output reg [out_bits-1:0] out
  );

reg [in_bits-1:0] last_sel;

integer i;

initial begin
  for(i=0; i<out_bits; i = i + 1)begin
    out[i] <= 1'b0;
  end

  last_sel <= 8'h00;
end

always @(last_sel != in)
begin
  for(i=0; i<out_bits; i = i + 1)begin
    out[i] <= 1'b0;
  end
  
  out[in] <= 1'b1;
  last_sel <= in;
end
     
endmodule

module mem_cell
  #(  parameter def_val = 8'h00 )
  (input wire col,
  input wire row,
  input wire rw,
  input  [7:0] d_in,
  output reg [7:0] d_out
  );

reg [7:0] val;

initial begin
  val <= def_val;
end

always @(*)
begin
  if(col & row) begin
    if(rw)
      d_out <= val;   // read bit
    if(!rw)
      val <= d_in;    // write bit
  end else begin
    d_out <= 8'hzz;
  end
end

endmodule

module mem_row
  #( parameter col_count = 256)
  ( input wire row,
    input wire rw,
    input [col_count-1:0] col_sel,
    input wire [7:0] d_in,
    output wire [7:0] d_out
  );

generate
  genvar i;

  for(i=0;  i<col_count; i=i+1) begin
    mem_cell cols (
      .col(col_sel[i]),
      .row(row),
      .rw(rw),
      .d_in(d_in),
      .d_out(d_out)
      );
  end

endgenerate

endmodule

module s_mem
  #(parameter row_count=128,
    parameter row_bits =7,
    parameter col_count=256,
    parameter col_bits =8
  )
  ( input wire rw,
    input wire [col_bits-1:0] word_offset,
    input wire [row_bits-1:0] seg_select,
    input wire [7:0]          d_in,
    output wire [7:0]         d_out
  );

wire [col_count-1:0] col_addr;
wire [row_count-1:0] row_addr;

sel #(.in_bits(col_bits), .out_bits(col_count)) col_sel 
  (.in(word_offset),
    .out(col_addr)
  );

sel #(.in_bits(row_bits), .out_bits(row_count)) row_sel 
  (.in(seg_select),
    .out(row_addr)
  );

generate
  genvar i;
  for(i=0; i<row_count; i=i+1) begin
    mem_row #(.col_count(col_count)) rows (
      .row(row_addr[i]),
      .rw(rw),
      .col_sel(col_addr),
      .d_in(d_in),
      .d_out(d_out)
      );
  end
endgenerate

endmodule
