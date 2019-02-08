function action(baseTime)
    return function(t)
        local start = t[1]
        local stop = t[2]
        local object = t[3]
        local act = t[4]
        
        local duration = ((stop - start) + 1) / 60

        if act and time.total == baseTime + start then
            object[act](duration)
        end
        
        if time.total >= baseTime + start and time.total <= baseTime + stop then
            if object["draw"] then
                object["draw"]()
            end
        end
    end
end
