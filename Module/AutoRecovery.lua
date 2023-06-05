Delegate.RegDelBattleOverEvent("AutoRecovery");
full_itemid = 800219;

function AutoRecovery(battle)
	for BPWhile=0,4 do
		local BPlayerIndex = Battle.GetPlayer(battle,BPWhile);
		if(BPlayerIndex >= 0 and Char.ItemNum(BPlayerIndex,full_itemid) > 0) then
			local HP = Char.GetData(BPlayerIndex,%对象_血%);
			local MP = Char.GetData(BPlayerIndex,%对象_魔%);
			local Full_HP = HP + 200;
			local Full_MP = MP + 200;
			Char.SetData(BPlayerIndex,%对象_血%,Full_HP);
			Char.SetData(BPlayerIndex,%对象_魔%,Full_MP);
			NLG.UpChar(BPlayerIndex);
			local petIndex = Char.GetPet(BPlayerIndex,Char.GetData(BPlayerIndex, %对象_战宠%));
			Char.GetData(BPlayerIndex, %对象_战宠%);
			local PetHP = Char.GetData(petIndex,%对象_血%);
			local PetMP = Char.GetData(petIndex,%对象_魔%);
			local PetFull_HP = PetHP + 200;
			local PetFull_MP = PetMP + 200;
			Char.SetData(petIndex,%对象_血%,PetFull_HP);
			Char.SetData(petIndex,%对象_魔%,PetFull_MP);
			NLG.UpChar(petIndex);
			NLG.TalkToCli(BPlayerIndex,-1,"得到秋菟的祝福，生命+200，魔力+200。",%颜色_黄色%,%字体_中%);
		end
	end
	return 0;
end