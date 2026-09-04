`timescale 1ns/1ps

module apb_master_tb;

    reg CLK;
    reg RST;

    reg PSEL;
    reg PENABLE;
    reg PWRITE;

    reg [31:0] PADDR;
    reg [31:0] PWDATA;

    wire [31:0] PRDATA;
    wire PREADY;
    wire PSLVERR;

    
    // 1. DUT
   
    apb_slave dut (
        .CLK     (CLK),
        .RST     (RST),
        .PSEL    (PSEL),
        .PENABLE (PENABLE),
        .PWRITE  (PWRITE),
        .PADDR   (PADDR),
        .PWDATA  (PWDATA),
        .PRDATA  (PRDATA),
        .PREADY  (PREADY),
        .PSLVERR (PSLVERR)
    );



    // 2. CLOCK
   
    always #5 CLK = ~CLK;
    
    
    // 3. TEST
    

    initial
    begin

        // INITIAL VALUES
        CLK     = 0;
        RST     = 0;

        PSEL    = 0;
        PENABLE = 0;
        PWRITE  = 0;
        PADDR   = 0;
        PWDATA  = 0;

        // RESET
       
        #12;
        RST = 1;
        
        // WRITE REG0
        
        PSEL    = 1;
        PENABLE = 0;
        PWRITE  = 1;
        PADDR   = 32'h00;
        PWDATA  = 32'h11111111;

        #10;

        PENABLE = 1;

        #10;

        PSEL    = 0;
        PENABLE = 0;
        PWRITE  = 0;

        // WRITE REG1
        
        PSEL    = 1;
        PENABLE = 0;
        PWRITE  = 1;
        PADDR   = 32'h04;
        PWDATA  = 32'h22222222;

        #10;

        PENABLE = 1;

        #10;

        PSEL    = 0;
        PENABLE = 0;
        PWRITE  = 0;

        // WRITE REG2
        
        PSEL    = 1;
        PENABLE = 0;
        PWRITE  = 1;
        PADDR   = 32'h08;
        PWDATA  = 32'h33333333;

        #10;

        PENABLE = 1;

        #10;

        PSEL    = 0;
        PENABLE = 0;
        PWRITE  = 0;
        
        // WRITE REG3
        
        PSEL    = 1;
        PENABLE = 0;
        PWRITE  = 1;
        PADDR   = 32'h0C;
        PWDATA  = 32'h44444444;

        #10;

        PENABLE = 1;

        #10;

        PSEL    = 0;
        PENABLE = 0;
        PWRITE  = 0;

        // READ REG0
       
        PSEL    = 1;
        PENABLE = 0;
        PWRITE  = 0;
        PADDR   = 32'h00;

        #10;

        PENABLE = 1;

        #10;

        PSEL    = 0;
        PENABLE = 0;
        
        // READ REG1

        PSEL    = 1;
        PENABLE = 0;
        PWRITE  = 0;
        PADDR   = 32'h04;

        #10;

        PENABLE = 1;

        #10;

        PSEL    = 0;
        PENABLE = 0;
        
        // READ REG2
        
        PSEL    = 1;
        PENABLE = 0;
        PWRITE  = 0;
        PADDR   = 32'h08;

        #10;

        PENABLE = 1;

        #10;

        PSEL    = 0;
        PENABLE = 0;

        
        // READ REG3

        PSEL    = 1;
        PENABLE = 0;
        PWRITE  = 0;
        PADDR   = 32'h0C;

        #10;

        PENABLE = 1;

        #10;

        PSEL    = 0;
        PENABLE = 0;

        
        // INVALID ADDRESS WRITE

        PSEL    = 1;
        PENABLE = 0;
        PWRITE  = 1;
        PADDR   = 32'h10;
        PWDATA  = 32'hAAAA5555;

        #10;

        PENABLE = 1;

        #10;

        PSEL    = 0;
        PENABLE = 0;
        PWRITE  = 0;

        
        // INVALID ADDRESS READ
        
        PSEL    = 1;
        PENABLE = 0;
        PWRITE  = 0;
        PADDR   = 32'h10;

        #10;

        PENABLE = 1;

        #10;

        PSEL    = 0;
        PENABLE = 0;


        // FINISH
       
        #10;
        $finish;

    end

endmodule