load 'regex'

is_part_2 =: -. (getenv 'PART_2') -: 0

input =: stdin ''
lines_raw =: <;._1 LF, input

transform_line =: 4 : 0
if. y
do. 
  x =. ('one'; 'o1ne') rxrplc x
  x =. ('two'; 't2wo') rxrplc x
  x =. ('three'; 't3hree') rxrplc x
  x =. ('four'; 'f4our') rxrplc x
  x =. ('five'; 'f5ive') rxrplc x
  x =. ('six'; 's6ix') rxrplc x
  x =. ('seven'; 's7even') rxrplc x
  x =. ('eight'; 'e8ight') rxrplc x
  ('nine'; 'n9ine') rxrplc x
else. x
end.
)

lines =: < (transform_line & is_part_2) "1 > lines_raw

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

as_calibration =: 3 : 0
  (((10 & *) @: (0 & {)) + (1 & {)) @: first_last_num y
)

echo +/ as_calibration "1 (3&u: > lines)

exit''