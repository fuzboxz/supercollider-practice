Engine_Moonshine : CroneEngine {

	// ** add variables here **
	var params;

	// Initializes SynthDefs, can call sync and wait methods after this is done
	alloc { // allocate memory to the following

		  // ** SYNTHDEF **
		  SynthDef("Moonshine", {
			arg out = 0,
			freq, sub_div, noise_level,
			cutoff, resonance,
			attack, release,
			amp, pan;

			// oscillator
			var pulse = Pulse.ar(freq: freq);
			var saw = Saw.ar(freq: freq);
			var sub = Pulse.ar(freq: freq/sub_div);
			var noise = WhiteNoise.ar(mul: noise_level);
			var mix = Mix.ar([pulse,saw,sub,noise]);

			//envelope
			var envelope = Env.perc(attackTime: attack, releaseTime: release, level: amp).kr(doneAction: 2);

			//  osc->lpf
			var filter = MoogFF.ar(in: mix, freq: cutoff * envelope, gain: resonance);

			//  pan and use the envelope with VCA
			var signal = Pan2.ar(filter * envelope, pan);

			// out
			Out.ar(out, signal);

		}).add;

		// Sync not needed
		// Server.default.sync

  // "Commands" are how the Lua interpreter controls the engine.
  // The format string is analogous to an OSC message format string,
  //   and the 'msg' argument contains data.

  // We'll just loop over the keys of the dictionary,
  //   and add a command for each one, which updates corresponding value:
		params.keysDo({ arg key;
			this.addCommand(key, "f", { arg msg;
				params[key] = msg[1];
			});
		});

  // This is faster than (but similar to) individually defining each command, eg:
		// this.addCommand("amp", "f", { arg msg;
		//	  amp = msg[1];
		// });

  // The "hz" command, however, requires a new syntax!
  // ".getPairs" flattens the dictionary to alternating key,value array
  //   and "++" concatenates it:
		this.addCommand("hz", "f", { arg msg;
			Synth.new("Moonshine", [\freq, msg[1]] ++ params.getPairs)
		});

	}

}