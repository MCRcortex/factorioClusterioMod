require("util")
require("config")

function ChangePictureFilename(entity, path, newFilename)
	if newFilename ~= nil then
		local filenamePath = entity[path[1]]
		for i = 2, #path do
			filenamePath = filenamePath[path[i]]
		end
		filenamePath.filename = newFilename
	end
end

function MakeLogisticEntity(entity, name, pictureFilename, pictureTablePath, iconPath)
	entity.name = name
	entity.minable.result = name
	--if no picture is defined then use the default one
	ChangePictureFilename(entity, pictureTablePath, pictureFilename)
	--if no icon is defined then use the default one
	entity.icon = iconPath or entity.icon

	-- add the entity to a technology so it can be unlocked
	--local wasAddedToTech = AddEntityToTech("construction-robotics", name)

	data:extend(
	{
		-- add the entity
		entity,
		-- add the recipe for the entity
		{
			type = "recipe",
			name = name,
			--if the recipe was succesfully attached to the tech then the recipe
			--shouldn't be enabled to begin with.
			--but if the recipe isn't attached to a tech then it should
			--be enabled to begin with because otherwise the player can never use the item ingame
			enabled = true,
			ingredients =
			{
				{"steel-chest", 1},
				{"electronic-circuit", 50}
			},
			result = name,
			requester_paste_multiplier = 4
		},
		{
			type = "item",
			name = name,
			icon = entity.icon,
			flags = {"goes-to-quickbar"},
			subgroup = "storage",
			order = "a[items]-b["..name.."]",
			place_result = name,
			stack_size = 50
		}
	})
	return entity
end

--adds a recipe to a tech and returns true or if that fails returns false
function AddEntityToTech(techName, name)
	--can't add the recipe to the tech if it doesn't exist
	if data.raw["technology"][techName] ~= nil then
		local effects = data.raw["technology"][techName].effects
		--if another mod removed the effects or made it nil then make a new table to put the recipe in
		effects = effects or {}
		--insert the recipe as an unlock when the research is done
		effects[#effects + 1] = {
			type = "unlock-recipe",
			recipe = name
		}
		--if a new table for the effects is made then the effects has to be attached to the
		-- tech again because the table won't otherwise be owned by the tech
		data.raw["technology"][techName].effects = effects
		return true
	end
	return false
end


--make chests
-- MakeLogisticEntity(table.deepcopy(data.raw["logistic-container"]["logistic-chest-requester"]), OUTPUT_CHEST_NAME, OUTPUT_CHEST_PICTURE_PATH, { "picture" }, OUTPUT_CHEST_ICON_PATH)
-- MakeLogisticEntity(table.deepcopy(data.raw["container"]["iron-chest"]), 							INPUT_CHEST_NAME,	INPUT_CHEST_PICTURE_PATH, { "picture" },	INPUT_CHEST_ICON_PATH)

