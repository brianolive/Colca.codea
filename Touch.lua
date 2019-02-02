function touched(t)
    for i, v in ipairs(stage) do
        stage[i].touched(t)
    end
end