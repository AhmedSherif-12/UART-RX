module edge_bit_counter (
    input wire clk,
    input wire rst,
    input wire cnt_en,
    input wire [4:0] prescale,
    output reg [3:0] bit_cnt,
    output reg [4:0] edge_cnt

);
always @(posedge clk or negedge rst) 
    begin
        if (!rst) 
            begin
               edge_cnt<=0;
               bit_cnt<=0;
            end  
        else
            begin
                if (cnt_en)
                    begin
                        if(edge_cnt<prescale)
                            edge_cnt<=edge_cnt+1'b1;
                        else
                            begin
                                edge_cnt<=0;
                                bit_cnt<=bit_cnt+1;
                            end
                            
                    end
                else
                    begin
                        edge_cnt<=0;
                        bit_cnt<=0;
                    end

            end  
    end
endmodule