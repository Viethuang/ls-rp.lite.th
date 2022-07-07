
#define GANG (1)
#define GOVERMENT (2)

#define POLICE (1)
#define MEDIC (2)
#define SHERIFF (3)
#define SADCR (4)
#define GOV (5)

forward Query_InsertFaction(playerid, varName, varAbbrev, idx);
public Query_InsertFaction(playerid, varName, varAbbrev, idx)
{
	new insertRanks[90], str[128];
		
	mysql_format(dbCon, insertRanks, sizeof(insertRanks), "INSERT INTO faction_ranks (`factionid`) VALUES(%i)", cache_insert_id()); 
	mysql_tquery(dbCon, insertRanks); 
	
	FactionInfo[idx][eFactionDBID] = cache_insert_id();
		
	format(FactionInfo[idx][eFactionName], 90, "%s", varName);
	format(FactionInfo[idx][eFactionAbbrev], 30, "%s", varAbbrev); 
		
	format(str, sizeof(str), "%s �����ҧ࿤��� �ʹ�:%d �����", ReturnName(playerid), cache_insert_id());
	SendAdminMessage(4, str);
	
	SendServerMessage(playerid, "���ҧ࿤���������ô����� \"/factions\".���ͷӡ����� (%d)",cache_insert_id()); 
	return 1;
}

forward Query_LoadFactions();
public Query_LoadFactions()
{
	if(!cache_num_rows())
		return printf("[SERVER]: No factions were loaded from \"%s\" database...", MYSQL_DB);
		
	new newThread[128], rows; cache_get_row_count(rows);
	
	for (new i = 0; i < rows && i < MAX_FACTIONS; i ++)
	{
        cache_get_value_name_int(i,"DBID",FactionInfo[i+1][eFactionDBID]);
		
        cache_get_value_name(i,"FactionName",FactionInfo[i+1][eFactionName], 90);
		cache_get_value_name(i,"FactionAbbrev",FactionInfo[i+1][eFactionAbbrev], 90);
		
        cache_get_value_name_float(i,"FactionSpawnX",FactionInfo[i+1][eFactionSpawn][0]);
        cache_get_value_name_float(i,"FactionSpawnY",FactionInfo[i+1][eFactionSpawn][1]);
        cache_get_value_name_float(i,"FactionSpawnZ",FactionInfo[i+1][eFactionSpawn][2]);
		
        cache_get_value_name_int(i,"FactionInterior",FactionInfo[i+1][eFactionSpawnInt]);
        cache_get_value_name_int(i,"FactionWorld",FactionInfo[i+1][eFactionSpawnWorld]);
		
        cache_get_value_name_int(i,"FactionJoinRank",FactionInfo[i+1][eFactionJoinRank]);
        cache_get_value_name_int(i,"FactionAlterRank",FactionInfo[i+1][eFactionAlterRank]);
        cache_get_value_name_int(i,"FactionChatRank",FactionInfo[i+1][eFactionChatRank]);
        cache_get_value_name_int(i,"FactionTowRank",FactionInfo[i+1][eFactionTowRank]);
		
        cache_get_value_name_int(i,"FactionChatColor",FactionInfo[i+1][eFactionChatColor]);
		
        cache_get_value_name_int(i,"FactionType",FactionInfo[i+1][eFactionType]);
        cache_get_value_name_int(i,"FactionJob",FactionInfo[i+1][eFactionJob]);
		
		mysql_format(dbCon, newThread, sizeof(newThread), "SELECT * FROM faction_ranks WHERE factionid = %i", i+1); 
		mysql_tquery(dbCon, newThread, "Query_LoadFactionRanks", "i", i+1);
	}
	printf("[SERVER]: %i factions were loaded from \"%s\" database...", rows, MYSQL_DB);
	return 1;
}

