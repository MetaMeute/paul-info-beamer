gl.setup(1280, 1024)

local json = require"json"

util.auto_loader(_G)

local old_title = ""

webcam_turm = resource.load_image("webcam_turm.jpg")

function cluttered()
    local all_breaks = '/.-{}()[]<>|,;!? '
    local breaks = {}
    for idx = 1, #all_breaks do
        breaks[all_breaks:sub(idx, idx)]=true
    end

    local next_change
    local start
    local duration
    local start_text
    local end_text
    local text

    local function go(s, e, d)
        start_text = s
        end_text = e
        start = sys.now()
        duration = d
        text = start_text
    end

    local function speed(t)
        return math.pow((math.sin(t / duration * math.pi)+1) / 2, 2)
    end

    local function next_time()
        next_change = sys.now() + speed()
    end

    local function get()
        if not start then
            return ""
        end
        local t = sys.now() - start
        if t > duration then
            return end_text
        end
        local s = speed(t)
        local spread = math.max(math.min(1.0 / duration * t, 1.0), 0)
        local len = #text
        local pos = 0
        text = string.gsub(text, "(.)", function (x)
            pos = pos + 1
            local r = math.random()
            if t < duration / 2 then
                if r < s / #start_text * spread  then
                    local p = math.random(1, #all_breaks)
                    return all_breaks:sub(p,p)
                elseif r < s / #start_text then
                    local p = math.random(1, #start_text)
                    return start_text:sub(pos,pos)
                else
                    return
                end
            else
                if r < s / #end_text * (1 - spread) then
                    local p = math.random(1, #all_breaks)
                    return all_breaks:sub(p,p)
                elseif r < s / #end_text then
                    return end_text:sub(pos, pos)
                else
                    return
                end
            end
        end)
        return text
    end
    return {
        go = go;
        get = get;
    }
end

function wrap(str, limit, indent, indent1)
    limit = limit or 72
    local here = 1
    local wrapped = str:gsub("(%s+)()(%S+)()", function(sp, st, word, fi)
        if fi-here > limit then
            here = st
            return "\n"..word
        end
    end)
    local splitted = {}
    for token in string.gmatch(wrapped, "[^\n]+") do
        splitted[#splitted + 1] = token
    end
    return splitted
end

local line
local base_time = N.base_time or 0
local current_talk

local BORDER = 50

line = cluttered()

vnc = resource.create_vnc("::1", 5901)

function node.render()
  gl.clear(0,0.02,0.2,1)

  resource.render_child("mpd-status"):draw(BORDER, BORDER, WIDTH - 2 * BORDER, BORDER + 140)

  resource.render_child("wetterkarte"):draw(BORDER, BORDER + 2 * 70, 520 + BORDER, 571 + BORDER + 2 * 70)
  webcam_turm:draw(WIDTH - BORDER - 640, BORDER + 2 * 70, WIDTH - BORDER, BORDER + 480 + 2 * 70) 

--  vnc:draw(0, 0, WIDTH, HEIGHT)
end
