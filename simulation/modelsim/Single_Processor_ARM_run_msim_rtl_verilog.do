transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/file\ TKS_VXL/Single_processor_ARM {D:/file TKS_VXL/Single_processor_ARM/ALU.sv}

vlog -sv -work work +incdir+D:/file\ TKS_VXL/Single_processor_ARM {D:/file TKS_VXL/Single_processor_ARM/tb_ALU.sv}
vlog -sv -work work +incdir+D:/file\ TKS_VXL/Single_processor_ARM {D:/file TKS_VXL/Single_processor_ARM/ALU.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  tb_ALU

add wave *
view structure
view signals
run -all
