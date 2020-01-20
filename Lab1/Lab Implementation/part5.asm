	
	.data
	array1: .space 400
	optionS: .space 4
	opA: .asciiz "a"
	opB: .asciiz "b"
	opC: .asciiz "c"
	opD: .asciiz "d"
	controll: .asciiz " "
	sumResult: .asciiz "Result of the summation is: "
	sumResult2: .asciiz "Result of the Odd number summation is: "
	terminated: .asciiz "Have a nice day, Session has been terminated"
	terminated2: .asciiz "Not a valid!!! Have a nice day, Session has been terminated"
	sumResult3: .asciiz "Result of the Even number summation is: "
	result1: .asciiz "Result of the occurrences of the given value is: "	
	oddEvenNumbers: .asciiz "Odd and Even number summation calculator\n "
	divisibleNumbers: .asciiz "Welcome to the divisible number program enter number to see how many numbers\n actually in this array which can be divided by given number:  "
	optionA: .asciiz "Please enter input number to compare "
	numberOfElements: .asciiz "Please enter number of integers: \n"
	enterElements: .asciiz "Please enter elements one by one \n"
	optionString: .asciiz "\nPlease choose choose one of the option below: \n a.Find summation of numbers stored in the array which is greater than an input number.\n b.Find summation of even and odd numbers and display them.\n c.Display the number of occurrences of the array elements divisible by a certain input number.\n d.Quit.\n"
