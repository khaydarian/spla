#!/usr/bin/env python3
# vi: ts=4:sw=4:sts=4:et

import sys
import os.path
ETC_DIR = os.path.join(os.path.dirname(sys.argv[0]), '../etc')
sys.path.append(ETC_DIR)
import netlist

def get_nets(top):
    return kvlookupn(top, 'export', 'nets')[0]

def get_fpga_pins(nets):
    out = {}
    for net in nets[1:]:
        pins = net_pins_for_ref(net, 'U1')
        if not pins:
            # Not connected to fpga
            continue
        if len(pins) > 1:
            # probably power / ground; ignore
            continue
        name = net_name(net)
        if name.startswith('Net-('):
            # NC on FPGA, ignore
            continue
        assert name not in out
        out[name] = pins[0]
    return out

def net_name(net):
    return kvlookup(net, 'net', 'name')

def net_pins_for_ref(net, ref):
    nodes = kvlookupn(net, 'net', 'node')
    pins = []
    for node in nodes:
        if kvlookup(node, 'node', 'ref') == ref:
            pins.append(kvlookup(node, 'node', 'pin'))
    return pins

class NoDefault(object): pass

def kvlookup(elem, first, key, default=NoDefault):
    assert elem[0] == first
    for kv in elem[1:]:
        if kv[0] == key:
            return kv[1]
    if default is NoDefault:
        raise ValueError('Missing %s.%s' % (first, key))
    return default

def kvlookupn(elem, first, key):
    assert elem[0] == first
    out = []
    for kv in elem[1:]:
        if kv[0] == key:
            out.append(kv)
    return out

def dump(expr, depth=0):
    for x in expr:
        if type(x) is list:
            dump(x, depth + 1)
        else:
            print("%s%r" % ('  '*depth, x))

