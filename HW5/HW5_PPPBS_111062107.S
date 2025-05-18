# Refernce : https://www.geeksforgeeks.org/the-painters-partition-problem-using-binary-search/
.data
.align 4
INT_MIN: .word -2147483648

# ==============testcase1==============
arr: .word 10, 20, 30, 40
n: .word 4
k: .word 2
str: .string "output: "
# output: 60
# =====================================

# ==============testcase2==============
# arr: .word 1, 2, 3, 4, 5, 6, 7, 8, 9
# n: .word 9
# k: .word 3
# str: .string "output: "
# output: 17
# =====================================

.text
.global _start
# Start your coding below, don't change anything upper except testing different testcase
_start:
    la a0, str
    li a7, 4 # print string
    ecall
    # Load array address
    la a0, arr
    # Load n
    la a1, n
    lw a1, 0(a1)
    # li a1,4
    # Load k
    la a2, k
    lw a2, 0(a2)
    la a3, INT_MIN
    lw a3, 0(a3)
    # li a2,2
##############################################
    
##############################################
    jal partition

    li a7, 1 # print number
    ecall
    j end
###########################################################################
partition:
    # Function prologue
    addi sp, sp, -20   # Adjust stack pointer
    sw ra, 16(sp)      # Save return address
    sw t0, 12(sp)      # Save t0 (lo)
    sw t1, 8(sp)       # Save t1 (hi)
    sw t2, 4(sp)       # Save t2 (mid)
    sw t3, 0(sp)       # Save t3 (requiredPainters)
    
    # Get initial values of lo and hi
    jal getMax         # Get maximum value of the array
    mv t0, a0          # Move returned value to lo (t0)
    la a0, arr
    # Load n
    lw a1, n
    # li a1,4
    # Load k
    lw a2, k
    # li a2,2
    jal getSum         # Get sum of elements in the array
    mv t1, a0          # Move returned value to hi (t1)
    
    # Perform binary search to find the minimum possible maximum sum
Loop:
    blt t0, t1, 1f     # Break if lo < hi
    j 2f               # Jump to EndLoop if lo >= hi

1:
    # Use arithmetic shift right to divide by 2
    # Calculate mid = lo + (hi - lo) / 2
    sub t2, t1, t0
    srai t2, t2, 1     
    add t2, t2, t0     
    
    # Calculate the number of painters required for the current mid
    la a0, arr          # Load address of arr
    lw a1, n            # Move n to a1
    mv a2, t2           # Move mid to a2
    jal numberOfPainters
    mv t3, a0          # Move returned value to requiredPainters (t3)
    lw a2,k
    ble t3, a2, 3f     # If requiredPainters <= k, update hi to mid
    addi t0, t2, 1     # lo = mid + 1
    j Loop             # Repeat the loop
    
3:
    mv t1, t2          # hi = mid 
    j Loop             # Repeat the loop
    
# EndLoop: Return the minimum possible maximum sum of k partitions
2:
    mv a0, t0           # Move lo to a0
    j Return            # Jump to Return

Return:
    # Function epilogue
    lw ra, 16(sp)      # Restore return address
    lw t0, 12(sp)      # Restore t0 (lo)
    lw t1, 8(sp)       # Restore t1 (hi)
    lw t2, 4(sp)       # Restore t2 (mid)
    lw t3, 0(sp)       # Restore t3 (requiredPainters)
    addi sp, sp, 20    # Restore stack pointer
    jr ra              # Return to caller
###########################################################################
numberOfPainters:
    # Function prologue
    addi sp, sp, -32   # Adjust stack pointer
    sw t1, 28(sp)
    sw t3, 24(sp)
    sw a2, 20(sp)
    sw ra, 16(sp)      # Save return address
    sw t0, 12(sp)      # Save t0 (total value)
    sw t4, 8(sp)       # Save t4 (numPainters)
    sw t2, 4(sp)       # Save t2 (loop counter)
    
    # Initialize total value and numPainters
    li t0, 0           # Load 0 into t0 (total)
    li t4, 1           # Load 1 into t4 (numPainters)
    
    # Loop through the array
    li t2, 0           # Initialize loop counter
