
##############################################################
# Homework #4
# name: Kristian Charbonneau	
# sbuid: 110557203
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

clear_board:
    #Define your code here
	############################################
	li $v0, -1
	move $t0, $a0 #address of board
	move $t1, $a1 #numrows
	move $t2, $a2 #numcols
	
	blt $t1, 2, return_clear_board #numrows < 2
	blt $t2, 2, return_clear_board #numcols < 2
	
	mul $t5, $t1, $t2 #numrows * numcols
	li $t4, 2 
	mul $t5, $t5, $t4 #numrows * numcols * 2
	add $t5, $t5, $t0 #addr + numrows*numcols*2 
	addi $t5, $t5, -2 #addr + numrows*numcols*2 - 2 (max addr)
	
	clear_loop:
	li $t3, -1
	sh $t3, 0($t0) #save -1 to board addr
	bge $t0, $t5, clear_loop_done
	addi $t0, $t0, 2 #addr += 2
	j clear_loop
	############################################
	clear_loop_done:
	li $v0, 0
	return_clear_board:
	jr $ra
	
get_cell_offset:
	move $t0, $a0 #row
	move $t1, $a1 #col 
	move $t2, $a2 #numrows
	move $t3, $a3 #numcols
	
	li $t4, 2
	mul $t5, $t3, $t4 #numcols * 2
	mul $t5, $t0, $t5 #numcols*2*row 
	mul $t6, $t1, $t4 #col*2
	add $t5, $t5, $t6 #numcols*2*row + col*2
	
	move $v0, $t5
	
	jr $ra
	

place:
	############################################
	li $v0, -1
	lw $t0, 0($sp) #col 
	lw $t1, 4($sp) #val
	
	addi $sp, $sp, -28	# save registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	
	move $s0, $a0 #board addr
	move $s1, $a1 #numrows
	move $s2, $a2 #numcols
	move $s3, $a3 #row
	move $s4, $t0 #col
	move $s5, $t1 #val
	
	blt $s1, 2, return_place #numrows < 2
	blt $s2, 2, return_place #numcols < 2
	bltz $s3, return_place #row < 0
	bltz $s4, return_place #col < 0
	bge $s3, $s1, return_place #row >= numrows
	bge $s4, $s2, return_place #col >= numcols 
	
	beqz $s5, return_place_error #val = 0
	addi $t9, $s5, -1 #check if val is a power of 2
	and $t9, $t9, $s5 
	beqz $t9, power_of_2
	bne $t5, -1, return_place_error #val != -1 && is not a power of 2
	power_of_2:
	
	move $a0, $s3 
	move $a1, $s4
	move $a2, $s1
	move $a3, $s2 
	jal get_cell_offset
	
	add $s0, $s0, $v0
	sh $s5, 0($s0)
	
	li $v0, 0
	j return_place
	############################################
	return_place_error:
	li $v0, -1
	return_place:
	
	lw $s0, 0($sp)		# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28
    jr $ra

start_game:
    #Define your code here
	############################################
	li $v0, -1
	lw $t0, 0($sp) 
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	
	addi $sp, $sp, -36	# save registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0 #board addr
	move $s1, $a1 #numrows
	move $s2, $a2 #numcols
	move $s3, $a3 #r1
	move $s4, $t0 #c1
	move $s5, $t1 #r2
	move $s6, $t2 #c2
	
	jal clear_board
	beq $v0, -1, return_start_game_error
	
	addi $sp, $sp, -8
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	li $s7, 2
	sw $s4, 0($sp)
	sw $s7, 4($sp)
	jal place
	addi $sp, $sp, 8
	beq $v0, -1, return_start_game_error
	
	
	addi $sp, $sp, -8
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s5
	sw $s6, 0($sp)
	sw $s7, 4($sp)
	jal place
	addi $sp, $sp, 8
	beq $v0, -1, return_start_game_error
	

	li $v0, 0
	j return_start_game
	return_start_game_error:
	li $v0, -1

	############################################
	return_start_game:	
	lw $s0, 0($sp)		# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
    	
    jr $ra

##############################
# PART 2 FUNCTIONS
##############################

