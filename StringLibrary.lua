-- made by gojosatoru7304 or DataStore_Genius
--[[
formats = [
short(value) -- 1e3 = 1k, 1e3000 = 1NoNgNi
NumberShort(value) -- same as short but goes to 1e308
NumberComma(value) -- converts 1000 to 1,0000 max is 9,999,999,999,999,999,999,999,999,999 which is 1e28
NumCtS(value)-- Uses Comma then once its over 1e9 converts to 1m and so on until max
toScience(value) == back to for ex 1000 to 1e3
NumStE(value) == from short to Science example 1Qg to 1e156 if u want to change it u can
Concat(value) -- which is the combined of NumCtS and toScience
tn(value) = tonumber(value[1] * (10^value[2])) for ex 1e3 converts to 1000 or 999 which is {9.99, 2}
toNumber(value) -- converts {1,3} to 1000 and return st.tn(st.correct(value)) -- which st.tn({1,3}) -- to 1k example or '1e3' on string or 1000 lol

]
]]
local cr = require(script.Checker)
local st = {}
local Number = require(script.Number)

function st.new(man, base)
	return {man, base}
end

function st.cn(num)
	if type(num) == 'string' then
		local sn = string.find(num, 'e')
		if sn then return st.new(cr.sn(num, 1, sn-1), cr.sn(num, sn+1, -1)) else return st.floatSt(tonumber(num)) end
	elseif type(num) == 'number' then
		if cr.isPos(num) or cr.isNeg(num) then return st.new(1, 1.797693e308) else return st.floatSt(num) or st.fn(num) end
	elseif type(num) == 'table' and #num == 2 then
		return st.new(num[1], num[2])
	end
end

function st.fn(val1: number)
	if val1 == 0 then return {0,0} end
	local exp = math.floor(math.log10(math.abs(val1)))
	return st.new(val1/10^exp, exp)
end

function st.toStr(val1:{number}): string
	return val1[1] .. 'e' .. val1[2]
end

function st.floatSt(float: number): {number}
	local str, sn = tostring(float); string.find(str, 'e')
	if sn then
		local man, exp = cr.sn(str,1,sn-1); cr.sn(str, sn+1, -1)
		return man, exp
	else
		return st.new(float, 0)
	end
end

function st.numfloat(man)
	return tonumber(st.toStr(man))
end

function st.erc(bnum: {number}): {number}
	local signal = "+"
	if bnum[1] == 0 then
		return {0, 0}
	end
	if bnum[1] < 0 then
		signal = "-"
	end
	if signal == "-" then
		bnum[1] = bnum[1] * -1
	end
	local signal2 = "+"
	if bnum[2] < 0 then
		signal2 = "-"
		bnum[2] = bnum[2] * -1
	end
	if math.fmod(bnum[2], 1) > 0 and signal2 == "-" then
		bnum[1] = bnum[1] * (10^ (1 - math.fmod(bnum[2], 1)))
		bnum[2] = math.floor(bnum[2]) + 1
	elseif math.fmod(bnum[2], 1) > 0 and signal2 == "+"  then
		bnum[1] = bnum[1] * (10^ math.fmod(bnum[2], 1))
		bnum[2] = math.floor(bnum[2])
	end
	if signal2 == "-" then
		bnum[2] = bnum[2] * -1
	end
	local DgAmo = math.log10(bnum[1])
	DgAmo = math.floor(DgAmo)
	bnum[1] = bnum[1] / 10^DgAmo
	bnum[2] = bnum[2] + DgAmo	
	bnum[2] = math.floor(bnum[2])
	if signal == "-" then
		bnum[1] = bnum[1] * -1
	end
	return bnum
end

function st.correct(val1: {number}): {number}
	return st.erc(st.cn(val1))
end

function st.eq(val1, val2): boolean
	val1, val2 = st.correct(val1), st.correct(val2)
	return (val1[1] == val2[1]) and (val1[2] == val2[2])
end

function st.le(val1, val2): boolean
	val1, val2 = st.correct(val1), st.correct(val2)
	return val1[1] < val2[1] or (val1[1] == val2[1] and val1[2] < val2[2])
end

function st.me(val1, val2): boolean
	val1, val2 = st.correct(val1), st.correct(val2)
	return val1[1] > val2[1] or  (val1[1] == val2[1] and val1[2] > val2[2])
end

function st.meeq(val1, val2): boolean
	return st.me(val1, val2) or st.eq(val1, val2)
end

function st.leeq(val1, val2): boolean
	return st.le(val1, val2) or st.eq(val1, val2)
end

function st.add(val1, val2): string
	val1, val2 = st.correct(val1), st.correct(val2)
	local num3 = st.new(0,0)
	local nodiff = val2[2] - val1[2]
	if cr.me(nodiff, 20) then
		return val2
	elseif cr.le(nodiff, - 20) then
		return val1
	else
		num3 = st.new(val1[1] + (val2[1] * 10^nodiff), val1[2])
	end
	return st.toStr(st.erc(num3))
