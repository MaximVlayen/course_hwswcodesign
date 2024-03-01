################################################################################
# Emerging technologies, Systems & Security
#
#   date: January 15th 2024
#   author: VlJo
#   edited: February 29th 2024
#   editor: VlMa
################################################################################
# Script to generate a Vivado project for HW/SW codesign (100)
#
################################################################################

# set parameters
set pname "hwswcodesign_200"
set srcpath "~/Documents/HWSW-codesign/course_hwswcodesign_repo_mv/src/200"
set projpath "~/Documents/HWSW-codesign/sandbox"
set part "xc7z020clg400-1"
set board "tul.com.tw:pynq-z2:part0:1.0"

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
add_files $srcpath/hdl/hwswcd_hd.vhd 

# add testbench
add_files -fileset sim_1 $srcpath/hdl/picorv32_testbench_hd.vhd

# set testbench Top
set_property top picorv32_testbench_hd [get_filesets sim_1]

