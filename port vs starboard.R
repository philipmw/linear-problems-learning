library(lpSolve)

#######################
# PROBLEM:
#   Some rowers want to row port, while some want to row starboard.
#
# OUTPUT:
#   solution: A matrix assigning each rower to a side that maximizes preference.
#
#######################

rowers = c(
  "P rower 1",
  "P rower 2",
  "P rower 3",
  "no pref rower 1",
  "no pref rower 2",
  "SB rower 1",
  "SB rower 2",
  "SB rower 3")

# source i, destination j
# /----> destinations are seat affinity, ordered bow to stern
# |
# v      sources are rowers
affinityRaw = c(
  c(0, 1, 0, 1, 0, 1, 0, 1), # port 1
  c(0, 1, 0, 1, 0, 1, 0, 1), # port 2
  c(0, 1, 0, 1, 0, 1, 0, 1), # port 3
  c(0, 0, 0, 0, 0, 0, 0, 0), # no pref 1
  c(0, 0, 0, 0, 0, 0, 0, 0), # no pref 2
  c(1, 0, 1, 0, 1, 0, 1, 0), # starboard 1
  c(1, 0, 1, 0, 1, 0, 1, 0), # starboard 2
  c(1, 0, 1, 0, 1, 0, 1, 0)  # starboard 3
)

affinityMatrix = matrix(affinityRaw, nrow=length(rowers), byrow=TRUE)

solution = lp.assign(affinityMatrix, direction="max")$solution

rownames(solution) = rowers

solution

# > solution
#                 [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
# P rower 1          0    0    0    1    0    0    0    0
# P rower 2          0    1    0    0    0    0    0    0
# P rower 3          0    0    0    0    0    1    0    0
# no pref rower 1    0    0    0    0    0    0    0    1
# no pref rower 2    0    0    0    0    1    0    0    0
# SB rower 1         0    0    0    0    0    0    1    0
# SB rower 2         0    0    1    0    0    0    0    0
# SB rower 3         1    0    0    0    0    0    0    0