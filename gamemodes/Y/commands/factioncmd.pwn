#include <YSI_Coding\y_hooks>




new 
	playerWeaponsSave[MAX_PLAYERS][4], 
	playerWeaponsAmmoSave[MAX_PLAYERS][4]; 

alias:factionhelp("fhelp")
CMD:factionhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_RED, "[FACTION]:{FFFFFF} /f, /togfam, /nofam, /factionhelp /customskin"); 

    if(!PlayerInfo[playerid][pFaction])
		return 1;
    
    if(ReturnFactionType(playerid) == GOVERMENT)
    {
        SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /duty/showbadge, /m(egaphone), /(dep)artment,");
		SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /carsign, /remove_carsign /cone /remove_rb");
		SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /siren, /siren2, /siren3, /headquarter /setbadge /elm");

		if(ReturnFactionJob(playerid) == POLICE && ReturnFactionJob(playerid) == SHERIFF)
		{
			SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /duty, /cuff, /uncuff, /showbadge");
			SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /carsign, /remove_carsign, /tazer, /impound, /mdc");
			SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /arrest /checkarrest /rubberbullets /spike_add /spike_del");
		}

		if(ReturnFactionJob(playerid) == GOV)
		{
			SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /checkgovcash /withdrawgov");
		}

		if(ReturnFactionJob(playerid) == MEDIC)
		{
			SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /revice /heal");
		}
		
		if(PlayerInfo[playerid][pFactionRank] <= FactionInfo[PlayerInfo[playerid][pFaction]][eFactionTowRank])
			SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /towcars");

        return 1;
    }
    return 1;
}


alias:headquarter("hq", "headhq")
CMD:headquarter(playerid, params[])
{
    if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���"); 

    if(isnull(params)) return SendUsageMessage(playerid, "/headquarter <��ͤ���>");
	
	if(strlen(params) > 100)
	{
		SendFactionMessage(playerid, 0x8D8DFFFF, "HQ: %.100s", ReturnName(playerid, 0), params);
		SendFactionMessage(playerid, 0x8D8DFFFF, "....", params[100]);
	}
	else SendFactionMessage(playerid, 0x8D8DFFFF, "HQ: %s", params);
    return 1;
}

CMD:factionconfig(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س�������������ῤ���");

	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
		return SendErrorMessage(playerid, "��/����˹觢ͧ�س ������Ѻ͹حҵ���������觹��");

	PlayerSelectFac[playerid] = PlayerInfo[playerid][pFaction];

	ShowFactionConfig(playerid);
	return 1;
}



alias:government("gov")
CMD:government(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");
		
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س����� ˹��§ҹ���ӧҹ��鹵ç�Ѻ�Ѱ���");

	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
		return SendErrorMessage(playerid, "��/����˹觢ͧ�س ������Ѻ͹حҵ���������觹��");

	if(isnull(params))
		return SendUsageMessage(playerid, "/government <��觷��л�С��>");

	if(strlen(params) > 89)
	{
		SendClientMessageToAllEx(-1, "----------Government %s ----------", FactionInfo[PlayerInfo[playerid][pFaction]][eFactionName]);
		SendClientMessageToAllEx(COLOR_COP, "��С��:{FFFFFF} %.89s", params);
		SendClientMessageToAllEx(-1, "%s", params[89]);
		SendClientMessageToAllEx(-1, "----------Government %s ----------", FactionInfo[PlayerInfo[playerid][pFaction]][eFactionName]);
	}
	else
	{
		SendClientMessageToAllEx(-1, "----------Government %s ----------", FactionInfo[PlayerInfo[playerid][pFaction]][eFactionName]);
		SendClientMessageToAllEx(COLOR_COP, "��С��:{FFFFFF} %s", params);
		SendClientMessageToAllEx(-1, "----------Government %s ----------", FactionInfo[PlayerInfo[playerid][pFaction]][eFactionName]);
	}
	return 1;
}

CMD:f(playerid, params[])
{
    if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");

    
    if(PlayerInfo[playerid][pFactionChat] == true)
		return SendErrorMessage(playerid, "�س��Դ����ͧ����к�᪷��������� ����� \"/togfam\" �����Դ");

    if(isnull(params)) return SendUsageMessage(playerid, "/f [��ͤ���]");

    if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatStatus] == true)
	{			
		if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank] && !PlayerInfo[playerid][pAdmin])
			return SendErrorMessage(playerid, "�к�᪷������١�Դ�����ҹ����㹢�й��");  
			
		if(strlen(params) > 79)
		{
			SendFactionMessage(playerid, COLOR_FACTIONCHAT, "**(( %s %s: %.79s ))**", ReturnFactionRank(playerid), ReturnName(playerid, 0), params); 
			SendFactionMessage(playerid, COLOR_FACTIONCHAT, "**(( %s %s: ...%s ))**", ReturnFactionRank(playerid), ReturnName(playerid, 0), params[79]); 
		}
		else SendFactionMessage(playerid, COLOR_FACTIONCHAT, "**(( %s %s: %s ))**", ReturnFactionRank(playerid), ReturnName(playerid, 0), params); 
		return 1;
	}
	
	if(strlen(params) > 79)
	{
		SendFactionMessage(playerid, COLOR_FACTIONCHAT, "**(( %s %s: %.79s ))**", ReturnFactionRank(playerid), ReturnName(playerid, 0), params); 
		SendFactionMessage(playerid, COLOR_FACTIONCHAT, "**(( %s %s: ...%s ))**", ReturnFactionRank(playerid), ReturnName(playerid, 0), params[79]); 
	}
	else SendFactionMessage(playerid, COLOR_FACTIONCHAT, "**(( %s %s: %s ))**", ReturnFactionRank(playerid), ReturnName(playerid, 0), params);
    return 1;
}

CMD:nofam(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");
		
	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank] && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "��/����˹觢ͧ�س ������Ѻ͹حҵ���������觹��");
		
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatStatus] == true)
	{
		SendFactionMessageEx(playerid, COLOR_RED, "%s �Դ�к�᪷�����", ReturnName(playerid));
		FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatStatus] = false;
	}
	else
	{
		SendFactionMessageEx(playerid, COLOR_RED, "%s �Դ�к�᪷�����", ReturnName(playerid));
		FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatStatus] = true;
	}	
	return 1;
}

