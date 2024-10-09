// Implement an adapter class for the design whose code is mentioned in the instruction tab.
/*
The functionality of I/O ports is as follows:

1) clk is the global clock signal.
2) rst is active high synchronous reset.
3) addrin is used to specify address of register where read or write operation will be performed.
4) datain is an input data bus.
5) dataout is the output data bus.
6) wr is mode control pin (if wr is high then specific register will be updated with datain value based on address specified on addrin bus else content of register will be returned on dataout bus based on address specified on addrin bus).
*/

// Design code:

module top(
  input clk, rst,
  input wr,
  input [3:0]  addrin,
  input [31:0]  datain,
  output [31:0] dataout
);

  ////////////DUT registers
  logic [31:0] reg1;///offset addr : 0
  logic [31:0] reg2;///offset addr : 1
  logic [31:0] reg3;///offset addr : 2
  logic [31:0] reg4;///offset addr : 3

  //////////// temporary register to store read data
  logic [31:0] temp;


  always@(posedge clk)
    begin
      if(rst)
        begin
        reg1 <= 32'h0;
        reg2 <= 32'h0;
        reg3 <= 32'h0;
        reg4 <= 32'h0;
        temp <= 32'h0;
        end
      else
        begin
          if(wr)
           begin
            case(addrin)
              2'b00: reg1 <= datain;
              2'b01: reg2 <= datain;
              2'b10: reg3 <= datain;
              2'b11: reg4 <= datain;
            endcase
          end
          else
           begin
            case(addrin)
              2'b00: temp <= reg1;
              2'b01: temp <= reg2;
              2'b10: temp <= reg3;
              2'b11: temp <= reg4;
            endcase
          end
        end
    end
  assign dataout = temp;

endmodule


//////////////////////////////////////

interface top_if ;

  logic clk, rst;
  logic wr;
  logic [3:0]  addrin;
  logic [31:0]  datain;
  logic [31:0] dataout;

endinterface

class Transaction extends uvm_sequence_item;
    `uvm_object_utils(Transaction)

    logic wr;
    logic [3:0]  addrin;
    logic [31:0]  datain;
    logic [31:0] dataout; 

    function new(name="Transaction");
        super.new(name);
    endfunction
    
endclass

class Adapter extends uvm_reg_adapter;
    `uvm_object_utils(Adapter)
    
    function new(string name="Adapter");
        super.new(name);
    endfunction

    function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        Transaction trans;
        trans = Transaction::type_id::create("trans");
        trans.wr = (rw.kind == UVM_WRITE) ? 1 : 0;
        trans.addrin = rw.addr;
        if (trans.wr == 1) trans.datain = rw.data;

        return trans;
    endfunction

    function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        Transaction trans;
        assert ($cast(trans, bus_item));
        rw.kind = (trans.wr == 1)? UVM_WRITE : UVM_READ;
        rw.data = trans.dataout;
        rw.addr = trans.addrin;
        rw.status = UVM_IS_OK;
    endfunction
endclass