forward OnPlayerEnterFaction(playerid, id);
public OnPlayerEnterFaction(playerid, id)
{
	SetPlayerPos(playerid, FactionInfo[id][eFactionSpawn][0], FactionInfo[id][eFactionSpawn][1], FactionInfo[id][eFactionSpawn][2]);
            
    SetPlayerVirtualWorld(playerid, FactionInfo[id][eFactionSpawnWorld]);
    SetPlayerInterior(playerid, FactionInfo[id][eFactionSpawnInt]);
	TogglePlayerControllable(playerid, 1);
	return 1;
}

forward Query_LoadFactionRanks(factionid);
public Query_LoadFactionRanks(factionid)
{
	new str[128];
	
	new rows; cache_get_row_count(rows);
	
	for (new i = 0; i < rows; i++)
	{
		for (new j = 1; j < MAX_FACTION_RANKS; j++)
		{
			format(str, sizeof(str), "FactionRank%i", j); 
            cache_get_value_name(i,str,FactionRanks[factionid][j],60);
		}
	}
	return 1;
}

stock ReturnTotalMembers(factionid)
{
	if(factionid == 0 || !FactionInfo[factionid][eFactionDBID])
		return 0; 
		
	new threadCheck[128], counter;
	
	mysql_format(dbCon, threadCheck, sizeof(threadCheck), "SELECT COUNT(*) FROM characters WHERE pFaction = %i", factionid);
	mysql_query(dbCon, threadCheck); 
	
	cache_get_value_index_int(0, 0,counter);
	return counter;
}

stock ReturnOnlineMembers(factionid)
{
	new counter;
		
	foreach(new i : Player)
	{
		if(!BitFlag_Get(gPlayerBitFlag[i], IS_LOGGED))
			continue;
		
		if(PlayerInfo[i][pFaction] == factionid)
		{
			counter++;
		}
	}
	return counter;
}

stock ReturnFactionName(playerid)
{
	new factionName[90];
	
	if(!PlayerInfo[playerid][pFaction])
		factionName = "����ա������";
		
	else
		format(factionName, sizeof(factionName), "%s", FactionInfo[PlayerInfo[playerid][pFaction]][eFactionName]);
		
	return factionName;
}

stock ReturnFactionNameEx(factionid)
{
	new factionName[90];
	
	format(factionName, sizeof(factionName), "%s", FactionInfo[factionid][eFactionName]);
	return factionName;
}

stock ReturnFactionAbbrev(factionid)
{		
	 new facAbbrev[90];
	 
	 format(facAbbrev, sizeof(facAbbrev), "%s", FactionInfo[factionid][eFactionAbbrev]);
	 return facAbbrev; 
}

stock ReturnFactionRank(playerid)
{
	new rankStr[90]; 
	
	if(!PlayerInfo[playerid][pFaction])
	{
		if(PlayerInfo[playerid][pJob] == JOB_MECHANIC)
		{
			switch(PlayerInfo[playerid][pJobRank])
			{
				case 1: rankStr = "��ҧ�֡�Ѵ";
				case 2: rankStr = "��ҧ��Ш����";
				case 3: rankStr = "���˹�ҧҹ��ҧ";
			}
		}
		rankStr = "����յ���˹�";
	}
	else
	{
		new 
			factionid = PlayerInfo[playerid][pFaction],
			rank = PlayerInfo[playerid][pFactionRank];
			
		format(rankStr, sizeof(rankStr), "%s", FactionRanks[factionid][rank]);
	}
	return rankStr;
}

stock ReturnFactionType(playerid)
{
	if(!PlayerInfo[playerid][pFaction])
		return 0;
	
	return FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType];
}

stock ReturnFactionJob(playerid)
{
	if(!PlayerInfo[playerid][pFaction])
		return 0;
	
	return FactionInfo[PlayerInfo[playerid][pFaction]][eFactionJob];
}

