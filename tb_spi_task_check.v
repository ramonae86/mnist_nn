// ***************************************************************************************
// * t-2
// * File Name: tb_spi_task_check.v
// * $Header: /afs/btv.ibm.com/u/loeffler/veri/TPM20/bamc1/RCS/tb_spi_task_check.v,v 1.9 2012/12/27 16:58:42 loeffler Exp $
// * $Locker:  $
// *
// * Description: check test bench structure and task coding for SPI memory
// * Test bench is written around Macronix MX25U3235E data sheet
// *
// * Note: - Set simulator resolution to "ns" accuracy
// *
// *
// * Change_list
// * Version Author Date Changes
// * 1.0 G.Grise 02/02/11 initial coding
// * 2.0 G.Grise 03/01/11 TASK_CMD coded so that CS is driven high internally for those commands
// * which require that behavior.
// * 3.0 Afshin Nourivand 06/24/11 Chip model change \00SP_SUANNITOP plus  Calls to spi_init.vh, spi_tm_.vh
// * 4.0 G.Grise 06/29/11  TASK_CE1 and TASK_CE2 have real delays added back in.
// * 5.0 G.Grise 06/29/11  TASK_CE1 and TASK_CE2 have delays removed and points back to BAMC.v for fast debug.
//       see //gdg-fast comments
// * 6.0 G.Grise 07/05/11  TASK_CE1 and TASK_CE2 have real delays added back in.
// * 7.0 G.Grise 07/13/11  fixed bug in checkers where BAMC1 was not checked
// * 8.0 G.Grise 08/16/11 change page size to 512, address space to 32 bits
// * 9.0 G.Grise 08/25/11 added TASK_BAMC_DATA_CHECKER compares what was read from BAMC chip to data in WRITE_DATA_ARRAY
// * 10.0 G.Grise 08/28/11 added  WP_offstate, modified testbench so for spi test modes #WP is driven to WP_offstate
// * 11.0 G.Grise 10/11/12 added Test Mode commands to function ASCII_CMD
// * 12.0 G.Grise 10/19/12 modified erase tasks so they would exit as soon as the E_FAIL bit went to a 1
// *                       instead of waiting until the end of erase period and then checking.
// * 13.0 G.Grise 12/07/12 added Steffen's logging code, added TASK_BE2, TASK_BE32K2, TASK_MONITOR
// * 14.0 G.Grise 12/07/12 backed out Steffen's monitor code
// * 15.0 G.Grise 12/10/12 Added Steffen's sdfRevlister code and monitor code
// * 16.0 G.Grise 12/11/12 Added check for status and security register mismatches
// * 17.0 G.Grise 12/12/12 expanded checks for status and security register mismatches
// * 18.0 G.Grise 12/13/12 expanded checks for status and security register mismatches in TASK_PP, TASK_PP2, TASK_4PP
// * 19.0 G.Grise 12/13/12 changed sdf call from `include "./base_code/spi_sdf_v2_noIPL.vh"  to `include "./base_code/spi_sdf_v2.vh"
// * 20.0 G.Grise 12/13/12 commented out SUCCESS=1 in TASK_REGISTER_VALUE_CHECK
// * 21.0 G.Grise 12/16/12 changed @@step_failure to @@fail in log output
// *                       commented out TASK_REGISTER_VALUE_CHECK call at the end of TASK_CHECK_WIP_COMPLETE success as we are not doing WEL polling
// * 22.0 G.Grise 12/17/12 commented out TASK_WREN following TASK_WPSEL in tasks SBLK,GBLK,SBULK,GBULK, comments //gdg 12/17/2012
// * 23.0 G.Grise 12/19/12 added back in TASK_WREN following TASK_WPSEL in tasks SBLK,GBLK,SBULK,GBULK, added  TASK_STATUS_REGISTER_VALUE_CHECK which
// *                       waits for WEL to clear and added TASK_STATUS_SECURITY_REGISTER_VALUE_CHECK
// * 24.0 G.Grise 12/19/12  TASK_STATUS_REGISTER_VALUE_CHECK corrected to actually loop
// * 25.0 G.Grise 12/19/12  Removed WREN call from TASK_CHECK_WIP_COMPLETE
// * 26.0 G.Grise 12/19/12  commented out lines 5633-5637 and 5729-5733 to reduce log size during CE commands
// * 27.0 St. Loeffler 12/22/2012 formatting the task sequence. Line numbers have not been adjusted.
// * 27.1 St. Loeffler 12/22/2012 adding a RDSCUR before the final secure_register compare in TASK_PP (was failing in RUN9)
// * 27.2 St. Loeffler 12/27/2012 removing it again as it causes fails in some patterns that expect a given
//                                data in some variables at the end of TASK_PP which are modified
//                                by performing this RDSCUR command.
// *
// *_limitations :
// *
// * :
// * Errors :
// *
// ****************************************************************************************
// search for gdg to find sections which need work or variables which are temporarily overridden
// concerns - does performance enhance mode need additional coding
// WRSR should be ignored once in HPM mode

// not directly coded:
// suspend to read_latency is 20 uS pg 68
// resume to read_latency is TSE/TPE/TPP pg 68
// resume to suspend_lstency is 1 mS pg 68
// software reset recovery 66 followed by 99 tRCR, tRCP, 20 uS; tRCE 12 mS pg 68


//
//
// Tasks coded around sclk , rising edge_launches data to chip, falling edge reads memory from chip.
//
// Task coding --
// each task is a complete sequence of events for that task
// each task is coded to start on the previous operations falling edge
// @(negedge SCLK) - signals end of prior operation
//
// code when hold expires based off falling edge, data goes invalid after hold_time
//
// code here setup for the coming rising edge,
// dead_time is interval when signal is not valid = tCK/2 - (setup_time + hold)
// to set up data for the next rising edge, make data valid dead_time after the hold_time
//
// @(posedge SCLK) - signals start of operation
//
// code when hold expires based off rising edge, data goes invalid after hold_time
//
// code here setup for the coming falling edge,
// dead_time is interval when signal is not valid = tCK/2 - (setup_time + hold)
// to set up data for the next faling edge, make data valid dead_time after the hold_time


// tasks from SST data sheet page 11
// each task calls a TASK_GENERIC which has a command op, address OPs, dummy ops and then Data opps as appropriate

// Instruction Description pgs CMD Address Dummy Data data_type Maximum error cond
// Width cycles cycles freq

// WREN WriteEnable 21,50 06 0 0 0 any
// WRDI WriteDisable 22/51 04 0 0 0 any
// RDID ReadID 22/52 9F 0 0 3B read any *data is returned next cycle after_last cmd bit
// RDSR ReadStatus 22/52 05 05 0 1B READ
// WRSR WriteStatus 01
// READ1X ReadData 03
// FASTREAD1X FastReadData 0b
// SE SectorErase 20
// PP PageProgram 02
// READ2X 2XRead bb
// ENSO EnterSecuredOTP b1
// EXSO ExitSecuredOTP c1
// READ4X 4XI/ORead ebstask
// FIOPGM0 4I/OPgPgmloadAddData 38
// WPSEL WriteProtectSelect 68
// SBLK SingleBlockLock 36
// SBULK SingleBlockUnlock 39
// RDBLOCK BlockProtectRead 3c
// NOP NoP 00
// RSTEN ResetEnable 66
// RST ResetMemory 99

`timescale 1 ns / 1 ps

`include "/home/don/workspace/bingen/M31GPSC900HL040PR_50N_pwr_del.v"
module tb_spi_task_check;
   

   
`include "./base_code/mem.v"
`include "./base_code/memrelease.v" 
`include "./base_code/spi_parameters.vh"
`include "./base_code/AF.v"   
   //`include "./base_code/spi_init.vh"   
   

   // variables for test 61
   reg	[15:0]	Current_ADDR;
   reg [19:0] 	Current_word;
   reg [19:0] 	Data_word;
   integer 	RUN61_array_index;
   integer 	RUN61_start_index;
   integer 	RUN61_finish_index;
   integer 	RUN61_sorting_var;

   // controls needed for chip I/O
   reg 		SCLK ;
   reg 		ACLK;
   reg 		BCLK;
   reg 		LB_ACLK;
   reg 		LB_BCLK;      
   reg 		CS ;
   //reg 	CLKD;
   

   //wire CLKD_WIRE;
   //assign CLKD_WIRE = CLKD;   
   wire 	ACLK_WIRE;
   assign ACLK_WIRE = ACLK;   
   wire 	BCLK_WIRE;
   assign BCLK_WIRE = BCLK;   
   wire 	SCLK_WIRE;
   assign SCLK_WIRE = SCLK;   
   wire 	LB_ACLK_WIRE;
   assign LB_ACLK_WIRE = LB_ACLK;   
   wire 	LB_BCLK_WIRE;
   assign LB_BCLK_WIRE = LB_BCLK;   
   wire 	CS_WIRE;
   assign CS_WIRE = CS;
   //wire SI_B;
   //assign SI_B = SI;
   //wire SO_B;
   //assign SO_B = SO;
   
   reg 		SI_en ; // controls BiDI direction
   reg 		SI_out ;        // register to write data
   wire 	SI_B   =  SI_en ? SI_out : 1'bz ;       // SI/SIO0

   reg 		SO_en ; // controls BiDI direction
   reg 		SO_out ;        // register to write data
   wire 	SO_B   =  SO_en ? SO_out : 1'bz ;


   
   /////////Initialization of TESTMODES//////
   reg [55:0] 	TM_reg = 56'h0;
   initial
     begin
	force chip_2.TM[55:0] = TM_reg;
     end
   /////////////////////////////////////////     
   ////////Initialization of Addresses/////////
   //reg [15:0] ADDR_reg = 16'h0103;    
   //  initial 
   //chip_2.ADDR[15:0] = ADDR_reg;
   //    begin 
   //     force  chip_2.ADDR[15:0] = ADDR_reg;
   ////////////////////////////////////////////
   //   release chip_2.ADDR[15:0];
   // end  

   /////////////////////////////////////////////////
   //reg READ_DONE_reg = 0;
   //    initial
   //      begin
   //	 force chip_2.READ_DONE = READ_DONE_reg;
   //      end
   //////////////////////////////////////////////////
   //////////////////////////////////////////////////
   //   reg END_RST_REG = 0;
   //   initial
   //     begin
   //	force chip_2.ITOP.END_RST = END_RST_REG;
   //     end


   //   reg [7:0] AF_REG = 8'b01011011;
   // initial
   //   begin
   //	force chip2.ICOR.AF_DATA = AF_REG;
   //   end
   

   //   reg [31:0] MAC_OUT_REG = 32'h11117777;
   //initial
   //begin
   //   force chip_2.MAC_OUT[31:0] = MAC_OUT_REG;
   //end 
   ////////////////////////////////////////////////// 
   
   //   reg [3:0] WH_DATA_REG = 4'b1010;
   //   initial
   //  /   begin
   //	force chip_2.WH_DATA[3:0] = WH_DATA_REG;
   //	end


   //   reg [31:0] dout = 32'h01010101;
   //   initial
   //     begin
   //	force chip_2.DOUT_N[31:0] = dout;
   //     end
   

   reg VCC_reg = 1;
   initial
     begin
	force chip_2.VCC = VCC_reg;
     end
   
   /////////////////////////////////////////////////          
   
   reg     WRITE_ENABLE ;  // write was enabled
   reg [7:0] READ_DATA_ARRAY_G [0:511] ;       // 512 byte READ data repository chip 2 gmsi
   reg [7:0] READ_BYTE_M ;     // 1 byte of read data
   reg [7:0] READ_BYTE_G ;     // 1 byte of read data
   reg [7:0] WRITE_DATA_ARRAY[0:511] ; // 512 byte WRITE data repository
   reg [7:0] WRITE_BYTE ;
   reg [47:0] ADDRESS ;                // address repository
   reg 	      QPI_MODE = 0;
   
   //reg	      SCAN_DATA_IN [255:0];
   // data to keep track of what was run
   reg [1:0]  SPI_CMD_DATA [47:0] ;       // SPI CMDs during run
   reg [1:0]  SPI_STATUS_REG_DATA [7:0] ; //
   reg 	      MODE_SEL;
   reg 	      IPL_INHIBIT;
   
   
   wire       MODE_SEL_WIRE;
   assign     MODE_SEL_WIRE = MODE_SEL;
   
   
   //integer NUMBER_OF_CMD_CYCLES ;
   integer    NUMBER_OF_ADDRESS_BITS ;
   integer    NUMBER_OF_DUMMY_CYCLES ;
   integer    NUMBER_OF_WRITE_BYTES ;
   integer    NUMBER_OF_READ_BYTES ;

   integer    CS_TERMINATION ;
   integer    PROGRAMMING ;
   integer    ERASING ;

   integer    i ;     // used for bit_loops
   integer    j ;     // used for byte_loops
   integer    k ;     // used for outer test experiment loops
   integer    l ;     // used for scanbits
   integer    m ;     // for scanbase  
   integer    n ;     // for scan w/o AF
   integer    index_spi_cmd;
   integer    index_spi_address;
   integer    index_dummy_cycle; 
   integer    index_spi_write_outer;
   integer    index_spi_write_inner;
   integer    index_spi_read_outer;
   integer    index_spi_read_inner;
   integer    index_task_monitor;
   integer    index_task_track; 
   integer    index_task_cmd;
   integer    index_gmsi_data_checker;
   integer    index_scan_bits;
   integer    index_scan_af;   
   
   integer    time_out ;      // global, used to allow for time out checks
   reg 	      clock_on ;      // turns on external clock
   reg 	      clock_on_delay;
   
   reg [720:0] Operation ;     // string Experiment  (level 0 tasks)
   reg [720:0] Operation1 ;    // string Experiment routine calls
   reg [720:0] Operation2 ;    // string Routines (multiple Tasks calling tasks)
   reg [720:0] Operation3 ;    // string Higher TASK ( calls basic tasks)
   reg [720:0] Operation4 ;    // string Basic Task - does not call any other task
   reg [720:0] Operation5 ;    // string   sub hierarchy in Basic task
   reg [720:0] Operation6 ;    // string   sub - sub hierarchy in Basic task
   reg [720:0] Operation7 ;    // string             sub sub - sub hierarchy in Basic task
   reg [720:0] Operation8 ;    // string               sub sub - sub hierarchy in Basic task
   reg [720:0] MODE ;          // string
   reg [720:0] Status ;        // string
   reg [720:0] Check_reason ;  // string
   reg 	       WINDOW ;                // when read or write was enabled

   reg [720:0] Line_num ;      // Line_num


   // flags definition
   reg 	       Check_flag ;            // check number
   integer     Error_number ;          // error number
   integer     CHECK ; // just to check results
   // if debug variable = 1, turns on reporting for that level
   integer     debug_0 ;       // reports error and SUCCESS results
   integer     debug_1 ;       // reports each time a task is entered
   integer     debug_2 ;       // reports read, write values
   integer     debug_3 ;       // reports flow in level0 tasks including what is being passed
   integer     debug_4 ;       // reports flow in level3 tasks including what is being passed
   integer     debug_5 ;       // reports flow in level4 tasks including what is being passed
   integer     debug_6 ;       // reports flow in level5 tasks including what is being passed
   // variable to determing if fail is to be reported. set to 1 for expected fail and fail will not to be written out
   reg 	       expected_fail ;
   // verbose report
   integer     SUCCESS ;       // pass if checker was a SUCCESS
   integer     TEST_RUN ;       // If 1, the testbench run passed
   integer     RUN_NUMBER;     // RUN number
   reg [720:0] TEST_NUMBER;    // test number in run

   assign  VSS   = 0;
   //assign  VDD   = 1;
   wire        VDD;
   //assign  VCC   = 1;
   //wire VCC;   
   //reg  VCC_reg   = 1;
   //assign VCC = VCC_reg;
   //assign  VREAD = 1;
   
   TR_MAIN_00_TR_schematic  chip_2 (
      
				    .CSn_P		(CS_WIRE),		// chip select active_low
				    .ACLK_P		(ACLK_WIRE),		// clock
				    .BCLK_P		(BCLK_WIRE),		// clock
				    .CCLK_P		(SCLK_WIRE),		// clock
				    .LB_ACLK_P		(LB_ACLK_WIRE),	// clock
				    .LB_BCLK_P		(LB_BCLK_WIRE),	// clock				     
				    .SI_P			(SI_B),		// SI/SIO0
				    .SO_P			(SO_B),		// SO/SIO1
				    .VCC			(VCC),
				    .VDD			(VDD),				     
				    .VSS			(VSS),
				    .MODE_SEL_P		(MODE_SEL_WIRE),		// NEW Pad Supply, should float	   
				    .DIGMON_P		(DIGMON_P)		// NEW Bond Option
				    //  .CLKD_P               (CLKD_WIRE)				 // 				     	        
				    );   
   
   integer     tCK ;                           // clock period, gdg will be redefine
   integer     tDH ;                           // data hold
   integer     tDSU ;                          // data setup

   reg [31:0]  task_sequence;
   integer     task_time;
   integer     indent;
   initial indent = 0;
   initial task_sequence = $fopen("task_sequence.txt");
   initial task_time = 99999;
   // end of added (SL1)

`include "./base_code/spi_init.vh"
   //`include "./base_code/spi_tm.vh"
   
   // start section to signal completion of run
   reg 	       Simulation_Completed ;
   initial Simulation_Completed   =  0 ;

   // simulation complete driven by reaching end of file in chaofeng_test_exps.vh
   always @(Simulation_Completed)
     begin : all_done
	Line_num   =  " t-316" ;
	if (Simulation_Completed == 1)

	  begin : msg
	     Line_num   =  " t-320-" ;
	     $display ($time," t-321- Simulation is Complete") ;
	     //	$system ("grep -h /RCS/ ./base_code/spi_parameters.vh >>revision.log");
	     $stop(0) ;              // for MTI runs
	     $finish ;
	  end     // msg
     end             // all_done
   // end section to signal completion of run


   // start initialize variables
   initial
     begin : initialize
`include "./base_code/spi_sdf_v2.vh"
	// `include "./base_code/spi_sdf_v2_noIPL.vh"
	//	$system ("grep -h /RCS/ RUN >>revision.log");
	//	$system ("echo `pwd` `ls -alrt RUN`>> revision.log");
	//	$system ("grep -h /RCS/ tb_spi_task_check.v >>revision.log");
	//	$system ("echo `pwd` `ls -alrt tb_spi_task_check.v`>> revision.log");
	//	$system ("grep -h /RCS/ 02SP_SUANNITOP.v >>revision.log");
	//	$system ("echo `pwd` `ls -alrt 02SP_SUANNITOP.v`>> revision.log");
	//	$system ("grep -h /RCS/ TLE2.v >>revision.log");
	//	$system ("echo `pwd` `ls -alrt TLE2.v`>> revision.log");
	//	$system ("grep -h /RCS/ MX25U3235E.v >>revision.log");
	//	$system ("echo `pwd` `ls -alrt MX25U3235E.v`>> revision.log");
	//	$system ("grep -h /RCS/ ./base_code/spi_task_check_exps.vh >>revision.log");
	//	$system ("echo `pwd` `ls -alrt ./base_code/spi_task_check_exps.vh`>> revision.log");
	//	$system ("grep -h /RCS/ ./base_code/spi_parameters.vh >>revision.log");
	//	$system ("echo `pwd` `ls -alrt ./base_code/spi_parameters.vh`>> revision.log");
	//	$system ("grep -h /RCS/ ./base_code/spi_init.vh >>revision.log");
	//	$system ("echo `pwd` `ls -alrt ./base_code/spi_init.vh`>> revision.log");
	//	$system ("grep -h /RCS/ ./base_code/spi_tm.vh >>revision.log");
	//	$system ("echo `pwd` `ls -alrt ./base_code/spi_tm.vh`>> revision.log");
	//	$system ("grep -h /RCS/ ./base_code/Simulation_setup.vh >>revision.log");
	//	$system ("echo `pwd` `ls -alrt ./base_code/Simulation_setup.vh`>> revision.log");
	//	$system ("grep -h /RCS/ ./base_code/spi_sdf_v2.vh >>revision.log");
	//	$system ("echo `pwd` `ls -alrt ./base_code/spi_sdf_v2.vh`>> revision.log");
	//	$system ("grep -h /RCS/ ./benches/*.vh >>revision.log");
	//	$system ("echo `pwd` `ls -alrt ./benches/*.vh`>> revision.log");
	//	$system ("sdfRevlister  ./base_code/spi_sdf_v2.vh >>revision.log");
	tDSU   =  tDVCH ;
	tDH    =  tCHDX ;
	tCK    =  tRSCLK_period ;       // start out with slow clock (33 MHz )
	
	// clock is off on startup
	clock_on   =  1 ;       // temp turned on until TASK_POWER_ON is completed gdg
	clock_on_delay = 1;   
	Status     =  1'bx ;
	Check_flag =  0 ;
	debug_0    =  0 ;
	debug_1    =  0 ;
	debug_2    =  0 ;
	debug_3    =  0 ;
	debug_4    =  0 ; 
	debug_5    =  0 ;
	debug_6    =  0 ;
	expected_fail = 0;
	TEST_NUMBER    =  0 ;
	RUN_NUMBER     =  0 ;
	PROGRAMMING    =  0 ;
	ERASING        =  0  ;
	
	CS = 1;
	ACLK = 0;	
	BCLK 	=0;	
	LB_ACLK	=0;   
	LB_BCLK=0;				     
	SI_en	=0;	
	SI_out = 0;		 
	MODE_SEL	   =0;
   	
	
	TASK_TRACK_CMD_INIT;
	TASK_TRACK_REG_INIT;
	//  #1 VCC_reg <= 1;
	//  force chip_2.VDDI = 1;
     end     // initialize
   // endinitialize variables

   // generate a clock actual frequency will be redefined depending on cmd
   // external clock generator tCK defines frequency
   // gdg needs to be changed to handle mode 0 or mode 1
   always
     begin : make_clock
	SCLK <= 0 ;
	#(tCK/2) ;

	wait (clock_on == 1) ;

	SCLK <= 1 ;
	#(tCK/2) ;
     end     // make_clock
   //
   // end clock definition

   // Test included from external file


   //always @ ( posedge(SCLK) ) begin
   //  #(0.5-1)
   //	CLKD = 1;
   //end
   

   //always @ ( negedge(SCLK) ) begin
   //  #(0.5-1)
   //	CLKD = 0;
   //end
   
   

   
