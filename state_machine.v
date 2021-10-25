`define INIT  2'h0
`define LATCH 2'h1
`define CALC  2'h2
`define DONE  2'h3

module state_machine (
  input  wire       clk,
  input  wire       rst,
  input  wire       trig,
  input  wire [1:0] count,    // 0 - 3,
  output wire [1:0] state_out // `INIT, `LATCH, `CALC, `DONE
);

reg [1:0] state_reg;

assign state_out = state_reg;

always @ (posedge clk) begin
  if (!rst) begin
    state_reg <= `INIT;
  end else begin
    case (state_reg)
      `INIT: begin
        if (trig) begin
          state_reg <= `LATCH;
        end
      end
      `LATCH: begin
        state_reg <= `CALC;
      end
      `CALC: begin
        if (count == 2'h0) begin
          state_reg <= `DONE;
        end
      end
      `DONE: begin
        state_reg <= `INIT;
      end
    endcase
  end
end

endmodule
