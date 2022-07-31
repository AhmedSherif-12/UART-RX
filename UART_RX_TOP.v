module UART_RX_TOP (
    input wire clk,
    input wire rst,

    input wire RX_IN,
    input wire PAR_EN,
    input wire PAR_TYP,
    input wire [4:0] prescale,
    output wire data_valid,
    output wire P_data

);

wire sampled_bit;
wire strt_glitch;
wire par_err;
wire stp_glitch;

wire strt_check_en;
wire stp_check_en;
wire par_chk_en;
wire cnt_en;
wire deser_en;

wire [3:0] bit_cnt;
wire [4:0] edge_cnt;

wire data_samp_en;

strt_check strt(

    .strt_check_en(strt_check_en),
    .sampled_bit(sampled_bit),
    .strt_glitch(strt_glitch)
);

stp_check stp(

    .stp_check_en(stp_check_en),
    .sampled_bit(sampled_bit),
    .stp_glitch(stp_glitch)
);

parity_check parity (

    .par_chk_en(par_chk_en),
    .PAR_TYP(PAR_TYP),
    .sampled_bit(sampled_bit),
    .par_err(par_err)

);
edge_bit_counter cntr(

    .clk(clk),
    .rst(rst),
    .cnt_en(cnt_en),
    .prescale(prescale),
    .bit_cnt(bit_cnt),
    .edge_cnt(edge_cnt)
);

FSM fsm(

    .clk(clk),
    .RST(rst),
    .RX_IN(RX_IN),
    .bit_cnt(bit_cnt),
    .edge_cnt(edge_cnt),
    .PAR_EN(PAR_EN),
    .par_err(par_err),
    .strt_glitch(strt_glitch),
    .stp_err(stp_err),
    .prescale(prescale),
    .par_chk_en(par_chk_en),
    .strt_chk_en(strt_chk_en),
    .stp_chk_en(stp_chk_en),
    .deser_en(deser_en),
    .counter_en(cnt_en),
    .data_samp_en(data_samp_en),
    .data_valid(data_valid)

);





endmodule