CMD:togfam(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");
	
	if(PlayerInfo[playerid][pFactionChat] == true)
	{
		SendServerMessage(playerid, "�س���Դ����ͧ����к�᪷�����");
		PlayerInfo[playerid][pFactionChat] = false;
	}
	else
	{
		SendServerMessage(playerid, "�س��Դ����ͧ����к�᪷�����");
		PlayerInfo[playerid][pFactionChat] = true;
	}
	return 1;
}

CMD:invite(playerid, params[])
{
	new playerb;
	
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");
		
	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank] && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "��/����˹觢ͧ�س ������Ѻ͹حҵ���������觹��"); 
	
	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/invite [���ͺҧ��ǹ/�ʹ�]");
		
	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "������������������͡Ѻ�׿�����"); 
		
	if(!BitFlag_Get(gPlayerBitFlag[playerb], IS_LOGGED))
		return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");
		
	if(PlayerInfo[playerb][pFaction])
		return SendErrorMessage(playerid, "�����蹤������࿤�����������"); 
		
	PlayerInfo[playerb][pFactionInvite] = PlayerInfo[playerid][pFaction];	
	PlayerInfo[playerb][pFactionInvitedBy] = playerid;
	
	SendClientMessageEx(playerb, COLOR_YELLOW, "%s ���ԭ�س���࿤��� %s ����� /accept �����������", ReturnName(playerid), ReturnFactionName(playerid));
	SendClientMessageEx(playerid, COLOR_YELLOW, "�س���ԭ %s ������࿤��� %s", ReturnName(playerb), ReturnFactionName(playerid));
	return 1;
}

CMD:accept(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س��࿤�����������");

	if(!PlayerInfo[playerid][pFactionInvite])
		return SendErrorMessage(playerid, "������ա���ԭ�س�������࿤���㹵͹���");

	if(FactionInfo[PlayerInfo[playerid][pFactionInvite]][eFactionType] == GOVERMENT)
	{
		PlayerInfo[playerid][pBadge] = random(99999);
	}
			
	SendClientMessageEx(PlayerInfo[playerid][pFactionInvitedBy], COLOR_YELLOW, "%s ���Ѻ�Ҥ��ԭ�ͧ�س㹡���������࿤���", ReturnName(playerid));
	SendClientMessageEx(playerid, COLOR_YELLOW, "�س���������࿤��� %s ���º��������", ReturnFactionNameEx(PlayerInfo[playerid][pFactionInvite]));
	
	PlayerInfo[playerid][pFaction] = PlayerInfo[playerid][pFactionInvite]; 
	PlayerInfo[playerid][pFactionRank] = FactionInfo[PlayerInfo[playerid][pFactionInvite]][eFactionJoinRank];
	
	PlayerInfo[playerid][pFactionInvite] = 0;
	PlayerInfo[playerid][pFactionInvitedBy] = INVALID_PLAYER_ID;
	
	CharacterSave(playerid);
	return 1;
}

CMD:uninvite(playerid, params[])
{
	new playerb;
	
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");
		
	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank] && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "��/����˹觢ͧ�س ������Ѻ͹حҵ���������觹��"); 
	
	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/uninvite [���ͺҧ��ǹ/�ʹ�]");
		
	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "������������������͡Ѻ�׿�����"); 
		
	if(!BitFlag_Get(gPlayerBitFlag[playerb], IS_LOGGED))
		return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");
		
	if(PlayerInfo[playerb][pFaction] != PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�����蹤��������������࿤��蹢ͧ�س");
	
	SendClientMessageEx(playerb, COLOR_YELLOW, "࿤��� %s ��Ӥس�͡�ҡ࿤����� %s", ReturnFactionNameEx(PlayerInfo[playerid][pFaction]), ReturnName(playerid));
	SendClientMessageEx(playerid, COLOR_YELLOW, "�س���� %s �͡�ҡ࿤���", ReturnName(playerb));
	
	PlayerInfo[playerb][pFaction] = 0;
	PlayerInfo[playerb][pFactionRank] = 0;
	
	SetPlayerSkin(playerb, 264); PlayerInfo[playerb][pLastSkin] = 264;
	CharacterSave(playerb);
	return 1;
}

CMD:giverank(playerid, params[])
{
    new playerb, rank;
	
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");
		
	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank] && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "��/����˹觢ͧ�س ������Ѻ͹حҵ���������觹��");

    if(sscanf(params, "ui", playerb, rank))
	{
		for(new i = 1; i < MAX_FACTION_RANKS; i++)
		{
			if(!strcmp(FactionRanks[PlayerInfo[playerid][pFaction]][i], "NotSet"))
				continue;
				
			SendClientMessageEx(playerid, COLOR_HELPME, "-> Rank %i: %s", i, FactionRanks[PlayerInfo[playerid][pFaction]][i]); 
		}
	
		SendUsageMessage(playerid, "/giverank [���ͺҧ��ǹ/�ʹ�] [����˹�/��]");
		return 1;
	}

    if(rank < 1 || rank > 20)
		return SendErrorMessage(playerid, "��/����˹� �� 1-20 ��ҹ��"); 
		
	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "������������������͡Ѻ�׿�����");

    if(!BitFlag_Get(gPlayerBitFlag[playerb], IS_LOGGED))
        return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");

    if(PlayerInfo[playerb][pFaction] != PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�����蹤��������������࿤��蹢ͧ�س");
		
	if(PlayerInfo[playerb][pFactionRank] < PlayerInfo[playerid][pFactionRank] && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "�س�������ö��Ѻ������� ��/����˹� �ͧ %s", ReturnName(playerb));

    if(rank > PlayerInfo[playerb][pFactionRank])
    {
        SendClientMessageEx(playerb, COLOR_HELPME, "�س�١Ŵ����˹觢ͧ�س �� %s �� %s", FactionRanks[PlayerInfo[playerb][pFaction]][rank], ReturnRealName(playerid, 0)); 
        SendClientMessageEx(playerid, COLOR_HELPME, "�س��Ŵ����˹觢ͧ %s �ҡ %s �� %s", ReturnRealName(playerb, 0), FactionRanks[PlayerInfo[playerb][pFaction]][PlayerInfo[playerb][pFactionRank]], FactionRanks[PlayerInfo[playerb][pFaction]][rank]);
            
        PlayerInfo[playerb][pFactionRank] = rank; 
        CharacterSave(playerb);
    }
    else
    {
        SendClientMessageEx(playerb, COLOR_HELPME, "�س��١��������˹觢ͧ�س �� %s", FactionRanks[PlayerInfo[playerb][pFaction]][rank], ReturnRealName(playerid, 0)); 
        SendClientMessageEx(playerid, COLOR_HELPME, "�س���ѻ�ô ��/����˹觢ͧ %s �ҡ %s �� %s", ReturnRealName(playerb, 0), FactionRanks[PlayerInfo[playerb][pFaction]][PlayerInfo[playerb][pFactionRank]], FactionRanks[PlayerInfo[playerb][pFaction]][rank]);
            
        PlayerInfo[playerb][pFactionRank] = rank; 
        CharacterSave(playerb);
    }
    return 1;
}

