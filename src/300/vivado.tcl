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
add_files $srcpath/hdl/soc/PKG_hwswcodesign.vhd
add_files $srcpath/hdl/soc/soc.vhd 
add_files $srcpath/hdl/picorv32/picorv32.v 
add_files $srcpath/hdl/picorv32/picorv32_apb_adapter.vhd
add_files $srcpath/hdl/fblocks/picorv32_mem_model.vhd




# import source files
import_files -norecurse /home/jvliegen/vc/github/trustediot/src/hdl/dev/ip_core_ehsm/ehsm_axi4_v1_0.vhd 
import_files -norecurse /home/jvliegen/vc/github/trustediot/src/hdl/dev/ip_core_ehsm/ehsm_axi4_v1_0_S00_AXI.vhd 
import_files -norecurse /home/jvliegen/vc/github/trustediot/src/hdl/dev/ip_core_ehsm/ehsm_core.vhd

# create IP cores
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name ICAP_firmware_store
set_property -dict [list CONFIG.Component_Name {ICAP_firmware_store} CONFIG.Memory_Type {Simple_Dual_Port_RAM} CONFIG.Assume_Synchronous_Clk {true} CONFIG.Write_Width_A {36} CONFIG.Write_Depth_A {512} CONFIG.Read_Width_A {36} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Enable_A {Always_Enabled} CONFIG.Write_Width_B {36} CONFIG.Read_Width_B {36} CONFIG.Operating_Mode_B {READ_FIRST} CONFIG.Enable_B {Always_Enabled} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {true} CONFIG.Load_Init_File {true} CONFIG.Coe_File {/home/jvliegen/vc/github/trustediot/src/hdl/dev/ip_core_ehsm/apb_ehsm_icap_firmware_store.coe} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Enable_Rate {100}] [get_ips ICAP_firmware_store]
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.Enable_B {Always_Enabled} CONFIG.Register_PortA_Output_of_Memory_Primitives {true} CONFIG.Port_B_Write_Rate {50}] [get_ips ICAP_firmware_store]
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name icap_buffer
set_property -dict [list CONFIG.Component_Name {icap_buffer} CONFIG.Performance_Options {First_Word_Fall_Through} CONFIG.Input_Data_Width {34} CONFIG.Output_Data_Width {34} CONFIG.Reset_Type {Synchronous_Reset} CONFIG.Full_Flags_Reset_Value {1} CONFIG.Almost_Empty_Flag {true} CONFIG.Use_Extra_Logic {true} CONFIG.Data_Count_Width {11} CONFIG.Write_Data_Count_Width {11} CONFIG.Read_Data_Count_Width {11} CONFIG.Full_Threshold_Assert_Value {1023} CONFIG.Full_Threshold_Negate_Value {1022} CONFIG.Empty_Threshold_Assert_Value {4} CONFIG.Empty_Threshold_Negate_Value {5} CONFIG.Enable_Safety_Circuit {true}] [get_ips icap_buffer]




ipx::package_project -root_dir $ippath/$pname -vendor kuleuven.be -library user -taxonomy /UserIP -import_files -set_current false
ipx::open_ipxact_file $ippath/$pname/component.xml
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::check_integrity -quiet [ipx::current_core]
ipx::archive_core $ippath/$pname/kuleuven.be_user_ehsm_axi4_v1_0_1.0.zip [ipx::current_core]
ipx::unload_core component_3

ipx::save_core [ipx::current_core]
ipx::check_integrity -quiet [ipx::current_core]
ipx::archive_core /home/jvliegen/sandbox/vivado/1_IP_COMPONENTS_v2020_02/$pname/kuleuven.be_user_ehsm_axi4_v1_0_1.0.zip [ipx::current_core]
ipx::unload_core component_1

close_project
