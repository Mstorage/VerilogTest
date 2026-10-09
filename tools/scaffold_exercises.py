#!/usr/bin/env python3
"""Generate the exercise RTL stubs and their matching baseline testbenches."""

from __future__ import annotations

import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE_MD = ROOT / "Verilog秋招面试练习题单.md"

# category, file slug, module name, parameters, ports
# Port format: direction:width:name. Width "1" means a scalar.
SPECS = [
    # 01 基础 RTL
    ("01_basic_rtl", "01_mux_2_4", "mux_2_4", "WIDTH=8", "i:WIDTH:in0;i:WIDTH:in1;i:WIDTH:in2;i:WIDTH:in3;i:2:sel;o:WIDTH:y"),
    ("01_basic_rtl", "02_priority_onehot_encoder", "priority_onehot_encoder", "N=8,INDEX_WIDTH=3", "i:N:req;o:INDEX_WIDTH:code;o:1:valid;o:N:onehot"),
    ("01_basic_rtl", "03_parity", "parity_unit", "WIDTH=8", "i:WIDTH:data;i:WIDTH:rx_data;i:1:rx_parity;o:1:parity_even;o:1:error"),
    ("01_basic_rtl", "04_dff_enable", "dff_enable", "WIDTH=8", "i:1:clk;i:1:rst_n;i:1:en;i:WIDTH:d;o:WIDTH:q"),
    ("01_basic_rtl", "05_latch", "gated_latch", "WIDTH=8", "i:1:gate;i:WIDTH:d;o:WIDTH:q"),
    ("01_basic_rtl", "06_edge_detector", "edge_detector", "WIDTH=8", "i:1:clk;i:1:rst_n;i:WIDTH:din;o:WIDTH:rise;o:WIDTH:fall;o:WIDTH:any_edge"),
    ("01_basic_rtl", "07_shift_register", "shift_register", "WIDTH=8", "i:1:clk;i:1:rst_n;i:1:load;i:1:dir;i:1:en;i:WIDTH:pdata;i:1:serial_in;o:WIDTH:q"),
    ("01_basic_rtl", "08_counter_family", "counter_family", "WIDTH=8,MODULO=100", "i:1:clk;i:1:rst_n;i:1:en;i:1:up;i:2:mode;o:WIDTH:q;o:1:wrap;o:1:saturated"),
    ("01_basic_rtl", "09_binary_gray_converter", "binary_gray_converter", "WIDTH=8", "i:WIDTH:bin;i:WIDTH:gray_in;o:WIDTH:gray;o:WIDTH:bin_out"),
    ("01_basic_rtl", "10_register_file", "register_file", "DATA_WIDTH=32,ADDR_WIDTH=5", "i:1:clk;i:1:rst_n;i:1:wen;i:ADDR_WIDTH:waddr;i:DATA_WIDTH:wdata;i:ADDR_WIDTH:raddr1;i:ADDR_WIDTH:raddr2;o:DATA_WIDTH:rdata1;o:DATA_WIDTH:rdata2"),
    ("01_basic_rtl", "11_leading_zero_counter", "leading_zero_counter", "WIDTH=32,COUNT_WIDTH=6", "i:WIDTH:din;o:COUNT_WIDTH:count;o:1:valid"),
    ("01_basic_rtl", "12_barrel_shifter", "barrel_shifter", "WIDTH=32,SHIFT_WIDTH=5", "i:WIDTH:din;i:SHIFT_WIDTH:shamt;i:1:dir;i:1:arithmetic_shift;o:WIDTH:dout"),

    # 02 时序控制与 FSM
    ("02_timing_fsm", "01_periodic_pulse", "periodic_pulse", "PERIOD=10,COUNT_WIDTH=4", "i:1:clk;i:1:rst_n;i:1:en;o:1:pulse"),
    ("02_timing_fsm", "02_pulse_stretcher", "pulse_stretcher", "LENGTH=4,COUNT_WIDTH=3", "i:1:clk;i:1:rst_n;i:1:trigger;i:1:retrigger_en;o:1:pulse_out;o:1:busy"),
    ("02_timing_fsm", "03_debouncer", "debouncer", "STABLE_CYCLES=8,COUNT_WIDTH=3", "i:1:clk;i:1:rst_n;i:1:async_in;o:1:level;o:1:pressed"),
    ("02_timing_fsm", "04_traffic_light", "traffic_light", "GREEN_CYCLES=10,YELLOW_CYCLES=3,RED_CYCLES=10", "i:1:clk;i:1:rst_n;i:1:emergency;o:3:light_a;o:3:light_b"),
    ("02_timing_fsm", "05_sequence_1011", "sequence_1011", "ALLOW_OVERLAP=1", "i:1:clk;i:1:rst_n;i:1:bit_in;i:1:valid_in;o:1:detected"),
    ("02_timing_fsm", "06_configurable_sequence", "configurable_sequence", "PATTERN=11,PATTERN_LEN=4", "i:1:clk;i:1:rst_n;i:1:bit_in;i:1:valid_in;o:1:detected"),
    ("02_timing_fsm", "07_watchdog", "watchdog", "TIMEOUT=16,COUNT_WIDTH=4", "i:1:clk;i:1:rst_n;i:1:kick;i:1:pause;i:1:clear_alarm;i:1:latch_mode;o:1:alarm"),
    ("02_timing_fsm", "08_glitch_free_clock_mux", "glitch_free_clock_mux", "", "i:1:clk0;i:1:clk1;i:1:rst_n;i:1:sel;o:1:clk_out"),
    ("02_timing_fsm", "09_programmable_pwm", "programmable_pwm", "WIDTH=8", "i:1:clk;i:1:rst_n;i:1:cfg_valid;i:WIDTH:period;i:WIDTH:duty;o:1:pwm;o:1:cfg_ready"),
    ("02_timing_fsm", "10_uart", "uart", "CLK_HZ=50000000,BAUD=115200", "i:1:clk;i:1:rst_n;i:1:rx;i:1:tx_valid;i:8:tx_data;o:1:tx;o:1:tx_ready;o:1:rx_valid;o:8:rx_data;o:1:frame_error"),

    # 03 流控、握手与仲裁
    ("03_flow_control", "01_four_phase_handshake", "four_phase_handshake", "WIDTH=8", "i:1:src_clk;i:1:dst_clk;i:1:rst_n;i:1:send;i:WIDTH:data_in;o:1:busy;o:1:data_valid;o:WIDTH:data_out"),
    ("03_flow_control", "02_ready_valid_register", "ready_valid_register", "WIDTH=8", "i:1:clk;i:1:rst_n;i:1:s_valid;o:1:s_ready;i:WIDTH:s_data;o:1:m_valid;i:1:m_ready;o:WIDTH:m_data"),
    ("03_flow_control", "03_skid_buffer", "skid_buffer", "WIDTH=8", "i:1:clk;i:1:rst_n;i:1:s_valid;o:1:s_ready;i:WIDTH:s_data;o:1:m_valid;i:1:m_ready;o:WIDTH:m_data"),
    ("03_flow_control", "04_elastic_pipeline", "elastic_pipeline", "WIDTH=8,STAGES=2", "i:1:clk;i:1:rst_n;i:1:s_valid;o:1:s_ready;i:WIDTH:s_data;o:1:m_valid;i:1:m_ready;o:WIDTH:m_data"),
    ("03_flow_control", "05_fixed_priority_arbiter", "fixed_priority_arbiter", "N=4", "i:N:req;o:N:grant;o:1:grant_valid"),
    ("03_flow_control", "06_round_robin_arbiter", "round_robin_arbiter", "N=4", "i:1:clk;i:1:rst_n;i:N:req;i:1:accept;o:N:grant;o:1:grant_valid"),
    ("03_flow_control", "07_weighted_round_robin", "weighted_round_robin", "N=4,WEIGHT_WIDTH=4", "i:1:clk;i:1:rst_n;i:N:req;i:N*WEIGHT_WIDTH:weights;i:1:accept;o:N:grant;o:1:grant_valid"),
    ("03_flow_control", "08_locked_arbiter", "locked_arbiter", "N=4", "i:1:clk;i:1:rst_n;i:N:req;i:1:transaction_done;o:N:grant;o:1:grant_valid"),
    ("03_flow_control", "09_stream_merger", "stream_merger", "N=4,WIDTH=8", "i:1:clk;i:1:rst_n;i:N:s_valid;o:N:s_ready;i:N*WIDTH:s_data;o:1:m_valid;i:1:m_ready;o:WIDTH:m_data;o:N:selected"),
    ("03_flow_control", "10_crossbar", "crossbar", "N_MASTER=2,N_SLAVE=2,ADDR_WIDTH=16,DATA_WIDTH=32", "i:1:clk;i:1:rst_n;i:N_MASTER:req_valid;o:N_MASTER:req_ready;i:N_MASTER*ADDR_WIDTH:req_addr;i:N_MASTER*DATA_WIDTH:req_wdata;o:N_MASTER:rsp_valid;i:N_MASTER:rsp_ready;o:N_MASTER*DATA_WIDTH:rsp_data"),

    # 04 FIFO
    ("04_fifo", "01_shift_fifo", "shift_fifo", "WIDTH=8,DEPTH=4", "i:1:clk;i:1:rst_n;i:1:wr_en;i:WIDTH:wr_data;i:1:rd_en;o:WIDTH:rd_data;o:1:full;o:1:empty"),
    ("04_fifo", "02_sync_ring_fifo", "sync_ring_fifo", "WIDTH=8,DEPTH=16,ADDR_WIDTH=4", "i:1:clk;i:1:rst_n;i:1:wr_en;i:WIDTH:wr_data;i:1:rd_en;o:WIDTH:rd_data;o:1:full;o:1:empty"),
    ("04_fifo", "03_counted_sync_fifo", "counted_sync_fifo", "WIDTH=8,DEPTH=16,ADDR_WIDTH=4,COUNT_WIDTH=5,ALMOST_FULL=14,ALMOST_EMPTY=2", "i:1:clk;i:1:rst_n;i:1:wr_en;i:WIDTH:wr_data;i:1:rd_en;o:WIDTH:rd_data;o:1:full;o:1:empty;o:1:almost_full;o:1:almost_empty;o:COUNT_WIDTH:count"),
    ("04_fifo", "04_fwft_fifo", "fwft_fifo", "WIDTH=8,DEPTH=16,ADDR_WIDTH=4", "i:1:clk;i:1:rst_n;i:1:s_valid;o:1:s_ready;i:WIDTH:s_data;o:1:m_valid;i:1:m_ready;o:WIDTH:m_data"),
    ("04_fifo", "05_non_power_of_two_fifo", "non_power_of_two_fifo", "WIDTH=8,DEPTH=10,ADDR_WIDTH=4,COUNT_WIDTH=4", "i:1:clk;i:1:rst_n;i:1:wr_en;i:WIDTH:wr_data;i:1:rd_en;o:WIDTH:rd_data;o:1:full;o:1:empty;o:COUNT_WIDTH:count"),
    ("04_fifo", "06_virtual_channel_fifo", "virtual_channel_fifo", "CHANNELS=4,WIDTH=8,DEPTH=16,CH_WIDTH=2", "i:1:clk;i:1:rst_n;i:1:wr_en;i:CH_WIDTH:wr_channel;i:WIDTH:wr_data;i:1:rd_en;i:CH_WIDTH:rd_channel;o:WIDTH:rd_data;o:CHANNELS:full;o:CHANNELS:empty"),
    ("04_fifo", "07_async_fifo_basic", "async_fifo_basic", "WIDTH=8,DEPTH=16,ADDR_WIDTH=4", "i:1:wclk;i:1:wrst_n;i:1:w_en;i:WIDTH:w_data;o:1:w_full;i:1:rclk;i:1:rrst_n;i:1:r_en;o:WIDTH:r_data;o:1:r_empty"),
    ("04_fifo", "08_async_fifo_engineering", "async_fifo_engineering", "WIDTH=8,DEPTH=16,ADDR_WIDTH=4,ALMOST_MARGIN=2", "i:1:wclk;i:1:wrst_n;i:1:w_en;i:WIDTH:w_data;o:1:w_full;o:1:w_almost_full;i:1:rclk;i:1:rrst_n;i:1:r_en;o:WIDTH:r_data;o:1:r_empty;o:1:r_almost_empty"),

    # 05 CDC 与复位
    ("05_cdc_reset", "01_bit_synchronizer", "bit_synchronizer", "STAGES=2", "i:1:dst_clk;i:1:dst_rst_n;i:1:async_in;o:1:sync_out"),
    ("05_cdc_reset", "02_reset_sync_release", "reset_sync_release", "STAGES=2", "i:1:clk;i:1:async_rst_n;o:1:sync_rst_n"),
    ("05_cdc_reset", "03_slow_to_fast_pulse", "slow_to_fast_pulse", "", "i:1:src_clk;i:1:src_rst_n;i:1:src_pulse;i:1:dst_clk;i:1:dst_rst_n;o:1:dst_pulse"),
    ("05_cdc_reset", "04_fast_to_slow_handshake", "fast_to_slow_handshake", "", "i:1:src_clk;i:1:src_rst_n;i:1:src_pulse;o:1:src_busy;i:1:dst_clk;i:1:dst_rst_n;o:1:dst_pulse"),
    ("05_cdc_reset", "05_multibit_config_cdc", "multibit_config_cdc", "WIDTH=32", "i:1:src_clk;i:1:src_rst_n;i:1:src_valid;o:1:src_ready;i:WIDTH:src_data;i:1:dst_clk;i:1:dst_rst_n;o:1:dst_valid;o:WIDTH:dst_data"),
    ("05_cdc_reset", "06_event_counter_cdc", "event_counter_cdc", "WIDTH=8", "i:1:src_clk;i:1:src_rst_n;i:1:src_event;i:1:dst_clk;i:1:dst_rst_n;o:WIDTH:event_count;o:WIDTH:event_delta"),
    ("05_cdc_reset", "07_reset_domain_controller", "reset_domain_controller", "DOMAINS=3,DELAY=4", "i:1:clk;i:1:async_rst_n;i:DOMAINS:domain_ready;o:DOMAINS:domain_rst_n;o:1:all_ready"),
    ("05_cdc_reset", "08_cdc_mailbox", "cdc_mailbox", "WIDTH=32", "i:1:src_clk;i:1:src_rst_n;i:1:src_valid;o:1:src_ready;i:WIDTH:src_data;i:1:dst_clk;i:1:dst_rst_n;o:1:dst_valid;i:1:dst_ready;o:WIDTH:dst_data"),
    ("05_cdc_reset", "09_cdc_review_repair", "cdc_review_repair", "WIDTH=16", "i:1:src_clk;i:1:src_rst_n;i:1:src_level;i:1:src_pulse;i:WIDTH:src_bus;i:1:src_bus_valid;o:1:src_bus_ready;i:1:dst_clk;i:1:dst_rst_n;o:1:dst_level;o:1:dst_pulse;o:WIDTH:dst_bus;o:1:dst_bus_valid"),

    # 06 总线与外设协议
    ("06_bus_protocol", "01_register_bus_slave", "register_bus_slave", "ADDR_WIDTH=8,DATA_WIDTH=32", "i:1:clk;i:1:rst_n;i:1:req;i:1:write;i:ADDR_WIDTH:addr;i:DATA_WIDTH:wdata;i:DATA_WIDTH:wstrb;o:1:ready;o:DATA_WIDTH:rdata;o:1:error"),
    ("06_bus_protocol", "02_apb3_slave", "apb3_slave", "ADDR_WIDTH=12,DATA_WIDTH=32", "i:1:pclk;i:1:preset_n;i:1:psel;i:1:penable;i:1:pwrite;i:ADDR_WIDTH:paddr;i:DATA_WIDTH:pwdata;o:DATA_WIDTH:prdata;o:1:pready;o:1:pslverr"),
    ("06_bus_protocol", "03_spi_mode0_master", "spi_mode0_master", "DATA_WIDTH=8,DIVIDER=4", "i:1:clk;i:1:rst_n;i:1:start;i:DATA_WIDTH:tx_data;i:1:miso;o:1:sclk;o:1:cs_n;o:1:mosi;o:1:busy;o:1:done;o:DATA_WIDTH:rx_data"),
    ("06_bus_protocol", "04_i2c_master_basic", "i2c_master_basic", "CLK_DIV=250", "i:1:clk;i:1:rst_n;i:1:start;i:7:address;i:1:read;i:8:tx_data;i:1:sda_i;o:1:scl;o:1:sda_o;o:1:sda_oe;o:1:busy;o:1:done;o:1:ack_error;o:8:rx_data"),
    ("06_bus_protocol", "05_ahb_lite_sram_slave", "ahb_lite_sram_slave", "ADDR_WIDTH=12,DATA_WIDTH=32,DEPTH=1024", "i:1:hclk;i:1:hreset_n;i:2:htrans;i:1:hwrite;i:3:hsize;i:ADDR_WIDTH:haddr;i:DATA_WIDTH:hwdata;i:1:hready_in;o:DATA_WIDTH:hrdata;o:1:hready_out;o:1:hresp"),
    ("06_bus_protocol", "06_ahb_to_apb_bridge", "ahb_to_apb_bridge", "ADDR_WIDTH=16,DATA_WIDTH=32", "i:1:hclk;i:1:hreset_n;i:2:htrans;i:1:hwrite;i:ADDR_WIDTH:haddr;i:DATA_WIDTH:hwdata;o:DATA_WIDTH:hrdata;o:1:hready;o:1:hresp;o:1:psel;o:1:penable;o:1:pwrite;o:ADDR_WIDTH:paddr;o:DATA_WIDTH:pwdata;i:DATA_WIDTH:prdata;i:1:pready;i:1:pslverr"),
    ("06_bus_protocol", "07_axi_stream_register_slice", "axi_stream_register_slice", "DATA_WIDTH=32", "i:1:aclk;i:1:areset_n;i:1:s_tvalid;o:1:s_tready;i:DATA_WIDTH:s_tdata;i:1:s_tlast;o:1:m_tvalid;i:1:m_tready;o:DATA_WIDTH:m_tdata;o:1:m_tlast"),
    ("06_bus_protocol", "08_axi4_lite_slave", "axi4_lite_slave", "ADDR_WIDTH=12,DATA_WIDTH=32", "i:1:aclk;i:1:areset_n;i:ADDR_WIDTH:s_awaddr;i:1:s_awvalid;o:1:s_awready;i:DATA_WIDTH:s_wdata;i:DATA_WIDTH/8:s_wstrb;i:1:s_wvalid;o:1:s_wready;o:2:s_bresp;o:1:s_bvalid;i:1:s_bready;i:ADDR_WIDTH:s_araddr;i:1:s_arvalid;o:1:s_arready;o:DATA_WIDTH:s_rdata;o:2:s_rresp;o:1:s_rvalid;i:1:s_rready"),
    ("06_bus_protocol", "09_axi4_lite_master", "axi4_lite_master", "ADDR_WIDTH=12,DATA_WIDTH=32", "i:1:aclk;i:1:areset_n;i:1:req_valid;o:1:req_ready;i:1:req_write;i:ADDR_WIDTH:req_addr;i:DATA_WIDTH:req_wdata;i:DATA_WIDTH/8:req_wstrb;o:1:rsp_valid;i:1:rsp_ready;o:DATA_WIDTH:rsp_rdata;o:2:rsp_resp;o:ADDR_WIDTH:m_awaddr;o:1:m_awvalid;i:1:m_awready;o:DATA_WIDTH:m_wdata;o:DATA_WIDTH/8:m_wstrb;o:1:m_wvalid;i:1:m_wready;i:2:m_bresp;i:1:m_bvalid;o:1:m_bready;o:ADDR_WIDTH:m_araddr;o:1:m_arvalid;i:1:m_arready;i:DATA_WIDTH:m_rdata;i:2:m_rresp;i:1:m_rvalid;o:1:m_rready"),
    ("06_bus_protocol", "10_axi4_burst_address", "axi4_burst_address", "ADDR_WIDTH=32", "i:ADDR_WIDTH:start_addr;i:8:len;i:3:size;i:2:burst;i:8:beat_index;o:ADDR_WIDTH:beat_addr;o:1:last;o:1:cross_4k;o:1:config_error"),
    ("06_bus_protocol", "11_axi4_to_axi4_lite_bridge", "axi4_to_axi4_lite_bridge", "ADDR_WIDTH=32,DATA_WIDTH=32", "i:1:clk;i:1:rst_n;i:1:req_valid;o:1:req_ready;i:1:req_write;i:ADDR_WIDTH:req_addr;i:8:req_len;i:3:req_size;i:DATA_WIDTH:req_wdata;o:1:rsp_valid;i:1:rsp_ready;o:DATA_WIDTH:rsp_rdata;o:2:rsp_resp;o:1:lite_valid;i:1:lite_ready;o:1:lite_write;o:ADDR_WIDTH:lite_addr;o:DATA_WIDTH:lite_wdata;i:1:lite_rsp_valid;i:DATA_WIDTH:lite_rdata;i:2:lite_resp"),
    ("06_bus_protocol", "12_simplified_axi_interconnect", "simplified_axi_interconnect", "N_MASTER=2,N_SLAVE=2,ADDR_WIDTH=32,DATA_WIDTH=32,ID_WIDTH=4", "i:1:clk;i:1:rst_n;i:N_MASTER:req_valid;o:N_MASTER:req_ready;i:N_MASTER*ADDR_WIDTH:req_addr;i:N_MASTER*DATA_WIDTH:req_data;i:N_MASTER*ID_WIDTH:req_id;o:N_MASTER:rsp_valid;i:N_MASTER:rsp_ready;o:N_MASTER*DATA_WIDTH:rsp_data;o:N_MASTER*ID_WIDTH:rsp_id"),

    # 07 算术与 DSP
    ("07_arithmetic_dsp", "01_add_sub", "add_sub", "WIDTH=16", "i:WIDTH:a;i:WIDTH:b;i:1:sub;i:1:signed_mode;o:WIDTH:result;o:1:carry_borrow;o:1:zero;o:1:overflow"),
    ("07_arithmetic_dsp", "02_abs_saturating", "abs_saturating", "WIDTH=16", "i:WIDTH:value;i:WIDTH:add_a;i:WIDTH:add_b;o:WIDTH:abs_value;o:WIDTH:sat_sum;o:1:saturated"),
    ("07_arithmetic_dsp", "03_iterative_multiplier", "iterative_multiplier", "WIDTH=16", "i:1:clk;i:1:rst_n;i:1:start;i:1:signed_mode;i:WIDTH:a;i:WIDTH:b;o:1:busy;o:1:done;o:2*WIDTH:product"),
    ("07_arithmetic_dsp", "04_iterative_divider", "iterative_divider", "WIDTH=16", "i:1:clk;i:1:rst_n;i:1:start;i:1:signed_mode;i:WIDTH:dividend;i:WIDTH:divisor;o:1:busy;o:1:done;o:WIDTH:quotient;o:WIDTH:remainder;o:1:divide_by_zero"),
    ("07_arithmetic_dsp", "05_pipelined_mac", "pipelined_mac", "A_WIDTH=16,B_WIDTH=16,ACC_WIDTH=40", "i:1:clk;i:1:rst_n;i:1:valid_in;i:1:clear_acc;i:A_WIDTH:a;i:B_WIDTH:b;o:1:valid_out;o:ACC_WIDTH:acc;o:1:overflow"),
    ("07_arithmetic_dsp", "06_fir_filter", "fir_filter", "DATA_WIDTH=16,COEFF_WIDTH=16,TAPS=8,OUT_WIDTH=36", "i:1:clk;i:1:rst_n;i:1:sample_valid;i:DATA_WIDTH:sample;i:1:coeff_we;i:TAPS*COEFF_WIDTH:coeffs;o:1:result_valid;o:OUT_WIDTH:result"),
    ("07_arithmetic_dsp", "07_lut_sine_generator", "lut_sine_generator", "PHASE_WIDTH=24,OUT_WIDTH=16,ADDR_WIDTH=10", "i:1:clk;i:1:rst_n;i:1:en;i:PHASE_WIDTH:phase_inc;o:OUT_WIDTH:sine;o:PHASE_WIDTH:phase"),
    ("07_arithmetic_dsp", "08_cordic_sincos", "cordic_sincos", "ANGLE_WIDTH=16,DATA_WIDTH=16,ITERATIONS=16", "i:1:clk;i:1:rst_n;i:1:in_valid;i:ANGLE_WIDTH:angle;o:1:out_valid;o:DATA_WIDTH:sine;o:DATA_WIDTH:cosine"),
    ("07_arithmetic_dsp", "09_crc", "crc_unit", "DATA_WIDTH=8,CRC_WIDTH=16,POLY=4129,INIT=65535", "i:1:clk;i:1:rst_n;i:1:init;i:1:data_valid;i:DATA_WIDTH:data;i:1:check;o:CRC_WIDTH:crc;o:1:crc_ok"),
    ("07_arithmetic_dsp", "10_fft_butterfly", "fft_butterfly", "WIDTH=16,COEFF_WIDTH=16,OUT_WIDTH=18", "i:1:clk;i:1:rst_n;i:1:in_valid;i:WIDTH:a_re;i:WIDTH:a_im;i:WIDTH:b_re;i:WIDTH:b_im;i:COEFF_WIDTH:w_re;i:COEFF_WIDTH:w_im;o:1:out_valid;o:OUT_WIDTH:y0_re;o:OUT_WIDTH:y0_im;o:OUT_WIDTH:y1_re;o:OUT_WIDTH:y1_im;o:1:overflow"),

    # 08 验证与综合（实现为可被 meta-testbench 检验的 checker/系统模块）
    ("08_verification_system", "01_counter_checker", "counter_checker", "WIDTH=8,MODULO=100", "i:1:clk;i:1:rst_n;i:1:en;i:WIDTH:observed_count;o:1:error"),
    ("08_verification_system", "02_sequence_checker", "sequence_checker", "PATTERN=11,PATTERN_LEN=4", "i:1:clk;i:1:rst_n;i:1:bit_valid;i:1:bit_in;i:1:observed_detect;o:1:error"),
    ("08_verification_system", "03_ready_valid_checker", "ready_valid_checker", "WIDTH=8", "i:1:clk;i:1:rst_n;i:1:valid;i:1:ready;i:WIDTH:data;o:1:error"),
    ("08_verification_system", "04_fifo_checker", "fifo_checker", "WIDTH=8,DEPTH=16", "i:1:clk;i:1:rst_n;i:1:wr_en;i:WIDTH:wr_data;i:1:rd_en;i:WIDTH:rd_data;i:1:full;i:1:empty;o:1:error"),
    ("08_verification_system", "05_arbiter_checker", "arbiter_checker", "N=4,MAX_WAIT=16", "i:1:clk;i:1:rst_n;i:N:req;i:N:grant;i:1:accept;o:1:error"),
    ("08_verification_system", "06_axi_lite_checker", "axi_lite_checker", "ADDR_WIDTH=12,DATA_WIDTH=32", "i:1:aclk;i:1:areset_n;i:1:awvalid;i:1:awready;i:ADDR_WIDTH:awaddr;i:1:wvalid;i:1:wready;i:DATA_WIDTH:wdata;i:1:bvalid;i:1:bready;i:1:arvalid;i:1:arready;i:ADDR_WIDTH:araddr;i:1:rvalid;i:1:rready;i:DATA_WIDTH:rdata;o:1:error"),
    ("08_verification_system", "07_async_fifo_checker", "async_fifo_checker", "WIDTH=8", "i:1:wclk;i:1:wrst_n;i:1:w_en;i:WIDTH:w_data;i:1:w_full;i:1:rclk;i:1:rrst_n;i:1:r_en;i:WIDTH:r_data;i:1:r_empty;o:1:error"),
    ("08_verification_system", "08_mini_dma", "mini_dma", "ADDR_WIDTH=32,DATA_WIDTH=32,LENGTH_WIDTH=16", "i:1:clk;i:1:rst_n;i:1:cfg_start;i:ADDR_WIDTH:cfg_src_addr;i:LENGTH_WIDTH:cfg_length;o:1:busy;o:1:done;o:1:error;o:1:mem_req_valid;i:1:mem_req_ready;o:ADDR_WIDTH:mem_req_addr;i:1:mem_rsp_valid;i:DATA_WIDTH:mem_rsp_data;o:1:stream_valid;i:1:stream_ready;o:DATA_WIDTH:stream_data;o:1:stream_last"),
]