merge_row:
    #Define your code here
    ############################################
    	li $v0, -1
	lw $t0, 0($sp) 
	
	addi $sp, $sp, -36	# save registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0 #board addr
	move $s1, $a1 #numrows
	move $s2, $a2 #numcols
	move $s3, $a3 #row
	move $s4, $t0 #dir
	move $s5, $s0
	move $s6, $s0 
	move $s7, $s0
	
	blt $s1, 2, merge_row_error #numrows < 2
	blt $s2, 2, merge_row_error #numcols < 2
	bltz $s3, merge_col_error #row < 0
	bge $s3, $s2, merge_col_error #row >= numrows 

	
	move $a0, $s3
	li $a1, 0
	move $a2, $s1
	move $a3, $s2 
	jal get_cell_offset
	add $s0, $s0, $v0 #address of first cell in row
	

	move $a0, $s3
	move $a1, $s2
	addi $a1, $a1, -1
	move $a2, $s1
	move $a3, $s2 
	jal get_cell_offset
	add $s5, $s5, $v0  #address of last cell in row
	
	
	bnez $s4, right_to_left
	
	merge_row_ltr_loop:
	bge $s0, $s5, merge_row_done #cell addr == last cell
	lh $t0, 0($s0) #first val in pair
	lh $t1, 2($s0) #second val in pair
	bne $t1, $t0, ltr_not_equal #firstval == secondval
	beq $t1, -1, ltr_not_equal #vals != -1
	add $t2, $t0, $t1 #firstval + secondval
	li $t3, -1
	sh $t2, 0($s0) #save sum
	sh $t3, 2($s0) #save -1 in second cell
	ltr_not_equal:
	addi $s0, $s0, 2
	j merge_row_ltr_loop
	
	right_to_left:
	bne $s4, 1, merge_row_error #dir != 0,1
	
	merge_row_rtl_loop:
	ble $s5, $s0, merge_row_done #cell addr == first cell
	lh $t0, 0($s5) #first val in pair
	lh $t1, -2($s5) #second val in pair
	bne $t1, $t0, rtl_not_equal #firstval == secondval
	beq $t1, -1, rtl_not_equal #vals != -1
	add $t2, $t0, $t1 #firstval + secondval
	li $t3, -1
	sh $t2, 0($s5) #save sum
	sh $t3, -2($s5) #save -1 in second cell
	rtl_not_equal:
	addi $s5, $s5, -2
	j merge_row_rtl_loop
	
	
	merge_row_done:
	move $a0, $s3
	li $a1, 0
	move $a2, $s1
	move $a3, $s2
	jal get_cell_offset
	add $t0, $s7, $v0 #addr of board[row][0]
	li $v0, 0 #init counter
	li $t3, 0 #colcounter
	count_tiles_loop_row:
	beq $t3, $s2, return_merge_row #colcounter == numcols
	lh $t4, 0($t0) #lh from cell adr
	beq $t4, -1, empty_cell_row
	addi $v0, $v0, 1 #counter ++
	empty_cell_row:
	addi $t0, $t0, 2 #cell adr+= 2
	addi $t3, $t3, 1 #rowcounter++
	j count_tiles_loop_row
	merge_row_error:
	li $v0, -1
    ############################################
    	return_merge_row:	
	lw $s0, 0($sp)		# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
    
    jr $ra

