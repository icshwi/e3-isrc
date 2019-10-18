#require modbus, 2.9.0-ESS0
require modbus, 2.11.0p

#require streamdevice, 2.7.7
require stream,2.8.8

#require ps-fug,2.0+
require ps_fug,2.0.0

#require sairemgmp20ked,2.0+
require sairemgmp20ked,2.0.0

require sairemai4s,2.0.0

require tdkGen10500,1.0.1

# ECMC --> JULEN !!!!!!!!!!!!
#require ecat2db,0.4+ 
#require ecat2db,0.5.0

#require iocStats,3.1+
require iocStats,ae5d083

#require source,2.2+
require isrc_source,master

#epicsEnvSet("STREAM_PROTOCOL_PATH", "$(ps_fug_DB)")
#epicsEnvSet("STREAM_PROTOCOL_PATH", "$(sairemgmp20ked_DB)")
#epicsEnvSet("STREAM_PROTOCOL_PATH", "$(sairemai4s_DB)")

epicsEnvSet("STREAM_PROTOCOL_PATH", "$(ps_fug_DB):$(tdkGen10500_DB)")


############################################################
######## FUG HCH 15k-100k [High Voltage Power Supply] ######
############################################################
drvAsynIPPortConfigure("HVPS", "172.16.60.57:2101")
#dbLoadRecords("fughch15k100k.db")

############################################################
######## FUG HCP 35-3500 [Repeller Power Supply] ###########
############################################################
drvAsynIPPortConfigure("RepPS-01", "172.16.60.52:2101")
drvAsynIPPortConfigure("RepPS-02", "172.16.60.53:2101")
#dbLoadRecords("fughcp353500.db")

#WLA open db file for both fug fughch15k100k and fughcp353500
##dbLoadRecords("source-fug.db")
dbLoadTemplate("source-fug.substitutions")
############################################################
###################### Sairem GMP20KED [Magnetron] #########
############################################################
drvAsynIPPortConfigure("conn-ISrc-ISS-Magtr", "172.16.60.54:502", 0, 0, 1)
modbusInterposeConfig("conn-ISrc-ISS-Magtr", 0, 1000, 0)
drvModbusAsynConfigure("sgmp20ked-modbus-write-word", "conn-ISrc-ISS-Magtr", 1, 6, 0, 9, 0, 1000, "Function6")
drvModbusAsynConfigure("sgmp20ked-modbus-read-word", "conn-ISrc-ISS-Magtr", 1, 3, 100, 109, 0, 1000, "Function3")
#dbLoadRecords("sairemgmp20ked.db")
dbLoadRecords("source-magnetron.db")

############################################################
################# Sairem AI4S [ATU] ########################
############################################################
drvAsynIPPortConfigure("conn-ISrc-ISS-ATU", "172.16.60.55:502", 0, 0, 1)
modbusInterposeConfig("conn-ISrc-ISS-ATU", 0, 1000, 0)
drvModbusAsynConfigure("sai4s-modbus-write-word", "conn-ISrc-ISS-ATU", 0, 6, 0, 10, 0, 1000, "Function6")
drvModbusAsynConfigure("sai4s-modbus-read-word", "conn-ISrc-ISS-ATU", 0, 3, 100, 5, 0, 1000, "Function3")
#dbLoadRecords("sairemai4s.db")   
dbLoadRecords("source-atu.db")

############################################################
############# TDK Lambda Genesys 10-500 [Coils] ############
############################################################
drvAsynIPPortConfigure("CoilsPS-01", "172.16.60.43:8003")
drvAsynIPPortConfigure("CoilsPS-02", "172.16.60.44:8003")
drvAsynIPPortConfigure("CoilsPS-03", "172.16.60.45:8003")
#dbLoadRecords("tdkGen10500.db")
dbLoadRecords("source-coils.db")

############################################################
#################  EtherCat Module  ########################
############################################################
# JULEN - ECMC !!!!!
#ecat2configure(0,500,1,1)
#dbLoadTemplate(source-sensors.substitutions)


