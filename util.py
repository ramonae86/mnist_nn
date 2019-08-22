import RPi.GPIO as GPIO
import time
import os


SI = 4
ACLK = 17
BCLK = 27
CCLK = 22
LB_ACLK = 23
LB_BCLK = 24
CSN = 18
MODE_SEL = 12
SO = 20

GPIO.setmode(GPIO.BCM)
GPIO.setup(SO, GPIO.IN)
GPIO.setup(SI, GPIO.OUT)
GPIO.setup(ACLK, GPIO.OUT)
GPIO.setup(BCLK, GPIO.OUT)
GPIO.setup(CCLK, GPIO.OUT)
GPIO.setup(LB_ACLK, GPIO.OUT)
GPIO.setup(LB_BCLK, GPIO.OUT)
GPIO.setup(CSN, GPIO.OUT)
GPIO.setup(MODE_SEL, GPIO.OUT)

por_cmd = '11110000'
reset_mul_cmd = '01100000'
latch_acc_cmd = '10100000'
reset_acc_cmd = '00100000'
loadtm_cmd = '11000000'
write_cmd = '01000000'
read_cmd = '10000000'
nop_cmd = '00000000'
lbread_cmd = '11100000'
lbwrite_cmd = '00010000'
pd_act_cmd = '01000000'
latch_mul_cmd = '01010000'
bias_clk0_cmd = '11010000'
bias_clk1_cmd = '00110000'
bias_clk2_cmd = '10110000'
bias_clk3_cmd = '01110000'


class scan_chain():
    def __init__(self, MACBUS_EN = '0', PRGM_AF = '0', LB_INP_SEL = '1', TM_MACSEL = '00', LB_ACT = '0', LB_BUFSEL = '0', SCAN = '0', DIGMON='00000', NC='000', CMD='00000000', BIAS_SEL='0', WRITE='0', READ='0', WA='0000000001', BA='000000', SAAD='0000', LB_IN='00000000', WHDATA='0000'):
        self.MACBUS_EN = MACBUS_EN
        self.PRGM_AF = PRGM_AF
        self.LB_INP_SEL = LB_INP_SEL
        self.TM_MACSEL = TM_MACSEL
        self.LB_ACT = LB_ACT
        self.LB_BUFSEL = LB_BUFSEL
        self.SCAN = SCAN
        self.DIGMON = DIGMON
        self.NC = NC
        self.CMD = CMD
        self.BIAS_SEL = BIAS_SEL
        self.WRITE = WRITE
        self.READ = READ
        self.WA = WA
        self.BA = BA
        self.SAAD = SAAD
        self.LB_IN = LB_IN
        self.WHDATA = WHDATA


    def update_scan_chain(self, name_value_pairs):
        for item in name_value_pairs:
            if item[0] == 'MACBUS_EN':
                self.MACBUS_EN = item[1]
                continue
            if item[0] == 'PRGM_AF':
                self.PRGM_AF = item[1]
                continue
            if item[0] == 'LB_INP_SEL':
                self.LB_INP_SEL = item[1]
                continue
            if item[0] == 'TM_MACSEL':
                self.TM_MACSEL = item[1]
                continue
            if item[0] == 'LB_ACT':
                self.LB_ACT = item[1]
                continue
            if item[0] == 'LB_BUFSEL':
                self.LB_BUFSEL = item[1]
                continue
            if item[0] == 'SCAN':
                self.SCAN = item[1]
                continue
            if item[0] == 'DIGMON':
                self.DIGMON = item[1]
                continue
            if item[0] == 'NC':
                self.NC = item[1]
                continue
            if item[0] == 'CMD':
                self.CMD = item[1]
                continue
            if item[0] == 'BIAS_SEL':
                self.BIAS_SEL = item[1]
                continue
            if item[0] == 'WRITE':
                self.WRITE = item[1]
                continue
            if item[0] == 'READ':
                self.READ = item[1]
                continue
            if item[0] == 'WA':
                self.WA = item[1]
                continue
            if item[0] == 'BA':
                self.BA = item[1]
                continue
            if item[0] == 'SAAD':
                self.SAAD = item[1]
                continue
            if item[0] == 'LB_IN':
                self.LB_IN = item[1]
                continue
            if item[0] == 'WHDATA':
                self.WHDATA = item[1]
            
        return self.get_sc()


    def get_sc(self):
        return self.MACBUS_EN + self.PRGM_AF + self.LB_INP_SEL + self.TM_MACSEL + self.LB_ACT + self.LB_BUFSEL + self.SCAN + '00000000000000000000000000000000000000000000000000000000' + self.DIGMON + self.NC + self.CMD + self.BIAS_SEL + self.WRITE + self.READ + self.WA + self.BA + self.SAAD + self.LB_IN + self.WHDATA

            
def get_binary_digit(number, n):
    return number // 2**n % 2


def scan_bits(bits):
    for i in range(len(bits)):
        bit = GPIO.HIGH if bits[-(i+1)]=='1' else GPIO.LOW
        GPIO.output(SI, bit)
        # 10 ns delay
        GPIO.output(ACLK, GPIO.HIGH)
        # 10 ns delay
        GPIO.output(ACLK, GPIO.LOW)
        # 10 ns delay
        GPIO.output(BCLK, GPIO.HIGH)
        # 10 ns delay
        GPIO.output(BCLK, GPIO.LOW)
        # 10 ns delay


def write_pattern(data):
    if len(data) != 32:
        print("data written has to be 32 bits!")
        return -1

    for i in range(16):
        if data[31-i] == 1:
            d1 = '10'
        else:
            d1 = '01'

        if data[15-i] == 1:
            d2 = '10'
        else:
            d2 = '01'

        sc.update_scan_chain([('WHDATA', d2+d1), ('CMD', write_cmd)])
        scan_bits(sc.get_sc)
        GPIO.output(SI, GPIO.LOW)
        run_command(0.02)

        sc.update_scan_chain([('SAAD', increment_binary_num(sc.SAAD))])


def increment_binary_num(s):
    value = int(s, 2)
    value += 1
    return '{:04b}'.format(value)
    

def baClock(n):
    for _ in range(n):
        # 5 ns delay
        GPIO.output(LB_BCLK, GPIO.HIGH)
        # 5 ns delay
        GPIO.output(LB_BCLK, GPIO.LOW)
        # 5 ns delay
        sc.update_scan_chain([('CMD', latch_mul_cmd)])
        scan_bits(sc.get_sc())
        run_command(0.1**8)
        # 5 ns delay
        GPIO.output(LB_ACLK, GPIO.HIGH)
        # 5 ns delay
        GPIO.output(LB_ACLK, GPIO.LOW)
        

def run_command(t):
    """ set CCLK HIGH for t nano seconds"""
    GPIO.output(CCLK, GPIO.HIGH)
    time.sleep(t/10**9)
    GPIO.output(CCLK, GPIO.LOW)
    

    
sc = scan_chain()