stock ShowFactionConfig(playerid)
{
	new rankCount, infoString[128], showString[256];
	
	format(infoString, sizeof(infoString), "����: %s\n", FactionInfo[PlayerSelectFac[playerid]][eFactionName]);
	strcat(showString, infoString); 
	
	format(infoString, sizeof(infoString), "�������: %s\n", ReturnFactionAbbrev(PlayerSelectFac[playerid]));
	strcat(showString, infoString);
	
	format(infoString, sizeof(infoString), "�ȵ���˹觷��Ǻ���: %d\n", FactionInfo[PlayerSelectFac[playerid]][eFactionAlterRank]);
	strcat(showString, infoString);
	
	format(infoString, sizeof(infoString), "���˹��������: %d\n", FactionInfo[PlayerSelectFac[playerid]][eFactionJoinRank]);
	strcat(showString, infoString);
	
	format(infoString, sizeof(infoString), "����˹觷������ö�����: %d\n", FactionInfo[PlayerSelectFac[playerid]][eFactionChatRank]);
	strcat(showString, infoString);
	
	format(infoString, sizeof(infoString), "�բ᪷ͧ\n", FactionInfo[PlayerSelectFac[playerid]][eFactionChatColor]);
	strcat(showString, infoString);
	
	for(new i = 1; i < MAX_FACTION_RANKS; i++)
	{
		if(!strcmp(FactionRanks[PlayerSelectFac[playerid]][i], "NotSet"))
			continue;
			
		rankCount++;
	}
	
	format(infoString, sizeof(infoString), "��/����˹� (%i)\n", rankCount);
	strcat(showString, infoString);
	
	strcat(showString, "�ش�Դ࿤���\n"); 
	
	format(infoString, sizeof(infoString), "����˹觷������ö��ö: %d\n", FactionInfo[PlayerSelectFac[playerid]][eFactionTowRank]);
	strcat(showString, infoString);


    if(!FactionInfo[PlayerSelectFac[playerid]][eFactionType])
    {
        format(infoString, sizeof(infoString), "�����࿤���: ������駤��\n");
        strcat(showString, infoString);
    }
    if(FactionInfo[PlayerSelectFac[playerid]][eFactionType] == 1)
    {
        format(infoString, sizeof(infoString), "�����࿤���: ��\n");
        strcat(showString, infoString);
    }
    if(FactionInfo[PlayerSelectFac[playerid]][eFactionType] == 2)
    {
        format(infoString, sizeof(infoString), "�����࿤���: �Ѱ���\n");
        strcat(showString, infoString);
    }

    if(!FactionInfo[PlayerSelectFac[playerid]][eFactionJob])
    {
        format(infoString, sizeof(infoString), "�Ҫվ: ������駤��\n");
        strcat(showString, infoString);
    }
    if(FactionInfo[PlayerSelectFac[playerid]][eFactionJob])
    {
        if(FactionInfo[PlayerSelectFac[playerid]][eFactionJob] == 1)
        {
            format(infoString, sizeof(infoString), "�Ҫվ: ���Ǩ\n");
        }
        if(FactionInfo[PlayerSelectFac[playerid]][eFactionJob] == 2)
        {
            format(infoString, sizeof(infoString), "�Ҫվ: ᾷ��\n");
        }
        if(FactionInfo[PlayerSelectFac[playerid]][eFactionJob] == 3)
        {
            format(infoString, sizeof(infoString), "�Ҫվ: ��������\n");
        }
        if(FactionInfo[PlayerSelectFac[playerid]][eFactionJob] == 4)
        {
            format(infoString, sizeof(infoString), "�Ҫվ: ����Ҫ�ѳ��\n");
        }
        strcat(showString, infoString);
    }
	
	Dialog_Show(playerid, DIALOG_FACTION_CONFIG, DIALOG_STYLE_LIST, "{ADC3E7}Faction Configuration", showString, "Select", "<<");
	return 1;
}