merge_col:
    #Define your code here
    ############################################
    	li $v0, -1
	lw $t0, 0($sp) 
	
	addi $sp, $sp, -36	# save registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0 #board addr
	move $s1, $a1 #numrows
	move $s2, $a2 #numcols
	move $s3, $a3 #col
	move $s4, $t0 #dir
	
	blt $s1, 2, merge_col_error #numrows < 2
	blt $s2, 2, merge_col_error #numcols < 2
	bltz $s3, merge_col_error #col < 0
	bge $s3, $s2, merge_col_error #col >= numcols 

	
	bnez $s4, top_to_bottom
	addi $s5, $s1, 2 #rowcounter = numrows - 2
	
	merge_col_btt_loop:
	blez $s5, merge_col_done #rowcounter <= 0
	move $a0, $s5 
	move $a1, $s3
	move $a2, $s1
	move $a3, $s2
	jal get_cell_offset
	add $s6, $s0, $v0 #addr of board[rowcounter][col]
	
	addi $a0, $s5, -1
	move $a1, $s3
	move $a2, $s1
	move $a3, $s2
	jal get_cell_offset
	add $s7, $s0, $v0 #addr of board[rowcounter - 1][col]
	
	lh $t1, 0($s6) #board[rowcounter][col]
	lh $t2, 0($s7) #board[rowcounter - 1][col]
	bne $t1, $t2, btt_not_equal #board[rowcounter][col] == board[rowcounter - 1][col]
	beq $t1, -1, btt_not_equal # != -1
	
	add $t3, $t1, $t2 #sum
	sh $t3, 0($s6) #store sum in board[rowcounter][col]
	li $t3, -1
	sh $t3, 0($s7) #store -1 in board[rowcounter - 1][col]
	
	
	btt_not_equal:
	addi $s5, $s5, -1 #rowcounter--
	
	j merge_col_btt_loop
	
	top_to_bottom:
	li $s5, 1 #rowcounter
	
	merge_col_ttb_loop:
	bne $s4, 1, merge_col_error #dir != 0,1
	
	bge $s5, $s1, merge_col_done #rowcounter >= numrows
	move $a0, $s5 
	move $a1, $s3
	move $a2, $s1
	move $a3, $s2
	jal get_cell_offset
	add $s6, $s0, $v0 #addr of board[rowcounter][col]
	
	addi $a0, $s5, -1
	move $a1, $s3
	move $a2, $s1
	move $a3, $s2
	jal get_cell_offset
	add $s7, $s0, $v0 #addr of board[rowcounter - 1][col]
	
	lh $t1, 0($s6) #board[rowcounter][col]
	lh $t2, 0($s7) #board[rowcounter - 1][col]
	bne $t1, $t2, ttb_not_equal #board[rowcounter][col] == board[rowcounter - 1][col]
	beq $t1, -1, ttb_not_equal # != -1
	
	add $t3, $t1, $t2 #sum
	sh $t3, 0($s7) #store sum in board[rowcounter - 1][col]
	li $t3, -1
	sh $t3, 0($s6) #store -1 in board[rowcounter][col]
	
	ttb_not_equal:
	addi $s5, $s5, 1 #rowcounter++
	j merge_col_ttb_loop

	merge_col_done:
	li $a0, 0 
	move $a1, $s3
	move $a2, $s1
	move $a3, $s2
	jal get_cell_offset
	add $t0, $s0, $v0 #addr of board[0][col]
	li $t3, 2
	mul $t1, $s2, $t3 #numcols * 2
	li $v0, 0 #init counter
	li $t3, 0 #rowcounter
	count_tiles_loop_col:
	beq $t3, $s1, return_merge_col #rowcounter == numrows
	lh $t4, 0($t0) #lh from cell adr
	beq $t4, -1, empty_cell_col
	addi $v0, $v0, 1 #counter ++
	empty_cell_col:
	add $t0, $t0, $t1 #cell adr+= rowsize
	addi $t3, $t3, 1 #rowcounter++
	j count_tiles_loop_col
	merge_col_error:
	li $v0, -1
    ############################################
    	return_merge_col:	
	lw $s0, 0($sp)		# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
    
    jr $ra


