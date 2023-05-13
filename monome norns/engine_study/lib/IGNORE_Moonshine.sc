(
  SynthDef("Moonshine",{
    arg freq = 440, sub_div = 5, noise_level = 0.1,
    cutoff = 8000, resonance = 3,
    attack = 0.3, release = 0.4,
    amp = 1, pan = 0, out = 0;

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
    Out.ar(0, signal);

  }).add;
)

x = Synth("Moonshine");
x = Synth("Moonshine", [\freq,440, \cutoff,14000, \attack,0.05 ,\resonance,2.0, \release,0.2]);