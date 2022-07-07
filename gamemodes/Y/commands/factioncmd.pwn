#include <YSI_Coding\y_hooks>


new 
	playerWeaponsSave[MAX_PLAYERS][4], 
	playerWeaponsAmmoSave[MAX_PLAYERS][4]; 

alias:factionhelp("fhelp")
CMD:factionhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_RED, "[FACTION]:{FFFFFF} /f, /togfam, /nofam, /factionhelp"); 

    if(!PlayerInfo[playerid][pFaction])
		return 1;
    
    if(ReturnFactionType(playerid) == GOVERMENT)
    {
        SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /duty, /cuff, /uncuff, /showbadge, /m(egaphone), /(dep)artment,");
		SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /carsign, /remove_carsign, /tazer, /take, /givelicense, /impound, /mdc, /wanted");
		
		if(PlayerInfo[playerid][pFactionRank] <= FactionInfo[PlayerInfo[playerid][pFaction]][eFactionTowRank])
			SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /towcars");

        return 1;
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
		if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
			return SendErrorMessage(playerid, "�к�᪷������١�Դ�����ҹ����㹢�й��");  
			
		if(strlen(params) > 79)
		{
			SendFactionMessage(playerid, "{2ECC71}**(( %s %s: %.79s ))**", ReturnFactionRank(playerid), ReturnName(playerid, 0), params); 
			SendFactionMessage(playerid, "{2ECC71}**(( %s %s: ...%s ))**", ReturnFactionRank(playerid), ReturnName(playerid, 0), params[79]); 
		}
		else SendFactionMessage(playerid, "{2ECC71}**(( %s %s: %s ))**", ReturnFactionRank(playerid), ReturnName(playerid, 0), params); 
		return 1;
	}
	
	if(strlen(params) > 79)
	{
		SendFactionMessage(playerid, "{2ECC71}**(( %s %s: %.79s ))**", ReturnFactionRank(playerid), ReturnName(playerid, 0), params); 
		SendFactionMessage(playerid, "{2ECC71}**(( %s %s: ...%s ))**", ReturnFactionRank(playerid), ReturnName(playerid, 0), params[79]); 
	}
	else SendFactionMessage(playerid, "{2ECC71}**(( %s %s: %s ))**", ReturnFactionRank(playerid), ReturnName(playerid, 0), params);
    return 1;
}

