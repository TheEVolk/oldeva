local function create_model(id, brand, name, consumption, speed, fuel_type, price)
    return {
        id = id,
        brand = brand,
        name = name,
        consumption = consumption,
        speed = speed,
        fuel_type = ({ AI92 = 1, AI95 = 2, AI98 = 3, DT = 4 })[fuel_type],
        price = price
    }
end

local models = {
    -- Brawo
    create_model(1, "Brawo", "Sir", 7, 80, "AI95", 265000),
    create_model(2, "Brawo", "Son", 7, 85, "AI95", 280000),
    create_model(3, "Brawo", "Pivo", 8, 80, "AI92", 250000),
    create_model(4, "Brawo", "X", 11, 90, "AI92", 900000),
    create_model(5, "Brawo", "Y", 9, 92, "AI95", 1500000),
    create_model(24, "Brawo", "Bochek", 9, 60, "AI92", 200000),
    -- Ches
    create_model(6, "Ches", "Cube", 14, 140, "AI98", 4500000),
    create_model(11, "Ches", "Gg", 16, 120, "DT", 1050000),
    create_model(12, "Ches", "Managed", 17, 140, "DT", 4500000),
    create_model(13, "Ches", "Dj", 7, 215, "AI95", 2800000),
    create_model(20, "Ches", "Mult", 11, 160, "DT", 1800000),
    create_model(21, "Ches", "COL", 15, 165, "AI98", 2000000),
    create_model(22, "Ches", "AKristi", 13, 270, "AI98", 5125000),
    -- Mod
    create_model(7, "Mod", "Erase", 13, 300, "AI98", 15000000),
    -- Solo
    create_model(8, "Solo", "Takt", 8, 100, "AI92", 1521000),
    create_model(9, "Solo", "Win", 8, 90, "AI95", 600000),
    create_model(15, "Solo", "Sar", 7, 160, "AI92", 500000),
    create_model(17, "Solo", "Edet", 9, 125, "AI95", 400000),
    create_model(18, "Solo", "FRONT", 14, 200, "AI95", 1500000),
    -- Top
    create_model(10, "Top", "Cat", 6, 225, "DT", 2750000),
    create_model(14, "Top", "Patu", 9, 170, "AI98", 1600000),
    create_model(16, "Top", "Old", 9, 180, "AI92", 1500000),
    create_model(19, "Top", "Mono", 9, 150, "AI95", 550000),
    create_model(23, "Top", "Lerik", 10, 140, "AI95", 1250000)
}

local number_places = {
    -- Brawo
    [1] = { 141, 248, 0.08, 6 }, -- Brawo Sir
    [2] = { 156, 458, 0.1, 5 }, -- Brawo Son
    [3] = { 315, 620, 0.22, 5 }, -- Brawo Pivo
    [4] = { 170, 338, 0.1, 8 }, -- Brawo X
    [5] = { 159, 251, 0.1, 1 }, -- Brawo Y
    [24] = { 364, 540, 0.2, 8 }, -- Brawo Bochek
    -- Ches
    [22] = { 250, 500, 0.13, 5 } -- Ches AKristi
}

return models, number_places
