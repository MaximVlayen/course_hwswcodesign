----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Maxim Vlayen
-- 
-- Create Date: 02.03.2024 14:48:08
-- Design Name: 
-- Module Name: ripple_carry_adder - Behavioral
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

entity ripple_carry_adder is
    Port (
        A_vector : in std_logic_vector(31 downto 0);
        B_vector : in std_logic_vector(31 downto 0);
        carry_in : in std_logic;
        S_vector : out std_logic_vector(31 downto 0);
        carry_out: out std_logic
    );
end entity ripple_carry_adder;

architecture Behavioral of ripple_carry_adder is

    constant number_of_bits: integer := 32; 
    signal carry_vector: std_logic_vector(number_of_bits downto 0) := (others => '0');

    component full_adder is
        Port (
            A: in std_logic;
            B: in std_logic;
            Cin: in std_logic;
            S: out std_logic;
            Cout: out std_logic
         );
     end component;
        
begin
    
    carry_vector(0) <= carry_in;
    carry_out <= carry_vector(number_of_bits);
    
    GEN : for i in 0 to (number_of_bits - 1) generate
        FA: component full_adder
            port map(
                A => A_vector(i),
                B => B_vector(i),
                Cin => carry_vector(i),
                S => S_vector(i),
                Cout => carry_vector(i+1)
            );
    end generate;

end Behavioral;