CMD:nofam(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "�س����������࿤���");
		
	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
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
		
	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
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
		
	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
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
		
	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
		return SendErrorMessage(playerid, "��/����˹觢ͧ�س ������Ѻ͹حҵ���������觹��");

    if(sscanf(params, "ui", playerb, rank))
	{
		for(new i = 1; i < MAX_FACTION_RANKS; i++)
		{
			if(!strcmp(FactionRanks[PlayerInfo[playerid][pFaction]][i], "NotSet"))
				continue;
				
			SendClientMessageEx(playerid, COLOR_YELLOWEX, "-> Rank %i: %s", i, FactionRanks[PlayerInfo[playerid][pFaction]][i]); 
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
		
	if(PlayerInfo[playerb][pFactionRank] < PlayerInfo[playerid][pFactionRank])
		return SendErrorMessage(playerid, "�س�������ö��Ѻ������� ��/����˹� �ͧ %s", ReturnName(playerb));

    if(rank > PlayerInfo[playerb][pFactionRank])
    {
        SendClientMessageEx(playerb, COLOR_YELLOW, "�س�١Ŵ����˹觢ͧ�س �� %s �� %s", FactionRanks[PlayerInfo[playerb][pFaction]][rank], ReturnRealName(playerid, 0)); 
        SendClientMessageEx(playerid, COLOR_YELLOW, "�س��Ŵ����˹觢ͧ %s �ҡ %s �� %s!", ReturnRealName(playerb, 0), FactionRanks[PlayerInfo[playerb][pFaction]][PlayerInfo[playerb][pFactionRank]], FactionRanks[PlayerInfo[playerb][pFaction]][rank]);
            
        PlayerInfo[playerb][pFactionRank] = rank; 
        CharacterSave(playerb);
    }
    else
    {
        SendClientMessageEx(playerb, COLOR_YELLOW, "�س��١��������˹觢ͧ�س �� %s", FactionRanks[PlayerInfo[playerb][pFaction]][rank], ReturnRealName(playerid, 0)); 
        SendClientMessageEx(playerid, COLOR_YELLOW, "�س���ѻ�ô ��/����˹觢ͧ %s �ҡ %s �� %s!", ReturnRealName(playerb, 0), FactionRanks[PlayerInfo[playerb][pFaction]][PlayerInfo[playerb][pFactionRank]], FactionRanks[PlayerInfo[playerb][pFaction]][rank]);
            
        PlayerInfo[playerb][pFactionRank] = rank; 
        CharacterSave(playerb);
    }
    return 1;
}

CMD:factionon(playerid, params[])
{
	new factionid;
	
	if(sscanf(params, "I(-1)", factionid))
		return SendUsageMessage(playerid, "/factionon [࿤����ʹ�]");
		
	if(factionid == -1)
	{
		if(!PlayerInfo[playerid][pFaction])
			return SendErrorMessage(playerid, "�س����������࿤���");
			
		SendClientMessageEx(playerid, COLOR_GREY, "��Ҫԡ %s �͹�Ź�:", ReturnFactionName(playerid)); 
		
		foreach(new i : Player)
		{
			if(PlayerInfo[i][pFaction] != PlayerInfo[playerid][pFaction])
				continue;
				
			if(PlayerInfo[i][pAdminDuty])
				SendClientMessageEx(playerid, COLOR_GREY, "(ID: %i) {FF9900}%s %s", i, ReturnFactionRank(i), ReturnName(i));
				
			else
				SendClientMessageEx(playerid, COLOR_GREY, "(ID: %i) %s %s", i, ReturnFactionRank(i), ReturnName(i));
		}
		
		return 1;
	}

	if(!FactionInfo[factionid][eFactionDBID])
		return SendErrorMessage(playerid, "�����࿤��蹷��س�к�");
		
	SendClientMessageEx(playerid, COLOR_RED, "[ ! ]{FFFFFF} %s �� %i �͡�ҡ %i ��Ҫԡ �͹�Ź�",  ReturnFactionNameEx(factionid), ReturnOnlineMembers(factionid), ReturnTotalMembers(factionid));
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
		if(!PlayerInfo[playerid][pPoliceDuty])
		{
			if(!IsPlayerInRangeOfPoint(playerid, 5.0, FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][0], FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][1], FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][2]))
				return SendErrorMessage(playerid, "�س���������ش��͡����");

			if(GetPlayerVirtualWorld(playerid) != FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawnWorld])
				return SendErrorMessage(playerid, "�س���������ش��͡����");

			PlayerInfo[playerid][pPoliceDuty] = true;

			for(new i = 0; i < 4; i++)
			{
				playerWeaponsSave[playerid][i] = PlayerInfo[playerid][pWeapons][i];
				playerWeaponsAmmoSave[playerid][i] = PlayerInfo[playerid][pWeaponsAmmo][i];
			}

			SendPoliceMessage(0x8D8DFFFF, "HQ: %s %s has gone on duty", ReturnFactionRank(playerid), ReturnName(playerid, 0));
			SendClientMessage(playerid, COLOR_WHITE, "��觷��س�����Ѻ: Spraycan, Nitestick, Desert Eagle (60), Health(100)");

			new str[128];
			format(str, sizeof(str), "����Ժ��һ�Шӵ���͡�Ҩҡ�����͡����");
			callcmd::me(playerid, str);

			SetPlayerHealth(playerid, 100);
			SetPlayerArmour(playerid, 100);

			TakePlayerGuns(playerid);

			GivePlayerWeapon(playerid, 24, 100);
			GivePlayerWeapon(playerid, 3, 1);
			GivePlayerWeapon(playerid, 41, 350);

			if(!PlayerInfo[playerid][pAdminDuty])
				SetPlayerColor(playerid, COLOR_COP);
			return 1;
		}
		else
		{
			PlayerInfo[playerid][pPoliceDuty] = false;

			ResetPlayerWeapons(playerid);

			for(new i = 0; i < 4; i++)
			{
				PlayerInfo[playerid][pWeapons][i] = 0; PlayerInfo[playerid][pWeaponsAmmo][i] = 0;

				if(playerWeaponsSave[playerid][i])
					GivePlayerGun(playerid, playerWeaponsSave[playerid][i], playerWeaponsAmmoSave[playerid][i]);
			}

			SendPoliceMessage(0x8D8DFFFF, " HQ: %s %s has gone off duty", ReturnFactionRank(playerid), ReturnName(playerid, 0));
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
	if(ReturnFactionJob(playerid) == SHERIFF)
	{
        if(!PlayerInfo[playerid][pSheriffDuty])
        {
            if(!IsPlayerInRangeOfPoint(playerid, 5.0, FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][0], FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][1], FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][2]))
                return SendErrorMessage(playerid, "�س���������ش��͡����");
 
            PlayerInfo[playerid][pSheriffDuty] = true;
 
            for(new i = 0; i < 4; i++)
            {
                playerWeaponsSave[playerid][i] = PlayerInfo[playerid][pWeapons][i];
                playerWeaponsAmmoSave[playerid][i] = PlayerInfo[playerid][pWeaponsAmmo][i];
            }
 
            SendSheriffMessage(0x8D8DFFFF, "HQ: %s %s ���������Ժѵ˹�ҷ�����ǵ͹���", ReturnFactionRank(playerid), ReturnName(playerid, 0));
            SendClientMessage(playerid, COLOR_WHITE, "��觷��س�����Ѻ: Spraycan, Nitestick, Desert Eagle (60), Health(100)");
 
            new str[128];
			format(str, sizeof(str), "����Ժ��һ�Шӵ���͡�Ҩҡ�����͡����");
			callcmd::me(playerid, str);
 
            SetPlayerHealth(playerid, 100);
            SetPlayerArmour(playerid, 100);
 
            TakePlayerGuns(playerid);
 
            GivePlayerWeapon(playerid, 24, 100);
            GivePlayerWeapon(playerid, 3, 1);
            GivePlayerWeapon(playerid, 41, 350);
 
            if(!PlayerInfo[playerid][pAdminDuty])
                SetPlayerColor(playerid, COLOR_COP);
 
            return 1;
        }
 
        if(PlayerInfo[playerid][pSheriffDuty])
        {
            PlayerInfo[playerid][pSheriffDuty] = false;
 
            ResetPlayerWeapons(playerid);
 
            for(new i = 0; i < 4; i++)
            {
                PlayerInfo[playerid][pWeapons][i] = 0; PlayerInfo[playerid][pWeaponsAmmo][i] = 0;
 
                if(playerWeaponsSave[playerid][i])
                    GivePlayerGun(playerid, playerWeaponsSave[playerid][i], playerWeaponsAmmoSave[playerid][i]);
            }
 
            SendPoliceMessage(0x8D8DFFFF, " HQ: %s %s ���͡�ҡ��û�Ժѵ˹�ҷ������ҹ��", ReturnFactionRank(playerid), ReturnName(playerid, 0));
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
	    if(!PlayerInfo[playerid][pMedicDuty])
		{
	    	if(!IsPlayerInRangeOfPoint(playerid, 5.0, FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][0], FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][1], FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][2]))
				return SendErrorMessage(playerid, "�س���������ش��͡����");

			PlayerInfo[playerid][pMedicDuty] = true;

			for(new i = 0; i < 4; i++)
			{
				playerWeaponsSave[playerid][i] = PlayerInfo[playerid][pWeapons][i];
				playerWeaponsAmmoSave[playerid][i] = PlayerInfo[playerid][pWeaponsAmmo][i];
			}

			SendMedicMessage(0xFF8282FF, "HQ: %s %s ���������Ժѵ˹�ҷ�����ǵ͹���", ReturnFactionRank(playerid), ReturnName(playerid, 0));
			SendClientMessage(playerid, COLOR_WHITE, "��觷��س�����Ѻ: �ѧ�Ѻ��ԧ");

			new str[128];
			format(str, sizeof(str), "����Ժ��һ�Шӵ���͡�Ҩҡ�����͡����");
			callcmd::me(playerid, str);

    		SetPlayerColor(playerid, 0xFF8282FF);
			SetPlayerHealth(playerid, 100);
			SetPlayerArmour(playerid, 100);

			TakePlayerGuns(playerid);

			GivePlayerWeapon(playerid, 42, 500);

			if(!PlayerInfo[playerid][pAdminDuty])
				SetPlayerColor(playerid, COLOR_PINK);

            return 1;
		}

		if(PlayerInfo[playerid][pMedicDuty])
		{
		    PlayerInfo[playerid][pMedicDuty] = false;

			ResetPlayerWeapons(playerid);

			for(new i = 0; i < 4; i++)
			{
				PlayerInfo[playerid][pWeapons][i] = 0; PlayerInfo[playerid][pWeaponsAmmo][i] = 0;

				if(playerWeaponsSave[playerid][i])
					GivePlayerGun(playerid, playerWeaponsSave[playerid][i], playerWeaponsAmmoSave[playerid][i]);
			}

			SendMedicMessage(0xFF8282FF, " HQ: %s %s ���͡�ҡ��û�Ժѵ˹�ҷ������ҹ��", ReturnFactionRank(playerid), ReturnName(playerid, 0));
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
	    if(!PlayerInfo[playerid][pSADCRDuty])
		{
	    	if(!IsPlayerInRangeOfPoint(playerid, 5.0, FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][0], FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][1], FactionInfo[PlayerInfo[playerid][pFaction]][eFactionSpawn][2]))
				return SendErrorMessage(playerid, "�س���������ش��͡����");

			PlayerInfo[playerid][pSADCRDuty] = true;

			for(new i = 0; i < 4; i++)
			{
				playerWeaponsSave[playerid][i] = PlayerInfo[playerid][pWeapons][i];
				playerWeaponsAmmoSave[playerid][i] = PlayerInfo[playerid][pWeaponsAmmo][i];
			}

			SendDOCMessage(0xFF8282FF, "HQ: %s %s ���������Ժѵ˹�ҷ�����ǵ͹���", ReturnFactionRank(playerid), ReturnName(playerid, 0));
			SendClientMessage(playerid, COLOR_WHITE, "��觷��س�����Ѻ: �ѧ�Ѻ��ԧ");

			new str[128];
			format(str, sizeof(str), "����Ժ��һ�Шӵ���͡�Ҩҡ�����͡����");
			callcmd::me(playerid, str);

    		SetPlayerColor(playerid, 0xFF8282FF);
			SetPlayerHealth(playerid, 100);
			SetPlayerArmour(playerid, 100);

			TakePlayerGuns(playerid);

			GivePlayerWeapon(playerid, 25, 150);
			GivePlayerWeapon(playerid, 24, 150);
			GivePlayerWeapon(playerid, 3, 1);
			GivePlayerWeapon(playerid, 41, 350);

			if(!PlayerInfo[playerid][pAdminDuty])
				SetPlayerColor(playerid, COLOR_PINK);

            return 1;
		}

		if(PlayerInfo[playerid][pSADCRDuty])
		{
		    PlayerInfo[playerid][pSADCRDuty] = false;

			ResetPlayerWeapons(playerid);

			for(new i = 0; i < 4; i++)
			{
				PlayerInfo[playerid][pWeapons][i] = 0; PlayerInfo[playerid][pWeaponsAmmo][i] = 0;

				if(playerWeaponsSave[playerid][i])
					GivePlayerGun(playerid, playerWeaponsSave[playerid][i], playerWeaponsAmmoSave[playerid][i]);
			}

			SendDOCMessage(0xFF8282FF, " HQ: %s %s ���͡�ҡ��û�Ժѵ˹�ҷ������ҹ��", ReturnFactionRank(playerid), ReturnName(playerid, 0));
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
		return SendUsageMessage(playerid, "/showbadge [���ͺҧ��ǹ/�ʹ�]"); 
		
	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "������������������͡Ѻ�׿�����");
		
	if(!BitFlag_Get(gPlayerBitFlag[playerb], IS_LOGGED))
		return SendErrorMessage(playerid, "�����蹡��ѧ�������к�"); 
		
	if(!IsPlayerNearPlayer(playerid, playerb, 5.0))
		return SendErrorMessage(playerid, "������������������س");
		
	if(playerb == playerid)
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s ��Ժ��һ�Шӵ�Ǣ���Ҵ�", ReturnName(playerid, 0));
	
	else SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s ��Ժ��һ�Шӵ�Ǣ�������������Ѻ %s ��", ReturnName(playerid, 0), ReturnName(playerb, 0));
	
	SendClientMessage(playerb, COLOR_COP, "______________________________________");
	
	SendClientMessageEx(playerb, COLOR_GRAD2, "  ����: %s", ReturnNameLetter(playerid));
	SendClientMessageEx(playerb, COLOR_GRAD2, "  �Ţ���: %d", PlayerInfo[playerid][pBadge]);
	SendClientMessageEx(playerb, COLOR_GRAD2, "  ��/����˹�: %s", ReturnFactionRank(playerid));
	SendClientMessageEx(playerb, COLOR_GRAD2, "  �ӹѡ�ҹ: %s", ReturnFactionName(playerid));
	
	SendClientMessage(playerb, COLOR_COP, "______________________________________");
	return 1;
}