Dialog:DIALOG_EDITFACTION(playerid, response, listitem, inputtext[])
{
    if(!response)
        return 1;

    PlayerSelectFac[playerid] = listitem+1;

    ShowFactionConfig(playerid);
    return 1;
}
Dialog:DIALOG_FACTION_CONFIG(playerid, response, listitem, inputtext[])
{
    if(response)
	{
	    switch(listitem)
        {
            case 0: return Dialog_Show(playerid, DIALOG_FACTION_NAME, DIALOG_STYLE_INPUT, "Faction Configuration", "������࿤��蹢ͧ�س:", "Select", "<<"); 
            case 1: return Dialog_Show(playerid, DIALOG_FACTION_ABBREV, DIALOG_STYLE_INPUT, "Faction Configuration", "���������࿤��蹢ͧ�س:", "Select", "<<");
            case 2: return Dialog_Show(playerid, DIALOG_FACTION_ALTER_R, DIALOG_STYLE_INPUT, "Faction Configuration", "����Ţ��/����˹觷����������ö�����:", "��ŧ", "<<");      
			case 3: return Dialog_Show(playerid, DIALOG_FACTION_ALTER_J, DIALOG_STYLE_INPUT, "Faction Configuration", "����Ţ��/����˹觷��������¹�������:", "��ŧ", "<<");
			case 4: return Dialog_Show(playerid, DIALOG_FACTION_ALTER_C, DIALOG_STYLE_INPUT, "Faction Configuration", "����Ţ��/����˹觷���������᪷�������", "��ŧ", "<<");
			case 5: return Dialog_Show(playerid, DIALOG_FACTION_CHATCOLOR, DIALOG_STYLE_MSGBOX, "Faction Configuration", "{FF0033}�ѧ���ͳحҵ���������觹���ô����", "��ŧ", "<<");
			case 6: return Dialog_Show(playerid, DIALOG_FACTION_RANKS, DIALOG_STYLE_INPUT, "Faction Configuration", "����Ţ��/����˹� ���س��ͧ������(1-20)", "��ŧ", "<<");
			case 7:
			{		
				new factionid = PlayerSelectFac[playerid];
					
				GetPlayerPos(playerid, FactionInfo[factionid][eFactionSpawn][0], FactionInfo[factionid][eFactionSpawn][1], FactionInfo[factionid][eFactionSpawn][2]);
		
				FactionInfo[factionid][eFactionSpawnInt] = GetPlayerInterior(playerid);
					
				if(GetPlayerVirtualWorld(playerid) == 0)
					FactionInfo[factionid][eFactionSpawnWorld] = random(99999); 
							
				else FactionInfo[factionid][eFactionSpawnWorld] = GetPlayerVirtualWorld(playerid);
				
				SaveFaction(PlayerSelectFac[playerid]);
				SendServerMessage(playerid, "����¹�ش�Դ࿤�������"); 
				return ShowFactionConfig(playerid);
			}
			case 8: return Dialog_Show(playerid, DIALOG_FACTION_ALTER_T, DIALOG_STYLE_INPUT, "Faction Configuration", "����Ţ��/����˹� ���س��ͧ���������ҹ��˹���:", "��ŧ", "<<");
			case 9: 
			{
				new str[MAX_STRING];
				format(str, sizeof(str), "{D35400}[{FFEB3B} ! {D35400}]{FF5722} ��\n\
										  {D35400}[{FFEB3B} ! {D35400}]{1976D2} �Ѱ���");
				return Dialog_Show(playerid, DIALOG_FACTION_TYPE, DIALOG_STYLE_LIST, "Faction Configuration", str, "��ŧ", "<<");
			}
			case 10: 
			{
				if(FactionInfo[PlayerSelectFac[playerid]][eFactionType] != 2)
				{
					SendClientMessageEx(playerid, -1, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF} ࿤��� {FFEE58}%s {FFFFFF}�������࿤����Ѱ���",FactionInfo[PlayerSelectFac[playerid]][eFactionName]);
					return ShowFactionConfig(playerid);
				}
				new str[MAX_STRING];
				format(str, sizeof(str), "{D35400}[{FFEB3B} ! {D35400}]{FFFFFF} ���Ǩ\n\
										  {D35400}[{FFEB3B} ! {D35400}]{FFFFFF} ���\n\
										  {D35400}[{FFEB3B} ! {D35400}]{FFFFFF} ��������\n\
										  {D35400}[{FFEB3B} ! {D35400}]{FFFFFF} ����Ҫ�ѳ��\n\
										  {D35400}[{FFEB3B} ! {D35400}]{FFFFFF} �Ѱ���\n");
				return Dialog_Show(playerid, DIALOG_FACTION_JOB, DIALOG_STYLE_LIST, "Faction Configuration", str, "��ŧ", "<<");
			}
        }
    }
    return 1;
}

