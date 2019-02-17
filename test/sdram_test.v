module sdram_test(
	input wire clk,
	input wire rstn,

  output reg [31:0] m_axi_araddr,
	input wire m_axi_arready,
	output reg m_axi_arvalid,

	output reg [31:0] m_axi_awaddr,
	input wire m_axi_awready,
	output reg m_axi_awvalid,

	output reg m_axi_bready,
	input wire [1:0] m_axi_bresp,
	input wire m_axi_bvalid,

	input wire [31:0] m_axi_rdata,
	output reg m_axi_rready,
	input wire [1:0] m_axi_rresp,
	input wire m_axi_rvalid,

	output reg [31:0] m_axi_wdata,
	input wire m_axi_wready,
	output reg [3:0] m_axi_wstrb,
	output reg m_axi_wvalid,

	output reg led
	);


	reg [6:0] state ;

	wire [31:0] addr1,addr2,addr3;
	assign addr1 = 32'h01000000;
	assign addr2 = 32'h01000010;
	assign addr3 = 32'h0F000000;

	wire [31:0] data1,data2,data3;
	assign data1 = 32'hAA;
	assign data2 = 32'hBBBB;
	assign data3 = 32'hFFFFFFFF;


	always @(posedge clk) begin
		if(~rstn) begin
			m_axi_araddr <= 0;
			m_axi_arvalid <= 0;
			m_axi_awaddr <= 0;
			m_axi_awvalid <= 0;
			m_axi_bready <= 0;
			m_axi_rready <= 0;
			m_axi_wdata <= 0;
			m_axi_wstrb <= 0;
			m_axi_wvalid <= 0;
			
			state <= 0;
			led <= 0;
		end else if (state == 0) begin
			m_axi_awaddr <= addr1;
			m_axi_awvalid <= 1;
			state <= 1;
		end else if (state == 1) begin
			if(m_axi_awready) begin
				m_axi_awvalid <= 0;
				m_axi_wdata <= data1;
				m_axi_wstrb <= 4'b1111;
				m_axi_wvalid <= 1;
				state <= 2;
			end
		end else if (state == 2) begin
			if(m_axi_wready) begin
				m_axi_wvalid <= 0;
				m_axi_bready <= 1;
				state <= 3;
			end
		end else if (state == 3) begin
			if(m_axi_bvalid) begin
				m_axi_bready <= 0;
				led[0] <= 1;
				state <= 4;
			end
		end else if (state == 4) begin
			m_axi_awaddr <= addr2;
			m_axi_awvalid <= 1;
			state <= 5;	
		end else if (state == 5) begin
			if(m_axi_awready) begin
				m_axi_awvalid <= 0;
				m_axi_wdata <= data2;
				m_axi_wstrb <= 4'b1111;
				m_axi_wvalid <= 1;
				state <= 6;
			end
		end else if (state == 7) begin
			if (m_axi_wready) begin
				m_axi_wvalid <= 0;
				m_axi_bready <= 1;
				state <= 8;
			end
		end else if (state == 8) begin
			if (m_axi_bvalid) begin
				m_axi_bready <= 0;
				led[1] <= 1;
				state <= 9;
			end
		end else if (state == 9) begin
			m_axi_araddr <= addr1;
			m_axi_arvalid <= 1;
			state <= 10;
		end else if (state == 10) begin
			if(m_axi_arready) begin
				m_axi_arvalid <= 0;
				m_axi_rready  <= 1;
				state <= 11;
			end
		end else if (state == 11) begin
			if(m_axi_rvalid) begin
				m_axi_rready <= 0;
				if(m_axi_rdata == data1) begin
					led[2] <= 1;
				end
				state <= 12;
			end
		end else if (state == 12) begin
			m_axi_awaddr <= addr3;
			m_axi_awvalid <= 1;
			state <= 13;
		end else if (state == 13) begin
			if(m_axi_awready) begin
				m_axi_awvalid <= 0;
				m_axi_wdata <= data3;
				m_axi_wstrb <= 4'b1111;
				m_axi_wvalid <= 1;
				state <= 14;
			end
		end else if (state == 14) begin
			if(m_axi_wready) begin
				m_axi_wvalid <= 0;
				m_axi_bready <= 1;
				state <= 15;
			end
		end else if (state == 15) begin
			if(m_axi_bvalid) begin
				m_axi_bready <= 0;
				led[3] <= 1;
				state <= 16;
			end
		end else if (state == 16) begin
			m_axi_araddr <= addr2;
			m_axi_arvalid <= 1;
			state <= 17;
		end else if (state == 17) begin
			if(m_axi_arready) begin
				m_axi_arvalid <= 0;
				m_axi_rready <= 1;
				state <= 18;
			end
		end else if (state == 18) begin
			if(m_axi_rvalid) begin
				m_axi_rready <= 0;
				if(m_axi_rdata == data2) begin
					led[4] <= 1;
				end
				state <= 19;
			end
		end else if (state == 19) begin
			m_axi_araddr <= addr3;
			m_axi_arvalid <= 1;
			state <= 20;
		end else if (state == 20) begin
			if(m_axi_arready) begin
				m_axi_arvalid <= 0;
				m_axi_rready <= 1;
				state <= 21;
			end
		end else if (state == 21) begin
			if(m_axi_rvalid) begin
				m_axi_rready <= 0;
				if(m_axi_rdata == data3) begin
					led[5] <= 1;
				end
				state <= 22;
			end
		end else if (state == 22) begin
			led[7] <= 1;
		end
	end // always
endmodule
																	
