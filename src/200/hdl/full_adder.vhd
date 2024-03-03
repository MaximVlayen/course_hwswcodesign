----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Maxim Vlayen
-- 
-- Create Date: 02.03.2024 14:44:19
-- Design Name: 
-- Module Name: full_adder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity full_adder is
    Port (
            A: in std_logic;
            B: in std_logic;
            Cin: in std_logic;
            Cout: out std_logic;
            S: out std_logic
    );
end entity full_adder;
    
architecture Behavioral of full_adder is

    signal tussenresultaat1: std_logic;
    signal tussenresultaat2: std_logic;
    signal tussenresultaat3: std_logic;
    
begin

    tussenresultaat1 <= A xor B;
    S <= tussenresultaat1 xor Cin;
    tussenresultaat2 <= Cin and tussenresultaat1;
    tussenresultaat3 <= A and B;
    Cout <= tussenresultaat2 or tussenresultaat3;
    
end Behavioral;