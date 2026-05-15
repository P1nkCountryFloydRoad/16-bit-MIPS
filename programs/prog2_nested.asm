main:
    addi $6, $0, 30   
    addi $1, $0, 4    
    addi $2, $0, 3    
    jal  outer     
    sw   $3, 0($0)    
loop:
    j loop           

outer:
    sw   $7, 0($6)     
    addi $6, $6, -1   
    sw   $2, 0($6)     
    addi $6, $6, -1    
    jal  double        
    addi $6, $6, 1    
    lw   $2, 0($6)     
    addi $6, $6, 1    
    lw   $7, 0($6)     
    add  $3, $3, $2    
    jr   $7          

double:
    add  $3, $1, $1   
    jr   $7          
