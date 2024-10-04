/*
Implement a 64 x 32 RAM memory consisting of 64 locations each capable of storing 32-bits of data.
*/
`include "uvm_macros.svh"
import uvm_pkg::*;

class Mem extends uvm_mem;
    `uvm_object_utils(Mem)

    function new(string name = "dut_mem1");
        super.new(name, 64, 32, "RW", UVM_NO_COVERAGE);
    endfunction

endclass

module tb;
    Mem mem;

    initial begin
        mem = new("mem");
    end
endmodule