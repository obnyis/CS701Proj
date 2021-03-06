#ifndef __DATAPATH_H_
#define __DATAPATH_H_

#include "systemc.h"
#include "ALU.h"
#include "MAX.h"
#include "IR.h"
#include "RF.h"
#include "PC.h"
#include "DPRegisters.h"
//#include "DPRR.h"
//#include "DPCR.h"
#include "data_mem.h"
#include "prog_mem.h"
#include "Register.h"
#include "ER.h"
#include "Mul2.h"
#include "Mul4.h"
#include "Mul7.h"
#include "EOT.h"
//#include "DFF.h"

SC_MODULE(datapath)
{
  sc_in<bool> CLK;
  sc_in<bool> RST;
  sc_in<sc_uint<16> > SIPi;

  // Control Signals
  sc_out<bool> zout;
  sc_in<bool> ld_IR;
  sc_in<bool> clrz;
  sc_in<bool> clrer; //TODO Assign // DONE 
  sc_in<bool> clreot; //TODO Assign // DONE
  sc_in<bool> seteot; //TODO Assign //DONE
  sc_in<bool> wr_en;
  sc_in<bool> SIP_Ld_Reg;
  sc_in<bool> SOP_Ld_Reg;
  sc_in<bool> SVOP_Ld_Reg;
  sc_in<bool> DPCR_Ld_Reg;
  sc_in<bool> mux_B_sel;
  sc_in<bool> PC_reg_ld;
  sc_in<bool> data_write;
  sc_in<bool> mux_DMR_sel;
  sc_in<bool> mux_DMW_sel;
  sc_in<sc_uint<2> > alu_op;
  sc_in<sc_uint<2> > mux_A_sel;
  sc_in<sc_uint<2> > mux_PC_sel;
  sc_in<sc_uint<3> > mux_RF_sel;
  sc_in<sc_uint<2> > mux_DM_Data_sel;
  sc_in<sc_uint<2> > mux_DPCR_sel;
  sc_in<sc_uint<4> > sel_x;
  sc_in<sc_uint<4> > sel_z;
  sc_in<sc_uint<4> > wr_dest;
  

  // ENV out
  sc_out<bool> CLR_IRQ;
  sc_out<bool> EOTO;
  sc_out<bool> DPC;
  sc_in<bool> ER_Ld_Reg; //TODO Assign // DONE
  sc_out<sc_uint<16> > DPCR; // Changed this nee to check
  sc_out<sc_uint<16> > CCD;
  sc_out<sc_uint<16> > PCD;
  sc_out<sc_uint<16> > SOPi;
  sc_out<sc_uint<16> > SVOPi;
  sc_out<sc_uint<16> > DATA;
  sc_out<sc_uint<12> > ADDR;

  // Instruction code
  sc_out<sc_uint<16> > instruction; // dunno about this?

  // Internal Connections
  sc_signal<sc_uint<32> > I_code;
  sc_signal<sc_uint<16> > I_in;
  sc_signal<sc_uint<16> > alu_A;
  sc_signal<sc_uint<16> > alu_B;
  sc_signal<sc_uint<16> > alu_out;
  sc_signal<sc_uint<16> > max_out;
  sc_signal<sc_uint<16> > wr_data;
  sc_signal<sc_uint<16> > SIP;
  sc_signal<sc_uint<16> > operand;
  sc_signal<sc_uint<16> > DM_out;

  sc_signal<sc_uint<16> > Rx;
  sc_signal<sc_uint<16> > Rz;

  sc_signal<sc_uint<16> > mux_DPCR_in_1;
  sc_signal<sc_uint<16> > mux_DPCR_in_2;
  sc_signal<sc_uint<16> > mux_DPCR_in_3;
  sc_signal<sc_uint<16> > mux_DPCR_in_4;
  sc_signal<sc_uint<16> > mux_DPCR_out;
  
  sc_signal<bool> ER_Bool;
  sc_signal<sc_uint<16> > ER_0;
  
  sc_signal<sc_uint<16> > mem_FIFO;
  
  sc_signal<sc_uint<16> > data_rdadd;
  sc_signal<sc_uint<16> > data_wradd;
  
  sc_signal<sc_uint<16> > mux_DM_Data_out;
  
  sc_signal<sc_lv<16> > PM_data_in;
  
  // Mem transformed signals
  sc_signal<sc_logic> lg_CLK;

  sc_signal<sc_lv<16> > DM_data_in; // From: mux_DM_Data_out
  sc_signal<sc_lv<16> > DM_rdaddress; // From: data_rdadd
  sc_signal<sc_lv<16> > DM_wraddress; // From: data_wradd
  sc_signal<sc_logic> DM_wren; // From: data_write
  sc_signal<sc_lv<16> > DM_q; // To: DM_out

  sc_signal<sc_lv<16> > PM_data;
  sc_signal<sc_lv<16> > PM_rdaddress;
  sc_signal<sc_lv<16> > PM_wraddress;
  sc_signal<sc_logic> PM_wren;
  sc_signal<sc_lv<16> > PM_q;
  sc_signal<sc_uint<16> > PC_out;

  sc_signal<bool> bool_null;
  sc_signal<sc_uint<16> > uint16_null;
  sc_signal<sc_uint<16> > const_1;

  void datatransform();

  ALU *my_ALU;
  MAX *my_MAX;
  IR *my_IR;
  RF *my_RF;
  PC *my_PC;
  DPRegisters *my_DPRR; //TODO Create // Dunno about this one as it only interacts with the CU from what I can see
  DPRegisters *my_DPCR; //TODO Create // Done
  data_mem *my_Data_mem;
  prog_mem *my_Prog_mem;
  Register *SIPR, *SOP, *SVOP;
  ER *my_ER; //TODO Create // DONE
  EOT *my_EOT; //TODO Create // DONE
  Mul4 *A_sel;
  Mul2 *B_sel;
  Mul4 *DPCR_sel;
  Mul7 *RF_sel;
  Mul2 *DMR_sel;
  Mul2 *DMW_sel;
  Mul4 *DM_Data_sel;

  SC_CTOR(datapath)
  {
    bool_null = 0;
    uint16_null = 0;
    const_1 = 1;
	PM_data_in = 0;
	
	my_DPCR = new DPRegisters("my_DPRR");
	my_DPCR->CLK(CLK);
	my_DPCR->RST(RST);
	my_DPCR->Ld_Reg(DPCR_Ld_Reg);
	my_DPCR->Input(mux_DPCR_out);
	my_DPCR->Output(DPCR);
	
	my_ER = new ER("my_ER");
	my_ER->CLR(clrer);
	my_ER->SET(ER_Ld_Reg);
	my_ER->out(ER_Bool);
	
	my_EOT = new EOT("my_EOT");
	my_EOT->CLR(clreot);
	my_EOT->SET(seteot);
	my_EOT->Out(EOTO);
	
    my_ALU = new ALU("my_ALU");
    my_ALU->clrz(clrz);
    my_ALU->alu_op(alu_op);
    my_ALU->A(alu_A);
    my_ALU->B(alu_B);
    my_ALU->out(alu_out);
    my_ALU->Z(zout);

    my_MAX = new MAX("my_MAX");
    my_MAX->A(alu_A);
    my_MAX->B(alu_B);
    my_MAX->out(max_out);

    A_sel = new Mul4("A_sel");
    A_sel->in1(Rx);
    A_sel->in2(operand);
    A_sel->in3(const_1);
    A_sel->in4(mem_FIFO);
    A_sel->out(alu_A);
    A_sel->select(mux_A_sel);

    B_sel = new Mul2("B_sel");
    B_sel->in1(Rz);
    B_sel->in2(Rx);
    B_sel->out(alu_B);
    B_sel->select(mux_B_sel);

    DPCR_sel = new Mul4("DPCR_sel"); // Only one that was declared as 8 bit ??
    DPCR_sel->in1(mux_DPCR_in_1);
    DPCR_sel->in2(mux_DPCR_in_2);
    DPCR_sel->in3(mux_DPCR_in_3);
    DPCR_sel->in4(mux_DPCR_in_4);
    DPCR_sel->out(mux_DPCR_out);
    DPCR_sel->select(mux_DPCR_sel);

    RF_sel = new Mul7("RF_sel");
    RF_sel->in1(operand);
    RF_sel->in2(Rx);
    RF_sel->in3(alu_out);
    RF_sel->in4(max_out);
    RF_sel->in5(SIP);
    RF_sel->in6(ER_0);
    RF_sel->in7(DM_out);
    RF_sel->out(wr_data);
    RF_sel->select(mux_RF_sel);

    DMR_sel = new Mul2("DMR_sel");
    DMR_sel->in1(Rx);
    DMR_sel->in2(operand);
    DMR_sel->out(data_rdadd);
    DMR_sel->select(mux_DMR_sel);

    DMW_sel = new Mul2("DMW_sel");
    DMW_sel->in1(Rz);
    DMW_sel->in2(operand);
    DMW_sel->out(data_wradd);
    DMW_sel->select(mux_DMW_sel);

    DM_Data_sel = new Mul4("DM_Data_sel");
    DM_Data_sel->in1(Rx);
    DM_Data_sel->in2(operand);
    DM_Data_sel->in3(PC_out);
    DM_Data_sel->in4(uint16_null); // snet null signal because it doesnt have this input.
    DM_Data_sel->out(mux_DM_Data_out);
    DM_Data_sel->select(mux_DM_Data_sel);

    my_IR = new IR("my_IR");
    my_IR->CLK(CLK);
    my_IR->RST(RST);
    my_IR->ld_IR(ld_IR);
    my_IR->I_in(I_in);

    my_IR->IReg(I_code);

    my_Data_mem = new data_mem("my_Data_mem","work.data_mem"); // Gives an error, dunno how to fix
    my_Data_mem->clock(lg_CLK);
    my_Data_mem->data(DM_data_in);
    my_Data_mem->rdaddress(DM_rdaddress);
    my_Data_mem->wraddress(DM_wraddress);
    my_Data_mem->wren(DM_wren);
    my_Data_mem->q(DM_q);

    my_Prog_mem = new prog_mem("my_Prog_mem","work.prog_mem"); // Gives an error, dunno how to fix
    my_Prog_mem->clock(lg_CLK);
    my_Prog_mem->data(PM_data_in);
    my_Prog_mem->rdaddress(PM_rdaddress);
    my_Prog_mem->wraddress(PM_wraddress);
    my_Prog_mem->wren(PM_wren);
    my_Prog_mem->q(PM_q);

    my_RF = new RF("my_RF");
    my_RF->RST(RST);
    my_RF->CLK(CLK);
    my_RF->sel_x(sel_x);
    my_RF->sel_z(sel_z);

    my_RF->wr_en(wr_en);
    my_RF->wr_dest(wr_dest);
    my_RF->wr_data(wr_data);

    my_RF->X(Rx);
    my_RF->Z(Rz);
    my_RF->ccd(CCD);
    my_RF->pcd(PCD);

    my_PC = new PC("my_PC");
    my_PC->CLK(CLK);
    my_PC->RST(RST);
    my_PC->PC_mux_in(mux_PC_sel);
    my_PC->Operand(operand);
    my_PC->Rx(Rx);
    my_PC->Data_out(DM_out);
    my_PC->PC_reg_ld(PC_reg_ld);
    my_PC->Prog_mem_out(PC_out);

    SIPR = new Register("SIPR");
    SIPR->CLK(CLK);
    SIPR->RST(RST);
    SIPR->Ld_Reg(SIP_Ld_Reg);
    SIPR->Input(SIPi);
    SIPR->Output(SIP);

    SOP = new Register("SOP");
    SOP->CLK(CLK);
    SOP->RST(RST);
    SOP->Ld_Reg(SOP_Ld_Reg);
    SOP->Input(Rx);
    SOP->Output(SOPi);

    SVOP = new Register("SVOP");
    SVOP->CLK(CLK);
    SVOP->RST(RST);
    SVOP->Ld_Reg(SVOP_Ld_Reg);
    SVOP->Input(Rx);
    SVOP->Output(SVOPi);

  }
};

#endif // __DATAPATH_H_
