#! usr/bin/python

import os

os.chdir("/home/francesca_vhu/Scrivania/EJE_Mission/data")

europe = open("europe_rv.m", "r")

with open('europe_vector.txt', 'rt') as myfile, open("europe_rv.m", "w") as europe:
    europe.write("function data = europe_rv() \n")
    europe.write("data = [ \n")
    for myline in myfile:
        line = myline.strip('\n')
        if len(line) >= 2:
            if line[1] == 'X':
                line = line.replace("X =", "")
                line = line.replace("Y =", "")
                line = line.replace("Z =", "")
                europe.write(line)
            elif line[1] == 'V':
                line = line.replace("VX=", "")
                line = line.replace("VY=", "")
                line = line.replace("VZ=", "")
                europe.write(line)
                europe.write('\n')
    europe.write('];')
