module multiplier (
  input  wire       clk,
  input  wire       rst,
  input  wire       trig,
  input  wire [3:0] x,      // 被乗数（multiplicand）
  input  wire [3:0] y,      // 乗数（multiplier）
  output wire       done,   // 完了
  output wire [7:0] product // 積
);

wire [3:0] mask;
wire [3:0] adder_in;
wire [3:0] adder_out;
wire       adder_carry;
wire [1:0] state;

reg [1:0] count;
reg [3:0] multiplicand; // 被乗数
reg [3:0] result_upper; // 結果の上4bits
reg [3:0] result_lower; // 乗数 兼 結果の下4bits

assign mask     = {result_lower[0:0], result_lower[0:0], result_lower[0:0], result_lower[0:0]};
assign adder_in = multiplicand & mask;
assign done     = (state == `DONE); // TODO: これできるか確認
assign product  = {result_upper[3:0], result_lower[3:0]};

state_machine u_state (clk, rst, trig, count, state);
adder_4bits   u_adder (adder_in, result_upper, adder_out, adder_carry);

always @ (posedge clk)
begin: COUNT
  if (!rst) begin
    count <= 2'h0;
  end else begin
    case (state)
      `LATCH: begin
        count <= 2'h3;
      end
      `CALC: begin
        count <= count - 2'h1;
      end
      default: begin // `INIT, `DONE
        count <= count;
      end
    endcase
  end
end

always @ (posedge clk)
begin: MULTIPLICAND
  if (!rst) begin
    multiplicand <= 4'h0;
  end else begin
    case (state)
      `LATCH: begin
        multiplicand <= x;
      end
      default: begin // `INIT, `CALC, `DONE
        multiplicand <= multiplicand;
      end
    endcase
  end
end

always @ (posedge clk)
begin: RESULT_UPPER
  if (!rst) begin
    result_upper <= 4'h0;
  end else begin
    case (state)
      `LATCH: begin
        result_upper <= 4'h0;
      end
      `CALC: begin
        result_upper <= {adder_carry, adder_out[3:1]};
      end
      default: begin // `INIT, `DONE
        result_upper <= result_upper;
      end
    endcase
  end
end

always @ (posedge clk)
begin: RESULT_LOWER
  if (!rst) begin
    result_lower <= 4'h0;
  end else begin
    case (state)
      `LATCH: begin
        result_lower <= y;
      end
      `CALC: begin
        result_lower <= {adder_out[0:0], result_lower[3:1]};
      end
      default: begin // `INIT, `DONE
        result_lower <= result_lower;
      end
    endcase
  end
end

endmodule
