module Add_Slave(
	input	wire	clk,
	input	wire	reset,
	input	wire	cs,
	input	wire	wr,
	input	wire	rd,
	input	wire	[1:0]	addr,
	input	wire	[31:0]	wr_data,
	output	wire	[31:0]	rd_data,
	output	reg		rd_data_vld,
	output	wire	wait_req
);

reg		wr_acc_dl;
wire	wr_acc;
reg		rd_acc_dl;
wire	rd_acc;
wire	start;
wire	rd_trigger;
wire	done, busy;
reg		[15:0]	a, b;
wire	[31:0]	s;

assign	wr_acc 	= wr && cs && (addr == 0);
assign	rd_acc 	= rd && cs && (addr == 1'b1);
assign	start	= ~wr_acc && wr_acc_dl;
assign	rd_trigger = ~rd_acc && rd_acc_dl;
assign	rd_data	= (rd_data_vld) ? s : 32'd0;
assign	wait_req = busy;

always @(posedge clk)
	begin
		if(reset) begin
			wr_acc_dl <= 1'b0;
			rd_acc_dl <= 1'b0;
		end else begin
			wr_acc_dl <= wr_acc;
			rd_acc_dl <= rd_acc;
		end
	end

always @(posedge clk) begin
	if(reset) begin
		a <= 16'd0;
		b <= 16'd0;
	end else if(wr_acc) begin
		a <= wr_data [15:0];
		b <= wr_data [31:16];
	end else begin
		a <= a;
		b <= b;
	end
end

always @(posedge clk) begin
	if(reset) rd_data_vld <= 1'b0;
	else if(done) rd_data_vld <= 1'b1;
	else if(rd_trigger) rd_data_vld <= 1'b0;
	else rd_data_vld <= rd_data_vld;
end

Add_Wrapper mw (
	.clk(clk),
	.reset(reset),
	.start(start),
	.a(a),
	.b(b),
	.s(s),
	.done(done),
	.busy(busy)
	);

endmodule