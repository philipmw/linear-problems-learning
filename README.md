# Philip's exploration of linear problems #

## What and why

This is my playground for exploring how to express problems such that they be solved by a linear solver.
I don't know a lot about this right now, but there is a real-world problem that I want to solve, and I believe
it is solvable using a linear solver.

My goal with this is to learn by challenging myself with progressively difficult linear problems,
and documenting it here for myself and maybe other LP neophytes.

Feel free to collaborate with me, either through GitHub pull requests or by email.

## Progression

1. `simple quad lineup.R`: a super simple assignment problem where four rowers want to row a quad.
   Each rower has an affinity for a specific seat, and we maximize the affinity.
2. `quad and launch.R`: a more complex assignment problem.  Now instead of rowers having affinities
   for particular seats, rowers have affinities for roles.  This better matches the real world.
   Now each seat of a boat has an affinity for a role (such as 1-seat having an affinity for the
   bow role), and so the solver tries to assign to 1-seat a rower who most has an affinity for the
   bow role.  This problem also adds a "launch seat", which has no affinity.

Potential next goals:

* Supporting exactly as many seats as rowers, since the solver requires a square matrix.
  This means assigning excess rowers to the launch or to an erg.
* Ensuring that boats are full.
  Do not assign three seats of a quad plus a single, but instead assign a full quad.

## Environment known to work

* macOS Catalina
* R 3.6.3 (installed through Homebrew)

In R:

    install.packages("lpSolve")

# References

* [lpSolve documentation](https://cran.r-project.org/web/packages/lpSolve/lpSolve.pdf)
