library(lpSolve)

#######################
# PROBLEM:
#   We have Greenlake Frostbite events and lineups. We want to form lineups
#   during regular practices as similar to Frostbite as possible.
#   We also want to accommodate drop-in rowers who aren't racing.
#
# OUTPUT:
#   solution: A matrix assigning each rower to a boat and seat that maximizes preference.
#
#######################

affinities = c(
    "8+ cox",
    "4(x)+ cox",

    "scull stroke",
    "scull engine",
    "scull bow",

    "sweep stroke",
    "sweep port",
    "sweep starboard")

rowers = data.frame(
              # --affinities-->
  Aubrey=c( # cox only
    5, 4,
    2, 1, 3,
    3, 1, 1),
  Alyssa=c( # 7-seat in 8+ and blind bow in double
    1, 1,
    3, 3, 5,
    1, 1, 5),
  Anthony=c( # 7-seat in 8+
    1, 1,
    0, 0, 0,
    0, 1, 5),
  Bara=c( # stroke of double, bow of quad
    1, 1,
    5, 3, 5,
    1, 1, 1),
  Erick=c( # stroke of quad, 1-seat of 8+
    1, 1,
    5, 3, 3,
    0, 1, 5),
  Fatima=c( # 1-seat of 8+
    1, 1,
    1, 1, 1,
    1, 2, 5),
  James=c( # 5-seat of 8+, 3-seat of 8+
    1, 1,
    0, 0, 0,
    0, 1, 5),
  Janee=c( # 3-seat of 8+
    1, 1,
    1, 1, 1,
    1, 1, 5),
  JessicaM=c( # 6-seat of 8+, 3-seat of 4+
    1, 1,
    1, 1, 1,
    3, 5, 5),
  JessicaT=c( # 1-seat and 7-seat of 8+
    1, 1,
    1, 1, 1,
    1, 3, 5),
  Johnny=c( # stroke seat of 8+, bow seat of quad
    1, 1,
    3, 3, 5,
    5, 3, 1),
  Julia=c( # stroke of quad, 1-seat of coxed four
    1, 1,
    5, 3, 3,
    1, 1, 5),
  Kayla=c( # 2-seat of 4+, 4-seat of 8+
    1, 1,
    1, 1, 1,
    3, 5, 1),
  Linzy=c( # stroke of double, stroke of 8+
    1, 1,
    5, 3, 1,
    5, 3, 1),
  Matthew=c( # 2-seat and 6-seat of 8+
    1, 1,
    0, 0, 0,
    1, 5, 0),
  Miranda=c( # 4-seat of 8+
    1, 1,
    1, 1, 1,
    3, 5, 2),
  Natalia=c( # 2-seat of quad, 2-seat of 8+
    1, 1,
    3, 5, 2,
    3, 5, 1),
  Nico=c( # 3-seat of quad, 5-seat of 8+
    1, 1,
    3, 5, 3,
    1, 1, 5),
  Patty=c( # 3-seat of quad
    1, 1,
    3, 5, 3,
    1, 1, 1),
  Priyanka=c( # stroke of 4+, 2-seat of 8+
    1, 1,
    1, 1, 1,
    5, 3, 1),
  Sarah=c( # 8-seat and 5-seat of 8+
    5, 4,
    5, 3, 4,
    1, 1, 1),
  Shannon=c( # bow of double, 3-seat of 8+
    1, 1,
    2, 3, 5,
    1, 2, 5),
  Stephen=c( # 4-seat of 8+
    1, 1,
    0, 0, 0,
    1, 5, 0),
  SteveK=c( # 2-seat of quad, 6-seat of 8+
    1, 1,
    2, 5, 2,
    2, 5, 1),

  # add drop-ins below
  dropin=c(
    3, 3,
    1, 5, 1,
    1, 5, 5)
)

