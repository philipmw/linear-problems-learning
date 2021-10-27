library(lpSolve)

#######################
# PROBLEM:
#   We have Greenlake Frostbite events and lineups. We want to form lineups
#   during regular practices as similar to Frostbite as possible.
#   We also want to accommodate drop-in rowers who aren't racing.
#
# APPROACH:
#   While I cannot express specific lineups (rower/boat/seat), I express
#   affinity for a seat type for each rower.
#   This is pretty accurate, though it results in mixing of rowers in same
#   boat categories. For example, if we have two doubles racing, their
#   strokes and bows may be mismatched.
#
# OUTPUT:
#   solution: A matrix assigning each rower to a boat and seat that maximizes preference.
#
#######################

# Affinities are given in three rows for readability:
#   [8+ cox]  [4(x)+ cox]
#   [scull stroke]  [scull engine]  [scull bow]
#   [sweep stroke]  [sweep port]  [sweep starboard]

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
  JessicaM=c( # 6-seat of 8+
    1, 1,
    1, 1, 1,
    3, 5, 1),
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
  Shaina=c( # 3-seat of a 4+
    1, 1,
    1, 1, 1,
    1, 1, 5),
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

# Boat seat weights range 0--5.
# Seats that shouldn't be sponged reach 5 in at least one category,
# while spongeable seats do not have 5 in any category.
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
        0, 4, 1), # spongeable
    seat3=c(
        0, 0,
        0, 0, 0,
        0, 1, 4), # spongeable
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
        0, 4, 1), # spongeable
    seat3=c(
        0, 0,
        0, 0, 0,
        0, 1, 4), # spongeable
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

############ end of customer-serviceable parts ##############

# This function creates a "launch boat", with a variable number of seats,
# to accommodate rowers that don't fit into existing real boats.
# It returns this new boat.
createLaunchBoat = function(rowers, boats) {
  launchAffinity = c(
      0, 0,
      0, 0, 0,
      0, 0, 0)

  qtyBoatSeats = length(do.call(c, boats))
  launchSeatsNeeded = max(0, length(rowers)-qtyBoatSeats)

  launchSeatList = list()
  launchSeatNames = sapply(
    seq(1, launchSeatsNeeded, length.out=launchSeatsNeeded),
    function(x) paste("seat", x, sep=""))
  for(launchSeatName in launchSeatNames)
    launchSeatList[[launchSeatName]] <- launchAffinity
  data.frame(launchSeatList)
}

# This function creates a variable number of "sponges", to fill empty seats in boats.
# Sponges act just like rowers, but with an affinity that minimizes the probability
# of being selected for a seat.
# It returns the data frame of sponges, which needs to be added to the list of rowers.
createSponges = function(rowers, boats) {
  spongeAffinity = c(
      0, 0,
      0, 0, 0,
      0, 0, 0)

  qtyBoatSeats = length(do.call(c, boats))
  spongesNeeded = max(0, qtyBoatSeats-length(rowers))

  spongesNeeded

  spongeList = list()
  spongeNames = sapply(
    seq(1, spongesNeeded, length.out=spongesNeeded),
    function(x) paste("sponge", x, sep=""))
  for(spongeName in spongeNames)
    spongeList[[spongeName]] <- spongeAffinity
  data.frame(spongeList)
}

# This function takes equal-sized data frames of rowers and boat seats,
# computes assignments, and adds row names and column names.
computeAssignments = function(rowers, boats) {
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
}

assnMatrixToListByRower = function(mx) {
  assn_by_rower = c()
  for (r in 1:nrow(mx)) {
    for (c in 1:ncol(mx)) {
      if (mx[r, c] > 0) { # mx values are `numeric`, not `integer`
        assn_by_rower = c(assn_by_rower, sprintf("%s in %s", rownames(mx)[r], colnames(mx)[c]))
      }
    }
  }
  assn_by_rower
}

assnMatrixToListBySeat = function(mx) {
  assn_by_seat = c()
  for (c in 1:ncol(mx)) {
    for (r in 1:nrow(mx)) {
      if (mx[r, c] > 0) { # mx values are `numeric`, not `integer`
        assn_by_seat = c(assn_by_seat, sprintf("%s: %s", colnames(mx)[c], rownames(mx)[r]))
      }
    }
  }
  assn_by_seat
}

# Augment `boats` with a variable number of launch seats
boats$launch = createLaunchBoat(rowers, boats)

# Augment `rowers` with a variable number of sponges
rowers = append(rowers, createSponges(rowers, boats))

# Now that we have the same quantity of rowers and seats,
# we can do the assignments.
solution_mx = computeAssignments(rowers, boats)

# print assignments sorted by rower
assnMatrixToListByRower(solution_mx)

# print assignments sorted by seat
assnMatrixToListBySeat(solution_mx)
