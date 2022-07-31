module parity_check (
    input wire par_chk_en,
    input wire PAR_TYP,
    input wire sampled_bit,
    output reg par_err

);
    
reg [8:0] data;
always @(*) 
    begin
        
       // data<=0;
        if (par_chk_en)
            data<={sampled_bit,data};
        else

             if (PAR_TYP==0) 
                    par_err=((^data[7:0])==data[8]) ? 1'b0:1'b1;
            else
                    par_err=((~(^data[7:0]))==data[8]) ? 1'b0:1'b1;
           // data<=0;
    end
endmodule