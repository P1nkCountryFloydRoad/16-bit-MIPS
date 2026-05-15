main:
    addi $1, $0, 15 
    addi $2, $0, 7   
    add  $3, $1, $2   
    sw   $3, 0($0)    
    sub  $4, $1, $2  
    sw   $4, 1($0)    
    and  $5, $1, $2   
    sw   $5, 2($0)     
    or   $6, $1, $2  
    sw   $6, 3($0)     
loop:
    j loop            