alias:megaphone("m")
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
			SendClientMessageEx(i, COLOR_DEPT, "** [%s] %s %s: %s", FactionInfo[factionid][eFactionAbbrev], ReturnFactionRank(i), ReturnName(playerid, 0), params); 
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

	if(VehFacInfo[vehicleid][VehFacFaction] != factionid)
		return SendErrorMessage(playerid, "ö�ѹ��������ö࿤��蹢ͧ�س");

	GetVehiclePos(vehicleid, VehFacInfo[vehicleid][VehFacPos][0], VehFacInfo[vehicleid][VehFacPos][1], VehFacInfo[vehicleid][VehFacPos][2]);
	GetVehicleZAngle(vehicleid, VehFacInfo[vehicleid][VehFacPos][3]);
	VehFacInfo[vehicleid][VehFacPosWorld] = GetPlayerVirtualWorld(playerid); 

	SendFactionMessage(playerid, "{2ECC71}**(( %s ������¹�ش�ҹ��˹� �ʹ� %d ))**",ReturnRealName(playerid, 0), VehFacInfo[vehicleid][VehFacDBID]);

	SaveFacVehicle(vehicleid);

	DestroyVehicle(vehicleid);

	vehicleid = CreateVehicle(VehFacInfo[vehicleid][VehFacModel], VehFacInfo[vehicleid][VehFacPos][0], VehFacInfo[vehicleid][VehFacPos][1], VehFacInfo[vehicleid][VehFacPos][2], VehFacInfo[vehicleid][VehFacPos][3], VehFacInfo[vehicleid][VehFacColor][0], VehFacInfo[vehicleid][VehFacColor][1], -1, 0);
	ToggleVehicleEngine(vehicleid, false); VehicleInfo[vehicleid][eVehicleEngineStatus] = false;
	PutPlayerInVehicle(playerid, vehicleid, 0);
	return 1;
}