-- Use ugly prototype based approach instead
data:extend({
	{
		type = "recipe",
		name = OUTPUT_CHEST_NAME,
		--if the recipe was succesfully attached to the tech then the recipe
		--shouldn't be enabled to begin with.
		--but if the recipe isn't attached to a tech then it should
		--be enabled to begin with because otherwise the player can never use the item ingame
		enabled = true,
		ingredients =
		{
			{"steel-chest", 1},
			{"electronic-circuit", 50}
		},
		result = OUTPUT_CHEST_NAME,
		requester_paste_multiplier = 4
	},
	{
		type = "item",
		name = OUTPUT_CHEST_NAME,
		icon = OUTPUT_CHEST_ICON_PATH,
		icon_size = OUTPUT_CHEST_ICON_SIZE,
		flags = {"goes-to-quickbar"},
		subgroup = "storage",
		order = "a[items]-b["..OUTPUT_CHEST_NAME.."]",
		place_result = OUTPUT_CHEST_NAME,
		stack_size = 50
	},
	{
		type = "logistic-container",
		name = OUTPUT_CHEST_NAME,
		icon = OUTPUT_CHEST_ICON_PATH,
		icon_size = 512,
		flags = {"placeable-player", "player-creation"},
		minable = {hardness = 0.2, mining_time = 2, result = OUTPUT_CHEST_NAME},
		max_health = 2000,
		corpse = "small-remnants",
		collision_box = {{-7.35, -1.35}, {1.35, 7.35}},
		selection_box = {{-7.5, -1.5}, {1.5, 7.5}},
		resistances =
		{
			{
				type = "fire",
				percent = 90
			},
			{
				type = "impact",
				percent = 60
			}
		},
		fast_replaceable_group = "container",
		inventory_size = 48,
		logistic_mode = "requester",
		open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
		close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
		vehicle_impact_sound =	{ filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		picture =
		{
			filename = OUTPUT_CHEST_PICTURE_PATH,
			priority = "extra-high",
			width = 512,
			height = 512,
			shift = {-0.25, 0.3}
		},
		circuit_wire_connection_point =
		{
			shadow =
			{
				red = {0.734375, 0.453125},
				green = {0.609375, 0.515625},
			},
			wire =
			{
				red = {0.40625, 0.21875},
				green = {0.40625, 0.375},
			}
		},
		circuit_wire_max_distance = 9,
		circuit_connector_sprites = get_circuit_connector_sprites({0.1875, 0.15625}, nil, 18),
	},
	{
		type = "recipe",
		name = INPUT_CHEST_NAME,
		--if the recipe was succesfully attached to the tech then the recipe
		--shouldn't be enabled to begin with.
		--but if the recipe isn't attached to a tech then it should
		--be enabled to begin with because otherwise the player can never use the item ingame
		enabled = true,
		ingredients =
		{
			{"steel-chest", 1},
			{"electronic-circuit", 50}
		},
		result = INPUT_CHEST_NAME,
		requester_paste_multiplier = 4
	},
	{
		type = "item",
		name = INPUT_CHEST_NAME,
		icon = INPUT_CHEST_ICON_PATH,
		icon_size = INPUT_CHEST_ICON_SIZE,
		flags = {"goes-to-quickbar"},
		subgroup = "storage",
		order = "a[items]-b["..INPUT_CHEST_NAME.."]",
		place_result = INPUT_CHEST_NAME,
		stack_size = 50
	},
	{
    type = "container",
    name = INPUT_CHEST_NAME,
    icon = INPUT_CHEST_ICON_PATH,
	icon_size = INPUT_CHEST_ICON_SIZE,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1, result = INPUT_CHEST_NAME},
    max_health = 200,
    corpse = "small-remnants",
    open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
    close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
    resistances =
    {
      {
        type = "fire",
        percent = 80
      },
      {
        type = "impact",
        percent = 30
      }
    },
    collision_box = {{-4.35, -4.35}, {4.35, 4.35}},
    selection_box = {{-4.5, -4.5}, {4.5, 4.5}},
    fast_replaceable_group = "container",
    inventory_size = 32,
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    picture =
    {
      filename = INPUT_CHEST_PICTURE_PATH,
      priority = "extra-high",
      width = 1024,
      height = 1024,
      shift = {1.5, -1.5},
	  scale = .4
    },
    circuit_wire_connection_point =
    {
      shadow =
      {
        red = {0.734375, 0.453125},
        green = {0.609375, 0.515625},
      },
      wire =
      {
        red = {0.40625, 0.21875},
        green = {0.40625, 0.375},
      }
    },
    circuit_connector_sprites = get_circuit_connector_sprites({0.1875, 0.15625}, nil, 18),
    circuit_wire_max_distance = 9
  },
})
--make tanks
MakeLogisticEntity(table.deepcopy(data.raw["storage-tank"]["storage-tank"]),	INPUT_TANK_NAME,	INPUT_TANK_PICTURE_PATH, { "pictures", "picture", "sheet" },	INPUT_TANK_ICON_PATH)

--------------------------------------------------------
--[[This section is purely to create the output tank]]--
--------------------------------------------------------

local CRAFING_FLUID_CATEGORY_NAME = "crafting-fluids"

data:extend(
{
	{
		type = "recipe-category",
		name = CRAFING_FLUID_CATEGORY_NAME
	}
})

