`include "./banners/+runP_start.vh"
`include "./banners/+test1.vh"
TASK_RSTEN;
TASK_RST;
TASK_INIT_WRITE_PI;
TASK_LBWR(16'h0000);
TASK_LBWR(16'h0001);
TASK_LBWR(16'h0002);
TASK_LBWR(16'h0003);
TASK_PP(16'h0000,4);
TASK_PP(16'h0001,4);
TASK_PP(16'h0002,4);
TASK_PP(16'h0003,4);
TASK_PP(16'h0004,4);
TASK_PP(16'h0005,4);
TASK_PP(16'h0006,4);
TASK_PP(16'h0007,4);
TASK_PP(16'h0008,4);
TASK_PP(16'h0009,4);
TASK_PP(16'h000A,4);
TASK_PP(16'h000B,4);
TASK_PP(16'h000C,4);
TASK_PP(16'h000D,4);
TASK_PP(16'h000E,4);
TASK_PP(16'h000F,4);
TASK_PP(16'h0010,4);
TASK_PP(16'h0011,4);
TASK_PP(16'h0012,4);
TASK_PP(16'h0013,4);
TASK_PP(16'h0014,4);
TASK_PP(16'h0015,4);
TASK_PP(16'h0016,4);
TASK_PP(16'h0017,4);
TASK_PP(16'h0018,4);
TASK_PP(16'h0019,4);
TASK_PP(16'h001A,4);
TASK_PP(16'h001B,4);
TASK_PP(16'h001C,4);
TASK_PP(16'h001D,4);
TASK_MACCYC(0,32'h00000000);
TASK_MACCYC(0,32'h00010001);
TASK_MACCYC(0,32'h00020002);
TASK_MACCYC(0,32'h00030003);
TASK_BIASBUF(2,16'h0004);
TASK_NEURONACT(32'h00010200);
TASK_NEURONACT(32'h00020201);
TASK_NEURONACT(32'h00030202);
TASK_NEURONACT(32'h00040203);
TASK_MACCYC(0,32'h00060200);
TASK_MACCYC(0,32'h00070201);
TASK_MACCYC(0,32'h00080202);
TASK_MACCYC(0,32'h00090203);
TASK_BIASBUF(2,16'h000A);
TASK_NEURONACT(32'h00010000);
TASK_NEURONACT(32'h00020001);
TASK_NEURONACT(32'h00030002);
TASK_NEURONACT(32'h00040003);
TASK_MACCYC(0,32'h000C0200);
TASK_MACCYC(0,32'h000D0201);
TASK_MACCYC(0,32'h000E0202);
TASK_MACCYC(0,32'h000F0203);
TASK_BIASBUF(2,16'h0010);
TASK_NEURONACT(32'h00010004);
TASK_MACCYC(0,32'h00120000);
TASK_MACCYC(0,32'h00130001);
TASK_MACCYC(0,32'h00140002);
TASK_MACCYC(0,32'h00150003);
TASK_MACCYC(0,32'h00160004);
TASK_BIASBUF(2,16'h0017);
TASK_NEURONACT(32'h00010200);
TASK_NEURONACT(32'h00020201);
TASK_NEURONACT(32'h00030202);
TASK_MACCYC(0,32'h00190200);
TASK_MACCYC(0,32'h001A0201);
TASK_MACCYC(0,32'h001B0202);
TASK_BIASBUF(2,16'h001C);
TASK_NEURONACT(32'h00010000);
TASK_NEURONACT(32'h00020001);
