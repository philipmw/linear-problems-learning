library(lpSolve)

#######################
# PROBLEM:
#   Given any number of rowers, assign them to available boats, and any extra rowers
#   are assigned to the launch.
#
# OUTPUT:
#   solution: A matrix assigning each rower to a specific seat that maximizes preference.
#
#######################

affinities = c(
  "stroke",
  "engine",
  "bow",
  "single",
  "cox"
)

rowers = data.frame(
              # --affinities-->
  engineRoomRower=c(0, 5, 0, 0, 0),
  loudRower=c(0, 2, 0, 0, 5),
  experiencedRowerDislikingBowing=c(5, 5, 3, 3, 5),
  experiencedRower=c(5, 5, 5, 5, 5),
  beginner1=c(0, 1, 0, 0, 0),
  beginner2=c(0, 1, 0, 0, 0)
)

launchAffinity = c(-1, -1, -1, -1, -1)

boats = list(
  jazz=data.frame(
    seat4=c(5, 3, 0, 0, 0),
    seat3=c(0, 5, 0, 0, 0),
    seat2=c(0, 5, 0, 0, 0),
    seat1=c(0, 3, 5, 0, 0)
  )
)

# Augment `boats` with a variable number of launch seats

qtyBoatSeats = length(do.call(c, boats))
launchSeatsNeeded = max(0, length(rowers)-qtyBoatSeats)

launchSeatList = list()
launchSeatNames = sapply(1:launchSeatsNeeded, function(x) paste("seat", x, sep=""))
for(launchSeatName in launchSeatNames)
  launchSeatList[[launchSeatName]] <- launchAffinity
boats$launch = data.frame(launchSeatList)

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
#
#                                 jazz.seat4 jazz.seat3 jazz.seat2 jazz.seat1 launch.seat1 launch.seat2
# engineRoomRower                          0          0          1          0            0            0
# loudRower                                0          1          0          0            0            0
# experiencedRowerDislikingBowing          1          0          0          0            0            0
# experiencedRower                         0          0          0          1            0            0
# beginner1                                0          0          0          0            1            0
# beginner2                                0          0          0          0            0            1
#
# Interpret this as:
#   the quad is stroked by an experienced rower who dislikes bowing,
#               bowed by an experienced rower (who presumably does not dislike bowing),
#               has an engine-room rower in 3-seat, a loud rower in 2-seat,
#               and two beginners riding the launch.
# This is not a good real-world solution, but makes sense in this very simplified system.

