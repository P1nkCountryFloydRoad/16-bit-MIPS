IVERILOG = iverilog
VVP      = vvp
FLAGS    = -g2012 -I src/

.PHONY: all assemble test_alu test_adder test_sign_ext test_mux2 test_datapath test_cpu clean

all: test_alu test_adder test_sign_ext test_mux2 test_datapath test_cpu

assemble:
	python3 assembler.py

test_alu: alu.vvp
	$(VVP) alu.vvp

alu.vvp: src/alu.sv tb/tb_alu.sv
	$(IVERILOG) $(FLAGS) -o alu.vvp tb/tb_alu.sv src/alu.sv

test_adder: adder.vvp
	$(VVP) adder.vvp

adder.vvp: src/adder.sv tb/tb_adder.sv
	$(IVERILOG) $(FLAGS) -o adder.vvp tb/tb_adder.sv src/adder.sv

test_sign_ext: sign_ext.vvp
	$(VVP) sign_ext.vvp

sign_ext.vvp: src/sign_ext.sv tb/tb_sign_ext.sv
	$(IVERILOG) $(FLAGS) -o sign_ext.vvp tb/tb_sign_ext.sv src/sign_ext.sv

test_mux2: mux2.vvp
	$(VVP) mux2.vvp

mux2.vvp: src/mux2.sv tb/tb_mux2.sv
	$(IVERILOG) $(FLAGS) -o mux2.vvp tb/tb_mux2.sv src/mux2.sv

DATAPATH_SRCS = src/datapath.sv src/pc.sv src/alu.sv src/adder.sv \
                src/sign_ext.sv src/sign_ext_12.sv src/mux2.sv \
                src/imem.sv src/dmem.sv src/regfile.sv

test_datapath: datapath.vvp
	$(VVP) datapath.vvp

datapath.vvp: $(DATAPATH_SRCS) tb/tb_datapath.sv
	$(IVERILOG) $(FLAGS) -o datapath.vvp tb/tb_datapath.sv $(DATAPATH_SRCS)

CPU_SRCS = src/cpu.sv src/controller.sv src/maindec.sv src/aludec.sv \
           $(DATAPATH_SRCS)

test_cpu: cpu.vvp
	$(VVP) cpu.vvp

cpu.vvp: $(CPU_SRCS) tb/tb_cpu.sv
	$(IVERILOG) $(FLAGS) -o cpu.vvp tb/tb_cpu.sv $(CPU_SRCS)

clean:
	rm -f *.vvp *.vcd
