IVERILOG = iverilog
VVP      = vvp
FLAGS    = -g2012

.PHONY: test_alu test_adder clean

test_alu: alu.vvp
	$(VVP) alu.vvp

alu.vvp: src/alu.sv tb/tb_alu.sv
	$(IVERILOG) $(FLAGS) -o alu.vvp tb/tb_alu.sv src/alu.sv

test_adder: adder.vvp
	$(VVP) adder.vvp

adder.vvp: src/adder.sv tb/tb_adder.sv
	$(IVERILOG) $(FLAGS) -o adder.vvp tb/tb_adder.sv src/adder.sv

clean:
	rm -f *.vvp *.vcd
