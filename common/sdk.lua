table.contains = function(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

table.sub = function(table, startIndex, endIndex)
    local subArray = {}

    startIndex = math.max(1, startIndex or 1)
    endIndex = math.min(#arr, endIndex or #arr)

    for i = startIndex, endIndex do
        table.insert(subArray, arr[i])
    end
    return subArray
end

string.split = function(str, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

TimerService = {
    timers = {},
    
    update = function(self, deltaSecs)
        for i = #self.timers, 1, -1 do
            local timer = self.timers[i]
            timer.elapsed = timer.elapsed + deltaSecs
            if timer.elapsed >= timer.interval then
                timer.elapsed = timer.elapsed - timer.interval
                timer.callback(timer)
                if not timer.running then
                    table.remove(self.timers, i)
                end
            end
        end
    end,
}

EventManager.Listen("Server:UpdatePre", TimerService.update, TimerService)

Timer = {}
Timer.__index = Timer

function Timer:new(interval, callback)
    local obj = setmetatable({}, self)
    obj.interval = interval
    obj.callback = callback
    obj.elapsed = 0
    obj.running = true
    table.insert(TimerService.timers, obj)
    return obj
end

function Timer:cancel()
    self.running = false
end

function SetTimeout(callback, delay)
    Timer:new(delay, function(timer)
        callback()
        timer:cancel()
    end)
end

return {
    Timer = Timer,
    SetTimeout = SetTimeout
}