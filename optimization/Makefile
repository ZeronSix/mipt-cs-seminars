all: 
	gcc -O0 main.c hashtable.c -o unoptimized
	gcc -O0 -masm=intel main.c hashtable_optimized.c -o optimized
	gcc -O0 -S -masm=intel hashtable.c
	gcc -O0 -S -masm=intel hashtable_optimized.c 