shift_row:
    #Define your code here
    ############################################
       	li $v0, -1
	lw $t0, 0($sp) 
	
	addi $sp, $sp, -36	# save registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0 #board addr
	move $s1, $a1 #numrows
	move $s2, $a2 #numcols
	move $s3, $a3 #row
	move $s4, $t0 #dir
	
	bnez $s4, shift_right
	
	li $s6, 1 #col counter
	li $s7, 0 #shift counter
	
	shift_left_loop:
	bge $s6, $s2, shift_row_done
	
	move $a0, $s3 
	move $a1, $s6
	move $a2, $s1
	move $a3, $s2
	jal get_cell_offset
	add $s5, $s0, $v0 #addr of board[row][colcounter]
	lh $t0, 0($s5) 
	beq $t0, -1, no_shift_left #board[row][colcounter] == -1
	
	move $t0, $s5 #cell adr
		shift_left_cell_loop:
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		move $a0, $s3 #row
		li $a1, 0 #col = 0
		move $a2, $s1 #numrows
		move $a3, $s2 #numcols
		jal get_cell_offset
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		add $t3, $v0, $s0	
		ble $t0, $t3, shift_left_place #check if end of row
		
		lh $t1, -2($t0) #lh from cell adr
		bne $t1, -1, shift_left_place
		

		addi $t0, $t0, -2 #cell addr -= 2
		j shift_left_cell_loop
		
	shift_left_place:
	beq $t0, $s5, no_shift_left
	addi $s7, $s7, 1 #shift counter++
	
	lh $t2, 0($s5) #load val in board[row][colcounter]
	li $t3, -1
	sh $t3, 0($s5) #store -1 in board[row][colcounter]
	sh $t2, 0($t0) #store val in cell addr
	
	no_shift_left:
	addi $s6, $s6, 1
	j shift_left_loop
	
	shift_right:
	bne $s4, 1, return_shift_row
	
	move $s6, $s2 
	addi $s6, $s6, -2 #colcounter = numcols - 2
	li $s7, 0 #shift counter
	
	shift_right_loop:
	bltz $s6, shift_row_done
	
	move $a0, $s3 
	move $a1, $s6
	move $a2, $s1
	move $a3, $s2
	jal get_cell_offset
	add $s5, $s0, $v0 #addr of board[row][colcounter]
	lh $t0, 0($s5) 
	beq $t0, -1, no_shift_right #board[row][colcounter] == -1
	
	move $t0, $s5 #cell adr
		shift_right_cell_loop:
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		move $a0, $s3 #row
		move $a1, $s2 #numcols
		addi $a1, $a1, -1 #numcols - 1
		move $a2, $s1
		move $a3, $s2
		jal get_cell_offset
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		add $t3, $v0, $s0	
		bge $t0, $t3, shift_right_place #check if end of row
		
		lh $t1, 2($t0) #lh from cell adr + 2
		bne $t1, -1, shift_right_place
		addi $t0, $t0, 2 #cell addr += 2
		j shift_right_cell_loop
		
	shift_right_place:
	beq $t0, $s5, no_shift_right
	addi $s7, $s7, 1 #shift counter++
	
	lh $t2, 0($s5) #load val in board[row][colcounter]
	li $t3, -1
	sh $t3, 0($s5) #store -1 in board[row][colcounter]
	sh $t2, 0($t0) #store val in cell addr
	
	no_shift_right:
	addi $s6, $s6, -1
	j shift_right_loop
	
   	shift_row_done:
	move $v0, $s7
    ############################################
    	return_shift_row:	
	lw $s0, 0($sp)		# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
    
    jr $ra

shift_col:
    #Define your code here
    ############################################
  	li $v0, -1
	lw $t0, 0($sp) 
	
	addi $sp, $sp, -36	# save registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0 #board addr
	move $s1, $a1 #numrows
	move $s2, $a2 #numcols
	move $s3, $a3 #col
	move $s4, $t0 #dir
	
	bnez $s4, shift_down
	
	li $s5, 1 #rowcounter
	li $s6, 0 #num of shifts
	
	
	shift_up_loop:
	bge $s5, $s1, shift_col_done
	
	move $a0, $s5
	move $a1, $s3
	move $a2, $s1
	move $a3, $s2
	jal get_cell_offset
	add $s7, $v0, $s0 #addr of board[rowcounter][col]
	lh $t0, 0($s7)
	beq $t0, -1, no_shift_up
	
	move $t1, $s5 #inner row counter
		shift_up_cell_loop:
		blez $t1, shift_up_place #end of col
		
		addi $sp, $sp, -4
		sw $t1, 0($sp)
		addi $a0, $t1, -1
		move $a1, $s3
		move $a2, $s1
		move $a3, $s2
		jal get_cell_offset
		lw $t1, 0($sp) 
		addi $sp, $sp, 4
		add $t2, $s0, $v0 #addr of board[innerrowcounter - 1][col]
		lh $t3, 0($t2) #board[innerrowcounter - 1][col]
		
		bne $t3, -1, shift_up_place #check if there is room to shift to next cell
		addi $t1, $t1, -1
		
		j shift_up_cell_loop
		  
	shift_up_place:
	beq $t1, $s5, no_shift_up #rowcounter == inner rowcounter
	addi $s6, $s6, 1 #shiftcounter++
	
	lh $t9, 0($s7) #board[rowcounter][col]
	
	addi $sp, $sp, -8
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $t1 #row
	sw $s3, 0($sp) #col
	sw $t9, 4($sp) #val
	jal place #board[innerrowcounter][col] = val
	addi $sp, $sp, 8 
	

	li $t0, -1
	sh $t0, 0($s7) #board[rowcounter][col] = -1

	
	no_shift_up:
	addi $s5, $s5, 1 #rowcounter++
	j shift_up_loop
	
	shift_down:
	bne $s4, 1, return_shift_col
		
	move $s5, $s1
	addi $s5, $s5, -2 #rowcounter = numrows - 2
	li $s6, 0 #num of shifts
	
	
	shift_down_loop:
	bltz $s5, shift_col_done
	
	move $a0, $s5
	move $a1, $s3
	move $a2, $s1
	move $a3, $s2
	jal get_cell_offset
	add $s7, $v0, $s0 #addr of board[rowcounter][col]
	lh $t0, 0($s7)
	beq $t0, -1, no_shift_down
	
	move $t1, $s5 #inner row counter
		shift_down_cell_loop:
		addi $t5, $s1, -1
		bge $t1, $t5, shift_down_place #innerrowcounter == numrows - 1
		
		addi $sp, $sp, -4
		sw $t1, 0($sp)
		addi $a0, $t1, 1
		move $a1, $s3
		move $a2, $s1
		move $a3, $s2
		jal get_cell_offset
		lw $t1, 0($sp) 
		addi $sp, $sp, 4
		add $t2, $s0, $v0 #addr of board[innerrowcounter + 1][col]
		lh $t3, 0($t2) #board[innerrowcounter + 1][col]
		
		bne $t3, -1, shift_down_place #check if there is room to shift to next cell
		addi $t1, $t1, 1
		
		j shift_down_cell_loop
		  
	shift_down_place:
	beq $t1, $s5, no_shift_down #rowcounter == inner rowcounter
	addi $s6, $s6, 1 #shiftcounter++
	
	lh $t9, 0($s7) #board[rowcounter][col]
	
	addi $sp, $sp, -8
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $t1 #row
	sw $s3, 0($sp) #col
	sw $t9, 4($sp) #val
	jal place #board[innerrowcounter][col] = val
	addi $sp, $sp, 8 
	

	li $t0, -1
	sh $t0, 0($s7) #board[rowcounter][col] = -1

	
	no_shift_down:
	addi $s5, $s5, -1 #rowcounter--
	j shift_down_loop
	
	
    
    
    
      	shift_col_done:
	move $v0, $s6
    ############################################
    	return_shift_col:	
	lw $s0, 0($sp)		# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
    
    jr $ra

