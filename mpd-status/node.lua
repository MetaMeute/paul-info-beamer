gl.setup(1180, 140)

util.auto_loader(_G)

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
    local old_text = ""
    local text

    local function go(e, d)
        local l = math.max(#old_text, #e)

        -- Guard against duplicate packets!
        if e == old_text then
          return
        end

        start_text = old_text
        end_text = e
        old_text = e
        start = sys.now()
        duration = d
        text = start_text
    end

    local function speed(t)
        return math.pow((math.sin(t / duration * math.pi)+1), 3)
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
        local pos = 0
        local l = math.max(#start_text, #end_text, #text)
        text = string.gsub(text .. string.rep(" ", l - #text), "(.)", function (x)
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

local line1, line2

line1 = cluttered()
line2 = cluttered()

node.alias("mpd-status")

node.event("data", function (data, suffix) 
  if suffix == "title" then line1.go(data, 3)  end
  if suffix == "artist" then line2.go(data, 3)  end
end)

function node.render()
  bold:write(0, 0, line1.get(), 50, 1,1,1,1)
  bold:write(0, 70, line2.get(), 50, .5,.8,.5,1)
end