############################################################
#################  iocStats  ###############################
############################################################

dbLoadTemplate(iocAdminSoft.substitutions,IOC="ISrc-010:Ctrl-IOC-ISrc")


iocInit


####### Chopper Voltage Ramp
dbpf LEBT-010:BMD-Chop:VolS.OROC 0.1
dbpf LEBT-010:BMD-Chop:VolS.SCAN '.1 second'

###########################################################
###Operation Parameters from ICSHWI-1265
###########################################################


dbpf ISrc-010:ISS-Magtr:PulsHLvlS.DRVH 2000
dbpf ISrc-010:ISS-Magtr:PulsHLvlS.EGU "W"
dbpf ISrc-010:ISS-Magtr:ForwdPwrR.HIHI 1500
dbpf ISrc-010:ISS-Magtr:ForwdPwrR.HIGH 1000
dbpf ISrc-010:ISS-Magtr:ForwdPwrR.EGU "W"
dbpf ISrc-010:ISS-Magtr:ForwdPwrR.HHSV "MAJOR"
dbpf ISrc-010:ISS-Magtr:ForwdPwrR.HSV "MINOR"
dbpf ISrc-010:ISS-Magtr:ReflPwrR.HIHI 1000
dbpf ISrc-010:ISS-Magtr:ReflPwrR.HIGH 300
dbpf ISrc-010:ISS-Magtr:ReflPwrR.EGU "W"
dbpf ISrc-010:ISS-Magtr:ReflPwrR.HHSV "MAJOR"
dbpf ISrc-010:ISS-Magtr:ReflPwrR.HSV "MINOR"
dbpf ISrc-010:ISS-ATU:PosXS.DRVH 10000
dbpf ISrc-010:ISS-ATU:PosXS.EGU "um"
dbpf ISrc-010:ISS-ATU:PosXR.HIGH 7500
dbpf ISrc-010:ISS-ATU:PosXR.LOW 2500
dbpf ISrc-010:ISS-ATU:PosXR.ADEL 10
dbpf ISrc-010:ISS-ATU:PosXR.EGU "um"
dbpf ISrc-010:ISS-ATU:PosXR.HSV "MINOR"
dbpf ISrc-010:ISS-ATU:PosXR.LSV "MINOR"
dbpf ISrc-010:ISS-ATU:PosYS.DRVH 10000
dbpf ISrc-010:ISS-ATU:PosYS.EGU "um"
dbpf ISrc-010:ISS-ATU:PosYR.HIGH 7500
dbpf ISrc-010:ISS-ATU:PosYR.LOW 2500
dbpf ISrc-010:ISS-ATU:PosYR.ADEL 10
dbpf ISrc-010:ISS-ATU:PosYR.EGU "um"
dbpf ISrc-010:ISS-ATU:PosYR.HSV "MINOR"
dbpf ISrc-010:ISS-ATU:PosYR.LSV "MINOR"
dbpf ISrc-010:PwrC-RepPS-01:VolS.DRVL -3500
dbpf ISrc-010:PwrC-RepPS-01:VolS.EGU "V"
dbpf ISrc-010:PwrC-RepPS-01:VolR.HIGH -3000
dbpf ISrc-010:PwrC-RepPS-01:VolR.EGU "V"
dbpf ISrc-010:PwrC-RepPS-01:VolR.HSV "MINOR"
dbpf ISrc-010:PwrC-RepPS-01:CurS.DRVL -10
dbpf ISrc-010:PwrC-RepPS-01:CurS.EGU "mA"
dbpf ISrc-010:PwrC-RepPS-01:CurR.HIGH -5
dbpf ISrc-010:PwrC-RepPS-01:CurR.EGU "mA"
dbpf ISrc-010:PwrC-RepPS-01:CurR.HSV "MINOR"
dbpf LEBT-010:PwrC-RepPS-01:VolS.DRVL -3500
dbpf LEBT-010:PwrC-RepPS-01:VolS.EGU "V"
dbpf LEBT-010:PwrC-RepPS-01:VolR.HIGH -3000
dbpf LEBT-010:PwrC-RepPS-01:VolR.EGU "V"
dbpf LEBT-010:PwrC-RepPS-01:VolR.HSV "MINOR"
dbpf LEBT-010:PwrC-RepPS-01:CurS.DRVL -10
dbpf LEBT-010:PwrC-RepPS-01:CurS.EGU "mA"
dbpf LEBT-010:PwrC-RepPS-01:CurR.HIGH -5
dbpf LEBT-010:PwrC-RepPS-01:CurR.EGU "mA"
dbpf LEBT-010:PwrC-RepPS-01:CurR.HSV "MINOR"
dbpf ISrc-010:PwrC-CoilPS-01:VolS.DRVH 10
dbpf ISrc-010:PwrC-CoilPS-01:VolS.PREC 1
dbpf ISrc-010:PwrC-CoilPS-01:VolS.EGU "V"
dbpf ISrc-010:PwrC-CoilPS-01:VolR.HIGH 8
dbpf ISrc-010:PwrC-CoilPS-01:VolR.ADEL 1
dbpf ISrc-010:PwrC-CoilPS-01:VolR.PREC 1
dbpf ISrc-010:PwrC-CoilPS-01:VolR.EGU "V"
dbpf ISrc-010:PwrC-CoilPS-01:VolR.HSV "MINOR"
dbpf ISrc-010:PwrC-CoilPS-01:CurS.DRVH 500
dbpf ISrc-010:PwrC-CoilPS-01:CurS.PREC 1
dbpf ISrc-010:PwrC-CoilPS-01:CurS.EGU "A"
dbpf ISrc-010:PwrC-CoilPS-01:CurR.HIGH 470
dbpf ISrc-010:PwrC-CoilPS-01:CurR.ADEL 1
dbpf ISrc-010:PwrC-CoilPS-01:CurR.PREC 1
dbpf ISrc-010:PwrC-CoilPS-01:CurR.EGU "A"
dbpf ISrc-010:PwrC-CoilPS-01:CurR.HSV "MINOR"
dbpf ISrc-010:PwrC-CoilPS-02:VolS.DRVH 10
dbpf ISrc-010:PwrC-CoilPS-02:VolS.PREC 1
dbpf ISrc-010:PwrC-CoilPS-02:VolS.EGU "V"
dbpf ISrc-010:PwrC-CoilPS-02:VolR.HIGH 8
dbpf ISrc-010:PwrC-CoilPS-02:VolR.ADEL 1
dbpf ISrc-010:PwrC-CoilPS-02:VolR.PREC 1
dbpf ISrc-010:PwrC-CoilPS-02:VolR.EGU "V"
dbpf ISrc-010:PwrC-CoilPS-02:VolR.HSV "MINOR"
dbpf ISrc-010:PwrC-CoilPS-02:CurS.DRVH 500
dbpf ISrc-010:PwrC-CoilPS-02:CurS.PREC 1
dbpf ISrc-010:PwrC-CoilPS-02:CurS.EGU "A"
dbpf ISrc-010:PwrC-CoilPS-02:CurR.HIGH 470
dbpf ISrc-010:PwrC-CoilPS-02:CurR.ADEL 1
dbpf ISrc-010:PwrC-CoilPS-02:CurR.PREC 1
dbpf ISrc-010:PwrC-CoilPS-02:CurR.EGU "A"
dbpf ISrc-010:PwrC-CoilPS-02:CurR.HSV "MINOR"
dbpf ISrc-010:PwrC-CoilPS-03:VolS.DRVH 10
dbpf ISrc-010:PwrC-CoilPS-03:VolS.PREC 1
dbpf ISrc-010:PwrC-CoilPS-03:VolS.EGU "V"
dbpf ISrc-010:PwrC-CoilPS-03:VolR.HIGH 8
dbpf ISrc-010:PwrC-CoilPS-03:VolR.ADEL 1
dbpf ISrc-010:PwrC-CoilPS-03:VolR.PREC 1
dbpf ISrc-010:PwrC-CoilPS-03:VolR.EGU "V"
dbpf ISrc-010:PwrC-CoilPS-03:VolR.HSV "MINOR"
dbpf ISrc-010:PwrC-CoilPS-03:CurS.DRVH 500
dbpf ISrc-010:PwrC-CoilPS-03:CurS.PREC 1
dbpf ISrc-010:PwrC-CoilPS-03:CurS.EGU "A"
dbpf ISrc-010:PwrC-CoilPS-03:CurR.HIGH 470
dbpf ISrc-010:PwrC-CoilPS-03:CurR.ADEL 1
dbpf ISrc-010:PwrC-CoilPS-03:CurR.PREC 1
dbpf ISrc-010:PwrC-CoilPS-03:CurR.EGU "A"
dbpf ISrc-010:PwrC-CoilPS-03:CurR.HSV "MINOR"
dbpf ISrc-010:ISS-HVPS:VolS.DRVH 80
dbpf ISrc-010:ISS-HVPS:VolS.HIHI 79
dbpf ISrc-010:ISS-HVPS:VolS.HIGH 76
dbpf ISrc-010:ISS-HVPS:VolS.LOW 69
dbpf ISrc-010:ISS-HVPS:VolS.ADEL 0.1
dbpf ISrc-010:ISS-HVPS:VolS.PREC 2
dbpf ISrc-010:ISS-HVPS:VolS.EGU "kV"
dbpf ISrc-010:ISS-HVPS:VolS.HHSV "MAJOR"
dbpf ISrc-010:ISS-HVPS:VolS.HSV "MINOR"
dbpf ISrc-010:ISS-HVPS:VolS.LSV "MINOR"
dbpf ISrc-010:ISS-HVPS:VolR.HIHI 79
dbpf ISrc-010:ISS-HVPS:VolR.HIGH 76
dbpf ISrc-010:ISS-HVPS:VolR.LOW 69
dbpf ISrc-010:ISS-HVPS:VolR.ADEL 0.1
dbpf ISrc-010:ISS-HVPS:VolR.PREC 2
dbpf ISrc-010:ISS-HVPS:VolR.EGU "kV"
dbpf ISrc-010:ISS-HVPS:VolR.HHSV "MAJOR"
dbpf ISrc-010:ISS-HVPS:VolR.HSV "MINOR"
dbpf ISrc-010:ISS-HVPS:VolR.LSV "MINOR"
dbpf ISrc-010:ISS-HVPS:CurS.DRVH 150
dbpf ISrc-010:ISS-HVPS:CurS.EGU "mA"
dbpf ISrc-010:ISS-HVPS:CurR.HIHI 140
dbpf ISrc-010:ISS-HVPS:CurR.HIGH 10
dbpf ISrc-010:ISS-HVPS:CurR.ADEL 0.5
dbpf ISrc-010:ISS-HVPS:CurR.PREC 1
dbpf ISrc-010:ISS-HVPS:CurR.EGU "mA"
dbpf ISrc-010:ISS-HVPS:CurR.HHSV "MAJOR"
dbpf ISrc-010:ISS-HVPS:CurR.HSV "MINOR"
dbpf LEBT-010:BMD-Chop:VolS.DRVH 12
dbpf LEBT-010:BMD-Chop:VolS.ADEL 0.3
dbpf LEBT-010:BMD-Chop:VolS.PREC 3
dbpf LEBT-010:BMD-Chop:VolS.EGU "kV"
dbpf LEBT-010:BMD-Chop:VolR.LOW 9
dbpf LEBT-010:BMD-Chop:VolR.ADEL 0.3
dbpf LEBT-010:BMD-Chop:VolR.MDEL 0.05
dbpf LEBT-010:BMD-Chop:VolR.PREC 3
dbpf LEBT-010:BMD-Chop:VolR.EGU "kV"
dbpf LEBT-010:BMD-Chop:VolR.LSV "MINOR"
dbpf LEBT-010:BMD-Chop:CurR.HIHI 10
dbpf LEBT-010:BMD-Chop:CurR.HIGH 0.2
dbpf LEBT-010:BMD-Chop:CurR.ADEL 0.005
dbpf LEBT-010:BMD-Chop:CurR.MDEL 0.005
dbpf LEBT-010:BMD-Chop:CurR.PREC 2
dbpf LEBT-010:BMD-Chop:CurR.EGU "mA"
dbpf LEBT-010:BMD-Chop:CurR.HHSV "MAJOR"
dbpf LEBT-010:BMD-Chop:CurR.HSV "MINOR"
dbpf ISrc-010:HVAC-ST:AmbTempR.HIHI 37
dbpf ISrc-010:HVAC-ST:AmbTempR.HIGH 30
dbpf ISrc-010:HVAC-ST:AmbTempR.LOW 15
dbpf ISrc-010:HVAC-ST:AmbTempR.ADEL 0.5
dbpf ISrc-010:HVAC-ST:AmbTempR.PREC 1
dbpf ISrc-010:HVAC-ST:AmbTempR.EGU "C"
dbpf ISrc-010:HVAC-ST:AmbTempR.HHSV "MAJOR"
dbpf ISrc-010:HVAC-ST:AmbTempR.HSV "MINOR"
dbpf ISrc-010:HVAC-ST:AmbTempR.LSV "MINOR"
dbpf ISrc-010:HVAC-ST:AmbTempR.LLSV "MAJOR"
dbpf ISrc-010:ISS-Coil-01:TempR.HIHI 50
dbpf ISrc-010:ISS-Coil-01:TempR.HIGH 40
dbpf ISrc-010:ISS-Coil-01:TempR.LOW 15
dbpf ISrc-010:ISS-Coil-01:TempR.ADEL 0.5
dbpf ISrc-010:ISS-Coil-01:TempR.PREC 1
dbpf ISrc-010:ISS-Coil-01:TempR.EGU "C"
dbpf ISrc-010:ISS-Coil-01:TempR.HHSV "MAJOR"
dbpf ISrc-010:ISS-Coil-01:TempR.HSV "MINOR"
dbpf ISrc-010:ISS-Coil-01:TempR.LSV "MINOR"
dbpf ISrc-010:ISS-Coil-02:TempR.HIHI 50
dbpf ISrc-010:ISS-Coil-02:TempR.HIGH 40
dbpf ISrc-010:ISS-Coil-02:TempR.LOW 15
dbpf ISrc-010:ISS-Coil-02:TempR.ADEL 0.5
dbpf ISrc-010:ISS-Coil-02:TempR.PREC 1
dbpf ISrc-010:ISS-Coil-02:TempR.EGU "C"
dbpf ISrc-010:ISS-Coil-02:TempR.HHSV "MAJOR"
dbpf ISrc-010:ISS-Coil-02:TempR.HSV "MINOR"
dbpf ISrc-010:ISS-Coil-02:TempR.LSV "MINOR"
dbpf ISrc-010:ISS-Coil-03:TempR.HIHI 50
dbpf ISrc-010:ISS-Coil-03:TempR.HIGH 40
dbpf ISrc-010:ISS-Coil-03:TempR.LOW 15
dbpf ISrc-010:ISS-Coil-03:TempR.ADEL 0.5
dbpf ISrc-010:ISS-Coil-03:TempR.PREC 1
dbpf ISrc-010:ISS-Coil-03:TempR.EGU "C"
dbpf ISrc-010:ISS-Coil-03:TempR.HHSV "MAJOR"
dbpf ISrc-010:ISS-Coil-03:TempR.HSV "MINOR"
dbpf ISrc-010:ISS-Coil-03:TempR.LSV "MINOR"