local fluidCreator = MakeLogisticEntity(table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"]), OUTPUT_TANK_NAME, OUTPUT_TANK_PICTURE_PATH, { "animation" }, OUTPUT_TANK_ICON_PATH)
fluidCreator.fluid_boxes =
{
	{
		production_type = "output",
		pipe_picture = assembler3pipepictures(),
		pipe_covers = pipecoverspictures(),
		base_area = 250,
		base_level = 1,
		pipe_connections =
		{
			{
				type="output", position = {0, 2}
			}
		}
	},
	off_when_no_fluid_recipe = false
}
fluidCreator.crafting_categories = {CRAFING_FLUID_CATEGORY_NAME}
fluidCreator.energy_usage = "1kW"
fluidCreator.ingredient_count = 1
fluidCreator.module_specification.module_slots = 0

for k,v in pairs(data.raw.fluid) do
	data:extend(
	{
		{
			type = "recipe",
			name = ("get-"..v.name),
			icon = v.icon,
			category = CRAFING_FLUID_CATEGORY_NAME,
			--localised_name = {v.name},
			energy_required = 1,
			subgroup = "fill-barrel",
			order = "b[fill-crude-oil-barrel]",
			enabled = true,
			ingredients = {},
			results=
			{
				{type="fluid", name=v.name, amount=-1}
			}
		}
	})
end


-- Virtual signals
data:extend{
	{
		type = "item-subgroup",
		name = "virtual-signal-clusterio",
		group = "signals",
		order = "e"
	},
	{
		type = "virtual-signal",
		name = "signal-srctick",
		icon = "__base__/graphics/icons/signal/signal_grey.png",
		subgroup = "virtual-signal-clusterio",
		order = "e[clusterio]-[1srctick]"
	},
	{
		type = "virtual-signal",
		name = "signal-srcid",
		icon = "__base__/graphics/icons/signal/signal_grey.png",
		subgroup = "virtual-signal-clusterio",
		order = "e[clusterio]-[2srcid]"
	},
	{
		type = "virtual-signal",
		name = "signal-localid",
		icon = "__base__/graphics/icons/signal/signal_grey.png",
		subgroup = "virtual-signal-clusterio",
		order = "e[clusterio]-[3localid]"
	},
	{
		type = "virtual-signal",
		name = "signal-unixtime",
		icon = "__base__/graphics/icons/signal/signal_grey.png",
		subgroup = "virtual-signal-clusterio",
		order = "e[clusterio]-[4unixtime]"
	},
}

-- TX Combinator
local tx = table.deepcopy(data.raw["decider-combinator"]["decider-combinator"])
tx.name = TX_COMBINATOR_NAME
tx.minable.result = TX_COMBINATOR_NAME
data:extend{
	tx,
	{
		type = "item",
		name = TX_COMBINATOR_NAME,
		icon = tx.icon,
		flags = {"goes-to-quickbar"},
		subgroup = "storage",
		place_result=TX_COMBINATOR_NAME,
		order = "a[items]-b["..TX_COMBINATOR_NAME.."]",
		stack_size = 50,
	},
	{
		type = "recipe",
		name = TX_COMBINATOR_NAME,
		enabled = true, -- TODO do this on a tech somewhere
		ingredients =
		{
			{"decider-combinator", 1},
			{"electronic-circuit", 50}
		},
		result = TX_COMBINATOR_NAME,
		requester_paste_multiplier = 1
	},
}

-- RX Combinator
local rx = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
rx.name = RX_COMBINATOR_NAME
rx.minable.result = RX_COMBINATOR_NAME
rx.item_slot_count = 100
data:extend{
	rx,
	{
		type = "item",
		name = RX_COMBINATOR_NAME,
		icon = rx.icon,
		flags = {"goes-to-quickbar"},
		subgroup = "storage",
		place_result=RX_COMBINATOR_NAME,
		order = "a[items]-b["..RX_COMBINATOR_NAME.."]",
		stack_size = 50,
	},
	{
		type = "recipe",
		name = RX_COMBINATOR_NAME,
		enabled = true, -- TODO do this on a tech somewhere
		ingredients =
		{
			{"constant-combinator", 1},
			{"electronic-circuit", 3},
			{"advanced-circuit", 1}
		},
		result = RX_COMBINATOR_NAME,
		requester_paste_multiplier = 1
	},
}
-- Inventory Combinator
local inv = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
inv.name = INV_COMBINATOR_NAME
inv.minable.result = INV_COMBINATOR_NAME
inv.item_slot_count = 500
data:extend{
	inv,
	{
		type = "item",
		name = INV_COMBINATOR_NAME,
		icon = inv.icon,
		flags = {"goes-to-quickbar"},
		subgroup = "storage",
		place_result=INV_COMBINATOR_NAME,
		order = "a[items]-b["..INV_COMBINATOR_NAME.."]",
		stack_size = 50,
	},
	{
		type = "recipe",
		name = INV_COMBINATOR_NAME,
		enabled = true, -- TODO do this on a tech somewhere
		ingredients =
		{
			{"constant-combinator", 1},
			{"electronic-circuit", 50}
		},
		result = INV_COMBINATOR_NAME,
		requester_paste_multiplier = 1
	},
}
