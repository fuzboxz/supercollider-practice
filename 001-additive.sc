// Based on https://composerprogrammer.com/teaching/supercollider/sctutorial/2.1%20Subtractive%20and%20Additive%20Synthesis.html

// default frequency is A - 440hz
{SinOsc.ar}.scope

// two sinewaves added to gather leading to a 5hz beating as they conflict in phase
{SinOsc.ar(435, 0, 0.1) + SinOsc.ar(440, 0, 0.1)}.scope

// similar to above, although one plays in L channel, other plays in R channel, if you add third it will play in a third channel
{SinOsc.ar([400, 660], 0, 0.1)}.scope

// panning goes from -1 hard left to 1 hard right
// mouse x is mapped to panning mouse y is mapped to LPF
{Pan2.ar(LPF.ar(WhiteNoise.ar(0.1), MouseY.kr(100, 10000)), MouseX.kr(-1,1))}.scope

// turning multiple channels of sound and sending them into Mix will sum them in single channel, sending them into Pan2 will convert it to stereo
{Pan2.ar(Mix(SinOsc.ar([440, 660, 1200],0,0.1)))}.scope

// Additive synthesis
// If we know the spectrum (frequency content) of a sound, we can synthesize it by adding up sine tones for each frequency

// SAWTOOTH
// Contains odd and even harmonics as well
// Amplitude of harmonics is 1 / number of harmonic
// Sign alternates between -+1
(
{
	var n = 16; //partials
	var wave = Mix.fill(n,{|i|
		var mult = ((-1)**i)*(0.5/((i+1)));
		SinOsc.ar(440*(i+1))*mult
	});
	Mix.fill(n,{|i| post(440*i)});
	Pan2.ar(wave/n, 0.0); //stereo center panning
}.scope;
)

// SQUARE
// Contains odd harmonics only, no even, amplitude falls of as 1/harmonicnumber, clarinet tone
//
(
{
	var n = 16; //partials
	var wave = Mix.fill(n, {|i|
		var harmonicnumber = 2*i+1; // odd harmonics only
		SinOsc.ar(440*harmonicnumber)/harmonicnumber
	})*0.1;

	Pan2.ar(wave, 0.0); // stereo panning
}.scope
)

// Triangle
// Odd harmonics as well, amplitude falls as 1 over harmonicnumber

(
{
	var n = 16;
	var wave = Mix.fill(n, {|i|
		var harmonicnumber = 2*i+1; // odd harmondics only
		var mult = ((-1)**((harmonicnumber-1)/2))*(1.0/(harmonicnumber*harmonicnumber));
	SinOsc.ar(440*i)*mult});
	Pan2.ar(wave, 0.0)
}.scope
)

// Bell sound
// Minor third bell [0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1]
{Pan2.ar(Mix(SinOsc.ar(500*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1*[0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1])),0)}.scope


(
var n = 10;
{Pan2.ar(Mix(SinOsc.ar(250 * (1..n), 0, 1/n)), 0)}.scope;
)