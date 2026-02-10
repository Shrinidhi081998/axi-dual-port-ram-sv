//-------------------------------------------
//Name    : Shrinidhi NS
//Project : AXI Interface
//Module name : AXI_Intf
//-------------------------------------------
interface AXI_Intf (input logic aclk, input aresetn);
  
  //Master AXI AWADDR Interface
  logic [31:0] AWADDR;
  logic        AWVALID;
  logic        AWREADY;
  logic  [3:0] AWLEN;
  logic  [2:0] AWSIZE;
  logic  [1:0] AWBURST;

  //Master AXI WDATA Interface
  logic [31:0] WDATA;
  logic        WVALID;
  logic        WREADY;
  logic  [3:0] WSTRB;
  logic        WLAST;
  
  //Master AXI BRESP Interface
  logic  [1:0] BRESP;
  logic        BVALID;
  logic        BREADY;
  
  //Master AXI ARADDR Interface
  logic [31:0] ARADDR;
  logic        ARVALID;
  logic        ARREADY;
  logic  [3:0] ARLEN;
  logic  [2:0] ARSIZE;
  logic  [1:0] ARBURST;
  
  //Master AXI RDATA Interface
  logic [31:0] RDATA;
  logic        RVALID;
  logic        RREADY;
  logic  [1:0] RRESP;    
  logic        RLAST;
  
  
  //----- Modport for AXI master
  modport AXI_M (
    //Master AXI AWADDR Interface
    output [31:0] AWADDR,
    output        AWVALID,
    input         AWREADY,
    output  [3:0] AWLEN,
    output  [2:0] AWSIZE,
    output  [1:0] AWBURST,
    
    //Master AXI WDATA Interface
    output [31:0] WDATA,
    output        WVALID,
    input         WREADY,
    output  [3:0] WSTRB,
    output        WLAST,
    
    //Master AXI BRESP Interface
    input  [1:0] BRESP,
    input        BVALID,
    output       BREADY,
    
    //Master AXI ARADDR Interface
    output [31:0] ARADDR,
    output        ARVALID,
    input         ARREADY,
    output  [3:0] ARLEN,
    output  [2:0] ARSIZE,
    output  [1:0] ARBURST,
    
    //Master AXI RDATA Interface
    input [31:0] RDATA,
    input        RVALID,
    output       RREADY,
    input  [1:0] RRESP,    
    input        RLAST
	
  );
  
  //----- Modport for AXI slave
  modport AXI_S (
    //Master AXI AWADDR Interface
    input [31:0] AWADDR,
    input        AWVALID,
    output       AWREADY,  //OUT
    input  [3:0] AWLEN,
    input  [2:0] AWSIZE,
    input  [1:0] AWBURST,
    
    //Master AXI WDATA Interface
    input [31:0] WDATA,
    input        WVALID,
    output       WREADY,  //OUT
    input  [3:0] WSTRB,
    input        WLAST,
    
    //Master AXI BRESP Interface
    output  [1:0] BRESP,
    output        BVALID,
    input         BREADY,  //IN
    
    //Master AXI ARADDR Interface
    input [31:0] ARADDR,
    input        ARVALID,
    output       ARREADY, //OUT
    input  [3:0] ARLEN,
    input  [2:0] ARSIZE,
    input  [1:0] ARBURST,
    
    //Master AXI RDATA Interface
    output [31:0] RDATA,
    output        RVALID,
    input         RREADY, //IN
    output  [1:0] RRESP,    
    output        RLAST
	
  );
  
endinterface