CMD:towcars(playerid, params[])
{
	new id = PlayerInfo[playerid][pFaction];

	if(FactionInfo[id][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���");

	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[id][eFactionAlterRank])
		return SendErrorMessage(playerid, "��/����˹觢ͧ�س ������Ѻ͹حҵ���������觹��");

	for(new v = 1; v< MAX_VEHICLES; v++)
	{
		if(!VehicleInfo[v][eVehicleFaction])
			continue;

		if(VehicleInfo[v][eVehicleFaction] != id)
			continue;

		if(IsVehicleOccupied(v))
			continue;

		SetVehicleToRespawn(v);
		LinkVehicleToInterior(v, VehicleInfo[v][eVehicleParkInterior]);
		SetVehicleVirtualWorld(v, VehicleInfo[v][eVehicleParkWorld]);
		SetVehicleNumberPlate(v, FactionInfo[id][eFactionAbbrev]);
		SetVehicleHp(v);
	}

	SendFactionMessageEx(playerid, -1, "{2ECC71}**(( %s �����ҹ��˹з������դ���觢ͧ�������Ѻ�ش�Դ������ ))**", ReturnName(playerid, 0));
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


stock SendFactionMessage(playerid, const str[], {Float,_}:...)
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
					SendClientMessage(i, FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatColor], string);
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
				SendClientMessage(i, FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatColor], str);
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

stock SendPoliceMessage(color, const str[], {Float,_}:...)
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
			if (FactionInfo[PlayerInfo[i][pFaction]][eFactionJob] == POLICE) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (FactionInfo[PlayerInfo[i][pFaction]][eFactionJob] == POLICE) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}

stock SendSheriffMessage(color, const str[], {Float,_}:...)
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
			if (FactionInfo[PlayerInfo[i][pFaction]][eFactionJob] == SHERIFF) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (FactionInfo[PlayerInfo[i][pFaction]][eFactionJob] == SHERIFF) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}

stock SendMedicMessage(color, const str[], {Float,_}:...)
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
			if (FactionInfo[PlayerInfo[i][pFaction]][eFactionJob] == MEDIC) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (FactionInfo[PlayerInfo[i][pFaction]][eFactionJob] == MEDIC) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}

stock SendDOCMessage(color, const str[], {Float,_}:...)
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
			if (FactionInfo[PlayerInfo[i][pFaction]][eFactionJob] == SADCR) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (FactionInfo[PlayerInfo[i][pFaction]][eFactionJob] == SADCR) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}
