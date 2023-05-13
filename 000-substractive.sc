// Based on https://composerprogrammer.com/teaching/supercollider/sctutorial/2.1%20Subtractive%20and%20Additive%20Synthesis.html


// White noise -> Low-pass filter (freq from 10khz->1000hz in 10 seconds)
{LPF.ar(WhiteNoise.ar(0.1),Line.kr(10000,20,10))}.scope

// Random noise at the frequency  -> Two pole resonant filter
{Ringz.ar(LFNoise0.ar(10000), Line.kr(1000, 20, 5), 1, Line.ar(0.01, 0, 10))}.play;


// Roughly the same thing, but in a neater format
(
{
var source, line, filter; //local variables for patch

	source=SinOsc.ar(880);
	line=Line.kr(10000, 20, 10);
	filter=Resonz.ar(source, line, 1);

filter // last thing returned from function in curly brackets is the final sound
}.scope;
)