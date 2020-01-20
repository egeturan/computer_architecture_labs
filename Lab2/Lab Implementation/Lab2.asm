.data
  	welcomeToMonitor: .asciiz "Welcome to the monitör "
  	printMenu: .asciiz "\nOptions are:\n a) Create an array and enter its values: \n b) BubbleSort the array: \n c) 2Ndmin2NdMax: \n d) Find the median of the sorted array: \n e)Print the array \n f)quit \n" 
  	opA: .asciiz "a"
	opB: .asciiz "b"
	opC: .asciiz "c"
	opD: .asciiz "d"
	opE: .asciiz "e"
	opF: .asciiz "f"
	optionS: .space 4
	pleaseEnterTheLength: .asciiz "Please enter the length of the array "
	pleaseEnterNums: .asciiz "Please enter numbers respectively "
	sessionIsTerminated: .asciiz "Session is terminated "
	welcomeToMedian: .asciiz "Median calculation is started "
	theMedianIs: .asciiz "The Median (o) is: "
	theMedianIs2: .asciiz "The Median (e) is: "
	secondMin: .asciiz "Second min is: " 
	secondMax: .asciiz "\nSecond max is: " 
	
	
	array1: .space 80
	enterInts: .asciiz "Please enter numbers "
	control: .asciiz "**************"
	sortedArrayIs: .asciiz "Sorted Array is: "
	interval: .asciiz "  "

.text

