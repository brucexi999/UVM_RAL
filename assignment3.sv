/*
Implement register block in the verification environment for the DUT, which consists of two 24-bit registers.
Structure of both registers :
1) reg0 structure : bits 0-5 represent ctrl bits, bits 6-11 represent addr bits, bits 12-19 represent data bits and bits 20-23 represent reserved bits.
2) reg1 structure : bits 0 - 11 represent addr bits and bits 12- 23 represent data bits
*/
`include "uvm_macros.svh"
import uvm_pkg::*;

class Reg0 extends uvm_reg;
    `uvm_object_utils(Reg0)
    rand uvm_reg_field ctrl;
    rand uvm_reg_field addr;
    rand uvm_reg_field data;

    function new(string name="Reg0");
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

class Reg1 extends uvm_reg;
    `uvm_object_utils(Reg1)
    rand uvm_reg_field addr;
    rand uvm_reg_field data;

    function new(string name="Reg1");
        super.new(name, 24, UVM_NO_COVERAGE);
    endfunction

    function void build();
        addr = uvm_reg_field::type_id::create("addr");
        data = uvm_reg_field::type_id::create("data");

        addr.configure(
            .parent(this),
            .size(12),
            .lsb_pos(0),
            .access("RW"),
            .volatile(0),
            .reset(0),
            .has_reset(1),
            .is_rand(1),
            .individually_accessible(1)
        );

        data.configure(
            .parent(this),
            .size(12),
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

class RegBlock extends uvm_reg_block;
    `uvm_object_utils(RegBlock)

    rand Reg0 reg0;
    rand Reg1 reg1;

    function new(string name="RegBlock");
        super.new(name, UVM_NO_COVERAGE);
    endfunction

    function void build();
        reg0 = Reg0::type_id::create("reg0");
        reg0.build();
        reg0.configure(this);
        
        reg1 = Reg1::type_id::create("reg1");
        reg1.build();
        reg1.configure(this);

        default_map = create_map("default_map", 0, 3, UVM_LITTLE_ENDIAN);
        default_map.add_reg(reg0, 0, "RW");
        default_map.add_reg(reg1, 3, "RW");

        lock_model();

    endfunction
endclass

module tb;
    RegBlock reg_block;

    initial begin
        reg_block = new("reg_block");
        reg_block.build();
    end
endmodule