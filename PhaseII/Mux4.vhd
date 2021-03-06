library ieee;
use ieee.std_logic_1164.all;

entity Mux4 is
port(	In3: 	in std_logic_vector(15 downto 0);
	In2: 	in std_logic_vector(15 downto 0);
	In1: 	in std_logic_vector(15 downto 0);
	In0: 	in std_logic_vector(15 downto 0);
	Sel:	in std_logic_vector(1 downto 0);
	Output:	out std_logic_vector(15 downto 0)
);
end Mux4;

architecture behavior of Mux4 is
begin

    Output <=	In0 when Sel="00" else
		In1 when Sel="01" else
		In2 when Sel="10" else
		In3 when Sel="11" else
		"ZZZZZZZZZZZZZZZZ";

end behavior;