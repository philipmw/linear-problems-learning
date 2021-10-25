# Philip's exploration of linear problems #

This is my playground for exploring how to express problems such that they be solved by a
[linear solver](https://en.wikipedia.org/wiki/Linear_programming).

My goal with this project is to learn by challenging myself with progressively difficult
linear problems, and documenting it here for myself and maybe other LP neophytes.

Please collaborate with me, either through GitHub pull requests or by email.
I'd love collaboration both in improving my understanding of linear problems and
the R code quality.

## Background and terms used

The real-world problem that motivates me is assigning rowers to rowboats in the sport
of [rowing](https://en.wikipedia.org/wiki/Rowing_(sport)).

Each row boat has some number of seats for rowers.
Boats range from a "single" (one rower) to an "eight", (eight rowers, one coxswain).
Rowing style can be [sweep](https://en.wikipedia.org/wiki/Sweep_rowing) or
[sculling](https://en.wikipedia.org/wiki/Sculling).
In sweep rowing, each rower is on port or starboard side, and some rowers have a preference
or a requirement (due to injury) for a specific side.
Lastly, different seats have differing responsibilities.
Some rowers prefer those responsibilities, while other rowers avoid them.

Ideally, the number of rowers fits exactly into available boats, so every seat
is occupied. But often there is a mismatch.
When there are empty seats, we "sponge" them: put a sponge in the rollers, so
the seat doesn't slide back and forth on the rollers during rowing.
On the other hand, when there is a small number of extra rowers, they ride
on the coaching launch to observe and maybe swap into someone's seat halfway
through the practice.

This, assigning rowers to rowboats needs to take into consideration available boats, rower skill,
and rower preferences.

Normally, the coach does the assignment in an ad-hoc approach, using intuition.
Sometimes this is suboptimal yet takes a long time.

I believe this problem can be efficiently solved by a computer.

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
1. `any quantity of boats.R`: generate as many sponges as needed to accommodate all seats.
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

Miscellaneous programs:

1. `assignment matrix to list.R`: a large assignment matrix is unwieldy to read.
   We know each row and column have exactly one 1, with the rest being 0. That's a lot of wasted visual space.
   This small program converts the matrix to a list, taking only those row/col pairs having value 1.
   The list is much easier to read.

## Environment known to work

* macOS Big Sur
* R 4.1.1 (installed through Homebrew)

One-time setup in R:

    install.packages("lpSolve")

Run one of these programs on the command line:

    $ R --no-save --no-echo < "port vs starboard.R"

# References

* [Assignment problem](https://en.wikipedia.org/wiki/Assignment_problem)
* [Linear programming](https://en.wikipedia.org/wiki/Linear_programming)
* [lpSolve documentation](https://cran.r-project.org/web/packages/lpSolve/lpSolve.pdf)
* [Rowing (sport)](https://en.wikipedia.org/wiki/Rowing_(sport))