LPFS = [
    ('CLK_12MHZ', 'clock_12mhz'),
    ('CLK_12MHZ', 'clock'),
    (None, None),
    ('LED_A', 'led_a'),
    ('LED_B', 'led_b'),
    ('LED_C', 'led_c'),
    ('LED_D', 'led_d'),
    (None, None),
    ('FIFO_D0', 'uart_rx'),
    ('FIFO_D1', 'uart_tx'),
    (None, None),
    ('FIFO_D0', 'fifo_d_0'),
    ('FIFO_D1', 'fifo_d_1'),
    ('FIFO_D2', 'fifo_d_2'),
    ('FIFO_D3', 'fifo_d_3'),
    ('FIFO_D4', 'fifo_d_4'),
    ('FIFO_D5', 'fifo_d_5'),
    ('FIFO_D6', 'fifo_d_6'),
    ('FIFO_D7', 'fifo_d_7'),
    (None, None),
    ('FIFO_D0', 'fifo_d[0]'),
    ('FIFO_D1', 'fifo_d[1]'),
    ('FIFO_D2', 'fifo_d[2]'),
    ('FIFO_D3', 'fifo_d[3]'),
    ('FIFO_D4', 'fifo_d[4]'),
    ('FIFO_D5', 'fifo_d[5]'),
    ('FIFO_D6', 'fifo_d[6]'),
    ('FIFO_D7', 'fifo_d[7]'),
    ('FIFO_~RXF~', 'fifo_rxf_n'),
    ('FIFO_~TXE~', 'fifo_txe_n'),
    ('FIFO_~RD~', 'fifo_rd_n'),
    ('FIFO_~WR~', 'fifo_wr_n'),
    ('FIFO_SIWU', 'fifo_siwu'),
    ('FIFO_CLKOUT', 'fifo_clkout'),
    ('FIFO_~OE~', 'fifo_oe_n'),
    (None, None),
    ('USB_~PWREN~', 'usb_pwren_n'),
    ('USB_~SUSPEND~', 'usb_suspend_n'),
    (None, None),
    ('FPGA_XIN', 'xin'),
    ('FPGA_PPU1_~RESET~', 'ppu1_reset_n'),
    ('FPGA_PPU2_~RESET~', 'ppu2_reset_n'),
    ('FPGA_PPU2_~RESOUT0~', 'ppu2_resout0_n'),
    ('FPGA_PPU2_~RESOUT1~', 'ppu2_resout1_n'),
    (None, None),
    ('FPGA_~BURST~', 'burst_n'),
    ('FPGA_~CSYNC~', 'csync_n'),
    ('FPGA_PPU2_HBLANK', 'hblank'),
    ('FPGA_PPU2_VBLANK', 'vblank'),
    (None, None),
    ('FPGA_~PARD~', 'pard_n'),
    ('FPGA_~PAWR~', 'pawr_n'),
    ('LVL_PA_DIR', 'lvl_pa_dir'),
    ('FPGA_PA0', 'pa[0]'),
    ('FPGA_PA1', 'pa[1]'),
    ('FPGA_PA2', 'pa[2]'),
    ('FPGA_PA3', 'pa[3]'),
    ('FPGA_PA4', 'pa[4]'),
    ('FPGA_PA5', 'pa[5]'),
    ('FPGA_PA6', 'pa[6]'),
    ('FPGA_PA7', 'pa[7]'),
    ('LVL_PD_DIR', 'lvl_pd_dir'),
    ('FPGA_D0', 'pd[0]'),
    ('FPGA_D1', 'pd[1]'),
    ('FPGA_D2', 'pd[2]'),
    ('FPGA_D3', 'pd[3]'),
    ('FPGA_D4', 'pd[4]'),
    ('FPGA_D5', 'pd[5]'),
    ('FPGA_D6', 'pd[6]'),
    ('FPGA_D7', 'pd[7]'),
    (None, None),
    ('FGPA_~VRD~', 'vrd_n'),
    ('FPGA_~VAWR~', 'vawr_n'),
    ('FPGA_~VBWR~', 'vbwr_n'),
    (None, None),
    ('LVL_VA_DIR', 'lvl_va_dir'),
    ('FPGA_VA14', 'va14'),
    ('FPGA_VAA0', 'vaa[0]'),
    ('FPGA_VAA1', 'vaa[1]'),
    ('FPGA_VAA2', 'vaa[2]'),
    ('FPGA_VAA3', 'vaa[3]'),
    ('FPGA_VAA4', 'vaa[4]'),
    ('FPGA_VAA5', 'vaa[5]'),
    ('FPGA_VAA6', 'vaa[6]'),
    ('FPGA_VAA7', 'vaa[7]'),
    ('FPGA_VAA8', 'vaa[8]'),
    ('FPGA_VAA9', 'vaa[9]'),
    ('FPGA_VAA10', 'vaa[10]'),
    ('FPGA_VAA11', 'vaa[11]'),
    ('FPGA_VAA12', 'vaa[12]'),
    ('FPGA_VAA13', 'vaa[13]'),
    ('FPGA_VAB0', 'vab[0]'),
    ('FPGA_VAB1', 'vab[1]'),
    ('FPGA_VAB2', 'vab[2]'),
    ('FPGA_VAB3', 'vab[3]'),
    ('FPGA_VAB4', 'vab[4]'),
    ('FPGA_VAB5', 'vab[5]'),
    ('FPGA_VAB6', 'vab[6]'),
    ('FPGA_VAB7', 'vab[7]'),
    ('FPGA_VAB8', 'vab[8]'),
    ('FPGA_VAB9', 'vab[9]'),
    ('FPGA_VAB10', 'vab[10]'),
    ('FPGA_VAB11', 'vab[11]'),
    ('FPGA_VAB12', 'vab[12]'),
    ('FPGA_VAB13', 'vab[13]'),
    (None, None),
    ('LVL_VD_DIR', 'lvl_vd_dir'),
    ('FPGA_VDA0', 'vda[0]'),
    ('FPGA_VDA1', 'vda[1]'),
    ('FPGA_VDA2', 'vda[2]'),
    ('FPGA_VDA3', 'vda[3]'),
    ('FPGA_VDA4', 'vda[4]'),
    ('FPGA_VDA5', 'vda[5]'),
    ('FPGA_VDA6', 'vda[6]'),
    ('FPGA_VDA7', 'vda[7]'),
    ('FPGA_VDB0', 'vdb[0]'),
    ('FPGA_VDB1', 'vdb[1]'),
    ('FPGA_VDB2', 'vdb[2]'),
    ('FPGA_VDB3', 'vdb[3]'),
    ('FPGA_VDB4', 'vdb[4]'),
    ('FPGA_VDB5', 'vdb[5]'),
    ('FPGA_VDB6', 'vdb[6]'),
    ('FPGA_VDB7', 'vdb[7]'),
    (None, None),
    ('FPGA_FIELD', 'field'),
    ('FPGA_~OVER~', 'over_n'),
    ('FPGA_~5M~', 'ppu_5m'),
    ('FPGA_~HCLD', 'hcld_n'),
    ('FPGA_~VCLD~', 'vcld_n'),
    ('FPGA_COLOR0', 'color[0]'),
    ('FPGA_COLOR1', 'color[1]'),
    ('FPGA_COLOR2', 'color[2]'),
    ('FPGA_PRIO0', 'prio[0]'),
    ('FPGA_PRIO1', 'prio[1]'),
    ('FPGA_CHR0', 'chr[0]'),
    ('FPGA_CHR1', 'chr[1]'),
    ('FPGA_CHR2', 'chr[2]'),
    ('FPGA_CHR3', 'chr[3]'),
    (None, None),
    ('LVL_TST_DIR', 'lvl_tst_dir'),
    ('LVL_TST_~OE~', 'lvl_tst_oe'),
    ('FGPA_PPU2_TST15', 'ppu2_tst15'),
    ('FGPA_PPU2_TST0', 'ppu2_tst[0]'),
    ('FGPA_PPU2_TST1', 'ppu2_tst[1]'),
    ('FGPA_PPU2_TST2', 'ppu2_tst[2]'),
    ('FGPA_PPU2_TST3', 'ppu2_tst[3]'),
    ('FGPA_PPU2_TST4', 'ppu2_tst[4]'),
    ('FGPA_PPU2_TST5', 'ppu2_tst[5]'),
    ('FGPA_PPU2_TST6', 'ppu2_tst[6]'),
    ('FGPA_PPU2_TST7', 'ppu2_tst[7]'),
    ('FGPA_PPU2_TST8', 'ppu2_tst[8]'),
    ('FGPA_PPU2_TST9', 'ppu2_tst[9]'),
    ('FGPA_PPU2_TST10', 'ppu2_tst[10]'),
    ('FGPA_PPU2_TST11', 'ppu2_tst[11]'),
    ('FGPA_PPU2_TST12', 'ppu2_tst[12]'),
    ('FGPA_PPU2_TST13', 'ppu2_tst[13]'),
    ('FGPA_PPU2_TST14', 'ppu2_tst[14]'),
    (None, None),
    ('FGPA_PPU1_~EXTSYNC~', 'ppu1_extsync_n'),
    ('FGPA_PPU1_HVCMODE', 'ppu1_hvcmode'),
    ('FPGA_PPU1_~MASTER~', 'ppu1_master_n'),
    ('FPGA_PPU1_PALMODE', 'ppu1_palmode'),
    ('FPGA_PPU2_3.58M', 'ppu2_3p58m'),
    ('FPGA_PPU2_~PED~', 'ppu2_ped_n'),
    ('FPGA_PPU2_~5MOUT~', 'ppu2_5mout_n'),
    ('FPGA_PPU2_EXTLATCH', 'ppu2_extlatch'),
    ('FPGA_PPU2_HVCMODE', 'ppu2_hvcmode'),
    ('FPGA_PPU2_PALMODE', 'ppu2_palmode'),
    ('FPGA_PPU2_~TOUMEI~', 'ppu2_toumei_n'),
    (None, None),
    ('FPGA_EXTRA1', 'extra1'),
    ('FPGA_EXTRA2', 'extra2'),
    ('FPGA_EXTRA3', 'extra3'),
    ('FPGA_EXTRA3', 'button'),
    (None, None),
    ('FPGA_BODGE1', 'bodge1'),
    ('FPGA_BODGE2', 'bodge2'),
    ('FPGA_BODGE3', 'bodge3'),
    (None, None),
    ('ANALOG_CLK', 'analog_clock'),
    ('ANALOG_OE', 'analog_oe_n'),
    ('ANALOG_R0', 'analog_r[0]'),
    ('ANALOG_R1', 'analog_r[1]'),
    ('ANALOG_R2', 'analog_r[2]'),
    ('ANALOG_R3', 'analog_r[3]'),
    ('ANALOG_R4', 'analog_r[4]'),
    ('ANALOG_R5', 'analog_r[5]'),
    ('ANALOG_R6', 'analog_r[6]'),
    ('ANALOG_R7', 'analog_r[7]'),
    ('ANALOG_G0', 'analog_g[0]'),
    ('ANALOG_G1', 'analog_g[1]'),
    ('ANALOG_G2', 'analog_g[2]'),
    ('ANALOG_G3', 'analog_g[3]'),
    ('ANALOG_G4', 'analog_g[4]'),
    ('ANALOG_G5', 'analog_g[5]'),
    ('ANALOG_G6', 'analog_g[6]'),
    ('ANALOG_G7', 'analog_g[7]'),
    ('ANALOG_B0', 'analog_b[0]'),
    ('ANALOG_B1', 'analog_b[1]'),
    ('ANALOG_B2', 'analog_b[2]'),
    ('ANALOG_B3', 'analog_b[3]'),
    ('ANALOG_B4', 'analog_b[4]'),
    ('ANALOG_B5', 'analog_b[5]'),
    ('ANALOG_B6', 'analog_b[6]'),
    ('ANALOG_B7', 'analog_b[7]'),
]