1:
    bge t2, a1, 2f     # Break if loop counter >= array length
    slli t3, t2, 2     # Calculate offset (4 bytes per integer)
    add t3, a0, t3     # Calculate address of arr[i]
    lw t1, 0(t3)       # Load current value into t1
    add t0, t0, t1     # Add current value to total
    
    bgt t0, a2, 3f     # Check if total > maxLen
    j 4f               # Jump to continue loop
    
3:
    # Increment numPainters and reset total
    addi t4, t4, 1     # Increment numPainters
    mv t0, t1          # Reset total to current value
    
4:
    addi t2, t2, 1     # Increment loop counter
    j 1b               # Repeat loop

2:
    mv a0, t4          # Move numPainters to a0
    
    # Function epilogue
    lw t1, 28(sp)
    lw t3, 24(sp)
    lw a2, 20(sp)
    lw ra, 16(sp)      # Restore return address
    lw t0, 12(sp)      # Restore t0 (total value)
    lw t4, 8(sp)       # Restore t4 (numPainters)
    lw t2, 4(sp)       # Restore t2 (loop counter)
    addi sp, sp, 32    # Restore stack pointer
    jr ra              # Return to caller
###########################################################################
getMax:
    # Function prologue
    addi sp, sp, -24   # Adjust stack pointer
    sw t1, 20(sp)
    sw t2, 16(sp)
    sw t3, 12(sp)
    sw ra, 8(sp)       # Save return address
    sw t0, 4(sp)       # Save t0 (max value)
    
    # Initialize max value to INT_MIN
    la t0, INT_MIN     # Load address of INT_MIN
    lw t0, 0(t0)       # Load value of INT_MIN into t0 (max)
    
    # Loop through the array
    li t2, 0           # Initialize loop counter
LoopStart:
    bge t2, a1, EndLoop     # Break if loop counter >= array length
    slli t3, t2, 2     # Calculate offset (4 bytes per integer)
    add t3, a0, t3     # Calculate address of arr[i]
    lw t1, 0(t3)       # Load current value into t1
    bge t1, t0, Update     # Compare current value with max value
    j AddI               # Jump to next iteration
Update:
    mv t0, t1          # Update max value
    # mv a0, t0      # Set a0 to the result of getMax function
    # li a7, 1        # Set ecall argument to 1 (print real value)
AddI:
    addi t2, t2, 1     # Increment loop counter
    j LoopStart               # Repeat loop
EndLoop:    
    # Function epilogue
    mv a0, t0
    lw t1, 20(sp)
    lw t2, 16(sp)
    lw t3, 12(sp)
    lw ra, 8(sp)       # Restore return address
    lw t0, 4(sp)       # Restore t0 (max value)
    addi sp, sp, 24    # Restore stack pointer
    jr ra              # Return to caller
###########################################################################
getSum:
    # Function prologue
    addi sp, sp, -28   # Adjust stack pointer
    sw t3, 24(sp)
    sw t1, 20(sp)
    sw s0, 16(sp)
    sw ra, 12(sp)      # Save return address
    sw t0, 8(sp)       # Save t0 (total value)
    sw t2, 4(sp)       # Save t2 (loop counter)
    
    # Initialize total value to 0
    li t0, 0           # Load 0 into t0 (total)
    
    # Loop through the array
    li t2, 0           # Initialize loop counter
1:
    bge t2, a1, 2f     # Break if loop counter >= array length
    slli t3, t2, 2     # Calculate offset (4 bytes per integer)
    add t3, a0, t3     # Calculate address of arr[i]
    lw t1, 0(t3)       # Load current value into t1
    add t0, t0, t1     # Add current value to total
    addi t2, t2, 1     # Increment loop counter
    j 1b               # Repeat loop
2:
    mv a0, t0          # Move total value to a0
    addi t0, zero, 0
    # Function epilogue
    lw t3, 24(sp)
    addi t1, zero, 0
    add t1, t3, zero
    # add t2, zero,t2
    # addi t1, zero, 0
    # add t1, t2, zero
    lw t1, 20(sp)
    lw s0, 16(sp)
    lw ra, 12(sp)      # Save return address
    lw t0, 8(sp)       # Save t0 (total value)
    lw t2, 4(sp)       # Save t2 (loop counter)
    addi sp, sp, 28    # Restore stack pointer
    jr ra              # Return to caller
###########################################################################
end:nop