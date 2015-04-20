// Datapath.cpp

#include "Datapath.h"

void Datapath::datatransform() {
  lg_CLK = static_cast<sc_logic> (CLK.read());
  DM_data_in = mux_DM_Data_out.read();
  DM_rdaddress = data_rdadd.read();
  DM_wraddress = data_wradd.read();
  DM_wren = static_cast<sc_logic> (data_write.read());
  DM_out = DM_q.read().to_uint();

  PM_data_in = uint16_null.read();
  PM_rdaddress = PC_out.read();
  PM_wraddress = uint16_null.read();
  PM_wren = static_cast<sc_logic> (bool_null.read());
  I_in = PM_q.read().to_uint();
}

