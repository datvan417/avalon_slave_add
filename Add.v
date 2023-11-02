module Add(
	input	wire	clk,
	input	wire	[15:0]	dataa,
	input	wire	[15:0]	datab,
	output 	reg		[31:0]	result
);
	
	always @(posedge clk)
	begin
		result	= dataa + datab;
	end

endmodule