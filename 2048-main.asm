

# Constants
.data
newline:  .asciiz "\n"

.text 

.globl main

main:

	li $a0, 0xffff0000
	li $a1, 2
	li $a2, 3
	li $a3, 0
	li $t0, 0
	li $t1, 0
	li $t2, 2
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	jal start_game
	addi $sp, $sp, 12
	
	li $a0, 0xffff0000
	li $a1, 2
	li $a2, 3
	li $a3, 0
	li $t0, 1
	li $t1, 4
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place
	addi $sp, $sp, 8
	move $a0, $v0 #print output 
		li $v0, 1
		syscall
	
	li $a0, 0xffff0000
	li $a1, 2
	li $a2, 3
	li $a3, 1
	li $t0, 1
	li $t1, 128
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place
	addi $sp, $sp, 8
	
	li $a0, 0xffff0000
	li $a1, 2
	li $a2, 3
	li $a3, 1
	li $t0, 0
	li $t1, 64
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place
	addi $sp, $sp, 8
	
	
	li $a0, 0xffff0000
	li $a1, 2
	li $a2, 3
	li $a3, 1
	li $t0, 2
	li $t1, 512
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place
	addi $sp, $sp, 8

	
	li $a0, 0xffff0000
	li $a1, 2
	li $a2, 3
	li $a3, 2
	li $t0, 2
	li $t1, 16
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place
	addi $sp, $sp, 8
	
	li $a0, 0xffff0000
	li $a1, 2
	li $a2, 3
	li $a3, 2
	li $t0, 1
	li $t1, 32
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place
	addi $sp, $sp, 8
	
	li $a0, 0xffff0000
	li $a1, 2
	li $a2, 3
	li $a3, 1
	li $t0, 1
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal merge_row
	addi $sp, $sp, 4
	


	game_loop:
	
		li   $v0, 12       
  		syscall            # Read Character
	
		li $a0, 0xffff0000
		li $a1, 2
		li $a2, 3
		move $a3, $v0
		jal user_move
		
		beq $v1, -1, game_over
		beq $v1, 1, game_over
		
		move $a0, $v0 #print output 
		li $v0, 1
		syscall
		move $a0, $v1 #print output 
		li $v0, 1
		syscall
		
		li $a0, '\n'
		li $v0, 11
		syscall
		
		
	j game_loop

	game_over:
	move $a0, $v0 #print output 
		li $v0, 1
		syscall
		move $a0, $v1 #print output 
		li $v0, 1
		syscall
		
# Exit the program
	li $v0, 10
	syscall
		
.include "hw4.asm"
