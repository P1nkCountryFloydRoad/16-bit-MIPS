# Program 1: Leaf procedure
# max(a, b) - returns the larger of two values
# $1 = 12, $2 = 7 => max = 12 stored in mem[0]
# Leaf: max does not call any other procedure, so $ra need not be saved

main:
    addi $1, $0, 12    # $1 = 12 (a)
    addi $2, $0, 7     # $2 = 7  (b)
    jal  max           # call max; return value in $3
    sw   $3, 0($0)     # mem[0] = max(12,7) = 12
loop:
    j loop             # halt

# max(a=$1, b=$2) -> $3
max:
    slt  $4, $1, $2    # $4 = 1 if $1 < $2, else 0
    beq  $4, $0, a_wins # if $4==0, a >= b
    add  $3, $2, $0    # $3 = b (b is larger)
    jr   $7            # return
a_wins:
    add  $3, $1, $0    # $3 = a (a is larger)
    jr   $7            # return
