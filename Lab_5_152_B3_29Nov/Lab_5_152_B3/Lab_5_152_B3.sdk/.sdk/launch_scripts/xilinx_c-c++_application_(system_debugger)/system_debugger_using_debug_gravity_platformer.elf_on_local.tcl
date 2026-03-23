connect -url tcp:127.0.0.1:3121
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "microblaze*#0" && bscan=="USER2"  && jtag_cable_name =~ "Digilent Basys3 210183B31ACBA"} -index 0
rst -processor
targets -set -nocase -filter {name =~ "microblaze*#0" && bscan=="USER2"  && jtag_cable_name =~ "Digilent Basys3 210183B31ACBA"} -index 0
dow C:/Users/rohit/Desktop/CS_M152B/22NOV_CODE/Lab_5_152_B3_22Nov/Lab_5_152_B3/Lab_5_152_B3.sdk/Gravity_Platformer/Debug/Gravity_Platformer.elf
targets -set -nocase -filter {name =~ "microblaze*#0" && bscan=="USER2"  && jtag_cable_name =~ "Digilent Basys3 210183B31ACBA"} -index 0
con
