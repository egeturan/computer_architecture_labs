.data
  	welcomeToMonitor: .asciiz "Welcome to the monitör "
  	printMenu: .asciiz "\n Options are:\n a) Ask the user the matrix size in terms of its dimensions (N),: \n b) Allocate an array with proper size using syscall code 9 \n c)Ask user the matrix element to be accessed and display the content: \n d)Obtain summation of matrix elements row-major (row by row) summation \n e)Obtain summation of matrix elements column-major (column by column) summation \n f)quit \n" 
  	opA: .asciiz "a"
	opB: .asciiz "b"
	opC: .asciiz "c"
	opD: .asciiz "d"
	opE: .asciiz "e"
	opF: .asciiz "f"
	optionS: .space 4
	
	array1: .space 80
	enterInts: .asciiz "Please enter numbers "
	control: .asciiz "**************"
	interval: .asciiz "  "
	line: .asciiz "\n"
	
	enteri: .asciiz "Please enter place i: "
	enterj: .asciiz "Please enter place j: "
	pleaseEnterTheDimension: .asciiz "Please enter the N matrix size \n"
	wantedElementIs: .asciiz "Wanted element is: "
	columnSumIs: .asciiz "Column Sum is: "
	rowSumIs: .asciiz "Row sum is: "

.text

