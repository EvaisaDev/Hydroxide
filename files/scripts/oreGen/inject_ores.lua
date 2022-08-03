dofile_once("data/scripts/lib/utilities.lua")

--SetRandomSeed( ({GameGetDateAndTimeLocal()})[5], ({GameGetDateAndTimeLocal()})[6])
SetRandomSeed( StatsGetValue("world_seed"), StatsGetValue("world_seed") )
print("oreGen Seed: " .. StatsGetValue("world_seed"))

function InjectOre(biomefile, orefile)
    local pattern = "(<[%s]-Materials[%s]-name=\"[^\"]*\"[%s]->)"
    local biome = ModTextFileGetContent(biomefile)
    local ore = ModTextFileGetContent(orefile)
    biome = string.gsub(biome, pattern, "%1\n" .. ore)
    ModTextFileSetContent(biomefile, biome)
end

function getDigit(num, digit)
	local n = 10 ^ digit
	local n1 = 10 ^ (digit - 1)
	return math.floor((num % n) / n1)
end

ore_types = {
	{	probability = 0.900, "random_metals",	},
	{	probability = 0.500, "mods/Hydroxide/files/oreGen/ores_toxic.xml",			},
	{	probability = 0.700, "mods/Hydroxide/files/oreGen/ores_crystals.xml"		},
	{	probability = 0.100, "mods/Hydroxide/files/oreGen/ores_concrete.xml",		},
	{	probability = 0.060, "mods/Hydroxide/files/oreGen/ores_radioactive.xml",	},
	{ 	probability = 0.300, "mods/Hydroxide/files/oreGen/ores_toxic_ice.xml",		},
	{ 	probability = 0.300, "mods/Hydroxide/files/oreGen/ores_frozen_meat.xml",	},
}

metals_1 = {
	{	probability = 0.900, "metals_cobalt1",	},
	{	probability = 1.000, "metals_iron1",		},
	{	probability = 0.800, "metals_preskite1",	},
	{	probability = 0.600, "metals_silver1",	},
	{	probability = 1.000, "metals_brass1",		},
}

metals_2 = {
	{	probability = 0.950, "metals_cobalt2",	},
	{	probability = 1.000, "metals_iron2",		},
	{	probability = 0.900, "metals_preskite2",	},
	{	probability = 0.700, "metals_silver2",	},
	{	probability = 1.000, "metals_brass2",	},
}

ore_coalmines = {
	{	probability = 1.000, "random_metals",	},
	{	probability = 0.600, "mods/Hydroxide/files/oreGen/ores_toxic.xml",		},
	{	probability = 0.600, "mods/Hydroxide/files/oreGen/ores_crystals.xml"	},
}

ore_excavationsite = {
	{	probability = 1.000, "random_metals",	},
	{	probability = 0.800, "mods/Hydroxide/files/oreGen/ores_toxic.xml",		},
	{	probability = 0.800, "mods/Hydroxide/files/oreGen/ores_crystals.xml"	},
}

metals_excavationsite = {
	{	probability = 0.900, "metals_cobalt2",	},
	{	probability = 1.000, "metals_iron2",		},
	{	probability = 0.600, "metals_preskite2",	},
	{	probability = 0.400, "metals_silver2",	},
	{	probability = 0.800, "metals_brass2",		},
	{	probability = 0.100, "metals_gold",		},
}

ore_snowcave = {
	{ 	probability = 0.700, "random_metals",	},
	{ 	probability = 0.800, "mods/Hydroxide/files/oreGen/ores_toxic_ice.xml",		},
	{ 	probability = 0.500, "mods/Hydroxide/files/oreGen/ores_frozen_meat.xml",	},
}
	

ore_snowcastle = {
	{	probability = 0.900, "mods/Hydroxide/files/oreGen/ores_concrete.xml" 		},
	{	probability = 0.600, "mods/Hydroxide/files/oreGen/ores_toxic.xml"			},
	{	probability = 0.750, "random_metals"	},
	{ 	probability = 0.500, "mods/Hydroxide/files/oreGen/ores_frozen_meat.xml",	},
}

ore_rainforest = {
	{	probability = 1.000, "random_metals"	},
	{	probability = 0.800, "mods/Hydroxide/files/oreGen/ores_toxic.xml"			},
}



function addOresToBiome(biome, ore_list, metal_list_1, metal_list_2)

	local rnd = random_create(Random(1,10), Random(1,10) )
	local oreType = tostring(pick_random_from_table_weighted( rnd, ore_list)[1])
	print ("oretype: " .. oreType)
	
	local ores = ""
	
	if (oreType == "random_metals") then

		local metal1 = tostring(pick_random_from_table_weighted(rnd, metal_list_1)[1])
		local metal2 = tostring(pick_random_from_table_weighted(rnd, metal_list_2)[1])
		
		ores = "mods/Hydroxide/files/oreGen/ores_" .. metal1 .. ".xml"
		print("adding " .. ores .. " to " .. biome)
		InjectOre(biome, ores)
		ores = "mods/Hydroxide/files/oreGen/ores_" .. metal2 .. ".xml"
		print("adding " .. ores .. " to " .. biome)
		InjectOre(biome, ores)
	else 
		ores = oreType
		print("adding " .. ores .. " to " .. biome)
		InjectOre(biome, ores)
	end
end

function nextSeed() 

	SetRandomSeed(StatsGetValue("world_seed") - Random(1,10), StatsGetValue("world_seed") + Random(1,10))

end


addOresToBiome("data/biome/coalmine.xml", ore_coalmines, metals_1, metals_2)
addOresToBiome("data/biome/coalmine_alt.xml", ore_coalmines, metals_1, metals_2)

addOresToBiome("data/biome/excavationsite.xml", ore_excavationsite, metals_1, metals_excavationsite) 

addOresToBiome("data/biome/snowcave.xml", ore_snowcave, metals_1, metals_2)

addOresToBiome("data/biome/snowcastle.xml", ore_snowcastle, metals_1, metals_2)

addOresToBiome("data/biome/rainforest.xml", ore_rainforest, metals_1, metals_2)	-- give custom list

addOresToBiome("data/biome/fungicave.xml", ore_types, metals_1, metals_2) 

addOresToBiome("data/biome/vault.xml", ore_types, metals_1, metals_2)

addOresToBiome("data/biome/crypt.xml", ore_types, metals_1, metals_2) --add a ton of potions to this