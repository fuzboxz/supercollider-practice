//////// -- first steps + tones -- ////////
// This part will teach the basics of SuperCollider and making sounds.
// By the end of this part, you should be able to mix different sounds
// together and use additive synthesis to make tones and overtones.


s.boot;
s.meter;
s.plotTree;
s.freqscope;

//////// 1 ////////
// this is a comment! it is valid code but doesn't do anything




//////// 2 ////////
// now, this is a line of code that does something!
// this line prints something in the window over there ->
// run any line of code by putting your cursor on it and then
// press <Ctl>+<Enter>
"I love SuperCollider".postln; // <- make sure to always have a ";" after code




//////// 3 ////////
// parentheses make it easy to
// run multiple lines of code with <Ctl>+<Enter>
(
"I love SuperCollider".postln;
"SuperCollider loves me".postln;
)




//////// 4 ////////
// disorder of operations!
// there is no order of operations in SuperCollider!
// beware beware beware beware
(
 (100+2/2).postln; // what does this equal?
 (100+(2/2)).postln; // force order of operations using parentheses
)




//////// 5 ////////
// semicolons make functions
// you can assign variables using letters a-z or with ~variableName
// execute each step, incrementally

// step 1: create functions stored in a variable
(
a={"I love SuperCollider".postln;};
~someVariable={"SuperCollider loves me".postln;};
)
// step 2a: run the first function
a.value; // .value evaluates the function stored in "a"
// step 2b: run the second function
~someVariable.value;





//////// 6 ////////
// functions can have arguments and variables!
// arguments and variables are similar, except that arguments can be passed into functions when the function is called.
// step 1: create a function that contains arguments and variable
(
a={
	arg name; // arguments must be defined first
	var something; // then variables must be defined next
	something="SuperCollider"; // variables can be assigned later
	(name++", do you like "++something++"?").postln;
};
)

// step 2: execute the function
a.value("zack");




//////// 7 ////////
// let's get into the music now!
// we need to boot the server to start music making:
// goto Server -> Boot Server
// or press <Ctl>+B (windows)





//////// 8 ////////
// lets make a function that generates a Sine wave
// SuperCollider generates things with a "UGen"
// the UGen for Sine waves is called "SinOsc"
(
{
	SinOsc.ar(freq:220);
}.plot(0.02); // .plot(x) will plot it for x seconds
)




//////// 9 ////////
// finally lets make a sound!
// just add .play to our function
(
{
	SinOsc.ar(freq:220);
}.play; // .play will play it
)
// stop it using <Ctl>+.
// you just made a synth!
// it makes one sound and only one sound,
// but who cares!? you did it!




//////// 10  ////////
// lets have the synth make another sound
// by adding an argument (see 6)
// and also save it to a variable (see 5)
(
// save a variable and a Sine UGen to the "x" variable
x={
	arg freq=220;
	SinOsc.ar(freq:freq);
}.play; // .play will play it
)
// now you can run each of these lines to change it!
x.set(\freq,440);
x.set(\freq,60.midicps); // .midicps converts midi note to frequency (cycles per second)
x.free; // we can stop the synth running this line




//////// 11 ////////
// UGens constantly generate numbers
// but they can also be treated like numbers,
// you can add and subtract them.
// for instance, we can add volume:
(
x={
	arg freq=220, amp=0.5;
	SinOsc.ar(freq:freq)*amp;
}.play;
)
// lowers the volume
x.set(\amp,0.1);
// raise the volume and set the frequency (you can do multiple things)
x.set(\amp,0.7,\freq,440);
// free the synths!
x.free;




//////// 12 ////////
// UGens have all sorts of parameters
// SinOsc happens to have one that gets multiplied, call "mul".
// highlight "SinOsc" and press <Ctl>+D [win] or <command>+D [mac] to see the parameters
(
x={
	arg freq=220, amp=0.5;
	SinOsc.ar(freq:freq,mul:amp);
}.play; // .play will play it
)
x.free;
// note: this is exactly the same as in 11
// in SuperCollider there are always many ways to do the same thing




//////// 13 ////////
// lets use Out.ar to specify the sound
// Out will output the result to the "bus"
// bus "0" is the audio out
(
x={
	arg freq=220, amp=0.5;
	var snd;
	snd=SinOsc.ar(freq:freq,mul:amp);
	Out.ar(0,snd);
}.play;
)
x.free;
// note: this is exactly the same as 11 and 12
// in 11 and 12, SuperCollider assumed this is what
// we wanted