__start:

	  #Prompt for entering integer count
		li $v0, 4
		la $a0, welcomeToMonitor
		syscall	
	  
	  menuLoop:
	  			
				jal menuChecker	  #I need to save the address of the loop in to $ra
				returnHere3:
																
				menuChecker:
				
				#Print options
				li $v0, 4
				la $a0, printMenu
				syscall   
				
		  		#Take the option
				li $v0, 8
				la $a0, optionS 
				li $a1, 4
				syscall
				
				#take address of the array
				la $s1, array1
				#take the first char of the optionS
				lb $s4, optionS($zero)
				
				#In order to control the a b c d options
				lb $t4, opA($zero)
				lb $t5, opB($zero)
				lb $t6, opC($zero)
				lb $t7, opD($zero)									
				lb $t8, opE($zero)
				lb $t9, opF($zero)	
				
				addi $s7, $0 ,0

				#now control  the options
				beq $s4, $t4, askDimension
				beq $s4, $t5, allocateAnArray
				beq $s4, $t6, askElementAndDisplayContent
				beq $s4, $t7, rowByrowSum
				beq $s4, $t8, columnBycolumnSum
				beq $s4, $t9, quit
				
				#sustain menu while user clicks to the d to quit
				j menuLoop
	
	askDimension:
	#Prompt for entering integer count
	li $v0, 4
	la $a0, pleaseEnterTheDimension
	syscall
	
	addi $v0, $0, 50
	
	#store the result 
	move $a3, $v0 # get the matrix dimension
	
	
	#control the value N
	li $v0, 1
		move $a0, $a3
		syscall
	
	
	j returnHere3
	
	allocateAnArray:
	
		addi $t0, $0, 0
		addi $t1, $0, 0
		addi $t2, $0, 0
		addi $t3, $0, 0
		addi $t4, $0, 0
		addi $t5, $0, 0
		addi $t6, $0, 0
		addi $t7, $0, 0
		
		mul $t6, $a3, $a3  #a3 is the N and t6 is the square which needed elemtns in the matricsx number of elements
		
		#SBRK Dynamic allocation
		li $a0, 400 #enough space for entered amount of integers
		li $v0, 9 #syscall 9 (sbrk)
		syscall
		
		move $s2, $v0   #pointer to the first element of the array
		
		addi $t5, $0, 1
		
		add $t4, $0, $s2 #coppied the s2
		
		#t7 is the counter
		
		while: 
		beq $t6, $t7, leave
		
	  	#put t5 values into the indices
	  	sb $t5, 0($t4) 
		
		addi $t5, $t5, 1  #increase the value that will be inserted
		addi $t4, $t4, 4
		addi $t7, $t7, 1
		j while
		
		
	leave:	
	
		#create interval among the numbers
		li $v0, 4
		la $a0, control
		syscall
	
		addi $t5, $0, 0
		add $t4, $0, $s2 #coppied the s2
		addi $t7, $0, 0

		j returnHere3
		
	
	askElementAndDisplayContent:
		
		addi $t0, $0, 0
		addi $t1, $0, 0
		addi $t2, $0, 0
		addi $t3, $0, 0
		addi $t4, $0, 0
		addi $t5, $0, 0
		addi $t6, $0, 0
		addi $t7, $0, 0
		
		#Prompt for entering integer count
		li $v0, 4
		la $a0, enteri
		syscall	
		
		#Get values to enter into the array
		li $v0, 5
		syscall

		move $t0, $v0
		
		#Prompt for entering integer count
		li $v0, 4
		la $a0, enterj
		syscall	
		
		#Get values to enter into the array
		li $v0, 5
		syscall
		
		move $t1, $v0
		
		#(j - 1) x N x 4 + (i - 1) x 4
		
		addi $t1, $t1, -1  #(j - 1)
		sll $t2, $a3, 2 # t2 = N * 4
		addi $t0, $t0, -1 #(i - 1)
		mul $t2, $t1, $t2 # (j - 1) *  t2 = N * 4
		sll $t3, $t0, 2 #(i - 1) x 4
		add $t4, $t3, $t2  #(j - 1) x N x 4 + (i - 1) x 4
		
		add $t5, $s2, $t4 #place of the wanted element
		
		lb $t6, 0($t5)
		
		#Prompt for entering integer count
		li $v0, 4
		la $a0, wantedElementIs
		syscall
		
		#print the values according to index
		li $v0, 1
		move $a0, $t6
		syscall
				
		j returnHere3
		
	rowByrowSum:
	
		#message
		li $v0, 4
		la $a0, rowSumIs
		syscall
		
		addi $t0, $0, 0
		addi $t1, $0, 0
		addi $t2, $0, 0
		addi $t3, $0, 0
		addi $t5, $s2, 0
		addi $t6, $0, 0
		addi $t7, $0, 0
		addi $t8, $0, 4
		addi $t9, $0, 0
	
		#increment value
		sll $t9, $a3, 2
						
		while5: 
		beq $t1, $a3, leave5
		
		lb $t2, 0($t5)
		add $t6, $t6, $t2	
		

		add $t5, $t5, $t9
		addi $t1, $t1, 1
		j while5
		
		leave5:
		
		#print this row sum
		li $v0, 1
		move $a0, $t6
		syscall	
		
		#Prompt for entering integer count
		li $v0, 4
		la $a0, line
		syscall	
		
		addi $t7, $t7, 1
		
		beq $t7, $a3, leave6
		
		addi $t5, $s2, 0
		add $t5, $t8, $t5
		addi $t8, $t8, 4
			
		addi $t1, $0, 0
		addi $t6, $0, 0
		j while5
		
		leave6:
		
		j returnHere3	
		
		
	columnBycolumnSum:
		#message
		li $v0, 4
		la $a0, columnSumIs
		syscall
	
		addi $t0, $0, 0
		addi $t1, $0, 0
		addi $t2, $0, 0
		addi $t3, $0, 0
		addi $t5, $s2, 0
		addi $t6, $0, 0
		addi $t7, $0, 0
		
		while3: 
		beq $t1, $a3, leave3
		
		lb $t2, 0($t5)
		add $t6, $t6, $t2	
		
		addi $t5, $t5, 4
		addi $t1, $t1, 1
		j while3
		
		leave3:
		
		#print this column sum
		li $v0, 1
		move $a0, $t6
		syscall	
		
		#Prompt for entering integer count
		li $v0, 4
		la $a0, line
		syscall	
		
		addi $t7, $t7, 1
		
		beq $t7, $a3, leave4
		
		addi $t1, $0, 0
		addi $t6, $0, 0
		j while3
		
		leave4:
		
		j returnHere3	
		
	quit:
		li $v0, 10
		syscall		
