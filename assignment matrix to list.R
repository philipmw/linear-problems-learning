# rowers are alphabetized
rowers = c("albert", "doobie", "jan", "sara")

# seats are ordered
seats = c("seat4", "seat3", "seat2", "seat1")

mx = matrix(c(
  0, 1, 0, 0,
  1, 0, 0, 0,
  0, 0, 0, 1,
  0, 0, 1, 0), nrow=4, byrow=TRUE)

rownames(mx) = rowers
colnames(mx) = seats

mx
# output:
#        seat4 seat3 seat2 seat1
# albert     0     1     0     0
# doobie     1     0     0     0
# jan        0     0     0     1
# sara       0     0     1     0

assn_by_rower = c()
for (r in 1:nrow(mx)) {
  for (c in 1:ncol(mx)) {
    if (mx[r, c] == 1) {
      assn_by_rower = c(assn_by_rower, sprintf("%s in %s", rowers[r], seats[c]))
    }
  }
}
assn_by_rower
# output:
# [1] "albert in seat3" "doobie in seat4" "jan in seat1"    "sara in seat2"

assn_by_seat = c()
for (c in 1:ncol(mx)) {
  for (r in 1:nrow(mx)) {
    if (mx[r, c] == 1) {
      assn_by_seat = c(assn_by_seat, sprintf("%s in %s", rowers[r], seats[c]))
    }
  }
}
assn_by_seat
# output:
# [1] "doobie in seat4" "albert in seat3" "sara in seat2"   "jan in seat1"