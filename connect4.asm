	.data
fp.ra	=	4
fp.fp	=	0
fp.a0	=	8
fp.a1	=	12
fp.a2	=	16
fp.s0	=	-4
fp.s1	=	-8
fp.s2	=	-12
fp.s3	=	-16
fp.s4	=	-20
fp.s5	=	-24

title	.asciiz	"WELCOME TO THE MIPSYM VERSION OF CONNECT-4!"
topline	.asciiz	"________________________\n"
middleline	.asciiz	"|   |   |   |   |   |   |\n"
bottomline	.asciiz	"|___|___|___|___|___|___|\n"
modifyline	.asciiz	"|   |   |   |   |   |   |\n"
prompt	.asciiz	"Select a column: "
prompt2	.asciiz	"Invalid Column selction. Choose a column between 1 and 6: "
uwin	.asciiz	"USER WINS!!"
cwin	.asciiz	"COMPUTER WINS!!"
tie	.asciiz	"GRID IS FULL. TIE!!"
	.align	2
grid	.space	24
againmsg	.asciiz	"PLAY AGAIN (Nonzero=YES, 0=NO)?"
playerPeice	.space 12
playerIndex .byte 0
turn	.byte 0
	.globl	main
	.code

main:
	li	$a0,65
	li	$a1,66
	li	$a2,67
	li	$s0,68
	li	$s1,69
	li	$s2,70
	li	$s3,71
	li	$s4,72
	li	$s5,73
a:	jal	initialize_grid
	la	$a0,turn
	sb	$0,0($a0)
	la	$a0,playerIndex
	sb	$0,0($a0)
1:
	jal	resetdisplay
	jal	print_game
	
	jal	select_col_user
	move	$a0,$v0
	move	$a2,$v0
	li	$a1,0
	jal	drop_piece
	jal	resetdisplay
	jal	print_game
	addi	$a0,$0,0
	jal	check_win
	beqz	$v0,3f
	jal	grid_full
	bnez	$v0,5f
	
	move	$a0,$a2
	jal	select_col_comp
	move	$a0,$v0
	li	$a1,1
	jal	drop_piece
	jal	resetdisplay
	jal	print_game
	addi	$a0,$0,1
	jal	check_win
	addi	$v0,$v0,-1
	beqz	$v0,4f
	jal	grid_full
	bnez	$v0,5f
	
	b	1b
2:
	la	$a0,againmsg
	syscall	$print_string
	syscall	$read_int
	bnez	$v0,a
	syscall	$exit

3:
	la	$a0,uwin
	syscall	$print_string
	b	2b
	
4:	la	$a0,cwin
	syscall	$print_string
	b	2b
	
5:	la	$a0,tie
	syscall	$print_string
	b	2b
#### #### #### #### #### #### #### #### #### ####
#void resetdisplay(void)
#Clears the console
#### #### #### #### #### #### #### #### #### ####
resetdisplay:
	addi	$sp,$sp,-8
	sw	$a0,4($sp)
	sw	$a1,0($sp)

	li	$a1,25
1:	li	$a0,0xA
	syscall	$print_char
	addi	$a1,$a1,-1
	bgtz	$a1,1b
	
	li	$a0,0
	li	$a1,0
	syscall	$xy	

	lw	$a1,0($sp)
	lw	$a0,4($sp)
	addi	$sp,$sp,8
	jr	$ra

#### #### #### #### #### #### #### #### #### ####
#void initialize_grid(void)
#clears the grid
#### #### #### #### #### #### #### #### #### ####

initialize_grid:
	addi	$sp,$sp,-12
	sw	$a0,8($sp)
	sw	$a1,4($sp)
	sw	$a2,0($sp)

	la	$a0,grid
	li	$a1,24
1:	li	$a2,0x16
	sb	$a2,0($a0)
	addi	$a0,$a0,1
	addi	$a1,$a1,-1
	bgtz	$a1,1b
	
	lw	$a0,8($sp)
	lw	$a1,4($sp)
	lw	$a2,0($sp)
	addi	$sp,$sp,12
	jr	$ra