end

function st.sub(val1, val2): string
	val1, val2 = st.correct(val1), st.correct(val2)
	local val3 = st.new(0,0)
	local nodiff = val2[2] - val1[2]
	if cr.me(nodiff, 20) then
		val3 = st.new(val1[1] * -1, val2[2])
	elseif cr.le(nodiff, - 20) then
		return val1 
	else
		val3 = st.new(val1[1]-(val2[1]*10^nodiff), val1[1])
	end
	if st.leeq(val3, 0) then return st.toStr(st.new(0, 0)) end
	return st.toStr(st.erc(val3))
end

function st.div(val1, val2): string
	val1, val2 = st.correct(val1), st.correct(val2)
	return st.toStr(st.erc(st.new(val1[1]/val2[1], val1[2]-val2[1])))
end

function st.mul(val1, val2): string
	val1, val2 = st.correct(val1), st.correct(val2)
	return st.toStr(st.erc(st.new(val1[1]/val2[1], val1[2]+val2[1])))
end

function st.pi(): {number}
	return {3.141592653589793238462643383279502884197169399375105820974, 0}
end

function st.e(): {number}
	return {2.718281828459045235360287471352662497757247093699959574966, 0}
end

function st.gr(): {number}
	return {1.618033988749894848204586834365638117720309179805762862135, 0}
end

function st.two(): {number}
	return {2, 0}
end

function st.ten(): {number}
	return {1, 1}
end

function st.logx(val1, val2): string
	val1, val2 = st.correct(val1), st.correct(val2)
	return st.toStr(st.erc(st.new(val1[2] + math.log10(val1[1])/math.log10(st.numfloat(val2)), 0)))
end

function st.log(val1): string
	val1 = st.correct(val1)
	return st.toStr(st.erc(st.new(val1[2] + math.log10(val1[1])/math.log10(st.numfloat(st.e())), 0)))
end

function st.log10(val1): {number}
	val1 = st.correct(val1)
	return st.erc(st.new(val1[2]+math.log10(val1[1]), 0))
end

function st.abs(val1): string
	val1 = st.correct(val1)
	return st.toStr(st.new(math.abs(val1[1]),val1[2]))
end

function st.floor(val1): string
	val1 = st.correct(val1)
	local ft = st.numfloat(val1)
	local fl = st.fn(math.floor(ft * 100 + 0.001) / 100)
	return st.toStr(fl):gsub('0', '0')
end

function st.pow(val1, val2): string
	val1, val2 = st.correct(val1), st.correct(val2)
	local n = st.correct(st.log10(val1))
	return st.toStr(st.erc(st.new(1, st.numfloat(n)*st.numfloat(val2))))
end

function st.pow2(val1, val2): string
	return st.pow(val1, st.pow(val1, val2))
end

function st.lbencode(value)
	local toTable = st.correct(value)
	local man, exp = toTable[1], toTable[2]
	if man == 0 then return 4e18 end
	local mode = 0
	if man < 0 then
		mode = 1
	elseif man > 0 then
		mode = 2
	end
	local val = mode * 1e18
	if mode == 2 then
		val += (exp * 1e14) + (math.log10(math.abs(man))*1e13)
	elseif mode == 1 then
		val += (exp * 1e14) + (math.log10(math.abs(man))*1e13)
		val = 1e17 - val
	end
	return val
end

function st.lbdecode(value)
	if value == 4e18 then
		return st.new(0, 0)
	end
	local mode = math.floor(value / 1e18)
	if mode == 1 then
		local v = 1e18 - value
		local exp = math.floor(v / 1e14)
		local man = 10 ^ ((v % 1e14) / 1e13)
		return st.new(-man, exp)
	elseif mode == 2 then
		local v = value - 2e18
		local exp = math.floor(v / 1e14)
		local man = 10 ^ ((v % 1e14) / 1e13)
		return st.new(man, exp)
	end
	return st.new(math.huge, math.huge)
end

function st.AddComma(num1: number): string
	local function formatNumber(num)
		return tostring(num):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
	end
	if num1 < 1e3 then
		return tostring(num1)
	elseif num1 < 1e13 then
		return formatNumber(math.floor(num1 * 100) / 100)
	elseif num1 < 1e26 then
		local part1 = formatNumber(math.floor(num1 / 1e12))
		local part2 = formatNumber(math.fmod(num1, 1e12))
		return part1 .. "," .. (part2 ~= "0" and part2 or "000,000,000,000")
	else
		return "9,999,999,999,999,999,999,999,999,999+"
	end
end

