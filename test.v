module test (
   input wire clk,
   input wire rst,
   input wire [4:0] prescale,
   input wire data_samp_en,
   input wire cnt_en,
   input wire RX_IN,

   output wire sampled_bit
);
    
wire [4:0] edge_cnt;
wire [3:0] bit_cnt;


edge_bit_counter c1(

    .clk(clk),
    .rst(rst),
    .cnt_en(cnt_en),
    .prescale(prescale),
    .bit_cnt(bit_cnt),
    .edge_cnt(edge_cnt)
);

data_sampling ds(
    .clk(clk),
    .rst(rst),
    .RX_IN(RX_IN),
    .prescale(prescale),
    .edge_cnt(edge_cnt),
    .data_samp_en(data_samp_en),
    .sampled_bit(sampled_bit)

);


endmodule