#### #### #### #### #### #### #### #### #### ####
#void print_game(void)
#prints a 4row 6col grid with peices
#### #### #### #### #### #### #### #### #### ####

print_game:
	addi	$sp,$sp,-20
	sw	$a0,16($sp)
	sw	$a1,12($sp)
	sw	$s0,8($sp)
	sw	$s1,4($sp)
	sw	$s2,0($sp)

	la	$a1,grid

	la	$a0,topline
	syscall	$print_string

	li	$s2,-4
2:	la	$a0,middleline
	syscall	$print_string
	
	li	$s0,-6
3:	la	$a0,modifyline

	#index in modifyline to be changed
	# index = 4n - 2
	addi	$s0,$s0,7	#makes $s0 = 1
	sll	$s0,$s0,2	#makes $s0 = 4 * s0
	addi	$s0,$s0,-2	#makes $s0 = s0 - 2
	add	$a0,$a0,$s0
	addi	$s0,$s0,2
	srl	$s0,$s0,2
	addi	$s0,$s0,-7
	
	lb	$s1,0($a1)
	sb	$s1,0($a0)
	addi	$s0,$s0,1
	addi	$a1,$a1,1
	bltz	$s0,3b
	#The string is finished being modified. Print string.
	addi	$a0,$a0,-22
	syscall	$print_string

	la	$a0,bottomline
	syscall	$print_string
	addi	$s2,$s2,1
	bltz	$s2,2b
		

	li	$a0,32
	li	$a1,3
	syscall	$xy
	la	$a0,title
	syscall	$print_string

	li	$a0,0
	li	$a1,15
	syscall	$xy

	lw	$a0,16($sp)
	lw	$a1,12($sp)
	lw	$s0,8($sp)
	lw	$s1,4($sp)
	lw	$s2,0($sp)
	addi	$sp,$sp,20
	jr	$ra


#### #### #### #### #### #### #### #### #### ####
#int select_col_user(void)
#return $v0 = coloum selected by user
#check to make sure it is valid
#### #### #### #### #### #### #### #### #### ####

select_col_user:
	addi	$sp,$sp,-8
	sw	$ra,0($sp)
	sw	$a0,4($sp)
	
	la	$a0,prompt
	syscall	$print_string
1:	syscall	$read_int
	addi	$v0,$v0,-1	#change index to [0:5]
	bltz	$v0,2f
	addi	$a0,$v0,-5
	bgtz	$a0,2f
	
	la	$a0,grid
	add	$a0,$a0,$v0
	lb	$a0,0($a0)
	addi	$a0,$a0,-22
	beqz	$a0,3f

2:	jal	resetdisplay
	jal	print_game
	la	$a0,prompt2
	syscall	$print_string
	b	1b

3:	lw	$ra,0($sp)
	lw	$a0,4($sp)
	addi	$sp,$sp,8
	jr	$ra

#### #### #### #### #### #### #### #### #### ####
#void drop_piece(int col, int user)
#col = $a0 = col_num
#user = $a1 = 0 if player("O"), 1 if Comp("X")
#### #### #### #### #### #### #### #### #### ####

drop_piece:
	addi	$sp,$sp,-20
	sw	$a0,16($sp)
	sw	$a1,12($sp)
	sw	$a2,8($sp)
	sw	$s0,4($sp)
	sw	$s1,0($sp)
	
	la	$a2,grid
	add	$a2,$a2,$a0
	addi	$a2,$a2,6
	move	$s1,$0

1:	lb	$s0,0($a2)
	addi	$s0,$s0,-22
	bnez	$s0,2f
	addi	$a2,$a2,6
	addi	$a0,$a0,6
	addi	$s1,$s1,1
	addi	$s1,$s1,-3
	bgtz	$s1,2f
	addi	$s1,$s1,3
	b	1b
2:	
	addi	$a2,$a2,-6
	bnez	$a1,3f
	li	$s0,0x4f
	sb	$s0,0($a2)
	b	4f

