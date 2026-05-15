main:
    addi $1, $0, 12   
    addi $2, $0, 7    
    jal  max          
    sw   $3, 0($0)    
loop:
    j loop           

max:
    slt  $4, $1, $2   
    beq  $4, $0, a_wins 
    add  $3, $2, $0  
    jr   $7            
a_wins:
    add  $3, $1, $0    
    jr   $7           
