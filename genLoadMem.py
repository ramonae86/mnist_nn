sparseMode = 0x80000000
forceAddr = 0x08000000


def writeAR( f, addr, word, comment ):
	"""Function Description:
	Force memory array value at given address

	Arguments:
	f: target verilog file
	addr: address to write word
	word: 32 bit word data
	comment: comment describing word
	"""

	WL = addr % 1023
	BL = addr // 1023
	SA_l = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34]
	f.write( '//---- ' + comment + ' ----\n' )
	for i in range(0, 32):
		if word & 1 << i:
			V = 1
		else:
			V = 0
		f.write( '\t\tITR_INFERENCE_sim.ICOR.ITLE2.ITLE1_A.IARY4.SA1_%d_.MainMem[%d][%d] = %d;\n' % (SA_l[i], WL, BL, V))
		if not ((i+1) % 8):
			f.write( '\n' )


def writeAR10( f, addr, word, comment ):
	WL = addr % 1023
	BL = addr // 1023
	SA_l = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34]
	f.write( '//---- ' + comment + ' ----\n' )
	for i in range(0, 32):
		if word & 1 << i:
			V = 1
		else:
			V = 0
		f.write( '\t\tITR_INFERENCE_sim.ICOR.ITLE2.ITLE1_A.IARY4.SA1_%d_.MainMem[%d][%d] = %d;\n' % (SA_l[i], WL, BL, V))
		if not ((i+1) % 10):
			f.write( '\n' )


def writeLB( f, fr, fl, addr, byte, comment ):
	"""Function Description:
	write one byte data to layer buffer given address

	Arguments:
	f: target force verilog file
	fr: target release verilog file
	addr: address to write word
	byte: byte to be written to addr
	comment: comment
	"""

	A = (addr >> 0) & 0x11
	B = (addr >> 2) & 0x11
	C = (addr >> 4) & 0x11
	D = (addr >> 6) & 0x11
	E = (addr >> 8) & 0x11
	f.write( '//---- ' + comment + ' ----\n' )
	for i in range(0, 8):
		if byte & 1 << i:
			V = 1
		else:
			V = 0
		f.write('\t\tforce ITR_INFERENCE_sim.ICOR.ILAYER_BUFFER.I_X5.IA%d.IB%d.IC%d.ID%d.IE%d.DLTCH_%d_.Q = %d;\n' % (A, B, C, D, E, i, V))
		fr.write('\t\trelease ITR_INFERENCE_sim.ICOR.ILAYER_BUFFER.I_X5.IA%d.IB%d.IC%d.ID%d.IE%d.DLTCH_%d_.Q;\n' % (A, B, C, D, E, i))
	# f.write('\t\tforce ITR_INFERENCE_sim.ICOR.ILAYER_BUFFER.I_X5.IA%d.IB%d.IC%d.ID%d.IE%d.WRITE = 0;\n' % (A, B, C, D, E))
	# fl.write('\t\tforce ITR_INFERENCE_sim.ICOR.ILAYER_BUFFER.I_X5.IA%d.IB%d.IC%d.ID%d.IE%d.WRITE = 1;\n' % (A, B, C, D, E))
	# fr.write('\t\trelease ITR_INFERENCE_sim.ICOR.ILAYER_BUFFER.I_X5.IA%d.IB%d.IC%d.ID%d.IE%d.WRITE;\n' % (A, B, C, D, E))


def writeNeurons( f, fr, fl, LBstart, inpNum, inpNeu ):
	"""Function Description:
	write multiple neurons to layer buffer

	Arguments:
	f: target force verilog file
	fr: target release verilog file
	fl: ???
	LBstart: start address of continuous neurons
	inpNum: number of continuous neurons to be written
	inpNeu: list of neurons to be written
	"""

	for i in range( 0, inpNum ):
		writeLB( f, fr, fl, LBstart + i, inpNeu[i], 'input neuron #%d' %(i) )


def writeFClayer( f, ARstart, inpNum, outNum, inpWeight, biasNum, inpBias, layerT, layerCont ):
	layerDesc = outNum & 0x000000FF | (inpNum & 0x000000FF) << 8 | ((biasNum - 1) & 0x00000003) << 29 | (layerCont & 0x00000001) << 28
	array_i = 0
	writeAR( f, ARstart + array_i, layerDesc, layerT + ' descriptor' )
	array_i += 1
	# Write weights & biases
	for i in range( 0, outNum ):
		for j in range( 0, inpNum ): # Weights
			word = (inpWeight[i][j][0] & 0x000000FF) << 0 | (inpWeight[i][j][1] & 0x000000FF) << 8 | (inpWeight[i][j][2] & 0x000000FF) << 16 |(inpWeight[i][j][3] & 0x000000FF) << 24
			writeAR( f, ARstart + array_i, word, layerT + ' input neuron #%d weight for output neuron #%d' % (j,i) )
			array_i += 1
		for j in range( 0, biasNum ): # Biases
			word = 0
			for k in range( 0, 4 ):
				word |= ((inpBias[i][k] >> (j*8)) & 0x000000FF) << (k*8)
			writeAR( f, ARstart + array_i, word, layerT + ' output neuron #%d bias byte #%d' % (i,j) )
			array_i += 1
	return ARstart + array_i