3:
	li	$s0,0x58
	sb	$s0,0($a2)

4:	lw	$a0,16($sp)
	lw	$a1,12($sp)
	lw	$a2,8($sp)
	lw	$s0,4($sp)
	lw	$s1,0($sp)
	addi	$sp,$sp,20
	jr	$ra

#### #### #### #### #### #### #### #### #### ####
#int select_col_comp(void)`
#return $v0 = col_num selected by computer
#### #### #### #### #### #### #### #### #### ####
	
select_col_comp:
	addi	$sp,$sp,-44
	sw	$fp,24($sp)
	addi	$fp,$sp,24
	sw	$ra,fp.ra($fp)
	sw	$a0,fp.a0($fp)
	sw	$a1,fp.a1($fp)
	sw	$a2,fp.a2($fp)
	sw	$s0,fp.s0($fp)
	sw	$s1,fp.s1($fp)
	sw	$s2,fp.s2($fp)
	sw	$s3,fp.s3($fp)
	sw	$s4,fp.s4($fp)
	sw	$s5,fp.s5($fp)
	
	#clear $v0 to invalid selection
	addi	$v0,$0,-1
	#store player's previous column
	la	$a1,playerPeice
	la	$a2,playerIndex
	lb	$s0,0($a2)
	add	$a1,$a1,$s0
	sb	$a0,0($a1)
	addi	$s0,$s0,1
	sb	$s0,0($a2)
	
	#increment's turn
	la	$a1,turn
	lb	$a2,0($a1)
	addi	$a2,$a2,1
	sb	$a2,0($a1)
	
	#first turn AI
	addi	$a2,$a2,-1
	bnez	$a2,2f
	
	addi	$a0,$a0,-2
	beqz	$a0,1f
	
	add	$v0,$0,2
	b	6f
1:
	add	$v0,$0,3
	b	6f	
	
	#second turn AI
2:	addi	$a2,$a2,-1
	bnez	$a2,3f
	
	addi	$a0,$a0,-2
	beqz	$a0,1f
	
	add	$v0,$0,2
	b	6f
1:
	add	$v0,$0,3
	b	6f
	
	#thrid turn AI
	#first time a block might be required
3:	addi	$a2,$a2,-1
	bnez	$a2,4f
	
	la	$a0,playerPeice
	lb	$s0,0($a0)
	lb	$s1,1($a0)
	lb	$s2,2($a0)
	
	beq	$s0,$s1,31f
	addi	$s0,$s0,-2
	beqz	$s0,4f
	addi	$s0,$s0,-1
	beqz	$s0,4f
	
31:	beq	$s0,$s2,32f
	addi	$s0,$s0,-2
	beqz	$s0,35f
	addi	$s0,$s0,-1
	beqz	$s0,36f
32:	add	$v0,$0,$s0
	b	6f
35:	addi	$v0,$0,5
	b	6f
36:	addi	$v0,$0,0
	b	6f
4:
	addi	$a0,$0,0x4F
	la	$a1,grid
	addi	$a1,6
	li	$s0,-6
41:	beqz	$s0,44f
	lb	$s1,0($a1)
	add	$a2,$0,$a1	#makes a2 = a1
	addi	$a1,1
	addi	$s0,1
	bne	$s1,$a0,41b
42:
	addi	$a2,$a2,6
	lb	$s1,0($a2)
	bne	$s1,$a0,41b
	addi	$a2,$a2,6
	lb	$s1,0($a2)
	bne	$s1,$a0,41b
	lb	$s1,-7($a1)
	addi	$s1,$s1,-22
	bnez	$s1,43f
	add	$v0,$s0,5
43:	b	41b

44:	la	$a1,grid
	addi	$a1,$a1,2
	lb	$a2,0($a1)
	addi	$a2,$a2,-22
	bnez	$a2,45f
	add	$v0,$0,2
	b	6f
45:	addi	$a1,$a1,1
	lb	$a2,0($a1)
	addi	$a2,$a2,-22
	bnez	$a2,5f
	add	$v0,$0,3
	b	6f
