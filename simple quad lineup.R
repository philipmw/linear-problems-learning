library(lpSolve)

#######################
# PROBLEM:
#   Given four rowers of differing skill levels, assign them to a quad sculling boat.
#
# OUTPUT:
#   solution: A matrix assigning each rower to a specific seat that maximizes preference.
#
#######################

rowers = c(
  "engine room rower",
  "experienced rower who dislikes bowing",
  "newer skilled rower",
  "experienced skilled rower")

# source i, destination j
# /----> destinations are seat affinity, ordered bow to stern
# |
# v      sources are rowers
affinityRaw = c(
  c(0, 5, 5, 4),
  c(3, 5, 5, 5),
  c(4, 5, 5, 5),
  c(5, 5, 5, 5)
)

affinityMatrix = matrix(affinityRaw, nrow=4, byrow=TRUE)

solution = lp.assign(affinityMatrix, direction="max")$solution

rownames(solution) = rowers

solution

# > solution
#                                       [,1] [,2] [,3] [,4]
# engine room rower                        0    1    0    0
# experienced rower who dislikes bowing    0    0    1    0
# newer talented rower                     0    0    0    1
# experienced talented rower               1    0    0    0
#
# Interpret this as: the quad is bowed by "experienced talented rower",
# stroked by "newer talented rower", with the other two being mid-boat.
