Delegate.RegInit("Signin_Init");

--這裡寫獲得獎勵的簽到次數，順序與下面對應
signInCountPrize = {1,2,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,56,61,66,71,76,81,86,91,96,100};
--這裡寫獲得的獎勵，順序與上面相同
--金幣寫 g|金幣數量，道具寫 i|道具ID|道具名字，聲望寫 f|聲望數量
signInPrize = {"i|87633|诱魔香10步","i|87634|诱魔香20步","i|87635|诱魔香30步","i|830038|时间水晶LV1","g|10000","i|830042|驱魔香Lv2","g|15000","i|87636|诱魔香40步","g|25000","i|830039|时间水晶Lv3","i|87637|诱魔香50步","i|830039|时间水晶Lv3","i|87637|诱魔香50步","g|30000","i|830039|时间水晶Lv3","i|87639|诱魔香70步","i|830043|驱魔香Lv3","i|830040|时间水晶Lv6","i|87642|诱魔香100步","i|87629|诱魔香Lv2","i|87629|诱魔香Lv2","i|87629|诱魔香Lv2","i|87629|诱魔香Lv2","i|87629|诱魔香Lv2","i|87630|诱魔香Lv3","i|87630|诱魔香Lv3","i|87630|诱魔香Lv3","i|87630|诱魔香Lv3","i|87630|诱魔香Lv3"};
--连续天数奖励		1			2		3			6		9		12		15		18		21		24		27			30			33		36		39			42			45			48		51	

function Signin_Init()
	signin_create();
	print(tonumber(Field.Get(_tome,"SigninTime")));
end

function signin_create() --每日签到
	if(SigninNPC == nil)then
		SigninNPC = NL.CreateNpc("./lua/System/BaseModule/Base.lua", "Myinit");
		Char.SetData(SigninNPC,%对象_形象%,14604);
		Char.SetData(SigninNPC,%对象_原形%,14604);
		Char.SetData(SigninNPC,%对象_X%,247);
		Char.SetData(SigninNPC,%对象_Y%,86);
		Char.SetData(SigninNPC,%对象_地图%,1000);
		Char.SetData(SigninNPC,%对象_方向%,6);
		Char.SetData(SigninNPC,%对象_名字%,"每日签到");
		NLG.UpChar(SigninNPC);
		Char.SetWindowTalkedEvent("./lua/Module/Task_Signin.lua","SigninNPCWinTalked",SigninNPC);
		Char.SetTalkedEvent("./lua/Module/Task_Signin.lua","SigninNPCTalked", SigninNPC);
	end
end

function canSignin(_tome)
	local times = tonumber(Field.Get(_tome,"SigninCount"));
	local signinTime = tonumber(Field.Get(_tome,"SigninTime"));
	local signble = 0;
	
	if(times == nil and signinTime == nil )then
		signble = 1;
	end

	if(times ~= nil and signinTime ~= nil)then
		local nowTime = os.time();
		local CTimeM = os.date("%m",signinTime);
		local CTimeD = os.date("%d",signinTime);
		local BTimeM = os.date("%m",nowTime);
		local BTimeD = os.date("%d",nowTime);
		if(CTimeM == BTimeM and CTimeD == BTimeD)then
			--已经签到过了
			signble = 0;
			return signble,times;
		end
		if(CTimeM ~= BTimeM or CTimeD ~= BTimeD)then		
			local signintimediff = os.difftime(nowTime,signinTime);
			if(signintimediff > 86400 and signintimediff < 172800)then
			--可以连续签到
				signble = 1;
			end
			if(signintimediff >= 172800)then
			--可以连续签到,但签到次数归零
				signble = 1;
				Field.Set(_tome,"SigninCount","0");
				times = 0;
			end
		end
	end
	return signble,times;
end

