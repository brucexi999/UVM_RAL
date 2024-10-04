/*
Implement a 24-bit register in a verification environment whose structure is as follow. 
bit no. 0-5 represent ctrl bits, bit no. 6-11 represent addr bits, bit no. 12-19 represent 
data bits and bit no. 20-23 represent reserved bits. 
*/
`include "uvm_macros.svh"
import uvm_pkg::*;

class Reg1 extends uvm_reg;
    `uvm_object_utils(Reg1)
    rand uvm_reg_field ctrl;
    rand uvm_reg_field addr;
    rand uvm_reg_field data;

    function new(string name="Reg1");
        super.new(name, 24, UVM_NO_COVERAGE);
    endfunction

    function void build();
        ctrl = uvm_reg_field::type_id::create("ctrl");
        addr = uvm_reg_field::type_id::create("addr");
        data = uvm_reg_field::type_id::create("data");

        ctrl.configure(
            .parent(this),
            .size(6),
            .lsb_pos(0),
            .access("RW"),
            .volatile(0),
            .reset(0),
            .has_reset(1),
            .is_rand(1),
            .individually_accessible(1)
        );

        addr.configure(
            .parent(this),
            .size(6),
            .lsb_pos(6),
            .access("RW"),
            .volatile(0),
            .reset(0),
            .has_reset(1),
            .is_rand(1),
            .individually_accessible(1)
        );

        data.configure(
            .parent(this),
            .size(8),
            .lsb_pos(12),
            .access("RW"),
            .volatile(0),
            .reset(0),
            .has_reset(1),
            .is_rand(1),
            .individually_accessible(1)
        );
    endfunction
endclass

module tb;
    Reg1 reg1;

    initial begin
        reg1 = new("reg1");
        reg1.build();
    end
endmodule