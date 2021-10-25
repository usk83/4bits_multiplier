module half_adder (
  input  wire x,        // 左辺
  input  wire y,        // 右辺
  output wire sum_out,  // 合計
  output wire c_out     // 繰り上がり
);

// | x y | c s |
// |:---:|:---:|
// | 0 0 | 0 0 |
// | 0 1 | 0 1 |
// | 1 0 | 0 1 |
// | 1 1 | 1 0 |

assign sum_out   = x ^ y; // 片方が1のとき
assign c_out     = x & y; // 両方が1のとき

endmodule


module full_adder (
  input  wire c,       // carry
  input  wire x,       // 左辺
  input  wire y,       // 右辺
  output wire sum_out, // 合計
  output wire c_out    // 繰り上がり
);

// | c x y | c s |
// |:-----:|:---:|
// | 0 0 0 | 0 0 |
// | 0 0 1 | 0 1 |
// | 0 1 0 | 0 1 |
// | 0 1 1 | 1 0 |
// | 1 0 0 | 0 1 |
// | 1 0 1 | 1 0 |
// | 1 1 0 | 1 0 |
// | 1 1 1 | 1 1 |

assign sum_out = x ^ y ^ c;               // 1の数が奇数のとき
assign c_out   = (x & y) | (c & (x ^ y)); // xとyが1であるか
                                          // cが1であり、x, yのどちらかが1であるとき

endmodule


module adder_4bits (
  input  wire [3:0] x,       // 左辺
  input  wire [3:0] y,       // 右辺
  output wire [3:0] sum_out, // 合計
  output wire       c_out    // 繰り上がり
);

wire s0, s1, s2, s3;
wire c0, c1, c2, c3;

assign sum_out = {s3, s2, s1, s0};
assign c_out = c3;

half_adder u_ha  (x[0:0], y[0:0], s0, c0);
full_adder u1_fa (c0, x[1:1], y[1:1], s1, c1);
full_adder u2_fa (c1, x[2:2], y[2:2], s2, c2);
full_adder u3_fa (c2, x[3:3], y[3:3], s3, c3);

endmodule
