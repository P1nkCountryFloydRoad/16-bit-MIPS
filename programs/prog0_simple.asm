# Program 0: Simple arithmetic
# Computes add, sub, and, or of $1=15 and $2=7
# Stores results to mem[0]-mem[3]
# No procedures

main:
    addi $1, $0, 15    # $1 = 15
    addi $2, $0, 7     # $2 = 7
    add  $3, $1, $2    # $3 = 22
    sw   $3, 0($0)     # mem[0] = 22
    sub  $4, $1, $2    # $4 = 8
    sw   $4, 1($0)     # mem[1] = 8
    and  $5, $1, $2    # $5 = 7
    sw   $5, 2($0)     # mem[2] = 7
    or   $6, $1, $2    # $6 = 15
    sw   $6, 3($0)     # mem[3] = 15
loop:
    j loop             # infinite loop (halt)