def writeSlayer( f, ARstart, outNum, inpConn, biasNum, inpBias, layerT, layerCont ):
	layerDesc = outNum & 0x000000FF | ((biasNum - 1) & 0x00000003) << 29 | sparseMode | (layerCont & 0x00000001) << 28
	array_i = 0
	writeAR( f, ARstart + array_i, layerDesc, layerT + ' descriptor' )
	array_i += 1
	# Write weights & biases
	for i in range( 0, outNum ):
		numC = len(inpConn[i])
		remaining = numC
		fullC = int(numC/3)
		if numC % 3 == 0:
			fullC -= 1
		for j in range( 0, fullC ):
			word = 3 << 30
			for k in range( 0, 3 ):
				word |= inpConn[i][(3*j)+k][0] << k * 10
			writeAR10( f, ARstart + array_i, word, layerT + ' output neuron #%d descriptor #%d with 3 connections + continue' % (i,j) )
			array_i += 1
			for k in range( 0, 3 ):
				word = 0
				for l in range( 0, 4 ):
					word |= (inpConn[i][(3*j)+k][1][l] & 0x000000FF) << (l*8)
				writeAR( f, ARstart + array_i, word, layerT + ' output neuron #%d weights for connection #%d' % (i,(3*j)+k) )
				array_i += 1
			remaining -= 3
		if remaining:
			word = remaining - 1 << 30
			for k in range( 0, remaining ):
				word |= inpConn[i][(3*fullC)+k][0] << k * 10
			writeAR10( f, ARstart + array_i, word, layerT + ' output neuron #%d descriptor #%d with %d connections' % (i,fullC + 1,remaining) )
			array_i += 1
			for k in range( 0, remaining ):
				word = 0
				for l in range( 0, 4 ):
					word |= (inpConn[i][(3*fullC)+k][1][l] & 0x000000FF) << (l*8)
				writeAR( f, ARstart + array_i, word, layerT + ' output neuron #%d weights for connection #%d' % (i,(3*fullC)+k) )
				array_i += 1
		for j in range( 0, biasNum ): #Biases
			word = 0
			for k in range( 0, 4 ):
				word |= ((inpBias[i][k] >> (j*8)) & 0x000000FF) << (k*8)
			writeAR( f, ARstart + array_i, word, layerT + ' output neuron #%d bias byte #%d' % (i,j) )
			array_i += 1
	return ARstart + array_i
	

def writeRecursive( f, ARstart, ARoffset, inpNum, outNum, biasNum, layerMode, layerT, layerCont ):
	layerDesc = outNum & 0x000000FF | (inpNum & 0x000000FF) << 8 | (ARoffset & 0x000003FF) << 16 | ((biasNum - 1) & 0x00000003) << 29 | (layerCont & 0x00000001) << 28 | (layerMode & 0x00000001) << 31 | forceAddr
	writeAR( f, ARstart, layerDesc, layerT + ' descriptor' )
	return ARstart + 1

f = open( 'mem.v', 'w' )
fl = open( 'memlatch.v', 'w' )
fr = open( 'memrelease.v', 'w' )
f.write( 'task loadmem;\n' )
f.write( '\tbegin\n' )
fl.write( 'task latchmem;\n' )
fl.write( '\tbegin\n' )
fr.write( 'task releasemem;\n' )
fr.write( '\tbegin\n' )

inputs = [8, 102, 67, 207]
weights = [
	[ #OUTPUT NEURON 1
	[3,	10,	100,	61],
	[11,	40,	45,	1],
	[240,	72,	19,	84],
	[35,	0,	91,	22]],
	[ #OUTPUT NEURON 2
	[35,	0,	91,	22],
	[3,	10,	100,	61],
	[11,	40,	45,	1],
	[240,	72,	19,	84]],
	[ #OUTPUT NEURON 3
	[15,	0,	91,	22],
	[31,	10,	101,	61],
	[11,	41,	15,	111],
	[210,	71,	19,	84]]
]
biases = [
	[32, 4, 2, 1], #ON1
	[0, 0, 0, 0], #ON2
	[0, 0, 0, 0]  #ON3
]
connections = [
	[ #OUTPUT NEURON 1
	[ 0, [45, 16, 156, 32]	],
	[ 2, [254, 0, 254, 0]	],
	[ 5, [45, 16, 156, 32]	]],
	[ #OUTPUT NEURON 2
	[ 0, [45, 16, 156, 32]	],
	[ 1, [254, 0, 254, 0]	],
	[ 3, [45, 16, 156, 32]	],
	[ 4, [45, 16, 156, 32]	],
	[ 6, [254, 0, 254, 0]	],
	[ 7, [45, 16, 156, 32]	]]
]
writeNeurons( f, fr, fl, 0, len(inputs), inputs )
SARstart = writeFClayer( f, 0, len(inputs), 3, weights, 1, biases, 'LAYER 1', 1 )
RECstart = writeSlayer( f, SARstart, 2, connections, 1, biases, 'LAYER 2', 1 )
SARstart2 = writeRecursive( f, RECstart, 1, 4, 3, 1, 0, 'LAYER 1 RECURSIVE', 1 )
writeSlayer( f, SARstart2, 2, connections, 1, biases, 'LAYER 2 copy', 0 )

f.write( '\tend\n' )
f.write( 'endtask\n' )
fl.write( '\tend\n' )
fl.write( 'endtask\n' )
fr.write( '\tend\n' )
fr.write( 'endtask\n' )
f.close()
fl.close()
fr.close()