alias:factionon("fon")
CMD:factionon(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");

	foreach(new i : Player)
	{
		if(PlayerInfo[i][pFaction] != PlayerInfo[playerid][pFaction])
			continue;
			
		SendClientMessageEx(playerid, COLOR_GREY, "(ID: %i) %s %s", i, ReturnFactionRank(i), ReturnName(i));
	}
	return 1;
}

CMD:duty(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");
	
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���");

	
	if(ReturnFactionJob(playerid) == POLICE)
	{
		if(!PlayerInfo[playerid][pDuty])
		{
			PlayerInfo[playerid][pDuty] = true;

			if(!PlayerInfo[playerid][pAdminDuty] && !PlayerInfo[playerid][pTesterDuty])
				SetPlayerColor(playerid, COLOR_COP);

			SendClientMessage(playerid, COLOR_LIGHTGREEN, "You Are On Duty Now!");
			return 1;
		}
		else
		{
			PlayerInfo[playerid][pDuty] = false;

			if(!PlayerInfo[playerid][pAdminDuty])
			SetPlayerColor(playerid, COLOR_WHITE);

			SendClientMessage(playerid, COLOR_LIGHTGREEN, "You Are Off Duty Now!");
			return 1;
		}
	}
	if(ReturnFactionJob(playerid) == SHERIFF)
	{
        if(!PlayerInfo[playerid][pDuty])
        {
            if(!IsPlayerInRangeOfPoint(playerid, 5.0, FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][0], FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][1], FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][2]))
                return SendErrorMessage(playerid, "�س���������ش��͡����");
 
            PlayerInfo[playerid][pDuty] = true;
 
            for(new i = 0; i < 4; i++)
            {
                playerWeaponsSave[playerid][i] = PlayerInfo[playerid][pWeapons][i];
                playerWeaponsAmmoSave[playerid][i] = PlayerInfo[playerid][pWeaponsAmmo][i];
            }
	
			SendFactionMessageEx(playerid, 0x8D8DFFFF, " HQ: %s %s has gone off duty", ReturnFactionRank(playerid), ReturnName(playerid, 0));
            SendClientMessage(playerid, COLOR_WHITE, "��觷��س�����Ѻ: Spraycan, Nitestick, Desert Eagle (60), Health(100)");
 
            new str[128];
			format(str, sizeof(str), "����Ժ��һ�Шӵ���͡�Ҩҡ�����͡����");
			callcmd::me(playerid, str);
 
            SetPlayerHealth(playerid, 100);
            SetPlayerArmour(playerid, 100);
 
            TakePlayerGuns(playerid);
 
            GivePlayerWeaponEx(playerid, 24, 100);
            GivePlayerWeaponEx(playerid, 3, 1);
            GivePlayerWeaponEx(playerid, 41, 350);
 
            if(!PlayerInfo[playerid][pAdminDuty] && !PlayerInfo[playerid][pTesterDuty])
                SetPlayerColor(playerid, COLOR_COP);
 
            return 1;
        }
 
        if(PlayerInfo[playerid][pDuty])
        {
            PlayerInfo[playerid][pDuty] = false;
 
            ResetPlayerWeapons(playerid);
 
            for(new i = 0; i < 4; i++)
            {
                PlayerInfo[playerid][pWeapons][i] = 0; PlayerInfo[playerid][pWeaponsAmmo][i] = 0;
 
                if(playerWeaponsSave[playerid][i])
                    GivePlayerGun(playerid, playerWeaponsSave[playerid][i], playerWeaponsAmmoSave[playerid][i]);
            }
            	
			SendFactionMessageEx(playerid, 0x8D8DFFFF, " HQ: %s %s ���͡�ҡ��û�Ժѵ˹�ҷ������ҹ��", ReturnFactionRank(playerid), ReturnName(playerid, 0));
			

			new str[128];
			format(str, sizeof(str), "�ҧ��һ�Шӵ���������ͤ����");
			callcmd::me(playerid, str);
 
            SetPlayerArmour(playerid, 0);
            SetPlayerHealth(playerid, 100);
 
            if(!PlayerInfo[playerid][pAdminDuty])
            SetPlayerColor(playerid, COLOR_WHITE);
 
            if(GetPlayerSkin(playerid) != PlayerInfo[playerid][pLastSkin])
            	SetPlayerSkin(playerid, PlayerInfo[playerid][pLastSkin]);
 
            return 1;
        }
    }
	if(ReturnFactionJob(playerid) == MEDIC)
	{
	    if(!PlayerInfo[playerid][pDuty])
		{
	    	if(!IsPlayerInRangeOfPoint(playerid, 5.0, FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][0], FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][1], FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][2]))
				return SendErrorMessage(playerid, "�س���������ش��͡����");

			PlayerInfo[playerid][pDuty] = true;

			for(new i = 0; i < 4; i++)
			{
				playerWeaponsSave[playerid][i] = PlayerInfo[playerid][pWeapons][i];
				playerWeaponsAmmoSave[playerid][i] = PlayerInfo[playerid][pWeaponsAmmo][i];
			}

			SendFactionMessageEx(playerid, 0xFF8282FF, "HQ: %s %s ���������Ժѵ˹�ҷ�����ǵ͹���", ReturnFactionRank(playerid), ReturnName(playerid, 0));
			SendClientMessage(playerid, COLOR_WHITE, "��觷��س�����Ѻ: �ѧ�Ѻ��ԧ");

			new str[128];
			format(str, sizeof(str), "����Ժ��һ�Шӵ���͡�Ҩҡ�����͡����");
			callcmd::me(playerid, str);

    		SetPlayerColor(playerid, 0xFF8282FF);
			SetPlayerHealth(playerid, 100);
			SetPlayerArmour(playerid, 100);

			TakePlayerGuns(playerid);

			GivePlayerWeaponEx(playerid, 42, 500);

			if(!PlayerInfo[playerid][pAdminDuty] && !PlayerInfo[playerid][pTesterDuty])
				SetPlayerColor(playerid, COLOR_PINK);

            return 1;
		}

		if(PlayerInfo[playerid][pDuty])
		{
		    PlayerInfo[playerid][pDuty] = false;

			ResetPlayerWeapons(playerid);

			for(new i = 0; i < 4; i++)
			{
				PlayerInfo[playerid][pWeapons][i] = 0; PlayerInfo[playerid][pWeaponsAmmo][i] = 0;

				if(playerWeaponsSave[playerid][i])
					GivePlayerGun(playerid, playerWeaponsSave[playerid][i], playerWeaponsAmmoSave[playerid][i]);
			}

			SendFactionMessageEx(playerid, 0xFF8282FF, " HQ: %s %s ���͡�ҡ��û�Ժѵ˹�ҷ������ҹ��", ReturnFactionRank(playerid), ReturnName(playerid, 0));

			new str[128];
			format(str, sizeof(str), "�ҧ��һ�Шӵ���������ͤ����");
			callcmd::me(playerid, str);

			SetPlayerArmour(playerid, 0);
			SetPlayerHealth(playerid, 100);

			if(!PlayerInfo[playerid][pAdminDuty])
			SetPlayerColor(playerid, COLOR_WHITE);

			if(GetPlayerSkin(playerid) != PlayerInfo[playerid][pLastSkin])
			SetPlayerSkin(playerid, PlayerInfo[playerid][pLastSkin]);

			return 1;
		}
	}
	if(ReturnFactionJob(playerid) == SADCR)
	{
	    if(!PlayerInfo[playerid][pDuty])
		{
	    	if(!IsPlayerInRangeOfPoint(playerid, 5.0, FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][0], FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][1], FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][2]))
				return SendErrorMessage(playerid, "�س���������ش��͡����");

			PlayerInfo[playerid][pDuty] = true;

			for(new i = 0; i < 4; i++)
			{
				playerWeaponsSave[playerid][i] = PlayerInfo[playerid][pWeapons][i];
				playerWeaponsAmmoSave[playerid][i] = PlayerInfo[playerid][pWeaponsAmmo][i];
			}

			SendFactionMessageEx(playerid, 0xFF8282FF, "HQ: %s %s ���������Ժѵ˹�ҷ�����ǵ͹���", ReturnFactionRank(playerid), ReturnName(playerid, 0));
			SendClientMessage(playerid, COLOR_WHITE, "��觷��س�����Ѻ: �ѧ�Ѻ��ԧ");

			new str[128];
			format(str, sizeof(str), "����Ժ��һ�Шӵ���͡�Ҩҡ�����͡����");
			callcmd::me(playerid, str);

    		SetPlayerColor(playerid, 0xFF8282FF);
			SetPlayerHealth(playerid, 100);
			SetPlayerArmour(playerid, 100);

			TakePlayerGuns(playerid);

			GivePlayerWeaponEx(playerid, 25, 150);
			GivePlayerWeaponEx(playerid, 24, 150);
			GivePlayerWeaponEx(playerid, 3, 1);
			GivePlayerWeaponEx(playerid, 41, 350);

			if(!PlayerInfo[playerid][pAdminDuty] && !PlayerInfo[playerid][pTesterDuty])
				SetPlayerColor(playerid, COLOR_PINK);

            return 1;
		}

		if(PlayerInfo[playerid][pDuty])
		{
		    PlayerInfo[playerid][pDuty] = false;

			ResetPlayerWeapons(playerid);

			for(new i = 0; i < 4; i++)
			{
				PlayerInfo[playerid][pWeapons][i] = 0; PlayerInfo[playerid][pWeaponsAmmo][i] = 0;

				if(playerWeaponsSave[playerid][i])
					GivePlayerGun(playerid, playerWeaponsSave[playerid][i], playerWeaponsAmmoSave[playerid][i]);
			}

			SendFactionMessageEx(playerid, 0xFF8282FF, " HQ: %s %s ���͡�ҡ��û�Ժѵ˹�ҷ������ҹ��", ReturnFactionRank(playerid), ReturnName(playerid, 0));
			
			new str[128];
			format(str, sizeof(str), "�ҧ��һ�Шӵ���������ͤ����");
			callcmd::me(playerid, str);

			SetPlayerArmour(playerid, 0);
			SetPlayerHealth(playerid, 100);

			if(!PlayerInfo[playerid][pAdminDuty])
			SetPlayerColor(playerid, COLOR_WHITE);

			if(GetPlayerSkin(playerid) != PlayerInfo[playerid][pLastSkin])
			SetPlayerSkin(playerid, PlayerInfo[playerid][pLastSkin]);

			return 1;
		}
	}
	else return SendErrorMessage(playerid, "�բ�ͼԴ��Ҵ�Դ���");
    return 1;
}

