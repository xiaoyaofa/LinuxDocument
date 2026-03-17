#!/bin/sh

reset_pin := 139
en_pin := 143

BUS=$1
#video_timing=1366x768_60
#video_timing=1920x1080_60
#video_timing=540x960_60
#video_timing=1920x1080_50
# video_timing=1024x600_60
video_timing=1280x800_60
function RESET_Lt8912chip()
{
#gpioset gpiochip4 9=0
echo $reset_pin > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio$reset_pin/direction
echo 0 > /sys/class/gpio/gpio$reset_pin/value
sleep 0.2
#gpioset gpiochip4 9=1
echo 1 > /sys/class/gpio/gpio$reset_pin/value
echo $reset_pin > /sys/class/gpio/unexport
}

function ENABLE_Lt8912chip()
{
echo $en_pin > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio$en_pin/direction
echo 1 > /sys/class/gpio/gpio$en_pin/value
sleep 0.2
}

function decimalism_to_Hexadecimal(){                                                                
        if [ $# != 1 ];then                                                                           
                echo "parameter nums error"                                                          
                return                                                                    
        fi                                                                                            
        val=$(echo "obase=16;$1" |bc)                                                                
        echo "0x$val"                                                                             
} 

function HDMI_WriteI2C_Byte()
{
  echo -n "WR:" $1 $2 $3 $4 "> " && i2cset -f -y -r $1 $2 $3 $4
}

#dmesg | grep "lane_mbps"
#modetest | grep "preferred"
#echo ""

#echo -n "0x39-00: " && i2cget -f -y  1 0x39 0
#echo -n "0x39-01: " && i2cget -f -y  1 0x39 1

echo "================ RESET LT8912 ==================="


# HDMI_WriteI2C_Byte  BUS ADDESS OFFSET VALUE
# HDMI_WriteI2C_Byte $BUS 0x48 0x08 0xff
function LT9611_Chip_ID(){
#LT9611_Chip_ID();

	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x80
	HDMI_WriteI2C_Byte $BUS 0x39 0xee 0x01

	echo -n "0x39-00: " && i2cget -f -y  $BUS 0x39 0
	echo -n "0x39-01: " && i2cget -f -y  $BUS 0x39 1
	echo -n "0x39-01: " && i2cget -f -y  $BUS 0x39 2

	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x81
	HDMI_WriteI2C_Byte $BUS 0x39 0x01 0x18 #//sel xtal clock
	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x80
#LT9611_Chip_ID() end
}


function LT9611_System_Init(){
#LT9611_System_Init
	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x82
	HDMI_WriteI2C_Byte $BUS 0x39 0x51 0x11
	#Timer for Frequency meter
	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x82
	HDMI_WriteI2C_Byte $BUS 0x39 0x1b 0x69
	HDMI_WriteI2C_Byte $BUS 0x39 0x1c 0x78
	HDMI_WriteI2C_Byte $BUS 0x39 0xcb 0x69
	HDMI_WriteI2C_Byte $BUS 0x39 0xcc 0x78

	#power consumption for work
	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x80
	HDMI_WriteI2C_Byte $BUS 0x39 0x04 0xf0
	HDMI_WriteI2C_Byte $BUS 0x39 0x06 0xf0
	HDMI_WriteI2C_Byte $BUS 0x39 0x0a 0x80
	HDMI_WriteI2C_Byte $BUS 0x39 0x0b 0x46
	HDMI_WriteI2C_Byte $BUS 0x39 0x0d 0xef
	HDMI_WriteI2C_Byte $BUS 0x39 0x11 0xfa
#LT9611_System_Init end

}

# LT9611_RST_PD_Init(void)
#	/* power consumption for standby */
#	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x81
#	HDMI_WriteI2C_Byte $BUS 0x39 0x02 0x48
#	HDMI_WriteI2C_Byte $BUS 0x39 0x23 0x80
#	HDMI_WriteI2C_Byte $BUS 0x39 0x30 0x00
#	HDMI_WriteI2C_Byte $BUS 0x39 0x01 0x00 # /* i2c stop work */
#LT9611_RST_PD_Init END

function LT9611_Pattern_en(){
#LT9611_Pattern_en
	
	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x82
	HDMI_WriteI2C_Byte $BUS 0x39 0x4f 0x80
	HDMI_WriteI2C_Byte $BUS 0x39 0x50 0x20

#LT9611_Pattern_en end
}


#LT9611_MIPI_Input_Analog
function LT9611_MIPI_Input_Analog(){
	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x81
	HDMI_WriteI2C_Byte $BUS 0x39 0x06 0x60
	HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x3f
	HDMI_WriteI2C_Byte $BUS 0x39 0x08 0x3f

	HDMI_WriteI2C_Byte $BUS 0x39 0x0a 0xfe
	HDMI_WriteI2C_Byte $BUS 0x39 0x0b 0xbf

	HDMI_WriteI2C_Byte $BUS 0x39 0x11 0x60
	HDMI_WriteI2C_Byte $BUS 0x39 0x12 0x3f
	HDMI_WriteI2C_Byte $BUS 0x39 0x13 0x3f
	HDMI_WriteI2C_Byte $BUS 0x39 0x15 0xfe
	HDMI_WriteI2C_Byte $BUS 0x39 0x16 0xbf

	HDMI_WriteI2C_Byte $BUS 0x39 0x1c 0x03
	HDMI_WriteI2C_Byte $BUS 0x39 0x20 0x03
}
#LT9611_MIPI_Input_Analog end


#LT9611_MIPI_Input_Digtal
function LT9611_MIPI_Input_Digtal(){
	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x82
	HDMI_WriteI2C_Byte $BUS 0x39 0x4f 0x80
	HDMI_WriteI2C_Byte $BUS 0x39 0x50 0x10

	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x83
	HDMI_WriteI2C_Byte $BUS 0x39 0x00 0x0 		# lanes
	HDMI_WriteI2C_Byte $BUS 0x39 0x02 0x0a
	HDMI_WriteI2C_Byte $BUS 0x39 0x06 0x0a
}
#LT9611_MIPI_Input_Digtal end



#lt9611_check_video_timing
#struct video_timing { 
#	hfp   hs;   hbp;   hact;   htotal;   vfp;   vs;   vbp;   vact;   vtotal; 
#	h_polarity; v_polarity; vic; aspact_ratio;  // 0=no data  1=4:3  2=16:9  3=no data. 
#	pclk_khz;      sysclk;      format;

#	16  96   48     640     800        10      2     33       480     525  
#           0              0                 1     AR_4_3  
#          25000         0           video_640x480_60Hz_vic1}   

#hfp=16
#hs=96
#hbp=48
#hact=640
#htotal=800
#vfp=10
#vs=2
#vbp=33
#vact=480
#vtotal=525
#h_polarity=0
#v_polarity=0
#vic=1
#aspact_ratio=1
#pclk_khz=25000
#sysclk=0
#format=1


#code struct video_timing video_1024x600_60Hz    ={60,60, 100,1024,  1154,  2,  5, 10, 600, 617,      1,1,0,AR_16_9,34000};
if [ $video_timing  == "1024x600_60" ]; then
hfp=60
hs=60
hbp=100
hact=1024
htotal=1154
vfp=2
vs=5
vbp=10
vact=600
vtotal=617
h_polarity=1
v_polarity=1
vic=0
aspact_ratio=2
pclk=34000
sysclk=0
format=1

	time_type=1

	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x81
	HDMI_WriteI2C_Byte $BUS 0x39 0x01 0x18 #sel xtal clock
	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x80
fi
#code struct video_timing video_540x960_60Hz      ={30, 10, 30, 540, 610,  10,  10,  10, 960, 990,      1,1,0,AR_16_9,33500};
if [ $video_timing  == "540x960_60" ]; then
hfp=30
hs=10
hbp=30
hact=540
htotal=610
vfp=10
vs=10
vbp=10
vact=960
vtotal=990
h_polarity=1
v_polarity=1
vic=0
aspact_ratio=2
pclk=33500
sysclk=0
format=1

	time_type=1

	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x81
	HDMI_WriteI2C_Byte $BUS 0x39 0x01 0x18 #sel xtal clock
	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x80
fi
#code struct video_timing video_1920x1080_60Hz   ={88, 44, 148,1920,  2200,  4,  5,  36, 1080,  1125, 1,1,16,AR_16_9,148500};
if [ $video_timing  == "1920x1080_60" ]; then
hfp=88
hs=14
hbp=148
hact=1920
htotal=2200
vfp=4
vs=5
vbp=36
vact=1080
vtotal=1125
h_polarity=1
v_polarity=1
vic=16
aspact_ratio=2
pclk=148500
sysclk=0
format=1

	time_type=1

	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x81
	HDMI_WriteI2C_Byte $BUS 0x39 0x01 0x18 #sel xtal clock
	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x80
fi
#video_1920x1080_50Hz   ={528, 44, 148,1920, 2640,  4,  5,  36, 1080, 1125, 1,1,31,AR_16_9,148500};
if [ $video_timing  == "1920x1080_50" ]; then
hfp=528
hs=44
hbp=148
hact=1920
htotal=2640
vfp=4
vs=5
vbp=36
vact=1080
vtotal=1125
h_polarity=1
v_polarity=1
vic=31
aspact_ratio=2
pclk=148500
sysclk=0
format=1

	time_type=1

	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x81
	HDMI_WriteI2C_Byte $BUS 0x39 0x01 0x18 #sel xtal clock
	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x80
fi

#code struct video_timing video_1366x768_60Hz    ={14, 56,  64,1366,  1500,  1,  3,  28, 768,  800,   1,1,0, AR_16_9,74000};
if [ $video_timing  == "1366x768_60" ]; then
hfp=14
hs=56
hbp=64
hact=1366
htotal=1500
vfp=1
vs=3
vbp=28
vact=768
vtotal=800
h_polarity=1
v_polarity=1
vic=0
aspact_ratio=2
pclk=74000
sysclk=0
format=1

	time_type=1

	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x81
	HDMI_WriteI2C_Byte $BUS 0x39 0x01 0x18 #sel xtal clock
	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x80
fi
#code struct video_timing video_1280x800_60Hz
if [ $video_timing  == "1280x800_60" ]; then
hfp=48
hs=32
hbp=80
hact=1280
htotal=1440
vfp=3
vs=6
vbp=14
vact=800
vtotal=823
h_polarity=1
v_polarity=1
vic=0
aspact_ratio=2
pclk=71000
sysclk=0
format=1

	time_type=1

	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x81
	HDMI_WriteI2C_Byte $BUS 0x39 0x01 0x18 #sel xtal clock
	HDMI_WriteI2C_Byte $BUS 0x39 0xFF 0x80
fi
##lt9611_check_video_timing end
#lt9611_check_video_timing end

function lt9611_set_pll(){
#lt9611_set_pll
	#pclk=74250
	#pclk=25000
	#post_div=0x04

	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x81
	HDMI_WriteI2C_Byte $BUS 0x39 0x23 0x40
	HDMI_WriteI2C_Byte $BUS 0x39 0x24 0x62
	HDMI_WriteI2C_Byte $BUS 0x39 0x25 0x80
	HDMI_WriteI2C_Byte $BUS 0x39 0x26 0x55
	HDMI_WriteI2C_Byte $BUS 0x39 0x2c 0x37

	HDMI_WriteI2C_Byte $BUS 0x39 0x2f 0x01
	HDMI_WriteI2C_Byte $BUS 0x39 0x27 0x66
	HDMI_WriteI2C_Byte $BUS 0x39 0x28 0x88
	HDMI_WriteI2C_Byte $BUS 0x39 0x2a 0x20
	#HDMI_WriteI2C_Byte $BUS 0x39 0x2d 0xaa  #reg_2d

	if [ $pclk -gt 150000 ];then
		HDMI_WriteI2C_Byte $BUS 0x39 0x2d 0x88
		post_div=0x01
	fi
	if [ $pclk -gt 80000 ];then
		HDMI_WriteI2C_Byte $BUS 0x39 0x2d 0x99
		post_div=0x02
	fi
	if [ $pclk -le 80000 ];then
		post_div=0x04
		HDMI_WriteI2C_Byte $BUS 0x39 0x2d 0xaa
	fi
	#post_div=0x04
	#reg_2d=0xaa
	prc_m=$((pclk*5*post_div/27000))
	echo "pcr_m = $prc_m"
	prc_m=$((prc_m-1))
	echo "prc_m -1 = $prc_m"



	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x83
	HDMI_WriteI2C_Byte $BUS 0x39 0x2d 0x40
	HDMI_WriteI2C_Byte $BUS 0x39 0x31 0x08

	HDMI_WriteI2C_Byte $BUS 0x39 0x26 $(decimalism_to_Hexadecimal $(( 0x80|pcr_m )))

	#pclk=$(decimalism_to_Hexadecimal $((pclk/2)))
	pclk=$(( pclk/2 ))
	echo pclk=$pclk
	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x82
	HDMI_WriteI2C_Byte $BUS 0x39 0xe3 $(decimalism_to_Hexadecimal $((pclk/65536)))

	pclk=$(( pclk % 65536 ))
	echo pclk=$pclk
	HDMI_WriteI2C_Byte $BUS 0x39 0xe4 $(decimalism_to_Hexadecimal $((pclk/256)))
	HDMI_WriteI2C_Byte $BUS 0x39 0xe5 $(decimalism_to_Hexadecimal $((pclk%256)))

	HDMI_WriteI2C_Byte $BUS 0x39 0xde 0x20
	HDMI_WriteI2C_Byte $BUS 0x39 0xde 0xe0
	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x80
	HDMI_WriteI2C_Byte $BUS 0x39 0x11 0x5a
	HDMI_WriteI2C_Byte $BUS 0x39 0x11 0xfa
	HDMI_WriteI2C_Byte $BUS 0x39 0x16 0xf2
	HDMI_WriteI2C_Byte $BUS 0x39 0x18 0xdc
	HDMI_WriteI2C_Byte $BUS 0x39 0x18 0xfc
	HDMI_WriteI2C_Byte $BUS 0x39 0x16 0xf3

	#pll lock status
	for (( i=0;i<6;i++))
	do
		HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x80
		HDMI_WriteI2C_Byte $BUS 0x39 0x16 0xe3
		HDMI_WriteI2C_Byte $BUS 0x39 0x16 0xf3
		HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x82

		eval $(echo -n "cal_done_flag=" && i2cget -f -y  $BUS 0x39 0xe7)
		eval $(echo -n "band_out=" && i2cget -f -y  $BUS 0x39 0xe6)
		eval $(echo -n "pll_lock_flag=" && i2cget -f -y  $BUS 0x39 0x15)
		echo "cal_done_flag = $cal_done_flag band_out=$band_out  pll_lock_flag=$pll_lock_flag"

		if [ $(( pll_lock_flag & 0x80)) -ne 0 ] && [  $((cal_done_flag & 0x80)) -ne 0 ] && [ $((band_out)) -ne 256 ];then
			echo " true"
		else
			echo "false"
			HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x80
			HDMI_WriteI2C_Byte $BUS 0x39 0x11 0x5a		#Pcr clk reset
			HDMI_WriteI2C_Byte $BUS 0x39 0x11 0xfa
			HDMI_WriteI2C_Byte $BUS 0x39 0x16 0xf2		#pll cal digital reset
			HDMI_WriteI2C_Byte $BUS 0x39 0x18 0xdc		#pll analog reset
			HDMI_WriteI2C_Byte $BUS 0x39 0x18 0xfc
			HDMI_WriteI2C_Byte $BUS 0x39 0x16 0xf3		#start calibration
		fi
	done

#lt9611_set_pll end
}


function LT9611_pattern_gcm(){
#LT9611_pattern_gcm

	#h_polarity=0
	#v_polarity=0
	POL=$(decimalism_to_Hexadecimal $((h_polarity*0x10+v_polarity*0x20)))
	echo POL=$POL
	POL=$(decimalism_to_Hexadecimal $((~POL)))
	echo POL=$POL
	POL=$(decimalism_to_Hexadecimal $((POL&0x30)))
	echo POL=$POL

	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x82
	HDMI_WriteI2C_Byte $BUS 0x39 0xa3 $(decimalism_to_Hexadecimal $(( (hs+hbp)/256 )) ) #/de_delay

	HDMI_WriteI2C_Byte $BUS 0x39 0xa4 $(decimalism_to_Hexadecimal $(( (hs+hbp)%256 )))

	HDMI_WriteI2C_Byte $BUS 0x39 0xa5 $(decimalism_to_Hexadecimal $(( (vs+vbp)%256 )) ) #//de_top
	
	HDMI_WriteI2C_Byte $BUS 0x39 0xa6 $(decimalism_to_Hexadecimal $(( hact/256 )) )

	HDMI_WriteI2C_Byte $BUS 0x39 0xa7 $(decimalism_to_Hexadecimal $(( hact%256 )) )  #//de_cnt


	HDMI_WriteI2C_Byte $BUS 0x39 0xa8 $(decimalism_to_Hexadecimal $(( vact/256 )) )


	HDMI_WriteI2C_Byte $BUS 0x39 0xa9 $(decimalism_to_Hexadecimal $((vact%256)) )  #//de_line


	HDMI_WriteI2C_Byte $BUS 0x39 0xaa $(decimalism_to_Hexadecimal $((htotal/256)) )

	HDMI_WriteI2C_Byte $BUS 0x39 0xab $(decimalism_to_Hexadecimal $((htotal%256)) )

	HDMI_WriteI2C_Byte $BUS 0x39 0xac $(decimalism_to_Hexadecimal $((vtotal/256)) )

	HDMI_WriteI2C_Byte $BUS 0x39 0xad $(decimalism_to_Hexadecimal $((vtotal%256)) )

	HDMI_WriteI2C_Byte $BUS 0x39 0xae $(decimalism_to_Hexadecimal $((hs/256)) )

	HDMI_WriteI2C_Byte $BUS 0x39 0xaf $(decimalism_to_Hexadecimal $((hs%256)) )    #//hvsa

	HDMI_WriteI2C_Byte $BUS 0x39 0xb0 $(decimalism_to_Hexadecimal $((vs%256)) )    #//v

	HDMI_WriteI2C_Byte $BUS 0x39 0x47 $(decimalism_to_Hexadecimal $(( POL|0x07 ))) //sync polarity

#LT9611_pattern_gcm_end
}


function LT9611_HDMI_TX_Digital(){
#LT9611_HDMI_TX_Digital

#lt9611_hdmi_tx

	AIF_PKT_EN=0x02
	SPD_PKT_EN=0x04
	AVI_PKT_EN=0x08
	UD1_PKT_EN=0x10
	UD0_PKT_EN=0x20

	infoFrame_en=$(( AIF_PKT_EN|AVI_PKT_EN|SPD_PKT_EN ))
	echo "infoFrame_en =$infoFrame_en"
	infoFrame_en=$(decimalism_to_Hexadecimal $infoFrame_en )
	echo "infoFrame_en =$infoFrame_en"

	#AR_4_3=0x01 AR_16_9=0x02
	AR=0x02
	pb2=$(decimalism_to_Hexadecimal $(( (AR << 4) + 0x08 )) )
	
	#video_640x480_60Hz_vic1=1
	##VIC=1
	pb4=$vic
	echo vic=$pb4
	pb0=$(decimalism_to_Hexadecimal $(( ((pb2+pb4) <=0x5f)?(0x5f-pb2-pb4):(0x15f-pb2-pb4) )) )
	echo "pb0 = $pb0"

	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x82
	#port_HDMI
	HDMI_WriteI2C_Byte $BUS 0x39 0xd6 0x8e
	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x84
	HDMI_WriteI2C_Byte $BUS 0x39 0x43 $pb0

	HDMI_WriteI2C_Byte $BUS 0x39 0x45 $pb2
	HDMI_WriteI2C_Byte $BUS 0x39 0x47 $pb4

	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x84
	HDMI_WriteI2C_Byte $BUS 0x39 0x10 0x02
	HDMI_WriteI2C_Byte $BUS 0x39 0x12 0x64

	#vic != 95
	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x84
	HDMI_WriteI2C_Byte $BUS 0x39 0x3d $infoFrame_en

	if [ $((infoFrame_en)) -ne 0 ] && [ $((SPD_PKT_EN))  -ne 0 ];then
		HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x84
		HDMI_WriteI2C_Byte $BUS 0x39 0xc0 0x83
		HDMI_WriteI2C_Byte $BUS 0x39 0xc1 0x01
		HDMI_WriteI2C_Byte $BUS 0x39 0xc2 0x19

		HDMI_WriteI2C_Byte $BUS 0x39 0xc3 0x00
		HDMI_WriteI2C_Byte $BUS 0x39 0xc4 0x01
		HDMI_WriteI2C_Byte $BUS 0x39 0xc5 0x02
		HDMI_WriteI2C_Byte $BUS 0x39 0xc6 0x03
		HDMI_WriteI2C_Byte $BUS 0x39 0xc7 0x04
		HDMI_WriteI2C_Byte $BUS 0x39 0xc8 0x00
	fi
	
#lt9611_hdmi_tx end

#LT9611_HDMI_TX_Digital end
}

function lt9611_hdmi_tx_phy(){
#lt9611_hdmi_tx_phy
	couple_mode=0x73 #AC 0x73 DC 0x31	
	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x08
	HDMI_WriteI2C_Byte $BUS 0x39 0x30 0x06

	HDMI_WriteI2C_Byte $BUS 0x39 0x31 0x73 #AC
	#HDMI_WriteI2C_Byte $BUS 0x39 0x31 0x44 #DC

	HDMI_WriteI2C_Byte $BUS 0x39 0x32 0x04
	HDMI_WriteI2C_Byte $BUS 0x39 0x33 0x00
	HDMI_WriteI2C_Byte $BUS 0x39 0x34 0x00
	HDMI_WriteI2C_Byte $BUS 0x39 0x35 0x00
	HDMI_WriteI2C_Byte $BUS 0x39 0x36 0x00
	HDMI_WriteI2C_Byte $BUS 0x39 0x37 0x04
	HDMI_WriteI2C_Byte $BUS 0x39 0x3f 0x00
	HDMI_WriteI2C_Byte $BUS 0x39 0x40 0x09
	HDMI_WriteI2C_Byte $BUS 0x39 0x41 0x09
	HDMI_WriteI2C_Byte $BUS 0x39 0x42 0x09
	HDMI_WriteI2C_Byte $BUS 0x39 0x43 0x09
	HDMI_WriteI2C_Byte $BUS 0x39 0x44 0x00
#lt9611_hdmi_tx_phy end
}


function LT9611_Pcr_MK_Print(){
#LT9611_Pcr_MK_Print
	
	for ((i=0;i<8;i++))
	do
		HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x83
		echo -n "1... " && i2cget -f -y $BUS 0x39 0x97
		echo -n "2... " && i2cget -f -y $BUS 0x39 0xb4 
		echo -n "3... " && i2cget -f -y $BUS 0x39 0xb5 
		echo -n "4... " && i2cget -f -y $BUS 0x39 0xb6
		echo -n "5... " && i2cget -f -y $BUS 0x39 0xb7
		sleep 1
	done

#LT9611_Pcr_MK_Print end
}


function lt9611_hdcp_init(){
#lt9611_hdcp_init
	
	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x85
	HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x1f
	HDMI_WriteI2C_Byte $BUS 0x39 0x13 0xfe
	HDMI_WriteI2C_Byte $BUS 0x39 0x17 0x0f
	HDMI_WriteI2C_Byte $BUS 0x39 0x15 0x05

#lt9611_hdcp_init end
}


function LT9611_load_hdcp_key(){
#LT9611_load_hdcp_key

	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x85
    HDMI_WriteI2C_Byte $BUS 0x39 0x00 0x85
	#//HDMI_WriteI2C_Byte(0x02 0x0a); //I2C 100K
	HDMI_WriteI2C_Byte $BUS 0x39 0x03 0xc0
    HDMI_WriteI2C_Byte $BUS 0x39 0x03 0xc3
	HDMI_WriteI2C_Byte $BUS 0x39 0x04 0xa0 # //0xA0 is eeprom device address
	HDMI_WriteI2C_Byte $BUS 0x39 0x05 0x00 # //0x00 is eeprom offset address
	HDMI_WriteI2C_Byte $BUS 0x39 0x06 0x20 # //length for read
	HDMI_WriteI2C_Byte $BUS 0x39 0x14 0xff

	HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x11 #//0x31
	HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x17 # //0x37
	sleep 0.05
	tmp=$(i2cget -f -y $BUS 0x39 0x40)
	echo tmp=$tmp
	if [ $(( tmp & 0x81 )) -eq $((0x81 + 0 )) ];then
		echo "LT9611_load_hdcp_key: external key valid"
	else
		echo "LT9611_load_hdcp_key: external key unvalid  using internal test key!"
	fi
	HDMI_WriteI2C_Byte $BUS 0x39 0x03 0xc2
	HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x1f  
#LT9611_load_hdcp_key end
#
}



function LT9611_HDMI_Out_Enable(){
#LT9611_HDMI_Out_Enable

	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x81
	HDMI_WriteI2C_Byte $BUS 0x39 0x23 0x40
	
	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x82
	HDMI_WriteI2C_Byte $BUS 0x39 0xde 0x20
	HDMI_WriteI2C_Byte $BUS 0x39 0xde 0xe0
		
	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x80 
	HDMI_WriteI2C_Byte $BUS 0x39 0x18 0xdc # /* txpll sw rst */
	HDMI_WriteI2C_Byte $BUS 0x39 0x18 0xfc
	HDMI_WriteI2C_Byte $BUS 0x39 0x16 0xf1 #/* txpll calibration rest */ 
	HDMI_WriteI2C_Byte $BUS 0x39 0x16 0xf3
	
	HDMI_WriteI2C_Byte $BUS 0x39 0x11 0x5a # //Pcr reset
	HDMI_WriteI2C_Byte $BUS 0x39 0x11 0xfa
	
	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x81
	HDMI_WriteI2C_Byte $BUS 0x39 0x30 0xea

#LT9611_HDMI_Out_Enable end
}


function LT9611_HDMI_CEC_ON(){
#LT9611_HDMI_CEC_ON

	HDMI_WriteI2C_Byte $BUS 0x39 0xff  0x80
	HDMI_WriteI2C_Byte $BUS 0x39 0x0d  0xff
	HDMI_WriteI2C_Byte $BUS 0x39 0x15  0xf1 # //reset cec logic
	HDMI_WriteI2C_Byte $BUS 0x39 0x15  0xf9 
	HDMI_WriteI2C_Byte $BUS 0x39 0xff  0x86 
	HDMI_WriteI2C_Byte $BUS 0x39 0xfe  0xa5 # //clk div
#LT9611_HDMI_CEC_ON end
}


function lt9611_cec_msg_set_logical_address(){
#lt9611_cec_msg_set_logical_address
#lt9611_cec_msg_set_logical_address end
a=1
}

function lt9611_cec_msg_write_demo(){
	#lt9611_cec_msg_write_demo
	CEC_TxData_Buff1=0x05
	CEC_TxData_Buff1=0x40
	CEC_TxData_Buff1=0x84
	CEC_TxData_Buff1=0x10
	CEC_TxData_Buff1=0x00
	CEC_TxData_Buff1=0x05
	#lt9611_cec_msg_write_demo end

	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x86
	HDMI_WriteI2C_Byte $BUS 0x39 0xf5 0x01 # //lock rx data buff
    HDMI_WriteI2C_Byte $BUS 0x39 0xf4 $CEC_TxData_Buff1
   
    	HDMI_WriteI2C_Byte $BUS 0x39 0xe4 0x40 
    	HDMI_WriteI2C_Byte $BUS 0x39 0xe5 0x84 
    	HDMI_WriteI2C_Byte $BUS 0x39 0xe6 0x10 
    	HDMI_WriteI2C_Byte $BUS 0x39 0xe7 0x00 
    	HDMI_WriteI2C_Byte $BUS 0x39 0xe8 0x05 
    
    HDMI_WriteI2C_Byte $BUS 0x39 0xf9 0x03 # //start send msg
	sleep 0.125
    HDMI_WriteI2C_Byte $BUS 0x39 0xf5 0x00 # //unlock rx data buff
}


function LT9611_Read_EDID(){
	HDMI_WriteI2C_Byte $BUS 0x39 0xff 0x85
	#HDMI_WriteI2C_Byte(0x02,0x0a) # //I2C 100K
	HDMI_WriteI2C_Byte $BUS 0x39 0x03 0xc9
	HDMI_WriteI2C_Byte $BUS 0x39 0x04 0xa0 # //0xA0 is EDID device address
	HDMI_WriteI2C_Byte $BUS 0x39 0x05 0x00 # //0x00 is EDID offset address
	HDMI_WriteI2C_Byte $BUS 0x39 0x06 0x20 # //length for read
	HDMI_WriteI2C_Byte $BUS 0x39 0x14 0x7f #

	for ((i=0;i<8;i++))
	do
		HDMI_WriteI2C_Byte $BUS 0x39 0x05 $(decimalism_to_Hexadecimal $(( i*32)) ) # //0x00 is EDID offset address
		HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x36 
		HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x34 # //0x31
		HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x37 # //0x37
		sleep 0.005

		if [ $(( $(i2cget -f -y $BUS 0x39 0x40) & 0x02 )) -ne 0 ];then
			if [ $(( $(i2cget -f -y $BUS 0x39 0x40) & 0x50 )) -ne 0 ];then
				echo "read edid faild"
				HDMI_WriteI2C_Byte $BUS 0x39 0x03 0xc2
				HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x1f
				break
			else
				for ((j=0;j<32;j++))
				do
					edid_data=$(i2cget -f -y $BUS 0x39 0x83)
					eval $(echo "Sink_EDID_$((i*32+j))=$edid_data")
					if [ $i -eq 3 ] && [ $j -eq 30 ];then
						external_flag=$((edid_data & 0x03 ))
					fi
					echo "edid_data $edid_data"
				done
				if [ $i -eq 3 ];then
					if [ $external_flag -lt 1 ];then
						echo "$external_flag -lt 1"
						HDMI_WriteI2C_Byte $BUS 0x39 0x03 0xc2
						HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x1f
						break
					fi
				fi
			fi
		else
			echo "read edid failed: accs not done"
			HDMI_WriteI2C_Byte $BUS 0x39 0x03 0xc2
			HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x1f
			break
		fi
	done

	if [ $external_flag -lt 2 ];then
		echo "$external_flag -le 2"
		HDMI_WriteI2C_Byte $BUS 0x39 0x03 0xc2
		HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x1f
	fi

	for ((i=0;i<8;i++))
	do
		HDMI_WriteI2C_Byte $BUS 0x39 0x05 $(decimalism_to_Hexadecimal $((i*32)) ) # //0x00 is EDID offset address
		HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x76 # //0x31
		HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x74 # //0x31
		HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x77 # //0x37
		sleep 0.005

		if [ $(( $(i2cget -f -y $BUS 0x39 0x40) & 0x02)) -ne 0 ];then
			if [ $(( $(i2cget -f -y $BUS 0x39 0x40) & 0x50)) -ne 0 ];then
				echo "read edid failed: no ack"
				HDMI_WriteI2C_Byte $BUS 0x39 0x03 0xc2
				HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x1f
				break
			else
				for (( j=0;j<32;j++ ))
				do
					edid_data=$(i2cget -f -y $BUS 0x39 0x83)
					echo "edid_data $edid_data"
				done
				if [ $i -eq 3 ];then
					if [ $external_flag -le 3 ];then
						echo "external_flag -le 3"
						HDMI_WriteI2C_Byte $BUS 0x39 0x03 0xc2
						HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x1f
						break
					fi
				fi
			fi
		else
			echo "read edid failed: accs not done"
			HDMI_WriteI2C_Byte $BUS 0x39 0x03 0xc2
			HDMI_WriteI2C_Byte $BUS 0x39 0x07 0x1f
			break
		fi
	done
}
ENABLE_Lt8912chip
RESET_Lt8912chip
LT9611_Chip_ID
LT9611_System_Init
LT9611_Pattern_en
lt9611_set_pll
LT9611_pattern_gcm

LT9611_HDMI_TX_Digital
lt9611_hdmi_tx_phy
LT9611_Pcr_MK_Print

#LT9611_Audio_Init
lt9611_hdcp_init
LT9611_load_hdcp_key

LT9611_Read_EDID
LT9611_HDMI_Out_Enable
LT9611_HDMI_CEC_ON
lt9611_cec_msg_set_logical_address

while true
do
	lt9611_cec_msg_write_demo
done


	


