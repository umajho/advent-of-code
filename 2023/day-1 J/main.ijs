input =: stdin ''
lines =: <;._1 LF, input

ch_0 =: 3&u: '0'
ch_9 =: 3&u: '9'

is_number =: (>: & ch_0) * (<: & ch_9)

i_first_last_num =: 3 : 0
  ((i. & 1), (i: & 1)) is_number y
)

first_last_num_ascii =: 3 : 0
  (({~) i_first_last_num) y
)

first_last_num =: (- & ch_0) @: first_last_num_ascii

for_first_digit =: 3 : 0
  (y - ch_0) * 10
)

for_second_digit =: 3 : 0
  y - ch_0
)

as_calibration =: 3 : 0
  (((10 & *) @: (0 & {)) + (1 & {)) @: first_last_num y
)

echo +/ as_calibration "1 (3&u: > lines)

exit''