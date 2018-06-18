onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_pipelined_mips_tb/pipelined_mips_pu/clk
add wave -noupdate /a_pipelined_mips_tb/pipelined_mips_pu/reset
add wave -noupdate -radix unsigned /a_pipelined_mips_tb/pipelined_mips_pu/dp/local_branch_predictor/pc_f
add wave -noupdate -radix unsigned /a_pipelined_mips_tb/pipelined_mips_pu/dp/pc_d
add wave -noupdate -radix unsigned /a_pipelined_mips_tb/pipelined_mips_pu/dp/local_branch_predictor/pc_e
add wave -noupdate -radix unsigned /a_pipelined_mips_tb/pipelined_mips_pu/dp/instr_f
add wave -noupdate -radix unsigned /a_pipelined_mips_tb/pipelined_mips_pu/dp/instr_d
add wave -noupdate -radix binary /a_pipelined_mips_tb/pipelined_mips_pu/dp/local_branch_predictor/branch_found_EXE
add wave -noupdate -radix binary /a_pipelined_mips_tb/pipelined_mips_pu/dp/local_branch_predictor/branch_taken_EXE
add wave -noupdate -radix unsigned {/a_pipelined_mips_tb/pipelined_mips_pu/dp/local_branch_predictor/branch_pc[12]}
add wave -noupdate -radix unsigned {/a_pipelined_mips_tb/pipelined_mips_pu/dp/local_branch_predictor/predict_pc[12]}
add wave -noupdate {/a_pipelined_mips_tb/pipelined_mips_pu/dp/local_branch_predictor/predict_state[12]}
add wave -noupdate -radix unsigned /a_pipelined_mips_tb/pipelined_mips_pu/dp/local_branch_predictor/mispredict_pc_e
add wave -noupdate -radix unsigned {/a_pipelined_mips_tb/pipelined_mips_pu/dp/rf_ID/rf[1]}
add wave -noupdate -radix unsigned {/a_pipelined_mips_tb/pipelined_mips_pu/dp/rf_ID/rf[4]}
add wave -noupdate -radix unsigned {/a_pipelined_mips_tb/pipelined_mips_pu/dp/rf_ID/rf[8]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {240 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 270
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {565 ps} {697 ps}
