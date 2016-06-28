--==============================================================================
--! @file timer.vhd
--==============================================================================

--------------------------------------------------------------------------------
--! @brief
--! VHDL Core that implements a basic logic for a timer
--------------------------------------------------------------------------------
--! @details
--!
--------------------------------------------------------------------------------
--! @version
--! 0.1 | ft | June 28, 2016
--!
--! @author
--! ft : Felipe Torres González(felipetg<AT>ugr.es) - UGR
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;     -- std_logic definitions
use IEEE.NUMERIC_STD.all;        -- conversion functions
use IEEE.STD_LOGIC_UNSIGNED.all; -- unsigned integer values

ENTITY wb_timer IS
GENERIC
(
    g_BUS_DATA_SIZE : INTEGER := 32
);
PORT
(
    clk_i   : IN STD_LOGIC;
    rst_n_i   : IN STD_LOGIC;

    cnt_o   : out STD_LOGIC_VECTOR(g_BUS_DATA_SIZE-1 DOWNTO 0);
    start_i : IN STD_LOGIC;
    stop_i  : IN STD_LOGIC;
    rst_i   : IN STD_LOGIC;
    counting_o : OUT STD_LOGIC;
    overflow_o : OUT STD_LOGIC
);
END wb_timer;
ARCHITECTURE rtl of wb_timer IS
    CONSTANT zeroes : UNSIGNED(g_BUS_DATA_SIZE-1 DOWNTO 0) := (OTHERS=>'0');
    CONSTANT max    : INTEGER := 4294967295;
    SIGNAL reg_cnt  : STD_LOGIC_VECTOR(g_BUS_DATA_SIZE-1 DOWNTO 0 ) := (OTHERS>='0');
    SIGNAL int_en   : STD_LOGIC := '0';
    SIGNAL int_stop : STD_LOGIC := '1';
BEGIN

    ctrl: PROCESS(clk_i)
    BEGIN
        IF rising_edge(clk_i) THEN
            IF rst_i = '1' OR NOT rst_n_i THEN
                reg_cnt <= zeroes;
                int_en  <= '0';
                overflow_o <= '0';
                counting_o <= '0';
            ELSE
                IF UNSIGNED(reg_cnt) >= max THEN
                    overflow_o <= '1';
                ELSE
                    overflow_o <= '0';
                END IF;

                IF stop_i = '1' THEN
                    counting_o <= '0';
                    int_en     <= '0';
                ELSIF start_i = '1' AND NOT int_en THEN
                    int_en     <= '1';
                    counting_o <= '1';
                END IF;
            END IF;
        END IF;
    END ctrl;

    cnt: PROCESS(clk_i)
    BEGIN
        IF int_en = '1' THEN
            reg_cnt <= reg_cnt + "1";
    END cnt;

    cnt_o <= reg_cnt;

END rtl;
