module memtest(
	input wire clk,
	input wire rstn,

	//axi
	output reg [30:0] s_axi_araddr,
	output reg [1:0] s_axi_arburst,
	output reg [3:0] s_axi_arcache,
	output reg [3:0] s_axi_arid,
	output reg [7:0] s_axi_arlen,
	output reg [0:0] s_axi_arlock,
	output reg	[2:0] s_axi_arprot,
	output reg [3:0] s_axi_arqos,
	input wire s_axi_arready,
	output reg [2:0] s_axi_arsize,
	output reg s_axi_arvalid,

	output reg [30:0] s_axi_awaddr,
	output reg [1:0] s_axi_awburst,
	output reg [3:0] s_axi_awcache,
	output reg [3:0] s_axi_awid,
	output reg [7:0] s_axi_awlen,
	output reg [0:0] s_axi_awlock,
	output reg	[2:0] s_axi_awprot,
	output reg [3:0] s_axi_awqos,
	input wire s_axi_awready,
	output reg [2:0] s_axi_awsize,
	output reg s_axi_awvalid,

	input wire [3:0] s_axi_bid,
	output reg s_axi_bready,
	input wire [1:0] s_axi_bresp,
	input wire s_axi_bvalid,

	input wire [511:0] s_axi_rdata,
	input wire [3:0] s_axi_rid,
	input wire s_axi_rlast,
	output reg s_axi_rready,
	input wire [1:0] s_axi_rresp,
	input wire s_axi_rvalid,

	output reg [511:0] s_axi_wdata,
	output reg s_axi_wlast,
	input wire s_axi_wready,
	output reg [63:0] s_axi_wstrb,
	output reg s_axi_wvalid
	);

	(* mark_debug = "true" *) reg [4:0] state;
	(* mark_debug = "true" *) reg err;
	(* mark_debug = "true" *) reg [511:0] rdata;
	(* mark_debug = "true" *) reg [511:0] data;
	(* mark_debug = "true" *) reg [30:0] addr;


	always @(posedge clk) begin
		if (~rstn) begin
			state <= 0;
			err <= 0;
			data <= 64'h1;
			addr <= 0;
			rdata <= 0;

			s_axi_araddr <= 0;
			s_axi_arburst <= 2'b01; // INCR
			s_axi_arcache <= 4'b0011; // music num
			s_axi_arid <= 0; // ignore
			s_axi_arlen <= 0; // burst len 1
			s_axi_arlock <= 0; // ignore
			s_axi_arprot <= 0; // ignore
			s_axi_arqos <= 0; // ignore
			s_axi_arsize <= 3'b011; // 64bit
			s_axi_arvalid <= 0;
			s_axi_awaddr <= 0;
			s_axi_awburst <= 2'b01; //INCR
			s_axi_awcache <= 4'b0011; // magic num
			s_axi_awid <= 0; // ignore
			s_axi_awlen <= 0; // burst len 1
			s_axi_awlock <= 0; // ignore
			s_axi_awprot <= 0; // ignore
			s_axi_awqos <= 0; // ignore
			s_axi_awsize <= 3'b011; // 64bit
			s_axi_awvalid <= 0;
			s_axi_bready <= 0;
			s_axi_rready <= 0;
			s_axi_wdata <= 0;
			s_axi_wlast <= 0;
			s_axi_wstrb <= {64{1'b1}}; // 64bit enable
			s_axi_wvalid <= 0;
		// write
		end else if (state == 0) begin
			s_axi_awvalid <= 1;
			s_axi_awaddr <= addr;
			data <= data + 32'h10000000;
			state <= 1;
		end else if (state == 1) begin
			if(s_axi_awready) begin
				s_axi_awvalid <= 0;
				state <= 2;
			end
		end else if (state == 2) begin
			s_axi_wvalid <= 1;
			s_axi_wdata <= data;
			s_axi_wlast <= 1;
			state <= 4;
		end else if (state == 4) begin
			if(s_axi_wready) begin
				s_axi_wvalid <= 0;
				s_axi_wlast <= 0;
				s_axi_bready <= 1;
				state <= 5;
			end
		end else if (state == 5) begin
			if(s_axi_bvalid) begin
				s_axi_bready <= 0;
				err <= err | s_axi_bresp[1];
				state <= 6;
			end
		//read
		end else if (state == 6) begin
			s_axi_araddr <= addr;
			s_axi_arvalid <= 1;
			state <= 7;
		end else if (state == 7) begin
			if(s_axi_arready) begin
				s_axi_arvalid <= 0;
				state <= 8;
			end
		end else if(state == 8) begin
			s_axi_rready <= 1;
			state <= 9;
		end else if (state == 9) begin
			if(s_axi_rvalid) begin
				err = err | s_axi_rresp[1];
				rdata <= s_axi_rdata;
				if(s_axi_rlast) begin
					s_axi_rready <= 0;
					addr <= addr + 8;
					state <= 0;
				end
			end
		end else begin
			
		end
	end

endmodule