check_state:
    #Define your code here
    ############################################
    	addi $sp, $sp, -36	# save registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0 #board addr
	move $s1, $a1 #num rows
	move $s2, $a2 #num cols 
	
	
	mul $s5, $s1, $s2 #numrows * numcols
	li $t4, 2 
	mul $s5, $s5, $t4 #numrows * numcols * 2
	add $s5, $s5, $s0 #addr + numrows*numcols*2 
	addi $s5, $s5, -2 #addr + numrows*numcols*2 - 2 (max addr)
	
	move $t0, $s0 #cell addr 
	check_win_loop:
		lh $t1, 0($t0)
		bge $t1, 2048, return_check_won
		bge $t0, $s5, check_win_loop_done #board checked
		addi $t0, $t0, 2
		j check_win_loop
	check_win_loop_done:
	
	li $s6, 0 #state
	move $s7, $s0 #cell addr
	li $t0, 0 #colcounter
	li $t1, 0 #rowcounter
	check_loop:
		bgt $s7, $s5, check_loop_done #end of board
		beq $t1, $s1, check_loop_done #end of board
		lh $t2, 0($s7) #board[cell addr]
		beq $t2, -1, return_check_inprogress #cell is empty
		beq $t2, 2048, return_check_won #game is won
	
		beqz $t0, beginning_of_row #is there a cell to the left?
		lh $t3, -2($s7) #lh from cell to the left
		beq $t3, $t2, return_check_inprogress #cell to the left can be merged
		beginning_of_row:
		
		addi $t6, $s2, -1
		beq $t0, $t6, end_of_row #colcounter == numcols -1
		lh $t3, 2($s7) #lh from cell to the right
		beq $t3, $t2, return_check_inprogress #cell to the right can be merged
		addi $t0, $t0, 1 #colcounter++
		j check_col
		end_of_row:
		li $t0, 0 #reset colcounter
		
		check_col:
		beqz $t1, beginning_of_col
		li $t9, 2
		mul $t8, $t9, $s2 #numcols * 2
		sub $t3, $s7, $t8 #addr of cell above = cell addr - numcols*2
		lh $t4, 0($t3) #lh from cell above
		beq $t4, $t2, return_check_inprogress #cell above can be merged 
		
		beginning_of_col:
		addi $t6, $s1, -1
		beq $t0, $t6, increment_address #rowcounter == numrow -1
		li $t9, 2
		mul $t8, $t9, $s2 #numcols * 2
		add $t3, $s7, $t8 #addr of cell below = cell addr + numcols*2
		lh $t4, 0($t3) #lh from cell below
		beq $t4, $t2, return_check_inprogress #cell below can be merged 
		
		bnez $t0, increment_address #check if colcounter was reset  
		addi $t1, $t1, 1 #rowcounter++
		increment_address:
		addi $s7, $s7, 2 #move to next cell
	 	j check_loop
	############################################
	check_loop_done:
	li $v0, -1
	j return_check
	return_check_won:
	li $v0, 1
	j return_check
	return_check_inprogress:
	li $v0, 0
	return_check:
    ############################################
   	lw $s0, 0($sp)		# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
    jr $ra