__start:

	  #Prompt for entering integer count
		li $v0, 4
		la $a0, welcomeToMonitor
		syscall	
	  
	  menuLoop:
	  			
				jal menuChecker	  #I need to save the address of the loop in to $ra
				returnHere3:
					
				#save header of the array and the size of the array
				add $s2, $0, $v0 #s2 has arrays header
				add $s3, $0, $v1 #s3 has arrays length					
																				
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
				
				#initialize arguments
				add $a0, $0, $s2 #s2 has arrays header
				add $a1, $0, $s3 #s3 has arrays length		
				
				#now control  the options
				beq $s4, $t4, readArray
				beq $s4, $t5, bubbleSort
				beq $s4, $t6, Ndmin2NdMax
				beq $s4, $t7, median
				beq $s4, $t8, printTheArray
				beq $s4, $t9, quit
				
				#sustain menu while user clicks to the d to quit
				j menuLoop
	
	readArray:
	#Prompt for entering integer count
	li $v0, 4
	la $a0, pleaseEnterTheLength
	syscall
	
	#Get the count
	li $v0, 5
	syscall
		
	
	#store the result 
	move $t0, $v0 # get the arraysize
	
	
	#print the values according to index
	# now I now the length it is in the t0	li $v0, 1
	#	move $a0, $t0
	#	syscall
	
	#v1 has number of integers
	move $v1, $t0
	
	sll $t0, $t0, 2
	
	#SBRK Dynamic allocation
	li $a0 8 #enough space for entered amount of integers
	li $v0 9 #syscall 9 (sbrk)
	syscall
	
	#v0 contains address of allocated memory
	add $s1, $0, $v0
	
	#s6 will protect the header
	add $s6, $0, $v0
	
	addi $s0, $0, 0 #to count the number of items in the array
	
	#Prompt for entering integers into the array
	li $v0, 4
	la $a0, pleaseEnterNums
	syscall
	
	
	while:  
		beq $v1, $s0, leave
		
		#Get values to enter into the array
		li $v0, 5
		syscall
		
		move $t4, $v0
		sb $t4, 0($s1) 
		
		addi $s1, $s1, 4
		addi $s0, $s0, 1
		j while
	
	leave:	
		#v1 is still the length of the array
		add $v0, $0, $s6 #s6 protects the dynamic array's header
		
		jr $ra	
					
	bubbleSort:	
		
	add $s2, $0, $a0
	add $s6, $0, $a0
	add $s7, $0, $a0
	
	add $s0, $0, $a1 # a1 is transferred to the s0, s0 is the size
	
		#s0 is the n
		
		addi $s4, $0, 1 #my pass
		
		addi $t2, $0, 0
		addi $t3, $0, 0	
		
		
		while2:
			
			addi $t0, $0, 0 #my boolean value sorted
			
			beq $s4, $s0, leaveTheLoop # pass < n 
			
			bne $t0, $0, leaveTheLoop # !sorted
			# add !sorted here
			
			#these are needed means in index = 0
			addi $s5, $0, 0 #index, int index = 0
			add $s2, $0, $s6 #take array address for the first index
			
			#create one more header to reach next
			add $s3, $0, $s2 #create s3 to reach next of the index
			
			while3:  #second loop
			
			# next 2 lines means, index < n - pass	
			sub $t1, $s0, $s4 #index < n - pass 
			beq $s5, $t1, returnWhile2 #index < n - pass
				
			add $s3, $s3, 4 # int nextIndex = index + 1; 
							
			#tak values to compare
			lb $t2, 0($s2)  #s2 is the header, t2 has theArray[index]
			lb $t3, 0($s3)  #s3 is the address of the next item, theArray[nextIndex	
			
			bgt $t2, $t3, makeSwap
			returnHere:
												
			add $s2, $s2, 4 # header need to move
			
			addi $s5, $s5, 1
			
			j while3
				
			
			returnWhile2:
			
			addi $s4, $s4, 1 #pass++
			
		j while2
	
	makeSwap:
		sb $t3, 0($s2) 
		sb $t2, 0($s3)
		
		addi $t0, $0, 1	 #sorted = false
			
		j returnHere	
		
	leaveTheLoop:	
		
		add $v0, $0, $s7 #v0 has the header of the array
		add $v1, $0, $s0 #v1 has the length of the array
		
		jr $ra
			
	Ndmin2NdMax:
						
		jal bubbleSort 
		
		add $a2, $0, $v0 #a2 has arrays header
		add $a3, $0, $v0 #a3 has arrays header
		add $s7, $0, $v0 #v0 has the header of the array
		add $s6, $0, $v1 #s6 has the length
		
		#a0 address
		#a1 is the length
		
		#array headers
		
		add $t0, $0, 0
		
		add $a2, $a2, 4 #a2 is the second min the array
		
		lb $t0, 0($a2) 
		
		li $v0, 4
		la $a0, secondMin
		syscall
		
		#print the values according to index
		li $v0, 1
		move $a0, $t0
		syscall	
		
		add $t0, $0, 0
		add $t1, $0, 0
		
		sll $a1, $a1, 2
		addi $a1, $a1, -8
		
		add $a3, $a3, $a1
		lb $t0, 0($a3)
		
		li $v0, 4
		la $a0, secondMax
		syscall
		
		#print the values according to index
		li $v0, 1
		move $a0, $t0
		syscall	
				
		add $v0, $0, $s7
		add $v1, $0, $s6 #s6 has arrays length			
						
		j returnHere3
						
	median: 
		
		#a0 is the header
		#a1 is the length	
		
		#array headers
		
		jal bubbleSort
						
		#array legnth
		add $a2, $0, $v0 #s2 has arrays header
		
		add $a3, $0, $v0 
		add $s7, $0, $v0 
		
		add $s3, $0, $v1 #s3 has arrays length
		
		addi $t0, $0, 0
		addi $t1, $0, 2
		addi $t2, $0, 0
		addi $t3, $0, 0
		addi $t4, $0, 0
		
		div $s3, $t1 # divide length s3 to t1
		mfhi $t0
		
		beq $t0, $0, evenMedian
		bne $t0, $0, oddMedian
		
	evenMedian:
	
		div $s3, $t1
		mflo $t2
		# 8/2 = 4 , 4*4 = 16, t2 has the location
		sll $t2, $t2, 2
		
		#header + 12
		add $a2, $a2, $t2
		addi $a2, $a2, -4
			
		 #header + 16 
		add $a3, $a3, $t2
		
		lb $t3, 0($a2)
		lb $t4, 0($a3)
		
		add $t4, $t4, $t3 #sum of the middle 2 number
		
		div $t4, $t1
		mflo $t4 #t4 has the average of the two numbers
		
		li $v0, 4
		la $a0, theMedianIs2
		syscall
			
		#print the values according to index
		li $v0, 1
		move $a0, $t4
		syscall	
																										
		add $v0, $0, $s7
		add $v1, $0, $s3 #s3 has arrays length	
																																																																												
		j returnHere3
		
	oddMedian:
		# 7 / 2 = 3
		div $s3, $t1
		mflo $t2		
		
		# 4 * 3 = 12
		sll $t2, $t2, 2
		
		#print the values according to index
		li $v0, 1
		move $a0, $t2
		syscall	
		
		#header + 12
		add $a2, $a2, $t2
		
		lb $t4, 0($a2)

		li $v0, 4
		la $a0, theMedianIs
		syscall
			
		#print the values according to index
		li $v0, 1
		move $a0, $t4
		syscall	
	
		add $v0, $0, $s7
		add $v1, $0, $s3 #s3 has arrays length	
		
		j returnHere3																										
					
												
																								
	
	printTheArray:
	
		add $s6, $0, $a0
		add $s7, $0, $a0
	
		add $s0, $0, $a1 # a1 is transferred to the s0, s0 is the size
		
		#create interval among the numbers
		li $v0, 4
		la $a0, sortedArrayIs
		syscall
		
		addi $t0, $0, 0 #count increases
			
	while4: 
		beq $t0, $s0, leave2

		lb $t5, 0($s6) #s1 reached to the end of the array now I have reached its end already
		
		#print the values according to index
		li $v0, 1
		move $a0, $t5
		syscall
	
		#create interval among the numbers
		li $v0, 4
		la $a0, interval
		syscall

		addi $t0, $t0, 1 #count increases	
			
		addi $s6, $s6, 4
		
		j while4
		
	leave2:	
	
		add $v0, $0, $s7 #v0 has the header of the array
		add $v1, $0, $s0 #v1 has the length of the array
		
		j returnHere3
		
	quit:
		li $v0, 10
		syscall		