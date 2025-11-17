
//input ports
add mapped point a[3] a[3] -type PI PI
add mapped point a[2] a[2] -type PI PI
add mapped point a[1] a[1] -type PI PI
add mapped point a[0] a[0] -type PI PI
add mapped point b[3] b[3] -type PI PI
add mapped point b[2] b[2] -type PI PI
add mapped point b[1] b[1] -type PI PI
add mapped point b[0] b[0] -type PI PI
add mapped point c[3] c[3] -type PI PI
add mapped point c[2] c[2] -type PI PI
add mapped point c[1] c[1] -type PI PI
add mapped point c[0] c[0] -type PI PI
add mapped point d[3] d[3] -type PI PI
add mapped point d[2] d[2] -type PI PI
add mapped point d[1] d[1] -type PI PI
add mapped point d[0] d[0] -type PI PI
add mapped point sel[1] sel[1] -type PI PI
add mapped point sel[0] sel[0] -type PI PI
add mapped point clk clk -type PI PI
add mapped point resetn resetn -type PI PI

//output ports
add mapped point out[3] out[3] -type PO PO
add mapped point out[2] out[2] -type PO PO
add mapped point out[1] out[1] -type PO PO
add mapped point out[0] out[0] -type PO PO

//inout ports




//Sequential Pins
add mapped point out[3]/q out_reg[3]/Q -type DFF DFF
add mapped point out[2]/q out_reg[2]/Q -type DFF DFF
add mapped point out[0]/q out_reg[0]/Q -type DFF DFF
add mapped point out[1]/q out_reg[1]/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
