# Philip's exploration of linear problems #

## What and why

This is my playground for exploring how to express problems such that they be solved by a linear solver.
I don't know a lot about this right now, but there is a real-world problem that I want to solve, and I believe
it is solvable using a linear solver.

My goal with this is to learn by challenging myself with progressively difficult linear problems,
and documenting it here for myself and maybe other LP neophytes.

Feel free to collaborate with me, either through GitHub pull requests or by email.

## Progression

1. `simple-quad-lineup.R`: a super simple assignment problem where four rowers want to row a quad.
  Each rower has an affinity for a specific seat, and we maximize the affinity.
2. next goal: support more rowers than seats.  Some rowers don't get to row.

## Environment known to work

* macOS Catalina
* R 3.6.2 (installed through Homebrew)

In R:

    install.packages("lpSolve")

# References

* [lpSolve documentation](https://cran.r-project.org/web/packages/lpSolve/lpSolve.pdf)
