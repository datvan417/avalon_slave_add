module Add_Wrapper(
	input 	wire	clk,
	input	wire	reset,
	input	wire	start,
	input	wire	[15:0]	a,
	input	wire	[15:0]	b,
	output 	reg		[31:0]	s,
	output 	reg		done,
	output 	reg		busy
);
reg		[1:0]	count; 
wire	[31:0]	s_temp;

	always @(posedge clk or posedge reset)
	begin
		if(reset) count <= 2'd0;
		else if(start) count <= count + 1'b1;
		else if(count != 0) count <= count + 1'b1;
		else count <= count;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if(reset) busy <= 1'b0;
		else if(start) busy <= 1'b1;
		else if(count == 2'd3) busy <= 1'b0;
		else busy <= busy;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if(reset) done <= 1'b0;
		else if(count == 2'd3) done <= 1'b1;
		else done <= 0;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if(reset) s <= 17'd0;
		else if(done) s <= s_temp;
		else s <= s;
	end
	
	Add m(
	.clk(clk),
	.dataa(a),
	.datab(b),
	.result(s_temp)
	);
	
endmodule