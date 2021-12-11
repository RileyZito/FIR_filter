# -Wall turns on all warnings
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -g2012 -Wall -y ./ -I ./
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source

SRCS=clk_divider.sv fir_n.sv test_fir_n.sv tapped_delay_block.sv register.sv

# Look up .PHONY rules for Makefiles
.PHONY: clean submission remove_solutions

test_fir_n: ${SRCS}
	${IVERILOG} $^ -o test_fir_n.bin && ${VVP} test_fir_n.bin ${VVP_POST} | python3 parse_output.py

# main.bit: main.sv $(MAIN_SRCS) memories/ili9341_init.memh build.tcl
# 	@echo "########################################"
# 	@echo "#### Building FPGA bitstream        ####"
# 	@echo "########################################"
# 	${VIVADO} build.tcl

# program_fpga_vivado: main.bit build.tcl program.tcl
# 	@echo "########################################"
# 	@echo "#### Programming FPGA (Vivado)      ####"
# 	@echo "########################################"
# 	${VIVADO} program.tcl

# program_fpga_digilent: main.bit build.tcl
# 	@echo "########################################"
# 	@echo "#### Programming FPGA (Digilent)    ####"
# 	@echo "########################################"
# 	djtgcfg enum
# 	djtgcfg prog -d CmodA7 -i 0 -f main.bit


# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml
	rm -r results