CMD:showbadge(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");
		
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س����� ���Ǩ/��������/����Ҫ������͹��"); 
		
	new playerb;
	
	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/showbadge <���ͺҧ��ǹ/�ʹ�>"); 
		
	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "������������������͡Ѻ�׿�����");
		
	if(!BitFlag_Get(gPlayerBitFlag[playerb], IS_LOGGED))
		return SendErrorMessage(playerid, "�����蹡��ѧ�������к�"); 
		
	if(!IsPlayerNearPlayer(playerid, playerb, 5.0))
		return SendErrorMessage(playerid, "������������������س");
		
	if(playerb == playerid)
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "> %s ��Ժ��һ�Шӵ�Ǣ���Ҵ�", ReturnName(playerid, 0));
	
	else SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "> %s ��Ժ��һ�Шӵ�Ǣ�������������Ѻ %s ��", ReturnName(playerid, 0), ReturnName(playerb, 0));
	
	SendClientMessage(playerb, COLOR_COP, "______________________________________");
	
	SendClientMessageEx(playerb, COLOR_GRAD2, "  ����: %s", ReturnNameLetter(playerid));
	SendClientMessageEx(playerb, COLOR_GRAD2, "  �Ţ���: %d", PlayerInfo[playerid][pBadge]);
	SendClientMessageEx(playerb, COLOR_GRAD2, "  ��/����˹�: %s", ReturnFactionRank(playerid));
	SendClientMessageEx(playerb, COLOR_GRAD2, "  �ӹѡ�ҹ: %s", ReturnFactionName(playerid));
	
	SendClientMessage(playerb, COLOR_COP, "______________________________________");
	return 1;
}

