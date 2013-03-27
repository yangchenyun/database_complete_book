(: fetch data through an interation :)
let $movies := doc('movies.xml')
for $m in $movies/Movies/Movie
return <Movie>{ $m/Version/Star }</Movie>

(: replace variables by its value :)
let $movies := doc('movies.xml')
for $m in $movies/Movies/Movie
return <Movie title = "{$m/@title}">{$m/Version/Star}</Movie>

(: put tags around a sequence :)
let $starReq := (
  let $movies := doc('movies.xml')
  for $m in $movies/Movies/Movie
  return $m/Version/Star
)
return <Star>{ $starReq }</Star>

(: use join in xquery :)
let $movies := doc('movies.xml'),
  $stars := doc('stars.xml')
for $s1 in $movies/Movies/Movie/Version/Star,
  $s2 in $stars/Stars/Star
where data($s1) = data($s2/Name)
return <Cities>{ $s2/Address/City }</Cities>

(: erronous comparison examples :)
(: because = stands: some item in the sequence matches... :)
let $stars := doc('stars.xml')
for $s in $stars/Stars/Star
where $s/Address/Street = '123 Maple St.' 
and $s/Address/City = 'Malibu'
return $s/Name

(: another erronous comparison, because eq only allows for single item  :)
let $stars := doc('stars.xml')
for $s in $stars/Stars/Star
where $s/Address/Street eq '123 Maple St.' 
and $s/Address/City eq 'Malibu'
return $s/Name


(: distinct stars, for a string sequence :)
let $starReq := distinct-values(
  let $movies := doc('movies.xml')
  for $m in $movies/Movies/Movie
  return $m/Version/Star
)
return <Star>{ $starReq }</Star>

(: qualification in xquery :)
let $stars := doc('stars.xml')
for $s in $stars/Stars/Star
where every $c in $s/Address/City satisfies
  $c = 'Malibu'
return $s/Name

(: by default the comparison follows the 'some' logic :)
let $stars := doc('stars.xml')
return <Name>
{
  for $s in $stars/Stars/Star
  where $s/Address/City = 'Malibu'
  return $s/Name
}
</Name>

(: aggregation functions :)
let $movies := doc('movies.xml')
for $m in $movies/Movies/Movie
  where count($m/Version) > 1
  return $m
