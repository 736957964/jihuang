

modimport("main/myth_skinsapi.lua")

MakeItemSkinDefaultImage("myth_redlantern","images/inventoryimages/redlantern_myth_a.xml","redlantern_myth_a")
MakeItemSkinDefaultImage("alchmy_fur","images/monkey_king_item.xml","alchmy_fur")
MakeItemSkinDefaultImage("myth_interiors_ghg_groundlight","images/inventoryimages/myth_interiors_ghg_groundlight.xml","myth_interiors_ghg_groundlight")

local myth_redlantern_clear_fn = function(inst,skin) 
	inst.AnimState:SetBuild("redlantern_myth_a")
    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem.atlasname = "images/inventoryimages/redlantern_myth_a.xml"
        inst.components.inventoryitem:ChangeImageName("redlantern_myth_a")
    end
end

local function alchmy_fur_init_fn(inst,skin) 
	if inst.components.stewer_fur and inst.components.stewer_fur:IsCooking() then
		inst.components.stewer_fur:CheckSmoke()
		inst.AnimState:OverrideSymbol("pot", skin.."_work", "pot_work")
	end 
end

local alchmy_fur_clear_fn = function(inst,skin) 
	inst.AnimState:SetBuild("alchmy_fur")
	alchmy_fur_init_fn(inst,"alchmy_fur")
end


local myth_interiors_ghg_groundlight_clear_fn = function(inst,skin) 
	if inst.Light then
		inst.Light:SetColour(242/255,239/255,103/255)
	end
	if inst.fires ~= nil then
		for _, v in ipairs(inst.fires) do
			v:Remove()
		end
		inst.fires = nil
	end
end

local fires = {
	{"yama_fire_purple","purple"},
	{"yama_fire_green","yellow"},
}
local function myth_interiors_ghg_groundlight_init_fn(inst,r,g,b,hasfire)
	if inst.Light then
		inst.Light:SetColour(r/255,g/255,b/255)
	end
	if hasfire then
		inst.fires = {}
		inst:DoTaskInTime(0,function()
			for _, v in ipairs(fires) do
				local fx = SpawnPrefab(v[1])
				if fx then
					fx._light.Light:Enable(false)
					fx.entity:SetParent(inst.entity)
					fx.entity:AddFollower()
					fx.Follower:FollowSymbol(inst.GUID, v[2], 0, 0, 0)    
					table.insert(inst.fires,fx)    
				end  
			end
		end)
	end
end

MakeItemSkin("myth_redlantern","redlantern_myth_b",
{
	basebuild = "redlantern_myth_a",
	rarity = "Loyal",
	type = "item",
	name = STRINGS.MYTH_SKIN_REDLANTERN_MYTH_B,
    atlas = "images/inventoryimages/redlantern_myth_b.xml",
    image = "redlantern_myth_b",
})

MakeItemSkin("myth_redlantern","redlantern_myth_c",
{
	basebuild = "redlantern_myth_a",
	rarity = "Loyal",
	type = "item",
	name = STRINGS.MYTH_SKIN_REDLANTERN_MYTH_C,
    atlas = "images/inventoryimages/redlantern_myth_c.xml",
    image = "redlantern_myth_c",
})


MakeItemSkin("myth_redlantern","redlantern_myth_d",
{
	basebuild = "redlantern_myth_a",
	rarity = "Loyal",
	type = "item",
	name = STRINGS.MYTH_SKIN_REDLANTERN_MYTH_D,
    atlas = "images/inventoryimages/redlantern_myth_d.xml",
    image = "redlantern_myth_d",
})

MakeItemSkin("myth_redlantern","redlantern_myth_e",
{
	basebuild = "redlantern_myth_a",
	rarity = "Loyal",
	type = "item",
	name = STRINGS.MYTH_SKIN_REDLANTERN_MYTH_E,
    atlas = "images/inventoryimages/redlantern_myth_e.xml",
    image = "redlantern_myth_e",
})

MakeItemSkin("alchmy_fur","alchmy_fur_copper",
{
	basebuild = "alchmy_fur",
	rarity = "Loyal",
	type = "item",
	name = STRINGS.MYTH_SKIN_ALCHMY_FUR_COPPER,
    atlas = "images/inventoryimages/alchmy_fur_copper.xml",
    image = "alchmy_fur_copper",
	init_fn  = function(inst) alchmy_fur_init_fn(inst,"alchmy_fur_copper")  end,
	clear_fn = alchmy_fur_clear_fn,
})

MakeItemSkin("alchmy_fur","alchmy_fur_ruins",
{
	basebuild = "alchmy_fur",
	rarity = "Loyal",
	type = "item",
	name = STRINGS.MYTH_SKIN_ALCHMY_FUR_RUINS,
    atlas = "images/inventoryimages/alchmy_fur_ruins.xml",
    image = "alchmy_fur_ruins",
	init_fn  = function(inst) alchmy_fur_init_fn(inst,"alchmy_fur_ruins")  end,
	clear_fn = alchmy_fur_clear_fn,
})