alias:megaphone("m", "meg")
CMD:megaphone(playerid, params[])
{
    if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���");
		
	if(isnull(params))
		return SendUsageMessage(playerid, "/(m)egaphone [��ͤ���]"); 
		
	SendNearbyMessage(playerid, 70.0, COLOR_YELLOWEX, "[%s:o< %s ]", ReturnRealName(playerid, 0), params);
    return 1;
}

alias:department("d","dep")
CMD:department(playerid, params[])
{
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���"); 
		
	if(isnull(params))
		return SendUsageMessage(playerid, "/(d)epartment [��ͤ���]");

	foreach(new i : Player)
	{
		new
			factionid;
			
		factionid = PlayerInfo[i][pFaction];
			
		if(FactionInfo[factionid][eFactionType] == GOVERMENT)
		{
			SendClientMessageEx(i, COLOR_DEPT, "** [%s] %s %s: %s", FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAbbrev], ReturnFactionRank(playerid), ReturnName(playerid, 0), params); 
		}
	}

	new Float:posx, Float:posy, Float:posz;
	GetPlayerPos(playerid, posx,posy,posz);

	foreach(new i : Player)
	{
 		if(i == playerid)
   			continue;

		else if(IsPlayerInRangeOfPoint(i, 20.0, posx,posy,posz))
		{
  			SendClientMessageEx(i, COLOR_GRAD1, "%s �ٴ��� (�Է��): %s", ReturnName(playerid, 0), params);
 		}
	}
	return 1;
}

CMD:carsign(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "�س��������躹ö");
		
	new
		vehicleid = GetPlayerVehicleID(playerid);
		
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���"); 
		
	if(isnull(params))
		return SendUsageMessage(playerid, "/carsign [��ͤ���]"); 
		
	if(strlen(params) < 2 || strlen(params) >= 50)
		return SendErrorMessage(playerid, "�س�������ö��� ������ ���ӡ��� 2 ����ѡ���������Թ 50 ����ѡ��");
		
	if(VehicleInfo[vehicleid][eVehicleHasCarsign])
		Update3DTextLabelText(VehicleInfo[vehicleid][eVehicleCarsign], COLOR_WHITE, params);
	
	else
	{
		SendServerMessage(playerid, "�ҡ����������ô����� /remove_carsign  ����"); 
		
		VehicleInfo[vehicleid][eVehicleCarsign] = Create3DTextLabel(params, COLOR_WHITE, 0.0, 0.0, 0.0, 25.0, GetPlayerVirtualWorld(playerid), 0); 
		Attach3DTextLabelToVehicle(VehicleInfo[vehicleid][eVehicleCarsign], vehicleid, -0.7, -1.9, -0.3); 
		
		VehicleInfo[vehicleid][eVehicleHasCarsign] = true;
	}
	return 1;
}

CMD:remove_carsign(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "�س��������躹ö");
		
	new
		vehicleid = GetPlayerVehicleID(playerid);
		
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���"); 
		
	if(!VehicleInfo[vehicleid][eVehicleHasCarsign])
		return SendErrorMessage(playerid, "ö�ѹ���������� ��������������"); 
	
	Delete3DTextLabel(VehicleInfo[vehicleid][eVehicleCarsign]); 
	VehicleInfo[vehicleid][eVehicleHasCarsign] = false;

	SendServerMessage(playerid, "�س��ź ������ �ͧö�ѹ�������º��������"); 
	return 1;
}

CMD:park(playerid ,params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س�����࿤���");

	new factionid = PlayerInfo[playerid][pFaction];
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "�س��������躹ö");
	
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendErrorMessage(playerid, "�س������繤��Ѻ");

	if(VehicleInfo[vehicleid][eVehicleFaction] != factionid)
		return SendErrorMessage(playerid, "ö�ѹ��������ö࿤��蹢ͧ�س");

	GetVehiclePos(vehicleid, VehicleInfo[vehicleid][eVehicleParkPos][0], VehicleInfo[vehicleid][eVehicleParkPos][1], VehicleInfo[vehicleid][eVehicleParkPos][2]);
	GetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][eVehicleParkPos][3]);
	VehicleInfo[vehicleid][eVehicleParkWorld] = GetPlayerVirtualWorld(playerid); 

	SendFactionMessage(playerid, COLOR_FACTION, "**(( %s ������¹�ش�ҹ��˹� �ʹ� %d ))**",ReturnRealName(playerid, 0), VehicleInfo[vehicleid][eVehicleDBID]);

	SaveFacVehicle(vehicleid);

	DestroyVehicle(vehicleid);

	vehicleid = CreateVehicle(VehicleInfo[vehicleid][eVehicleModel], VehicleInfo[vehicleid][eVehicleParkPos][0], VehicleInfo[vehicleid][eVehicleParkPos][1], VehicleInfo[vehicleid][eVehicleParkPos][2], VehicleInfo[vehicleid][eVehicleParkPos][3], VehicleInfo[vehicleid][eVehicleColor1], VehicleInfo[vehicleid][eVehicleColor2], -1, 0);
	ToggleVehicleEngine(vehicleid, false); VehicleInfo[vehicleid][eVehicleEngineStatus] = false;
	PutPlayerInVehicle(playerid, vehicleid, 0);
	return 1;
}

CMD:towcars(playerid, params[])
{
	new id = PlayerInfo[playerid][pFaction];

	if(FactionInfo[id][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���");

	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[id][eFactionAlterRank] && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "��/����˹觢ͧ�س ������Ѻ͹حҵ���������觹��");

	for(new v = 1; v< MAX_FACTION_VEHICLE; v++)
	{
		if(!VehicleInfo[v][eVehicleFaction])
			continue;

		if(VehicleInfo[v][eVehicleFaction] != id)
			continue;

		if(IsVehicleOccupied(v))
			continue;

		SetVehicleToRespawnEx(v);
		SetVehicleNumberPlate(v, FactionInfo[id][eFactionAbbrev]);
	}

	SendFactionMessageEx(playerid, COLOR_FACTION, "**(( %s �����ҹ��˹з������դ���觢ͧ�������Ѻ�ش�Դ������ ))**", ReturnName(playerid, 0));
	return 1;
}

alias:checkgovcash("checkgc")
CMD:checkgovcash(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction] && PlayerInfo[playerid][pAdmin] < LEAD_ADMIN)
		return SendErrorMessage(playerid, "�س����������ῤ��� �Ѱ���");

	new factionid = PlayerInfo[playerid][pFaction];

	if(FactionInfo[factionid][eFactionJob] != GOV && PlayerInfo[playerid][pAdmin] < LEAD_ADMIN)
		return SendErrorMessage(playerid, "�س����������ῤ��蹷������ǡѺ��ú����ç�����ҳ�ͧ�Ѱ���");

	SendClientMessageEx(playerid, COLOR_HELPME, "�Թ㹡����ä�ѧ�ͧ�Ѱ San Andreas: $%s",MoneyFormat(GlobalInfo[G_GovCash]));
	return 1;
}