def parse_questions():
    text = SOURCE_MD.read_text(encoding="utf-8")
    rows = []
    for line in text.splitlines():
        match = re.match(r"^\|\s*\d+\s*\|\s*([★☆]{6})\s*\|\s*(.*?)\s*\|\s*(.*?)\s*\|$", line)
        if match:
            rows.append(match.groups())
    if len(rows) != len(SPECS):
        raise RuntimeError(f"题单有 {len(rows)} 道题，但接口表有 {len(SPECS)} 项")
    return rows


def parse_params(encoded: str):
    if not encoded:
        return []
    return [tuple(item.split("=", 1)) for item in encoded.split(",")]


def parse_ports(encoded: str):
    names = {"i": "input", "o": "output", "io": "inout"}
    return [(names[d], width, name) for d, width, name in (item.split(":", 2) for item in encoded.split(";"))]


def width_decl(width: str):
    return "" if width == "1" else f"[{width}-1:0] "


def rtl_text(spec, question):
    category, slug, module, param_src, port_src = spec
    difficulty, title, description = question
    params = parse_params(param_src)
    ports = parse_ports(port_src)
    param_lines = ""
    if params:
        body = ",\n".join(f"    parameter integer {name} = {value}" for name, value in params)
        param_lines = f" #(\n{body}\n)"
    port_lines = []
    for direction, width, name in ports:
        kind = "wire" if direction in ("input", "inout") else "reg"
        port_lines.append(f"    {direction} {kind} {width_decl(width)}{name}")
    port_block = ",\n".join(port_lines)
    param_doc = "、".join(f"{n}={v}" for n, v in params) if params else "无"
    port_doc = "\n".join(f"//   - {d:6s} {width:16s} {name}" for d, width, name in ports)
    return f"""`timescale 1ns/1ps
// ============================================================================
// 题目：{title}
// 难度：{difficulty}
// 编号：{category}/{slug}
//
// 要求：{description}
//
// 建议参数：{param_doc}
// 端口列表（方向 / 位宽 / 名称）：
{port_doc}
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q={category}/{slug}；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module {module}{param_lines} (
{port_block}
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
"""


