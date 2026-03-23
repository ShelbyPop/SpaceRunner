onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Game_Design_opt

do {wave.do}

view wave
view structure
view signals

do {Game_Design.udo}

run -all

quit -force
