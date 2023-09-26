.data   
  dash: 		.asciiz " - "
  draw_again: 		.asciiz "\nOne more time? (1) YES (0) NO: "
  
  x:		.asciiz " X "
  o: 		.asciiz " O "
  nl:		.asciiz "\n"
  
  p1: 	.asciiz "\nPlayer 1, please enter your move (1 - 9): "
  p2:	.asciiz"\nPlayer 2, please enter your move (1 - 9): "
  
  opt: 	.asciiz "\n Player 1, do you want to be X (1) or O(0)?: "
  
  WonO: 		.asciiz "\nO Won!"
  WonX: 		.asciiz "\nX Won!"
  
  usedPos:	.asciiz "\nThat position already taken! Choose another."
  pos:		.word 0:10
  used:		.word 0:10
  
.text

main:
	li $t0, 0 # iter
	li $t1, 36
	li $t2, 9 #  counter
	li $t5, 2
	li $t9, 0

	
	
loop:
	beq $t0, $t1, loopend

	add $t0, $t0, 4
	
	lw $t3, pos($t0)
	
	beq $t3, 0, dashP
	beq $t3, 1, xP
	beq $t3, 4, oP
	
	beq $t2, 0, draw_againP
	
	j loopend

dashP:
	la $a0, dash
	li $v0, 4
	syscall 
	
	beq $t0, 12, nlP
	beq $t0, 24, nlP
	beq $t0, 36, nlP
	
	j loop

nlP:
	la $a0, nl
	li $v0, 4
	syscall
	
	j loop

xP:
	la $a0, x
	li $v0, 4
	syscall
	
	beq $t0, 12, nlP
	beq $t0, 24, nlP
	beq $t0, 36, nlP
	
	j loop

oP:
	la $a0, o
	li $v0, 4
	syscall
	
	beq $t0, 12, nlP
	beq $t0, 24, nlP
	beq $t0, 36, nlP
	
	j loop

loopend:
	beq $t2, 0, draw_againP
	
	beq $t5, 2, p1M
	beq $t5, 1, p2M
	
	
	j p1M

p1M:
	li $t0, 1
	li $s5, 1
	la $a0,p1
	li $v0,4
	syscall

	li $v0,5
	syscall
	
	mul $t7, $v0, 4
	mflo $t7
	
	lw $s6, used($t7)
	
	beq $s6, $s5, usedSpotP1
	
	sw $s5, used($t7)

	sw $t0, pos($t7)
	li $t0, 0
	
	add $t5, $t5, -1
	
	add $t2, $t2, -1

	jal TopHorizontalWon
	jal MidHorizontalWon
	jal BotHorizontalWon
	jal LeftVerticalWon
	jal MidVerticalWon
	jal RightVerticalWon
	jal RightTopLeftBottomDiagonal
	jal RightTopLeftBottomDiagonal
	j loop
	
usedSpotP1:
	la $a0, usedPos
	li $v0, 4
	syscall
	
	j p1M
	
p2M:
	li $t0, 4
	li $s5, 1
	la $a0,p2
	li $v0,4
	syscall

	li $v0,5
	syscall
	
	mul $t7, $v0, 4
	mflo $t7
	
	lw $s6, used($t7)
	beq $s6, $s5, usedSpotP2
	sw $s5, used($t7)

	sw $t0, pos($t7)
	li $t0, 0
	
	add $t5, $t5, 1
	
	add $t2, $t2, -1
	

	jal TopHorizontalWon
	jal MidHorizontalWon
	jal BotHorizontalWon
	jal LeftVerticalWon
	jal MidVerticalWon
	jal RightVerticalWon
	jal RightTopLeftBottomDiagonal
	jal RightTopLeftBottomDiagonal
	j loop

usedSpotP2:
	la $a0, usedPos
	li $v0, 4
	syscall
	
	j p2M

draw_againP:
	la $a0, draw_again
	li $v0, 4
	syscall 
	
	li $v0, 5
	syscall
	
	beq $v0, 1, clmain
	beq $v0, 0, end

 

clmain:   
	la $a0, pos
   	add $a2, $zero, $zero
loop2:   
	slti $t1, $a2, 10
  	 beq $t1, $zero, main
loop4:   
	lw $a1, 0($a0)
   	addi $a2, $a2, 1 
   	add $a1, $zero, $zero
  	 sw $a1, 0($a0)
   	addi $a0, $a0, 4 
   
   	j loop2

win1:  
   	la $a0, WonX
	li $v0, 4
	syscall
	j end

win2:   
	la $a0, WonO
	li $v0, 4
	syscall
	j end


TopHorizontalWon:   
	# 1 1 1
	# 0 0 0
	# 0 0 0

	
	la $a0, pos
	lw $s1, 4($a0)   
	lw $s2, 8($a0)
	lw $s3, 12($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   	
   	
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra

 
MidHorizontalWon:   
	# 0 0 0
	# 1 1 1
	# 0 0 0

	la $a0, pos
	lw $s1, 16($a0)   
	lw $s2, 20($a0)
	lw $s3, 24($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra


BotHorizontalWon:   
	# 0 0 0
	# 0 0 0	
	# 1 1 1

	la $a0, pos
	lw $s1, 28($a0)  
	lw $s2, 32($a0)
	lw $s3, 36($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra

 
LeftVerticalWon:   
	# 1 0 0
	# 1 0 0
	# 1 0 0

	la $a0, pos
	lw $s1, 4($a0)  
	lw $s2, 16($a0)
	lw $s3, 28($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra

 
MidVerticalWon:   
	# 0 1 0
	# 0 1 0
	# 0 1 0

	la $a0, pos
	lw $s1, 8($a0)  
	lw $s2, 20($a0)
	lw $s3, 32($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra

 
RightVerticalWon:   
	# 0 0 1
	# 0 0 1
	# 0 0 1

	la $a0, pos
	lw $s1, 12($a0)  
	lw $s2, 24($a0)
	lw $s3, 36($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra

 
RightTopLeftBottomDiagonal:  
	# 0 0 1 
	# 0 1 0 
	# 1 0 0 

	la $a0, pos
	lw $s1, 4($a0)  
	lw $s2, 20($a0)
	lw $s3, 36($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra

 
RightTopLeftBottomDiagonal:   
	# 1 0 0
	# 0 1 0
	# 0 0 1
	
	la $a0, pos
	lw $s1, 12($a0)   
	lw $s2, 20($a0)
	lw $s3, 28($a0)
   
	add $s4, $s1,$s2
	add $s4, $s4,$s3
   
	beq $s4, 3, win1
	beq $s4, 12, win2
	
	jr  $ra
end:
	nop
