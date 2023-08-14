
//`include "uvm_pkg"
import uvm_pkg:: *;
`include "uvm_macros.svh" 

`include "common.sv"
`include "ahb_tx.sv"
`include "sequence.sv"
`include "interface.sv"
`include "arb_intf.sv"
`include "sequencer.sv"
`include "scoreboard.sv"
`include "drv.sv"
`include "responder.sv"
`include "monitor.sv"
`include "coverage.sv"
`include "assertions.sv"
`include "sagent.sv"
`include "magent.sv"
`include "env.sv"
`include "test.sv"



module top;

    bit clk, rst;

    //signals required here since EDA playground uses Mentor Questa
    //without assigning these signals wavefors cannot be viewed
    //arb_intf signals
    logic [15:0] hbusreq;
    logic [15:0] hlock;
    logic [15:0]hgrant;
    logic [3:0]hmaster;
    logic hmastlock;
    logic [15:0] hsplit;
  // intf signals
  logic [31:0] haddr;
    logic [2:0] hburst;
    logic[6:0] hprot;
    logic[2:0] hsize;
    logic hnonsec;
    logic hexcl;
    
    logic [1:0] htrans;
    logic [31:0] hwdata;
    logic [31:0] hrdata;
    logic hwrite;
    logic hreadyout;
    logic [1:0] hresp;
    logic hexokay;
  

    ahb_intf pif(.hclk(clk), .hrst(rst));
    arb_intf arb_pif(.hclk(clk), .hrst(rst));
    ahb_assertions ahb_assertions_i(pif.hclk, pif.hrst, pif.haddr, pif.hburst, pif.hprot, pif.hsize,
    pif.hnonsec, pif.hexcl, pif.htrans, pif.hwdata, pif.hrdata, pif.hwrite, pif.hreadyout,
    pif.hresp, pif.hexokay );
    //arb_intf signals
    assign hbusreq = arb_pif.hbusreq;
    assign hlock =arb_pif.hlock;
    assign hgrant =arb_pif.hgrant;
    assign hmaster= arb_pif.hmaster;
    assign hmastlock =arb_pif.hmastlock;
    assign hsplit =arb_pif.hsplit;
  
  //intf signals
  assign haddr =pif.haddr ;
    assign hburst= pif.hburst;
    assign hprot =pif.hprot;
    assign hsize =pif.hsize;
    assign hnonsec =pif.hnonsec;
    assign hexcl= pif.hexcl;
    
    assign htrans =pif.htrans;
    assign hwdata =pif.hwdata;
    assign hrdata =pif.hrdata;
    assign hwrite =pif.hwrite;
    assign hreadyout= pif.hreadyout;
    assign hresp =pif.hresp;
    assign hexokay =pif.hexokay;
  

    initial begin : generate_clock
        clk = 1'b0;
        while(1) #5 clk = ~clk;
     end

     initial begin
        rst = 1;
        drive_rst_values;
        @(posedge clk);
        rst = 0;
     end

     //to prevent undefined values during simulation
     task drive_rst_values();
        pif.haddr = 0;
        pif.hburst = 0;
        pif.hprot = 0;
        pif.hsize = 0;
        pif.hnonsec = 0;
        pif.hexcl = 0;
        
        pif.htrans = 0;
        pif.hwdata = 0;
        pif.hrdata = 0;
        pif.hwrite = 0;
        pif.hreadyout = 0;
        pif.hresp = 0;
        pif.hexokay = 0;
        //arb_intf signals
        arb_pif.hbusreq = 0;
        arb_pif.hlock = 0;
        arb_pif.hgrant = 0;
        arb_pif.hmaster = 0;
        arb_pif.hmastlock = 0;
        arb_pif.hsplit = 0;
     endtask

    initial begin
        run_test("ahb_rand_wr_rd_wrap_test");
    end

    initial begin
        uvm_resource_db#(virtual ahb_intf)::set("AHB", "INTF", pif, null);
        uvm_resource_db#(virtual arb_intf)::set("AHB", "ARB_INTF", arb_pif, null);

    end

    initial begin
        $dumpfile("ahb_ic.vcd");
        $dumpvars();
    end
endmodule