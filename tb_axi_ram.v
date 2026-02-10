//-------------------------------------------
//Name    : Shrinidhi NS
//Project : AXI Interface
//Module name : tb_axi_ram
//-------------------------------------------
module tb_axi_ram;

  logic aclk;
  logic aresetn;

  AXI_Intf axi_if (.aclk(aclk), .aresetn(aresetn));

  axi_dual_port_ram dut (
    .aclk(aclk),
    .aresetn(aresetn),
    .axi(axi_if)
  );

  // Clock
  always #5 aclk = ~aclk;

  initial begin
    aclk = 0;
    aresetn = 0;
    #20 aresetn = 1;
  end

  // ---------------- MASTER TASKS ----------------
  initial begin
    // Defaults
    axi_if.AWVALID = 0;
    axi_if.WVALID  = 0;
    axi_if.BREADY  = 1;
    axi_if.ARVALID = 0;
    axi_if.RREADY  = 1;

    wait(aresetn);

    // -------- WRITE BURST --------
    @(posedge aclk);
    axi_if.AWADDR  <= 32'h0000_0000;
    axi_if.AWLEN   <= 3'd3;      // 4 beats
    axi_if.AWSIZE  <= 3'b010;    // 4 bytes
    axi_if.AWBURST <= 2'b01;     // INCR
    axi_if.AWVALID <= 1;

    wait(axi_if.AWREADY);
    @(posedge aclk);
    axi_if.AWVALID <= 0;

    for (int i = 0; i < 4; i++) begin
      @(posedge aclk);
      axi_if.WDATA  <= 32'hA5A50000 + i;
      axi_if.WSTRB  <= 4'hF;
      axi_if.WLAST  <= (i == 3);
      axi_if.WVALID <= 1;
      wait(axi_if.WREADY);
      axi_if.WVALID <= 0;
    end

    wait(axi_if.BVALID);
    $display("WRITE DONE");

    // -------- READ BURST --------
    @(posedge aclk);
    axi_if.ARADDR  <= 32'h0000_0000;
    axi_if.ARLEN   <= 3'd3;
    axi_if.ARSIZE  <= 3'b010;
    axi_if.ARBURST <= 2'b01;
    axi_if.ARVALID <= 1;

    wait(axi_if.ARREADY);
    @(posedge aclk);
    axi_if.ARVALID <= 0;

    while (!axi_if.RLAST) begin
      wait(axi_if.RVALID);
      $display("READ DATA = %h", axi_if.RDATA);
      @(posedge aclk);
    end

    $display("READ DONE");
    #50 $finish;
  end

endmodule
