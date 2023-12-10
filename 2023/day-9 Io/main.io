List zipWith := method(ys, op,
  len := self size min(ys size)
  l := List clone
  for(i, 0, len-1,
    l append(op call(self at(i), ys at(i)))
  )
  l
)

List diff := method(
  minuends := self itemCopy
  minuends removeFirst
  minuends zipWith(self, block(a, b, a - b))
)

List every := method(p,
  failed := false
  for(i, 0, (self size) - 1,
    (p call(self at(i)) not) ifTrue(
      failed = true
      break
    )
  )
  failed not
)

lines := File standardInput readLines
inputs := lines map(line,
  line split map(asNumber)
)

isPart2 := (System getEnvironmentVariable("PART_2")) != nil

inputs = if(isPart2 not,
  inputs,
  inputs map(l, l reverse)
)

outputs := inputs map(input,
  values := input
  nextValue := 0
  loop(
    nextValue = nextValue + (values last)
    values = values diff
    (values every(block(x, x == 0))) ifTrue(break)
  )
  nextValue
)

outputs sum println