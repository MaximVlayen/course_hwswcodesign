----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Maxim Vlayen
-- 
-- Create Date: 02.03.2024 14:54:29
-- Design Name: 
-- Module Name: tb_rca - Behavioral
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

entity tb_rca is
--  Port ( );
end tb_rca;

architecture Behavioral of tb_rca is

component ripple_carry_adder is
  Port (A_vector : in std_logic_vector(31 downto 0);
        B_vector : in std_logic_vector(31 downto 0);
        carry_in : in std_logic;
        S_vector : out std_logic_vector(31 downto 0);
        carry_out: out std_logic 
  );
end component;

signal A_vector, B_vector, S_vector : std_logic_vector(31 downto 0);
signal carry_in, carry_out: std_logic;
signal carry_vector: std_logic_vector(32 downto 0);

begin

DUT: ripple_carry_adder port map(
    A_vector => A_vector,
    B_vector => B_vector,
    carry_in => carry_in,
    S_vector => S_vector,
    carry_out => carry_out
);

 PSTIM: process
  begin
    A_vector <= "00000000000000000000000000000000";
    B_vector <= "00000000000000000000000000000000";
    carry_in <= '0';
    wait for 10ns;
    assert (S_vector = "00000000000000000000000000000000") report "ADDER werkt niet" severity failure;
    
    A_vector <= "00000000000000000000000000000000";
    B_vector <= "00000000000000000000000000000000";
    carry_in <= '1';
    wait for 10ns;
    assert (S_vector = "00000000000000000000000000000001") report "ADDER werkt niet" severity failure;
    
    wait for 10ns;    
    A_vector <= "00000000000000000000000000000001";
    B_vector <= "00000000000000000000000000000000";
    carry_in <= '0';
    wait for 10ns;
    assert (S_vector = "00000000000000000000000000000001") report "ADDER werkt niet" severity failure;
    
    wait for 10ns;    
    A_vector <= "00000000000000000000000000000000";
    B_vector <= "00000000000000000000000000000001";
    wait for 10ns;
    assert (S_vector = "00000000000000000000000000000001") report "ADDER werkt niet" severity failure;
    
    wait for 10ns;    
    A_vector <= "00000000000000000000000000000001";
    B_vector <= "00000000000000000000000000000001";
    wait for 10ns;
    assert (S_vector = "00000000000000000000000000000010") report "ADDER werkt niet" severity failure;
    
    wait for 10ns;    
    A_vector <= "11111111111111111111111111111111";
    B_vector <= "00000000000000000000000000000001";
    wait for 10ns;
    assert (S_vector = "00000000000000000000000000000000" and carry_out = '1') report "ADDER werkt niet" severity failure;
    
    wait for 10ns;    
    A_vector <= "11111111111111111111111111111111";
    B_vector <= "10000000000000000000000000000000";
    wait for 10ns;
    assert (S_vector = "01111111111111111111111111111111" and carry_out = '1') report "ADDER werkt niet" severity failure;
    
    wait for 10ns;    
    A_vector <= "11111111111111111111111111111111";
    B_vector <= "11111111111111111111111111111111";
    wait for 10ns;
    assert (S_vector = "11111111111111111111111111111110" and carry_out = '1') report "ADDER werkt niet" severity failure;
        
    
    wait;
  end process;

end Behavioral;