`include "./base_code/spi_task_check_exps.vh"
end // UNMATCHED !!







// Adding RDCR, DREAD, QREAD, SUSPEND2, SBL2, RESUME2 --VDB, September 11, 2018
// Removing EQIO, SBLK, SBULK, RDBLOCK, WPSEL, GBLK, GBULK, QPIID, W4READ, RSTQUI, SCANEN0 --VDB, September 11, 2018


function [96:0] ASCII_CMD; 
   input [7:0] cmd_in ;
   begin
      if (cmd_in === 8'h00) ASCII_CMD = "NOP 00h";
      else if (cmd_in === 8'h01) ASCII_CMD = "WRSR 01h";
      else if (cmd_in === 8'h02) ASCII_CMD = "PP 02h";
      else if (cmd_in === 8'h03) ASCII_CMD = "READ 03h";   
      else if (cmd_in === 8'h04) ASCII_CMD = "WRDI 04h";
      else if (cmd_in === 8'h05) ASCII_CMD = "RDSR 05h";
      else if (cmd_in === 8'h06) ASCII_CMD = "WREN 06h";
      else if (cmd_in === 8'h09) ASCII_CMD = "RDLB 09h";
      else if (cmd_in === 8'h10) ASCII_CMD = "NEURONACT 10h"; 
      else if (cmd_in === 8'h0B) ASCII_CMD = "FASTREAD 0Bh";
      else if (cmd_in === 8'h53) ASCII_CMD = "INF 53h";
      else if (cmd_in === 8'h54) ASCII_CMD = "NEUREAD 54h";
      else if (cmd_in === 8'h55) ASCII_CMD = "MACCYC 55h";
      else if (cmd_in === 8'h56) ASCII_CMD = "BIASBUF 56h";
      else if (cmd_in === 8'h57) ASCII_CMD = "SCE 57h";
      else if (cmd_in === 8'h58) ASCII_CMD = "SCEWAF 58h";
      else if (cmd_in === 8'h59) ASCII_CMD = "LBWR 59h";
      else if (cmd_in === 8'h66) ASCII_CMD = "RSTEN 66h";
      else if (cmd_in === 8'h98) ASCII_CMD = "ACCRST 98h";
      else if (cmd_in === 8'h99) ASCII_CMD = "RST 99h";

      else ASCII_CMD = "??";
   end
endfunction // if


// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED*****
// end define variables



// **START****START****START****START****START****START****START****START****START****START****START**
// $3 TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
// Level 3 routine
// Will call sub-tasks
// -- Normal Flow is CMD, Address, Dummy, read or write
// gdg not expected would do both read and write but no check to prevent miss call
// to do both read and write would be illegal , probably should add check

task TASK_GENERIC ;
   input   [7:0] CMD ;     // pass command code
   input 	 NUMBER_OF_ADDRESS_BITS ;
   input [47:0]  ADDRESS ;
   input 	 NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer
   input 	 NUMBER_OF_WRITE_BYTES ;
   input 	 NUMBER_OF_READ_BYTES ;
   
   integer 	 NUMBER_OF_ADDRESS_BITS ;
   integer 	 NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer
   integer 	 NUMBER_OF_WRITE_BYTES ;
   integer 	 NUMBER_OF_READ_BYTES ;
   begin :initial_begin
      task_monitor("TASK_GENERIC",1);
      $fwrite(task_sequence, "                     CMD='h%h, NoAB='h%h,ADDR='h%h,  NoDC='h%h, NoWB='h%h, NoRB='h%h\n"
	      , CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS, NUMBER_OF_DUMMY_CYCLES, NUMBER_OF_WRITE_BYTES, NUMBER_OF_READ_BYTES);
      Line_num       =  " t-484" ;
      Operation3     =  " t-485 TASK_GENERIC" ;

      if (debug_1 == 1) $display ($time," t-487- TASK_GENERIC ") ;
      if (debug_4 == 1) $display ($time," t-488- TASK_GENERIC-> NUMBER_OF_ADDRESS_BITS = %d ", NUMBER_OF_ADDRESS_BITS ) ;
      if (debug_4 == 1) $display ($time," t-489- TASK_GENERIC-> ADDRESS = %h ", ADDRESS ) ;
      if (debug_4 == 1) $display ($time," t-490- TASK_GENERIC-> NUMBER_OF_DUMMY_CYCLES = %d ", NUMBER_OF_DUMMY_CYCLES ) ;
      if (debug_4 == 1) $display ($time," t-491- TASK_GENERIC-> NUMBER_OF_WRITE_BYTES = %d ", NUMBER_OF_WRITE_BYTES ) ;
      if (debug_4 == 1) $display ($time," t-492- TASK_GENERIC-> NUMBER_OF_READ_BYTES = %d ", NUMBER_OF_READ_BYTES ) ;
      TASK_CMD(CMD) ;
      // do test if address cycles are needed
      if (NUMBER_OF_ADDRESS_BITS != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-497- TASK_GENERIC->TASK_ADDRESS") ;
	   Line_num   =  " t-498-" ;
	   MODE       =  "ADDRESS MODE" ;
	   TASK_ADDRESS(NUMBER_OF_ADDRESS_BITS,ADDRESS) ;
	end
      // do test if dummy cycles are needed
      if (NUMBER_OF_DUMMY_CYCLES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-505- TASK_GENERIC->TASK_DUMMY") ;
	   Line_num   =  " t-506-" ;
	   MODE       =  "DUMMY MODE" ;
	   TASK_DUMMY(NUMBER_OF_DUMMY_CYCLES) ;
	end

      // do test if write cycles are needed
      if (NUMBER_OF_WRITE_BYTES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-514- TASK_GENERIC->TASK_WRITE") ;
	   Line_num   =  " t-515" ;
	   MODE       =  "WRITE MODE" ;
	   TASK_WRITE(NUMBER_OF_WRITE_BYTES) ;
	end

      // do test if read cycles are needed
      if (NUMBER_OF_READ_BYTES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-523- TASK_GENERIC->TASK_READ") ;
	   Line_num   =  " t-524" ;
	   MODE       =  "READ MODE" ;
	   TASK_SPI_READ(NUMBER_OF_READ_BYTES) ;
	end
      if (debug_4 == 1) $display ($time," t-528- TASK_GENERIC->END") ;
      Operation3 =  1'bx ;
      @(negedge SCLK) CS =  1 ;
      SI_out = 0;
      
      task_monitor("TASK_GENERIC",0);
   end

endtask // TASK_GENERIC
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******



// **START****START****START****START****START****START****START****START****START****START****START**
// $3 TASK_GENERIC2 (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
// Level 3 routine
// Will call sub-tasks
// Same as TASK_GENERIC except call TASK_CMD2, no return high of CS after CMD
// -- Normal Flow is CMD, Address, Dummy, read or write
// gdg not expected would do both read and write but no check to prevent miss call
// to do both read and write would be illegal , probably should add check
//
// global signals used
// reg QPI_MODE ; // if 0 we are in SPI mode, if 1 we are in QPI mode
// reg I2O_MODE ; // if 0 we are in not in 2 io mode, if 1 we are in 2 io mode
// reg I4O_MODE ; // if 0 we are in not in 4 io mode, if 1 we are in 4 io mode
//
task TASK_GENERIC2 ;
   input   [7:0] CMD ;     // pass command code
   input 	 NUMBER_OF_ADDRESS_BITS ;
   input [47:0]  ADDRESS ;
   input 	 NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer
   input 	 NUMBER_OF_WRITE_BYTES ;
   input 	 NUMBER_OF_READ_BYTES ;

   integer 	 NUMBER_OF_ADDRESS_BITS ;
   integer 	 NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer
   integer 	 NUMBER_OF_WRITE_BYTES ;
   integer 	 NUMBER_OF_READ_BYTES ;
   begin :initial_begin
      task_monitor("TASK_GENERIC2",1);
      Line_num   =  " t-567" ;
      Operation3 =  " t-568 TASK_GENERIC2" ;

      if (debug_1 == 1) $display ($time," t-570- TASK_GENERIC2 ") ;
      if (debug_4 == 1) $display ($time," t-571- TASK_GENERIC2-> NUMBER_OF_ADDRESS_BITS = %d ", NUMBER_OF_ADDRESS_BITS ) ;
      if (debug_4 == 1) $display ($time," t-572- TASK_GENERIC2-> ADDRESS = %h ", ADDRESS ) ;
      if (debug_4 == 1) $display ($time," t-573- TASK_GENERIC2-> NUMBER_OF_DUMMY_CYCLES = %d ", NUMBER_OF_DUMMY_CYCLES ) ;
      if (debug_4 == 1) $display ($time," t-574- TASK_GENERIC2-> NUMBER_OF_WRITE_BYTES = %d ", NUMBER_OF_WRITE_BYTES ) ;
      if (debug_4 == 1) $display ($time," t-575- TASK_GENERIC2-> NUMBER_OF_READ_BYTES = %d ", NUMBER_OF_READ_BYTES ) ;
      TASK_CMD2(CMD) ;
      // do test if address cycles are needed
      if (NUMBER_OF_ADDRESS_BITS != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-580- TASK_GENERIC2->TASK_ADDRESS") ;
	   Line_num   =  " t-581-" ;
	   MODE       =  "ADDRESS MODE" ;
	   TASK_ADDRESS(NUMBER_OF_ADDRESS_BITS,ADDRESS) ;
	end

      
      // do test if dummy cycles are needed
      if (NUMBER_OF_DUMMY_CYCLES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-588- TASK_GENERIC2->TASK_DUMMY") ;
	   Line_num   =  " t-589-" ;
	   MODE       =  "DUMMY MODE" ;
	   TASK_DUMMY(NUMBER_OF_DUMMY_CYCLES) ;
	end

      // do test if write cycles are needed
      if (NUMBER_OF_WRITE_BYTES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-597- TASK_GENERIC2->TASK_WRITE") ;
	   Line_num   =  " t-598" ;
	   MODE       =  "WRITE MODE" ;
	   TASK_WRITE(NUMBER_OF_WRITE_BYTES) ;
	end

      // do test if read cycles are needed
      if (NUMBER_OF_READ_BYTES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-606- TASK_GENERI2C->TASK_READ") ;
	   Line_num   =  " t-607" ;
	   MODE       =  "READ MODE" ;
	   TASK_READ(NUMBER_OF_READ_BYTES) ;
	end
      if (debug_4 == 1) $display ($time," t-611- TASK_GENERIC2->END") ;
      Operation3 =  1'bx ;
      @(negedge SCLK) CS =  1 ;
      task_monitor("TASK_GENERIC2",0);
   end

endtask // TASK_GENERIC2
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $4 TASK_CMD(CMD)
// CMD input, adjusts task calls to fit SPI or QPI modes, note no DPI mode for command cycles
// Passed 8 bit command,
// command is read by chip on rising edge MSB is first read in to_lSB is_last
// added CS going_low control_locally, if set externally, missed timing
// Level 4 routine
task TASK_CMD ;
   input   [7:0] CMD ;
   begin :initial_begin
      task_monitor("TASK_CMD",1);
      Line_num   =  " t-632" ;
      Operation4 =  " t-633 TASK_CMD" ;
      if (debug_1 == 1) $display ($time," t-634- TASK_CMD") ;
      TASK_TRACK_CMD_USAGE(CMD);
      // assumption is if QPI_MODE = 0, must be SPI_MODE 
      Line_num   =  " t-637" ;
      MODE       =  "SPI MODE" ;
      TASK_SPI_CMD(CMD) ;  
      // gdg 110301 start - added test to force CS high for CMD opcodes which require this
      // The following CMD OPCODES require CS to go high after the_last CMD bit is read in:
      // NOP (8'h00),
      // WSR (8'h01);
      // WRDIS (8'h04),
      // WREN (8'h06),   
      // RSTEN (8'h66),
      // RSTMEM (8'h99),
      // SCEWAF (8'h58),
      // SCE (8'h57),     
      if ( (CMD===(8'h00))
	   | (CMD===(8'h01))
	   | (CMD===(8'h04))
	   | (CMD===(8'h06)) 
	   | (CMD===(8'h66))
	   //    | (CMD===(8'h57))
	   //    | (CMD===(8'h59))
	   | (CMD===(8'h99)) )
	 
	begin:CS_TERMINATE
	   Line_num   =  " t-660" ;
	   Status     =  {ASCII_CMD(CMD)," t-661- forced CS high" } ;
	   @(negedge SCLK) # tDH CS   =  1 ;
	end     // end CS_TERMINATE
      // gdg 110301 end - added test to force CS high for CMD opcodes which require this
      if (debug_5 == 1) $display ($time," t-665- TASK_CMD -> end") ;
      Status =  1'bx ;
      Operation4 =  1'bx ;
      task_monitor("TASK_CMD",0);
   end             // end initial_begin
endtask // TASK_CMD
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $4 TASK_CMD2(CMD)
// CMD input, adjusts task calls to fit SPI or QPI modes, note no DPI mode for command cycles
// Passed 8 bit command,
// command is read by chip on rising edge MSB is first read in to_lSB is_last
// CS IS NOT FORCED LOW LOCALLY
// Level 4 routine
task TASK_CMD2 ;
   input   [7:0] CMD ;
   begin :initial_begin
      task_monitor("TASK_CMD2",1);
      Line_num   =  " t-685" ;
      Operation4 =  " t-686 TASK_CMD2" ;
      if (debug_1 == 1) $display ($time," t-687- TASK_CMD2") ;
      // assumption is if QPI_MODE = 0, must be SPI_MODE  
      Line_num   =  " t-689" ;
      MODE       =  "SPI MODE" ;
      TASK_SPI_CMD(CMD) ;
      
      if (debug_5 == 1) $display ($time," t-693- TASK_CMD2 -> end") ;
      Status =  1'bx ;
      Operation4 =  1'bx ;
      task_monitor("TASK_CMD2",0);
   end             // end initial_begin
endtask // TASK_CMD2
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $5 TASK_SPI_CMD(CMD)
// - SI Single chip input active, takes 8 clock cycles to_load command
// Passed 8 bit command, command is read in on SI
// command is read by chip on rising edge MSB is first read in to_lSB is_last
// added CS control_locally, if set externally, missed timing
// Level 5 routine
task TASK_SPI_CMD ;
   input   [7:0] CMD ;

   begin :initial_begin
      task_monitor("TASK_SPI_CMD",1);
      Line_num   =  " t-714" ;
      Operation5 =  " t-715 TASK_SPI_CMD" ;
      //gdg_fix_log
      // if (debug_0 == 1) $display ("---->", $time," t-717- TASK_SPI_CMD, CMD = %h ", CMD) ; //gdg
      if (debug_1 == 1) $display ($time," t-718- TASK_SPI_CMD ") ;

      // setup BIDI's
      SI_en      =  1 ;       // drive SI_en high to allow TB
      // to drive data onto SI pin
      // (write to chip)
      // SI_out register to write data to chip
      // SI_out = data
      SO_en      =  0 ;       // drive SO_en_low to allow chip
      // to drive data onto SO pin
      // (read from chip)
      // SO_out = SO
      WINDOW     =  1'bx ;
      //  for (i     =  0 ; i < 8 ; i=  i+ 1) begin :cmd_loop
      for (index_spi_cmd     =  0 ; index_spi_cmd < 8 ; index_spi_cmd =  index_spi_cmd + 1) begin :cmd_loop  
	 Line_num   =  " t-733" ;
	 if (debug_6 == 1) $display ($time," t-734- TASK_SPI_CMD_loop") ;
	 @(negedge SCLK) //_last operation completed
	   // CS = 0 ; // CS driven_low to start CMD cycle
	   # tDH ; // hold expires, set ca to X
	 CS =  0 ;       // CS driven_low to start CMD cycle
	 #((tCK/2)-(tDSU+tDH)) ; // calculates when valid data window opens
	 Line_num   =  " t-740" ;
	 Status     =  {ASCII_CMD(CMD)," rising edge"} ;
	 WINDOW     =  1'b1 ;
	 SI_out     =  CMD [7-index_spi_cmd] ;       // MSB ->_lSB order


	 
	 

	 @(posedge SCLK)
	   # tDH ; // hold expires, CMD invalid
         // end capture_data_rising_edge
	 WINDOW     =  1'bx ;
	 //    SI_out     =  1'bx ;
      end             // end cmd_loop
      // need to check if there are situations where the CMD of 35 would be ignored

      if (debug_6 == 1) $display ($time," t-753- TASK_SPI_CMD -> end") ;
      Status =  1'bx ;
      Operation5 =  1'bx ;
      task_monitor("TASK_SPI_CMD",0);
   end     // end initial_begin
endtask // TASK_SPI_CMD
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $4 TASK_ADDRESS(NUMBER_OF_ADDRESS_BITS, ADDRESS)
// if NUMBER_OF_ADDRESS_BITS = 0, set ADDRESS = 0 as well, and drop through to dummy cycles task block
//
// adjusts task calls to fit SPI modes
//
// address is read by chip on rising edge MSB is first read in to_lSB is_last
// Level 4 routine
task TASK_ADDRESS ;
   input   NUMBER_OF_ADDRESS_BITS ;
   input [47:0] ADDRESS ;

   integer 	NUMBER_OF_ADDRESS_BITS ;

   begin :initial_begin
      task_monitor("TASK_ADDRESS",1);
      Line_num   =  " t-778" ;
      Operation4 =  " t-779 TASK_ADDRESS" ;
      if (debug_1 == 1) $display ($time," t-780- TASK_ADDRESS") ;
      if (NUMBER_OF_ADDRESS_BITS != 0)
	begin: address_mode
	   Line_num   =  " t-783" ;

	   Line_num   =  " t-785" ;
	   MODE       =  " t-786- SPI ADDRESS" ;
	   TASK_SPI_ADDRESS(NUMBER_OF_ADDRESS_BITS,ADDRESS);
	end             // : address_mode
      else
	begin: No_address
	   Line_num   =  " t-791" ;
	   Status     =  "No Address Operation" ;
	end             // : No_address
      if (debug_5 == 1) $display ($time," t-794- TASK_ADDRESS -> end") ;
      Operation4 =  1'bx ;
      Status     =  1'bx ;
      task_monitor("TASK_ADDRESS",0);
   end     // end initial_begin
endtask // TASK_ADDRESS
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $5 TASK_SPI_ADDRESS(NUMBER_OF_ADDRESS_BITS, ADDRESS)
// - SI Single chip input active, takes 8 clock cycles to_load 1 byte,
// number of bytes for address given by NUMBER_OF_ADDRESS_BITS
// Passed 24 bit ADDRESS, command is read in on SI
// ADDRESS is read by chip on rising edge MSB ->_lSB order
// Level 5 routine
task TASK_SPI_ADDRESS ;
   input   NUMBER_OF_ADDRESS_BITS ;
   input [47:0] ADDRESS ;
   integer 	NUMBER_OF_ADDRESS_BITS ;

   begin :initial_begin
      task_monitor("TASK_SPI_ADDRESS",1);
      Line_num   =  " t-820" ;
      Operation5 =  " t-821 TASK_SPI_ADDRESS" ;
      if (debug_1 == 1) $display ($time," t-822- TASK_SPI_ADDRESS -> begin") ;
      WINDOW     =  1'bx ;
      // setup BIDI's
      SI_en      =  1 ;       // drive SI_en high to allow TB
      SO_en      =  0 ;       // drive SO_en_low to allow chip  
      for (index_spi_address     =  0 ; index_spi_address < (NUMBER_OF_ADDRESS_BITS ) ; index_spi_address =  index_spi_address + 1) begin :address_loop // max is 24
	 // $display ($time," t-835 TASK_SPI_ADDRESS-> i = %h ", i, "NUMBER_OF_ADDRESS_BITS = %h ", NUMBER_OF_ADDRESS_BITS, "ADDRESS = %h ", ADDRESS ) ;
	 if (debug_6 == 1) $display ($time," t-836- TASK_SPI_ADDRESS_loop") ;
	 @(negedge SCLK) //_last operation completed
	   # tDH ;         // hold expires, set ca to X
	 #((tCK/2)-(tDSU+tDH)) ; // calculates when valid data window opens
	 Status =  " t-840- write ADDRESS - rising edge" ;


	 //     if (index_spi_address < 48) begin      //     
	 //    SI_out =  ADDRESS[(NUMBER_OF_ADDRESS_BITS - 1) - index_spi_address] ;   // MSB ->_lSB order
	 //	end
	 //    else if(index_spi_address == 48) begin
	 //	@(negedge SCLK)
	 //       SI_out = 0;	
	 //  end

	 SI_out =  ADDRESS[(NUMBER_OF_ADDRESS_BITS - 1) - index_spi_address] ;   // MSB ->_lSB order

	 
	 WINDOW =  1'b1 ;
	 @(posedge SCLK)
	   # tDH ; // hold expires, CMD invalid
         // end capture_data_rising_edge
	 //gdg WP change   SI_out =  1'bx ;
	 WINDOW =  1'bx ;
      end             // end address_loop
      Status =  1'bx ;
      if (debug_6 == 1) $display ($time," t-850- TASK_SPI_ADDRESS -> end") ;
      Operation5 =  1'bx ;
      task_monitor("TASK_ADDRESS",0);
   end     // end initial_begin
endtask // TASK_SPI_ADDRESS
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******



// **START****START****START****START****START****START****START****START****START****START****START**
// $5 TASK_DUMMY( NUMBER_OF_DUMMY_CYCLES)
// - sets up enables to allow the inputs to be in the proper driven mode based on mode we are in
//
// Level 5 routine
task TASK_DUMMY ;
   input   NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer

   integer NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer

   begin :initial_begin
      task_monitor("TASK_DUMMY",1);
      Line_num   =  " t-871" ;
      Operation5 =  " t-872 TASK_DUMMY" ;
      if (debug_1 == 1) $display ($time," t-873- TASK_DUMMY") ; 
      Line_num	= " t-874";
      SI_en		=  1 ;		// TB can drive SI
      SI_out		= 1'b1;		// TB drives SI high
      SO_en		=  0 ;		// TB leaves SO high-Z
      SO_out		= 1'b1;
      for (index_dummy_cycle     =  0 ; index_dummy_cycle < (NUMBER_OF_DUMMY_CYCLES + 1 ) ; index_dummy_cycle =  index_dummy_cycle + 1) begin :dummy_loop       //
	 // $display ($time," t-880 TASK_DUMMY-> i = %h ", i, "NUMBER_OF_DUMMY_CYCLES = %h ", NUMBER_OF_DUMMY_CYCLES ) ;
	 Line_num   =  " t-881" ;
	 if (debug_6 == 1) $display ($time," t-882- TASK_DUMMY_loop") ;
	 @(negedge SCLK) ;
	 Line_num   =  " t-884" ;
	 Status     =  "DUMMY cycle" ;
      end     // end dummy_loop
      Status =  1'bx ;
      if (debug_6 == 1) $display ($time," t-888- TASK_DUMMY -> end") ;
      Operation5 =  1'bx ;
      task_monitor("TASK_DUMMY",0);
   end             // end initial_begin
endtask // TASK_DUMMY
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $5 TASK_INIT_WRITE_PI
// no arguments
//_loads WRITE_DATA_ARRAY with 1st 512 Bytes of PI starts off 03H and follows with 511 decimal bytes
// Level 5 routine
task TASK_INIT_WRITE_PI ;
   begin
      task_monitor("TASK_INIT_WRITE_PI",1);
      Operation5 =  " t-904 TASK_INIT_WRITE_PI" ;
      Line_num   =  " t-905" ;
      $display ($time," t-906- TASK_INIT_WRITE_PI") ;
      $readmemh("./write_data/PI_BLOCK_512.list", WRITE_DATA_ARRAY) ;
      #5;
      Operation5 =  1'bx ;
      task_monitor("TASK_INIT_WRITE_PI",0);
   end
endtask // TASK_INIT_WRITE_PI
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $5 TASK_INIT_WRITE_ONES
// no arguments
//_loads WRITE_DATA_ARRAY with all ONES  (Note this is to load WRITE_DATA_ARRAY for checking purposes
// Can't actually write a 1
// Level 5 routine
task TASK_INIT_WRITE_ONES ;
   begin
      task_monitor("TASK_INIT_WRITE_ONES",1);
      Operation5 =  " t-925 TASK_INIT_WRITE_ONES" ;
      Line_num   =  " t-926" ;
      $display ($time," t-927- TASK_INIT_WRITE_ONES (FF's)") ;
      $readmemh("./write_data/ONES_BLOCK_512.list", WRITE_DATA_ARRAY) ;
      #5;
      Operation5 =  1'bx ;
      task_monitor("TASK_INIT_WRITE_ONES",0);
   end
endtask //TASK_INIT_WRITE_ONES
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******

// **START****START****START****START****START****START****START****START****START****START****START**
// $5 TASK_INIT_WRITE_CHECKERBOARD
// no arguments
//_loads WRITE_DATA_ARRAY checkerboard data
// Level 5 routine
task TASK_INIT_WRITE_CHECKERBOARD ;
   begin
      task_monitor("TASK_INIT_WRITE_CHECKERBOARD",1);
      Operation5 =  " t-944 TASK_INIT_WRITE_CHECKERBOARD" ;
      Line_num   =  " t-945" ;
      $display ($time," t-946- TASK_INIT_WRITE_CHECKERBOARD") ;
      $readmemh("./write_data/CHECKERBOARD_BLOCK_512.list", WRITE_DATA_ARRAY) ;
      #5;
      Operation5 =  1'bx ;
      task_monitor("TASK_INIT_WRITE_CHECKERBOARD",0);
   end
endtask // TASK_INIT_WRITE_CHECKERBOARD
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $5 TASK_INIT_WRITE_ZEROS
// no arguments
//_loads WRITE_DATA_ARRAY with all zeros (memory is erased to 1s
// Level 5 routine
task TASK_INIT_WRITE_ZEROS ;
   begin
      task_monitor("TASK_INIT_WRITE_ZEROS",1);
      Operation5 =  " t-964 TASK_INIT_WRITE_ZEROS" ;
      Line_num   =  " t-965" ;
      $display ($time," t-966- TASK_INIT_WRITE_ZEROS") ;
      $readmemh("./write_data/ZEROS_BLOCK_512.list", WRITE_DATA_ARRAY) ;
      #5;
      Operation5 =  1'bx ;
      task_monitor("TASK_INIT_WRITE_ZEROS",0);
   end
endtask // TASK_INIT_WRITE_ZEROS
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******



// **START****START****START****START****START****START****START****START****START****START****START**
// $4 TASK_WRITE(NUMBER_OF_WRITE_BYTES)
//
// adjusts task calls to fit SPI, DPI or QPI modes
//
// data is written by chip on rising edge MSB is first read in to_lSB is_last
// Level 4 routine
task TASK_WRITE ;
   input   NUMBER_OF_WRITE_BYTES ;
   integer NUMBER_OF_WRITE_BYTES ;
   begin :initial_begin
      task_monitor("TASK_WRITE",1);
      Line_num   =  " t-989" ;
      Operation4 =  " t-990 TASK_WRITE" ;
      if (debug_1 == 1) $display ($time," t-991- TASK_WRITE ") ;
      if (NUMBER_OF_WRITE_BYTES != 0)
	begin
	   Line_num   =  " t-994" ;
	   if (QPI_MODE==0)
	     begin
		Line_num   =  " t-997" ;
		MODE       =  "SPI WRITE" ;
		TASK_SPI_WRITE(NUMBER_OF_WRITE_BYTES);
	     end      
	   else
	     begin
		Line_num   =  " t-1003" ;
		MODE       =  " t-1004- ERROR IN TASK_WRITE" ;
		Check_reason   =  " t-1005- TASK_WRITE UNEXPECTED FLAGS VALUES " ;
		Check_flag     =  1'bx ;
		Error_number   =  Error_number + 1 ;
		if (debug_0 == 1) $display ($time," t-1008- TASK_WRITE error UNEXPECTED FLAGS VALUES") ;
		SUCCESS = 0 ;
		#5 ;
		Check_flag     =  1'b0 ;
		Check_reason   =  1'bx ;
	     end
	end
      else
	begin
	   Line_num   =  " t-1017" ;
	   Status     =  " t-1018 No Address Operation" ;
	end
      Status =  1'bx ;
      if (debug_5 == 1) $display ($time," t-1021- TASK_WRITE -> end") ;
      Operation4 =  1'bx ;
      task_monitor("TASK_WRITE",0);
   end             // end initial_begin
endtask // TASK_WRITE
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
// $5 TASK_SPI_WRITE(NUMBER_OF_WRITE_BYTES)
// - SI Single chip input active, takes 8 clock cycles to_load 1 byte,
// Write data coming from WRITE_DATA_ARRAY maximum number of bytes is 512
// if WRITE_DATA_ARRAY is not initialized, you won't see any bus activity
// number of bytes for a WRITE given by NUMBER_OF_WRITE_BYTES
// Maximum value for NUMBER_OF_WRITE_BYTES is 511
// Bytes are read in from 0 -> 511 (LSByte to MSByte)
// WRITE to chip on rising edge, bits are written in MSB ->_lSB order
// WRITE to SI
// Level 5 routine
task TASK_SPI_WRITE ;
   input   NUMBER_OF_WRITE_BYTES ;

   integer NUMBER_OF_WRITE_BYTES ;

   reg [ 1 : 24 ] my_string ;  // create string repository
   // WRITE_DATA_ARRAY, WRITE_BYTE externally declared
   begin :initial_begin
      task_monitor("TASK_SPI_WRITE",1);
      Line_num   =  " t-1051" ;
      Operation5 =  " t-1052 TASK_SPI_WRITE" ;
      if (debug_1 == 1) $display ($time," t-1053- TASK_SPI_WRITE ") ;
      WINDOW     =  1'bx ;
      // setup BIDI's
      SI_en      =  1 ;       // drive SI_en high to allow TB
      // to drive data onto SI pin
      // (write to chip)
      // SI_out register to write data to chip
      // SI_out = WRITE
      SO_en      =  0 ;       // drive SO_en_low to allow chip
      // to drive data onto SO pin
      // (WRITE from chip)
      // SO_out = SO
      if (debug_6 == 1) $display ($time," t-1065- TASK_SPI_WRITE_loop") ;
      for (index_spi_write_outer     =  0 ; index_spi_write_outer < (NUMBER_OF_WRITE_BYTES) ; index_spi_write_outer  =  index_spi_write_outer + 1) begin :WRITE_outer_loop     // max is 512
	 if (debug_6 == 1) $display ($time," t-1067- TASK_SPI_WRITE_loop") ;
	 Line_num   =  " t-1068" ;
	 Operation6 =  "outer" ;
	 WRITE_BYTE =  WRITE_DATA_ARRAY[index_spi_write_outer] ;     // from 0 to NUMBER_OF_WRITE_BYTES
	 if (debug_2 == 1) $display ($time," t-1071- TASK_SPI_WRITE-> WRITE_BYTE = %h ", WRITE_BYTE ) ;
         $sformat(my_string, "%h", WRITE_BYTE) ; // do conversion
	 for (index_spi_write_inner     =  0 ; index_spi_write_inner < 8 ; index_spi_write_inner =  index_spi_write_inner + 1) begin: write_inner_loop     // inner_loop, write bits, 8 passes
	    Line_num   =  " t-1074" ;
	    Operation7 =  "inner" ;
	    @(negedge SCLK) //_last operation completed
	      # tDH ;         // hold expires, set ca to X
	    Line_num   =  " t-1078" ;
	    Operation8 =  "data" ;
	    #((tCK/2)-(tDSU+tDH)) ; // calculates when valid data window opens
	    Line_num   =  " t-1081" ;
	    Status     =  {my_string, " data"} ;
	    SI_out     =  WRITE_BYTE[ 7 - index_spi_write_inner] ;      // MSB ->_lSB order
	    WINDOW     =  1'b1 ;

	    @(posedge SCLK)
	      # tDH ; // hold expires, CMD invalid
            // end capture_data_rising_edge
	    SI_out     =  1'bx ;
	    WINDOW     =  1'bx ;
	    Operation7 =  1'bx ;
	 end             // end write_inner_loop
	 Operation6 =  1'bx ;
      end     // end WRITE_outer_loop
      Status =  1'bx ;
      if (debug_6 == 1) $display ($time," t-1096- TASK_WRITE -> end") ;
      Operation5 =  1'bx ;
      task_monitor("TASK_SPI_WRITE",0);
   end             // end initial_begin
endtask // TASK_SPI_WRITE
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******



// **START****START****START****START****START****START****START****START****START****START****START**
// $4 TASK_READ(NUMBER_OF_READ_BYTES)
//
// adjusts task calls to fit SPI, DPI or QPI read tasks modes
// does not consume ant clock edges
// data is written by chip on rising edge MSB is first read in to_lSB is_last
// Level 4 routine
task TASK_READ ;
   input   NUMBER_OF_READ_BYTES ;

   integer NUMBER_OF_READ_BYTES ;

   begin :initial_begin
      task_monitor("TASK_READ",1);
      Operation4 =  " t-1119- TASK_READ" ;
      Line_num   =  " t-1120" ;
      if (debug_1 == 1) $display ($time," t-1121- TASK_READ ") ;
      if (NUMBER_OF_READ_BYTES != 0)
	begin: find_read_mode
	   Line_num   =  " t-1124" ;   
	   if (debug_5 == 1) $display ($time," t-1125- TASK_READ->TASK_SPI_READ") ;
	   Line_num   =  " t-1126" ;
	   MODE       =  "SPI READ" ;
	   TASK_SPI_READ(NUMBER_OF_READ_BYTES);  
	end             // find_read_mode
      else
	begin: no_read
	   Line_num   =  " t-1132" ;
	   Status     =  "No Address Operation" ;
	end             // no_read
      Status =  1'bx ;
      if (debug_5 == 1) $display ($time," t-1136- TASK_READ->END") ;
      Operation4 =  1'bx ;
      task_monitor("TASK_READ",0);
   end     // end initial_begin
endtask //  TASK_READ
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******



// **START****START****START****START****START****START****START****START****START****START****START**
// $5 TASK_SPI_READ(NUMBER_OF_READ_BYTES);
// - SI Single chip input active, takes 8 clock cycles to_load 1 byte,
// READ data written to READ_DATA_ARRAY_M maximum number of bytes which can be written is 512
// number of bytes for a READ given by NUMBER_OF_READ_BYTES
// Maximum value for NUMBER_OF_READ_BYTES is 512
// Bytes are read in from 0 -> 511 (LSByte to MSByte)
// READ from chip on falling edge in MSB ->_lSB bit order
// READ from SO
// Level 5 routine
task TASK_SPI_READ ;
   input   NUMBER_OF_READ_BYTES ;

   integer NUMBER_OF_READ_BYTES ;

   // READ_DATA_ARRAY_M, READ_BYTE_M externally declared
   //reg     [7:0] READ_SI_M ;
   reg [7:0] READ_SI_B ;
   begin :initial_begin
      task_monitor("TASK_SPI_READ",1);
      Line_num   =  " t-1165" ;
      if (debug_1 == 1) $display ($time," t-1166- TASK_SPI_READ ") ;
      if (debug_6 == 1) $display ($time," t-1167- TASK_SPI_READ-> NUMBER_OF_READ_BYTES = %d ", NUMBER_OF_READ_BYTES ) ;
      WINDOW     =  1'bx ;
      Line_num   =  " t-1169" ;
      Operation5 =  " t-1170 TASK_SPI_READ" ;
      // setup BIDI's
      SI_en      =  1 ;       // drive SI_en high to allow TB
      // to drive data onto SI pin
      // (WRITE to chip)
      // SI_out register to READ data to chip
      // SI_out = READ
      SO_en      =  0 ;       // drive SO_en_low to allow chip
      // to drive data onto SO pin
      // (READ from chip)
      // SO_out = SO

      @(posedge SCLK) ;       // if this is not included, the order will be
      // rising edge write followed by immediate falling
      // edge read. This moves the read out to the next cycle

      if (debug_6 == 1) $display ($time," t-1186- TASK_SPI_READ_loop") ;
      if (debug_6 == 1) $display ($time," t-1187- NUMBER_OF_READ_BYTES-> = %d ", NUMBER_OF_READ_BYTES ) ;

      for (index_spi_read_outer     =  0 ; index_spi_read_outer < NUMBER_OF_READ_BYTES ; index_spi_read_outer =  index_spi_read_outer + 1) begin :READ_outer_loop  // max is 512
	 // $display ($time," t-1190 TASK_SPI_READ-> j = %h ", j, "NUMBER_OF_READ_BYTES = %h ", NUMBER_OF_READ_BYTES ) ;

	 Line_num   =  " t-1192" ;
	 if (debug_6 == 1) $display ($time," t-1193- TASK_SPI_READ_loop") ;
	 if (debug_6 == 1) $display ($time," t-1194- index_spi_read_outer = %d ", index_spi_read_outer ) ;
	 Operation6 =  " t-1195 outer_READ_loop" ;
	 for (index_spi_read_inner     =  0 ; index_spi_read_inner < 8 ; index_spi_read_inner =  index_spi_read_inner + 1) begin :READ_inner_loop              // inner_loop, READ bits, 8 passes
	    //  $display ($time," t-1197 TASK_SPI_READ-> i = %h ", i ) ;
	    Line_num   =  " t-1198" ;
	    Operation7 =  " t-1199 inner_READ_loop" ;
	    if (debug_6 == 1) $display ($time," t-1200- index_spi_read_inner-> = %d ", index_spi_read_inner ) ;
	    @(negedge SCLK) //_last operation completed
	      if (debug_6 == 1) $display ($time," t-1202- - time ",$time," TASK_SPI_READ-> READ BIT") ;
	    Line_num   =  " t-1203" ;
	    Status     =  "READ bit" ;
	    READ_BYTE_G[7 - index_spi_read_inner] =  SO_B ;    //MSB ->_lSB order
	    WINDOW =  1'b1 ;
	    # tDH ;
	    WINDOW =  1'bx ;
	    Status =  1'bx ;
	    Operation7 =  1'bx ;
	 end     // end READ_inner_loop  
	 READ_DATA_ARRAY_G[index_spi_read_outer]   =  READ_BYTE_G ;
	 Line_num   =  " t-1213" ;
	 if (debug_2 == 1) $display ($time," t-1214- TASK_SPI_READ-> READ_BYTE_G = %h ", READ_BYTE_G ) ;

	 Operation6 =  1'bx ;
      end             // end READ_outer_loop
      Status =  1'bx ;
      if (debug_6 == 1) $display ($time," t-1219- TASK_SPI_READ -> END") ;
      Line_num   =  " t-1220" ;
      Operation5 =  1'bx ;
      task_monitor("TASK_SPI_READ",0);
   end     // end initial_begin
endtask // TASK_SPI_READ
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_POWERUP
// TAKES NO ARGUMENTS
//
// Power up of chip
// Level 0 routine
task TASK_POWERUP ;
   begin
      task_monitor("TASK_POWERUP",1);
      // SUCCESS = 1 ; // NO CHECK HERE
      // add tPUW delay to wake up Macronix chip
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1241- TASK_POWERUP ") ;
      Operation      =  " t-1242 tPUW start"      ;
      CS =  1 ;  // CS must start out inactive (high)
      #(tVSL * (1_000)) ;   // time after which CS can go active (low)          
      Operation1     =  "tPUW 10 mS"      ;
      // tPUW = 10, tVSL = 300, if speedup_us and speedup_ms are both set to 1_000,
      // then we would have 10 - 300 which would be an illegal delay
      if ((tPUW * ((1_000)*(1_000)) ) > (tVSL * (1_000)) )
	#((tPUW * ((1_000)*(1_000)) ) - (tVSL * (1_000))) ;
      else
	begin
	   #(tPUW * ((1_000)*(1_000)) ) ;
	end
      Operation      =  1'bx ;
      Operation1     =  1'bx ;
      // ************************
      task_monitor("TASK_POWERUP",0);
   end
endtask // TASK_POWERUP
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_READ_READ(ADDRESS,NUMBER_OF_READ_BYTES)
//
//
// Level 0 routine
// works only in SPI mode
//
// Level 0 routine
//
task TASK_READ_READ ;
   input   [15:0] ADDRESS ;        // Starting address for read
   input 	  NUMBER_OF_READ_BYTES ;  // number of bytes to read in each CS low interval
   integer 	  ADDRESS ;
   integer 	  NUMBER_OF_READ_BYTES ;
   begin
      task_monitor("TASK_READ_READ",1);
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1281- TASK_READ_READ ") ;
      //  SUCCESS = 1;        // SET SUCCESS, ANY FAILURE WILL LATER WILL SET TO 0
      Operation      =  (" t-1283 TASK_READ_READ " )      ;
      if (debug_2 == 1) $display ($time," t-1284 TASK_READ_READ --> TASK_GENERIC - 03 - _READ 8'h03") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      if (QPI_MODE == 0)
	begin
	   Line_num   =  " t-1288" ;
	   MODE       =  "SPI MODE" ;
	   TASK_GENERIC (8'h03, 16, ADDRESS, 8,0,NUMBER_OF_READ_BYTES) ;   // READ
	end
      else begin
	 if ((debug_0 == 1)&(expected_fail == 0)) $display ($time," t-1293 TASK_READ_READ -> FAILURE, Only Runs in SPI MODE") ;
	 SUCCESS = 0 ;
      end
   end
endtask
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_NOP
// TAKES NO ARGUMENTS
//
// reset the chip
// Power up of chip
// Level 0 routine
task TASK_NOP ;
   begin
      task_monitor("TASK_NOP",1);
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1314- TASK_NOP ") ;
      if (debug_1 == 1) $display ($time," t-1315 TASK_NOP ") ;
      Operation      =  (" t-1316 TASK_NOP " )      ;
      if (debug_3 == 1) $display ($time," t-1317 TASK_NOP --> TASK_GENERIC - 00 - NOP") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h00, 0, 0, 0,0, 0) ;    // NOP    - nop 
      Operation1     =  "TASK_NOP --> tRCR Reset Recover Time start"      ;
      #(tRCR * ((1_000) )) ;
      // ************************
      Operation      =  1'bx ;
      Operation1     =  1'bx ;
      // ************************
      task_monitor("TASK_NOP",0);
   end
endtask // TASK_NOP
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_RESET
// TAKES NO ARGUMENTS
//
// reset the chip
// Power up of chip
// Level 0 routine
task TASK_RESET ;
   begin
      task_monitor("TASK_RESET",1);
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1345- TASK_RESET ") ;
      if (debug_1 == 1) $display ($time," t-1346 TASK_RESET ") ;
      Operation      =  (" t-1347 TASK_RESET " )      ;
      if (debug_3 == 1) $display ($time," t-1348 TASK_RESET --> TASK_GENERIC - 66 - RSTEN") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h66, 0, 0, 0,0, 0) ;    // RSTEN    - reset enable
      if (debug_3 == 1) $display ($time," t-1351 TASK_RESET --> TASK_GENERIC - 99 - RST") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h99, 0, 0, 0,0, 0) ;    // RST    - reset
      Operation1     =  "TASK_RESET --> tRCR Reset Recover Time start"      ;
      #(tRCR * ((1_000) )) ;
      // ************************
      Operation      =  1'bx ;
      Operation1     =  1'bx ;
      // ************************
      task_monitor("TASK_RESET",0);
   end
endtask // TASK_RESET
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_RESET_ERASE
// TAKES NO ARGUMENTS
//
// reset the chip
// Power up of chip
// Level 0 routine
task TASK_RESET_ERASE ;
   begin
      task_monitor("TASK_RESET_ERASE",1);
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1377- TASK_RESET_ERASE ") ;
      if (debug_1 == 1) $display ($time," t-1378 TASK_RESET_ERASE ") ;
      Operation      =  (" t-1379 TASK_RESET_ERASE " )      ;
      if (debug_3 == 1) $display ($time," t-1380 TASK_RESET_ERASE --> TASK_GENERIC - 66 - RSTEN") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h66, 0, 0, 0,0, 0) ;    // RSTEN    - reset enable
      if (debug_3 == 1) $display ($time," t-1383 TASK_RESET_ERASE --> TASK_GENERIC - 99 - RST") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h99, 0, 0, 0,0, 0) ;    // RST    - reset
      Operation1     =  "TASK_RESET_ERASE --> tRCR Reset Recover Time start"      ;
      #(tRCE * ((1_000_000) )) ;
      // ************************
      Operation      =  1'bx ;
      Operation1     =  1'bx ;
      // ************************
      task_monitor("TASK_RESET_ERASE",0);
   end
endtask // TASK_RESET_ERASE
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_RSTEN_NOP
// TAKES NO ARGUMENTS
//
// Enable Reset, disable with NOP, fail to Reset the chip
// Power up of chip
// Level 0 routine
task TASK_RSTEN_NOP ;
   begin
      task_monitor("TASK_RSTEN_NOP",1);
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1411- TASK_RSTEN_NOP ") ;
      if (debug_1 == 1) $display ($time," t-1412 TASK_RSTEN_NOP ") ;
      Operation      =  (" t-1413 TASK_RSTEN_NOP " )      ;
      if (debug_3 == 1) $display ($time," t-1414 TASK_RSTEN_NOP --> TASK_GENERIC - 66 - RSTEN") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h66, 0, 0, 0,0, 0) ;    // RSTEN    - reset enable
      if (debug_3 == 1) $display ($time," t-1417 TASK_RSTEN_NOP --> TASK_GENERIC - 00 - NOP") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h00, 0, 0, 0,0, 0) ;    // RSTEN    - reset enable
      if (debug_3 == 1) $display ($time," t-1420 TASK_RSTEN_NOP --> TASK_GENERIC - 99 - RST") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h99, 0, 0, 0,0, 0) ;    // RST    - reset
      Operation1     =  "TASK_RSTEN_NOP --> tRCR Reset Recover Time start"      ;
      #(tRCR * ((1_000) )) ;
      // ************************
      Operation      =  1'bx ;
      Operation1     =  1'bx ;
      // ************************
      task_monitor("TASK_RSTEN_NOP",0);
   end
endtask // TASK_RSTEN_NOP
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_RSTEN_NOP
// TAKES NO ARGUMENTS
//
// Enable Reset, disable with NOP, fail to Reset the chip
// Power up of chip
// Level 0 routine
task TASK_RST ;
   begin
      task_monitor("TASK_RSTEN_NOP",1);
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1411- TASK_RSTEN_NOP ") ;
      if (debug_1 == 1) $display ($time," t-1412 TASK_RSTEN_NOP ") ;
      Operation      =  (" t-1413 TASK_RSTEN_NOP " )      ;  
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h99, 0, 0, 0,0, 0) ;    // RST    - reset
      Operation1     =  "TASK_RSTEN_NOP --> tRCR Reset Recover Time start"      ;
      #(tRCR * ((1_000) )) ;
      // ************************
      Operation      =  1'bx ;
      Operation1     =  1'bx ;
      // ************************
      task_monitor("TASK_RSTEN_NOP",0);
   end
endtask // TASK_RSTEN_NOP
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******






// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_RSTEN_NOP
// TAKES NO ARGUMENTS
//
// Enable Reset, disable with NOP, fail to Reset the chip
// Power up of chip
// Level 0 routine
task TASK_RSTEN ;
   begin
      task_monitor("TASK_RSTEN_NOP",1);
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1411- TASK_RSTEN_NOP ") ;
      if (debug_1 == 1) $display ($time," t-1412 TASK_RSTEN_NOP ") ;
      Operation      =  (" t-1413 TASK_RSTEN_NOP " )      ;
      if (debug_3 == 1) $display ($time," t-1414 TASK_RSTEN_NOP --> TASK_GENERIC - 66 - RSTEN") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h66, 0, 0, 0,0, 0) ;    // RSTEN    - reset enable
      if (debug_3 == 1) $display ($time," t-1417 TASK_RSTEN_NOP --> TASK_GENERIC - 00 - NOP") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES) 
      Operation1     =  "TASK_RSTEN_NOP --> tRCR Reset Recover Time start"      ;
      #(tRCR * ((1_000) )) ;
      // ************************
      Operation      =  1'bx ;
      Operation1     =  1'bx ;
      // ************************
      task_monitor("TASK_RSTEN_NOP",0);
   end
endtask // TASK_RSTEN_NOP
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_WRDI (write disable)
// TAKES NO ARGUMENTS
//
// Check out WRDI function resets WEL bit to 0
// can be run in either SPI or QPI mode
// Uses flow on page 25
// Level 0 routine
task TASK_WRDI ;
   begin
      task_monitor("TASK_WRDI",1);
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1447- TASK_WRDI ") ;
      // if (debug_3 == 1) $display ($time," t-1448 TASK_WRDI-> TASK_GENERIC - 05 - RDSR 8'h05, 0, 0, 0,0, 1 ") ;
      Operation      =  (" t-1449 TASK_WRDI " )     ;
      // if (debug_3 == 1) $display ($time," t-1451 TASK_WRDI -->TASK_GENERIC - 05 - RDSR 8'h05, 0, 0, 0,0, 1 ") ;
      //    Operation     =  " t-1452 TASK_WRDI -->SPI reads RDSR, 8'h05, 0, 0, 0,0, 1"       ;
      TASK_GENERIC (8'h04, 0, 0, 0,0, 0) ;    // WRDI     - write disable
      TASK_TRACK_STATUS_REG_USAGE;
      //  *****************************************************************
      // WRDI loop has time out of 50,000 and depends on success = 1 to run
      time_out   =  0 ;
      // gdg add GMSI chip to completion check
      while ((READ_BYTE_G[1]!== 1'b0) & (time_out < (20_000 / time_out_factor))  )
	begin
	   time_out   =  time_out+1 ;
	   //    loop issuing WRDI and then doing a RDSR to see if WEL bit was set to 0  ;
	   //    Operation2    =  " t-1463 TASK_SET_WRDI ->(SPI reads) WRDI, 8'h04, 0, 0, 0,0, 1"      ;
	   TASK_GENERIC (8'h04, 0, 0, 0,0, 0) ;    // WRDI     - write disable
	   //    if (debug_3 == 1) $display ($time," t-1465 TASK_SET_WRDI -> TASK_GENERIC - 05 - RDSR 8'h05, 0, 0, 0,0, 1 ") ;
	   //    Operation2    =  " t-1466 TASK_SET_WRDI ->(SPI reads) RDSR, 8'h05, 0, 0, 0,0, 1"      ;  
	   TASK_TRACK_STATUS_REG_USAGE;
	   #10 ;
	end
      if (debug_0 == 1)  $display ($time," t-1470- TASK_WRDI time_out = %d   ", time_out ) ;
      if (time_out == (20_000 / time_out_factor))  begin
	 Check_reason   =  " t-1472 TASK_WRDI WEL status timed out " ;
	 Check_flag     =  1'bx ;
	 Error_number   =  Error_number + 1 ;
	 if (debug_0 == 1) $display ($time," t-1475- TASK_SET_WRDI WEL status timed out") ;
	 if (debug_0 == 1) $display ($time," t-1476- TASK_SET_WRDI ERROR in STATUS REGISTER, WEL expected 0's;  GMSI_READ_BYTE_G[1] = %h     ", READ_BYTE_G[1]) ;
	 SUCCESS = 0;
	 #5 ;
	 Check_flag     =  1'b0 ;
	 Check_reason   =  1'bx ;
      end  
      if ((debug_0 == 1)& (SUCCESS == 1)) begin
	 $display ($time," t-1483 TASK_WRDI -> SUCCESS!") ;
	 if (debug_0 == 1) $display ("---->", $time," t-1484- TASK_WRDI, successfully cleared status reg bit 1 WEL ") ;  //gdg
      end
      //
      // ************************
      Operation        =  1'bx ;
      //  Operation2    =  1'bx ;
      // ************************
      task_monitor("TASK_WRDI",0);
   end
endtask // TASK_WRDI
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
task TASK_PP ;  //
   input   [31:0] ADDRESS ;  // Starting address for PP
   input 	  NUMBER_OF_WRITE_BYTES ;
   integer 	  ADDRESS ;
   integer 	  NUMBER_OF_WRITE_BYTES ;
   begin
      task_monitor("TASK_PP",1);
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1506- TASK_PP ") ;
      Operation      =  " t-1507 TASK_PP" ;
      if (debug_1 == 1) $display ($time," t-1508 TASK_PP ") ; 
      TASK_WREN ; 
      if (debug_3 == 1) $display ($time," t-1516 TASK_PP ->TASK_GENERIC - 02 - PP 8'h02, 24, 0, 0,0, 0 ") ;  
      TASK_GENERIC (8'h02, 32, ADDRESS, 0,NUMBER_OF_WRITE_BYTES, 0) ; // PP
      TASK_CHECK_WIP_COMPLETE ;
      //  TASK_GENERIC (0, 0, ADDRESS, 200,NUMBER_OF_WRITE_BYTES, 0) ; // PP
      
      //TASK_WRITE_CHECKER(ADDRESS, NUMBER_OF_WRITE_BYTES) ;
      
      Operation  =  1'bx ;
      if ((debug_0 == 1)&(SUCCESS == 1)) $display ($time," t-1529 TASK_PP -> SUCCESS!") ;
      if ((debug_0 == 1)&(SUCCESS == 0)&(expected_fail == 0)) $display ($time," t-1530 TASK_PP -> FAILED!") ;
      if (debug_0 == 1) $display ($time," t-1531- TASK_SECURITY_REGISTER_VALUE_CHECK call,  TASK_PP exit") ;
      task_monitor("TASK_PP",0);
   end
endtask // TASK_PP
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
// $1 TASK_WRITE_CHECKER(ADDRESS, NUMBER_OF_READ_BYTES)
// Does a FASTREAD (0B - supports both SPI and QPI modes w/different dummy cycles)
// Check then compares the read outputs of both chips stored in READ_DATA_ARRAY_M and READ_DATA_ARRAY_G
// against each other and against the original write date stored in WRITE_DATA_ARRAY
//
// Level 1 routine
task TASK_WRITE_CHECKER ;       //
   input   [15:0] ADDRESS ;          //
   input 	  NUMBER_OF_READ_BYTES ;
   // 1st address is 24'h000000
   integer 	  ADDRESS ;
   integer 	  NUMBER_OF_READ_BYTES ;
   begin   //1 task
      task_monitor("TASK_WRITE_CHECKER",1);
      Operation1     =  " t-5444 TASK_WRITE_CHECKER -> READ, 8'h0B - ADDRESS - NUMBER_OF_READ_BYTES"      ;
      if (debug_1 == 1) $display ($time," t-5445 TASK_WRITE_CHECKER ") ;
      //
      // do a fast read (512 bytes) instead of read as fastread works in both SPI and QPI modes
      // note dummy cycles changes from SPI to QPI
      // if miscompare between 2 chips you will get an error
      // however the compare checking built into the read is only checking that chip 1 = chip 2
      //

      if (QPI_MODE == 0)
	begin   //2
	   if (debug_3 == 1) $display ($time," t-5455 TASK_WRITE_CHECKER ->TASK_GENERIC - 0B - FASTREAD 8'h0B, 24, ADDRESS, 4,0, NUMBER_OF_READ_BYTES ") ;
	   //    Operation2    =  " t-5456 TASK_WRITE_CHECKER ->SPI reads READ, 8'h0B, 24, ADDRESS, 8 or 4,0, NUMBER_OF_READ_BYTES"      ;
	   // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
	   TASK_GENERIC (8'h0B, 24, ADDRESS, 8,0, NUMBER_OF_READ_BYTES) ;  // READ     - read Array
	end     //2  
      //
      // final check that read = write data, if so print SUCCESS message
      // WRITE_DATA_ARRAY contains what was used for data to write into chip
      // READ_DATA_ARRAY_G contains what was read out of the GMSI's chip

      for ( i = 0 ; i < ( NUMBER_OF_READ_BYTES ) ; i = i + 1 )
	begin   // Start Compare loop
	   // $display ($time," t-5475 TASK_WRITE_CHECKER-> i = %h ", i, "NUMBER_OF_READ_BYTES = %h ", NUMBER_OF_READ_BYTES ) ;
	   if (debug_2 == 1) $display ($time," t-5476- TASK_WRITE_CHECKER-> WRITE_DATA_ARRAY[i] = %h ", WRITE_DATA_ARRAY[i] ) ;
	   if (debug_2 == 1) $display ($time," t-5478- TASK_WRITE_CHECKER-> READ_DATA_ARRAY_G[i] = %h ", READ_DATA_ARRAY_G[i] ) ;
	   // checks start
	   if (WRITE_DATA_ARRAY[i] === READ_DATA_ARRAY_G[i])  begin   // check for success
	      // report success
	      if (debug_0 == 1) $display ($time," t-5482 TASK_WRITE_CHECKER -> SUCCESS read = write") ;
	      if (debug_0 == 1) $display ($time," t-5483- TASK_WRITE_CHECKER-> read  i = %d ", i , "WRITE_DATA_ARRAY[i] = %h ", WRITE_DATA_ARRAY[i] ) ;
	      if (debug_0 == 1) $display ($time," t-5485- TASK_WRITE_CHECKER-> read  i = %d ", i , "READ_DATA_ARRAY_G[i] = %h ", READ_DATA_ARRAY_G[i] ) ;
	      Operation1     =  " t-5486 TASK_WRITE_CHECKER -> SUCCESS read = write" ;
	      // if not a pass, check for fail reason
	   end
	   if (WRITE_DATA_ARRAY[i] !== READ_DATA_ARRAY_G[i]) begin              // error output results
	      if (debug_0 == 1) $display ($time," t-5490 TASK_WRITE_CHECKER -> ERROR read != write") ;
	      if (debug_0 == 1) $display ($time," t-5491- TASK_WRITE_CHECKER-> read  i = %d ", i , "WRITE_DATA_ARRAY[i] = %h ", WRITE_DATA_ARRAY[i] ) ;
	      if (debug_0 == 1) $display ($time," t-5493- TASK_WRITE_CHECKER-> read  i = %d ", i , "READ_DATA_ARRAY_G[i] = %h ", READ_DATA_ARRAY_G[i] ) ;
	      Operation1     =  " t-5494 TASK_WRITE_CHECKER -> ERROR B " ;
	      Check_reason       =  " t-5495 TASK_WRITE_CHECKER -> ERROR" ;
	      Check_flag =  1'bx ;
	      Error_number   =  Error_number + 1 ;
	      SUCCESS = 0 ;   // any error is stickey
	      #5 ;
	      Check_flag     =  1'b0 ;
	      Check_reason   =  1'bx ;
	   end
	end

      Operation1 =  1'bx ;
      //  Operation2 =  1'bx ;
      if ((debug_0 == 1)&(SUCCESS == 1)) $display ($time," t-5507 TASK_WRITE_CHECKER -> SUCCESS!") ;
      if ((debug_0 == 1)&(SUCCESS == 0)&(expected_fail == 0)) $display ($time," t-5508 TASK_WRITE_CHECKER -> FAILED!") ;
      task_monitor("TASK_WRITE_CHECKER",0);
   end     // 1 task
endtask // TASK_WRITE_CHECKER
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******






// **START****START****START****START****START****START****START****START****START****START****START**
// $5 TASK_SPI_WRITE_BYTE(BYTE)
// - SI Single chip input active, takes 8 clock cycles to_load 1 byte,
// Write data coming from WRITE_BYTE
// WRITE to chip on rising edge, bits are written in MSB ->_lSB order
// WRITE to SI
// Level 5 routine
task TASK_SPI_WRITE_BYTE ;
   input   BYTE ;

   reg [7:0] 	BYTE ;

   reg [ 1 : 24 ] my_string ;  // create string repository
   // WRITE_BYTE externally declared
   begin :initial_begin
      task_monitor("TASK_SPI_WRITE_BYTE",1);
      Line_num   =  " t-1554" ;
      Operation5 =  " t-1555 TASK_SPI_WRITE_BYTE" ;
      WRITE_BYTE =  BYTE ;
      if (debug_1 == 1) $display ($time," t-1557- TASK_SPI_WRITE_BYTE ") ;
      WINDOW     =  1'bx ;
      // setup BIDI's
      SI_en      =  1 ;       // drive SI_en high to allow TB
      SO_en      =  0 ;       // drive SO_en_low to allow chip
      if (debug_6 == 1) $display ($time," t-1562- TASK_SPI_WRITE_BYTE_loop") ;
      for (i     =  0 ; i < 8 ; i=  i+ 1) begin: write_inner_loop     // inner_loop, write bits, 8 passes
	 Line_num   =  " t-1564" ;
	 Operation7 =  "inner" ;
	 @(negedge SCLK) //_last operation completed
	   # tDH ;         // hold expires, set ca to X
	 Line_num   =  " t-1568" ;
	 Operation8 =  "data" ;
	 #((tCK/2)-(tDSU+tDH)) ; // calculates when valid data window opens
	 Line_num   =  " t-1571" ;
	 Status     =  {my_string, " data"} ;
	 SI_out     =  WRITE_BYTE[ 7 - i] ;      // MSB ->_lSB order
	 WINDOW     =  1'b1 ;

	 @(posedge SCLK)
	   # tDH ; // hold expires, CMD invalid
         // end capture_data_rising_edge
	 //gdg WP    SI_out     =  1'bx ;
	 WINDOW     =  1'bx ;
	 Operation7 =  1'bx ;
      end             // end write_inner_loop
      Operation6 =  1'bx ;
      Status     =  1'bx ;
      if (debug_6 == 1) $display ($time," t-1585- TASK_WRITE_BYTE -> end") ;
      Operation5 =  1'bx ;
      Operation7 =  1'bx ;
      Operation8 =  1'bx ;
      WRITE_BYTE =  8'bx ;
      task_monitor("TASK_SPI_WRITE_BYTE",0);
   end     // end initial_begin
endtask // TASK_SPI_WRITE_BYTE(BYTE)
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******



// **START****START****START****START****START****START****START****START****START****START****START**
// $4 TASK_WRITE_BYTE(BYTE)
//
// adjusts task calls to fit SPI, QPI modes
//
// data is written by chip on rising edge MSB is first read in to_lSB is_last
// CS is not returned high within task
// Level 4 routine
task TASK_WRITE_BYTE ;
   input   BYTE ;
   reg [7:0] 	BYTE ;

   begin :initial_begin
      task_monitor("TASK_WRITE_BYTE",1);
      Line_num   =  " t-1611" ;
      Operation4 =  " t-1612 TASK_WRITE_BYTE" ;
      if (debug_1 == 1) $display ($time," t-1613- TASK_WRITE_BYTE ") ;
      Line_num   =  " t-1614" ;
      if (QPI_MODE==0)
	begin
	   Line_num   =  " t-1617" ;
	   MODE       =  "SPI WRITE" ;
	   TASK_SPI_WRITE_BYTE(BYTE);
	end
      
      else
	begin
	   Line_num   =  " t-1624" ;
	   MODE       =  " t-1625- ERROR IN TASK_WRITE_BYTE" ;
	   Check_reason   =  " t-1626- TASK_WRITE_BYTE UNEXPECTED FLAGS VALUES " ;
	   Check_flag     =  1'bx ;
	   Error_number   =  Error_number + 1 ;
	   SUCCESS = 0;
	   if (debug_0 == 1) $display ($time," t-1630- TASK_WRITE_BYTE UNEXPECTED FLAGS VALUES error") ;
	   #5 ;
	   Check_flag     =  1'b0 ;
	end
      Status =  1'bx ;
      if (debug_5 == 1) $display ($time," t-1635- TASK_WRITE_BYTE -> end") ;
      Operation4 =  1'bx ;
      task_monitor("TASK_WRITE_BYTE",0);
   end     // end initial_begin
endtask // TASK_WRITE_BYTE(BYTE)
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******





// **START****START****START****START****START****START****START****START****START****START****START**
// $1 TASK_GMSI_DATA_CHECKER(START_ADDRESS, NUMBER_OF_COMPARE_BYTES)
// Does not do a read but instead compares existing  READ_DATA_ARRAY_G  and WRITE_DATA_ARRAY
// Check then compares the read output of GMSI chip stored in READ_DATA_ARRAY_G
// against ethe original write date stored in WRITE_DATA_ARRAY
//
// Level 1 routine
task TASK_GMSI_DATA_CHECKER ;      //
   input   START_ADDRESS ;
   input   NUMBER_OF_COMPARE_BYTES ;
   integer START_ADDRESS ;
   integer NUMBER_OF_COMPARE_BYTES ;
   begin   //1 task
      task_monitor("TASK_GMSI_DATA_CHECKER",1);
      Operation1     =  " t-9663 TASK_GMSI_DATA_CHECKER -> compare READ_DATA_ARRAY_G  and WRITE_DATA_ARRAY for NUMBER_OF_COMPARE_BYTES"       ;
      if (debug_1 == 1) $display ($time," t-9664 TASK_GMSI_DATA_CHECKER ") ;
      //
      //
      // final check that read = write data, if so print SUCCESS message
      // WRITE_DATA_ARRAY contains what was used for data to write into chip
      // READ_DATA_ARRAY_G contains what was read out of the GMSI's chip


      for ( i = ( 0 + START_ADDRESS ) ; i < ( NUMBER_OF_COMPARE_BYTES + START_ADDRESS ) ; i = i + 1 )
	begin   // Start Compare loop
	   //  $display ($time," t-9674 TASK_GMSI_DATA_CHECKER-> i = %h ", i, "NUMBER_OF_READ_BYTES = %h ", NUMBER_OF_READ_BYTES ) ;
	   if (debug_2 == 1) $display ($time," t-9675- TASK_GMSI_DATA_CHECKER-> WRITE_DATA_ARRAY[i] = %h ", WRITE_DATA_ARRAY[i] ) ;
	   if (debug_2 == 1) $display ($time," t-9676- TASK_GMSI_DATA_CHECKER-> READ_DATA_ARRAY_G[i] = %h ", READ_DATA_ARRAY_G[i] ) ;
	   // checks start
	   if (WRITE_DATA_ARRAY[i] === READ_DATA_ARRAY_G[i])   begin   // check for success
	      // report success
	      if (debug_0 == 1)$display ($time," t-9680 TASK_GMSI_DATA_CHECKER -> SUCCESS read = write") ;
	      if (debug_0 == 1) $display ($time," t-9681- TASK_GMSI_DATA_CHECKER-> read  i = %d ", i , "WRITE_DATA_ARRAY[i] = %h ", WRITE_DATA_ARRAY[i] ) ;
	      if (debug_0 == 1) $display ($time," t-9682- TASK_GMSI_DATA_CHECKER-> read  i = %d ", i , "READ_DATA_ARRAY_G[i] = %h ", READ_DATA_ARRAY_G[i] ) ;

	      Operation1     =  " t-9684 TASK_GMSI_DATA_CHECKER -> SUCCESS read = write" ; // if not a pass, check for fail reason
	   end
	   if (WRITE_DATA_ARRAY[i] !== READ_DATA_ARRAY_G[i]) begin              // check if macronix operation passed
	      if (debug_0 == 1)$display ($time," t-9687 TASK_GMSI_DATA_CHECKER -> FAIL read != write") ;
	      if (debug_0 == 1) $display ($time," t-9688- TASK_GMSI_DATA_CHECKER-> read  i = %d ", i , "WRITE_DATA_ARRAY[i] = %h ", WRITE_DATA_ARRAY[i] ) ;
	      if (debug_0 == 1) $display ($time," t-9689- TASK_GMSI_DATA_CHECKER-> read  i = %d ", i , "READ_DATA_ARRAY_G[i] = %h ", READ_DATA_ARRAY_G[i] ) ;
	      Operation1     =  " t-9690 TASK_GMSI_DATA_CHECKER -> ERROR  " ;
	      Check_reason       =  " t-9691 TASK_GMSI_DATA_CHECKER -> ERROR  " ;
	      Check_flag =  1'bx ;
	      Error_number   =  Error_number + 1 ;
	      SUCCESS = 0 ;   // any error is stickey
	      #5 ;
	      Check_flag     =  1'b0 ;
	      Check_reason   =  1'bx ;
	   end
	end

      Operation1 =  1'bx ;
      //  Operation2 =  1'bx ;
      if ((debug_0 == 1)&(SUCCESS == 1)) $display ($time," t-9703 TASK_GMSI_DATA_CHECKER -> SUCCESS!") ;
      if ((debug_0 == 1)&(SUCCESS == 0)&(expected_fail == 0)) $display ($time," t-9704 TASK_GMSI_DATA_CHECKER -> FAILED!") ;
      task_monitor("TASK_GMSI_DATA_CHECKER",0);
   end     // 1 task
endtask // TASK_GMSI_DATA_CHECKER
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******





// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_READ_FASTREAD(ADDRESS,NUMBER_OF_READ_BYTES)
//
//
// Level 0 routine
// works in SPI or QPI modes
//
// Level 0 routine
//
task TASK_READ_FASTREAD ;
   input   [15:0] ADDRESS ;        // Starting address for read
   input 	  NUMBER_OF_READ_BYTES ;  // number of bytes to read in each CS low interval
   integer 	  ADDRESS ;
   integer 	  NUMBER_OF_READ_BYTES ;
   begin
      task_monitor("TASK_FASTREAD",1);      
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1660- TASK_READ_FASTREAD ") ;
      //  SUCCESS = 1;        // SET SUCCESS, ANY FAILURE WILL LATER WILL SET TO 0
      Operation      =  (" t-1662 TASK_READ_FASTREAD " )      ;
      if (debug_2 == 1) $display ($time," t-1663 TASK_READ_FASTREAD --> TASK_GENERIC - 0B - _FASTREAD 8'h0B") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      if (QPI_MODE == 0)
	begin       
	   Line_num   =  " t-1667" ;
	   MODE       =  "SPI MODE" ;
	   
	   TASK_GENERIC (8'h0B, 16, ADDRESS, 8,0,NUMBER_OF_READ_BYTES) ;   // FASTREAD
	end
      TASK_GMSI_DATA_CHECKER(0,NUMBER_OF_READ_BYTES);
      if ((debug_0 == 1)&(SUCCESS == 0)&(expected_fail == 0)) $display ($time," t-1673 TASK_READ_FASTREAD -> FAILED!") ;
      else if ((debug_0 == 1)&(SUCCESS == 1)) $display ($time," t-1674 TASK_READ_FASTREAD -> SUCCESS!") ;
      // ************************
      Operation      =  1'bx ;
      //  Operation2    =  1'bx ;
      // ************************
      task_monitor("TASK_FASTREAD",0);
   end
endtask // TASK_READ_FASTREAD
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******

// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_READ_FASTREAD_GMSI(ADDRESS,NUMBER_OF_READ_BYTES)
//
//
// Level 0 routine
// works in SPI or QPI modes
//
// Level 0 routine
//
task TASK_READ_FASTREAD_GMSI ;
   input   [15:0] ADDRESS ;        // Starting address for read
   input 	  NUMBER_OF_READ_BYTES ;  // number of bytes to read in each CS low interval
   integer 	  ADDRESS ;
   integer 	  NUMBER_OF_READ_BYTES ;
   begin
      task_monitor("TASK_FASTREAD_GMSI",1);
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1700- TASK_READ_FASTREAD_GMSI ") ;
      //  SUCCESS = 1;        // SET SUCCESS, ANY FAILURE WILL LATER WILL SET TO 0
      Operation      =  (" t-1702 TASK_READ_FASTREAD_GMSI " )      ;
      if (debug_2 == 1) $display ($time," t-1703 TASK_READ_FASTREAD_GMSI --> TASK_GENERIC - 0B - _FASTREAD 8'h0B") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      if (QPI_MODE == 0)
	begin
	   Line_num   =  " t-1707" ;
	   MODE       =  "SPI MODE" ;
	   TASK_GENERIC (8'h0B, 16, ADDRESS, 8,0,NUMBER_OF_READ_BYTES) ;   // FASTREAD
	end
      else
	begin
	   Line_num   =  " t-1713" ;
	   MODE       =  "QPI MODE" ;
	   TASK_GENERIC (8'h0B, 24, ADDRESS, 4,0,NUMBER_OF_READ_BYTES) ;   // FASTREAD
	end


      TASK_GMSI_DATA_CHECKER(0, NUMBER_OF_READ_BYTES);
      if ((debug_0 == 1)&(SUCCESS == 0)&(expected_fail == 0)) $display ($time," t-1720 TASK_READ_FASTREAD_GMSI -> FAILED!") ;
      else if ((debug_0 == 1)&(SUCCESS == 1)) $display ($time," t-1721 TASK_READ_FASTREAD_GMSI -> SUCCESS!") ;
      // ************************
      Operation      =  1'bx ;
      //  Operation2    =  1'bx ;
      // ************************
      task_monitor("TASK_FASTREAD_GMSI",0);
   end
endtask // TASK_READ_FASTREAD_GMSI
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******

// **START****START****START****START****START****START****START****START****START****START****START**
// $2 TASK_WREN
// generic WREN program
// SPI or QPI modes
// Generic WREN command, can be called by level 0 tasks
// Note - does not set SUCCESS = 1 upon call
// Level 2 routine

task TASK_WREN ;        //
   begin
      task_monitor("TASK_WREN",1);
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1742- TASK_WREN ") ;
      Operation2     =  " t-1743 TASK_WREN" ;
      //
      //$$ - WREN Block
      //
      // initial status register read to load WREN bit
      //
      if (debug_3 == 1) $display ($time," t-1750 TASK_WREN -> TASK_GENERIC - 05 - RDSR 8'h05, 0, 0, 0,0, 1 ") ;
      //  Operation3    =  " t-1751 TASK_WREN -> RDSR, 8'h05, 0, 0, 0,0, 1"       ;
      TASK_GENERIC (8'h05, 0, 0, 0,0, 1) ;    // RDSR     - read Status
      TASK_TRACK_STATUS_REG_USAGE;
      // loop to check if WREN is or switched to a 1, will loop until write is enabled
      if (debug_3 == 1) $display ($time," t-1755 TASK_WREN ->enter while loop (READ_BYTE_M[1]!== 1'b1) - WREN 8'h06, RDSR 8'h05 ") ;
      //  *****************************************************************
      // WREN loop has time out of 50,000 and depends on success = 1 to run
      time_out   =  0 ;
      // gdg add GMSI chip to completion check
      while ( (READ_BYTE_G[1]!== 1'b1) & (time_out < (20_000 / time_out_factor))  )
	begin
	   time_out   =  time_out+1 ;
	   //    if (debug_3 == 1) $display ($time," t-1763 TASK_WREN -> TASK_GENERIC - 06 - WREN 8'h06, 0, 0, 0,0, 0 ") ;
	   //    Operation2    =  " t-1764 TASK_WREN ->(SPI reads) WREN, 8'h06, 0, 0, 0,0, 1"      ;
	   TASK_GENERIC (8'h06, 0, 0, 0,0, 0) ;    // WREN     - write enable
	   //    if (debug_3 == 1) $display ($time," t-1766 TASK_WREN -> TASK_GENERIC - 05 - RDSR 8'h05, 0, 0, 0,0, 1 ") ;
	   //    Operation2    =  " t-1767 TASK_WREN ->(SPI reads) RDSR, 8'h05, 0, 0, 0,0, 1"      ;
	   TASK_GENERIC (8'h05, 0, 0, 0,0, 1) ;    // RDSR     - read Status
	   TASK_TRACK_STATUS_REG_USAGE;
	   #10 ;
	end
      if (debug_0 == 1)  $display ($time," t-1772- TASK_WREN time_out = %d   ", time_out ) ;
      if (time_out == (20_000 / time_out_factor))
	begin
	   Check_reason   =  " t-1775 TASK_WREN WREN status timed out " ;
	   Check_flag     =  1'bx ;
	   Error_number   =  Error_number + 1 ;
	   if (debug_0 == 1) $display ($time," t-1778- TASK_WREN WREN status timed out") ;
	   if (debug_0 == 1) $display ($time," t-1779- TASK_WREN ERROR in STATUS REGISTER[1], WEL expected 1's; GMSI_READ_BYTE_G[1] = %h", READ_BYTE_G[1]) ;
	   if (debug_0 == 1) $display ($time," t-1780- TASK_WREN STATUS REGISTER is ,GMSI_READ_BYTE_G = %b     ", READ_BYTE_G) ;
	   if (debug_0 == 1) $display ($time," t-1781- TASK_REGISTER_VALUE_CHECK call, TASK_WREN ERROR in STATUS REGISTER[1]") ;
  	   TASK_REGISTER_VALUE_CHECK ;
	   SUCCESS = 0;
	   #5 ;
	   Check_flag     =  1'b0 ;
	   Check_reason   =  1'bx ;
	end
      // end WREN LOOP
      //  *****************************************************************
      // Macronix chip was able to set WREN but check GMSI for like behavior
      // delete   not needed now as GMSI chip was added to completion check
      //delete  if ((READ_BYTE_G[1]!== 1'b1))
      //delete  begin
      //delete    Check_reason   =  " t-1794 TASK_WREN -> GMSI WREN check FAILED, Macronix ok!" ;
      //delete    Check_flag     =  1'bx ;
      //delete    Error_number   =  Error_number + 1 ;
      //delete    if ((debug_0 == 1)&(expected_fail == 0)) $display ($time," t-1797- TASK_WREN -> GMSI WREN check FAILED, Macronix ok! Macronix = %h     ", READ_BYTE_M[1], " GMSI = %h    ", READ_BYTE_G[1]) ;
      //delete    SUCCESS = 0;
      //delete    #5 ;
      //delete    Check_flag     =  1'b0 ;
      //delete    Check_reason   =  1'bx ;
      //delete  end
      //delete  else
      //delete  begin
      //delete    if (debug_0 == 1) $display ($time," t-1805- TASK_WREN -> PASSED;  Macronix = %h    ", READ_BYTE_M[1], " GMSI = %h    ", READ_BYTE_G[1]) ;
      //delete    if (debug_0 == 1) $display ("---->", $time," t-1806- TASK_WREN, successfully set  Status reg bit 1 WEL ") ; //gdg
      //delete  end
      if ((debug_0 == 1)& (SUCCESS == 1)) begin
	 $display ($time," t-1809 TASK_WREN -> SUCCESS!") ;
	 if (debug_0 == 1) $display ("---->", $time," t-1810- TASK_WREN, successfully set  status reg bit 1 WEL ") ; //gdg
	 if (debug_0 == 1) $display ($time," t-1811- TASK_WREN  STATUS REGISTER[1], WEL expected 1's;  GMSI_READ_BYTE_G[1] = %b ", READ_BYTE_G[1]) ;
	 if (debug_0 == 1) $display ($time," t-1812- TASK_WREN STATUS REGISTER is , GMSI_READ_BYTE_G = %b     ", READ_BYTE_G) ;
	 if (debug_0 == 1) $display ($time," t-1813- TASK_REGISTER_VALUE_CHECK call, TASK_WREN, successfully set  status reg bit 1 WEL") ;
  	 TASK_REGISTER_VALUE_CHECK ;
      end
      Operation1         =  1'bx ;

      //
      //$$ end WREN block
      //  Operation2           =  1'bx ;
      //  	if (READ_BYTE_M !==  READ_BYTE_G)
      //  	begin
      //    if (debug_0 == 1) $display ($time," t-1823- TASK_WREN STATUS REGISTER is ,Macronix READ_BYTE_M= %b     ", READ_BYTE_M, " GMSI_READ_BYTE_G = %b     ", READ_BYTE_G) ;
      //    if (debug_0 == 1) $display ($time," t-1824- TASK_REGISTER_VALUE_CHECK call,  TASK_WREN STATUS REGISTER ") ;
      //  	TASK_REGISTER_VALUE_CHECK ;
      //  	end
      task_monitor("TASK_WREN",0);
   end
endtask // TASK_WREN
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******

// **START****START****START****START****START****START****START****START****START****START****START**
// $1 TASK_CHECK_WIP_COMPLETE
// generic WIP program
// SPI or QPI modes
// Generic WIP command, can be called by level 0 tasks
// Note - does not set SUCCESS = 1 upon call
// Level 2 routine


task TASK_CHECK_WIP_COMPLETE ;  //
   begin
      task_monitor("TASK_CHECK_WIP_COMPLETE",1);
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1844- TASK_CHECK_WIP_COMPLETE ") ;
      Operation2         =  " t-1845 TASK_CHECK_WIP_COMPLETE" ;
      //

      //$$ - WIP Block
      //
      // initial status register read to load WIP bit
      //
      if (debug_3 == 1) $display ($time," t-1852 TASK_CHECK_WIP_COMPLETE -> TASK_GENERIC - 05 - RDSR 8'h05, 0, 0, 0,0, 1 ") ;
      //  Operation3    =  " t-1853 TASK_CHECK_WIP_COMPLETE -> RDSR, 8'h05, 0, 0, 0,0, 1"       ;
      TASK_GENERIC (8'h05, 0, 0, 0,0, 1) ;    // RDSR     - read Status
      TASK_TRACK_STATUS_REG_USAGE;
      // loop to check if WIP is or switched to a 1, will loop until write is enabled
      if (debug_3 == 1) $display ($time," t-1857 TASK_CHECK_WIP_COMPLETE ->enter while loop (READ_BYTE_M[0]== 1) - WIP 8'h06, RDSR 8'h05 ") ;
      //  *****************************************************************
      // CHECK_WIP_COMPLETE loop has time out of 50,000 and depends on success = 1 to run
      time_out   =  0 ;
      while ((READ_BYTE_G[0]=== 1'b1) & (time_out < (20_000 / time_out_factor))  )
	begin
	   time_out   =  time_out+1 ;

	   //
	   //
	   //    if (debug_3 == 1) $display ($time," t-1867 TASK_CHECK_WIP_COMPLETE -> TASK_GENERIC - 05 - RDSR 8'h05, 0, 0, 0,0, 1 ") ;
	   //    Operation2    =  " t-1868 TASK_CHECK_WIP_COMPLETE ->(SPI reads) RDSR, 8'h05, 0, 0, 0,0, 1"      ;
	   TASK_GENERIC (8'h05, 0, 0, 0,0, 1) ;    // RDSR     - read Status
	   TASK_TRACK_STATUS_REG_USAGE;
	   #10 ;
	end
      if (debug_0 == 1)  $display ($time," t-1873- CHECK_WIP_COMPLETE time_out = %d   ", time_out ) ;
      if (time_out == (20_000 / time_out_factor))  begin
  	 // we have an time out error, print messages
	 Check_reason   =  " t-1876 TASK_CHECK_WIP_COMPLETE CHECK_WIP_COMPLETE status timed out " ;
	 if (debug_0 == 1) $display ($time," t-1877- TASK_REGISTER_VALUE_CHECK call, CHECK_WIP_COMPLETE time_out") ;
	 if (debug_0 == 1) $display ($time," t-1878- TASK_REGISTER_VALUE_CHECK call, in this case we don't want to wait on WEL bit") ;
  	 TASK_REGISTER_VALUE_CHECK ;
	 Check_flag     =  1'bx ;
	 Error_number   =  Error_number + 1 ;
	 if (debug_0 == 1) $display ($time," t-1882- TASK_CHECK_WIP_COMPLETE CHECK_WIP_COMPLETE status timed out") ;
	 if (debug_0 == 1) $display ($time," t-1883- TASK_CHECK_WIP_COMPLETE  STATUS REGISTER[0], WIP expected 0's;  Macronix READ_BYTE_M[0]= %b    ", READ_BYTE_M[0], " GMSI_READ_BYTE_G[0] = %b     ", READ_BYTE_G[0]) ;
	 if (debug_0 == 1) $display ($time," t-1884- TASK_CHECK_WIP_COMPLETE STATUS REGISTER is ,Macronix READ_BYTE_M= %b     ", READ_BYTE_M, " GMSI_READ_BYTE_G = %b     ", READ_BYTE_G) ;

	 SUCCESS = 0;
	 #5 ;
	 Check_flag     =  1'b0 ;
	 Check_reason   =  1'bx ;
      end
      // end CHECK_WIP_COMPLETE LOOP
      //  *****************************************************************
      // delete   not needed now as GMSI chip was added to completion check
      // delete     // Macronix chip was able to complete write in progress, but check GMSI for like behavior
      // delete if ((READ_BYTE_G[0]!= 0)) begin
      // delete   Check_reason   =  " t-1896 TASK_CHECK_WIP_COMPLETE -> GMSI WIP check FAILED, Macronix ok!" ;
      // delete   Check_flag     =  1'bx ;
      // delete   Error_number   =  Error_number + 1 ;
      // delete   if ((debug_0 == 1)&(expected_fail == 0)) $display ($time," t-1899- TASK_CHECK_WIP_COMPLETE -> GMSI WIP check FAILED, Macronix ok! Macronix = %h    ", READ_BYTE_M[0], " GMSI = %h    ", READ_BYTE_G[0]) ;
      // delete   SUCCESS = 0 ;
      // delete   #5 ;
      // delete   Check_flag     =  1'b0 ;
      // delete   Check_reason   =  1'bx ;
      // delete end
      // delete else
      // delete begin
      // delete   if (debug_0 == 1) $display ($time," t-1907- TASK_CHECK_WIP_COMPLETE -> PASSED; Macronix = %h     ", READ_BYTE_M[0], " GMSI = %h    ", READ_BYTE_G[0]) ;
      // delete   if (debug_0 == 1) $display ("---->", $time," t-1908- TASK_CHECK_WIP_COMPLETE, successfully clear  Status reg bit 0 WIP ") ; //gdg
      // delete end       //
      // delete //$$ end WIP block
      if ((debug_0 == 1)& (SUCCESS == 1))
	begin
	   $display ($time," t-1913 TASK_CHECK_WIP_COMPLETE -> SUCCESS!") ;
	   if (debug_0 == 1) $display ($time," t-1914- TASK_STATUS_REGISTER_VALUE_CHECK call, TASK_CHECK_WIP_COMPLETE -> SUCCESS!") ;
  	   TASK_STATUS_REGISTER_VALUE_CHECK_HIGH ;
	   if (debug_0 == 1) $display ("---->", $time," t-1916- TASK_CHECK_WIP_COMPLETE, successfully cleared  status reg bit 0 WIP ") ; //gdg
	   if (debug_0 == 1) $display ($time," t-1917- TASK_CHECK_WIP_COMPLETE  STATUS REGISTER[0], WIP expected 0's;  Macronix READ_BYTE_M[0]= %b    ", READ_BYTE_M[0], " GMSI_READ_BYTE_G[0] = %b     ", READ_BYTE_G[0]) ;
	   if (debug_0 == 1) $display ($time," t-1918- TASK_CHECK_WIP_COMPLETE STATUS REGISTER is ,Macronix READ_BYTE_M= %b     ", READ_BYTE_M, " GMSI_READ_BYTE_G = %b     ", READ_BYTE_G) ;
	end
      Operation2           =  1'bx ;
      task_monitor("TASK_CHECK_WIP_COMPLETE",0);
   end
endtask // TASK_CHECK_WIP_COMPLETE
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $1 TASK_EXPECT_PASS ;
// mode independent
// switches TEST_RUN = 0 if SUCCESS = 0 for this setp in the test run (we expected a pass )
// prints to display if expect was not met)
//
// Level 1 routine


task TASK_EXPECT_PASS ;
   begin
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1938- TASK_EXPECT_PASS ") ;
      Operation1         =  " t-1939 TASK_TASK_EXPECT_PASS" ;
      if (SUCCESS == 0)
	begin
	   task_monitor("TASK_EXPECT_PASS",1);
	   TEST_RUN = 0;
	   $display ("__________________________________________________________________") ;
	   $display (" ########    ###    #### ##       ##     ## ########  ########  ");
	   $display (" ##         ## ##    ##  ##       ##     ## ##     ## ##        ");
	   $display (" ##        ##   ##   ##  ##       ##     ## ##     ## ##        ");
	   $display (" ######   ##     ##  ##  ##       ##     ## ########  ######    ");
	   $display (" ##       #########  ##  ##       ##     ## ##   ##   ##        ");
	   $display (" ##       ##     ##  ##  ##       ##     ## ##    ##  ##        ");
	   $display (" ##       ##     ## #### ########  #######  ##     ## ########  ");
	   $display ("__________________________________________________________________") ;
	   $display ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") ;
	   $display ("Test bench step FAILURE -- unexpected behavior, expected a PASS, got a FAIL  ") ;
	   $display (" @@fail   ") ;
	   $display ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") ;
	end
      else begin
	 $display ("__________________________________________________________________") ;
	 $display ("  ######  ##     ##  ######   ######  ########  ######   ######   ");
	 $display (" ##    ## ##     ## ##    ## ##    ## ##       ##    ## ##    ##  ");
	 $display (" ##       ##     ## ##       ##       ##       ##       ##        ");
	 $display ("  ######  ##     ## ##       ##       ######    ######   ######   ");
	 $display ("       ## ##     ## ##       ##       ##             ##       ##  ");
	 $display (" ##    ## ##     ## ##    ## ##    ## ##       ##    ## ##    ##  ");
	 $display ("  ######   #######   ######   ######  ########  ######   ######   ");
	 $display ("__________________________________________________________________") ;
	 $display ("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$") ;
	 $display ("Test bench step SUCCESS -- expected a PASS, got a PASS  ") ;
	 $display ("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$") ;
      end
      Operation1           =  1'bx ;
      if (debug_1 == 1 ) $display ("Reset SUCCESS to 1 for next section") ;
      SUCCESS = 1 ;
      task_monitor("TASK_EXPECT_PASS",0);
   end
endtask // TASK_EXPECT_PASS
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******

// **START****START****START****START****START****START****START****START****START****START****START**
// $1 TASK_EXPECT_FAIL
// mode independent
// switches TEST_RUN = 0 if SUCCESS = 1 for this setp in the test run (we expected a FAIL )
// prints to display if expect was not met)
//
// Level 1 routine
task TASK_EXPECT_FAIL ;
   begin
      task_monitor("TASK_EXPECT_FAIL",1);
      if (debug_1 == 1 ) $display ("ENTER", $time," t-1990- TASK_EXPECT_FAIL ") ;
      Operation1     =  " t-1991 TASK_TASK_EXPECT_FAIL" ;
      if (SUCCESS == 1)
	begin
	   task_monitor("TASK_EXPECT_FAIL",1);
	   TEST_RUN = 0;

	   $display ("________________________________________________________________") ;
	   $display (" ########    ###    #### ##       ##     ## ########  ########  ");
	   $display (" ##         ## ##    ##  ##       ##     ## ##     ## ##        ");
	   $display (" ##        ##   ##   ##  ##       ##     ## ##     ## ##        ");
	   $display (" ######   ##     ##  ##  ##       ##     ## ########  ######    ");
	   $display (" ##       #########  ##  ##       ##     ## ##   ##   ##        ");
	   $display (" ##       ##     ##  ##  ##       ##     ## ##    ##  ##        ");
	   $display (" ##       ##     ## #### ########  #######  ##     ## ########  ");
	   $display ("________________________________________________________________") ;
	   $display ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") ;
	   $display ("Test bench step FAILURE -- unexpected behavior, expected a FAIL, got a PASS  ") ;
	   $display (" @@fail   ") ;
	   $display ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") ;
	end
      else begin
	 $display ("__________________________________________________________________") ;
	 $display ("  ######  ##     ##  ######   ######  ########  ######   ######   ");
	 $display (" ##    ## ##     ## ##    ## ##    ## ##       ##    ## ##    ##  ");
	 $display (" ##       ##     ## ##       ##       ##       ##       ##        ");
	 $display ("  ######  ##     ## ##       ##       ######    ######   ######   ");
	 $display ("       ## ##     ## ##       ##       ##             ##       ##  ");
	 $display (" ##    ## ##     ## ##    ## ##    ## ##       ##    ## ##    ##  ");
	 $display ("  ######   #######   ######   ######  ########  ######   ######   ");
	 $display ("__________________________________________________________________") ;
	 $display ("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$") ;
	 $display ("Test bench step SUCCESS -- expected a FAIL, got a FAIL  ") ;
	 $display ("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$") ;
      end
      Operation1       =  1'bx ;
      if (debug_1 == 1 ) $display ("Reset SUCCESS to 1 for next section") ;
      SUCCESS = 1 ;
      if (debug_1 == 1 ) $display ("Reset expected_fail to 1 for next section") ;
      expected_fail = 0 ;
      task_monitor("TASK_EXPECT_FAIL",0);
   end
endtask // TASK_EXPECT_FAIL
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
// $5 TASK_INIT_WRITE_AND
// no arguments
//_loads WRITE_DATA_ARRAY with
// AND_BLOCK_512.list is the equivalent of a BITWISE AND of PI_BLOCK_512.list and CHECKERBOARD_BLOCK_512.list
// Can't actually write 0 to a 1 but can write a 1 to a 0
// used for overwrite check
// Level 5 routine
task TASK_INIT_WRITE_AND ;
   begin
      task_monitor("TASK_INIT_WRITE_AND",1);
      Operation5 =  " t-2049 TASK_INIT_WRITE_AND" ;
      Line_num   =  " t-2050" ;
      $display ($time," t-2051- TASK_INIT_WRITE_AND") ;
      $readmemh("./write_data/AND_BLOCK_512.list", WRITE_DATA_ARRAY) ;
      #5;
      Operation5 =  1'bx ;
      task_monitor("TASK_INIT_WRITE_AND",0);
   end
endtask // TASK_INIT_WRITE_AND
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******





// **START****START****START****START****START****START****START****START****START****START****START**
// $  TASK_CMD_USAGE_REPORT
//writes out listing of CMDs used in run
task TASK_CMD_USAGE_REPORT ;
   begin
      task_monitor("TASK_CMD_USAGE_REPORT",1);

      $display (" t-2131-                                                                                                                           ")     ;
      if (SPI_CMD_DATA[0]  == 1) begin $display (" t-2132- SPI CMD  NOP 00h             USED")  ; end else begin $display (" t-2132- SPI CMD NOP 00h              ----") ;  end
      if (SPI_CMD_DATA[1]  == 1) begin $display (" t-2133- SPI CMD  WRSR 01h            USED")  ; end else begin $display (" t-2133- SPI CMD  WRSR 01h            ----") ;  end
      if (SPI_CMD_DATA[2]  == 1) begin $display (" t-2134- SPI CMD  PP 02h              USED")  ; end else begin $display (" t-2134- SPI CMD  PP 02h              ----") ;  end
      if (SPI_CMD_DATA[3]  == 1) begin $display (" t-2135- SPI CMD  READ 03h            USED")  ; end else begin $display (" t-2135- SPI CMD  READ 03h            ----") ;  end
      if (SPI_CMD_DATA[4]  == 1) begin $display (" t-2136- SPI CMD  WRDI 04h            USED")  ; end else begin $display (" t-2136- SPI CMD  WRDI 04h            ----") ;  end
      if (SPI_CMD_DATA[5]  == 1) begin $display (" t-2137- SPI CMD  RDSR 05h            USED")  ; end else begin $display (" t-2137- SPI CMD  RDSR 05h            ----") ;  end
      if (SPI_CMD_DATA[6]  == 1) begin $display (" t-2138- SPI CMD  WREN 06h            USED")  ; end else begin $display (" t-2138- SPI CMD  WREN 06h            ----") ;  end     
      if (SPI_CMD_DATA[7]  == 1) begin $display (" t-2139- SPI CMD  RDLB  09h            USED")  ; end else begin $display (" t-2139- SPI CMD  RLB 09h             ----") ;  end
      if (SPI_CMD_DATA[8]  == 1) begin $display (" t-2140- SPI CMD  NEURONACT 10h       USED")  ; end else begin $display (" t-2140- SPI CMD  NEURONACT 20h       ----") ;  end
      if (SPI_CMD_DATA[9]  == 1) begin $display (" t-2141- SPI CMD  FASTREAD 0Bh        USED")  ; end else begin $display (" t-2141- SPI CMD  FASTREAD 0Bh        ----") ;  end
      if (SPI_CMD_DATA[10] == 1) begin $display (" t-2142- SPI CMD  INF 53h             USED")  ; end else begin $display (" t-2142- SPI CMD  INF 53h             ----") ;  end 
      if (SPI_CMD_DATA[11] == 1) begin $display (" t-2143- SPI CMD  NEUREAD 54h         USED")  ; end else begin $display (" t-2143- SPI CMD  NEUREAD 54h         ----") ;  end
      if (SPI_CMD_DATA[12] == 1) begin $display (" t-2144- SPI CMD  MACCYC 55h          USED")  ; end else begin $display (" t-2144- SPI CMD  MACCYC 55h          ----") ;  end
      if (SPI_CMD_DATA[13] == 1) begin $display (" t-2145- SPI CMD  BIASBUF 56h         USED")  ; end else begin $display (" t-2145- SPI CMD  BIASBUF 56h         ----") ;  end
      if (SPI_CMD_DATA[14] == 1) begin $display (" t-2146- SPI CMD  SCE 57h             USED")  ; end else begin $display (" t-2146- SPI CMD  SCE 57h             ----") ;  end
      if (SPI_CMD_DATA[15] == 1) begin $display (" t-2147- SPI CMD  SCEWAF 58h          USED")  ; end else begin $display (" t-2147- SPI CMD  SCEWAF 58h          ----") ;  end
      if (SPI_CMD_DATA[16] == 1) begin $display (" t-2148- SPI CMD  LBWR 59h            USED")  ; end else begin $display (" t-2148- SPI CMD  LBWR 59h            ----") ;  end
      if (SPI_CMD_DATA[17] == 1) begin $display (" t-2149- SPI CMD  RSTEN 66h           USED")  ; end else begin $display (" t-2149- SPI CMD  RSTEN 66h           ----") ;  end
      if (SPI_CMD_DATA[18] == 1) begin $display (" t-2150- SPI CMD  ACCRST 98h          USED")  ; end else begin $display (" t-2150- SPI CMD  ACCRST 98h          ----") ;  end
      if (SPI_CMD_DATA[19] == 1) begin $display (" t-2151- SPI CMD  RST 99h             USED")  ; end else begin $display (" t-2151- SPI CMD  RST 99h             ----") ;  end    
      $display (" t-2152-                                                                                                                           ")     ;

      task_monitor("TASK_CMD_USAGE_REPORT",0);
   end
endtask // TASK_CMD_USAGE_REPORT
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $4 TASK_TRACK_CMD_INIT
// initializes SPI_CMD_DATA and QPI_CMD_DATA arrays to 0
task TASK_TRACK_CMD_INIT ;
   begin
      task_monitor("TASK_TRACK_CMD_INIT",1);
      for (index_task_cmd = 0 ; index_task_cmd < 48 ; index_task_cmd =  index_task_cmd + 1)
	begin
	   SPI_CMD_DATA[index_task_cmd] = 0 ;
	end
      task_monitor("TASK_TRACK_CMD_INIT",0);
   end
endtask // TASK_TRACK_CMD_INIT
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******

// **START****START****START****START****START****START****START****START****START****START****START**
// TASK_TRACK_CMD_USAGE(CMD)
// CMD input,  tracks what commands were used in SPI and QPI modes
task TASK_TRACK_CMD_USAGE ;
   input   [7:0] CMD ;
   begin
      // task_monitor("TASK_TRACK_CMD_USAGE",1);

      if (QPI_MODE == 0)
	begin
           case (CMD)
             8'h00:  SPI_CMD_DATA[0]  = 1 ;   //ASCII_CMD     =  "NOP 00h" ;
             8'h01:  SPI_CMD_DATA[1]  = 1 ;   //ASCII_CMD     =  "WRSR 01h" ;
             8'h02:  SPI_CMD_DATA[2]  = 1 ;   //ASCII_CMD     =  "PP 02h" ;
             8'h03:  SPI_CMD_DATA[3]  = 1 ;   //ASCII_CMD     =  "READ 03h" ;
             8'h04:  SPI_CMD_DATA[4]  = 1 ;   //ASCII_CMD     =  "WRDI 04h" ;
             8'h05:  SPI_CMD_DATA[5]  = 1 ;   //ASCII_CMD     =  "RDSR 05h" ;
             8'h06:  SPI_CMD_DATA[6]  = 1 ;   //ASCII_CMD     =  "WREN 06h" ;
             8'h09:  SPI_CMD_DATA[7]  = 1 ;   //ASCII_CMD     =  "RDLB 09h" ;
             8'h10:  SPI_CMD_DATA[8]  = 1 ;   //ASCII_CMD     =  "NEURONACT 10h" ;
             8'h0B:  SPI_CMD_DATA[9]  = 1 ;   //ASCII_CMD     =  "FASTREAD 0Bh" ;
             8'h53:  SPI_CMD_DATA[10] = 1 ;   //ASCII_CMD     =  "INF 53h" ;
             8'h54:  SPI_CMD_DATA[11] = 1 ;   //ASCII_CMD     =  "NEUREAD 54h" ;
             8'h55:  SPI_CMD_DATA[12] = 1 ;   //ASCII_CMD     =  "MACCYC 55h" ;
             8'h56:  SPI_CMD_DATA[13] = 1 ;   //ASCII_CMD     =  "BIASBUF 56h" ;
             8'h57:  SPI_CMD_DATA[14] = 1 ;   //ASCII_CMD     =  "SCE 57h" ;
             8'h58:  SPI_CMD_DATA[15] = 1 ;   //ASCII_CMD     =  "SCEWAF 58h" ;
             8'h59:  SPI_CMD_DATA[16] = 1 ;   //ASCII_CMD     =  "LBWR 59h" ;
             8'h66:  SPI_CMD_DATA[17] = 1 ;   //ASCII_CMD     =  "RSTEN 66h" ;
             8'h98:  SPI_CMD_DATA[18] = 1 ;   //ASCII_CMD     =  "ACCRST 98h" ;
             8'h99:  SPI_CMD_DATA[19] = 1 ;   //ASCII_CMD     =  "RSTMEM 99h" ;                   
           endcase
	end
      // task_monitor("TASK_TRACK_CMD_USAGE",0);
   end
endtask // TASK_TRACK_CMD_USAGE
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
// $4 TASK_TRACK_STATUS_REG_USAGE
// CMD input, adjusts task calls to fit SPI or QPI modes, note no DPI mode for command cycles
// Passed 8 bit command,
// command is read by chip on rising edge MSB is first read in to_lSB is_last
// added CS going_low control_locally, if set externally, missed timing
// Level 4 routine
task TASK_TRACK_STATUS_REG_USAGE ;
   begin
      task_monitor("TASK_TRACK_STATUS_REG_USAGE",1);
      if (QPI_MODE == 0)
	begin
	   if (READ_BYTE_G[0] == 1 )  SPI_STATUS_REG_DATA[0] = 1 ;
	   if (READ_BYTE_G[1] == 1 )  SPI_STATUS_REG_DATA[1] = 1 ;
	   if (READ_BYTE_G[2] == 1 )  SPI_STATUS_REG_DATA[2] = 1 ;
	   if (READ_BYTE_G[3] == 1 )  SPI_STATUS_REG_DATA[3] = 1 ;
	   if (READ_BYTE_G[4] == 1 )  SPI_STATUS_REG_DATA[4] = 1 ;
	   if (READ_BYTE_G[5] == 1 )  SPI_STATUS_REG_DATA[5] = 1 ;
	   if (READ_BYTE_G[6] == 1 )  SPI_STATUS_REG_DATA[6] = 1 ;
	   if (READ_BYTE_G[7] == 1 )  SPI_STATUS_REG_DATA[7] = 1 ;
	end
      
      task_monitor("TASK_TRACK_STATUS_REG_USAGE",0);
   end
endtask // TASK_TRACK_STATUS_REG_USAGE
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
// $4 TASK_TRACK_REG_INIT
// initializes SPI_STATUS_REG_DATA, QPI_STATUS_REG_DATA, SPI_SECUR_REG_DATA and QPI_SECUR_REG_DATA arrays to 0
task TASK_TRACK_REG_INIT ;
   begin
      task_monitor("TASK_TRACK_REG_INIT",1);
      for (index_task_track     =  0 ; index_task_track < 8 ; index_task_track =  index_task_track + 1)
	begin
           SPI_STATUS_REG_DATA[index_task_track] = 0 ;
	end
      task_monitor("TASK_TRACK_REG_INIT",0);
   end
endtask // TASK_TRACK_REG_INIT
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******

// **START****START****START****START****START****START****START****START****START****START****START**
task task_monitor;
   input [255:0] taskname;
   input 	 start;
   integer 	 start;
   begin
      if ( task_time != $time) begin
	 task_time= $time;
	 $fwrite(task_sequence,"%t ", $time);
      end
      else $fwrite(task_sequence,"                     ");
      if (start == 1) begin
	 indent = indent + 1;
  	 for (index_task_monitor     =  0 ; index_task_monitor < indent ; index_task_monitor =  index_task_monitor + 1) begin :start_indent_loop
	    $fwrite(task_sequence, " ");
	 end
	 $fwrite(task_sequence, "%0s {\n" ,taskname);
      end
      else begin
  	 for (index_task_monitor     =  0 ; index_task_monitor < indent ; index_task_monitor =  index_task_monitor + 1) begin :end_indent_loop
	    $fwrite(task_sequence, " ");
	 end
	 indent = indent - 1;
	 $fwrite(task_sequence,"}   \/\/ %0s\n",taskname);
      end

      // if ( task_time != $time) begin
      // 	$fwrite(task_sequence,"%t task_powerup\n", $time);
      // end
      // else $fwrite(task_sequence,"       task_powerup (%t)\n",$time);
   end
endtask
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******



// **START****START****START****START****START****START****START****START****START****START****START**
task TASK_REGISTER_VALUE_CHECK ;
   begin
      if (debug_1 == 1 ) $display ("ENTER", $time," t-2300- TASK_REGISTER_VALUE_CHECK status register w/o WEL loop ") ;
      Operation1         =  " t-2301 TASK_TASK_EXPECT_PASS" ;
      if (READ_BYTE_G !==  0)
	begin
	   task_monitor("TASK_REGISTER_VALUE_CHECK status register w/o WEL loop",1);
	   TEST_RUN = 0;
	   $display ("__________________________________________________________________") ;
	   $display (" ########    ###    #### ##       ##     ## ########  ########  ");
	   $display (" ##         ## ##    ##  ##       ##     ## ##     ## ##        ");
	   $display (" ##        ##   ##   ##  ##       ##     ## ##     ## ##        ");
	   $display (" ######   ##     ##  ##  ##       ##     ## ########  ######    ");
	   $display (" ##       #########  ##  ##       ##     ## ##   ##   ##        ");
	   $display (" ##       ##     ##  ##  ##       ##     ## ##    ##  ##        ");
	   $display (" ##       ##     ## #### ########  #######  ##     ## ########  ");
	   $display ("__________________________________________________________________") ;
	   $display ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") ;
	   $display ("Test bench step FAILURE -- status Register Mismatch between MACRONIX and GMSI  status register w/o WEL loop  ") ;
	   $display (" @@fail   ") ;
	   if (debug_0 == 1) $display ($time," t-2318-TASK_REGISTER_VALUE_CHECK  status register w/o WEL loop is  GMSI_READ_BYTE_G[1] = %b    ", READ_BYTE_G) ;
	   $display ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") ;
	end
      Operation1           =  1'bx ;
      //  if (debug_1 == 1 ) $display ("Reset SUCCESS to 1 for next section") ;
      //   SUCCESS = 1 ;
   end
endtask // TASK_REGISTER_VALUE_CHECK
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******



task TASK_STATUS_REGISTER_VALUE_CHECK ;
   begin
      task_monitor("TASK_STATUS_REGISTER_VALUE_CHECK",1);
      if (debug_1 == 1 ) $display ("ENTER", $time," t-2333- TASK_STATUS_REGISTER_VALUE_CHECK ") ;
      // allow for time delay for WEL bit to change
      Operation1         =  " t-2335 TASK_STATUS_REGISTER_VALUE_CHECK, provide for temporial WEL mismatch" ;
      if (READ_BYTE_G[1] !==  0)
	begin
	   time_out   =  0 ;
	   //		  while (time_out < (20_000 / time_out_factor))
	   while ((READ_BYTE_G[1] !==  0) & (time_out < (20_000 / time_out_factor)))
	     begin
		time_out   =  time_out+1 ;
		//    if (debug_1 == 1) $display ($time," t-2342 TASK_STATUS_REGISTER_VALUE_CHECK -> wait for WEL bit to change, RDSR ") ;
		TASK_GENERIC (8'h05, 0, 0, 0,0, 1) ;    // RDSR     - read Status
		TASK_TRACK_STATUS_REG_USAGE;
		#10 ;
	     end
	end

      // at this point have allowed for time delay of GMSIC design to reset WEL bit
      // if time_out less than 20_000, then (READ_BYTE_M[1] ===  READ_BYTE_G[1])
      if (READ_BYTE_G !==  0) 
	begin
  	   task_monitor("TASK_STATUS_REGISTER_VALUE_CHECK",1);
  	   TEST_RUN = 0;
	   if (debug_0 == 1)  $display ($time," t-2355- TASK_STATUS_REGISTER_VALUE_CHECK  if time_out = 0, READ_BYTE_M[1] ===  READ_BYTE_G[1] on call " ) ;
	   if (debug_0 == 1)  $display ($time," t-2356- TASK_STATUS_REGISTER_VALUE_CHECK  if time_out < 20,000, READ_BYTE_M[1] !==  READ_BYTE_G[1] and WEL bit switched after call " ) ;
	   if (debug_0 == 1)  $display ($time," t-2357- TASK_STATUS_REGISTER_VALUE_CHECK  if time_out = 20,000, READ_BYTE_M[1] !==  READ_BYTE_G[1] and WEL bit never switched " ) ;
	   if (debug_0 == 1)  $display ($time," t-2358- TASK_STATUS_REGISTER_VALUE_CHECK time_out = %d   ", time_out ) ;
  	   $display ("__________________________________________________________________") ;
  	   $display (" ########    ###    #### ##       ##     ## ########  ########  ");
  	   $display (" ##         ## ##    ##  ##       ##     ## ##     ## ##        ");
  	   $display (" ##        ##   ##   ##  ##       ##     ## ##     ## ##        ");
  	   $display (" ######   ##     ##  ##  ##       ##     ## ########  ######    ");
  	   $display (" ##       #########  ##  ##       ##     ## ##   ##   ##        ");
  	   $display (" ##       ##     ##  ##  ##       ##     ## ##    ##  ##        ");
  	   $display (" ##       ##     ## #### ########  #######  ##     ## ########  ");
  	   $display ("__________________________________________________________________") ;
  	   $display ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") ;
  	   $display ("Test bench step FAILURE -- Register Mismatch between MACRONIX and GMSI  ") ;
  	   $display (" @@fail   ") ;
	   if (debug_0 == 1) $display ($time," t-2371-TASK_STATUS_REGISTER_VALUE_CHECK is  Macronix READ_BYTE_M= %b    ", READ_BYTE_M, " GMSI_READ_BYTE_G[1] = %b    ", READ_BYTE_G) ;
  	   $display ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") ;
	   Operation1           =  1'bx ;
	end

      //  if (debug_1 == 1 ) $display ("Reset SUCCESS to 1 for next section") ;
      //  SUCCESS = 1 ;

      task_monitor("TASK_STATUS_REGISTER_VALUE_CHECK",0);
   end
endtask // TASK_STATUS_REGISTER_VALUE_CHECK
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******







task TASK_STATUS_REGISTER_VALUE_CHECK_HIGH ;
   begin
      task_monitor("TASK_STATUS_REGISTER_VALUE_CHECK",1);
      if (debug_1 == 1 ) $display ("ENTER", $time," t-2333- TASK_STATUS_REGISTER_VALUE_CHECK ") ;
      // allow for time delay for WEL bit to change
      Operation1         =  " t-2335 TASK_STATUS_REGISTER_VALUE_CHECK, provide for temporial WEL mismatch" ;
      if (READ_BYTE_G[1] ==  1)
	begin
	   time_out   =  0 ;
	   //		  while (time_out < (20_000 / time_out_factor))
	   while ((READ_BYTE_G[1] ==  1) & (time_out < (20_000 / time_out_factor)))
	     begin
		time_out   =  time_out+1 ;
		//    if (debug_1 == 1) $display ($time," t-2342 TASK_STATUS_REGISTER_VALUE_CHECK -> wait for WEL bit to change, RDSR ") ;
		TASK_GENERIC (8'h05, 0, 0, 0,0, 1) ;    // RDSR     - read Status
		TASK_TRACK_STATUS_REG_USAGE;
		#10 ;
	     end
	end

      // at this point have allowed for time delay of GMSIC design to reset WEL bit
      // if time_out less than 20_000, then (READ_BYTE_M[1] ===  READ_BYTE_G[1])
      if (READ_BYTE_G ==  1) 
	begin
  	   task_monitor("TASK_STATUS_REGISTER_VALUE_CHECK",1);
  	   TEST_RUN = 0;
	   if (debug_0 == 1)  $display ($time," t-2355- TASK_STATUS_REGISTER_VALUE_CHECK  if time_out = 0, READ_BYTE_M[1] ===  READ_BYTE_G[1] on call " ) ;
	   if (debug_0 == 1)  $display ($time," t-2356- TASK_STATUS_REGISTER_VALUE_CHECK  if time_out < 20,000, READ_BYTE_M[1] !==  READ_BYTE_G[1] and WEL bit switched after call " ) ;
	   if (debug_0 == 1)  $display ($time," t-2357- TASK_STATUS_REGISTER_VALUE_CHECK  if time_out = 20,000, READ_BYTE_M[1] !==  READ_BYTE_G[1] and WEL bit never switched " ) ;
	   if (debug_0 == 1)  $display ($time," t-2358- TASK_STATUS_REGISTER_VALUE_CHECK time_out = %d   ", time_out ) ;
  	   $display ("__________________________________________________________________") ;
  	   $display (" ########    ###    #### ##       ##     ## ########  ########  ");
  	   $display (" ##         ## ##    ##  ##       ##     ## ##     ## ##        ");
  	   $display (" ##        ##   ##   ##  ##       ##     ## ##     ## ##        ");
  	   $display (" ######   ##     ##  ##  ##       ##     ## ########  ######    ");
  	   $display (" ##       #########  ##  ##       ##     ## ##   ##   ##        ");
  	   $display (" ##       ##     ##  ##  ##       ##     ## ##    ##  ##        ");
  	   $display (" ##       ##     ## #### ########  #######  ##     ## ########  ");
  	   $display ("__________________________________________________________________") ;
  	   $display ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") ;
  	   $display ("Test bench step FAILURE -- Register Mismatch between MACRONIX and GMSI  ") ;
  	   $display (" @@fail   ") ;
	   if (debug_0 == 1) $display ($time," t-2371-TASK_STATUS_REGISTER_VALUE_CHECK is  Macronix READ_BYTE_M= %b    ", READ_BYTE_M, " GMSI_READ_BYTE_G[1] = %b    ", READ_BYTE_G) ;
  	   $display ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") ;
	   Operation1           =  1'bx ;
	end

      //  if (debug_1 == 1 ) $display ("Reset SUCCESS to 1 for next section") ;
      //  SUCCESS = 1 ;

      task_monitor("TASK_STATUS_REGISTER_VALUE_CHECK",0);
   end
endtask // TASK_STATUS_REGISTER_VALUE_CHECK
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




task TASK_STATUS_REGISTER_VALUE_CHECK_LOW ;
   begin
      task_monitor("TASK_STATUS_REGISTER_VALUE_CHECK",1);
      if (debug_1 == 1 ) $display ("ENTER", $time," t-2333- TASK_STATUS_REGISTER_VALUE_CHECK ") ;
      // allow for time delay for WEL bit to change
      Operation1         =  " t-2335 TASK_STATUS_REGISTER_VALUE_CHECK, provide for temporial WEL mismatch" ;
      if (READ_BYTE_G[1] ==  0)
	begin
	   time_out   =  0 ;
	   //		  while (time_out < (20_000 / time_out_factor))
	   while ((READ_BYTE_G[1] ==  0) & (time_out < (20_000 / time_out_factor)))
	     begin
		time_out   =  time_out+1 ;
		//    if (debug_1 == 1) $display ($time," t-2342 TASK_STATUS_REGISTER_VALUE_CHECK -> wait for WEL bit to change, RDSR ") ;
		TASK_GENERIC (8'h05, 0, 0, 0,0, 1) ;    // RDSR     - read Status
		TASK_TRACK_STATUS_REG_USAGE;
		#10 ;
	     end
	end

      // at this point have allowed for time delay of GMSIC design to reset WEL bit
      // if time_out less than 20_000, then (READ_BYTE_M[1] ===  READ_BYTE_G[1])
      if (READ_BYTE_G ==  0) 
	begin
  	   task_monitor("TASK_STATUS_REGISTER_VALUE_CHECK",1);
  	   TEST_RUN = 0;
	   if (debug_0 == 1)  $display ($time," t-2355- TASK_STATUS_REGISTER_VALUE_CHECK  if time_out = 0, READ_BYTE_M[1] ===  READ_BYTE_G[1] on call " ) ;
	   if (debug_0 == 1)  $display ($time," t-2356- TASK_STATUS_REGISTER_VALUE_CHECK  if time_out < 20,000, READ_BYTE_M[1] !==  READ_BYTE_G[1] and WEL bit switched after call " ) ;
	   if (debug_0 == 1)  $display ($time," t-2357- TASK_STATUS_REGISTER_VALUE_CHECK  if time_out = 20,000, READ_BYTE_M[1] !==  READ_BYTE_G[1] and WEL bit never switched " ) ;
	   if (debug_0 == 1)  $display ($time," t-2358- TASK_STATUS_REGISTER_VALUE_CHECK time_out = %d   ", time_out ) ;
  	   $display ("__________________________________________________________________") ;
  	   $display (" ########    ###    #### ##       ##     ## ########  ########  ");
  	   $display (" ##         ## ##    ##  ##       ##     ## ##     ## ##        ");
  	   $display (" ##        ##   ##   ##  ##       ##     ## ##     ## ##        ");
  	   $display (" ######   ##     ##  ##  ##       ##     ## ########  ######    ");
  	   $display (" ##       #########  ##  ##       ##     ## ##   ##   ##        ");
  	   $display (" ##       ##     ##  ##  ##       ##     ## ##    ##  ##        ");
  	   $display (" ##       ##     ## #### ########  #######  ##     ## ########  ");
  	   $display ("__________________________________________________________________") ;
  	   $display ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") ;
  	   $display ("Test bench step FAILURE -- Register Mismatch between MACRONIX and GMSI  ") ;
  	   $display (" @@fail   ") ;
	   if (debug_0 == 1) $display ($time," t-2371-TASK_STATUS_REGISTER_VALUE_CHECK is  Macronix READ_BYTE_M= %b    ", READ_BYTE_M, " GMSI_READ_BYTE_G[1] = %b    ", READ_BYTE_G) ;
  	   $display ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") ;
	   Operation1           =  1'bx ;
	end

      //  if (debug_1 == 1 ) $display ("Reset SUCCESS to 1 for next section") ;
      //  SUCCESS = 1 ;

      task_monitor("TASK_STATUS_REGISTER_VALUE_CHECK",0);
   end
endtask // TASK_STATUS_REGISTER_VALUE_CHECK




// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_RESET
// TAKES NO ARGUMENTS
//
// reset the chip
// Power up of chip
// Level 0 routine
task TASK_ACCRST ;
   //input   NUMBER_OF_READ_BYTES ;  // number of bytes to read in each CS low interval

   //integer NUMBER_OF_READ_BYTES ;  
   begin
      task_monitor("TASK_ACCRST",1);
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_1 == 1 ) $display ("ENTER", $time," t-2401- TASK_ACCRST ") ;
      if (debug_1 == 1) $display ($time," t-2402 TASK_ACCRST ") ;
      Operation      =  (" t-2403 TASK_ACCRST " )      ;
      if (debug_3 == 1) $display ($time," t-2404 TASK_ACCRST --> TASK_GENERIC - 98 - ACCRST") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h98, 0, 0, 0,0, 0) ;    // ACCRST    - reset enable  
      //  Operation1     =  "TASK_RESET --> tRCR Reset Recover Time start"      ;
      #(tRCR * ((1_000) )) ;
      // ************************
      Operation      =  1'bx ;
      Operation1     =  1'bx ;
      // ************************
      task_monitor("TASK_ACCRST",0);
   end
endtask // TASK_ACCRST
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******



// **START****START****START****START****START****START****START****START****START****START****START**
// $3 TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
// Level 3 routine
// Will call sub-tasks
// -- Normal Flow is CMD, Address, Dummy, read or write
// gdg not expected would do both read and write but no check to prevent miss call
// to do both read and write would be illegal , probably should add check

task TASK_GENERIC_BIASBUF ;
   input   [7:0] CMD ;     // pass command code
   input 	 NUMBER_OF_ADDRESS_BITS ;
   input [47:0]  ADDRESS ;
   input 	 NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer
   input 	 NUMBER_OF_WRITE_BYTES ;
   input 	 NUMBER_OF_READ_BYTES ;
   
   integer 	 NUMBER_OF_ADDRESS_BITS ;
   integer 	 NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer
   integer 	 NUMBER_OF_WRITE_BYTES ;
   integer 	 NUMBER_OF_READ_BYTES ;
   begin :initial_begin
      task_monitor("TASK_GENERIC",1);
      $fwrite(task_sequence, "                     CMD='h%h, NoAB='h%h,ADDR='h%h,  NoDC='h%h, NoWB='h%h, NoRB='h%h\n"
	      , CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS, NUMBER_OF_DUMMY_CYCLES, NUMBER_OF_WRITE_BYTES, NUMBER_OF_READ_BYTES);
      Line_num       =  " t-484" ;
      Operation3     =  " t-485 TASK_GENERIC" ;

      if (debug_1 == 1) $display ($time," t-487- TASK_GENERIC ") ;
      if (debug_4 == 1) $display ($time," t-488- TASK_GENERIC-> NUMBER_OF_ADDRESS_BITS = %d ", NUMBER_OF_ADDRESS_BITS ) ;
      if (debug_4 == 1) $display ($time," t-489- TASK_GENERIC-> ADDRESS = %h ", ADDRESS ) ;
      if (debug_4 == 1) $display ($time," t-490- TASK_GENERIC-> NUMBER_OF_DUMMY_CYCLES = %d ", NUMBER_OF_DUMMY_CYCLES ) ;
      if (debug_4 == 1) $display ($time," t-491- TASK_GENERIC-> NUMBER_OF_WRITE_BYTES = %d ", NUMBER_OF_WRITE_BYTES ) ;
      if (debug_4 == 1) $display ($time," t-492- TASK_GENERIC-> NUMBER_OF_READ_BYTES = %d ", NUMBER_OF_READ_BYTES ) ;
      TASK_CMD(CMD) ;
      // do test if address cycles are needed
      if (NUMBER_OF_ADDRESS_BITS != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-497- TASK_GENERIC->TASK_ADDRESS") ;
	   Line_num   =  " t-498-" ;
	   MODE       =  "ADDRESS MODE" ;
	   TASK_ADDRESS(NUMBER_OF_ADDRESS_BITS,ADDRESS) ;
	end

      // do test if write cycles are needed
      if (NUMBER_OF_WRITE_BYTES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-514- TASK_GENERIC->TASK_WRITE") ;
	   Line_num   =  " t-515" ;
	   MODE       =  "WRITE MODE" ;
	   TASK_WRITE(NUMBER_OF_WRITE_BYTES) ;
	end

      // do test if read cycles are needed
      if (NUMBER_OF_READ_BYTES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-523- TASK_GENERIC->TASK_READ") ;
	   Line_num   =  " t-524" ;
	   MODE       =  "READ MODE" ;
	   TASK_SPI_READ(NUMBER_OF_READ_BYTES) ;
	end

      if (NUMBER_OF_DUMMY_CYCLES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-505- TASK_GENERIC->TASK_DUMMY") ;
	   Line_num   =  " t-506-" ;
	   MODE       =  "DUMMY MODE" ;
	   TASK_DUMMY(NUMBER_OF_DUMMY_CYCLES) ;
	end
      
      if (debug_4 == 1) $display ($time," t-528- TASK_GENERIC->END") ;
      Operation3 =  1'bx ;
      @(posedge SCLK) CS =  1 ;
      SI_out = 0;   
      task_monitor("TASK_GENERIC",0);
   end

endtask // TASK_GENERIC
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******



// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_BIASBUFF
// TAKES NO ARGUMENTS
// works in Either SPI  modes
// layer buffer write
task TASK_BIASBUF ;
   input   NUMBER_OF_READ_BYTES ;  // number of bytes to read in each CS low interval

   integer NUMBER_OF_READ_BYTES ;   

   input [15:0] ADDRESS;   
   
   integer 	ADDRESS;
   
   begin
      task_monitor("TASK_BIASBUF",1);
      if (debug_1 == 1) $display ("ENTER", $time," t-2435- TASK_BIASBUF ") ;
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_0 == 1) $display ($time," t-2437 TASK_BIASBUF ") ;
      Operation      =  (" t-2438 TASK_BIASBUF " )      ;
      if (debug_2 == 1) $display ($time," t-2439 TASK_BIASBUF --> TASK_GENERIC - 56 - BIASBUF") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h56, 16, ADDRESS, 0, NUMBER_OF_READ_BYTES, 0) ;    // BIASBUF
      //    TASK_GENERIC (8'h56, 16, ADDRESS, 8, 2, 0) ;    // BIASBUF

      #(tRES1 * (1_000 / speedup_us)) ;
      // ************************
      Operation      =  1'bx ;
      //  Operation2    =  1'bx ;
      // ************************
      task_monitor("TASK_BIASBUF",0);
   end
endtask // TASK_BIASBUF
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $3 TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
// Level 3 routine
// Will call sub-tasks
// -- Normal Flow is CMD, Address, Dummy, read or write
// gdg not expected would do both read and write but no check to prevent miss call
// to do both read and write would be illegal , probably should add check

task TASK_GENERIC_LB ;
   input   [7:0] CMD ;     // pass command code
   input 	 NUMBER_OF_ADDRESS_BITS ;
   input [47:0]  ADDRESS ;
   input 	 NUMBER_OF_WRITE_BYTES ;
   input 	 NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer
   input 	 NUMBER_OF_READ_BYTES ;
   
   integer 	 NUMBER_OF_ADDRESS_BITS ;
   integer 	 NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer
   integer 	 NUMBER_OF_WRITE_BYTES ;
   integer 	 NUMBER_OF_READ_BYTES ;
   begin :initial_begin
      task_monitor("TASK_GENERIC_LB",1);
      $fwrite(task_sequence, "                     CMD='h%h, NoAB='h%h,ADDR='h%h,  NoDC='h%h, NoWB='h%h, NoRB='h%h\n"
	      , CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS, NUMBER_OF_WRITE_BYTES,NUMBER_OF_DUMMY_CYCLES, NUMBER_OF_READ_BYTES);
      Line_num       =  " t-484" ;
      Operation3     =  " t-485 TASK_GENERIC" ;

      if (debug_1 == 1) $display ($time," t-487- TASK_GENERIC ") ;
      if (debug_4 == 1) $display ($time," t-488- TASK_GENERIC-> NUMBER_OF_ADDRESS_BITS = %d ", NUMBER_OF_ADDRESS_BITS ) ;
      if (debug_4 == 1) $display ($time," t-489- TASK_GENERIC-> ADDRESS = %h ", ADDRESS ) ;
      if (debug_4 == 1) $display ($time," t-491- TASK_GENERIC-> NUMBER_OF_WRITE_BYTES = %d ", NUMBER_OF_WRITE_BYTES ) ;
      if (debug_4 == 1) $display ($time," t-490- TASK_GENERIC-> NUMBER_OF_DUMMY_CYCLES = %d ", NUMBER_OF_DUMMY_CYCLES ) ;
      if (debug_4 == 1) $display ($time," t-492- TASK_GENERIC-> NUMBER_OF_READ_BYTES = %d ", NUMBER_OF_READ_BYTES ) ;
      TASK_CMD(CMD) ;
      // do test if address cycles are needed
      if (NUMBER_OF_ADDRESS_BITS != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-497- TASK_GENERIC->TASK_ADDRESS") ;
	   Line_num   =  " t-498-" ;
	   MODE       =  "ADDRESS MODE" ;
	   TASK_ADDRESS(NUMBER_OF_ADDRESS_BITS,ADDRESS) ;
	end
      // do test if write cycles are needed
      if (NUMBER_OF_WRITE_BYTES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-514- TASK_GENERIC->TASK_WRITE") ;
	   Line_num   =  " t-515" ;
	   MODE       =  "WRITE MODE" ;
	   TASK_WRITE(NUMBER_OF_WRITE_BYTES) ;
	end
      // do test if dummy cycles are needed
      if (NUMBER_OF_DUMMY_CYCLES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-505- TASK_GENERIC->TASK_DUMMY") ;
	   Line_num   =  " t-506-" ;
	   MODE       =  "DUMMY MODE" ;
	   TASK_DUMMY(NUMBER_OF_DUMMY_CYCLES) ;
	end
      // do test if read cycles are needed
      if (NUMBER_OF_READ_BYTES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-523- TASK_GENERIC->TASK_READ") ;
	   Line_num   =  " t-524" ;
	   MODE       =  "READ MODE" ;
	   TASK_READ(NUMBER_OF_READ_BYTES) ;
	end
      if (debug_4 == 1) $display ($time," t-528- TASK_GENERIC->END") ;
      Operation3 =  1'bx ;
      @(posedge SCLK) CS =  1 ;
      SI_out = 0;   
      task_monitor("TASK_GENERIC",0);
   end
endtask // TASK_GENERIC
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_LBWR
// TAKES NO ARGUMENTS
// works in Either SPI  modes
// layer buffer write
task TASK_LBWR ;
   //input   NUMBER_OF_WRITE_BYTES ;
   
   //input   NUMBER_OF_READ_BYTES ;  // number of bytes to read in each CS low interval
   //integer NUMBER_OF_READ_BYTES ;
   input [15:0] ADDRESS;
   integer 	ADDRESS;    
   begin
      task_monitor("TASK_LBWR",1);
      if (debug_1 == 1) $display ("ENTER", $time," t-2469- TASK_LBWR ") ;
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_0 == 1) $display ($time," t-2471 TASK_LBWR ") ;
      Operation      =  (" t-2472 TASK_LBWR " )      ;
      if (debug_2 == 1) $display ($time," t-2473 TASK_LBWR --> TASK_GENERIC - 59 - LBWR") ;
      // TASK_GENERIC_LB (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_WRITE_BYTE,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC_LB (8'h59, 16, ADDRESS, 1,8, 0) ;    
      #(tRES1 * (1_000 / speedup_us)) ;
      // ************************
      Operation      =  1'bx ;
      //  Operation2    =  1'bx ;
      // ************************
      task_monitor("TASK_LBWR",0);
   end
endtask // TASK_LBWR
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******



// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_MACCYC
// TAKES NO ARGUMENTS
// works in Either SPI  modes
// mac cycle
task TASK_MACCYC ;
   input   NUMBER_OF_READ_BYTES ;  // number of bytes to read in each CS low interval     
   integer NUMBER_OF_READ_BYTES ;   
   input [31:0] ADDRESS;
   integer 	ADDRESS;   

   begin
      task_monitor("TASK_MACCYC",1);
      if (debug_1 == 1) $display ("ENTER", $time," t-2501- TASK_MACCYC ") ;
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_0 == 1) $display ($time," t-2503 TASK_MACCYC ") ;
      Operation      =  (" t-2504 TASK_MACCYC " )      ;
      if (debug_2 == 1) $display ($time," t-2505 TASK_MACCYC --> TASK_GENERIC - 55 - MACCYC") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC5 (8'h55, 32, ADDRESS, 0, 0, NUMBER_OF_READ_BYTES) ;    // MACCYC
      #(tRES1 * (1_000 / speedup_us)) ;
      // ************************
      Operation      =  1'bx ;
      //  Operation2    =  1'bx ;
      // ************************
      task_monitor("TASK_MACCYC",0);
   end
endtask // TASK_MACCYC
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******



// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_NEUREAD
// TAKES NO ARGUMENTS
// works in Either SPI  modes
// neuron read
task TASK_NEUREAD ;
   input   NUMBER_OF_READ_BYTES ;  // number of bytes to read in each CS low interval
   integer NUMBER_OF_READ_BYTES ;
   
   input [15:0] ADDRESS;
   integer 	ADDRESS;     
   begin
      task_monitor("TASK_NEUREAD",1);
      if (debug_1 == 1) $display ("ENTER", $time," t-2534- TASK_NEUREAD ") ;
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_0 == 1) $display ($time," t-2536 TASK_NEUREAD ") ;
      Operation      =  (" t-2537 TASK_NEUREAD " )      ;
      if (debug_2 == 1) $display ($time," t-2538 TASK_NEUREAD --> TASK_GENERIC - 54 - NEUREAD") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h54, 16, ADDRESS, 8,0,NUMBER_OF_READ_BYTES) ;    // NEUREAD
      #(tRES1 * (1_000 / speedup_us)) ;
      // ************************
      Operation      =  1'bx ;
      //  Operation2    =  1'bx ;
      // ************************
      task_monitor("TASK_NEUREAD",0);
   end
endtask // TASK_NEUREAD
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******



// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_INF
// TAKES NO ARGUMENTS
// works in Either SPI  modes
// inference
task TASK_INF ;
   //input   NUMBER_OF_READ_BYTES ;  // number of bytes to read in each CS low interval
   //integer NUMBER_OF_READ_BYTES ;
   input [47:0] ADDRESS;
   //integer ADDRESS;   
   
   begin
      task_monitor("TASK_INF",1);
      if (debug_1 == 1) $display ("ENTER", $time," t-2569- TASK_INF ") ;
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_0 == 1) $display ($time," t-2571 TASK_INF ") ;
      Operation      =  (" t-2572 TASK_INF " )      ;
      if (debug_2 == 1) $display ($time," t-2573 TASK_INF --> TASK_GENERIC - 53 - INF") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h53, 48, ADDRESS, 0, 0,0 ) ;    // INF
      #(tRES1 * (1_000 / speedup_us)) ;
      // ************************
      Operation      =  1'bx ;
      //  Operation2    =  1'bx ;
      // ************************
      task_monitor("TASK_INF",0);
   end
endtask // TASK_INF
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******



// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_NEURONACT
// TAKES NO ARGUMENTS
// works in Either SPI  modes
// neuron activation
// RES the chip - figs 29-1, 29-2
task TASK_NEURONACT ;
   //input   NUMBER_OF_READ_BYTES ;  // number of bytes to read in each CS low interval
   //integer NUMBER_OF_READ_BYTES ;   
   input [31:0] ADDRESS;
   integer 	ADDRESS;     
   begin
      task_monitor("TASK_NEURONACT",1);
      if (debug_1 == 1) $display ("ENTER", $time," t-2601- TASK_NEURONACT ") ;
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_0 == 1) $display ($time," t-2603 TASK_NEURONACT ") ;
      Operation      =  (" t-2604 TASK_NEURONACT " )      ;
      if (debug_2 == 1) $display ($time," t-2605 TASK_NEURONACT --> TASK_GENERIC - 10 - NEURONACT") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC (8'h10, 32, ADDRESS, 8, 0, 0) ;    // NEURONACT
      #(tRES1 * (1_000 / speedup_us)) ;
      // ************************
      Operation      =  1'bx ;
      //  Operation2    =  1'bx ;
      // ************************
      task_monitor("TASK_NEURONACT",0);
   end
endtask // TASK_NEURONACT
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $3 TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
// Level 3 routine
// Will call sub-tasks
// -- Normal Flow is CMD, Address, Dummy, read or write
// gdg not expected would do both read and write but no check to prevent miss call
// to do both read and write would be illegal , probably should add check

task TASK_GENERIC5 ;
   input   [7:0] CMD ;     // pass command code
   input 	 NUMBER_OF_ADDRESS_BITS ;
   input [47:0]  ADDRESS ;
   input 	 NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer
   input 	 NUMBER_OF_WRITE_BYTES ;
   input 	 NUMBER_OF_READ_BYTES ;
   
   integer 	 NUMBER_OF_ADDRESS_BITS ;
   integer 	 NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer
   integer 	 NUMBER_OF_WRITE_BYTES ;
   integer 	 NUMBER_OF_READ_BYTES ;
   begin :initial_begin
      task_monitor("TASK_GENERIC",1);
      $fwrite(task_sequence, "                     CMD='h%h, NoAB='h%h,ADDR='h%h,  NoDC='h%h, NoWB='h%h, NoRB='h%h\n"
	      , CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS, NUMBER_OF_DUMMY_CYCLES, NUMBER_OF_WRITE_BYTES, NUMBER_OF_READ_BYTES);
      Line_num       =  " t-484" ;
      Operation3     =  " t-485 TASK_GENERIC" ;

      if (debug_1 == 1) $display ($time," t-487- TASK_GENERIC ") ;
      if (debug_4 == 1) $display ($time," t-488- TASK_GENERIC-> NUMBER_OF_ADDRESS_BITS = %d ", NUMBER_OF_ADDRESS_BITS ) ;
      if (debug_4 == 1) $display ($time," t-489- TASK_GENERIC-> ADDRESS = %h ", ADDRESS ) ;
      if (debug_4 == 1) $display ($time," t-490- TASK_GENERIC-> NUMBER_OF_DUMMY_CYCLES = %d ", NUMBER_OF_DUMMY_CYCLES ) ;
      if (debug_4 == 1) $display ($time," t-491- TASK_GENERIC-> NUMBER_OF_WRITE_BYTES = %d ", NUMBER_OF_WRITE_BYTES ) ;
      if (debug_4 == 1) $display ($time," t-492- TASK_GENERIC-> NUMBER_OF_READ_BYTES = %d ", NUMBER_OF_READ_BYTES ) ;
      TASK_CMD(CMD) ;
      // do test if address cycles are needed
      if (NUMBER_OF_ADDRESS_BITS != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-497- TASK_GENERIC->TASK_ADDRESS") ;
	   Line_num   =  " t-498-" ;
	   MODE       =  "ADDRESS MODE" ;
	   TASK_ADDRESS(NUMBER_OF_ADDRESS_BITS,ADDRESS) ;
	end
      // do test if dummy cycles are needed
      if (NUMBER_OF_DUMMY_CYCLES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-505- TASK_GENERIC->TASK_DUMMY") ;
	   Line_num   =  " t-506-" ;
	   MODE       =  "DUMMY MODE" ;
	   TASK_DUMMY(NUMBER_OF_DUMMY_CYCLES) ;
	end

      // do test if write cycles are needed
      if (NUMBER_OF_WRITE_BYTES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-514- TASK_GENERIC->TASK_WRITE") ;
	   Line_num   =  " t-515" ;
	   MODE       =  "WRITE MODE" ;
	   TASK_WRITE(NUMBER_OF_WRITE_BYTES) ;
	end

      // do test if read cycles are needed
      if (NUMBER_OF_READ_BYTES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-523- TASK_GENERIC->TASK_READ") ;
	   Line_num   =  " t-524" ;
	   MODE       =  "READ MODE" ;
	   TASK_SPI_READ(NUMBER_OF_READ_BYTES) ;
	end
      if (debug_4 == 1) $display ($time," t-528- TASK_GENERIC->END") ;
      Operation3 =  1'bx ;
      @(posedge SCLK) CS =  1 ;
      SI_out = 0;   
      task_monitor("TASK_GENERIC",0);
   end

endtask // TASK_GENERIC
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******


// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_RDLB
// TAKES NO ARGUMENTS
// works in Either SPI  modes
// reads layer buffer
// RES the chip - figs 29-1, 29-2
task TASK_RDLB ;
   input   NUMBER_OF_READ_BYTES ;  // number of bytes to read in each CS low interval
   integer NUMBER_OF_READ_BYTES ;
   begin
      task_monitor("TASK_RDLB",1);
      if (debug_1 == 1) $display ("ENTER", $time," t-2631- TASK_RDLB ") ;
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_0 == 1) $display ($time," t-2633 TASK_RDLB ") ;
      Operation      =  (" t-2634 TASK_RDLB " )      ;
      if (debug_2 == 1) $display ($time," t-2635 TASK_RDLB --> TASK_GENERIC - 09 - RDLB") ;
      // TASK_GENERIC (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC5 (8'h09, 0, 0, 8, 0, NUMBER_OF_READ_BYTES) ;    // RDLB

      //   @(posedge SCLK) CS = 1;
      
      
      #(tRES1 * (1_000 / speedup_us)) ;
      // ************************
      Operation      =  1'bx ;
      //  Operation2    =  1'bx ;
      // ************************
      task_monitor("TASK_RDLB",0);
   end
endtask // TASK_RDLB
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
task TASK_GENERIC3 ;
   input   [7:0] CMD ;     // pass command code
   input 	 NUMBER_OF_SCAN_BITS ;
   input [567:0] ADDRESS ;              // externally defined addresses
   input 	 NUMBER_OF_DUMMY_CYCLES ;       // externally defined integer
   input 	 NUMBER_OF_WRITE_BYTES ;        // externally defined integer
   input 	 NUMBER_OF_READ_BYTES ;         // externally defined integer
   
   integer 	 NUMBER_OF_SCAN_BITS ;        // externally defined integer
   integer 	 NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer
   integer 	 NUMBER_OF_WRITE_BYTES ;         // externally defined integer
   integer 	 NUMBER_OF_READ_BYTES ;          // externally defined integer
   begin :initial_begin
      task_monitor("TASK_GENERIC3",1);
      $fwrite(task_sequence, "                     CMD='h%h, NoAB='h%h,ADDR='h%h,  NoDC='h%h, NoWB='h%h, NoRB='h%h\n"
	      , CMD,NUMBER_OF_SCAN_BITS,ADDRESS, NUMBER_OF_DUMMY_CYCLES, NUMBER_OF_WRITE_BYTES, NUMBER_OF_READ_BYTES);
      Line_num       =  " t-484" ;
      Operation3     =  " t-485 TASK_GENERIC3" ;
      if (debug_1 == 1) $display ($time," t-487- TASK_GENERIC3 ") ;
      if (debug_4 == 1) $display ($time," t-488- TASK_GENERIC3-> NUMBER_OF_SCAN_BITS = %d ", NUMBER_OF_SCAN_BITS ) ;
      if (debug_4 == 1) $display ($time," t-489- TASK_GENERIC3-> ADDRESS = %h ", ADDRESS ) ;
      if (debug_4 == 1) $display ($time," t-490- TASK_GENERIC3-> NUMBER_OF_DUMMY_CYCLES = %d ", NUMBER_OF_DUMMY_CYCLES ) ;
      if (debug_4 == 1) $display ($time," t-491- TASK_GENERIC3-> NUMBER_OF_WRITE_BYTES = %d ", NUMBER_OF_WRITE_BYTES ) ;
      if (debug_4 == 1) $display ($time," t-492- TASK_GENERIC3-> NUMBER_OF_READ_BYTES = %d ", NUMBER_OF_READ_BYTES ) ;

      TASK_CMD(CMD) ;
      // do test if address cycles are needed
      if (NUMBER_OF_SCAN_BITS != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-497- TASK_GENERIC3->TASK_ADDRESS") ;
	   Line_num   =  " t-498-" ;
	   MODE       =  "ADDRESS MODE" ;

	   TASK_SCAN_BITS(NUMBER_OF_SCAN_BITS,ADDRESS) ;
	end
      // do test if dummy cycles are needed
      if (NUMBER_OF_DUMMY_CYCLES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-505- TASK_GENERIC3->TASK_DUMMY") ;
	   Line_num   =  " t-506-" ;
	   MODE       =  "DUMMY MODE" ;

	   TASK_DUMMY(NUMBER_OF_DUMMY_CYCLES) ;
	end

      // do test if write cycles are needed
      if (NUMBER_OF_WRITE_BYTES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-514- TASK_GENERIC3->TASK_WRITE") ;
	   Line_num   =  " t-515" ;
	   MODE       =  "WRITE MODE" ;

	   TASK_WRITE(NUMBER_OF_WRITE_BYTES) ;
	end

      // do test if read cycles are needed
      if (NUMBER_OF_READ_BYTES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-523- TASK_GENERIC3->TASK_READ") ;
	   Line_num   =  " t-524" ;
	   MODE       =  "READ MODE" ;

	   TASK_READ(NUMBER_OF_READ_BYTES) ;
	end
      if (debug_4 == 1) $display ($time," t-528- TASK_GENERIC3->END") ;
      Operation3 =  1'bx ;
      @(negedge SCLK) CS =  1 ;
      task_monitor("TASK_GENERIC3",0);
   end

endtask // TASK_GENERIC3
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******

// **START****START****START****START****START****START****START****START****START****START****START**
task TASK_SCAN_BITS ;
   input   NUMBER_OF_SCAN_BITS ;
   input [567:0] ADDRESS ;

   integer 	 NUMBER_OF_SCAN_BITS ;

   begin :initial_begin
      task_monitor("TASK_SCAN_ADDRESS",1);
      Line_num   =  " t-778" ;
      Operation4 =  " t-779 TASK_SCAN_ADDRESS" ;
      if (debug_1 == 1) $display ($time," t-780- TASK_SCAN_ADDRESS") ;
      if (NUMBER_OF_SCAN_BITS != 0)
	begin: address_mode
	   Line_num   =  " t-783" ;
	   Line_num   =  " t-785" ;
	   MODE       =  " t-786- SPI ADDRESS" ;
	   TASK_SPI_SCAN(NUMBER_OF_SCAN_BITS,ADDRESS);
	end             // : address_mode
      else
	begin: No_address
	   Line_num   =  " t-791" ;
	   Status     =  "No Address Operation" ;
	end             // : No_address
      if (debug_5 == 1) $display ($time," t-794- TASK_ADDRESS -> end") ;
      Operation4 =  1'bx ;
      Status     =  1'bx ;
      task_monitor("TASK_SCAN_ADDRESS",0);
   end     // end initial_begin
endtask // TASK_SCAN_ADDRESS
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******

// **START****START****START****START****START****START****START****START****START****START****START**
task TASK_SPI_SCAN ;
   input   NUMBER_OF_SCAN_BITS ;
   input [567:0] ADDRESS ;
   integer 	 NUMBER_OF_SCAN_BITS ;

   begin :initial_begin
      task_monitor("TASK_SPI_SCAN",1);
      Line_num   =  " t-820" ;
      Operation5 =  " t-821 TASK_SPI_SCAN" ;
      if (debug_1 == 1) $display ($time," t-822- TASK_SPI_SCAN -> begin") ;
      WINDOW     =  1'bx ;
      // setup BIDI's
      SI_en      =  1 ;       // drive SI_en high to allow TB
      SO_en      =  0 ;       // drive SO_en_low to allow chip  
      for (index_scan_bits     =  0 ; index_scan_bits < (NUMBER_OF_SCAN_BITS ) ; index_scan_bits =  index_scan_bits + 1) begin :address_loop // max is 24
	 // $display ($time," t-835 TASK_SPI_ADDRESS-> i = %h ", i, "NUMBER_OF_ADDRESS_BITS = %h ", NUMBER_OF_ADDRESS_BITS, "ADDRESS = %h ", ADDRESS ) ;
	 if (debug_6 == 1) $display ($time," t-836- TASK_SPI_SCAN_loop") ;
	 @(negedge SCLK) //_last operation completed
	   # tDH ;         // hold expires, set ca to X
	 #((tCK/2)-(tDSU+tDH)) ; // calculates when valid data window opens
	 Status =  " t-840- write ADDRESS - rising edge" ;
	 SI_out =  ADDRESS[(NUMBER_OF_SCAN_BITS - 1) - index_scan_bits] ;   // MSB ->_lSB order
	 WINDOW =  1'b1 ;
	 @(posedge SCLK)
	   # tDH ; // hold expires, CMD invalid
         // end capture_data_rising_edge
	 //gdg WP change   SI_out =  1'bx ;
	 WINDOW =  1'bx ;
      end             // end address_loop
      Status =  1'bx ;
      if (debug_6 == 1) $display ($time," t-850- TASK_SPI_SCAN -> end") ;
      Operation5 =  1'bx ;
      task_monitor("TASK_SPI_SCAN",0);
   end     // end initial_begin
endtask // TASK_SPI_ADDRESS
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******

// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_SCE
// TAKES NO ARGUMENTS
// works in Either SPI  modes
// mac cycle
task TASK_SCE ;
   input   NUMBER_OF_READ_BYTES ;  // number of bytes to read in each CS low interval     
   integer NUMBER_OF_READ_BYTES ;
   
   input [159:0] MAC;
   input [3:0] 	 WHDATA;
   input [7:0] 	 LB_IN;
   input [3:0] 	 SAAD;  
   input [15:0]  ADDR;
   input 	 READ;
   input 	 WRITE;
   input 	 BIAS_SEL;
   input [7:0] 	 CMD;
   input [63:0]  TM;
   input [300:0] X;

   reg [467:0] 	 ADDRESS;
   begin :initial_begin
      assign ADDRESS = {MAC,WHDATA,LB_IN,SAAD,ADDR,READ,WRITE,BIAS_SEL,CMD,TM,X};      
      task_monitor("TASK_SCE",1);
      if (debug_1 == 1) $display ("ENTER", $time," t-2501- TASK_SCE ") ;
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_0 == 1) $display ($time," t-2503 TASK_SCE ") ;
      Operation      =  (" t-2504 TASK_MACCYC " )      ;
      if (debug_2 == 1) $display ($time," t-2505 TASK_SCE --> TASK_GENERIC3 - 57 - SCE") ;
      // TASK_GENERIC3 (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC3 (8'h57, 567, ADDRESS, 0,NUMBER_OF_READ_BYTES, NUMBER_OF_READ_BYTES) ;    // MACCYC
      #(tRES1 * (1_000 / speedup_us)) ;
      // ************************
      Operation      =  1'bx ;
      //  Operation2    =  1'bx ;
      // ************************
      task_monitor("TASK_SCE",0);
   end
endtask // TASK_SCE
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
task TASK_GENERIC4 ;
   input   [7:0] CMD ;     // pass command code
   input 	 NUMBER_OF_SCANAF_BITS ;
   input 	 NUMBER_OF_SCAN_BITS ;
   input [4095:0] ADDRESS1 ;
   input [4095:0] ADDRESS2 ;
   input [4095:0] ADDRESS3 ;
   input [4095:0] ADDRESS4 ;
   input [573:0]  ADDRESS5 ;
   

   input 	  NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer
   input 	  NUMBER_OF_WRITE_BYTES ;
   input 	  NUMBER_OF_READ_BYTES ;

   integer 	  NUMBER_OF_SCANAF_BITS ;   
   integer 	  NUMBER_OF_SCAN_BITS ;
   integer 	  NUMBER_OF_DUMMY_CYCLES ;        // externally defined integer
   integer 	  NUMBER_OF_WRITE_BYTES ;
   integer 	  NUMBER_OF_READ_BYTES ;
   begin :initial_begin
      task_monitor("TASK_GENERIC4",1);
      $fwrite(task_sequence, "                     CMD='h%h, NoAB='h%h,ADDR='h%h,  NoDC='h%h, NoWB='h%h, NoRB='h%h\n"
	      , CMD,NUMBER_OF_SCANAF_BITS,NUMBER_OF_SCAN_BITS,ADDRESS1,ADDRESS2,ADDRESS3,ADDRESS4, NUMBER_OF_DUMMY_CYCLES, NUMBER_OF_WRITE_BYTES, NUMBER_OF_READ_BYTES);
      Line_num       =  " t-484" ;
      Operation3     =  " t-485 TASK_GENERIC4" ;
      if (debug_1 == 1) $display ($time," t-487- TASK_GENERIC4 ") ;
      if (debug_4 == 1) $display ($time," t-488- TASK_GENERIC4-> NUMBER_OF_SCANAF_BITS = %d ", NUMBER_OF_SCAN_BITS ) ;
      if (debug_4 == 1) $display ($time," t-488- TASK_GENERIC4-> NUMBER_OF_SCAN_BITS = %d ", NUMBER_OF_SCAN_BITS ) ;
      if (debug_4 == 1) $display ($time," t-489- TASK_GENERIC4-> ADDRESS1 = %h ", ADDRESS1 ) ;
      if (debug_4 == 1) $display ($time," t-489- TASK_GENERIC4-> ADDRESS2 = %h ", ADDRESS2 ) ;
      if (debug_4 == 1) $display ($time," t-489- TASK_GENERIC4-> ADDRESS3 = %h ", ADDRESS3 ) ;
      if (debug_4 == 1) $display ($time," t-489- TASK_GENERIC4-> ADDRESS4 = %h ", ADDRESS4 ) ;  
      if (debug_4 == 1) $display ($time," t-489- TASK_GENERIC4-> ADDRESS5 = %h ", ADDRESS5 ) ;  
      //  if (debug_4 == 1) $display ($time," t-489- TASK_GENERIC4-> ADDRESS4 = %h ", ADDRESS4 ) ;
      if (debug_4 == 1) $display ($time," t-490- TASK_GENERIC4-> NUMBER_OF_DUMMY_CYCLES = %d ", NUMBER_OF_DUMMY_CYCLES ) ;
      if (debug_4 == 1) $display ($time," t-491- TASK_GENERIC4-> NUMBER_OF_WRITE_BYTES = %d ", NUMBER_OF_WRITE_BYTES ) ;
      if (debug_4 == 1) $display ($time," t-492- TASK_GENERIC4-> NUMBER_OF_READ_BYTES = %d ", NUMBER_OF_READ_BYTES ) ;

      TASK_CMD(CMD) ;
      // do test if address cycles are needed
      if (NUMBER_OF_SCANAF_BITS != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-497- TASK_GENERIC4->TASK_ADDRESS") ;
	   Line_num   =  " t-498-" ;
	   
	   MODE       =  "ADDRESS MODE" ;
	   TASK_SCANAF_BITS(NUMBER_OF_SCANAF_BITS,ADDRESS1) ;
	end

      
      // do test if dummy cycles are needed
      if (NUMBER_OF_SCAN_BITS != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-497- TASK_GENERIC4->TASK_ADDRESS") ;
	   Line_num   =  " t-498-" ;
	   MODE       =  "ADDRESS MODE" ;
	   TASK_SCANAF_BITS(NUMBER_OF_SCANAF_BITS,ADDRESS2) ;
	end
      // do test if dummy cycles are needed
      

      if (NUMBER_OF_SCAN_BITS != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-497- TASK_GENERIC4->TASK_ADDRESS") ;
	   Line_num   =  " t-498-" ;
	   MODE       =  "ADDRESS MODE" ;
           TASK_SCANAF_BITS(NUMBER_OF_SCANAF_BITS,ADDRESS3) ;
	end


      if (NUMBER_OF_SCAN_BITS != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-497- TASK_GENERIC4->TASK_ADDRESS") ;
	   Line_num   =  " t-498-" ;
	   MODE       =  "ADDRESS MODE" ;
           TASK_SCANAF_BITS(NUMBER_OF_SCANAF_BITS,ADDRESS4) ;
	end

      if (NUMBER_OF_SCAN_BITS != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-497- TASK_GENERIC4->TASK_ADDRESS") ;
	   Line_num   =  " t-498-" ;
	   MODE       =  "ADDRESS MODE" ;
           TASK_SCAN_BITS1(NUMBER_OF_SCAN_BITS,ADDRESS5) ;
	end
      
      // do test if dummy cycles are needed
      if (NUMBER_OF_DUMMY_CYCLES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-505- TASK_GENERIC3->TASK_DUMMY") ;
	   Line_num   =  " t-506-" ;
	   MODE       =  "DUMMY MODE" ;     
	   TASK_DUMMY(NUMBER_OF_DUMMY_CYCLES) ;
	end

      // do test if write cycles are needed
      if (NUMBER_OF_WRITE_BYTES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-514- TASK_GENERIC4->TASK_WRITE") ;
	   Line_num   =  " t-515" ;
	   MODE       =  "WRITE MODE" ;

	   TASK_WRITE(NUMBER_OF_WRITE_BYTES) ;
	end

      // do test if read cycles are needed
      if (NUMBER_OF_READ_BYTES != 0)
	begin
	   if (debug_4 == 1) $display ($time," t-523- TASK_GENERIC4->TASK_READ") ;
	   Line_num   =  " t-524" ;
	   MODE       =  "READ MODE" ;

	   TASK_READ(NUMBER_OF_READ_BYTES) ;
	end
      if (debug_4 == 1) $display ($time," t-528- TASK_GENERIC4->END") ;
      Operation3 =  1'bx ;
      @(negedge SCLK) CS =  1 ;
      task_monitor("TASK_GENERIC4",0);
   end
endtask 
// TASK_GENERIC4
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
task TASK_SCANAF_BITS ;
   input   NUMBER_OF_SCAN_BITS ;
   //input   [467:0] ADDRESS ;
   input [4095:0] ADDRESS;
   integer 	  NUMBER_OF_SCAN_BITS ;

   begin :initial_begin
      task_monitor("TASK_SCANAF_BITS",1);
      Line_num   =  " t-778" ;
      Operation4 =  " t-779 TASK_SCANAF_BITS" ;
      if (debug_1 == 1) $display ($time," t-780- TASK_SCANAF_BITS") ;
      if (NUMBER_OF_SCAN_BITS != 0)
	begin: address_mode
	   Line_num   =  " t-783" ;
	   Line_num   =  " t-785" ;
	   MODE       =  " t-786- SPI ADDRESS" ;
	   TASK_SPI_SCANAF(NUMBER_OF_SCAN_BITS,ADDRESS);     
	end             // : address_mode
      else
	begin: No_address
	   Line_num   =  " t-791" ;
	   Status     =  "No Address Operation" ;
	end             // : No_address
      if (debug_5 == 1) $display ($time," t-794- TASK_ADDRESS -> end") ;
      Operation4 =  1'bx ;
      Status     =  1'bx ;
      task_monitor("TASK_SCANAF_BITS",0);
   end     // end initial_begin
endtask // TASK_SCANAF_BITS
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
task TASK_SCAN_BITS1 ;
   input   NUMBER_OF_SCAN_BITS ;
   input [574:0] ADDRESS ;
   integer 	 NUMBER_OF_SCAN_BITS ;

   begin :initial_begin
      task_monitor("TASK_SCANAF_BITS",1);
      Line_num   =  " t-778" ;
      Operation4 =  " t-779 TASK_SCANAF_BITS" ;
      if (debug_1 == 1) $display ($time," t-780- TASK_SCANAF_BITS") ;
      if (NUMBER_OF_SCAN_BITS != 0)
	begin: address_mode
	   Line_num   =  " t-783" ;
	   Line_num   =  " t-785" ;
	   MODE       =  " t-786- SPI ADDRESS" ;
	   TASK_SPI_SCAN1(NUMBER_OF_SCAN_BITS,ADDRESS);     
	end             // : address_mode
      else
	begin: No_address
	   Line_num   =  " t-791" ;
	   Status     =  "No Address Operation" ;
	end             // : No_address
      if (debug_5 == 1) $display ($time," t-794- TASK_ADDRESS -> end") ;
      Operation4 =  1'bx ;
      Status     =  1'bx ;
      task_monitor("TASK_SCANAF_BITS",0);
   end     // end initial_begin
endtask // TASK_SCANAF_BITS1
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
task TASK_SPI_SCANAF ;
   input   NUMBER_OF_SCANAF_BITS ;
   input [4095:0] ADDRESS;
   integer 	  NUMBER_OF_SCANAF_BITS ;

   begin :initial_begin
      task_monitor("TASK_SPI_SCANAF",1);
      Line_num   =  " t-820" ;
      Operation5 =  " t-821 TASK_SPI_SCANAF" ;
      if (debug_1 == 1) $display ($time," t-822- TASK_SPI_SCANAF -> begin") ;
      WINDOW     =  1'bx ;
      // setup BIDI's
      SI_en      =  1 ;       // drive SI_en high to allow TB
      SO_en      =  0 ;       // drive SO_en_low to allow chip 
      
      for (index_scan_bits     =  0 ; index_scan_bits < (NUMBER_OF_SCANAF_BITS) ; index_scan_bits =  index_scan_bits + 1) begin :address_loop //
	 if (debug_6 == 1) $display ($time," t-836- TASK_SPI_SCAN_loop") ;
	 @(negedge SCLK) //_last operation completed
	   # tDH ;         // hold expires, set ca to X
	 #((tCK/2)-(tDSU+tDH)) ; // calculates when valid data window opens
	 Status =  " t-840- write ADDRESS - rising edge" ;
	 SI_out =  ADDRESS[(NUMBER_OF_SCANAF_BITS - 1) - index_scan_bits] ;   // MSB ->_lSB order
	 WINDOW =  1'b1 ;
	 @(posedge SCLK)
	   # tDH ; // hold expires, CMD invalid            
	 WINDOW =  1'bx ;
      end             // end address_loop

      Status =  1'bx ;
      if (debug_6 == 1) $display ($time," t-850- TASK_SPI_SCAN -> end") ;
      Operation5 =  1'bx ;
      task_monitor("TASK_SPI_SCAN",0);
   end     // end initial_begin
endtask // TASK_SPI_SCANAF
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
task TASK_SPI_SCAN1 ;
   input   NUMBER_OF_SCANAF_BITS ;
   input [574:0] ADDRESS;
   integer 	 NUMBER_OF_SCANAF_BITS ;

   begin :initial_begin
      task_monitor("TASK_SPI_SCANAF",1);
      Line_num   =  " t-820" ;
      Operation5 =  " t-821 TASK_SPI_SCANAF" ;
      if (debug_1 == 1) $display ($time," t-822- TASK_SPI_SCANAF -> begin") ;
      WINDOW     =  1'bx ;
      // setup BIDI's
      SI_en      =  1 ;       // drive SI_en high to allow TB
      SO_en      =  0 ;       // drive SO_en_low to allow chip 
      
      for (index_scan_bits     =  0 ; index_scan_bits < (NUMBER_OF_SCANAF_BITS) ; index_scan_bits =  index_scan_bits + 1) begin :address_loop //
	 if (debug_6 == 1) $display ($time," t-836- TASK_SPI_SCAN_loop") ;
	 @(negedge SCLK) //_last operation completed
	   # tDH ;         // hold expires, set ca to X
	 #((tCK/2)-(tDSU+tDH)) ; // calculates when valid data window opens
	 Status =  " t-840- write ADDRESS - rising edge" ;
	 SI_out =  ADDRESS[(NUMBER_OF_SCANAF_BITS - 1) - index_scan_bits] ;   // MSB ->_lSB order
	 WINDOW =  1'b1 ;
	 @(posedge SCLK)
	   # tDH ; // hold expires, CMD invalid            
	 WINDOW =  1'bx ;
      end             // end address_loop

      Status =  1'bx ;
      if (debug_6 == 1) $display ($time," t-850- TASK_SPI_SCAN -> end") ;
      Operation5 =  1'bx ;
      task_monitor("TASK_SPI_SCAN1",0);
   end     // end initial_begin
endtask // TASK_SPI_SCAN1
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******




// **START****START****START****START****START****START****START****START****START****START****START**
// $0 TASK_SCEAF
// TAKES NO ARGUMENTS
// works in SPI  modes
// Scan Chain activated including AF
task TASK_SCEWAF ;
   //input   NUMBER_OF_READ_BYTES ;  // number of bytes to read in each CS low interval     
   //integer NUMBER_OF_READ_BYTES ;

   input   [4095:0] AF2;
   input [4095:0]   AF1;
   input [159:0]    MAC;
   input [3:0] 	    WHDATA;
   input [7:0] 	    LB_IN;
   input [3:0] 	    SAAD;
   input [15:0]     ADDR;
   input 	    READ;
   input 	    WRITE;
   input 	    BIAS_SEL;
   input [7:0] 	    CMD;
   input [63:0]     TM;
   
   input [3828:0]   X;
   input [4095:0]   Y;
   input [574:0]    Z;
   
   //input   NUMBER_OF_READ_BYTES ;  // number of bytes to read in each CS low interval     
   //integer NUMBER_OF_READ_BYTES ;
   reg [574:0] 	    ADDRESS5;   
   reg [4095:0]     ADDRESS3;
   reg [4095:0]     ADDRESS2;
   reg [4095:0]     ADDRESS1;
   reg [4095:0]     ADDRESS4;
   


   begin :initial_begin
      assign ADDRESS4 = {Y};      
      assign ADDRESS3 = {TM,CMD,BIAS_SEL,WRITE,READ,ADDR,SAAD,LB_IN,WHDATA,MAC,X};   
      assign ADDRESS2 = {AF1};   
      assign ADDRESS1 = {AF2};   
      assign ADDRESS5 = {Z};
      
      
      task_monitor("TASK_SCEAF",1);
      if (debug_1 == 1) $display ("ENTER", $time," t-2501- TASK_SCEAF ") ;
      //  SUCCESS = 1 ; // NO CHECK HERE
      if (debug_0 == 1) $display ($time," t-2503 TASK_SCE ") ;
      Operation      =  (" t-2504 TASK_MACCYC " )      ;
      if (debug_2 == 1) $display ($time," t-2505 TASK_SCE --> TASK_GENERIC3 - 57 - SCE") ;
      // TASK_GENERIC4 (CMD,NUMBER_OF_ADDRESS_BITS,ADDRESS1,ADDRESS2,ADDRESS3,ADDRESS4,NUMBER_OF_DUMMY_CYCLES,NUMBER_OF_WRITE_BYTES,NUMBER_OF_READ_BYTES)
      TASK_GENERIC4 (8'h58, 4096, 574, ADDRESS1, ADDRESS2, ADDRESS3, ADDRESS4, ADDRESS5, 0,0,0) ;    // MACCYC
      #(tRES1 * (1_000 / speedup_us)) ;
      // ************************
      Operation      =  1'bx ;
      //  Operation2    =  1'bx ;
      // ************************
      task_monitor("TASK_SCEWAF",0);
   end
endtask // TASK_SCEAF
// **FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******FINISHED******

endmodule
