# CTU CAN Ascon – Vivado project

Vivado **2025.2.1** hardware design for the Digilent **Arty Z7-20** (`xc7z020clg400-1`):
the [CTU CAN FD](https://github.com/Logic-Design-Services/CTU-CAN-FD) controller on the
Zynq PS through AXI → APB, as the base for CAN FD + Ascon work.

The firmware (Vitis platform + bare-metal app) is a separate repo:
`../../Vitis_Workspaces` → `CTU_CAN_FD_ILA` / `CTU_CAN_FD_ILA_Firmware`.

## Block design (`CAN_System`)

```
PS7 M_AXI_GP0 → SmartConnect → AXI APB Bridge (APB4) → ctu_can_fd_top_apb_wrapper
```

| Item | Value |
|---|---|
| CAN core base address | `0x43C0_0000` (64 KB) |
| Clock | `FCLK_CLK0` = 100 MHz for everything |
| Reset | `rst_ps7_0_100M` → `peripheral_aresetn` (core, bridge), `interconnect_aresetn` (SmartConnect) |
| Interrupt | CAN `irq` → `IRQ_F2P[0]` (GIC ID 61) |
| CAN bus | `can_tx` wired to `can_rx` inside the PL (no transceiver) |
| `scan_mode`, `timestamp` | tied to 0 |
| ILA | `ila_0` on `can_tx` |

The firmware runs the core in self-test + internal loopback mode.

## What is in git

| Path | What it is |
|---|---|
| `CTU_CAN_Ascon.xpr` | Vivado project |
| `CTU_CAN_Ascon.srcs/sources_1/new/ctu_can_fd_top_apb_wrapper.vhd` | Wrapper adding Xilinx interface attributes, so the block design sees `s_apb` as one APB bus plus clock/reset/interrupt pins |
| `CTU_CAN_Ascon.srcs/sources_1/bd/CAN_System/` | Block design (`.bd`, `.bda`, `ui/`) and each IP's `.xci` |
| `external/CTU-CAN-FD` | CTU CAN FD, git submodule |
| `project.sigasi` | Sigasi project file |

Everything Vivado regenerates (`.runs`, `.gen`, `.cache`, IP output products, `.xsa`,
`.bit`, `.ltx`, …) is ignored. See `.gitignore`.

## Notes

- **Library:** all CTU CAN FD sources must be compiled into the VHDL library
  `ctu_can_fd_rtl`. The wrapper stays in `xil_defaultlib`.
- **The packaged IP isn't used.** The upstream `src/component.xml` is stale (wrong top entity and
  generic names), so the core is added as a module reference through the wrapper.
- **APB4:** the bridge must be set to APB4. With APB3, `pstrb` is tied to 0 and every
  register write is silently dropped.
- **Timing:** at 100 MHz the design meets timing with the `Performance_ExtraTimingOpt`
  implementation strategy. The near-critical path is `BTR_FD` → bit-timing segment
  meter. A multicycle path from the `BTR`/`BTR_FD` registers is safe if needed, because
  they're write-locked while the core is enabled.

## Rebuilding from a clean clone

```bat
git clone --recurse-submodules https://github.com/danalexandru26/CTU_CAN_Ascon
```

1. Open `CTU_CAN_Ascon.xpr` in Vivado 2025.2.
2. Generate Bitstream. The block design output products are regenerated automatically.
3. `File > Export > Export Hardware` (include bitstream), then update the `.xsa` in the
   Vitis repo (see its README).

> **Path warning:** the project currently points at CTU CAN FD sources in
> `D:\CTU-CAN-FD\src` and at the XDC in `..\..\Arty-Z7-20-Master.xdc`, both outside this
> repo. Re-add the sources from `external/CTU-CAN-FD/src` (library `ctu_can_fd_rtl`) and
> copy the XDC into the repo before relying on a clean clone.
