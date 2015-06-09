math.randomseed(os.time())
math.random();math.random();math.random();

population_size = 8
individual_size = 15 -- number of cells which gets squared
cell_size = 10 -- pixels

function random_colour()
	return math.random(256)-1 -- 0 - 255
end

-- a cell is a colour table {r,g,b} e.g {34, 139, 34} 
function create_random_cell()
	local ind = {}
	for i = 1, 3 do
		table.insert(ind, random_colour())
	end

    local mt = {__tostring = -- tostring for debugging purposes
        function(t)
            local buffer = {}
            for k, v in ipairs(t) do
                table.insert(buffer, v)
            end
            return "{" .. table.concat(buffer, ",") .. "}" 
        end
    }
    
	return setmetatable(ind, mt)
end

-- an individual is a list of cells (colours), each individual has one fitness value
function create_random_individual()
	local list = {fitness = 0}
	for i = 1, individual_size*individual_size do
		table.insert(list, create_random_cell())
	end
    
    local mt = {__tostring = -- tostring for debugging purposes
        function(t)
            local buffer = {}
            for k, v in ipairs(t) do
                table.insert(buffer, tostring(v))
            end
            return "{" .. table.concat(buffer, ",") .. "}" 
        end
    }

	return setmetatable(list, mt)
end

function build_population()
    local pop = {}
    for i = 1, population_size do
        table.insert(pop, create_random_individual())
    end
    
    return pop
end

-- calculate the display coords each cell should be given a starting point
function ind_display_coords(ind, start_x, start_y)
    local coords = {}
    local i, j = start_x, start_y
    
    for m, cell in ipairs(ind) do
        table.insert(coords, {i,j})
        if i >= (cell_size*(individual_size-1))+start_x then -- 10*15 = 150 + 50 = 200
            i = start_x
            j = j + cell_size
        else
            i = i + cell_size
        end
    end
    
    return coords
end

-- randomly alter a cells in the child
function mutate(child, probability)
    for k,v in ipairs(child) do
        if math.random() < probability then
            child[k] = create_random_cell()
        end
    end
    
    return child
end

function crossover(mother, father)
    local child = deepcopy(mother)
    child.fitness = 0 -- fitness has not been assessed yet
    for i = 1, #child do
        local mix = math.random(2) == 1
        if mix then
            child[i] = copy(father[i]) -- take a random gene from the father
        end
    end
    
    return child
end

function cell_difference(cellA, cellB)
    local a = math.abs(cellA[1] - cellB[1])
    local b = math.abs(cellA[2] - cellB[2])
    local c = math.abs(cellA[3] - cellB[3])
    
    return a + b + c
end

-- assign fitness values to the population
function assign_fitness()
    for k, ind in ipairs(population) do
        
        local fit = 0
        for m, cell in ipairs(ind) do
            fit = fit - cell_difference(cell, paragon[m])
        end
        
        ind.fitness = fit
    end
end

function evolve()
    assign_fitness()
    
    local fit = {}
    for k, v in ipairs(population) do
        table.insert(fit, {v.fitness, k})
    end
    
    table.sort(fit, function(a,b) return a[1] < b[1] end) -- high fitness at the end of table
    
    -- get 2 children from top 4 individuals
    local parentA = population[fit[#fit][2]]
    local parentB = population[fit[#fit-1][2]]
    
    local parentC = population[fit[#fit-2][2]]
    local parentD = population[fit[#fit-3][2]]
    
    local childA = crossover(parentA, parentB)
    local childB = crossover(parentC, parentD)
    mutate(childA, 0.01)
    mutate(childB, 0.01)
    
    -- replace the 2 worst individuals with the children
    population[fit[1][2]] = childA
    population[fit[2][2]] = childB
end

-- Useful functions
function copy(t)
	local new = {}
	for k,v in pairs(t) do
		new[k] = v
	end
	return setmetatable(new, getmetatable(t))
end

function deepcopy(t)
	if type(t) ~= "table" then return t end
	local res = {}
	for k,v in pairs(t) do
		if type(v) == "table" then
			v = deepcopy(v)
		end
		res[k] = v
	end
	return setmetatable(res, getmetatable(t))
end