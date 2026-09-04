module apb_slave (
input CLK,
input RST,
input PSEL ,
input PENABLE,
input PWRITE,
input [31:0] PADDR,
input [31:0] PWDATA,

output [31:0] PRDATA,
output        PREADY,
output        PSLVERR
);

// 1. RESET + REGISTER DECLARATIONS 

reg [31:0] REG 0;
reg [31:0] REG 1;
reg [31:0] REG 2;
reg [31:0] REG 3;

reg [1:0] STATE;
reg [1:0] NEXT_STATE;

parameter IDLE = 2'b00;
parameter SETUP = 2'b01;
parameter ACCESS = 2'b10;


   // 2. RESET / STATE REGISTER

  always @(posedge CLK or negedge RST)
begin
if(!RST)
begin
state <= IDLE ;

REG 0 <=  32'b0;
REG 1 <=  32'b0;
REG 2 <=  32'b0;
REG 3 <=  32'b0;

PRDATA <= 32'b0;
PREADY <= 1'b0;
PSLVERR <= 1'b0;
end
else begin
 STATE <= NEXT_STATE;
   end
end

// 3. FSM

 always @(*)
begin
NEXT_STATE = STATE;

case (STATE)

IDLE:
 begin
if(PSEL)
  STATE = SETUP; 
end

SETUP:
 begin
if(PENABLE)
  STATE = ACCESS;
end

ACCESS:
 begin
  NEXT_STATE = IDLE;
end

DEFAULT:
begin
NEXT_STATE = IDLE;
 end
   endcase 
end


// 4. REGISTERS - WRITE / READ


 always @(posedge CLK or negedge RST)
 begin
if(!RST)

REG 0 <= 32'b0;
REG 1 <= 32'b0;
REG 2 <= 32'b0;
REG 3 <= 32'b0;

PRDATA <= 32'b0;
end
else begin
  
// write 

if (PSEL && PENABLE && PWRITE)
begin
case (PADDR)

32'h00;
REG 0 <= PWDATA;

32'h04;
REG 1 <= PWDATA;

32'h08;
REG 2 <= PWDATA;

32'h0C;
REG 3 <= PWDATA;

endcase
 end
 
// read

if (PSEL && PENABLE && PWRITE)
begin
case (PADDR)

32'h00;
PRDATA <= REG 0;

32'h04;
PRDATA <= REG 1;

32'h08;
PRDATA <= REG 2;

32'h0C;
PRDATA <= REG 3;

DEFAULT
PRDATA <= 32'h0;
 
  endcase
end 
   end 
      end 

 // 5. PREADY
 
always @(*)
begin
if(PSEL && PENABLE)
  PREADY <= 1'b1;
else 
PREADY <= 1'b0;
end


  // 6. PSLVERR

  always @(*)
 begin
if ((PADDR != 32'h00) &&
    (PADDR != 32'h04) &&
    (PADDR != 32'h08) &&
    (PADDR != 32'h0C))
    PSLVERR = 1'b1;
  else 
    PSLVERR = 1'b0;
end 
else
  begin
   PSLVERR = 1'b0;
  end 
endmodule







 
 


