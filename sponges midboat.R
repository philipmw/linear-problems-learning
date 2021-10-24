library(lpSolve)

#######################
# PROBLEM:
#   Sponges are empty seats. We want to leave empty seats strategically,
#   preferably mid-boat in larger boats.
#
# APPROACH:
#   Important seats have a higher weight, while unimportant (spongeable)
#   seats have a lower weight.
#   Real rowers have a higher weight, while sponges have a lower weight.
#   Since the assignment problem is maximizing a score, it maximizes
#   real rowers placed in important seats.
#
# OUTPUT:
#   solution: A matrix assigning sponges in safe places.
#
#######################

rowers = data.frame(
  person1=c(1),
  person2=c(1),
  person3=c(1),
  person4=c(1),
  person5=c(1),
  person6=c(1),
  person7=c(1),
  person8=c(1),
  person9=c(1),
  sponge1=c(0),
  sponge2=c(0))

# Boat seats range 1--5 in weight.
boats = list(
  eight=data.frame(
    cox=c(5),
    seat8=c(5),
    seat7=c(4),
    seat6=c(3),
    seat5=c(3),
    seat4=c(1),
    seat3=c(1),
    seat2=c(4),
    seat1=c(4)
  ),
  double=data.frame(
    seat2=c(5),
    seat1=c(5)
  )
)

seats = names(do.call(c, boats))

affinitiesNestedList = lapply(rowers, function(rowerAff) {
  lapply(do.call(c, boats), function(seatAff) {
    crossprod(rowerAff, seatAff)[,1]
  })
})

affinitiesVector = as.vector(unlist(affinitiesNestedList))

affinitiesMatrix = matrix(affinitiesVector, nrow=length(rowers), byrow=TRUE)
rownames(affinitiesMatrix) = names(rowers)
colnames(affinitiesMatrix) = seats

lpOutcome = lp.assign(affinitiesMatrix, direction="max")

if (lpOutcome$status != 0) {
  stop("No feasible solution")
}
solution = lpOutcome$solution

rownames(solution) = names(rowers)
colnames(solution) = seats

solution

# > solution
#         eight.cox eight.seat8 eight.seat7 eight.seat6 eight.seat5 eight.seat4
# person1         0           0           0           0           0           0
# person2         1           0           0           0           0           0
# person3         0           0           0           0           0           0
# person4         0           0           0           0           0           0
# person5         0           1           0           0           0           0
# person6         0           0           0           0           1           0
# person7         0           0           0           1           0           0
# person8         0           0           1           0           0           0
# person9         0           0           0           0           0           0
# sponge1         0           0           0           0           0           1
# sponge2         0           0           0           0           0           0
#         eight.seat3 eight.seat2 eight.seat1 double.seat2 double.seat1
# person1           0           0           0            1            0
# person2           0           0           0            0            0
# person3           0           0           1            0            0
# person4           0           1           0            0            0
# person5           0           0           0            0            0
# person6           0           0           0            0            0
# person7           0           0           0            0            0
# person8           0           0           0            0            0
# person9           0           0           0            0            1
# sponge1           0           0           0            0            0
# sponge2           1           0           0            0            0
#
# Interpret this as:
#   The 8+ has two sponges in seats 3 and 4, which are defined as the least important seats.
#   The double is filled with rowers.