boats = list(
  chai=data.frame(
    seat2=c(
        0, 0,
        5, 3, 3,
        1, 1, 1),
    seat1=c(
        0, 0,
        3, 3, 5,
        1, 1, 1)
  ),

  jack=data.frame(
    seat2=c(
        0, 0,
        5, 3, 3,
        1, 1, 1),
    seat1=c(
        0, 0,
        3, 3, 5,
        1, 1, 1)
  ),


  jazz=data.frame(
    seat4=c(
        0, 0,
        5, 3, 3,
        1, 1, 1),
    seat3=c(
        0, 0,
        3, 5, 3,
        1, 1, 1),
    seat2=c(
        0, 0,
        3, 5, 3,
        1, 1, 1),
    seat1=c(
        0, 0,
        3, 3, 5,
        1, 1, 1)
  ),

  terrio=data.frame(
    cox=c(
        0, 5,
        0, 0, 0,
        0, 0, 0),
    seat4=c(
        0, 0,
        0, 0, 0,
        5, 3, 0),
    seat3=c(
        0, 0,
        0, 0, 0,
        0, 0, 5),
    seat2=c(
        0, 0,
        0, 0, 0,
        0, 5, 0),
    seat1=c(
        0, 0,
        0, 0, 0,
        0, 0, 5)
  ),

  darkness=data.frame(
    cox=c(
        5, 0,
        0, 0, 0,
        0, 0, 0),
    seat8=c(
        0, 0,
        0, 0, 0,
        5, 3, 1),
    seat7=c(
        0, 0,
        0, 0, 0,
        0, 1, 5),
    seat6=c(
        0, 0,
        0, 0, 0,
        0, 5, 1),
    seat5=c(
        0, 0,
        0, 0, 0,
        0, 1, 5),
    seat4=c(
        0, 0,
        0, 0, 0,
        0, 5, 1),
    seat3=c(
        0, 0,
        0, 0, 0,
        0, 1, 5),
    seat2=c(
        0, 0,
        0, 0, 0,
        0, 5, 1),
    seat1=c(
        0, 0,
        0, 0, 0,
        0, 1, 5)
  ),

  zellner=data.frame(
    cox=c(
        5, 0,
        0, 0, 0,
        0, 0, 0),
    seat8=c(
        0, 0,
        0, 0, 0,
        5, 3, 1),
    seat7=c(
        0, 0,
        0, 0, 0,
        0, 1, 5),
    seat6=c(
        0, 0,
        0, 0, 0,
        0, 5, 1),
    seat5=c(
        0, 0,
        0, 0, 0,
        0, 1, 5),
    seat4=c(
        0, 0,
        0, 0, 0,
        0, 5, 1),
    seat3=c(
        0, 0,
        0, 0, 0,
        0, 1, 5),
    seat2=c(
        0, 0,
        0, 0, 0,
        0, 5, 1),
    seat1=c(
        0, 0,
        0, 0, 0,
        0, 1, 5)
  )
)

# Augment `boats` with a variable number of launch seats

launchAffinity = c(
    0, 0,
    0, 0, 0,
    0, 0, 0)

qtyBoatSeats = length(do.call(c, boats))
launchSeatsNeeded = max(0, length(rowers)-qtyBoatSeats)

launchSeatList = list()
launchSeatNames = sapply(seq(1, launchSeatsNeeded, length.out=launchSeatsNeeded), function(x) paste("seat", x, sep=""))
for(launchSeatName in launchSeatNames)
  launchSeatList[[launchSeatName]] <- launchAffinity
boats$launch = data.frame(launchSeatList)

boats

# Augment `rowers` with a variable number of sponges

spongeAffinity = c(
    0, 0,
    0, 0, 0,
    0, 0, 0)

qtyBoatSeats = length(do.call(c, boats))
spongesNeeded = max(0, qtyBoatSeats-length(rowers))

spongesNeeded

spongeList = list()
spongeNames = sapply(seq(1, spongesNeeded, length.out=spongesNeeded), function(x) paste("sponge", x, sep=""))
for(spongeName in spongeNames)
  spongeList[[spongeName]] <- spongeAffinity
rowers = append(rowers, data.frame(spongeList))

rowers

#####

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
