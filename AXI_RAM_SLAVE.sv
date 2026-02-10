//-------------------------------------------
//Name    : Shrinidhi NS
//Project : AXI Interface
//Module name : AXI_RAM_SLAVE
//-------------------------------------------
module axi_ram_slave (
  input  logic           aclk,
  input  logic           aresetn,
  AXI_Intf.AXI_S          axi
);

  // Simple memory
  logic [31:0] mem [0:255];

  // Internal registers
  logic [31:0] wr_addr;
  logic [31:0] rd_addr;
  logic [2:0]  wr_cnt;
  logic [2:0]  rd_cnt;

  // ---------------- WRITE ADDRESS ----------------
  always_ff @(posedge aclk) begin
    if (!aresetn) begin
      axi.AWREADY <= 0;
      wr_cnt      <= 0;
    end else begin
      axi.AWREADY <= 1;
      if (axi.AWVALID && axi.AWREADY) begin
        wr_addr <= axi.AWADDR;
        wr_cnt  <= axi.AWLEN;
      end
    end
  end

  // ---------------- WRITE DATA ----------------
  always_ff @(posedge aclk) begin
    if (!aresetn) begin
      axi.WREADY <= 0;
    end else begin
      axi.WREADY <= 1;
      if (axi.WVALID && axi.WREADY) begin
        mem[wr_addr[9:2]] <= axi.WDATA;
        wr_addr <= wr_addr + 4;
      end
    end
  end

  // ---------------- WRITE RESPONSE ----------------
  always_ff @(posedge aclk) begin
    if (!aresetn) begin
      axi.BVALID <= 0;
      axi.BRESP  <= 2'b00;
    end else begin
      if (axi.WVALID && axi.WREADY && axi.WLAST) begin
        axi.BVALID <= 1;
      end
      if (axi.BVALID && axi.BREADY) begin
        axi.BVALID <= 0;
      end
    end
  end

  // ---------------- READ ADDRESS ----------------
  always_ff @(posedge aclk) begin
    if (!aresetn) begin
      axi.ARREADY <= 0;
      rd_cnt      <= 0;
    end else begin
      axi.ARREADY <= 1;
      if (axi.ARVALID && axi.ARREADY) begin
        rd_addr <= axi.ARADDR;
        rd_cnt  <= axi.ARLEN;
      end
    end
  end

  // ---------------- READ DATA ----------------
  always_ff @(posedge aclk) begin
    if (!aresetn) begin
      axi.RVALID <= 0;
      axi.RLAST  <= 0;
    end else begin
      if (axi.ARVALID && axi.ARREADY) begin
        axi.RVALID <= 1;
      end

      if (axi.RVALID && axi.RREADY) begin
        axi.RDATA <= mem[rd_addr[9:2]];
        rd_addr   <= rd_addr + 4;

        if (rd_cnt == 0)
          axi.RLAST <= 1;
        else
          rd_cnt <= rd_cnt - 1;
      end

      if (axi.RVALID && axi.RREADY && axi.RLAST) begin
        axi.RVALID <= 0;
        axi.RLAST  <= 0;
      end
    end
  end

  assign axi.RRESP = 2'b00;

endmodule
