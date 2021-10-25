library(lpSolve)

# Supposing we have two rowers, and we need to assign them to a double and a single.
#
# The only reasonable assignment is to put both into a double, since we cannot
# sponge one of the seats.
#
# How can we ensure that both rowers are in one double?
#
# I believe that the assignment problem cannot handle this, because we cannot indicate
# relationships between seats or rowers.
#
# So let's try a more general approach, using linear programming.
#
# https://en.wikipedia.org/wiki/Assignment_problem#Solution_by_linear_programming
#
# We have two rowers (A_{0,1}) and three seats (T_{0,2}).
# Let's say seats 0 and 1 are a double, and seat 2 is a single.
#
# The following is an implementation of the wikipedia page's description of the
# linear problem.
#
# x_ij is 0 or 1, indicating whether the bipartite graph has an edge i->j.
# In our case, all rowers are eligible for all seats, so x is 1 for all ij.
#
# maximize sumof(w_ij * x_ij) ----- w00*x00 + w01*x01 + w10*x10 + ...
f.obj = c(1, 1, 1,  1, 1, 1)

# subject to
f.con = matrix(c(
            # x00 x01 x02 | x10 x11 x12

# for i=0: x00 + x01 + x02 = 1
            1, 1, 1,  0, 0, 0,
# for i=1: x10 + x11 + x12 = 1
            0, 0, 0,  1, 1, 1,

# for j=0: x00 + x10 = 1
            1, 0, 0,  1, 0, 0,
# for j=1: x01 + x11 = 1
            0, 1, 0,  0, 1, 0,
# for j=2: x02 + x12 = 1
            0, 0, 1,  0, 0, 1,

# x00 <= 1
            1, 0, 0,  0, 0, 0,
# x01 <= 1
            0, 1, 0,  0, 0, 0,
# x02 <= 1
            0, 0, 1,  0, 0, 0,
# x10 <= 1
            0, 0, 0,  1, 0, 0,
# x11 <= 1
            0, 0, 0,  0, 1, 0,
# x12 <= 1
            0, 0, 0,  0, 0, 1
          ),
          nrow=11, byrow=TRUE)
f.dir = rep("<=", 11) # this should be "=" for the first 5, but we have fewer rowers than seats
f.rhs = rep(1, 11)

# So far, this has been exactly the assignment problem.
# We have 6 variables and 11 constraints.

# Now we have variants, each of which can be enabled by uncommenting it.

### VARIANT A: Rower 1 prefers rowing a single.
# f.obj = c(1, 1, 1,  1, 1, 2) # increase w_12
### end of variant A

# Now we add new constraints that the regular assignment problem
# does not support.
#
### VARIANT B: Force some rower into a single:
# f.con = rbind(f.con, c(0, 0, 1,  0, 0, 1))
# f.dir = c(f.dir, ">=")
# f.rhs = c(f.rhs, 1)
### end of variant B

### VARIANT C: The double has two rowers.
# f.con = rbind(f.con, c(1, 1, 0,  1, 1, 0))
# f.dir = c(f.dir, ">=")
# f.rhs = c(f.rhs, 2)
### end of variant C

### VARIANT D: The double has either zero or two rowers.
#   This would be ideal, but I don't know how to achieve this.
#   Best approximation is variant C: if the double exists, then it must
#   be full. If we cannot fill it, then remove it from the system.
### end of variant D

# An interesting observation that confirms that this whole thing is working:
# We cannot have both variant B and C enabled at once.

##############

lpOut = lp("max", f.obj, f.con, f.dir, f.rhs)

if (lpOut$status != 0) {
  stop("No feasible solutions")
}

solution = matrix(lpOut$solution, nrow=2, byrow=TRUE)
rownames(solution) = c("rower1", "rower2")
colnames(solution) = c("double2", "double1", "single")
solution
