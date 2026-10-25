-- Block-design wrapper for CTU CAN FD (APB4).
-- Adds Xilinx interface attributes so Vivado infers s_apb as one APB
-- interface (with an address segment), plus clock/reset/irq metadata.
-- Add this file to library xil_defaultlib (default), NOT ctu_can_fd_rtl,
-- then "Add Module" -> ctu_can_fd_bd.

library ieee;
use ieee.std_logic_1164.all;

library ctu_can_fd_rtl;

entity ctu_can_fd_top_apb_wrapper is
    generic(
        G_RX_BUF_SIZE     : natural range 32 to 4096 := 128;
        G_TXT_BUF_COUNT   : natural range 2 to 8     := 4;
        G_FILT_A_EN       : boolean                  := false;
        G_FILT_B_EN       : boolean                  := false;
        G_FILT_C_EN       : boolean                  := false;
        G_FILT_RANGE_EN   : boolean                  := false;
        G_TEST_REGS_EN    : boolean                  := true;
        G_TRAFFIC_CTRS_EN : boolean                  := false;
        G_PARITY_EN       : boolean                  := false;
        G_ACTIVE_TS_BITS  : natural range 0 to 63    := 63;
        G_RESET_BUF_RAMS  : boolean                  := false
    );
    port(
        aclk             : in  std_logic;
        arstn            : in  std_logic;
        scan_mode        : in  std_logic;
        rst_n_out        : out std_logic;

        irq              : out std_logic;
        can_tx           : out std_logic;
        can_rx           : in  std_logic;
        timestamp        : in std_logic_vector(63 downto 0);

        -- Ports of APB4
        s_apb_paddr      : in  std_logic_vector(31 downto 0);
        s_apb_penable    : in  std_logic;
        s_apb_pprot      : in  std_logic_vector(2 downto 0);
        s_apb_prdata     : out std_logic_vector(31 downto 0);
        s_apb_pready     : out std_logic;
        s_apb_psel       : in  std_logic;
        s_apb_pslverr    : out std_logic;
        s_apb_pstrb      : in  std_logic_vector(3 downto 0);
        s_apb_pwdata     : in  std_logic_vector(31 downto 0);
        s_apb_pwrite     : in  std_logic
    );
end entity ctu_can_fd_top_apb_wrapper;

architecture rtl of ctu_can_fd_top_apb_wrapper is
    begin
    
end architecture;
   