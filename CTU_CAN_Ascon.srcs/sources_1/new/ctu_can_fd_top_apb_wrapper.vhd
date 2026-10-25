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
    -- Attribure definiton for interface mapping

    attribute X_INTERFACE_INFO      : string;
    attribute X_INTERFACE_PARAMETER : string;
 
    attribute X_INTERFACE_INFO      of aclk : signal is "xilinx.com:signal:clock:1.0 aclk CLK";
    attribute X_INTERFACE_PARAMETER of aclk : signal is "ASSOCIATED_BUSIF s_apb, ASSOCIATED_RESET arstn";
 
    attribute X_INTERFACE_INFO      of arstn : signal is "xilinx.com:signal:reset:1.0 arstn RST";
    attribute X_INTERFACE_PARAMETER of arstn : signal is "POLARITY ACTIVE_LOW";
 
    attribute X_INTERFACE_INFO      of irq : signal is "xilinx.com:signal:interrupt:1.0 irq INTERRUPT";
    attribute X_INTERFACE_PARAMETER of irq : signal is "SENSITIVITY LEVEL_HIGH";
 
    attribute X_INTERFACE_INFO of s_apb_paddr   : signal is "xilinx.com:interface:apb:1.0 s_apb PADDR";
    attribute X_INTERFACE_INFO of s_apb_penable : signal is "xilinx.com:interface:apb:1.0 s_apb PENABLE";
    attribute X_INTERFACE_INFO of s_apb_pprot   : signal is "xilinx.com:interface:apb:1.0 s_apb PPROT";
    attribute X_INTERFACE_INFO of s_apb_prdata  : signal is "xilinx.com:interface:apb:1.0 s_apb PRDATA";
    attribute X_INTERFACE_INFO of s_apb_pready  : signal is "xilinx.com:interface:apb:1.0 s_apb PREADY";
    attribute X_INTERFACE_INFO of s_apb_psel    : signal is "xilinx.com:interface:apb:1.0 s_apb PSEL";
    attribute X_INTERFACE_INFO of s_apb_pslverr : signal is "xilinx.com:interface:apb:1.0 s_apb PSLVERR";
    attribute X_INTERFACE_INFO of s_apb_pstrb   : signal is "xilinx.com:interface:apb:1.0 s_apb PSTRB";
    attribute X_INTERFACE_INFO of s_apb_pwdata  : signal is "xilinx.com:interface:apb:1.0 s_apb PWDATA";
    attribute X_INTERFACE_INFO of s_apb_pwrite  : signal is "xilinx.com:interface:apb:1.0 s_apb PWRITE";

    begin
        -- CTU CAN FD APB wrapper
        i_can : entity ctu_can_fd_rtl.ctu_can_fd_top_apb
        generic map(
            G_RX_BUF_SIZE     => G_RX_BUF_SIZE,
            G_TXT_BUF_COUNT   => G_TXT_BUF_COUNT,
            G_FILT_A_EN       => G_FILT_A_EN,
            G_FILT_B_EN       => G_FILT_B_EN,
            G_FILT_C_EN       => G_FILT_C_EN,
            G_FILT_RANGE_EN   => G_FILT_RANGE_EN,
            G_TEST_REGS_EN    => G_TEST_REGS_EN,
            G_TRAFFIC_CTRS_EN => G_TRAFFIC_CTRS_EN,
            G_PARITY_EN       => G_PARITY_EN,
            G_ACTIVE_TS_BITS  => G_ACTIVE_TS_BITS,
            G_RESET_BUF_RAMS  => G_RESET_BUF_RAMS
        )
        port map(
            aclk          => aclk,
            arstn         => arstn,
            scan_mode     => scan_mode,
            rst_n_out     => rst_n_out,
            irq           => irq,
            can_tx        => can_tx,
            can_rx        => can_rx,
            timestamp     => timestamp,
            s_apb_paddr   => s_apb_paddr,
            s_apb_penable => s_apb_penable,
            s_apb_pprot   => s_apb_pprot,
            s_apb_prdata  => s_apb_prdata,
            s_apb_pready  => s_apb_pready,
            s_apb_psel    => s_apb_psel,
            s_apb_pslverr => s_apb_pslverr,
            s_apb_pstrb   => s_apb_pstrb,
            s_apb_pwdata  => s_apb_pwdata,
            s_apb_pwrite  => s_apb_pwrite
        );
end architecture rtl;
   