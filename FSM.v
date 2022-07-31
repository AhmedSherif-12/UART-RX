module FSM (
    input wire clk,
    input wire RST,
    input wire RX_IN,
    input wire [3:0] bit_cnt,
    input wire [4:0] edge_cnt,
    input wire PAR_EN,
    input wire par_err,
    input wire strt_glitch,
    input wire stp_err,
    input wire [4:0] prescale,

    output reg par_chk_en,
    output reg strt_chk_en,
    output reg stp_chk_en,
    output reg deser_en,
    output reg counter_en,
    output reg data_samp_en,
    output reg data_valid

);

localparam IDLE   =  3'b0,
           start  =  3'b001,
           data   =  3'b010,
           parity =  3'b011,
           stop   =  3'b100,
           valid  =  3'b101;

reg [2:0] state;
reg [2:0] next_state;

always @(posedge clk or negedge RST) 
    begin
        if (!RST) 
            state<=IDLE;
        else
            state<=next_state;
    end


always @(*) 
    begin
        case (state)
            IDLE:
                begin
                    par_chk_en<=0;
                    strt_chk_en<=0;
                    stp_chk_en<=0;
                    data_valid<=0;
                    deser_en<=0;
                    counter_en<=0;
                    data_samp_en<=0;
                    if (!RX_IN) 
                        next_state<=start;
                    else
                        next_state<=IDLE;
                end
            start:
                begin
                    par_chk_en<=0;
                    strt_chk_en<=1;
                    stp_chk_en<=0;
                    deser_en<=1'b1;
                    data_valid<=0;
                    counter_en<=1;
                    data_samp_en<=1;

                    if (bit_cnt==1) 
                        next_state<=start;
                    else
                        next_state<=IDLE;
                end
            data:
                begin
                    par_chk_en<=1;
                    strt_chk_en<=0;
                    stp_chk_en<=0;
                    deser_en<=1'b1;
                    data_valid<=0;
                    counter_en<=1;
                    data_samp_en<=1; 

                    if (bit_cnt==9) 
                        if(PAR_EN)
                            next_state<=parity;
                        else
                            next_state<=stop;
                    else
                        next_state<=data;
                end
                parity:
                    begin
                        par_chk_en<=1;
                        strt_chk_en<=0;
                        stp_chk_en<=0;
                        deser_en<=1'b1;
                        data_valid<=0;
                        counter_en<=1;
                        data_samp_en<=1;

                        if(bit_cnt==10)
                            next_state<=stop;
                        else
                            next_state<=parity;
                    end
                stop:
                    begin
                        par_chk_en<=0;
                        strt_chk_en<=0;
                        stp_chk_en<=1;
                        deser_en<=1'b1;
                        data_valid<=0;
                        counter_en<=1;
                        data_samp_en<=1;

                        if(PAR_EN)
                            begin
                                if(bit_cnt==11)
                                    next_state<=valid;
                                else
                                    next_state<=stop;
                            end
                        else
                            begin
                                if(bit_cnt==10)
                                    next_state<=valid;
                                else
                                    next_state<=stop;
                            end
                    end

                valid:
                    begin
                       par_chk_en<=0;
                       strt_chk_en<=0;
                       stp_chk_en<=0;
                       deser_en<=1'b0;
                       counter_en<=0;
                       data_samp_en<=0;

                        if(par_chk_en || strt_glitch || stp_err)
                            begin
                                data_valid<=0;
                                next_state<=IDLE;
                            end
                        else
                            begin
                                data_valid<=1;
                            end
                    end
                    endcase
    end


endmodule