module data_sampling (
    input wire clk,
    input wire rst,
    input wire RX_IN,
    input wire [4:0] prescale,
    input wire [4:0] edge_cnt,
    input wire data_samp_en,

    output reg sampled_bit

);
reg [2:0] data; // for storing samples

always @(posedge clk or negedge rst) 
    begin
        if (!rst)
            begin
                sampled_bit<=0;
                data<=0;

            end
        else
            begin
                if(data_samp_en)
                    begin
                        if(edge_cnt==((prescale>>1)-1) || edge_cnt==((prescale>>1)) || edge_cnt==((prescale>>1)+1) )
                            data<={data,RX_IN};
                        else
                            begin
                                data<=data;
                                if (edge_cnt>((prescale>>1)+1)) 
                                    begin
                                        case (data)
                                          3'b000:
                                            sampled_bit<=1'b0;
                                          3'b001:
                                            sampled_bit<=1'b0;    
                                          3'b010:
                                            sampled_bit<=1'b0;
                                          3'b011:
                                            sampled_bit<=1'b1;
                                          3'b100:
                                            sampled_bit<=1'b0;
                                          3'b101:
                                            sampled_bit<=1'b1;
                                          3'b110:
                                            sampled_bit<=1'b1;
                                          3'b111:
                                            sampled_bit<=1'b1;
                                        endcase 
                                    end
                                else
                                    begin
                                        sampled_bit<=0;
                                        data<=0;  
                                    end
                            end
                    end
                
                else
                    begin
                        sampled_bit<=0;
                        data<=0;

                    end
                    
            end
    end


endmodule