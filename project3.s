.data
	userInput: .space 1001			# to store user input (1000 characters maximum)
	invalid: .asciiz "X"			# label to store invalid input message
	comma: .asciiz ","			# label to store comma
	left_paren: .asciiz "("			# label to store left paremthesis
	right_paren: .asciiz ")"		# label to store rught parenthesis
.text

main:	
	# calculate N and M
	# My Howard ID: 03043178
	# N = 26 + (3043178 % 11) = 32
	# M = 32-10 = 22
	# Range: 0-9, a-v, A-V

	# prompt user for input
	li $v0, 8 				# read string system call
	la $a0, userInput 			# load input buffer
	li $a1, 1001 				# maximum length (including null terminator) 
	syscall 				# execute
	
	la $t0, ($a0)				# load the address of input in stack to pass to sub_a
	addi $sp, $sp, -4
	sw $t0, ($sp) 
	jal sub_a	

Exit:	li $v0, 10
	syscall

sub_a:	
	la $t1, ($ra)
	lw $t0, ($sp)
	addi $sp, $sp, 4

	Loop1:
	li $t5, 0
	addi $sp, $sp, -8
	sw $t0, ($sp)

	Loop2:
	lb $t5, ($t0)
	beq $t5, 44, pass_sub_b
	beq $t5, 10, pass_sub_b
	beq $t5, 0, pass_sub_b
	addi $t0, $t0, 1
	j Loop2

	pass_sub_b:     			# function to pass strings to second subprogram
	sw $t0, 4($sp)
	jal sub_b
	lw $t7, ($sp)
	beq $t7, -1, ErrorMsg
	
	j PrintValue

	ErrorMsg:				# print invalid message when input is invalid
	li $v0, 4				# print a string
	la $a0, invalid				# load the invalid label
	syscall					# execute print
	j Position				# jump to Postion function
	
	PrintValue:
	li $v0, 1
	addi $a0, $t7, 0
	syscall

	li $v0, 4
	la $a0, left_paren
	syscall

	li $v0, 1
	addi $a0, $t8, 0
	syscall
	
	li $v0, 4
	la $a0, right_paren
	syscall
	
	j Position

	Position:
	lw $t9, 4($sp)
	addi $sp, $sp, 8
	lb $t5, ($t9)
	beq $t5, 10, End
	beq $t5, 0, End
	beq $t5, 44, NextIndex
	
	NextIndex:
	la $t0, ($t9)
	addi $t0, $t0, 1
	li $v0, 4
	la $a0, comma
	syscall
	
	j Loop1

	End:
	la $ra, 0($t1)
	jr $ra

	
sub_b:	
	li $t8, 0
	li $t6, 0
	li $t7, 0
	
	lw $t4, ($sp)
	lw $t9, 4($sp)
	lb $t2, ($t9)
	addi $sp, $sp, 8

	Leading:		# to skip leading spaces and tabs
	lb $t3, ($t4)	# loading the subsequent bit to $t3
	beq $t3, $t2, Valid
	bne $t3, 32, Tab1	# check for leading space
	j Skip1
	
	Tab1:	bne $t3, 9, Loop3
	Skip1:	addi $t4, $t4, 1
		j Leading

	Loop3:
	lb $t3, ($t4)
	bgt $t8, 4, Invalid
	beq $t3, $t2, Valid
	beq $t3, 32, Trailing
	beq $t3, 9, Trailing

	Nums:	bgt $t3, 57, Upper		
		blt $t3, 48, Invalid		
		li $t6, -48			# assign character's value 
		j Calculations			# jump to Calculations
	