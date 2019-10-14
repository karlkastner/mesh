% -rw-rw-r-- 1 pia pia 415 2016-07-24 12:37:44.883991851 +0200 /home/pia/phd/src/lib/@MMesh/generate_advancing_front.m

%(advancing front generator with loop intersection)
%ring = boundary
%- while ring not emptys
%	-> resample current ring into ds steps (integer)
%	-> at each step compute inward normal
%	-> put points at ds*sqrt(3/2)
%	-> advance to next row
%	-> if new ring intersects itself (loop)
%	-> cut in rings
%	-> remove rings with negative area
%	-> push rings of positive area
%-> close open centres by connecting opposit elements
%
