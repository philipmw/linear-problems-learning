library(lpSolve)

#######################
# PROBLEM:
#   Given more boat seats than rowers, fill empty seats with sponges.
#
# OUTPUT:
#   solution: A matrix assigning each rower to a specific seat that maximizes preference.
#
#######################

affinities = c(
  "stroke",
  "engine",
  "bow"
)

rowers = data.frame(
              # --affinities-->
  rower1=c(5, 5, 5),
  rower2=c(5, 5, 5),
  rower3=c(5, 5, 5),
  rower4=c(5, 5, 5),
  rower5=c(5, 5, 5)
)

spongeAffinity = c(0, 0, 0)

boats = list(
  jazz=data.frame(
    seat4=c(5, 3, 1),
    seat3=c(1, 5, 1),
    seat2=c(1, 5, 1),
    seat1=c(1, 3, 5)
  ),
  jack=data.frame(
    seat2=c(5, 3, 1),
    seat1=c(1, 3, 5)
  )
)

# Augment `rowers` with a variable number of sponges

qtyBoatSeats = length(do.call(c, boats))
spongesNeeded = max(0, qtyBoatSeats-length(rowers))

spongeList = list()
spongeNames = sapply(seq(1, spongesNeeded, length.out=spongesNeeded), function(x) paste("sponge", x, sep=""))
for(spongeName in spongeNames)
  spongeList[[spongeName]] <- spongeAffinity
rowers = append(rowers, data.frame(spongeList))

seats = names(do.call(c, boats))

# Affinities of each rower for each boat and seat.
# We have to have a square matrix, so we need exactly as many seats as rowers.

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
#         jazz.seat4 jazz.seat3 jazz.seat2 jazz.seat1 jack.seat2 jack.seat1
# rower1           0          0          0          0          1          0
# rower2           0          0          0          1          0          0
# rower3           1          0          0          0          0          0
# rower4           0          0          1          0          0          0
# rower5           0          0          0          0          0          1
# sponge1          0          1          0          0          0          0