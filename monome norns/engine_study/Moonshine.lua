engine.name = 'Moonshine'
-- Single or dual quotes don't matter

moonshine = include('engine_study/lib/moonshine_engine')
s = require 'sequins'
-- https://monome.org/docs/norns/reference/lib/sequins 

function init()
    -- sequins of hz multiples
    mults = s{1, 2.25, s{0.25, 1.5, 3.5, 2, 3, 0.75} } 

    playing = false
    base_hz = 220
    sequence = clock.run(
        function ()
            while true do
                clock.sync(1/3)
                if playing then
                    engine.hz(base_hz * mults() * math.random(2))
                end
            end
        end
    )
end

function key(n, z)
    if n == 3 and z == 1 then
        playing = not playing
        mults:reset() -- resets 'mults' index to 1
        redraw()
    end
end

function redraw()
    screen.clear()
    screen.move(64, 32)
    screen.text_center(playing and "K3: turn off" or "K3: turn on")
    screen.update()
end