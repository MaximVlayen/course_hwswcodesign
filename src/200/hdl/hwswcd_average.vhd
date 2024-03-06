----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Maxim Vlayen
-- 
-- Create Date: 29.02.2024 15:05:22
-- Design Name: 
-- Module Name: hwswcd_average - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Coprocessor that calculates the average of two inputs (rounded down)
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

entity hwswcd_average is
    port (
            resetn : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            pcpi_valid : IN STD_LOGIC;
            pcpi_insn : IN STD_LOGIC_VECTOR(32-1 downto 0);
            pcpi_rs1 : IN STD_LOGIC_VECTOR(32-1 downto 0);
            pcpi_rs2 : IN STD_LOGIC_VECTOR(32-1 downto 0);
            pcpi_wr : OUT STD_LOGIC;
            pcpi_rd : OUT STD_LOGIC_VECTOR(32-1 downto 0);
            pcpi_wait : OUT STD_LOGIC;
            pcpi_ready : OUT STD_LOGIC
        );
end hwswcd_average;

architecture Behavioural of hwswcd_average is

    component ripple_carry_adder is 
        port(
            A_vector : in std_logic_vector(31 downto 0);
            B_vector : in std_logic_vector(31 downto 0);
            carry_in : in std_logic;
            S_vector : out std_logic_vector(31 downto 0);
            carry_out: out std_logic
        );
    end component;

    -- localised inputs
    signal resetn_i : STD_LOGIC;
    signal clock_i : STD_LOGIC;
    signal pcpi_valid_i : STD_LOGIC;
    signal pcpi_insn_i : STD_LOGIC_VECTOR(32-1 downto 0);
    signal pcpi_rs1_i : STD_LOGIC_VECTOR(32-1 downto 0);
    signal pcpi_rs2_i : STD_LOGIC_VECTOR(32-1 downto 0);
    signal pcpi_wr_i : STD_LOGIC;
    signal pcpi_rd_i : STD_LOGIC_VECTOR(32-1 downto 0);
    signal pcpi_wait_i : STD_LOGIC;
    signal pcpi_ready_i : STD_LOGIC;

    signal isArith, isMul, isValid, finished, carry_out : STD_LOGIC;
    signal calculating, calculating_set, calculating_reset : STD_LOGIC;
    signal pointer : STD_LOGIC_VECTOR(31 downto 0);
    signal operand_x, operand_y, sum, average : STD_LOGIC_VECTOR(31 downto 0);
    
begin

    -------------------------------------------------------------------------------
    -- (DE-)LOCALISING IN/OUTPUTS
    -------------------------------------------------------------------------------
    resetn_i <= resetn;
    clock_i <= clk;
    pcpi_valid_i <= pcpi_valid;
    pcpi_insn_i <= pcpi_insn;
    pcpi_rs1_i <= pcpi_rs1;
    pcpi_rs2_i <= pcpi_rs2;
    pcpi_wr <= pcpi_wr_i;
    pcpi_rd <= pcpi_rd_i;
    pcpi_wait <= pcpi_wait_i;
    pcpi_ready <= pcpi_ready_i;

    -------------------------------------------------------------------------------
    -- COMBINATORIAL
    -------------------------------------------------------------------------------
    isArith <= '1' when pcpi_insn_i(6 downto 0) = "0110011" else '0';                                           -- check if correct opcode
    isMul <= '1' when (pcpi_insn_i(31 downto 25) = "0000001" and pcpi_insn_i(14 downto 12) = "000") else '0';   -- check if correct funct7 and funct3 
    
    calculating_set <= pcpi_valid_i and not(calculating) and isArith and isMul and not(finished);
    calculating_reset <= pointer(0) and not pointer(1) and calculating;

    pcpi_wait_i <= calculating;
    pcpi_wr_i <= finished;          
    pcpi_rd_i <= average;
    pcpi_ready_i <= finished;
    
    ripple_carry_adder_instance00: component ripple_carry_adder
        port map(
            A_vector => operand_x,
            B_vector => operand_y,
            carry_in => '0',
            S_vector => sum,
            carry_out => carry_out
        );
    
    -------------------------------------------------------------------------------
    -- SEQUENTIAL
    -------------------------------------------------------------------------------
    PREG: process(resetn_i, clock_i)
    begin
        if resetn_i = '0' then
            operand_x <= (others => '0');
            operand_y <= (others => '0');
            pointer <= (others => '1');
            average <= (others => '0');
            calculating <= '0';
            finished <= '0';
        elsif rising_edge(clock_i) then 
            if calculating_set = '1' then 
                operand_x <= pcpi_rs1_i;
                operand_y <= pcpi_rs2_i;
                pointer <= (others => '1');
                average <= (others => '0');
            elsif calculating = '1' then 
                pointer <= '0' & pointer(pointer'high downto 1);
                average(30 downto 0) <= sum(31 downto 1);   -- divide sum by 2 (shift right)
                average(31) <= carry_out;                   -- include carry to get final average
            end if;
            if calculating_reset = '1' then 
                calculating <= '0';
            elsif calculating_set = '1' then 
                calculating <= '1';
            end if;
            finished <= calculating_reset;
        end if;
    end process;
    
----------------------------
   -- Vorige code 
----------------------------    
--    PREG: process(resetn_i, clock_i)
--    begin
--        if resetn_i = '0' then                  -- reset is actief laag
--            operand_x <= (others => '0');
--            operand_y <= (others => '0');
--            finished <= '0';
--        elsif rising_edge(clock_i) then 
--            if isValid = '1' then 
--                operand_x <= pcpi_rs1_i;
--                operand_y <= pcpi_rs2_i;
--            end if;
--            finished <= '1';
--       end if;
--    end process;

end Behavioural;