user_move:
 #Define your code here
    ############################################
	addi $sp, $sp, -36	# save registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	
	move $s0, $a0 #board addr
	move $s1, $a1 #numrows
	move $s2, $a2 #numcols
	move $s3, $a3 #dir
	
	beq $s3, 'R', right_move
	beq $s3, 'U', up_move
	beq $s3, 'D', down_move
	beq $s3, 'L', left_move
	j return_move_error
	#left_move
	
	left_move:
	li $s4, 0 #rowcounter
	li $s5, 0 #shift dir
	li $s6, 0 #merge dir 
	j horiz_move_loop
	
	right_move:
	li $s4, 0 #rowcounter
	li $s5, 1 #shift dir
	li $s6, 1 #merge dir 
	
	horiz_move_loop: 
		bge $s4, $s1, horiz_move_loop_done #counter == numrows
		
		move $a0, $s0 #addr
		move $a1, $s1 #numrows
		move $a2, $s2 #numcols
		move $a3, $s4 #row
		addi $sp, $sp, -4
		sw $s5, 0($sp) #shift dir
		jal shift_row
		addi $sp, $sp, 4
		
		move $a0, $s0 #addr
		move $a1, $s1 #numrows
		move $a2, $s2 #numcols
		move $a3, $s4 #row
		addi $sp, $sp, -4
		sw $s6, 0($sp) #merge dir
		jal merge_row
		addi $sp, $sp, 4
		
		move $a0, $s0 #addr
		move $a1, $s1 #numrows
		move $a2, $s2 #numcols
		move $a3, $s4 #row
		addi $sp, $sp, -4
		sw $s5, 0($sp) #shift dir
		jal shift_row
		addi $sp, $sp, 4
		addi $s4, $s4, 1
		
		j horiz_move_loop
		
	horiz_move_loop_done:
	j check_state_move
	
	up_move:
	li $s4, 0 #colcounter
	li $s5, 0 #shift dir
	li $s6, 1 #merge dir 
	j vertical_move_loop
	down_move:
	li $s4, 0 #colcounter
	li $s5, 1 #shift dir
	li $s6, 0 #merge dir 
	vertical_move_loop:
		bge $s4, $s2, vertical_move_loop_done #colcounter == numcols
		
		move $a0, $s0 #addr
		move $a1, $s1 #numrows
		move $a2, $s2 #numcols
		move $a3, $s4 #col
		addi $sp, $sp, -4
		sw $s5, 0($sp) #shift dir
		jal shift_col
		addi $sp, $sp, 4
		beq $v0, -1, return_move_error
		
		move $a0, $s0 #addr
		move $a1, $s1 #numrows
		move $a2, $s2 #numcols
		move $a3, $s4 #col
		addi $sp, $sp, -4
		sw $s6, 0($sp) #merge dir
		jal merge_col
		addi $sp, $sp, 4
		beq $v0, -1, return_move_error
		
		move $a0, $s0 #addr
		move $a1, $s1 #numrows
		move $a2, $s2 #numcols
		move $a3, $s4 #row
		addi $sp, $sp, -4
		sw $s5, 0($sp) #shift dir
		jal shift_col
		addi $sp, $sp, 4
		beq $v0, -1, return_move_error
		addi $s4, $s4, 1
		
		
	
	j vertical_move_loop
	vertical_move_loop_done:
	
	check_state_move:
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal check_state
	move $v1, $v0
	li $v0, 0
	
    ############################################
    	j return_move
    	return_move_error:
    	li $v0, -1
    	li $v1, -1
    	return_move:
        lw $s0, 0($sp)		# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
   
    jr $ra


#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary

#place all data declarations here


