# Program 3: Recursive procedure
# sum(n) = 0 + 1 + 2 + ... + n
# sum(5) = 15, stored in mem[0]
# $6 = $sp (initialized to 30), $7 = $ra
#
# Instruction addresses:
#   main:  0-4   (addi, addi, jal, sw, j)
#   sum:   5-17  (beq=5, sw, addi, sw, addi, addi, jal, addi, lw, addi, lw, add, jr)
#   base: 18-19  (addi, jr)
#
# beq at addr 5: offset = 18-(5+1) = 12  [6-bit signed, fits]
# jal sum at addr 11: target = 5

main:
    addi $6, $0, 30    # $6 = sp = 30
    addi $1, $0, 5     # $1 = n = 5
    jal  sum           # $3 = sum(5) = 15
    sw   $3, 0($0)     # mem[0] = 15
loop:
    j loop             # halt

# sum(n=$1) -> $3
# base case: n==0 => return 0
# recursive: return n + sum(n-1)
sum:
    beq  $1, $0, base  # if n==0, go to base  [offset=12]
    sw   $7, 0($6)     # save $ra
    addi $6, $6, -1    # sp--
    sw   $1, 0($6)     # save n
    addi $6, $6, -1    # sp--
    addi $1, $1, -1    # n = n-1
    jal  sum           # $3 = sum(n-1)
    addi $6, $6, 1     # sp++
    lw   $1, 0($6)     # restore n
    addi $6, $6, 1     # sp++
    lw   $7, 0($6)     # restore $ra
    add  $3, $1, $3    # $3 = n + sum(n-1)
    jr   $7            # return
base:
    addi $3, $0, 0     # $3 = 0
    jr   $7            # return
