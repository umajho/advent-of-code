#!/usr/bin/env factor
IN: day-6
USING: splitting math.functions ;
USING: assocs environment io kernel math math.parser prettyprint sequences sorting ;

DEFER: read-and-parse-line
DEFER: calc-ways
DEFER: calc-roots
DEFER: calc-discriminant
DEFER: is-integer
DEFER: ceil

: main ( -- )
  read-and-parse-line read-and-parse-line
  
  "PART_2" os-env not [
    zip
    [ calc-ways ] map
    product
  ] [
    [ [ number>string ] map "" join string>number ] bi@
    { } swap prefix swap prefix
    calc-ways
  ] if
  .
  ;

: read-and-parse-line ( -- numbers )
  readln split-words [ string>number ] map [ ] filter
  ;

: calc-ways ( t-d -- roots )
  { -1 } swap             ! `{ -1 } t-d`
  dup first               ! `{ -1 } t-d t`
  swapd suffix            ! `t-d { -1 t }`
  swap second neg suffix  ! `{ -1 t -d }`

  calc-roots sort
  ! ^: `{ x_1 x_2 }`

  dup first
  dup is-integer [ 1 + ] [ ceil ] if
  swap second
  dup is-integer [ 1 - ] [ floor ] if
  { } swap prefix swap prefix
  [ >fixnum ] map

  dup second swap first - 1 +
  ;

: calc-roots ( a-b-c -- roots )
  ! a-b-c
  dup calc-discriminant dup neg { } swap suffix swap suffix
  swap dup { } swap suffix swap suffix zip
  ! ^: X=`{ { +discriminant a-b-c } { -discriminant a-b-c } }`

  [
    dup second second neg   ! `X -b`
    swap dup first swapd +  ! `X -b±D`
    swap second first 2 * / ! `(-b±D)/2a`
  ] map
  ;

: calc-discriminant ( a-b-c -- discriminant )
  dup second sq swap
  dup first swap third * 4 *
  - sqrt
  ;

: is-integer ( x -- t/f )
  dup floor = ;

: ceil ( x -- ceiled )
  neg floor neg ;

MAIN: main