function SigninNPCTalked(_me,_tome)

	if(NLG.CanTalk(_me,_tome)==false)then
		return;
	end
	
	local myStr = "";
	local signble,times = canSignin(_tome);
	
	if(signble == 0 or signble == nil)then
		myStr = "\\n\\n"..Char.GetData(_tome,%对象_名字%)..",欢迎您来到魔力宝贝\\n\\n".."这里是每日签到系统\\n\\n今天你已经签到过了呢,非常好!\\n\\n目前您已经连续签到了 "..times.." 天了哦!\\n";
		NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,0,myStr);
		return;
	end

	if (times == nil)then
		myStr = "\\n\\n"..Char.GetData(_tome,%对象_名字%)..",欢迎您来到魔力宝贝\\n".."这里是每日签到系统\\n您似乎是第一次使用签到服务呢\\n当您连续签到几天后,会获得不同的奖励\\n具体的奖励请前往论坛查看\\n论坛地址是http://www.35doo.com/\\n请问您想现在就进行签到么?";
		NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定关闭%,0,myStr);
		return;
	end
	if(signble == 1 and times > 0)then
		myStr = "\\n\\n"..Char.GetData(_tome,%对象_名字%)..",欢迎您来到魔力宝贝\\n".."这里是每日签到系统\\n您已经连续签到了 "..times.." 天了哦!\\n请问您想现在就进行签到么?";
		NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定关闭%,0,myStr);
		return;
	end
	if(signble == 1 and times == 0)then
		myStr = "\\n\\n"..Char.GetData(_tome,%对象_名字%)..",欢迎您来到魔力宝贝\\n".."这里是每日签到系统\\n似乎你有一段时间没有来过就上魔力了呢!\\n 恢滥垂每珊媚?\\n不管如何,希望你在就上玩的愉快!\\n请问您想现在就进行签到么?";
		NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定关闭%,0,myStr);
		return;
	end
end

function makeSignin(_me,_tome,times)
	local myStr = "\\n\\n\\n恭喜你签到成功!\\n感谢您支持就上魔力,祝您游戏愉快!\\n";
	local prizeCount = IsInTable(times,signInCountPrize);
	if(prizeCount ~= -1)then
		local prizeSetting = Split(signInPrize[prizeCount],"|");
		if(prizeSetting[1] == "g")then
			Char.AddGold(_tome,tonumber(prizeSetting[2]));
			NLG.SystemMessage(_tome,"获得金钱 "..tonumber(prizeSetting[2]).." Gold.");
		end
		if(prizeSetting[1] == "i")then
			if(Char.ItemSlot(_tome) == 20)then
				NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,0,"\\n\\n你的背包似乎装不下奖励了哦!\\n\\n快去清理下吧!");
				return;
			end
			Char.GiveItem(_tome,tonumber(prizeSetting[2]));
			NLG.SystemMessage(_tome,"获得道具 "..prizeSetting[3].." .");
		end
		if(prizeSetting[1] == "f")then
			Char.SetData(_tome,%对象_声望%,Char.GetData(_tome,%对象_声望%)+tonumber(prizeSetting[2]));
			NLG.UpChar(_tome);
			NLG.SystemMessage(_tome,"获得声望 "..tonumber(prizeSetting[2]));
		end
		myStr = myStr .. "您的奖励已经发放,请注意查收哦!\\n";
	end
	local t = os.time();
	local m = os.date("%m" ,t);
	local d = os.date("%d" ,t);
	local Y = os.date("%Y" ,t);
	local tt = {year = Y, month = m, day = d, hour = 0};
	Field.Set(_tome,"SigninTime",""..os.time(tt));
	Field.Set(_tome,"SigninCount",""..times);
	NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,0,myStr);
end

function SigninNPCWinTalked(_me,_tome,_seqno,_select,_data)
	if(NLG.CanTalk(_me,_tome) == false)then
		return;
	end
	
	if(_select == %按钮_确定% or _select == ""..%按钮_确定%)then
		local signble,times = canSignin(_tome);
		if(times == nil)then
			times = 0;
			signble = 1;
		end
		if(signble==1)then
			times = times + 1;
			makeSignin(_me,_tome,times);
		end
	end
end