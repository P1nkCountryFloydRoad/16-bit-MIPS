# Program 2: Nested procedure
# outer(a=$1=4, b=$2=3) = double(a) + b = 8 + 3 = 11
# outer calls double, so outer must save/restore $ra and $2 on stack
# $6 = $sp (initialized to 30), $7 = $ra

main:
    addi $6, $0, 30    # $6 = sp = 30
    addi $1, $0, 4     # $1 = 4  (a)
    addi $2, $0, 3     # $2 = 3  (b)
    jal  outer         # call outer; result in $3
    sw   $3, 0($0)     # mem[0] = outer(4,3) = 11
loop:
    j loop             # halt

# outer(a=$1, b=$2) -> $3 = double(a)+b
outer:
    sw   $7, 0($6)     # save $ra to stack
    addi $6, $6, -1    # sp--
    sw   $2, 0($6)     # save $2 to stack
    addi $6, $6, -1    # sp--
    jal  double        # $3 = double($1) = 2*a; clobbers $7
    addi $6, $6, 1     # sp++
    lw   $2, 0($6)     # restore $2
    addi $6, $6, 1     # sp++
    lw   $7, 0($6)     # restore $ra
    add  $3, $3, $2    # $3 = double(a) + b
    jr   $7            # return

# double(a=$1) -> $3 = 2*a  (leaf)
double:
    add  $3, $1, $1    # $3 = $1 + $1
    jr   $7            # return
