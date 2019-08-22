//Verilog HDL for "sandboxTRdave", "TR_INFERENCE" "functional"
//DAVE WAS HERE
module TR_INFERENCE ( VDD, VSS,
		      CLK, RST, STS, DONE, SMAC,
		      LBstart, LBtemp, ARstart, DOUTN, READ_DONE, LB_ACT, LB_BCLK, LB_ACLK,
		      ADDRESS, READ_S, WRITE_S, PD_ACT, RESET_ACC, RESET_MULT, LATCH_ACC, LATCH_MULT, LB_READ, LB_WRITE, MACSEL, BIASSEL, BIASCK, MACBUS_EN, LB_BUFSEL );
   inout VDD, VSS;
   //State IO
   input CLK;
   input RST;
   input STS;
   input SMAC;
   output reg DONE;
   //Fixed
   input [15:0] ARstart;
   input [9:0] 	LBstart;
   input [9:0] 	LBtemp;
   //Array
   input [31:0] DOUTN;
   input 	READ_DONE;
   output [15:0] ADDRESS;
   output reg 	 READ_S;
   output reg 	 WRITE_S;
   output 	 PD_ACT;
   //MAC/LB
   output reg 	 RESET_ACC;
   output reg 	 RESET_MULT;
   output reg 	 LATCH_ACC;
   output 	 LATCH_MULT;
   output reg 	 LB_READ;
   output reg 	 LB_WRITE;
   output 	 LB_ACT;
   output 	 LB_BCLK;
   output 	 LB_ACLK;
   output [1:0]  MACSEL;
   output reg 	 MACBUS_EN;
   output reg [3:0] BIASCK;
   output reg 	    BIASSEL;
   output reg 	    LB_BUFSEL;

   //---- INTERNAL ----
   reg 		    layerMode;
   reg 		    layerCont;
   reg [1:0] 	    biasCount;
   reg [7:0] 	    layerInpNeu;
   reg [7:0] 	    layerInpNeu_i;
   reg [7:0] 	    layerOutNeu;
   reg [7:0] 	    layerOutNeu_i;
   reg [3:0] 	    counter;
   reg 		    LATCH_MULT_int;
   reg [15:0] 	    array_addr;
   reg [9:0] 	    lb_addr;
   reg [9:0] 	    lbtemp_addr;
   reg 		    LBaddrsel;
   reg 		    selectMAC;
   reg [4:0] 	    state;
   reg [4:0] 	    next;
   reg [4:0] 	    nextNext;
   reg [9:0] 	    sparse_0;
   reg [9:0] 	    sparse_1;
   reg [9:0] 	    sparse_2;
   reg 		    forceAddr; //NEW
   reg [9:0] 	    addrOffset; //NEW
   reg [15:0] 	    force_addr; //NEW
   reg 		    SMAC_EN; //added nibir - 05/15/2019
   
   localparam
     sSTART		= 0,
     sGETLAYER	= 1,
     sGETLAYER_ret = 2,
     sRD			= 3,
     sRDCHECK		= 4,
     sRDDEL		= 5,
     sMACpre		= 6,
     sLBRD		= 7,
     sMULT		= 8,
     sACC			= 9,
     sMACstart	= 10,
     sMACpost 	= 11,
     sBIASA		= 12,
     sBIASB		= 13,
     sBIASC		= 14,
     sLBWA		= 15,
     sLBWB		= 16,
     sLBWC		= 17,
     sLBWD		= 18,
     sOUTNEU		= 19,
     sLBCPA		= 20,
     sLBCPB		= 21,
     sLBCPB2		= 22,
     sLBCPC		= 23,
     sLBCPD		= 24,
     sLBCPD2		= 25,
     sLBCPE		= 26,
     sLAYER		= 27,
     sGETSPARSE	= 28,
     sDONE		= 29,
     sSMAC_ENABLE    = 30;
   //---------------------
   //---- ASSIGNMENTS ----
   //---------------------
   wire [7:0] 	    inpCompare;
   assign inpCompare = layerInpNeu == 3 ? layerInpNeu : layerInpNeu + 1;
   wire [9:0] 	    LBstartortemp;
   wire [15:0] 	    ARnormalorforce;
   assign LBstartortemp = LBaddrsel ? LBtemp + lbtemp_addr : LBstart + lb_addr;
   assign ARnormalorforce = forceAddr ? ARstart + addrOffset + force_addr : ARstart + array_addr; //NEW
   assign ADDRESS = WRITE_S ? LBstartortemp : ARnormalorforce;
   //	assign ADDRESS = WRITE_S ? LBstartortemp : ARstart + array_addr;
   //	assign [MUXsel 
   //	always @(*) begin
   
   //	end
   assign MACSEL[0] = counter[0] & MACBUS_EN;
   assign MACSEL[1] = counter[1] & MACBUS_EN;
   assign LB_ACT = WRITE_S;
   //-----------------------
   //---- MANUAL BLOCKS ----
   //-----------------------
   reg 		    PD_ACT_int;
   reg 		    RD_clr;
   wire [31:0] 	    DOUT;
   //Prop delay for PD_ACT sanity
   DEL0N7X1CR9	IPDDEL( .I(PD_ACT_int), .O(PD_ACT), .VCCK(VDD), .GNDK(VSS));
   //Async latch for READ_DONE
   TIE1X1CR9	IT1( .TIE1(Tie1), .VCCK(VDD), .GNDK(VSS));
   DFFRBQX05CR9	IRDL(.RB (~RD_clr), .CK (READ_DONE), .D (Tie1), .Q(READ_DONE_l),.VCCK(VDD), .GNDK(VSS));	
   //Async latch for DOUTN + Inverter @READ_DONE
   DFFQBX05CR9	IDL_0 ( .QB(DOUT[0]), .CK(READ_DONE), .D(DOUTN[0]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_1 ( .QB(DOUT[1]), .CK(READ_DONE), .D(DOUTN[1]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_2 ( .QB(DOUT[2]), .CK(READ_DONE), .D(DOUTN[2]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_3 ( .QB(DOUT[3]), .CK(READ_DONE), .D(DOUTN[3]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_4 ( .QB(DOUT[4]), .CK(READ_DONE), .D(DOUTN[4]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_5 ( .QB(DOUT[5]), .CK(READ_DONE), .D(DOUTN[5]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_6 ( .QB(DOUT[6]), .CK(READ_DONE), .D(DOUTN[6]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_7 ( .QB(DOUT[7]), .CK(READ_DONE), .D(DOUTN[7]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_8 ( .QB(DOUT[8]), .CK(READ_DONE), .D(DOUTN[8]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_9 ( .QB(DOUT[9]), .CK(READ_DONE), .D(DOUTN[9]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_10 ( .QB(DOUT[10]), .CK(READ_DONE), .D(DOUTN[10]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_11 ( .QB(DOUT[11]), .CK(READ_DONE), .D(DOUTN[11]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_12 ( .QB(DOUT[12]), .CK(READ_DONE), .D(DOUTN[12]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_13 ( .QB(DOUT[13]), .CK(READ_DONE), .D(DOUTN[13]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_14 ( .QB(DOUT[14]), .CK(READ_DONE), .D(DOUTN[14]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_15 ( .QB(DOUT[15]), .CK(READ_DONE), .D(DOUTN[15]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_16 ( .QB(DOUT[16]), .CK(READ_DONE), .D(DOUTN[16]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_17 ( .QB(DOUT[17]), .CK(READ_DONE), .D(DOUTN[17]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_18 ( .QB(DOUT[18]), .CK(READ_DONE), .D(DOUTN[18]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_19 ( .QB(DOUT[19]), .CK(READ_DONE), .D(DOUTN[19]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_20 ( .QB(DOUT[20]), .CK(READ_DONE), .D(DOUTN[20]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_21 ( .QB(DOUT[21]), .CK(READ_DONE), .D(DOUTN[21]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_22 ( .QB(DOUT[22]), .CK(READ_DONE), .D(DOUTN[22]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_23 ( .QB(DOUT[23]), .CK(READ_DONE), .D(DOUTN[23]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_24 ( .QB(DOUT[24]), .CK(READ_DONE), .D(DOUTN[24]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_25 ( .QB(DOUT[25]), .CK(READ_DONE), .D(DOUTN[25]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_26 ( .QB(DOUT[26]), .CK(READ_DONE), .D(DOUTN[26]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_27 ( .QB(DOUT[27]), .CK(READ_DONE), .D(DOUTN[27]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_28 ( .QB(DOUT[28]), .CK(READ_DONE), .D(DOUTN[28]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_29 ( .QB(DOUT[29]), .CK(READ_DONE), .D(DOUTN[29]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_30 ( .QB(DOUT[30]), .CK(READ_DONE), .D(DOUTN[30]), .VCCK(VDD), .GNDK(VSS));
   DFFQBX05CR9	IDL_31 ( .QB(DOUT[31]), .CK(READ_DONE), .D(DOUTN[31]), .VCCK(VDD), .GNDK(VSS));
   //Pulsegen
   assign LATCH_MULT_clk = LATCH_MULT_int & CLK;
   DEL1N4X1CR9	IPG_1 (.I(LATCH_MULT_clk), .O(PG_1),.VCCK(VDD), .GNDK(VSS));
   INVX1CR9 	IPG_2 (.I(PG_1), .O(PG_2),.VCCK(VDD), .GNDK(VSS));
   AND2X1CR9	IPG_3 (.I1(LATCH_MULT_clk), .I2(PG_2), .O(LB_BCLK),.VCCK(VDD), .GNDK(VSS));
   DEL0N7X1CR9	IPG_4 (.I(LB_BCLK), .O(PG_3),.VCCK(VDD), .GNDK(VSS));
   INVX1CR9 	IPG_5 (.I(PG_3), .O(PG_4),.VCCK(VDD), .GNDK(VSS));
   DEL1N4X1CR9	IPG_6 (.I(PG_4), .O(PG_5),.VCCK(VDD), .GNDK(VSS));
   INVX1CR9 	IPG_7 (.I(PG_5), .O(PG_6),.VCCK(VDD), .GNDK(VSS));
   AND2X1CR9	IPG_8 (.I1(PG_4), .I2(PG_6), .O(LATCH_MULT),.VCCK(VDD), .GNDK(VSS));
   DEL0N7X1CR9	IPG_9 (.I(LATCH_MULT), .O(PG_7),.VCCK(VDD), .GNDK(VSS));
   INVX1CR9 	IPG_A (.I(PG_7), .O(PG_8),.VCCK(VDD), .GNDK(VSS));
   DEL1N4X1CR9	IPG_B (.I(PG_8), .O(PG_9),.VCCK(VDD), .GNDK(VSS));
   INVX1CR9 	IPG_C (.I(PG_9), .O(PG_A),.VCCK(VDD), .GNDK(VSS));
   AND2X1CR9	IPG_D (.I1(PG_8), .I2(PG_A), .O(LB_ACLK),.VCCK(VDD), .GNDK(VSS));
   //SMAC STUFF
   wire 	    SMAC_int;
   AND2B1X1CR9	ISANITY(.I1(SMAC), .B2(STS), .O(SMAC_int_new),.VCCK(VDD), .GNDK(VSS));
   //ASYNC latch for RST
   TIE0X1CR9	IT2( .TIE0(Tie2),.VCCK(VDD), .GNDK(VSS));
   DFFSBQX1CR9	IRSTL(.SB (~RST), .CK (CLK & RST_and), .D (Tie2), .Q(RST_l),.VCCK(VDD), .GNDK(VSS));	
   DFFRBQX05CR9	IRSTC(.RB (~RST), .CK (CLK & RST_l), .D (~RST_and), .Q(RST_and),.VCCK(VDD), .GNDK(VSS));

   
   AND2X1CR9	ISMAC_8 (.I1(SMAC_EN), .I2(SMAC_int_new), .O(SMAC_int),.VCCK(VDD), .GNDK(VSS));	//added nibir - 05/15/2019
   //---------------------
   //---- CLOCK BLOCK ----
   //---------------------

   //added nibir 05-15-2019 
   
   //always @(posedge SMAC) begin
   //   if(SMAC) begin
   //   SMAC_EN = 1;
   //   rArray;
   //   next = sRD;
   //   nextNext = sMACpre;
   //  end
   //   else begin
   //      nextNext = nextNext;
   //      end
   //end // UNMATCHED !!



   
   always @(posedge CLK) begin
      if (RST_l) begin
	 tRESET;
	 RD_clr <= 1;
	 state <= sSTART;
      end else begin
	 state <= next;
	 case (next)
	   sSTART : begin

	   end
	   sSMAC_ENABLE : begin
	      rArray;
	      nextNext		<= sMACpre;
	      SMAC_EN = 1;
              forceAddr <= (SMAC) ? 0:forceAddr;  //added -05/16/2019 nibir
	      
	   end
	   
	   sGETLAYER : begin
	      rArray;
	      layerOutNeu_i	<= 0;
	      nextNext			<= sGETLAYER_ret;
	      forceAddr		<= 0; //NEW
	      force_addr		<= 0; //NEW
	   end
	   sRD : begin
	      DONE				<= 0;
	      PD_ACT_int		<= 0;
	   end
	   sRDDEL : begin
	      READ_S			<= 0;
	      RD_clr			<= 1;
	      if( nextNext	== sGETLAYER_ret ) begin
		 layerMode	<= DOUT[31];
		 biasCount	<= DOUT[30:29];
		 layerCont	<= DOUT[28];
		 forceAddr	<= DOUT[27]; //NEW
		 addrOffset	<= DOUT[25:16]; //NEW
	      end else if ( nextNext == sGETSPARSE ) begin
		 sparse_0		<= DOUT[9:0];
		 sparse_1		<= DOUT[19:10];
		 sparse_2		<= DOUT[29:20];
		 layerInpNeu[0] <= DOUT[30];
		 layerInpNeu[1] <= DOUT[31];
		 layerInpNeu[7:2] <= 0;
	      end
	   end
	   sGETLAYER_ret : begin
	      rArray;
	      array_addr		<= array_addr + 1; //This one always increments because it is always a real addr and not forced.
	      layerOutNeu		<= DOUT[7:0];
	      if (layerMode) begin
		 nextNext 	<= sGETSPARSE;
	      end else begin
		 layerInpNeu	<= DOUT[15:8];
		 nextNext		<= sMACpre;
	      end
	   end
	   sMACpre : begin
	      RESET_ACC		<= 1;
	      RESET_MULT		<= 1;
	      layerInpNeu_i	<= 0;
	      lb_addr			<= 0;
	      counter			<= 0;
	      nextNext			<= sMULT;
	      rLB;
	   end
	   sLBRD : begin
	      PD_ACT_int		<= 0;
	      LB_READ			<= 0;
	      RESET_ACC		<= 0;
	      RESET_MULT		<= 0;
	   end
	   sMULT : begin
	      WRITE_S			<= 0;
	      counter			<= counter + 1;
	   end
	   sACC : begin
	      LATCH_ACC		<= 1;
	      if( forceAddr ) begin
		 force_addr		<= force_addr + 1;
	      end else begin
		 array_addr		<= array_addr + 1;
	      end
	      layerInpNeu_i	<= layerInpNeu_i + 1;
	      if( !layerMode ) begin
		 lb_addr		<= lb_addr + 1;
	      end
	   end
	   sMACpost : begin
	      LATCH_ACC		<= 0;
	      if (!SMAC_int) begin
		 rArray;
		 if( layerMode ) begin
		    if (layerInpNeu_i < inpCompare) begin
		       nextNext				<= sMACstart;
		    end else begin
		       if(layerInpNeu == 3) begin
			  nextNext			<= sGETSPARSE;
		       end else begin
			  layerOutNeu_i	<= layerOutNeu_i + 1;
			  counter			<= 0;
			  nextNext			<= sBIASA;
			  BIASSEL		<= 1;
		       end
		    end
		 end else begin
		    if (layerInpNeu_i < layerInpNeu) begin
		       nextNext		<= sMACstart;
		    end else begin
		       layerOutNeu_i <= layerOutNeu_i + 1;
		       counter		<= 0;
		       nextNext		<= sBIASA;
		       BIASSEL		<= 1;
		    end
		 end
	      end
	   end
	   sMACstart : begin
	      RESET_MULT		<= 1;
	      MACBUS_EN		<= 0;
	      if( layerMode ) begin
		 case (layerInpNeu_i) 
		   0 :	lb_addr <= sparse_0;
		   1 :	lb_addr <= sparse_1;
		   2 :	lb_addr <= sparse_2;
		   default: lb_addr <= 0;
		 endcase
	      end
	      counter			<= 0;
	      nextNext			<= sMULT;
	      rLB;
	   end
	   sBIASA : begin
	      case (counter)
		0 : BIASCK		<= 1;
		1 : BIASCK		<= 2;
		2 : BIASCK		<= 4;
		3 : BIASCK		<= 8;
	      endcase
	   end
	   sBIASB : begin
	      BIASCK			<= 0;
	      RD_clr			<= 0;
	      counter			<= counter + 1;
	      if( forceAddr ) begin
		 force_addr		<= force_addr + 1;
	      end else begin
		 array_addr		<= array_addr + 1;
	      end
	      nextNext			<= sBIASA;
	      rArray;
	   end
	   sBIASC : begin
	      BIASCK			<= 0;
	      RD_clr			<= 0;
	      LATCH_ACC		<= 1;
	      MACBUS_EN		<= 1;
	      counter			<= 0;
	      if( forceAddr ) begin
		 force_addr		<= force_addr + 1;
	      end else begin
		 array_addr		<= array_addr + 1;
	      end
	   end
	   sLBWA : begin
	      LATCH_ACC		<= 0;
	      LB_BUFSEL		<= 0;
	      BIASSEL			<= 0;
	   end
	   sLBWB : begin
	      wLB;
	   end
	   sLBWC : begin
	      PD_ACT_int		<= 0;
	      LB_WRITE 		<= 0;
	      counter			<= counter + 1;
	      lbtemp_addr		<= lbtemp_addr + 1;
	   end
	   sLBWD : begin
	      PD_ACT_int		<= 0;
	      LB_WRITE			<= 0;
	      WRITE_S		<= 0;
	      MACBUS_EN		<= 0;
	   end
	   sOUTNEU : begin
	      if( layerOutNeu_i < layerOutNeu ) begin
		 rArray;
		 if( layerMode ) begin
		    nextNext		<= sGETSPARSE;
		 end else begin
		    nextNext		<= sMACpre;
		 end
	      end else begin
		 lbtemp_addr	<= 0;
		 counter		<= 0;	
		 layerInpNeu_i <= 0;
		 lb_addr		<= 0;			
	      end
	   end
	   sLBCPA : begin
	      layerOutNeu_i	<= 0;
	      LB_BUFSEL		<= 1;
	   end
	   sLBCPB : begin
	      rLB;
	      counter			<= counter + 1;
	   end
	   sLBCPB2 : begin
	      layerOutNeu_i	<= layerOutNeu_i + 1;
	      counter			<= 0;
	      rLB;
	   end
	   sLBCPC : begin
	      PD_ACT_int		<= 0;
	      LB_READ			<= 0;
	   end
	   sLBCPD : begin
	      wLB;	
	   end
	   sLBCPD2 : begin
	      wLB;
	   end
	   sLBCPE : begin
	      PD_ACT_int		<= 0;
	      LB_WRITE			<= 0;
	      layerInpNeu_i	<= layerInpNeu_i + 1;
	      lb_addr			<= lb_addr + 1;
	      lbtemp_addr		<= lbtemp_addr + 1;
	   end
	   sLAYER : begin
	      LB_BUFSEL		<= 0;
	      WRITE_S			<= 0;
	   end
	   sDONE : begin //THE END IS HERE
	      DONE				<= 1;
	      if (SMAC) begin 
		 SMAC_EN = 1;
   	      end
	   end
	   sGETSPARSE : begin
	      rArray;
	      if( forceAddr ) begin
		 force_addr		<= force_addr + 1;
	      end else begin
		 array_addr		<= array_addr + 1;
	      end
	      nextNext			<= sMACstart;
	      layerInpNeu_i	<= 0;
	      counter			<= 0;
	      RESET_ACC		<= 1;
	   end
	 endcase
      end // else: !if(RST_l)
   end
   //------------------------
   //---- ALWAYS * BLOCK ----
   //------------------------
   always @(*) begin
      next = state;
      LATCH_MULT_int = 0;
      LBaddrsel = 0;
      //	        SMAC_EN = 0;	   
      case (state)
	sSTART : begin
	   if (STS) begin
	      next = sGETLAYER;
	      //  SMAC_EN = 0; 			
	   end else 
	     if (SMAC) begin
		next = sSMAC_ENABLE;
		//    SMAC_EN = 1;   		       				   
	     end  
	end
	sSMAC_ENABLE : begin
	   next = sRD;
	end
	sGETLAYER : begin
	   next = sRD;
	end
	sGETLAYER_ret : begin
	   next = sRD;
	end
	sRD : begin
	   if (READ_DONE_l) begin
	      next = sRDCHECK;
	   end
	end
	sRDCHECK : begin
	   if (READ_DONE_l) begin
	      next = sRDDEL;
	   end else begin
	      next = sRD;
	   end
	end
	sRDDEL : begin
	   next = nextNext;
	end
	sMACpre : begin
	   next = sLBRD;
	end
	sLBRD : begin
	   next = nextNext;
	end
	sMULT : begin
	   if (counter <= 8) begin
	      LATCH_MULT_int = 1;
	   end else begin
	      next = sACC;
	   end
	end
	sACC : begin
	   next = sMACpost;
	end
	sMACpost : begin
	   if (SMAC) begin
	      next = sDONE;
	      //   SMAC_EN = 0;     //added nibir 05-15-2019
	      
	   end else begin
	      next = sRD;
	   end
	end
	sMACstart : begin
	   next = sLBRD;
	end
	sBIASA : begin
	   if ( counter < biasCount ) begin
	      next = sBIASB;
	   end else begin
	      next = sBIASC;
	   end
	end
	sBIASB : begin
	   next = sRD;
	end
	sBIASC : begin
	   next = sLBWA;
	end
	sLBWA : begin
	   LBaddrsel = 1;
	   if ( counter <= 3 ) begin
	      next = sLBWB;
	   end else begin
	      next = sLBWD;
	   end
	end
	sLBWB : begin
	   LBaddrsel = 1;
	   next = sLBWC;
	end
	sLBWC : begin
	   LBaddrsel = 1;
	   next = sLBWA;
	end
	sLBWD : begin
	   next = sOUTNEU;
	end
	sOUTNEU : begin
	   if( layerOutNeu_i < layerOutNeu ) begin //changed
	      next = sRD;
	   end else begin
	      next = sLBCPA;
	   end
	end
	sLBCPA : begin
	   LBaddrsel = 1;
	   next = sLBCPB;
	end
	sLBCPB : begin
	   LBaddrsel = 1;
	   next = sLBCPC;
	end
	sLBCPB2 : begin
	   LBaddrsel = 1;
	   next = sLBCPC;
	end
	sLBCPC : begin
	   LBaddrsel = 1;
	   if( counter < 3 ) begin
	      next = sLBCPD;
	   end else begin
	      next = sLBCPD2;
	   end
	end
	sLBCPD : begin
	   next = sLBCPE;
	end
	sLBCPD2 : begin
	   next = sLBCPE;
	end
	sLBCPE : begin
	   if( layerOutNeu_i < layerOutNeu ) begin
	      if( counter == 3 ) begin
		 next = sLBCPB2;
	      end else begin
		 next = sLBCPB;
	      end
	   end else begin
	      next = sLAYER;
	   end
	end
	sLAYER : begin
	   if( layerCont ) begin
	      next = sGETLAYER;
	   end else begin
	      next = sDONE;
	   end
	end
	sGETSPARSE : begin
	   next = sRD;
	end
	sDONE : begin
	   next = (STS) ? sSTART : state;
	end
	default : begin
	   next = state;
	end
      endcase
   end
   //---------------
   //---- TASKS ----
   //---------------
   task rArray;
      begin
	 RD_clr			<= 0;
	 READ_S			<= 1;
	 PD_ACT_int		<= 1;
      end
   endtask
   task rLB;
      begin
	 WRITE_S			<= 1;
	 PD_ACT_int		<= 1;
	 LB_READ			<= 1;
      end
   endtask
   task wLB;
      begin
	 WRITE_S			<= 1;
	 PD_ACT_int		<= 1;
	 LB_WRITE 		<= 1;
      end
   endtask
   task tRESET;
      begin
	 //Clear Counters
	 lb_addr			<= 0;
	 lbtemp_addr		<= 0;
	 array_addr		<= 0;
	 layerOutNeu_i	<= 0;
	 layerInpNeu_i	<= 0;
	 counter			<= 0;
	 //OUTPUT SIGNALS
	 BIASCK			<= 0;
	 DONE				<= 0;
	 READ_S			<= 0;
	 WRITE_S			<= 0;
	 LATCH_ACC		<= 0;
	 RESET_MULT		<= 0;
	 RESET_ACC		<= 0;
	 LB_READ			<= 0;
	 LB_WRITE 		<= 0;
	 BIASSEL			<= 0;
	 BIASCK			<= 0;
	 LB_BUFSEL		<= 0;
	 MACBUS_EN		<= 0;
	 //This stuff
	 PD_ACT_int		<= 0;
      end
   endtask
endmodule