5:	
	la	$a0,grid
	li	$a1,-6
21:	beqz	$a1,5f
	lb	$a2,0($a0)
	addi	$a0,1
	addi	$a1,1
	addi	$a2,$a2,-22
	bnez	$a2,21b
	addi	$v0,$a1,5  

6:	
	lw	$ra,fp.ra($fp)
	lw	$a0,fp.a0($fp)
	lw	$a1,fp.a1($fp)
	lw	$a2,fp.a2($fp)
	lw	$s0,fp.s0($fp)
	lw	$s1,fp.s1($fp)
	lw	$s2,fp.s2($fp)
	lw	$s3,fp.s3($fp)
	lw	$s4,fp.s4($fp)
	lw	$s5,fp.s5($fp)
	lw	$fp,0($fp)
	addi	$sp,$sp,44
	jr	$ra

#### #### #### #### #### #### #### #### #### ####
#int check_win(int player)
#return $v0 = 0 if player(0 user, 1 comp) has not won, 1 if they have
#### #### #### #### #### #### #### #### #### ####

check_win:
	addi	$sp,$sp,-44
	sw	$fp,24($sp)
	addi	$fp,$sp,24
	sw	$ra,fp.ra($fp)
	sw	$a0,fp.a0($fp)
	sw	$a1,fp.a1($fp)
	sw	$a2,fp.a2($fp)
	sw	$s0,fp.s0($fp)
	sw	$s1,fp.s1($fp)
	sw	$s2,fp.s2($fp)
	sw	$s3,fp.s3($fp)
	sw	$s4,fp.s4($fp)
	sw	$s5,fp.s5($fp)
	
	beqz	$a0,1f
	b	2f
1:	addi	$a0,$0,0x4f
	b	vert
2:	addi	$a0,$0,0x58
	#vertical win check
vert:	la	$a1,grid
	li	$s0,-6
1:	beqz	$s0,horiz
	lb	$s1,0($a1)
	add	$a2,$0,$a1	#makes a2 = a1
	addi	$a1,1
	addi	$s0,1
	bne	$s1,$a0,1b
2:
	addi	$a2,$a2,6
	lb	$s1,0($a2)
	bne	$s1,$a0,1b
	addi	$a2,$a2,6
	lb	$s1,0($a2)
	bne	$s1,$a0,1b
	addi	$a2,$a2,6
	lb	$s1,0($a2)
	bne	$s1,$a0,1b
	lw	$v0,fp.a0($fp)
	b	80f

horiz:	la	$a1,grid
	li	$s0,-4
1:	addi	$s3,$0,0
	beqz	$s0,diag1
	lb	$s1,0($a1)
	add	$a2,$0,$a1	#makes a2 = a1
	addi	$a1,6
	addi	$s0,1
	beq	$s1,$a0,2f
	addi	$s3,$0,0
	b	21f

2:	addi	$s3,$s3,1
21:	addi	$a2,$a2,1
	lb	$s1,0($a2)
	beq	$s1,$a0,3f
	addi	$s3,$0,0
	b	31f
	
3:	addi	$s3,$s3,1
31:	addi	$a2,$a2,1
	lb	$s1,0($a2)
	beq	$s1,$a0,4f
	addi	$s3,$0,0
	b	41f
	
4:	addi	$s3,$s3,1
41:	addi	$a2,$a2,1
	lb	$s1,0($a2)
	beq	$s1,$a0,5f
	addi	$s3,$0,0
	b	51f
	
5:	addi	$s3,$s3,-3
	beqz	$s3,horizWin
	addi	$s3,$s3,3
	
	addi	$s3,$s3,1
51:	addi	$a2,$a2,1
	lb	$s1,0($a2)
	beq	$s1,$a0,6f
	addi	$s3,$0,0
	b	61f

6:	addi	$s3,$s3,-3
	beqz	$s3,horizWin
	addi	$s3,$s3,3
	
	addi	$s3,$s3,1