CMD:siren(playerid, params[])
{
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���");

	if(!IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "�س��������躹�ҹ��˹�");

	new vehicleid = GetPlayerVehicleID(playerid);
	new modelid = GetVehicleModel(vehicleid);

	if(HasNoEngine(vehicleid))
		return SendErrorMessage(playerid, "�س�������ö�����觹��Ѻ�ҹ��˹й����");

	/*if(!HasSiren(vehicleid))
		return SendErrorMessage(playerid, "�س�������ö�����觹��Ѻ�ҹ��˹й���� (���繵�ͧ���ҹ��˹з�����Ѻ͹حҵ��ҹ��)");*/

	if(!IsValidDynamicObject(VehicleSiren[vehicleid]))
	{
		if(modelid != 560 && modelid != 541 && modelid != 525 && modelid != 426 && modelid != 579) return SendClientMessage(playerid, COLOR_GREY, "��ù�ͧ�Ѻ੾���ҹ��˹���� Sultan/Bullet/Towtruck/Premier/Huntley");

		if(modelid == 560)
		{
			VehicleSiren[vehicleid] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleSiren[vehicleid], vehicleid, 0.225000,0.750000,0.449999, 0.000000, 0.000000, 0.000000);
		}
		if(modelid == 541)
		{
			VehicleSiren[vehicleid] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleSiren[vehicleid], vehicleid, 0.375000,0.524999,0.375000, 0.000000, 0.000000, 0.000000);
		}
		if(modelid == 426)
		{
			VehicleSiren[vehicleid] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleSiren[vehicleid], vehicleid, 0.524999,0.749999, 0.375000, 0.000000, 0.000000, 0.000000);
		}
		if(modelid == 525)
		{
			VehicleSiren[vehicleid] = CreateDynamicObject(19419, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleSiren[vehicleid], vehicleid, 0.0, -0.485, 1.36, 0.000000, 0.000000, 180.0);
		}
		if(modelid == 579)
		{
			VehicleSiren[vehicleid] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleSiren[vehicleid], vehicleid,  0.679999, 0.479999, 0.734999, 0.000000, 0.000000, 0.000000);
		}
        SendClientMessage(playerid, COLOR_LIGHTGREEN, "�س�Դ��ù");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "�س�ʹ��ù�͡");
		DestroyDynamicObject(VehicleSiren[vehicleid]);
		VehicleSiren[vehicleid] = INVALID_OBJECT_ID;
	}
	return 1;
}

CMD:siren2(playerid, params[])
{
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���");

	if(!IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "�س��������躹�ҹ��˹�");

	new vehicleid = GetPlayerVehicleID(playerid);
	new modelid = GetVehicleModel(vehicleid);

	if(HasNoEngine(vehicleid))
		return SendErrorMessage(playerid, "�س�������ö�����觹��Ѻ�ҹ��˹й����");

	if(!IsValidDynamicObject(VehicleSiren[vehicleid]))
	{
		if(modelid != 560 && modelid != 426) return SendClientMessage(playerid, COLOR_GREY, "��ù�ͧ�Ѻ੾���ҹ��˹���� Sultan/Premier");

		if(modelid == 560)
		{
			VehicleSiren[vehicleid] = CreateDynamicObject(19419, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleSiren[vehicleid], vehicleid, 0.000000, -1.289999, 0.394999, 0.000000, 0.000000, 0.000000);
			return 1;
		}
		if(modelid == 426)
		{
			VehicleSiren[vehicleid] = CreateDynamicObject(19419, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleSiren[vehicleid], vehicleid, 0.000000, -1.669998, 0.349999, 0.000000, 0.000000, 0.000000);
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "�س�ʹ��ù�͡");
		DestroyDynamicObject(VehicleSiren[vehicleid]);
		VehicleSiren[vehicleid] = INVALID_OBJECT_ID;
		
	}
	return 1;
}

CMD:siren3(playerid, params[])
{
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���");

	if(!IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "�س��������躹�ҹ��˹�");

	new vehicleid = GetPlayerVehicleID(playerid);
	//new modelid = GetVehicleModel(vehicleid);
	new type[8];

	if(HasNoEngine(vehicleid))
		return SendErrorMessage(playerid, "�س�������ö�����觹��Ѻ�ҹ��˹й����");

	if(sscanf(params, "s[8]", type))
	{
		SendClientMessage(playerid, COLOR_WHITE, "[Usage]: /siren [���˹�]");
		SendClientMessage(playerid, COLOR_WHITE, "���˹�: ���� | ��ѧ�� | �Դ");
		return 1;
	}

	if(!strcmp(type, "����"))
	{
		if(VehicleSiren[vehicleid] != INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOR_GREY, "��˹Фѹ���Դ��ù����");
        VehicleSiren[vehicleid] = CreateDynamicObject(18646, 10.0, 10.0, 10.0, 0, 0, 0);
        AttachDynamicObjectToVehicle(VehicleSiren[vehicleid],vehicleid, 0.0, 0.75, 0.275, 0.0, 0.1, 0.0);
        return 1;
	}
	else if(!strcmp(type, "��ѧ��"))
	{
	    if(VehicleSiren[vehicleid] != INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOR_GREY, "��˹Фѹ���Դ��ù����");
        VehicleSiren[vehicleid] = CreateDynamicObject(18646, 10.0, 10.0, 10.0, 0, 0, 0);
        AttachDynamicObjectToVehicle(VehicleSiren[vehicleid], vehicleid, -0.43, 0.0, 0.785, 0.0, 0.1, 0.0);
        return 1;
	}
	else if(!strcmp(type, "�Դ"))
	{
	    if(VehicleSiren[vehicleid] == INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOR_GREY, "��˹Фѹ����ѧ�����Դ��ù");
		
		if(IsValidDynamicObject(VehicleSiren[vehicleid]))
			DestroyDynamicObject(VehicleSiren[vehicleid]);

		VehicleSiren[vehicleid] = INVALID_OBJECT_ID;
		return 1;
	}
	return 1;
}