LPF_IGNORE = set([
    '/SPLA Board - FPGA/CFG_0',
    'SPI_CLK', 'SPI_MISO', 'SPI_MOSI', 'SPI_~CS~',
    '~INIT', '~PROGRAM', 'DONE',
    'JTAG_TCK', 'JTAG_TDI', 'JTAG_TDO', 'JTAG_TMS',
])

def print_lpf(pins):
    used = set()
    lines = []
    bad = set()
    for net_name, rtl_name in LPFS:
        if net_name is None:
            lines.append('')
        else:
            used.add(net_name)
            if net_name in pins:
                pin = pins[net_name]
                lines.append('LOCATE COMP "%s" SITE "%s"; IOBUF PORT "%s" IO_TYPE=LVCMOS33;' % (rtl_name, pin, rtl_name))
            else:
                bad.add(net_name)

    print('\n'.join(lines))
    unused = set()
    for net_name, pin in pins.items():
        if net_name not in used and net_name not in LPF_IGNORE:
            unused.add(net_name)
    if bad:
        print('// Bad %d: %s' % (len(bad), ' '.join(sorted(bad))))
    if unused:
        print('// Unused %d: %s' % (len(unused), ' '.join(sorted(unused))))

def main():
    filename = os.path.join(os.path.dirname(sys.argv[0]),
            '../spla-board/spla-board.net')
    top = netlist.parse(open(filename).read())
    nets = get_nets(top)
    pins = get_fpga_pins(nets) # name -> pin
    print_lpf(pins)


if __name__ == '__main__':
    main()
