Delegate.RegDelBattleOverEvent("AutoRecovery");
full_itemid = 800219;

function AutoRecovery(battle)
	for BPWhile=0,4 do
		local BPlayerIndex = Battle.GetPlayer(battle,BPWhile);
		if(BPlayerIndex >= 0 and Char.ItemNum(BPlayerIndex,full_itemid) > 0) then
			local HP = Char.GetData(BPlayerIndex,%����_Ѫ%);
			local MP = Char.GetData(BPlayerIndex,%����_ħ%);
			local Full_HP = HP + 200;
			local Full_MP = MP + 200;
			Char.SetData(BPlayerIndex,%����_Ѫ%,Full_HP);
			Char.SetData(BPlayerIndex,%����_ħ%,Full_MP);
			NLG.UpChar(BPlayerIndex);
			local petIndex = Char.GetPet(BPlayerIndex,Char.GetData(BPlayerIndex, %����_ս��%));
			Char.GetData(BPlayerIndex, %����_ս��%);
			local PetHP = Char.GetData(petIndex,%����_Ѫ%);
			local PetMP = Char.GetData(petIndex,%����_ħ%);
			local PetFull_HP = PetHP + 200;
			local PetFull_MP = PetMP + 200;
			Char.SetData(petIndex,%����_Ѫ%,PetFull_HP);
			Char.SetData(petIndex,%����_ħ%,PetFull_MP);
			NLG.UpChar(petIndex);
			NLG.TalkToCli(BPlayerIndex,-1,"�õ����˵�ף��������+200��ħ��+200��",%��ɫ_��ɫ%,%����_��%);
		end
	end
	return 0;
end