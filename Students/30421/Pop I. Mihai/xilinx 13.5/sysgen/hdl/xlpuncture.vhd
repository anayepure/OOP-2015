
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
use IEEE.std_logic_arith.all;
use work.conv_pkg.all;
entity xlpuncture is
    generic (
        puncture_code : integer := 26;
        din_width     : integer := 5;
        din_bin_pt    : integer := 0;
        din_arith     : integer := xlUnsigned;
        dout_width    : integer := 3;
        dout_bin_pt   : integer := 0;
        dout_arith    : integer := xlUnsigned);
    port (
        din : in std_logic_vector (din_width-1 downto 0);
        dout : out std_logic_vector (dout_width-1 downto 0));
end xlpuncture;
architecture behavior of xlpuncture is
    constant bin_puncture_code : std_logic_vector(din_width-1 downto 0)
        := integer_to_std_logic_vector(puncture_code, din_width, xlUnsigned);
begin
    puncturing : process (din)
        variable pos : integer;
        variable result : std_logic_vector(dout_width-1 downto 0);
    begin
        pos := 0;
        for i in 0 to din_width-1  loop
            if bin_puncture_code(i) = '1' then
                result(pos) := din(i);
                pos := pos + 1;
            end if;
        end loop;
        dout <= result;
    end process;
end  behavior;