.text
	main:
		
	la $s1, array1
	
	addi $a2, $zero, 0
	
	#Prompt for entering integer count
	li $v0, 4
	la $a0, numberOfElements
	syscall
	
	#Get the count
	li $v0, 5
	syscall
	
	#store the result 
	add $t0, $0, $v0
	
	#Prompt for entering integers one by one
	li $v0, 4
	la $a0, enterElements
	syscall	

	
	#Initialize values
	addi $t1, $0, 0 #to count
	
	slt $t1 , $t0, $0  #control the length of the array
	beq $t1, 1, terminate1
	beq $t0, $zero, terminate1
	
		
	#Initialize values
	addi $t1, $0, 0 #used variaable initlialize again
	

	while: 	
		beq $t1, $t0, leave  #to leave the loop after array values entered
		
		#Prompt for entering integers one by one
		li $v0, 4
		la $a0, controll
		syscall
		
		#Get values to enter into the array
		li $v0, 5
		syscall
		
		add $t3, $0, $v0 #take entered value v0 to t3
		
		#put into the array
		sb $t3, 0($s1)
		
		addi $t1, $t1, 1 # number of values that stored			
		addi $s1, $s1, 4 #to reach integer elements of the array incerase by 4
		
		j while
		
	leave:
			menuLoop:
				
				#Print options
				li $v0, 4
				la $a0, optionString
				syscall
				
				jal menuChecker	  #I need to save the address of the loop in to $ra   
		     		       		       		  
		       				       				       			       
		 menuChecker:
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
				lb $t8, opD($zero)									
				
				
				addi $s7, $0 ,0
				
				#now control  the options
				beq $s4, $t4, selecta
				beq $s4, $t5, selectb
				beq $s4, $t6, selectc
				beq $s4, $t8, quit
				
				#sustain menu while user clicks to the d to quit
				j menuLoop
														       		       		       
			#this is a part of the question reached with beq $s4, $t4, selecta											       		       		       										       		       		    										       		       		       
		 selecta:			
				#Prompt for entering integer count
				li $v0, 4
				la $a0, optionA
				syscall
	
				#Get number
				li $v0, 5
				syscall
				
				addi $v1, $0,  0
				
				#store the result 
				add $s2, $0, $v0 # s2 is value that will be compared
				
				
				while2: 
								
				lb $t5, 0($s1) # I need to take first byte of the string
								
				add $a1, $0, $t5 #t5 is the value of the coming index
				
		  	
				bgt $t5, $s2, summation # now this number is bigger than thus summ it to my sum
	
				returnHere: #retun from the sum to look other valyes that bigger
				
				addi $s7, $s7, 1 # to see how many elements in the array
				addi $s1, $s1, 4 #header address of the array incrementing one by one				
																																																																																																				
				beq $t1, $s7, leave2	 # when all elementss traced leae the loop			
				
				j while2		
							
		 selectb:
		 		#Prompt for entering integers one by one
				li $v0, 4
				la $a0, oddEvenNumbers
				syscall
		 		#find the sum of the even and odd numbers and display
		 		addi $v1, $0,  0
		 		addi $s6, $0,  0
		 		addi $t9, $0, 2
		 		
		 		while3:
		 			lb $t5, 0($s1) # I need to take first byte of the string	
		 			
		 			add $a1, $0, $t5 #t5 is the value of the coming index
		 			
		 			div $t5, $t9 
		 			mfhi $t5 #take remainder
		 			
		 			beq $t5, $zero, sumEven #according to the value of remainder sum it with even or odd
		 			beq $t5, 1, sumOdd
		 			
		 			returnHere2:	 	 #return from the sum	 
		 		 
		 			addi $s7, $s7, 1
					addi $s1, $s1, 4 #header address of the array incrementing one by one				
																																																																																																				
					beq $t1, $s7, leave3	 #when reached to the end of the loop leave the program	 		 
		 		 
		 			j while3 
		 		

		 selectc:          
		 		#Print divisible number string
				li $v0, 4
				la $a0, divisibleNumbers
				syscall      
				
				#Get number which is for comparison of divisible
				li $v0, 5
				syscall
		        		
		        	#Display the number of occurrences of the array elements divisible by a certain input number.
		        	addi $v1, $0,  0
		 		addi $s6, $0,  0
		 		addi $t9, $0,  2
		 		#make necessary initialization
		 		add $s2, $0, $v0 # s2 is value that will be compared
		 		
		 		beq $s2, $0, terminate1 #if entered number is 0 then not divisibke termintae
		 			         			         	
		        	while4:
		        		lb $t5, 0($s1) # I need to take first byte of the string	
		        		
		        		add $a1, $0, $t5 #t5 is the value of the coming index
		        		
		        		div $t5, $s2 
		        		mfhi $t5
		        		
		        		beq $t5, $0, countOccurrence
		        		
		        		returnHere3:
		        		
		        		addi $s7, $s7, 1
					addi $s1, $s1, 4 #header address of the array incrementing one by one				
																																																																																																				
					beq $t1, $s7, leave4		 		 
		        	
		        	
		        	j while4		        	
		        	
		  summation:      # for adding greater numbres	
		  		add $v1, $a1, $v1		  		
		  		
		  		j returnHere
		  		
		  sumEven:		  # for adding even numbres
		  		add $v1, $a1, $v1
		  		
		  		j returnHere2	
		  
		  sumOdd:	  # for adding odd numbres
		  		add $s6, $a1, $s6	
		  		
		  		j returnHere2	
		  		
		  countOccurrence:
		  
		  		addi $v1, $v1, 1	
		  		
		  		j returnHere3					
		  				   	       
		   leave2:
		   		#Prompt for entering integers one by one
				li $v0, 4
				la $a0, sumResult
				syscall
		   		
		   		#print the values according to index
				li $v0, 1
				addi $a0, $v1, 0
				syscall			   		
		   				   				   				   		
		   		# turn back to main menu
				jr $ra
				
		  leave3:
		  		#Prompt for entering integers one by one
				li $v0, 4
				la $a0, sumResult2
				syscall															
				
				#print the values according to index
				li $v0, 1
				addi $a0, $s6, 0
				syscall	
				
		  		#Prompt for entering integers one by one
				li $v0, 4
				la $a0, sumResult3
				syscall
				
				#print the values according to index
				li $v0, 1
				addi $a0, $v1, 0
				syscall	
				
				jr $ra
		
		leave4:
				#Prompt for entering integers one by one
				li $v0, 4
				la $a0, result1
				syscall
				
				#print the values according to index
				li $v0, 1
				addi $a0, $v1, 0
				syscall	
				
				jr $ra  			  		  		
		  		  		  		  		
		quit:	
			#Prompt for entering integers one by one
			li $v0, 4
			la $a0, terminated
			syscall
			
			li $v0, 10
			syscall
			
		terminate1:
			#Prompt for entering integers one by one
			li $v0, 4
			la $a0, terminated2
			syscall
			
			li $v0, 10
			syscall
	

	
	
	