//////// 14 ////////
// "multichannel expansion" is SuperCollider's secret sauce.
// "multichannel expansion" also sounds cool to drop in conversation.
// "multichannel expansion" means that SuperCollider will automatically
// generate multiple UGens for you when a parameter has an array
// and assign each UGen to an audio channel (e.g. left and right speakers).
(
x={
	arg freq=220, amp=0.5;
	var snd;
	snd=SinOsc.ar(freq:[freq,freq*2],mul:[amp,amp/2]);
	Out.ar(0,snd);
}.play;
)
// you should hear
// lower frequency at higher volume in left ear
// higher frequency at lower volume in right ear
x.free;




//////// 15 ////////
// sometimes you don't want multichannel expansion
// so you can mix it down to a single channel using the
// Mix.ar UGen
// then you can split it across the left/right using Splay
(
x={
	arg freq=220, amp=0.5;
	var snd;
	snd=SinOsc.ar(freq:[freq,freq*2,freq*4],mul:[amp,amp/2,amp/8]);
	snd=Mix.ar(snd); // mixes the three channels into 1
	snd=Splay.ar(snd);
	Out.ar(0,snd);
}.play;
)
x.free;




//////// 16 ////////
// lets define a synth to use multiple times
// using a "SynthDef"
(
SynthDef("coolsynth",{ // add SynthDef here, with a name
	arg freq=220, amp=0.1;
	var snd;
	snd=SinOsc.ar(freq:[freq,freq*2,freq*4],mul:[amp,amp/2,amp/8]);
	snd=Mix.ar(snd);
	snd=Splay.ar(snd);
	Out.ar(0,snd);
}).add; // use "add" instead of play
)

// now you can create multiple instances of them!
(
x = Synth("coolsynth",[\freq,60.midicps]);
y = Synth("coolsynth",[\freq,62.midicps]);
z = Synth("coolsynth",[\freq,65.midicps]);
)

// and each can be set later!
(
x.set(\freq,58.midicps);
y.set(\freq,62.midicps);
z.set(\freq,67.midicps);
)
(
x.set(\freq,60.midicps);
y.set(\freq,62.midicps);
z.set(\freq,65.midicps);
)

// set them all free!
(
x.free;
y.free;
z.free;
)




//////// 17 ////////
// you can treat UGens like numbers
// lets add them together and make a new oscillator
// famous oscillators to play with:
// SinOsc, LFSaw, Tri
(
SynthDef("coolsynth",{
	arg freq=110, amp=0.1;
	var snd;
     // you can directly Mix
	snd=Mix.ar(
		SinOsc.ar(freq:[freq,freq*2,freq*4],mul:[amp,amp/2,amp/4])
	);
    // lets add some harmonic from a saw wave
	snd=snd+(0.1*Mix.ar(
		Saw.ar(freq:[freq,freq*2,freq*3,freq*4],mul:[amp,amp/2,amp/3,amp/4]))
	);
     // note: the following doesn't work, why not?
	// snd=snd+0.5*Mix.ar(Saw.ar(freq:[freq,freq*2],mul:[amp,amp/2]));
	snd=Splay.ar(snd);
	Out.ar(0,snd);
}).play;
)



//////// 18 ////////
// fancy multiexpansion
// use Array.fill(<num>,{arg i; <code>})
// to easily create an additive synth
// this is same as 17
(
SynthDef("coolsynth",{
	arg freq=110, amp=0.1;
	var snd;
     // you can directly Mix
	snd=Mix.ar(
		Array.fill(2,{arg i; SinOsc.ar(freq:freq*(2**i),mul:amp/(2**i))})
	);
    // lets add some harmonic from a saw wave
	snd=snd+(0.1*Mix.ar(
		Array.fill(4,{arg i; Saw.ar(freq:freq*(i+1),mul:amp/(i+1))}))
	);
	snd=Splay.ar(snd);
	Out.ar(0,snd);
}).play;
)



//////// 19 ////////
// your turn!
// take the synth in #18 and try changing things, including:
// - try changing the oscillators (try VarSaw, SinOsc, Pulse, LFTri, Saw, ..)
// - try changing the frequency
// - try changing the number of oscillators (instead of 3, do 1, 2, ..)