Dialog:DIALOG_FACTION_NAME(playerid, response, listitem, inputtext[])
{
    if(!response)
        ShowFactionConfig(playerid);

    if(response)
    {
        if(strlen(inputtext) > 90 || strlen(inputtext) < 3)
            return Dialog_Show(playerid, DIALOG_FACTION_NAME, DIALOG_STYLE_INPUT, "Faction Configuration", "����࿤��蹢ͧ�س�������Թ 90 ����ѡ��\n\n������࿤��蹢ͧ�س:", "��ŧ", "<<");
        
        format(FactionInfo[PlayerSelectFac[playerid]][eFactionName], 90, "%s", inputtext);
        SendClientMessageEx(playerid, -1, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF} ����࿤��蹢ͧ�س: \"%s\".", inputtext);
        SaveFaction(PlayerSelectFac[playerid]);
        ShowFactionConfig(playerid);
        return 1;
    }
    return 1;
}

Dialog:DIALOG_FACTION_ABBREV(playerid, response, listitem, inputtext[])
{
    if(!response)
		return ShowFactionConfig(playerid);

    if(response)
    {
        if(strlen(inputtext) > 30 || strlen(inputtext) < 1)
            return Dialog_Show(playerid, DIALOG_FACTION_ABBREV, DIALOG_STYLE_INPUT, "Faction Configuration", "�������࿤��蹢ͧ�س�������Թ 30 ����ѡ��\n\n���������࿤��蹢ͧ�س:", "��ŧ", "<<"); 
                    
        format(FactionInfo[PlayerSelectFac[playerid]][eFactionAbbrev], 30, "%s", inputtext);
        SendClientMessageEx(playerid, -1, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF} �������࿤�������ͧ�س: \"%s\".", inputtext);
        SaveFaction(PlayerSelectFac[playerid]);
                
        return ShowFactionConfig(playerid);
    }
    return 1;
}

Dialog:DIALOG_FACTION_ALTER_R(playerid, response, listitem, inputtext[])
{
	if(!response)
		return ShowFactionConfig(playerid);

	if(response)
	{	
		if(strlen(inputtext) < 1 || strlen(inputtext) > 2)
			return Dialog_Show(playerid, DIALOG_FACTION_ALTER_R, DIALOG_STYLE_INPUT, "Faction Configuration", "����Ţ��/����˹觷����������ö�����:", "��ŧ", "<<"); 

		new rankid = strval(inputtext); 
				
		if(rankid > 20 || rankid < 1)
			return Dialog_Show(playerid, DIALOG_FACTION_ALTER_R, DIALOG_STYLE_INPUT, "Faction Configuration", "�Ţ��/���˹� ��ͧ����Թ 1-20\n\n����Ţ��/����˹觷����������ö�����", "��ŧ", "<<"); 
				
		FactionInfo[PlayerSelectFac[playerid]][eFactionAlterRank] = rankid;
		SendClientMessageEx(playerid, -1, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF} �Ţ��/����˹觷����������ö�����: %i.", rankid);
		SaveFaction(PlayerSelectFac[playerid]);
				
		return ShowFactionConfig(playerid);
	}
	return 1;
}