CMD:setbadge(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���");

	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank] && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "��/����˹觢ͧ�س ������Ѻ͹حҵ���������觹��");

	new tagetid, badgenumber;

	if(sscanf(params, "ud", tagetid, badgenumber))
		return SendUsageMessage(playerid, "/setbadge <���ͺҧ��ǹ/�ʹ�> <�Ţ���>");
	
	if(!IsPlayerConnected(tagetid))
		return SendErrorMessage(playerid, "������������������͡Ѻ�׿�����"); 
		
	if(!BitFlag_Get(gPlayerBitFlag[tagetid], IS_LOGGED))
		return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");
	
	if(PlayerInfo[playerid][pFaction] != PlayerInfo[tagetid][pFaction])
		return SendErrorMessage(playerid, "ῤ��蹢ͧ���������������Ѻ�س");

	
	PlayerInfo[tagetid][pBadge] = badgenumber;
	
	CharacterSave(playerid);
	CharacterSave(tagetid);

	SendClientMessageEx(playerid, COLOR_HELPME, "�س������¹�Ţ������Ѻ %s �� %d",ReturnName(tagetid,0), badgenumber);
	SendClientMessageEx(tagetid, COLOR_HELPME, "%s ������¹���Ţ������س�� %d",ReturnName(playerid,0), badgenumber);
	return 1;
}

CMD:withdrawgov(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction] && PlayerInfo[playerid][pAdmin] < LEAD_ADMIN)
		return SendErrorMessage(playerid, "�س����������ῤ��� �Ѱ���");

	new factionid = PlayerInfo[playerid][pFaction];

	if(FactionInfo[factionid][eFactionJob] != GOV && PlayerInfo[playerid][pAdmin] < LEAD_ADMIN)
		return SendErrorMessage(playerid, "�س����������ῤ��蹷������ǡѺ��ú����ç�����ҳ�ͧ�Ѱ���");

	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[factionid][eFactionAlterRank] && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "��/����˹觢ͧ�س ������Ѻ͹حҵ���������觹��");

	new amount;
	if(sscanf(params, "d", amount))
		return SendUsageMessage(playerid, "/withdrawgov <�ӹǹ>");

	if(amount > GlobalInfo[G_GovCash])
		return SendErrorMessage(playerid, "�ӹǹ�Թ���� �Ѱ��� �����§��");
	
	GlobalInfo[G_GovCash]-= amount;
	GiveMoney(playerid, amount);
	SendFactionMessageEx(playerid, COLOR_ORANGE, "HQ: %s %s: �͹�Թ�ҡ�Ѱ����͡�Ҩӹǹ $%s",ReturnFactionRank(playerid), ReturnRealName(playerid,0), MoneyFormat(amount));
	return 1;
}

/*CMD:customskin(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");

	new skinid, factionid = PlayerInfo[playerid][pFaction];
	if(sscanf(params, "d", skinid))
	{
		new skincuount;
		for(new i = 1; i < 31; i++)
		{
			if(!CustomskinFacInfo[factionid][FactionSkin][i])
				continue;
			
			skincuount = i;
			
		}

		SendUsageMessage(playerid, "/customskin <1-%d>", skincuount);
		return 1;
	}

	if(skinid == 0)
		return SetPlayerSkin(playerid, PlayerInfo[playerid][pLastSkin]);

	if(skinid < 0 || skinid > 30)
		return SendErrorMessage(playerid, "�س��� ʡԹ���١��ͧ");

	if(!CustomskinFacInfo[factionid][FactionSkin][skinid])
		return SendErrorMessage(playerid, "�س��� ʡԹ���١��ͧ");
	
	SetPlayerSkin(playerid, CustomskinFacInfo[factionid][FactionSkin][skinid]);
	PlayerInfo[playerid][pLastSkin] = CustomskinFacInfo[factionid][FactionSkin][skinid];
	TogglePlayerControllable(playerid, 1);
	ClearAnimations(playerid);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	return 1;
}*/

CMD:elm(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���");

	if(!IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "�س�������躹�ҹ��˹�");

	new vehicleid = GetPlayerVehicleID(playerid),Float:veh_health;

	if(!VehicleInfo[vehicleid][eVehicleLights])
		return SendErrorMessage(playerid, "�Դ�˹���ҹ��˹Тͧ�س��͹");

	if(VehicleInfo[vehicleid][eVehicleElmTimer] != -1)
	{
		KillTimer(VehicleInfo[vehicleid][eVehicleElmTimer]);
		VehicleInfo[vehicleid][eVehicleElmTimer] = -1;

		GetVehicleHealth(vehicleid, veh_health);

		RepairVehicle(vehicleid);
		SetVehicleHealth(vehicleid, veh_health);

		GameTextForPlayer(playerid, "~g~Emergency Lights Off", 2000, 4);
		return 1;
	}
	else
	{
		VehicleInfo[vehicleid][eVehicleElmTimer] = SetTimerEx("OnLightFlash", 115, true, "i", vehicleid);
		GameTextForPlayer(playerid, "~g~Emergency Lights On", 2000, 4);
		return 1;
	}
}

CMD:cone(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���");

	new id, Float:x, Float:y, Float:z;
	
	if(sscanf(params, "d", id))
		return SendUsageMessage(playerid, "/cone <slotid>");

	if(id < 1 || id > 10)
		return SendErrorMessage(playerid, "��س�����Ţ���١��ͧ");

	if(PlayerInfo[playerid][pObject][id] != INVALID_OBJECT_ID)
		return SendErrorMessage(playerid, "�س���� ���͵��ͧ���㹡���ҧ Object ��������");

	GetPlayerPos(playerid, x, y,z);
	PlayerInfo[playerid][pObject][id] = CreateDynamicObject(1238, x, y, z, 0.0, 0.0, 0.0,-1,-1,-1);
	EditDynamicObject(playerid,PlayerInfo[playerid][pObject][id]);
	SetPVarInt(playerid, "EditObejctRB", id);
	SetPVarInt(playerid, "ObjectID", 1238);
	return 1;
}

