.data 
	welcome: .asciiz "Welcome to the expression program:  \n"
	valX: .asciiz "Please enter value for x :  \n"
	valY: .asciiz "Please enter value for y :  \n"
	result: .asciiz "The result is: "
	expression: .asciiz "Expression is: ((x * 2) + y) % 4   \n"

.text
	main:
	addi $t2, $zero, 4
	addi $t4, $zero, 1
	#Prompt for welcome to the program
	li $v0, 4
	la $a0, welcome
	syscall
	
	#Prompt for value x
	li $v0, 4
	la $a0, valX
	syscall
	
	#Get the x
	li $v0, 5
	syscall
	
	move $t1, $v0 # x = $t1
	
	#Prompt for value y
	li $v0, 4
	la $a0, valY
	syscall
	
	#Get the y
	li $v0, 5
	syscall
	
	move $t0, $v0 # y = $t0
	
	sll $t1, $t1, 1 # x * 2
	add $t1, $t1, $t0
	
	slt $t3 ,$t1, $zero
	beq $t3, $t4, negativeDivision
	
	div $t1, $t2
	
	mfhi $t1
	
	#Prompt for result
	li $v0, 4
	la $a0, result
	syscall
	
	#print the result value
	li $v0, 1
	addi $a0, $t1, 0
	syscall	
	
	#terminate the program
	li $v0, 10
	syscall
	
	negativeDivision:
		
	
	div $t1, $t2
	
	mfhi $t1
	
	addi $t1, $t1, 4
	
	#Prompt for result
	li $v0, 4
	la $a0, result
	syscall
	
	#print the result value
	li $v0, 1
	addi $a0, $t1, 0
	syscall	
	
	#terminate the program
	li $v0, 10
	syscall