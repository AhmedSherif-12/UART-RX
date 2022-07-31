module stp_check (
    input wire stp_check_en,
    input wire sampled_bit,

    output reg stp_glitch

);


always @(*) 
    begin
        
       // data<=0;
        if (stp_check_en)
            if(sampled_bit==1)    
                stp_glitch<=0;
            else
                stp_glitch<=1'b1;
        else
           stp_glitch<=stp_glitch;
    end
endmodule