Dialog:DIALOG_FACTION_ALTER_J(playerid, response, listitem, inputtext[])
{
	if(!response)
		return ShowFactionConfig(playerid);

	if(response)
	{		
		if(strlen(inputtext) < 1 || strlen(inputtext) > 2)
			return Dialog_Show(playerid, DIALOG_FACTION_ALTER_J, DIALOG_STYLE_INPUT, "Faction Configuration", "����Ţ��/����˹觷��������¹�������:", "Select", "<<");

		new rankid = strval(inputtext); 
				
		if(rankid > 20 || rankid < 1)
			return Dialog_Show(playerid, DIALOG_FACTION_ALTER_J, DIALOG_STYLE_INPUT, "Faction Configuration", "�Ţ��/����˹觵�ͧ����Թ 1-20.\n\n����Ţ��/����˹觷��������¹�������:", "��ŧ", "<<"); 
				
		FactionInfo[PlayerSelectFac[playerid]][eFactionJoinRank] = rankid;
		SendClientMessageEx(playerid, -1, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF} �Ţ��/����˹觷��������¹�������: %i.", rankid);
		SaveFaction(PlayerSelectFac[playerid]);
				
		return ShowFactionConfig(playerid);
	}

	return 1;
}

Dialog:DIALOG_FACTION_ALTER_C(playerid, response, listitem, inputtext[])
{
	if(!response)
		return ShowFactionConfig(playerid);
	
	if(response)
	{
		if(strlen(inputtext) < 1 || strlen(inputtext) > 2)
			return Dialog_Show(playerid, DIALOG_FACTION_ALTER_C, DIALOG_STYLE_INPUT, "Faction Configuration", "����Ţ��/����˹觷���������᪷�������:", "Select", "<<"); 

		new rankid = strval(inputtext); 
			
		if(rankid > 20 || rankid < 1)
			return Dialog_Show(playerid, DIALOG_FACTION_ALTER_C, DIALOG_STYLE_INPUT, "Faction Configuration", "�Ţ��/����˹觵�ͧ����Թ 1-20.\n\n����Ţ��/����˹觷���������᪷�������:", "��ŧ", "<<"); 
			
		FactionInfo[PlayerSelectFac[playerid]][eFactionChatRank] = rankid;
		SendClientMessageEx(playerid, -1, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF} �س������¹���������: %i ��������ö������к�᪷�������(/f)", rankid);
		SaveFaction(PlayerSelectFac[playerid]);
			
		return ShowFactionConfig(playerid);
	}
	return 1;
}

Dialog:DIALOG_FACTION_CHATCOLOR(playerid, response, listitem, inputtext[])
{
	if(!response)
		return ShowFactionConfig(playerid);
	
	if(response)
	{
		return ShowFactionConfig(playerid);
	}
	return 1;
}

Dialog:DIALOG_FACTION_RANKS(playerid, response, listitem, inputtext[])
{
	if(!response)
		return ShowFactionConfig(playerid);
	
	if(response)
	{
		new rankid = strval(inputtext), str[128];
				
		if(rankid > 20 || rankid < 1)
			return Dialog_Show(playerid, DIALOG_FACTION_RANKS, DIALOG_STYLE_INPUT, "Faction Configuration", "����Ţ��/����˹� ������䢪��� ��/����˹�", "��ŧ", "<<");
					
		playerEditingRank[playerid] = rankid;
				
		format(str, sizeof(str), "�س���ѧ�����/����˹� %i ('%s').\n\n{F81414}�ҡ��ź�������˵���� \"NotSet\". ", rankid, FactionRanks[PlayerSelectFac[playerid]][rankid]);
		return Dialog_Show(playerid, DIALOG_FACTION_RANKEDIT, DIALOG_STYLE_INPUT, "Faction Configuration", str, "��ŧ", "<<");
	}
	return 1;
}

