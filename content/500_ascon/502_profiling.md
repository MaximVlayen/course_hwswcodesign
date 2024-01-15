---
title: '502 Profiling'
weight: 502
draft: true
---

In the first step of the project, a **software implementation of ASCON hash** is to be made. The prototype of the hash function should look like this:

{{< highlight c >}}
void ascon_hash(uint32_t * digest, uint32_t * message, uint8_t mlen);
{{< /highlight >}}

* the **first** argument contains a pointer to the reserved memory in which the digest will be saved;
* the **second** argument contains a pointer to the first memory address on which the message is saved;
* the **third** and final argument is an unsigned byte that gives the length of the message in number of 32-bit words.

This function, **ascon_hash( )**, will hence be called once for each hash operation. It might very well be that you create a number of other functions to achieve a working implementation. 

Having an insight in how often each function is called, can be interesting information for choosing the most optimal point for hardware offloading. This can be done with [profiling](https://en.wikipedia.org/wiki/Profiling_(computer_programming))

## An example

{{% multiHcolumn %}}

{{% column %}}
{{< highlight c >}}
#include <stdio.h>
#include <stdint.h>

void orden_two(uint8_t * a, uint8_t * b);
void orden_list(uint8_t * l);
uint8_t check_list(uint8_t * l);
void print_list(uint8_t * l);

uint8_t main(void) {
    uint8_t list[] = {3, 6, 1, 8, 2, 0, 5, 4, 9, 7};
    uint8_t rv;

    print_list(list);
    rv = check_list(list);

    while(rv > 0) {
        orden_list(list);
        print_list(list);
        rv = check_list(list);
    }

    return 0;
}

void orden_two(uint8_t * a, uint8_t * b) {
    uint8_t temp;

    if(*a > *b) {
        temp = *a;
        *a = *b;
        *b = temp;
    }
}

void orden_list(uint8_t * l) {
    for(uint8_t i=0;i<9;i++) { 
        orden_two(&l[i], &l[i+1]);
    }
}

uint8_t check_list(uint8_t * l) {
    for(uint8_t i=0;i<9;i++) {
        if(l[i] > l[i+1]) {
            return 1;
    }}
    return 0;
}

void print_list(uint8_t * l) {
    for(uint8_t i=0;i<10;i++) {
        printf("%i ", l[i]);
    } printf("\n");
}


{{< /highlight >}}
{{% /column %}}
{{% column %}}

### Bubble sort
Let's look at this example. It performs a **bubble-sort** operation on a list of 10 unsigned bytes.

The list is first printed, after which it is checked whether or not further sorting is required. If required, the list is **ordened** again.

The ordening happens by iterating over the array, per couple of entries. These entries possibly switch locations (if required).

### Compiling
Now ... to see where optimisation would pay of most we run profiling on this code. The **gprof** tool comes with the **gcc** compiler. To enable *profiling*, the compile option **-pg** needs to be added. 

{{< highlight bash >}}
gcc -o main_v1 main_v1.c
{{< /highlight >}}

becomes

{{< highlight bash >}}
gcc -pg -o main_v1 main_v1.c
{{< /highlight >}}

### Running

After running the executable, an additional (binary) file is created: **gmon.out**. This file contains metadata that is stored during the running of the executable.

To parse the gmon.out file, simply run the command again, preceded by **gprof**. To store the output, the standard output can be redirected to a file (```bash > analysis.txt```).

{{< highlight bash >}}
./main_v1
.gprof /main_v1 > analysis_v1.txt
{{< /highlight >}}

{{% /column %}}
{{% /multiHcolumn %}}

Below you can see te result of the outcome. For more information on the **gprof** tool, see the [man page](https://linux.die.net/man/1/gprof).


{{% multiHcolumn %}}
{{% column %}}
### Profile v1
In v1, list is initialised with: 

{{< highlight C>}}
    uint8_t list[] = {3, 6, 1, 8, 2, 0, 5, 4, 9, 7};
{{< /highlight >}}

{{< highlight S>}}
Flat profile:

Each sample counts as 0.01 seconds.
 no time accumulated

  %   cumulative   self              self     total           
 time   seconds   seconds    calls  Ts/call  Ts/call  name    
  0.00      0.00     0.00       45     0.00     0.00  orden_two
  0.00      0.00     0.00        6     0.00     0.00  check_list
  0.00      0.00     0.00        6     0.00     0.00  print_list
  0.00      0.00     0.00        5     0.00     0.00  orden_list

 %         the percentage of the total running time of the
time       program used by this function.

cumulative a running sum of the number of seconds accounted
 seconds   for by this function and those listed above it.

 self      the number of seconds accounted for by this
seconds    function alone.  This is the major sort for this
           listing.

calls      the number of times this function was invoked, if
           this function is profiled, else blank.

 self      the average number of milliseconds spent in this
ms/call    function per call, if this function is profiled,
	   else blank.

 total     the average number of milliseconds spent in this
ms/call    function and its descendents per call, if this
	   function is profiled, else blank.

name       the name of the function.  This is the minor sort
           for this listing. The index shows the location of
	   the function in the gprof listing. If the index is
	   in parenthesis it shows where it would appear in
	   the gprof listing if it were to be printed.

Copyright (C) 2012-2020 Free Software Foundation, Inc.

Copying and distribution of this file, with or without modification,
are permitted in any medium without royalty provided the copyright
notice and this notice are preserved.

		     Call graph (explanation follows)


granularity: each sample hit covers 2 byte(s) no time propagated

index % time    self  children    called     name
                0.00    0.00      45/45          orden_list [4]
[1]      0.0    0.00    0.00      45         orden_two [1]
-----------------------------------------------
                0.00    0.00       6/6           main [10]
[2]      0.0    0.00    0.00       6         check_list [2]
-----------------------------------------------
                0.00    0.00       6/6           main [10]
[3]      0.0    0.00    0.00       6         print_list [3]
-----------------------------------------------
                0.00    0.00       5/5           main [10]
[4]      0.0    0.00    0.00       5         orden_list [4]
                0.00    0.00      45/45          orden_two [1]
-----------------------------------------------

 This table describes the call tree of the program, and was sorted by
 the total amount of time spent in each function and its children.

 Each entry in this table consists of several lines.  The line with the
 index number at the left hand margin lists the current function.
 The lines above it list the functions that called this function,
 and the lines below it list the functions this one called.
 This line lists:
     index	A unique number given to each element of the table.
		Index numbers are sorted numerically.
		The index number is printed next to every function name so
		it is easier to look up where the function is in the table.

     % time	This is the percentage of the `total' time that was spent
		in this function and its children.  Note that due to
		different viewpoints, functions excluded by options, etc,
		these numbers will NOT add up to 100%.

     self	This is the total amount of time spent in this function.

     children	This is the total amount of time propagated into this
		function by its children.

     called	This is the number of times the function was called.
		If the function called itself recursively, the number
		only includes non-recursive calls, and is followed by
		a `+' and the number of recursive calls.

     name	The name of the current function.  The index number is
		printed after it.  If the function is a member of a
		cycle, the cycle number is printed between the
		function's name and the index number.


 For the function's parents, the fields have the following meanings:

     self	This is the amount of time that was propagated directly
		from the function into this parent.

     children	This is the amount of time that was propagated from
		the function's children into this parent.

     called	This is the number of times this parent called the
		function `/' the total number of times the function
		was called.  Recursive calls to the function are not
		included in the number after the `/'.

     name	This is the name of the parent.  The parent's index
		number is printed after it.  If the parent is a
		member of a cycle, the cycle number is printed between
		the name and the index number.

 If the parents of the function cannot be determined, the word
 `<spontaneous>' is printed in the `name' field, and all the other
 fields are blank.

 For the function's children, the fields have the following meanings:

     self	This is the amount of time that was propagated directly
		from the child into the function.

     children	This is the amount of time that was propagated from the
		child's children to the function.

     called	This is the number of times the function called
		this child `/' the total number of times the child
		was called.  Recursive calls by the child are not
		listed in the number after the `/'.

     name	This is the name of the child.  The child's index
		number is printed after it.  If the child is a
		member of a cycle, the cycle number is printed
		between the name and the index number.

 If there are any cycles (circles) in the call graph, there is an
 entry for the cycle-as-a-whole.  This entry shows who called the
 cycle (as parents) and the members of the cycle (as children.)
 The `+' recursive calls entry shows the number of function calls that
 were internal to the cycle, and the calls entry for each member shows,
 for that member, how many times it was called from other members of
 the cycle.

Copyright (C) 2012-2020 Free Software Foundation, Inc.

Copying and distribution of this file, with or without modification,
are permitted in any medium without royalty provided the copyright
notice and this notice are preserved.

Index by function name

   [2] check_list              [1] orden_two
   [4] orden_list              [3] print_list

{{< /highlight >}}
{{% /column %}}

{{% column %}}
### Profile v2
In v2, list is initialised with: 

{{< highlight C>}}
    uint8_t list[] = {9, 8, 7, 6, 5, 4, 3, 2, 1, 0};
{{< /highlight>}}

{{< highlight S>}}
Flat profile:

Each sample counts as 0.01 seconds.
 no time accumulated

  %   cumulative   self              self     total           
 time   seconds   seconds    calls  Ts/call  Ts/call  name    
  0.00      0.00     0.00       81     0.00     0.00  orden_two
  0.00      0.00     0.00       10     0.00     0.00  check_list
  0.00      0.00     0.00       10     0.00     0.00  print_list
  0.00      0.00     0.00        9     0.00     0.00  orden_list

 %         the percentage of the total running time of the
time       program used by this function.

cumulative a running sum of the number of seconds accounted
 seconds   for by this function and those listed above it.

 self      the number of seconds accounted for by this
seconds    function alone.  This is the major sort for this
           listing.

calls      the number of times this function was invoked, if
           this function is profiled, else blank.

 self      the average number of milliseconds spent in this
ms/call    function per call, if this function is profiled,
	   else blank.

 total     the average number of milliseconds spent in this
ms/call    function and its descendents per call, if this
	   function is profiled, else blank.

name       the name of the function.  This is the minor sort
           for this listing. The index shows the location of
	   the function in the gprof listing. If the index is
	   in parenthesis it shows where it would appear in
	   the gprof listing if it were to be printed.

Copyright (C) 2012-2020 Free Software Foundation, Inc.

Copying and distribution of this file, with or without modification,
are permitted in any medium without royalty provided the copyright
notice and this notice are preserved.

		     Call graph (explanation follows)


granularity: each sample hit covers 2 byte(s) no time propagated

index % time    self  children    called     name
                0.00    0.00      81/81          orden_list [4]
[1]      0.0    0.00    0.00      81         orden_two [1]
-----------------------------------------------
                0.00    0.00      10/10          main [10]
[2]      0.0    0.00    0.00      10         check_list [2]
-----------------------------------------------
                0.00    0.00      10/10          main [10]
[3]      0.0    0.00    0.00      10         print_list [3]
-----------------------------------------------
                0.00    0.00       9/9           main [10]
[4]      0.0    0.00    0.00       9         orden_list [4]
                0.00    0.00      81/81          orden_two [1]
-----------------------------------------------

 This table describes the call tree of the program, and was sorted by
 the total amount of time spent in each function and its children.

 Each entry in this table consists of several lines.  The line with the
 index number at the left hand margin lists the current function.
 The lines above it list the functions that called this function,
 and the lines below it list the functions this one called.
 This line lists:
     index	A unique number given to each element of the table.
		Index numbers are sorted numerically.
		The index number is printed next to every function name so
		it is easier to look up where the function is in the table.

     % time	This is the percentage of the `total' time that was spent
		in this function and its children.  Note that due to
		different viewpoints, functions excluded by options, etc,
		these numbers will NOT add up to 100%.

     self	This is the total amount of time spent in this function.

     children	This is the total amount of time propagated into this
		function by its children.

     called	This is the number of times the function was called.
		If the function called itself recursively, the number
		only includes non-recursive calls, and is followed by
		a `+' and the number of recursive calls.

     name	The name of the current function.  The index number is
		printed after it.  If the function is a member of a
		cycle, the cycle number is printed between the
		function's name and the index number.


 For the function's parents, the fields have the following meanings:

     self	This is the amount of time that was propagated directly
		from the function into this parent.

     children	This is the amount of time that was propagated from
		the function's children into this parent.

     called	This is the number of times this parent called the
		function `/' the total number of times the function
		was called.  Recursive calls to the function are not
		included in the number after the `/'.

     name	This is the name of the parent.  The parent's index
		number is printed after it.  If the parent is a
		member of a cycle, the cycle number is printed between
		the name and the index number.

 If the parents of the function cannot be determined, the word
 `<spontaneous>' is printed in the `name' field, and all the other
 fields are blank.

 For the function's children, the fields have the following meanings:

     self	This is the amount of time that was propagated directly
		from the child into the function.

     children	This is the amount of time that was propagated from the
		child's children to the function.

     called	This is the number of times the function called
		this child `/' the total number of times the child
		was called.  Recursive calls by the child are not
		listed in the number after the `/'.

     name	This is the name of the child.  The child's index
		number is printed after it.  If the child is a
		member of a cycle, the cycle number is printed
		between the name and the index number.

 If there are any cycles (circles) in the call graph, there is an
 entry for the cycle-as-a-whole.  This entry shows who called the
 cycle (as parents) and the members of the cycle (as children.)
 The `+' recursive calls entry shows the number of function calls that
 were internal to the cycle, and the calls entry for each member shows,
 for that member, how many times it was called from other members of
 the cycle.

Copyright (C) 2012-2020 Free Software Foundation, Inc.

Copying and distribution of this file, with or without modification,
are permitted in any medium without royalty provided the copyright
notice and this notice are preserved.

Index by function name

   [2] check_list              [1] orden_two
   [4] orden_list              [3] print_list

{{< /highlight >}}
{{% /column %}}
{{% /multiHcolumn %}}