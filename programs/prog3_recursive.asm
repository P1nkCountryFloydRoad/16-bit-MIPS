main:
    addi $6, $0, 30   
    addi $1, $0, 5    
    jal  sum          
    sw   $3, 0($0)   
loop:
    j loop          


sum:
    beq  $1, $0, base  
    sw   $7, 0($6)    
    addi $6, $6, -1    
    sw   $1, 0($6)    
    addi $1, $1, -1    
    jal  sum          
    addi $6, $6, 1    
    lw   $1, 0($6)  
    addi $6, $6, 1    
    lw   $7, 0($6)   
    add  $3, $1, $3  
    jr   $7           
base:
    addi $3, $0, 0    
    jr   $7           
