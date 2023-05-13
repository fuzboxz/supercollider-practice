local Moonshine = {}
local Formatters = require 'formatters'

-- map all commands into norns-friendly ranges
local specs = {
    ["amp"] = controlspec.new(0, 2, "lin", 0, 1, ""),
    ["sub_div"] = controlspec.new(1, 10, "lin", 1, 2, ""),
    ["noise_level"] = controlspec.new(0, 1, "lin", 0, 0.3, ""),
    ["cutoff"] = controlspec.new(0.1, 20000, 'exp', 0, 1300, "Hz"),
    ["resonance"] = controlspec.new(0, 4, "lin", 0, 2, ""),
    ["attack"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
    ["release"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
    ["pan"] = controlspec.PAN
}

-- parameter order
local param_names = {"amp", "sub_div", "noise_level", "cutoff", "resonance", "attack", "release", "pan"}

-- initialize parameters
function Moonshine.add_params()
    params:add_group("Moonshine", #param_names)

    for i = 1, #param_names do
        local p_name = param_names[i]
        params:add{
            type = "control",
            id = "Moonshine_"..p_name,
            name = p_name,
            controlspec = specs[p_name],
            formatter = p_name == "pan" and Formatters.bipolar_as_pan_widget or nil,
            -- send parameter changes to sc engine
            action = function(x) engine[p_name](x) end
        }

        params:bang()
    end
end

-- trigger note
function Moonshine.trig(hz)
    if hz ~= nil then
        engine.hz(hz)
    end
end

-- return engine-specific lua functions to host script
return Moonshine