def tb_text(spec, question):
    category, slug, module, param_src, port_src = spec
    difficulty, title, description = question
    params = parse_params(param_src)
    ports = parse_ports(port_src)
    declarations = []
    connections = []
    input_names = []
    output_names = []
    clock_names = []
    reset_low = []
    reset_high = []
    for direction, width, name in ports:
        kind = "reg" if direction == "input" else "wire"
        declarations.append(f"    {kind} {width_decl(width)}{name};")
        connections.append(f"        .{name}({name})")
        if direction == "input":
            input_names.append(name)
            if name.endswith("clk") or name in {"clk0", "clk1"}:
                clock_names.append(name)
            if name.endswith("rst_n") or name.endswith("reset_n") or name in {"areset_n", "preset_n", "hreset_n", "async_rst_n"}:
                reset_low.append(name)
            elif name in {"rst", "reset"}:
                reset_high.append(name)
        elif direction == "output":
            output_names.append(name)
    localparams = "\n".join(f"    localparam integer {n} = {v};" for n, v in params)
    init_lines = []
    for name in input_names:
        if name in clock_names or name in reset_low:
            init_lines.append(f"        {name} = 1'b0;")
        elif name in reset_high:
            init_lines.append(f"        {name} = 1'b1;")
        else:
            init_lines.append(f"        {name} = '0;")
    release_lines = [f"        {n} = 1'b1;" for n in reset_low] + [f"        {n} = 1'b0;" for n in reset_high]
    toggle_lines = [f"    always #{3 + idx * 2} {name} = ~{name};" for idx, name in enumerate(clock_names)]
    outputs = ", ".join(output_names)
    drive_ones = [f"        {n} = '1;" for n in input_names if n not in clock_names + reset_low + reset_high]
    connection_block = ",\n".join(connections)
    return f"""`timescale 1ns/1ps
// Baseline self-checking testbench: {title} ({difficulty})
// Core verification point: {description}
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_{slug};
{localparams}
{chr(10).join(declarations)}

    {module} dut (
{connection_block}
    );

{chr(10).join(toggle_lines)}

    task check_outputs_known;
    begin
        if ((^{{{outputs}}}) === 1'bx) begin
            $display("[FAIL] {category}/{slug}: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
{chr(10).join(init_lines)}
        #20;
{chr(10).join(release_lines)}
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
{chr(10).join(drive_ones)}
        #40;
        check_outputs_known();

        $display("[PASS] {category}/{slug} baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] {category}/{slug}: timeout");
        $fatal(1);
    end
endmodule
"""


def main():
    questions = parse_questions()
    created = 0
    preserved = 0
    for spec, question in zip(SPECS, questions):
        category, slug, *_ = spec
        rtl_path = ROOT / "test" / category / f"{slug}.v"
        tb_path = ROOT / "tb_test" / category / f"{slug}_tb.v"
        rtl_path.parent.mkdir(parents=True, exist_ok=True)
        tb_path.parent.mkdir(parents=True, exist_ok=True)
        if rtl_path.exists():
            preserved += 1
        else:
            rtl_path.write_text(rtl_text(spec, question), encoding="utf-8", newline="\n")
            created += 1
        if tb_path.exists():
            preserved += 1
        else:
            tb_path.write_text(tb_text(spec, question), encoding="utf-8", newline="\n")
            created += 1
    print(f"Created {created} missing file(s); preserved {preserved} existing file(s).")


if __name__ == "__main__":
    main()