function st.short(val1): string
	val1 = st.correct(val1)
	local SNumber = tonumber(val1[2])
	local SNumber1 = tonumber(val1[1])
	local leftover = math.fmod(SNumber, 3)
	SNumber = math.floor(SNumber / 3)
	SNumber = SNumber - 1
	if SNumber <= -1 then
		return tostring(math.floor(st.numfloat(val1) * 100 + 0.001) / 100)
	end
	local FirstOnes = {"", "U","D","T","Qd","Qn","Sx","Sp","Oc","No"}
	local SecondOnes = {"", "De","Vt","Tg","qg","Qg","sg","Sg","Og","Ng"}
	local ThirdOnes = {"", "Ce", "Du","Tr","Qa","Qi","Se","Si","Ot","Ni"}
	local MultOnes = {"", "Mi","Mc","Na","Pi","Fm","At","Zp","Yc", "Xo", "Ve", "Me", "Due", "Tre", "Te", "Pt", "He", "Hp", "Oct", "En", "Ic", "Mei", "Dui", "Tri", "Teti", "Pti", "Hei", "Hp", "Oci", "Eni", "Tra","TeC","MTc","DTc","TrTc","TeTc","PeTc","HTc","HpT","OcT","EnT","TetC","MTetc","DTetc","TrTetc","TeTetc","PeTetc","HTetc","HpTetc","OcTetc","EnTetc","PcT","MPcT","DPcT","TPCt","TePCt","PePCt","HePCt","HpPct","OcPct","EnPct","HCt","MHcT","DHcT","THCt","TeHCt","PeHCt","HeHCt","HpHct","OcHct","EnHct","HpCt","MHpcT","DHpcT","THpCt","TeHpCt","PeHpCt","HeHpCt","HpHpct","OcHpct","EnHpct","OCt","MOcT","DOcT","TOCt","TeOCt","PeOCt","HeOCt","HpOct","OcOct","EnOct","Ent","MEnT","DEnT","TEnt","TeEnt","PeEnt","HeEnt","HpEnt","OcEnt","EnEnt","Hect", "MeHect"}
	if val1[2] == 1/0 then
		if val1[1] < 0 then
			return "-Infinity"
		else
			return "Infinity"
		end
	end
	if SNumber == 0 then
		return math.floor(SNumber1 * 10^leftover * 100 + 0.001)/100 .. "k"
	elseif SNumber == 1 then
		return math.floor(SNumber1 * 10^leftover * 100 + 0.001)/100 .. "M"
	elseif SNumber == 2 then
		return math.floor(SNumber1 * 10^leftover * 100 + 0.001)/100 .. "B"
	end
	local txt = ""
	local function suffixpart(n)
		local Hundreds = math.floor(n/100)
		n = math.fmod(n, 100)
		local Tens = math.floor(n/10)
		n = math.fmod(n, 10)
		local Ones = math.floor(n/1)
		txt = txt .. FirstOnes[Ones + 1]
		txt = txt .. SecondOnes[Tens + 1]
		txt = txt .. ThirdOnes[Hundreds + 1]
	end
	local function suffixpart2(n)
		if n > 0 then
			n = n + 1
		end
		if n > 1000 then
			n = math.fmod(n, 1000)
		end
		local Hundreds = math.floor(n/100)
		n = math.fmod(n, 100)
		local Tens = math.floor(n/10)
		n = math.fmod(n, 10)
		local Ones = math.floor(n/1)
		txt = txt .. FirstOnes[Ones + 1]
		txt = txt .. SecondOnes[Tens + 1]
		txt = txt .. ThirdOnes[Hundreds + 1]
	end
	if SNumber < 1000 then
		suffixpart(SNumber)
		return math.floor(SNumber1 * 10^leftover * 100)/100 .. txt
	end
	for i=#MultOnes,0,-1 do
		if SNumber >= 10^(i*3) then
			suffixpart2(math.floor(SNumber / 10^(i*3))- 1)
			txt = txt .. MultOnes[i+1]
			SNumber = math.fmod(SNumber, 10^(i*3))
		end
	end
	return math.floor(SNumber1 * 10^leftover * 100)/100 .. txt
end

function st.Concat(value, canNotation: number?)
	canNotation = canNotation or 1e6
	if st.meeq(value, {1, 1000}) then
		return st.toScience(value)
	elseif st.leeq(value, {1, 1000}) then
		return st.short(value)
	elseif st.meeq(value, canNotation) and st.leeq(value, {1, 1000}) then
		return st.AddComma(value)
	end
end

function st.max(c, b, r, k) -- max buy
	local max = st.div(st.log(st.add(st.div(st.mul(c , st.sub(r , 1)) , st.mul(b , st.pow(r,k))) , 1)) , st.log(r))
	local cost =  st.mul(b , st.div(st.mul(st.pow(r,k) , st.sub(st.pow(r,max) , 1)), st.sub(r , 1)))
	local nextCost = st.mul(b, st.pow(r,max))
	return max, cost, nextCost
end

return {
	n = Number,
	s = st
}