MakeItemSkin("myth_interiors_ghg_groundlight","myth_interiors_ghg_groundlight_std",
{
	basebuild = "myth_interiors_ghg_groundlight",
	rarity = "Loyal",
	type = "item",
	name = STRINGS.MYTH_SKIN_GROUNDLIGHT_STD,
    atlas = "images/inventoryimages/myth_interiors_ghg_groundlight_std.xml",
    image = "myth_interiors_ghg_groundlight_std",
	init_fn  = function(inst) myth_interiors_ghg_groundlight_init_fn(inst,255,239,169)  end,
	clear_fn = myth_interiors_ghg_groundlight_clear_fn,
})

MakeItemSkin("myth_interiors_ghg_groundlight","myth_interiors_ghg_groundlight_ryx",
{
	basebuild = "myth_interiors_ghg_groundlight",
	rarity = "Loyal",
	type = "item",
	name = STRINGS.MYTH_SKIN_GROUNDLIGHT_RYX,
    atlas = "images/inventoryimages/myth_interiors_ghg_groundlight_ryx.xml",
    image = "myth_interiors_ghg_groundlight_ryx",
	init_fn  = function(inst) myth_interiors_ghg_groundlight_init_fn(inst,255,205,115)  end,
	clear_fn = myth_interiors_ghg_groundlight_clear_fn,
})

MakeItemSkin("myth_interiors_ghg_groundlight","myth_interiors_ghg_groundlight_qzh",
{
	basebuild = "myth_interiors_ghg_groundlight",
	rarity = "Loyal",
	type = "item",
	name = STRINGS.MYTH_SKIN_GROUNDLIGHT_QZH,
    atlas = "images/inventoryimages/myth_interiors_ghg_groundlight_qzh.xml",
    image = "myth_interiors_ghg_groundlight_qzh",
	init_fn  = function(inst) myth_interiors_ghg_groundlight_init_fn(inst,255,240,144)  end,
	clear_fn = myth_interiors_ghg_groundlight_clear_fn,
})

MakeItemSkin("myth_interiors_ghg_groundlight","myth_interiors_ghg_groundlight_llt",
{
	basebuild = "myth_interiors_ghg_groundlight",
	rarity = "Loyal",
	type = "item",
	name = STRINGS.MYTH_SKIN_GROUNDLIGHT_LLT,
    atlas = "images/inventoryimages/myth_interiors_ghg_groundlight_llt.xml",
    image = "myth_interiors_ghg_groundlight_llt",
	init_fn  = function(inst) myth_interiors_ghg_groundlight_init_fn(inst,255,219,111)  end,
	clear_fn = myth_interiors_ghg_groundlight_clear_fn,
})

MakeItemSkin("myth_interiors_ghg_groundlight","myth_interiors_ghg_groundlight_bgz",
{
	basebuild = "myth_interiors_ghg_groundlight",
	rarity = "Loyal",
	type = "item",
	name = STRINGS.MYTH_SKIN_GROUNDLIGHT_BGZ,
    atlas = "images/inventoryimages/myth_interiors_ghg_groundlight_bgz.xml",
    image = "myth_interiors_ghg_groundlight_bgz",
	init_fn  = function(inst) myth_interiors_ghg_groundlight_init_fn(inst,255,102,169)  end,
	clear_fn = myth_interiors_ghg_groundlight_clear_fn,
})

MakeItemSkin("myth_interiors_ghg_groundlight","myth_interiors_ghg_groundlight_blz",
{
	basebuild = "myth_interiors_ghg_groundlight",
	rarity = "Loyal",
	type = "item",
	name = STRINGS.MYTH_SKIN_GROUNDLIGHT_BLZ,
    atlas = "images/inventoryimages/myth_interiors_ghg_groundlight_blz.xml",
    image = "myth_interiors_ghg_groundlight_blz",
	init_fn  = function(inst) myth_interiors_ghg_groundlight_init_fn(inst,152,255,233)  end,
	clear_fn = myth_interiors_ghg_groundlight_clear_fn,
})

MakeItemSkin("myth_interiors_ghg_groundlight","myth_interiors_ghg_groundlight_gxy",
{
	basebuild = "myth_interiors_ghg_groundlight",
	rarity = "Loyal",
	type = "item",
	name = STRINGS.MYTH_SKIN_GROUNDLIGHT_GXY,
    atlas = "images/inventoryimages/myth_interiors_ghg_groundlight_gxy.xml",
    image = "myth_interiors_ghg_groundlight_gxy",
	init_fn  = function(inst) myth_interiors_ghg_groundlight_init_fn(inst,255,176,2)  end,
	clear_fn = myth_interiors_ghg_groundlight_clear_fn,
})

MakeItemSkin("myth_interiors_ghg_groundlight","myth_interiors_ghg_groundlight_yhy",
{
	basebuild = "myth_interiors_ghg_groundlight",
	rarity = "Loyal",
	type = "item",
	name = STRINGS.MYTH_SKIN_GROUNDLIGHT_YHY,
    atlas = "images/inventoryimages/myth_interiors_ghg_groundlight_yhy.xml",
    image = "myth_interiors_ghg_groundlight_yhy",
	init_fn  = function(inst) myth_interiors_ghg_groundlight_init_fn(inst,210,59,221,true)  end,
	clear_fn = myth_interiors_ghg_groundlight_clear_fn,
})
