
-------------------------------------------------------------------
-- System Generator version 13.4 VHDL source file.
--
-- Copyright(C) 2011 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2011 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;
entity xlspram_dist is
  generic (
    core_name0: string := "";
    c_width: integer := 12;
    c_address_width: integer := 4;
    addr_width: integer := 4;
    write_mode: integer := 1;
    latency: integer := 1
  );
  port (
    data_in: in std_logic_vector(c_width - 1 downto 0);
    addr: in std_logic_vector(addr_width - 1 downto 0);
    we: in std_logic_vector(0 downto 0);
    en: in std_logic_vector(0 downto 0);
    ce: in std_logic;
    clk: in std_logic;
    data_out: out std_logic_vector(c_width - 1 downto 0)
  );
end xlspram_dist ;
architecture behavior of xlspram_dist is
  component synth_reg is
    generic (
      width: integer := 8;
      latency: integer := 1
    );
    port (
      i: in std_logic_vector(width - 1 downto 0);
      ce: in std_logic;
      clr: in std_logic;
      clk: in std_logic;
      o: out std_logic_vector(width - 1 downto 0)
    );
  end component;
  constant num_extra_addr_bits: integer := (c_address_width - addr_width);
  signal core_addr: std_logic_vector(c_address_width - 1 downto 0);
  signal core_data_in, core_data_out: std_logic_vector(c_width - 1 downto 0);
  signal reg_data_in, reg_data_out: std_logic_vector(c_width - 1 downto 0);
  signal core_ce: std_logic;
  signal core_we: std_logic_vector(0 downto 0);
[% names_already_seen = {}                                                 -%]
[% FOREACH name = core_name0                                               -%]
[%   NEXT IF (! name.defined || names_already_seen.$name == 1)             -%]
[%   names_already_seen.$name = 1                                          -%]
[%   i = loop.index                                                        -%]
[%   comp_def = core_component_def.$i                                      -%]
  component [% name %]
    port (
      a: in std_logic_vector(c_address_width - 1 downto 0);
      clk: in std_logic;
      d: in std_logic_vector(c_width - 1 downto 0);
      we: in std_logic;
      spo: out std_logic_vector(c_width - 1 downto 0)
    );
  end component;
  attribute syn_black_box of [% name %]:
    component is true;
  attribute fpga_dont_touch of [% name %]:
    component is "true";
  attribute box_type of [% name %]:
    component  is "black_box";
[% END                                                                     -%]
begin
  need_to_pad_addr : if num_extra_addr_bits > 0 generate
      core_addr(c_address_width - 1 downto addr_width) <= (others => '0');
      core_addr(addr_width - 1 downto 0) <= addr;
  end generate;
  no_need_to_pad_addr: if num_extra_addr_bits = 0 generate
    core_addr <= addr;
  end generate;
  core_ce <= ce and en(0);
  core_data_in <= data_in;
  data_out <= reg_data_out;
  core_we(0) <= we(0) and core_ce;

  muxed_out : if write_mode = 1 generate
    choose_output: process(core_we(0), core_data_in, core_data_out)
    begin
      case core_we(0) is
        when '1' => reg_data_in <= core_data_in;
        when '0' => reg_data_in <= core_data_out;
        when others => reg_data_in <= core_data_in;
      end case;
    end process;
  end generate;
  nonmuxed_out : if write_mode = 2 generate
    reg_data_in <= core_data_out;
  end generate;

  registered_ram : if latency > 0 generate
    output_reg: synth_reg
      generic map (
        width   => c_width,
        latency => latency
      )
      port map (
        i   => reg_data_in,
        ce  => core_ce,
        clr => '0',
        clk => clk,
        o   => reg_data_out
      );
  end generate;

  nonregistered_ram : if latency = 0 generate
    reg_data_out <= core_data_out;
  end generate;
[% names_already_seen = {}                                                 -%]
[% FOREACH name = core_name0                                               -%]
[%   NEXT IF (! name.defined || names_already_seen.$name == 1)             -%]
[%   names_already_seen.$name = 1                                          -%]
[%   i = loop.index                                                        -%]
[%   inst_txt = core_instance_text.$i                                      -%]
  comp[% i %]: if ((core_name0 = "[% name %]")) generate
    core_instance[% i %]: [% name %]
      port map (
        a => core_addr,
        clk => clk,
        d => core_data_in,
        we => core_we(0),
        spo => core_data_out
      );
  end generate;
[% END                                                                     -%]
end behavior;
