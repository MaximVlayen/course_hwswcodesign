################################################################################
# Emerging technologies, Systems & Security
#
#   date: January 15th 2024
#   author: VlJo
################################################################################
# Script to generate a Vivado project for HW/SW codesign (100)
#
################################################################################

# set parameters
set pname "hwswcodesign_100"
set srcpath "/home/jvliegen/vc/github/KULeuven-Diepenbeek/course_hwswcodesign/src/100"
set projpath "/home/jvliegen/sandbox/course_hwswcodesign"
set part "xc7vx485tffg1761-2"
set board "xilinx.com:vc707:part0:1.3"

# delete older versions
cd $projpath
exec rm -Rf $pname

# create project
create_project $pname $projpath/$pname -part $part
set_property board_part $board [current_project]
set_property target_language VHDL [current_project]

# add source files
add_files $srcpath/hdl/picorv32.v 
add_files $srcpath/hdl/picorv32_mem_model.vhd 

# add testbench
add_files -fileset sim_1 $srcpath/hdl/picorv32_testbench.vhd

# set testbench Top
set_property top picorv32_testbench [get_filesets sim_1]

