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
1. `port vs starboard.R`: one boat, and rowers have an affinity for port vs starboard.
1. `quad and launch.R`: Instead of rowers having affinities for particular seats, rowers have
   affinities for roles.  This better matches the real world. Now each seat of a boat has an
   affinity for a role (such as 1-seat having an affinity for the bow role), and so the solver
   tries to assign to 1-seat a rower who most has an affinity for the bow role.
   This problem also adds a "launch seat" for extra rowers, which has no affinity.
1. `any quantity of rowers.R`: generate as many launch seats as needed to accommodate all rowers.
1. `any quantity of boats.R`: generate as many "sponges" (fake rowers) to accommodate all available
   boat seats.
1. `frostbite.R`: an assignment problem for Greenlake Frostbite 2021.

The `frostbite` script is the most comprehensive. It supports real rowers and real boats.
It respects sweep/scull preferences, port/starboard preferences, and stroke/bow preferences.
It fills extra seats with sponges, and it puts overflow rowers on the launch.

The limitation of `frostbite` (and all other scripts) is that sometimes the algorithm distributes
rowers among the boats in an unrealistic way.
For example, if there is an 8+ and a double, with two sponges, the algorithm has no problem
putting one sponge in the 8+ and one in the double.
In reality, we'd want to put both sponges in the 8+.
I don't yet know how to teach the computer a more intelligent way of distributing sponges.

## Environment known to work

* macOS Big Sur
* R 4.1.1 (installed through Homebrew)

One-time setup in R:

    install.packages("lpSolve")

Run one of these programs on the command line:

    $ R --no-save < "port vs starboard.R"

# References

* [lpSolve documentation](https://cran.r-project.org/web/packages/lpSolve/lpSolve.pdf)
