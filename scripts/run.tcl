# gtkwave waves/waves.vcd
# vsim -c
# do "scripts/run.tcl"
vlib work
vlog +incdir+./interface -f "scripts/list.list" -mfcu +cover -covercells
# Enable the transcript (even in the compile version of questa sim)
transcript on
transcript file scripts/uvm_transcript.log
# Start Simulation
vsim -voptargs=+acc -sv_lib design/FIFO_design/golden_model_c work.tb_top -cover -classdebug -uvmcontrol=all

log -r /*
# Add signals to the wave window
add wave /tb_top/DUT/*

# Code Coverage
coverage save top.ucdb -onexit -du work.priority_fifo

vcd file waves/waves.vcd
vcd add -r /* 
run -all
# Disable the transcript
transcript off
vcd flush

# Functional Coverage Report
coverage report -detail -cvg -directive  \
    -output "reports/Functional Coverage Report.txt" \
    /FIFO_coverage_pkg/FIFO_coverage/*
quit -sim
# Save Coverage Report
vcover report top.ucdb -details -annotate -all -output "reports/Coverage Report - Code, Assertions, and Directives.txt"