Dialog:DIALOG_FACTION_RANKEDIT(playerid, response, listitem, inputtext[])
{
	if(!response)
		return ShowFactionConfig(playerid);
	
	if(response)
	{
		new str[128];
				
		if(strlen(inputtext) > 60 || strlen(inputtext) < 1)
		{
			format(str, sizeof(str), "�س��õ�駪���������Թ 60 ����ѡ��\n\n�س���ѧ�����/����˹� %i ('%s').\n{F81414}�ҡ��ź�������˵���� \"NotSet\".", FactionRanks[PlayerInfo[playerid][pFaction]][playerEditingRank[playerid]], playerEditingRank[playerid]);
			return Dialog_Show(playerid, DIALOG_FACTION_RANKEDIT, DIALOG_STYLE_INPUT, "Faction Configuration", str, "��ŧ", "<<"); 
		}
			
		SendServerMessage(playerid, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF} �س����䢪���� %i (%s) ��: \"%s\". ", playerEditingRank[playerid], FactionRanks[PlayerSelectFac[playerid]][playerEditingRank[playerid]], inputtext);
		format(FactionRanks[PlayerSelectFac[playerid]][playerEditingRank[playerid]], 60, "%s", inputtext);
		
		SaveFactionRanks(PlayerSelectFac[playerid]);

		return ShowFactionConfig(playerid);
	}
	return 1;
}
Dialog:DIALOG_FACTION_ALTER_T(playerid, response, listitem, inputtext[])
{
	if(!response)
		return ShowFactionConfig(playerid);

	if(response)
	{
		if(strlen(inputtext) < 1 || strlen(inputtext) > 2)
			return Dialog_Show(playerid, DIALOG_FACTION_ALTER_T, DIALOG_STYLE_INPUT, "Faction Configuration", "����Ţ��/����˹觷�������ö ���ҹ��˹���:", "��ŧ", "<<"); 
					
		new rankid = strval(inputtext); 
				
		if(rankid > 20 || rankid < 1)
			return Dialog_Show(playerid, DIALOG_FACTION_ALTER_T, DIALOG_STYLE_INPUT, "Faction Configuration", "�Ţ��/����˹觵�ͧ����Թ 1-20.\n\n����Ţ��/����˹觷�������ö ���ҹ��˹���:", "��ŧ", "<<");

		FactionInfo[PlayerSelectFac[playerid]][eFactionTowRank] = rankid;
		SaveFaction(PlayerSelectFac[playerid]);
		SendServerMessage(playerid, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF} �Ţ��/����˹觷�������ö ���ҹ��˹���: %i.", rankid);
		return ShowFactionConfig(playerid);
	}
	return 1;
}

Dialog:DIALOG_FACTION_TYPE(playerid, response, listitem, inputtext[])
{
	if(!response)
		return ShowFactionConfig(playerid);
	
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
				FactionInfo[PlayerSelectFac[playerid]][eFactionType] = 1;
				FactionInfo[PlayerSelectFac[playerid]][eFactionJob] = 0;
				SendClientMessageEx(playerid, -1, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF}�س������¹������࿤��� �ͧ {FFEB3B}%s {FFFFFF}�� '��' ���ǵ͹���", FactionInfo[PlayerSelectFac[playerid]][eFactionName]);
				SaveFaction(PlayerSelectFac[playerid]);
			}
			case 1:
			{
				FactionInfo[PlayerSelectFac[playerid]][eFactionType] = 2;
				SendClientMessageEx(playerid, -1, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF}�س������¹������࿤��� �ͧ {FFEB3B}%s {FFFFFF}�� '�Ѱ���' ���ǵ͹���", FactionInfo[PlayerSelectFac[playerid]][eFactionName]);
				SaveFaction(PlayerSelectFac[playerid]);
			}
		}
	}
	return ShowFactionConfig(playerid);
}

