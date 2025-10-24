# Prefix Calculator

A prefix-notation calculator in Racket that evaluates expressions and keeps a history of results.

How to run interactive mode:
racket main.rkt

How to run batch mode (no prompts):
racket main.rkt -b

Supported operations:

- a b - Addition

* a b - Multiplication  
  / a b - Integer division (errors on divide by zero)

- a - Unary negation (not subtraction)
  $n - Reference to history result n
  Numbers - Any positive or negative number

Example session:

> 5
> 1: 5.0
> 10
> 2: 10.0
>
> - $1 $2
>   3: 15.0
>
> * $3 2
>   4: 30.0

Nested expressions work like this: + _ 2 3 4 evaluates as (2 _ 3) + 4 = 10

File structure:

main.rkt - The REPL loop that reads input and manages history

mode.rkt - Detects whether to run in interactive or batch mode

io.rkt - Handles printing results and error messages

util.rkt - String utility functions for trimming and splitting whitespace

evaluation.rkt - Main expression evaluator that coordinates parsing

parsing.rkt - Parses numbers and history references from character lists

operators.rkt - Handles unary and binary operator parsing

Notes:
Type quit to exit. History IDs start at 1. Whitespace between tokens is required. Leftover characters after parsing cause an error.
