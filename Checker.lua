local Checker = {}

function Checker.eq(val1, val2): boolean
    return val1 == val2
end

function Checker.me(val1, val2): boolean
    return val1 > val2
end

function Checker.le(val1, val2): boolean
    return val1 < val2
end

function Checker.meeq(val1, val2): boolean
    return (val1 > val2) or (val1 == val2)
end

function Checker.leeq(val1, val2): boolean
    return (val1 < val2) or (val1 == val2)
end

function Checker.isPos(val1): boolean
    return val1 == math.huge
end

function Checker.isNeg(val1): boolean
    return val1 == -math.huge
end

function Checker.new(man, base): { number }
    return {man, base}
end

function Checker.gn(num, index)
    return num[index]
end

function Checker.sn(str, stind, endin)
    return tonumber(string.sub(str, stind, endin))
end

function Checker.sq(val1, val2)
    return val1 ~= val2
end

function Checker.ne(val1, val2)
    return not (val1 == val2)
end

return Checker