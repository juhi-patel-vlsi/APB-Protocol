module apb_slave (
  input         CLK,
  input         RST,
  input         PSEL,
  input         PENABLE,
  input         PWRITE,
  input  [31:0] PADDR,
  input  [31:0] PWDATA,

  output reg [31:0] PRDATA,
  output            PREADY,
  output            PSLVERR
);

// 1. REGISTER AND STATE DECLARATIONS

reg [31:0] REG0;
reg [31:0] REG1;
reg [31:0] REG2;
reg [31:0] REG3;

reg [1:0] STATE;
reg [1:0] NEXT_STATE;

parameter IDLE   = 2'b00;
parameter SETUP  = 2'b01;
parameter ACCESS = 2'b10;

// 2. STATE REGISTER

always @(posedge CLK or negedge RST)
begin
  if (!RST)
    STATE <= IDLE;
  else
    STATE <= NEXT_STATE;
end

// 3. FSM NEXT STATE LOGIC

always @(*)
begin
  NEXT_STATE = STATE;

  case (STATE)

    IDLE:
    begin
      if (PSEL)
        NEXT_STATE = SETUP;
    end

    SETUP:
    begin
      if (PENABLE)
        NEXT_STATE = ACCESS;
    end

    ACCESS:
    begin
      NEXT_STATE = IDLE;
    end

    default:
      NEXT_STATE = IDLE;

  endcase
end

// 4. REGISTERS - WRITE / READ

always @(posedge CLK or negedge RST)
begin
  if (!RST)
  begin
    REG0   <= 32'b0;
    REG1   <= 32'b0;
    REG2   <= 32'b0;
    REG3   <= 32'b0;
    PRDATA <= 32'b0;
  end
  else
  begin

    // write
    if (PSEL && PENABLE && PWRITE)
    begin
      case (PADDR)
        32'h00: REG0 <= PWDATA;
        32'h04: REG1 <= PWDATA;
        32'h08: REG2 <= PWDATA;
        32'h0C: REG3 <= PWDATA;
      endcase
    end

    // read
    if (PSEL && PENABLE && !PWRITE)
    begin
      case (PADDR)
        32'h00: PRDATA <= REG0;
        32'h04: PRDATA <= REG1;
        32'h08: PRDATA <= REG2;
        32'h0C: PRDATA <= REG3;
        default: PRDATA <= 32'h0;
      endcase
    end

  end
end

// 5. PREADY

assign PREADY = (PSEL && PENABLE) ? 1'b1 : 1'b0;

// 6. PSLVERR

assign PSLVERR = (PSEL && PENABLE &&
                 (PADDR != 32'h00) &&
                 (PADDR != 32'h04) &&
                 (PADDR != 32'h08) &&
                 (PADDR != 32'h0C)) ? 1'b1 : 1'b0;

endmodule









 

 






 
 


