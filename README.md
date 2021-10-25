# Philip's exploration of linear problems #

## What and why

This is my playground for exploring how to express problems such that they be solved by a
[linear solver](https://en.wikipedia.org/wiki/Linear_programming).

The real-world problem that motivates me is assigning rowers to rowboats.
This assignment problem needs to take into consideration available boats, rower skill,
and rower preferences.
It's normally solved by a coach, but I believe it can be efficiently solved by a computer.

My goal with this project is to learn by challenging myself with progressively difficult
linear problems, and documenting it here for myself and maybe other LP neophytes.

Please collaborate with me, either through GitHub pull requests or by email.
I'd love collaboration both in improving my understanding of linear problems and
the R code quality.

## Progression

For each script, see the comment block at the top for more info.

Problems solved using `lp.assign()`:

1. `simple quad lineup.R`: a super simple assignment problem where four rowers want to row a quad.
   Each rower has an affinity for a specific seat, and we maximize the affinity.
1. `port vs starboard.R`: one boat, and rowers have an affinity for port vs starboard.
1. `quad and launch.R`: Instead of rowers having affinities for particular seats, rowers have
   affinities for roles.  This better matches the real world. Now each seat of a boat has an
   affinity for a role (such as 1-seat having an affinity for the bow role), and so the solver
   tries to assign to 1-seat a rower who most has an affinity for the bow role.
   This problem also adds a "launch seat" for extra rowers, which has no affinity.
1. `sponges midboat.R`: seats define how important they are to be filled by a rower versus a sponge.
1. `any quantity of rowers.R`: generate as many launch seats as needed to accommodate all rowers.
1. `any quantity of boats.R`: generate as many "sponges" (fake rowers) to accommodate all available
   boat seats.
1. `frostbite.R`: an assignment problem for Greenlake Frostbite 2021.
    This one is the most comprehensive so far. It supports real rowers and real boats,
    sweep/scull preferences, port/starboard preferences, and stroke/bow preferences.
    It fills extra seats with sponges, and it puts overflow rowers on a launch.
    Lastly, it factors logic into separate functions to keep code clean.

Here I've reached the limit of `lp.assign()` and reached for `lp()`:

1. `two rowers three seats.R`: a small extension to an assignment problem, adding several constraints.
    We have two rowers, and we have two boats: a double and a single.
    One constraint forces some rower into a single.
    Another forces two rowers into a double, preventing a situation where one of the double's seats is empty.

## Environment known to work

* macOS Big Sur
* R 4.1.1 (installed through Homebrew)

One-time setup in R:

    install.packages("lpSolve")

Run one of these programs on the command line:

    $ R --no-save < "port vs starboard.R"

# References

* [lpSolve documentation](https://cran.r-project.org/web/packages/lpSolve/lpSolve.pdf)
