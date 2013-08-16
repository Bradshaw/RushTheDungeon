useful = {}

function math.clamp(val, min, max)
	return math.max(min, math.min(max, val))
end

function math.sign(val)
	return useful.tri(val>0,1,-1)
end

function math.lerp(a, b, n)
	local i = math.clamp(n, 0, 1)
	return a*(1-i)+b*i
end

function useful.tri(condition, yes, no)
	if condition then
		return yes
	else
		return no
	end
end