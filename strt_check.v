module strt_check (
    input wire strt_check_en,
    input wire sampled_bit,

    output reg strt_glitch

);


always @(*) 
    begin
        
       // data<=0;
        if (strt_check_en)
            if(sampled_bit==0)    
                strt_glitch<=0;
            else
                strt_glitch<=1'b1;
        else
           strt_glitch<=strt_glitch;
    end
endmodule