61:	addi	$a2,$a2,1
	lb	$s1,0($a2)
	beq	$s1,$a0,7f
	addi	$s3,$0,0
	
7:	addi	$s3,$s3,-3
	beqz	$s3,horizWin
	bnez	$s0,1b
	beqz	$s0,diag1
	addi	$v0,$0,-1
	b	80f
	
horizWin:
	lw	$v0,fp.a0($fp)
	b	80f
	
diag1:	la	$a1,grid
	li	$s0,-3
1:	beqz	$s0,diag2
	lb	$s1,0($a1)
	add	$a2,$0,$a1	#makes a2 = a1
	addi	$a1,1
	addi	$s0,1
	bne	$s1,$a0,1b
2:
	addi	$a2,$a2,7
	lb	$s1,0($a2)
	bne	$s1,$a0,1b
	addi	$a2,$a2,7
	lb	$s1,0($a2)
	bne	$s1,$a0,1b
	addi	$a2,$a2,7
	lb	$s1,0($a2)
	bne	$s1,$a0,1b
	lw	$v0,fp.a0($fp)
	b	80f
	
diag2:	la	$a1,grid
	addi	$a1,$a1,5
	li	$s0,-3
1:	beqz	$s0,80f
	lb	$s1,0($a1)
	add	$a2,$0,$a1	#makes a2 = a1
	addi	$a1,-1
	addi	$s0,1
	bne	$s1,$a0,1b
2:
	addi	$a2,$a2,5
	lb	$s1,0($a2)
	bne	$s1,$a0,1b
	addi	$a2,$a2,5
	lb	$s1,0($a2)
	bne	$s1,$a0,1b
	addi	$a2,$a2,5
	lb	$s1,0($a2)
	bne	$s1,$a0,1b
	lw	$v0,fp.a0($fp)

80:
	lw	$ra,fp.ra($fp)
	lw	$a0,fp.a0($fp)
	lw	$a1,fp.a1($fp)
	lw	$a2,fp.a2($fp)
	lw	$s0,fp.s0($fp)
	lw	$s1,fp.s1($fp)
	lw	$s2,fp.s2($fp)
	lw	$s3,fp.s3($fp)
	lw	$s4,fp.s4($fp)
	lw	$s5,fp.s5($fp)
	lw	$fp,0($fp)
	addi	$sp,$sp,44
	jr	$ra
	
###################################################
# int grid_full(void)
# output:
# v0: =0 if grid is NOT full
# =1 if grid is full.
###################################################
# Register usage: 
#<list any t0-t9 registers used by the function>
###################################################
grid_full:
	addi	$sp,$sp,-44
	sw	$fp,24($sp)
	addi	$fp,$sp,24
	sw	$ra,fp.ra($fp)
	sw	$a0,fp.a0($fp)
	sw	$a1,fp.a1($fp)
	sw	$a2,fp.a2($fp)
	sw	$s0,fp.s0($fp)
	sw	$s1,fp.s1($fp)
	sw	$s2,fp.s2($fp)
	sw	$s3,fp.s3($fp)
	sw	$s4,fp.s4($fp)
	sw	$s5,fp.s5($fp)
	
	addi	$a0,$0,-7
	la	$a1,grid
1:	lb	$a2,0($a1)
	addi	$a2,$a2,-22
	addi	$a0,$a0,1
	addi	$a1,$a1,1
	beqz	$a2,3f
	bltz	$a0,1b	
2:
	addi	$v0,$0,1
	b	4f
3:
	addi	$v0,$0,0
4:
	lw	$ra,fp.ra($fp)
	lw	$a0,fp.a0($fp)
	lw	$a1,fp.a1($fp)
	lw	$a2,fp.a2($fp)
	lw	$s0,fp.s0($fp)
	lw	$s1,fp.s1($fp)
	lw	$s2,fp.s2($fp)
	lw	$s3,fp.s3($fp)
	lw	$s4,fp.s4($fp)
	lw	$s5,fp.s5($fp)
	lw	$fp,0($fp)
	addi	$sp,$sp,44
	jr	$ra
