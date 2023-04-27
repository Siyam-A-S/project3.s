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