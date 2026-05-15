import sys
import re

# ISA Dictionary
OPCODES = {
    'add': '0001', 'sub': '0010', 'and': '0011', 'or': '0100', 'slt': '0101', # R-Type
    'addi': '0110', 'lw': '0111', 'sw': '1000', 'beq': '1001',                # I-Type
    'j': '1010', 'jal': '1011', 'jr': '1100'                                  # J-Type
}

R_TYPE = ['add', 'sub', 'and', 'or', 'slt']
I_TYPE = ['addi', 'beq']
MEM_TYPE = ['lw', 'sw'] # Special I-Type formatting
J_TYPE = ['j', 'jal', ]
JR = ['jr'] 

def reg_to_bin(reg_str):
    """Converts '$1' to '001'"""
    num = int(reg_str.replace('$', '').replace(',', ''))
    return format(num, '03b')

def imm_to_bin(imm_str, bits):
    """Converts integer string to 2s complement binary string"""
    num = int(imm_str)
    if num < 0:
        num = (1 << bits) + num
    return format(num, f'0{bits}b')

def assemble(input_file, output_file):
    with open(input_file, 'r') as f:
        lines = f.readlines()

    #Remove comments, empty lines, record label addresses
    clean_lines = []
    labels = {}
    address = 0
    
    for line in lines:
        line = line.split('#')[0].strip()
        if not line:
            continue
            
        if ':' in line:
            label, _ = line.split(':')
            labels[label.strip()] = address
            continue
        
        clean_lines.append(line)
        address += 1

    #Translate to machine code
    machine_code = []
    address = 0
    
    for line in clean_lines:
        parts = line.replace(',', ' ').split()
        inst = parts[0].lower()
        opcode = OPCODES[inst]
        binary = ""

        if inst in R_TYPE:
            rd = reg_to_bin(parts[1])
            rs = reg_to_bin(parts[2])
            rt = reg_to_bin(parts[3])
            unused = "000"
            binary = f"{opcode}{rs}{rt}{rd}{unused}"

        elif inst in I_TYPE:
            if inst == 'beq':
                rs = reg_to_bin(parts[1])
                rt = reg_to_bin(parts[2])
                target = parts[3]
                offset = labels[target] - (address + 1) if target in labels else int(target)
                imm = imm_to_bin(offset, 6)
            else:
                rt = reg_to_bin(parts[1])
                rs = reg_to_bin(parts[2])
                imm = imm_to_bin(parts[3], 6)
            binary = f"{opcode}{rs}{rt}{imm}"

        elif inst in MEM_TYPE:
            rt = reg_to_bin(parts[1])
            mem_parts = parts[2].replace(')', '').split('(')
            imm = imm_to_bin(mem_parts[0], 6)
            rs = reg_to_bin(mem_parts[1])
            binary = f"{opcode}{rs}{rt}{imm}"

        elif inst in J_TYPE:
            target = parts[1]
            addr = labels[target] if target in labels else int(target)
            addr_bin = imm_to_bin(addr, 12)
            binary = f"{opcode}{addr_bin}"
            
        elif inst in JR:
            rs = reg_to_bin(parts[1])
            binary = f"{opcode}{rs}000000000"

        machine_code.append(binary)
        address += 1
    NOP = '0001000000000000'  
    with open(output_file, 'w') as f:
        for code in machine_code:
            f.write(code + '\n')
        for _ in range(4096 - len(machine_code)):
            f.write(NOP + '\n')
    print(f"Successfully assembled {len(machine_code)} instructions to {output_file}")

if __name__ == "__main__":
    import sys

    if len(sys.argv) >= 3:
        input_file = sys.argv[1]
        output_file = sys.argv[2]
        
    elif len(sys.argv) == 2:
        input_file = sys.argv[1]
        output_file = "memfile.dat"
        
    else:
        print("Usage: python3 assembler.py <input_file> [output_file]")
        sys.exit(1)

    assemble(input_file, output_file)