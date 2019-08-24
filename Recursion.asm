          .data
array:   .space 40
Prompt:  .asciiz "\nEnter a value: "
min:     .asciiz "\nMin Value: "
com:     .asciiz "Combination Value: "
high:    .asciiz "Enter High Value: "
low:     .asciiz "Enter Low Value: " 
n:       .asciiz "Enter n value: "
r:       .asciiz "Enter r value: "
newLine: .asciiz "\n"

         .text
main:      li $t0, 10
           la $t1, array
loopR:     la $a0, Prompt   #stores 20 integers
           li $v0, 4
           syscall
           li $v0,5           
           syscall
           sw $v0,0($t1)
           add $t0,$t0,-1
           add $t1,$t1,4
           bgtz $t0,loopR
           li $t0,10
           la $t1,array
           la $a0, high  #Prompt high
           li $v0, 4
           syscall
           li $v0, 5
           syscall
           move $a2, $v0  #a2 holds high
           la $a0, low    #Prompt Low
           li $v0, 4
           syscall
           li $v0, 5
           syscall
           la $a0, array
           move $a1, $v0  #t3 holds low
           jal Min
           move $a0, $v0
           li $v0, 1
           syscall
           la $a0, newLine
           li $v0, 4
           syscall 
           la $a0, r
          li $v0, 4
          syscall
          li $v0, 5
          syscall
          move $a1, $v0   #$a1 holds r
          la $a0, n
          li $v0, 4
          syscall
          li $v0, 5
          syscall
          move $a0, $v0   #$a0 holds n
          jal Comb
          move $a0, $v0 
          li $v0, 1
          syscall
          la $a0, newLine
          li $v0, 4
          syscall
end:      li $v0, 10
          syscall

Min:      bne $a1, $a2, recu   #recursion
          mul $a2, $a2, 4
          add $a0, $a0, $a2
          lw $v0, 0($a0)
          jr $ra

recu:     addiu $sp, $sp, -20   #make space in stack 
          sw $a0, 4($sp)
          sw $ra, 0($sp)
          sw $a1, 8($sp)
          sw $a2, 12($sp)
          add $t6,$a2, $a1   #finding mid
          div $t6, $t6,2     #finding mid
          move $a2, $t6   #move mid to high
          jal Min
          sw $v0, 16($sp)
          lw $a0, 4($sp)
          lw $a1, 8($sp)
          lw $a2, 12($sp)
          add $t6, $a1, $a2     
          div $t6, $t6, 2
          addi $t6,$t6,1     #add 1 to min
          move $a1, $t6  #move mid+1 to low
          jal Min 
          lw $t0, 16($sp)
          bgt $t0, $v0, returnmin2
          move $v0,$t0
          lw $ra, 0($sp)
          addiu $sp,$sp, 20   #exit function
          jr $ra
    
returnmin2:   
          lw $ra,0($sp)
          addiu $sp,$sp, 20   #exit function
          jr $ra
          
Comb:     beq $a0, $a1, base   #if r is equal to n
          beqz $a1, base      #if r == 0
notbase:  addiu $sp, $sp, -16
          sw $ra, 0($sp) #store return address
          sw $a0, 4($sp) #store n
          sw $a1, 8($sp) #store r
          add $a0, $a0, -1 #sub 1 for first comb
          jal Comb
          sw $v0, 12($sp)#store value of comb 1
          lw $a0, 4($sp)
          lw $a1, 8($sp)
          add $a0, $a0, -1
          add $a1, $a1, -1
          jal Comb
          lw $t0, 12($sp)
          add $v0, $v0, $t0
          lw $ra, 0($sp)
          addiu $sp, $sp, 16
          jr $ra

base:     li $v0, 1
          jr $ra 