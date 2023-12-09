with open("./rom.txt", "w") as file:
    init = 0x76543210
    for i in range(0, 256):
        file.write(hex(init + i)[2:] + "\n")