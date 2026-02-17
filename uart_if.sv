interface uart_if(input bit clk);
    logic rst;
    logic rx;
    logic tx;
    logic [7:0] dintx;
    logic newd;
    logic [7:0] doutrx;
    logic donetx;
    logic donerx;

    logic uclktx;
    logic uclkrx;
endinterface
