require "colour"

function love.load()
	-- Graphic options
	colourBlack = {10,10,10}
	colourWhite = {255,255,255}
	colourRed 	= {200,0,0}
	colourGreen = {34,139,34}
	
	love.graphics.setBackgroundColor(colourBlack)
    
    population = build_population()
    
    coords = {} -- for drawing the individuals
    mouse_coords = {} -- for clicking on an individual
    local member = 1
    for j = 50, 250, 200 do
        for i = 50, 650, 200 do
            table.insert(coords, ind_display_coords(population[member], i, j))
            mouse_coords[member] = {i, j, i + (individual_size*cell_size), j + (individual_size*cell_size)}
            member = member + 1
        end
    end
    
    label_font = love.graphics.newFont(12)
    button_font = love.graphics.newFont(24)
    
    -- get sample genotype 
    image_data = love.image.newImageData("image.bmp")
    paragon = {}
    for i = 0, 140, 10 do
        for j = 0, 140, 10 do
            local r, g, b, a = image_data:getPixel(j, i)
            table.insert(paragon, {r,g,b})
        end
    end
    generation = 0
    evolving = false
end

function love.draw()
    for k,v in ipairs(population) do
        for cell = 1, #v do
            love.graphics.setColor(v[cell])
            love.graphics.rectangle("fill", coords[k][cell][1], coords[k][cell][2], cell_size, cell_size)
        end
    end
    
    if evolving then
        love.graphics.setColor(colourRed) -- red
    else
        love.graphics.setColor(colourGreen) -- green
    end
	love.graphics.rectangle("fill", 350, 450, 150, 50) -- evolve button
    
    love.graphics.setColor(colourWhite)
	love.graphics.setFont(button_font)
    love.graphics.print("Evolve", 385, 460)
    
    love.graphics.setFont(label_font)
	love.graphics.print("Fitness",              50, 210)
    love.graphics.print(population[1].fitness, 100, 210)
    love.graphics.print("Fitness",             250, 210)
    love.graphics.print(population[2].fitness, 300, 210)
    love.graphics.print("Fitness",             450, 210)
    love.graphics.print(population[3].fitness, 500, 210)
    love.graphics.print("Fitness",             650, 210)
    love.graphics.print(population[4].fitness, 700, 210)
    
	love.graphics.print("Fitness",              50, 410)
    love.graphics.print(population[5].fitness, 100, 410)
    love.graphics.print("Fitness",             250, 410)
    love.graphics.print(population[6].fitness, 300, 410)
    love.graphics.print("Fitness",             450, 410)
    love.graphics.print(population[7].fitness, 500, 410)
    love.graphics.print("Fitness",             650, 410)
    love.graphics.print(population[8].fitness, 700, 410)
    
    love.graphics.print("Generation",    50, 510)
    love.graphics.print(generation,     150, 510)
end

function love.update(dt)
    if evolving then
        evolve()
        generation = generation + 1
    end
end

function love.keypressed(key)
	if key == "r" then -- r for reset
        love.load()
	end
end

function love.mousepressed(x, y, button)
    if x > 350 and x < 500 and y > 450 and y < 500 then 
        evolving = not evolving
    -- else
        -- for k, v in ipairs(mouse_coords) do
            -- if x > v[1] and x < v[3] and y > v[2] and y < v[4] then
                -- print("Member " .. k .. " pressed.")
                -- if button == "l" then
                    -- population[k].fitness = population[k].fitness + 1
                -- else
                    -- population[k].fitness = population[k].fitness - 1
                -- end
                -- break
            -- end
        -- end
    end
end
