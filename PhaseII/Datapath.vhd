-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.0 Build 156 04/24/2013 SJ Web Edition"
-- CREATED		"Mon May 04 19:03:48 2015"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Datapath IS 
	PORT
	(
		pin_name5 :  IN  STD_LOGIC;
		PC_ld_reg :  IN  STD_LOGIC;
		CLK :  IN  STD_LOGIC;
		RST :  IN  STD_LOGIC;
		clrz :  IN  STD_LOGIC;
		mux_B_sel :  IN  STD_LOGIC;
		wr_en :  IN  STD_LOGIC;
		alu_op :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		mux_A_sel :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		mux_PC_sel :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		pin_name2 :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		pin_name3 :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		pin_name4 :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		zout :  OUT  STD_LOGIC;
		instruction :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END Datapath;

ARCHITECTURE bdf_type OF Datapath IS 

COMPONENT alu
	PORT(clrz : IN STD_LOGIC;
		 A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 alu_op : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Z : OUT STD_LOGIC;
		 alu_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT register_32
	PORT(clk : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 input : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux4
	PORT(In0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 Output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT data_mem
	PORT(clock : IN STD_LOGIC;
		 wren : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 rdaddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 wraddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux2
	PORT(Sel : IN STD_LOGIC;
		 In0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT instruction_register
	PORT(clk : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 sel : IN STD_LOGIC;
		 input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT prog_mem
	PORT(clock : IN STD_LOGIC;
		 wren : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 rdaddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 wraddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pcplus1
	PORT(Input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT max
	PORT(A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 max_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT single_register
	PORT(clk : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT rf
	PORT(clock : IN STD_LOGIC;
		 wren : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Sel_X : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Sel_Z : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 wraddress : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Out_X : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Out_Z : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux8
	PORT(In0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In4 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In5 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In6 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In7 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 Output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	CLK_OUT :  STD_LOGIC;
SIGNAL	DPCR :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	IReg :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	PC_out :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	RX_OUT :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	RZ_OUT :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC_VECTOR(15 DOWNTO 0);


BEGIN 



b2v_ALU_inst : alu
PORT MAP(clrz => clrz,
		 A => SYNTHESIZED_WIRE_16,
		 alu_op => alu_op,
		 B => SYNTHESIZED_WIRE_17,
		 Z => zout,
		 alu_out => SYNTHESIZED_WIRE_12);


b2v_DCPR_reg : register_32
PORT MAP(clk => CLK_OUT,
		 input => DPCR);


b2v_DM_DATA_MUX : mux4
PORT MAP(In0 => RX_OUT,
		 In1 => IReg(15 DOWNTO 0),
		 In2 => PC_out,
		 Output => SYNTHESIZED_WIRE_2);


b2v_DM_inst : data_mem
PORT MAP(clock => CLK_OUT,
		 wren => wr_en,
		 data => SYNTHESIZED_WIRE_2,
		 rdaddress => SYNTHESIZED_WIRE_3,
		 wraddress => SYNTHESIZED_WIRE_4,
		 q => SYNTHESIZED_WIRE_18);


b2v_DMR_MUX : mux2
PORT MAP(In0 => RX_OUT,
		 In1 => IReg(15 DOWNTO 0),
		 Output => SYNTHESIZED_WIRE_3);


b2v_DMW_MUX : mux2
PORT MAP(In0 => RZ_OUT,
		 In1 => IReg(15 DOWNTO 0),
		 Output => SYNTHESIZED_WIRE_4);


b2v_DPCR_MUX : mux4
PORT MAP(In0 => RX_OUT,
		 In3 => IReg(15 DOWNTO 0),
		 Output => DPCR(15 DOWNTO 0));


b2v_inst1 : instruction_register
PORT MAP(clk => CLK_OUT,
		 input => SYNTHESIZED_WIRE_5,
		 output => IReg);


b2v_inst2 : prog_mem
PORT MAP(clock => CLK_OUT,
		 rdaddress => PC_out,
		 q => SYNTHESIZED_WIRE_5);


b2v_inst4 : pcplus1
PORT MAP(Input => PC_out,
		 Output => SYNTHESIZED_WIRE_8);


b2v_MAX_inst : max
PORT MAP(A => SYNTHESIZED_WIRE_16,
		 B => SYNTHESIZED_WIRE_17,
		 max_out => SYNTHESIZED_WIRE_13);


b2v_MUX_A : mux4
PORT MAP(In0 => RX_OUT,
		 In1 => IReg(15 DOWNTO 0),
		 Sel => mux_A_sel,
		 Output => SYNTHESIZED_WIRE_16);


b2v_MUX_B : mux2
PORT MAP(Sel => mux_B_sel,
		 In0 => RX_OUT,
		 In1 => RZ_OUT,
		 Output => SYNTHESIZED_WIRE_17);


b2v_PC_MUX : mux4
PORT MAP(In0 => SYNTHESIZED_WIRE_8,
		 In1 => IReg(15 DOWNTO 0),
		 In2 => RX_OUT,
		 In3 => SYNTHESIZED_WIRE_18,
		 Sel => mux_PC_sel,
		 Output => SYNTHESIZED_WIRE_10);


b2v_PC_REGISTER : single_register
PORT MAP(clk => CLK_OUT,
		 enable => PC_ld_reg,
		 reset => RST,
		 input => SYNTHESIZED_WIRE_10,
		 output => PC_out);


b2v_RF_inst : rf
PORT MAP(clock => CLK_OUT,
		 wren => pin_name5,
		 data => SYNTHESIZED_WIRE_11,
		 Sel_X => pin_name2,
		 Sel_Z => pin_name3,
		 wraddress => pin_name4,
		 Out_X => RX_OUT,
		 Out_Z => RZ_OUT);


b2v_RF_MUX : mux8
PORT MAP(In0 => IReg(15 DOWNTO 0),
		 In1 => RX_OUT,
		 In2 => SYNTHESIZED_WIRE_12,
		 In3 => SYNTHESIZED_WIRE_13,
		 In4 => SYNTHESIZED_WIRE_14,
		 In6 => SYNTHESIZED_WIRE_18,
		 Output => SYNTHESIZED_WIRE_11);


b2v_SIP : single_register
PORT MAP(clk => CLK_OUT,
		 output => SYNTHESIZED_WIRE_14);


b2v_SOP : single_register
PORT MAP(clk => CLK_OUT,
		 input => RX_OUT);


b2v_SVOP : single_register
PORT MAP(clk => CLK_OUT,
		 input => RX_OUT);

CLK_OUT <= CLK;
instruction(15 DOWNTO 0) <= IReg(31 DOWNTO 16);

END bdf_type;