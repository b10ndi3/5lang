# 5lang README.md

#### 5lang was created as a team project by two University of Dayton students.
#### Member 1: Charles Pope <popec4@udayton.edu>

#### Member 2: Lucas Willison <willisonl1@udayton.edu>




# Introduction

5lang is a custom programming language designed and implemented by Team 5 for the final project in CPS 352.  
Our design goals were to create a simple, expressive, and educational language that supports:

- Arithmetic on flexible number types  
- Local binding  
- Conditional evaluation  
- First-class functions  
- Function calls  
- An additional team-defined feature: a built-in `print` expression
- Higher-order functions and closures (emergent behaviors from our semantics)

The implementation is a full interpreter written in Racket using the `sllgen` toolset from Essentials of Programming Languages.  
This README explains the language design, interpreter architecture, and how to run and evaluate programs in 5lang.

# Design

# Syntax Overview

5lang provides the following expression forms:

| Feature | Syntax | Example |
|--------|--------|---------|
| Number literals | integer or float | `5`, `3.14` |
| Binary operations | `(expr op expr)` | `(1 + 2)` |
| Local binding | `hold x = expr inside expr` | `hold x = 5 inside (x + 1)` |
| Conditional evaluation | `given expr then expr otherwise expr` | `given (x > 0) then 1 otherwise 0` |
| Function definition | `task(a,b) -> { expr }` | `task(x) -> { (x + 1) }` |
| Function call | `call f(5, 6)` | calls `f` |
| Printing (team concept) | `print(expr)` | prints expr to console |

# Semantics Summary

- Numbers evaluate to themselves.  
- Binary expressions evaluate left-to-right and then apply the primitive operator.  
- hold introduces a new environment frame with lexical scope.  
- given treats any non-zero number as true, zero as false.  
- task creates a closure capturing its defining environment.  
- call evaluates arguments and executes the closure body.  
- print outputs the value to the console and returns the printed value.  

# Implementation

### Semantics Summary

- Numbers evaluate to themselves.  
- Binary expressions evaluate left-to-right and then apply the primitive operator.  
- hold introduces a new environment frame with lexical scope.  
- given treats any non-zero number as true, zero as false.  
- task creates a closure capturing its defining environment.  
- call evaluates arguments and executes the closure body.  
- print outputs the value to the console and returns the printed value.  

# User guide

1. Open DrRacket  
2. Load `5lang-interpreter.rkt`  
3. Click Run  
4. Use the `run` function in the REPL:

# Contributions

Charles Pope

Designed major language features (hold, given, task, call, print)

Implemented interpreter core: primitives, error handling, print semantics

Created test programs and debugging workflows

Worked with AI tools to refine syntax and semantics

Lucas Willison

Led grammar design and parsing structure

Developed environment model and closure representation

Implemented function calling and lexical scoping behavior

Integrated syntax fixes and ensured LL(1) compatibility

Our collaboration was balanced: both members contributed code, design decisions, debugging, and documentation.

_[Updated 11/25/2025]: Please declare whether your team has used any AI tools, which is strongly encouraged, in this project. If so, provide specific details on which tools were used and how they contributed to your project design and development._

Use of AI Tools

Our team used ChatGPT as an AI design assistant to:

Brainstorm syntax ideas

Validate grammar structure

Debug interpreter behavior

Improve error messages

Generate test programs

Fix LL(1) grammar conflicts

Produce sample programs for evaluation

Draft documentation sections used in this README

All final code was reviewed, tested, and integrated manually by the team.