Dialog:DIALOG_FACTION_JOB(playerid, response, listitem, inputtext[])
{
	if(!response)
		return ShowFactionConfig(playerid);
	
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
				FactionInfo[PlayerSelectFac[playerid]][eFactionJob] = 1;
				SendClientMessageEx(playerid, -1, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF}�س������¹�������Ҫվ࿤��� �ͧ {FFEB3B}%s {FFFFFF}�� '���Ǩ' ���ǵ͹���", FactionInfo[PlayerSelectFac[playerid]][eFactionName]);
				SaveFaction(PlayerSelectFac[playerid]);
			}
			case 1:
			{
				FactionInfo[PlayerSelectFac[playerid]][eFactionJob] = 2;
				SendClientMessageEx(playerid, -1, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF}�س������¹�������Ҫվ࿤��� �ͧ {FFEB3B}%s {FFFFFF}�� '���' ���ǵ͹���", FactionInfo[PlayerSelectFac[playerid]][eFactionName]);
				SaveFaction(PlayerSelectFac[playerid]);
			}
			case 2:
			{
				FactionInfo[PlayerSelectFac[playerid]][eFactionJob] = 3;
				SendClientMessageEx(playerid, -1, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF}�س������¹�������Ҫվ࿤��� �ͧ {FFEB3B}%s {FFFFFF}�� '��������' ���ǵ͹���", FactionInfo[PlayerSelectFac[playerid]][eFactionName]);
				SaveFaction(PlayerSelectFac[playerid]);
			}
			case 3:
			{
				FactionInfo[PlayerSelectFac[playerid]][eFactionJob] = 4;
				SendClientMessageEx(playerid, -1, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF}�س������¹�������Ҫվ࿤��� �ͧ {FFEB3B}%s {FFFFFF}�� '����Ҫ�ѳ��' ���ǵ͹���", FactionInfo[PlayerSelectFac[playerid]][eFactionName]);
				SaveFaction(PlayerSelectFac[playerid]);
			}
			case 4:
			{
				FactionInfo[PlayerSelectFac[playerid]][eFactionJob] = 5;
				SendClientMessageEx(playerid, -1, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF}�س������¹�������Ҫվ࿤��� �ͧ {FFEB3B}%s {FFFFFF}�� '�Ѱ���' ���ǵ͹���", FactionInfo[PlayerSelectFac[playerid]][eFactionName]);
				SaveFaction(PlayerSelectFac[playerid]);
			}
		}
	}
	return ShowFactionConfig(playerid);
}


new PlayerMakeleader[MAX_PLAYERS], PLayerMakeleaderFacID[MAX_PLAYERS];
Dialog:DIALOG_COM_FAC_INV(playerid, response, listitem, inputtext[])
{
	new factionid = PLayerMakeleaderFacID[playerid], str[MAX_STRING];

	if(!response)
	{
		SendClientMessageEx(PlayerMakeleader[playerid], -1, "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF}%s ����ʸ�����������˹��࿤���",ReturnRealName(playerid,0));
		return 1;
	}
	else
	{
		PlayerInfo[playerid][pFaction] = factionid;
		PlayerInfo[playerid][pFactionRank] = 1;

		if(FactionInfo[factionid][eFactionType] == GOVERMENT)
		{
			PlayerInfo[playerid][pBadge] = random(99999);
		}

		foreach (new i : Player)
		{
			if(PlayerInfo[i][pFaction] != factionid)
				continue;
			
			SendClientMessageEx(i, -1, "{2ECC71}**((%s: ��������࿤��蹢ͧ�ǡ�س����))**", ReturnRealName(playerid,0));
		}
		SendClientMessageEx(PlayerMakeleader[playerid], -1,"{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF} �س�������� %s �����˹��࿤��� �ͧ %s",ReturnRealName(playerid,0),FactionInfo[factionid][eFactionName]);

		format(str, sizeof(str), "{2196F3}FACTION {FF9800}SYSTEM:{FFFFFF} %s ��駤����� %s �����˹�ҡ����࿤��� %s", ReturnRealName(PlayerMakeleader[playerid],0), ReturnRealName(playerid,0), FactionInfo[factionid][eFactionName]);
		SendAdminMessage(4, str);

		CharacterSave(playerid);
	}
	return 1;
}


forward SpawnFaction(playerid,id);
public SpawnFaction(playerid,id)
{
    SetPlayerPos(playerid, FactionInfo[id][eFactionSpawn][0], FactionInfo[id][eFactionSpawn][1], FactionInfo[id][eFactionSpawn][2]);        
    SetPlayerVirtualWorld(playerid, FactionInfo[id][eFactionSpawnWorld]);
    SetPlayerInterior(playerid, FactionInfo[id][eFactionSpawnInt]);
    TogglePlayerControllable(playerid, 1);
	return 1;
}