CMD:remove_rb(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���");

	new id;
	
	if(sscanf(params, "d", id))
		return SendUsageMessage(playerid, "/remove_rb <slotid>");

	if(id < 1 || id > 9)
		return SendErrorMessage(playerid, "��س�����Ţ���١��ͧ");

	if(PlayerInfo[playerid][pObject][id] == INVALID_OBJECT_ID)
		return SendErrorMessage(playerid, "��ͧ ���������ա����ҹ");
	

	if(IsValidDynamicObject(PlayerInfo[playerid][pObject][id]))
        DestroyDynamicObject(PlayerInfo[playerid][pObject][id]);

	SendClientMessageEx(playerid, -1, "�س��ź�ѵ�ت�ͧ��� %d ���º��������", id);
	PlayerInfo[playerid][pObject][id] = INVALID_OBJECT_ID;
	return 1;
}


CMD:rb(playerid, params[])
{
	new slot, model, Float:x, Float:y, Float:z;

	if(sscanf(params,"dd",slot,model))
	{
		SendSyntaxMessage(playerid, "/rb <slot(1-9)> <model-id>");
		SendClientMessage(playerid, COLOR_GRAD2, "|_______________RoadBlocks types_______________|");
		SendClientMessage(playerid, COLOR_GRAD3, "973,978,979,1422,1423,1424,1425,1427,1434,1459,19834");
		return 1;
	}

	if(slot < 1 || slot > 9)
		return SendErrorMessage(playerid, "��س�����Ţ���١��ͧ");

	if(model != 973 && model != 978 && model != 979 && model != 1422 && model != 1423 && model != 1424 && model != 1425 && model != 1427 && model != 1434 && model != 1459 && model != 19834) 
		return SendErrorMessage(playerid, "����Ţ Object ���١��ͧ");

	if(PlayerInfo[playerid][pObject][slot] != INVALID_OBJECT_ID)
		return SendErrorMessage(playerid, "�س���� ���͵��ͧ���㹡���ҧ Object ��������");

	GetPlayerPos(playerid, x, y,z);
	PlayerInfo[playerid][pObject][slot] = CreateDynamicObject(model, x, y, z, 0.0, 0.0, 0.0,-1,-1,-1);
	EditDynamicObject(playerid,PlayerInfo[playerid][pObject][slot]);
	SetPVarInt(playerid, "EditObejctRB", slot);
	SetPVarInt(playerid, "ObjectID", model);
	return 1;
}


hook OP_EditDynamicObject(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(GetPVarInt(playerid, "EditObejctRB"))
	{
		new id = GetPVarInt(playerid, "EditObejctRB");
		new modelid = GetPVarInt(playerid, "ObjectID");

		switch(response)
		{
			case EDIT_RESPONSE_FINAL:
			{
				if(IsValidDynamicObject(PlayerInfo[playerid][pObject][id]))
                    DestroyDynamicObject(PlayerInfo[playerid][pObject][id]);

				SendClientMessage(playerid, -1, "�س���ҧ����ŧ���������");
				DeletePVar(playerid, "EditObejctRB");
				PlayerInfo[playerid][pObject] = CreateDynamicObject(modelid, x, y, z, rx, ry, rz,-1,-1,-1);
				return 1;
			}
			case EDIT_RESPONSE_CANCEL: 
			{
				if(IsValidDynamicObject(PlayerInfo[playerid][pObject][id]))
                    DestroyDynamicObject(PlayerInfo[playerid][pObject][id]);
				
				DeletePVar(playerid, "EditObejctRB");
				PlayerInfo[playerid][pObject][id] = INVALID_OBJECT_ID;
				SendClientMessage(playerid, -1, "�س��¡��ԡ����ҧ����");
				return 1;
			}

		}
	}
	return 1;
}

forward OnLightFlash(vehicleid);
public OnLightFlash(vehicleid)
{
    new panels, doors, lights, tires;
    GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

    new states[ 3 ] = 
    {
        2, 4, 5
    };
    
    new idx = random( 3 );

    idx = ( ( states[ idx ] == VehicleInfo[ vehicleid ][ eVehicleElmFlash ] ) ? ( idx == 2 ? 0 : ( idx + 1 ) ) : idx );

    UpdateVehicleDamageStatus( vehicleid, panels, doors, states[ idx ], tires );
    VehicleInfo[ vehicleid ][ eVehicleElmFlash ] = states[ idx ];
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    foreach(new i : Player)
	{
		if(PlayerInfo[i][pFactionInvitedBy] == playerid)
		{
			PlayerInfo[i][pFactionInvite] = 0;
			PlayerInfo[i][pFactionInvitedBy] = INVALID_PLAYER_ID;
			SendClientMessage(i, COLOR_YELLOW, "���ԭ��������ͧ�س�١�ԡ�� ����ԭ�ͧ�س�١¡��ԡ�����������");
		}
	}

	for(new i = 0; i < 10; i++)
	{
		if(IsValidDynamicObject(PlayerInfo[playerid][pObject][i]))
        	DestroyDynamicObject(PlayerInfo[playerid][pObject][i]);
	}

	CharacterSave(playerid);

	if(PlayerInfo[playerid][pDuty])
	{
		if(ReturnFactionJob(playerid) == POLICE)
			SendDiscordMessageEx("duty-roster", "```HQ: %s %s has gone off duty```", ReturnFactionRank(playerid), ReturnName(playerid, 0));
	}
    return 1;
}

stock ReturnNameLetter(playerid)
{
	new 
		playersName[MAX_PLAYER_NAME]
	; 
	
	GetPlayerName(playerid, playersName, sizeof(playersName));
	
	format(playersName, sizeof(playersName), "%c. %s", playersName[0], playersName[strfind(playersName, "_") + 1]);
	return playersName;
}


stock SendFactionMessage(playerid, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if (PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction]) {
				if(PlayerInfo[i][pFactionChat] == false)
  				{ 
					SendClientMessage(i, color, string);
				}
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction]) {
			if(PlayerInfo[i][pFactionChat] == false)
  			{ 
				SendClientMessage(i, color, str);
			}
		}
	}
	return 1;
}

stock SendFactionMessageEx(playerid, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if (PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction]) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction]) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}


stock SendFactionMessageToAll(type , color, fmat[],  va_args<>)
{
	new
		str[145];

	va_format(str, sizeof (str), fmat, va_start<2>);

	foreach (new i : Player)
	{
		if(ReturnFactionJob(i) == type)
		{
			SendClientMessage(i, color, str);
		}
	}
}


stock HasSiren(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
		case 581, 521, 522, 461, 468, 523, 416, 427, 490,
			 528, 407, 544, 470, 596, 598, 599, 597, 607, 
			 428, 560: return 1;
	}
	return 0;
}
