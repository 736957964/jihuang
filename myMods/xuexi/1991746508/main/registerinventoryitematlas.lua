

local common = {
    "myth_bamboo_shoots","myth_bamboo","myth_banana_leaf","myth_lotusleaf","myth_lotus_flower","lotus_root","lotus_root_cooked",
    "lotus_seeds","lotus_seeds_cooked","redlantern_myth_a","myth_yylp","gourd","gourd_cooked","gourd_seeds",
}

for _,v in ipairs(common) do
    RegisterInventoryItemAtlas("images/inventoryimages/"..v..".xml", v..".tex")
end

--特殊的
RegisterInventoryItemAtlas("images/monkey_king_item.xml", "lotus_flower.tex")
RegisterInventoryItemAtlas("images/monkey_king_item.xml", "peach.tex")
RegisterInventoryItemAtlas("images/monkey_king_item.xml", "gourd.tex")
RegisterInventoryItemAtlas("images/monkey_king_item.xml", "bigpeach.tex")
RegisterInventoryItemAtlas("images/monkey_king_item.xml", "mk_longpi.tex")
RegisterInventoryItemAtlas("images/monkey_king_item.xml", "mk_hualing.tex")
RegisterInventoryItemAtlas("images/monkey_king_item.xml", "mk_huoyuan.tex")
RegisterInventoryItemAtlas("images/monkey_king_item.xml", "pill_bottle_gourd.tex")
RegisterInventoryItemAtlas("images/monkey_king_item.xml", "laozi_sp.tex")
RegisterInventoryItemAtlas("images/monkey_king_item.xml","cassock.tex")
RegisterInventoryItemAtlas("images/monkey_king_item.xml","vegetarian_food.tex")
RegisterInventoryItemAtlas("images/monkey_king_item.xml","peach_wine.tex")