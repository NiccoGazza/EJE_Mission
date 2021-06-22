#! usr/bin/python

import os

os.chdir("/home/francesca_vhu/Scrivania/EJE_Mission/ephemerides")

io = open("io_rv.m", "r")

with open('io_vector.txt', 'rt') as myfile, open("io_rv.m", "w") as io:
    io.write("function data = io_rv() \n")
    io.write("data = [ \n")
    for myline in myfile:
        line = myline.strip('\n')
        if len(line) >= 2:
            if line[1] == 'X':
                line = line.replace("X =", "")
                line = line.replace("Y =", "")
                line = line.replace("Z =", "")
                io.write(line)
            elif line[1] == 'V':
                line = line.replace("VX=", "")
                line = line.replace("VY=", "")
                line = line.replace("VZ=", "")
                io.write(line)
                io.write('\n')
    io.write('];')
