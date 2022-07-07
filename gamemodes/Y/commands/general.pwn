#include <YSI_Coding\y_hooks>

new bool:PlayerHelpUp[MAX_PLAYERS];

enum F_FRISK_DATA
{
	Frisk_ID,
	Frisk_BY
}

new FriskInfo[MAX_PLAYERS][F_FRISK_DATA];

hook OnPlayerConnect(playerid)
{
	PlayerHelpUp[playerid] = false;

	FriskInfo[playerid][Frisk_ID] = INVALID_PLAYER_ID;
	FriskInfo[playerid][Frisk_BY] = INVALID_PLAYER_ID;
	SetPVarInt(playerid, "HideHud", 1);
	return 1;
}

CMD:help(playerid, params[])
{
	SendClientMessage(playerid, COLOR_DARKGREEN, "___________www.lsrplite.in.th___________");
	SendClientMessage(playerid, COLOR_GRAD2,"[ACCOUNT] /stats /levelup /myweapon /setspawn /license /fines /frisk");
	SendClientMessage(playerid, COLOR_GRAD2,"[GENERAL] /pay /time /buy /call /coin /admins /housecmds /blindfold /gps /makegps /editgps /cigarettes");
	SendClientMessage(playerid, COLOR_GRAD2,"[GENERAL] /global /bitsamphelp /setstation /boombox /clothing /buyclothing /takegun");
	SendClientMessage(playerid, COLOR_GRAD2,"[CHAT] (/s)hout /(w)hisper /(o)oc /b /pm(ooc) (/l)ocal /me /ame /do(low) /low /radiohelp(/rhelp) ");
	SendClientMessage(playerid, COLOR_GRAD1,"[HELP] /jobhelp /fishhelp  /minerhelp /stats /report /helpme /computerhelp /drughelp /meal /dropgun");
	SendClientMessage(playerid, COLOR_GRAD2,"[ANIMATION] /anim /animlist /sa(stopanimation) /walkstyle /shakehand");
	SendClientMessage(playerid, COLOR_GRAD2,"[VEHICLE] /cw");
	SendClientMessage(playerid, COLOR_GREEN,"_____________________________________");
    SendClientMessage(playerid, COLOR_GRAD1,"�ô�֡�Ҥ���������������������㹿��������� /helpme ���ͤ͢������������");
	return 1; 
}

CMD:onduty(playerid, params[])
{
	new police, medic, sadcr, taxi;

	foreach(new i : Player)
	{
		new factiontype = FactionInfo[PlayerInfo[i][pFaction]][eFactionJob];
		
		if(!PlayerInfo[i][pDuty])
			continue;

		if(factiontype == POLICE || factiontype == SHERIFF)
			police++;
		
		if(factiontype == SADCR)
			sadcr++;
			
		if(factiontype == MEDIC)
			medic++;

		if(PlayerTaxiDuty[i])
			taxi++;
		

	}
	SendClientMessageEx(playerid, -1, "On duty: %d PD/SD, %d DOC, %d LSFD, %d Taxis", police, sadcr, medic, taxi);
	return 1;
}

alias:radiohelp("rhelp")
CMD:radiohelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN,"|_____________________Radio_help______________________|");
	SendClientMessage(playerid, COLOR_YELLOW,"HINT: �س����ö�����Է��������ҹ 24/7");
	SendClientMessage(playerid, COLOR_WHITE,"/setchannel - ��駤�����");
	SendClientMessage(playerid, COLOR_WHITE,"/setslot - ��駤����ͧ�ͧ���");
	SendClientMessage(playerid, COLOR_WHITE,"/r - �ٴ�Է��");
	SendClientMessage(playerid, COLOR_WHITE,"/rlow - �ٴ�Է��Ẻ��");
	SendClientMessage(playerid, COLOR_WHITE,"/radioon - �Դ �Դ�Է��");
	SendClientMessage(playerid, COLOR_GREEN,"|_____________________________________________________|");
	return 1;
}


CMD:logout(playerid, params[])
{
	if(gettime() - PlayerInfo[playerid][pLastDamagetime] < 120)
		return SendServerMessage(playerid, "�س���Ѻ���������");

	SendNearbyMessage(playerid, 5.5, COLOR_GREY, "%s ���͡�ҡ���� (Log-out)", ReturnRealName(playerid,0));

	new str[120];
	format(str, sizeof(str), "[%s] %s(DBID: %d) Log Out In Game", ReturnDate(),ReturnRealName(playerid,0), PlayerInfo[playerid][pDBID]);
	SendDiscordMessageEx("connecnt", str);


	/*if(PlayerInfo[playerid][pVehicleSpawned])
	{
		ResetVehicleVars(PlayerInfo[playerid][pVehicleSpawnedID]);
		DestroyVehicle(PlayerInfo[playerid][pVehicleSpawnedID]);
		
		PlayerInfo[playerid][pVehicleSpawned] = false;
		PlayerInfo[playerid][pVehicleSpawnedID] = INVALID_VEHICLE_ID;
	}*/


	CharacterSave(playerid);
	SetPlayerName(playerid, e_pAccountData[playerid][mAccName]); 
	TogglePlayerSpectating(playerid, true);

	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	SetPlayerCameraPos(playerid, 2071.6313,-1828.9207,23.3445);
	SetPlayerCameraLookAt(playerid, 2096.2373,-1794.2494,13.3889);
	

	ResetPlayerCharacter(playerid);
	new pname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pname, sizeof(pname));
	new maxname = strlen(pname);
	new query[MAX_STRING];

	for(new i=0; i<maxname; i++)
	{
		if(pname[i] == '_')
		{
			SendServerMessage(playerid, "�س����������� Username �ô�͡��������� Username �����������к�");
			return Dialog_Show(playerid, DIALOG_SET_USERNAME, DIALOG_STYLE_INPUT, "����¹������ Username ���س��ͧ���", "������ Username ���س��ͧ����������к� �ҡ�ժ��ͼ�����������Ǩй��������к�����:", "�׹�ѹ", "¡��ԡ");
		}
	}
    
	mysql_format(dbCon, query, sizeof(query), "SELECT COUNT(acc_name) FROM `masters` WHERE acc_name = '%e'", ReturnPlayerName(playerid));
	mysql_tquery(dbCon, query, "OnPlayerJoin", "d", playerid);
    SendClientMessage(playerid, -1, "�Թ�յ�͹�Ѻ������ "EMBED_YELLOW"Los Santos Roleplay LITE");
	return 1;
}


CMD:opendoor(playerid, params[])
{
	new item[16];
	if(sscanf(params, "s[32]", item)) 
	{
	  	    //SendClientMessage(playerid, COLOR_LIGHTRED, "[ ! ]"EMBED_WHITE" TIP: ������繤��Ѻ �س����ö�к�˹�ҵ�ҧ�����Դ��");
			SendClientMessage(playerid, COLOR_LIGHTRED, "�����: "EMBED_WHITE"/opendoor [dr (driver) / pa (passenger) / bl (backleft) / br (backright)]");
	}

	if(!IsPlayerInAnyVehicle(playerid) && GetNearestVehicle(playerid) != INVALID_VEHICLE_ID)
	{
		new vehicleid = GetNearestVehicle(playerid);

		if(HasNoEngine(vehicleid))
			return SendErrorMessage(playerid, "�������ö�Դ��еٷ���ҹ��˹���觹����");

		if(IsCheckBike(vehicleid))
			return SendErrorMessage(playerid, "�������ö�Դ��еٷ���ҹ��˹���觹����");

		if(strcmp(item, "driver", true) == 0 || strcmp(item, "dr", true) == 0)
		{
			SetVehicleParamsCarDoors(vehicleid, 1, -1, -1, -1);
			SendNearbyMessage(playerid, 30.0, COLOR_EMOTE, "* %s �Դ��е�ö %s", ReturnRealName(playerid), ReturnVehicleName(vehicleid));
		}
		else if(strcmp(item, "passenger", true) == 0 || strcmp(item, "pa", true) == 0)
		{
			SetVehicleParamsCarDoors(vehicleid, -1, 1, -1, -1);
			SendNearbyMessage(playerid, 30.0, COLOR_EMOTE, "* %s �Դ��е�ö %s", ReturnRealName(playerid), ReturnVehicleName(vehicleid));		
		}
		else if(strcmp(item, "backleft", true) == 0 || strcmp(item, "bl", true) == 0)
		{
			SetVehicleParamsCarDoors(vehicleid, -1, -1, 1, -1);
			SendNearbyMessage(playerid, 30.0, COLOR_EMOTE, "* %s �Դ��е�ö %s", ReturnRealName(playerid), ReturnVehicleName(vehicleid));
		}
		else if(strcmp(item, "backright", true) == 0 || strcmp(item, "br", true) == 0)
		{
			SetVehicleParamsCarDoors(vehicleid, -1, -1, -1, 1);
			SendNearbyMessage(playerid, 30.0, COLOR_EMOTE, "* %s �Դ��е�ö %s", ReturnRealName(playerid), ReturnVehicleName(vehicleid));		
		}
		else SendErrorMessage(playerid, "�Ծ�����١��ͧ����");

		return 1;
	}
	else SendErrorMessage(playerid, "�س�������������ҹ��˹�");
	return 1;
}


CMD:dropgun(playerid, params[])
{
	new weaponid;
	if(sscanf(params, "i", weaponid))
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "��÷�����ظ���¤���觹�� �з�������ظ����͡仨ҡ��������㹷ѹ��");
		SendUsageMessage(playerid, "/dropgun <�ʹ����ظ>");
		return 1;
	}

	if(GetPlayerWeapon(playerid) != weaponid)
		return SendErrorMessage(playerid, "�س��������ظ�ѧ����� (*������ظ��Դ���)");


	SendClientMessageEx(playerid, COLOR_GREY, "�س�������ظ %s �͡�ҡ�������", ReturnWeaponName(weaponid));
	SendNearbyMessage(playerid, 5.5, COLOR_EMOTE, "> %s �������ظ %s ŧ���", ReturnRealName(playerid,0), ReturnWeaponName(weaponid));
	
	new str[120];
	format(str, sizeof(str), "[%s] %s(DBID:%d) Drop %s(%d)",ReturnDate(), ReturnRealName(playerid,0), PlayerInfo[playerid][pDBID], ReturnWeaponName(weaponid), weaponid);
	SendDiscordMessageEx("weapons",str);

	RemovePlayerWeapon(playerid, weaponid);
	CharacterSave(playerid);
	return 1;
}

CMD:jobhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
	SendClientMessage(playerid, COLOR_GRAD3,"�Ҫվ㹻Ѩ�غѹ�ͧ�س:");
	SendClientMessageEx(playerid,COLOR_GRAD3,"%s", GetJobName(PlayerInfo[playerid][pCareer], PlayerInfo[playerid][pJob]));

	if(PlayerInfo[playerid][pSideJob]) {
		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
		SendClientMessage(playerid, COLOR_GRAD3,"�Ҫվ�����:");
		SendClientMessageEx(playerid,COLOR_GRAD3,"%s", GetJobName(PlayerInfo[playerid][pCareer], PlayerInfo[playerid][pSideJob]));
	}

	// �Ҫվ�����
	

	// �Ҫվ��ѡ
	if(PlayerInfo[playerid][pJob] == JOB_FARMER) {
	    SendClientMessage(playerid,COLOR_LIGHTRED,"����觢ͧ������:");
		SendClientMessage(playerid,COLOR_WHITE,"/harvest");
		SendClientMessage(playerid,COLOR_WHITE,"/stopharvest");
	}

	if(PlayerInfo[playerid][pJob] == JOB_TRUCKER) {
	    SendClientMessage(playerid,COLOR_LIGHTRED,"����觢ͧ��ѡ�ҹ�觢ͧ:");
		SendClientMessage(playerid,COLOR_WHITE,"/cargo (���ʹ٤��������ǡѺ��ѧ�Թ���)");
	}

	if(PlayerInfo[playerid][pJob] == JOB_MECHANIC)
	{
 		SendClientMessage(playerid,COLOR_LIGHTRED,"����觢ͧ��ѡ�ҹ��ҧ¹��:");
	}

	if(PlayerInfo[playerid][pJob] == JOB_MINER)
	{
 		SendClientMessage(playerid,COLOR_LIGHTRED,"����觢ͧ��ѡ�ҹ��ҧ¹��:");
		SendClientMessage(playerid,COLOR_WHITE,"/checkore (�����㹵��)");
		SendClientMessage(playerid,COLOR_WHITE,"/ptze (���ٻ)");
		SendClientMessage(playerid,COLOR_WHITE,"/sellore (������)");
		SendClientMessage(playerid,COLOR_WHITE,"/giveore (������)");
	}

	if(PlayerInfo[playerid][pJob] == JOB_ELECTRICIAN)
	{
 		SendClientMessage(playerid,COLOR_LIGHTRED,"����觢ͧ��ҧ�������俿��:");
		SendClientMessage(playerid,COLOR_WHITE,"/startele (����������ҹ)");
		SendClientMessage(playerid,COLOR_WHITE,"/getstair (�Ӻ����͡�Ҩҡ�����ҹ��ҹ�)");
		SendClientMessage(playerid,COLOR_WHITE,"/fixele (������������俿�ҷ��������ª��ش)");
	}

	return 1;
}

CMD:bitsamphelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_DARKGREEN, "___________BITSAMP : HELP___________");
	SendClientMessage(playerid, COLOR_DARKGREEN, "");
	SendClientMessage(playerid, COLOR_GRAD2,"[GENERAL] /checkbit /givebit /sellbit /buybit");
	SendClientMessage(playerid, COLOR_DARKGREEN, "");
	SendClientMessage(playerid, COLOR_DARKGREEN, "___________BITSAMP : HELP___________");
	return 1;
}

CMD:buybit(playerid, params[])
{	
	new Float:bit;
	if(sscanf(params, "f", bit))
		return SendUsageMessage(playerid, "/buybit <�ӹǹ�Ե:>");

	if(bit < 0.00001)
		return SendErrorMessage(playerid, "��س����ӹǹ �Ե���١��ͧ (*��ͧ�ҡ���� 0.00001*)");


	if(PlayerInfo[playerid][pCash] < bit * GlobalInfo[G_BITSAMP])
		return SendErrorMessage(playerid, "�س���Թ�����§��");

	if(GlobalInfo[G_BitStock] < bit)
		return SendErrorMessage(playerid, "BIT 㹵�Ҵ�š�����");
		

	SendClientMessageEx(playerid, COLOR_DARKGREEN, "�س����� BITSMAP ���§Թ�Ҩӹǹ $%s", MoneyFormat(floatround(bit * GlobalInfo[G_BITSAMP],floatround_round)));
	SendClientMessageEx(playerid, COLOR_GREY, "�س�� BITSAMP: %.5f",PlayerInfo[playerid][pBTC]);

	PlayerInfo[playerid][pBTC]+=  bit;
	GiveMoney(playerid, -floatround(bit * GlobalInfo[G_BITSAMP],floatround_round));
	GlobalInfo[G_BITSAMP] += floatround(bit * GlobalInfo[G_BITSAMP]);
	GlobalInfo[G_BitStock]-= bit;
	CharacterSave(playerid);
	Saveglobal();
	SendClientMessageToAll(COLOR_YELLOWEX, "�ա������¹�ŧ�ҧ�Ҥҵ�Ҵ");
	return 1;
}


CMD:sellbit(playerid, params[])
{
	new Float:bit;
	if(sscanf(params, "f", bit))
		return SendUsageMessage(playerid, "/sellbit <�ӹǹ�Ե:>");

	if(bit < 0.00001)
		return SendErrorMessage(playerid, "��س����ӹǹ �Ե���١��ͧ (*��ͧ�ҡ���� 0.00001*)");


	if(PlayerInfo[playerid][pBTC] < bit)
		return SendErrorMessage(playerid, "�س�պԵ�����§��");
		
	new Float:result;
	
	PlayerInfo[playerid][pBTC]-= bit;
	GlobalInfo[G_BitStock]+= bit;

	if(!GlobalInfo[G_BITSAMP])
		GlobalInfo[G_BITSAMP] = 100;	
		
	result  = GlobalInfo[G_BITSAMP] * bit;
	GlobalInfo[G_BITSAMP] -= floatround(result,floatround_round);

	GlobalInfo[G_GovCash] += floatround(result * 0.07, floatround_round);
	
	GiveMoney(playerid, floatround(result - (result * 0.07),floatround_round));
	CharacterSave(playerid);
	Saveglobal();
	SendClientMessageEx(playerid, COLOR_DARKGREEN, "�س���� BITSMAP ���Թ�Ҩӹǹ $%s", MoneyFormat(floatround(result,floatround_round)));
	SendClientMessageEx(playerid, COLOR_GREY, "�����: %.5f",PlayerInfo[playerid][pBTC]);
	SendClientMessageToAll(COLOR_YELLOWEX, "�ա������¹�ŧ�ҧ�Ҥҵ�Ҵ");
	return 1;
}


CMD:mask(playerid, params[])
{
	if(PlayerInfo[playerid][pLevel] < 3 && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "�س������ѧ���ͷ��������� Mask �� (����ŵ�ͧ�ҡ���� 3 ����)"); 
		
	if(!PlayerInfo[playerid][pHasMask] && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "�س����� Mask"); 
	
	if(!PlayerInfo[playerid][pMasked])
	{
		foreach(new i : Player)
		{
			ShowPlayerNameTagForPlayer(i, playerid, 0);
		}
		
		PlayerInfo[playerid][pMasked] = true;
		GameTextForPlayer(playerid, "~p~YOUR MASK IS NOW ON", 3000, 5); 
	}
	else
	{
		foreach(new i : Player)
		{	
			ShowPlayerNameTagForPlayer(i, playerid, 1);
		}
		
		PlayerInfo[playerid][pMasked] = false;
		GameTextForPlayer(playerid, "~p~YOUR MASK IS NOW OFF", 3000, 5); 
	}
		
	return 1;
}

CMD:gps(playerid, params[])
{
	Dialog_Show(playerid, D_GPS_LIST, DIALOG_STYLE_LIST, "GPS SYSTEM:", "[GPS GLOBAL]\n[GPS PRIVATE]", "�Թ�ѹ", "¡��ԡ");
	return 1;
}

CMD:global(playerid, params[])
{
	SendClientMessage(playerid, COLOR_DARKGREEN, "___________GLOBAL: PRICE___________");
	SendClientMessage(playerid, COLOR_DARKGREEN, "");
	SendClientMessageEx(playerid, COLOR_GRAD2, "BITSAMP %.5f: 1 �Ե�դ����ҡѺ %s ",GlobalInfo[G_BitStock], MoneyFormat(GlobalInfo[G_BITSAMP]));
	SendClientMessage(playerid, COLOR_DARKGREEN, "");
	SendClientMessage(playerid, COLOR_DARKGREEN, "___________GLOBAL: PRICE___________");
	return 1;
}

CMD:enter(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, -2706.9470,215.1062,3.8854))
		{
			if(GetPlayerInterior(playerid) != 0)
				return 1;


			new vehicleid = GetPlayerVehicleID(playerid);
			SetVehiclePos(vehicleid, -2722.9558,217.4294,4.0583);
			PutPlayerInVehicle(playerid, vehicleid, 0);
			return 1;
		}
		return 1;
	}
	for(new p = 1; p < MAX_HOUSE; p++)
	{
		if(!HouseInfo[p][HouseDBID])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[p][HouseEntrance][0], HouseInfo[p][HouseEntrance][1], HouseInfo[p][HouseEntrance][2]))
		{
			if(GetPlayerVirtualWorld(playerid) != HouseInfo[p][HouseEntranceWorld])
				continue;
					
			if(GetPlayerInterior(playerid) != HouseInfo[p][HouseEntranceInterior])
				continue;

			if(HouseInfo[p][HouseLock] == true)
				return GameTextForPlayer(playerid, "~r~Locked", 3000, 1);

			if(!HouseInfo[p][HouseInterior][0] || !HouseInfo[p][HouseInterior][1] || !HouseInfo[p][HouseInterior][2])
				return GameTextForPlayer(playerid, "~r~Close", 3000, 1);

			PlayerInfo[playerid][pInsideProperty] = p;

			SetPlayerPos(playerid, HouseInfo[p][HouseInterior][0], HouseInfo[p][HouseInterior][1], HouseInfo[p][HouseInterior][2] - 3);
			
			SetPlayerVirtualWorld(playerid, HouseInfo[p][HouseInteriorWorld]);
			SetPlayerInterior(playerid, HouseInfo[p][HouseInteriorID]);
			
			TogglePlayerControllable(playerid, 0);
			SetTimerEx("OnPlayerEnterProperty", 2000, false, "ii", playerid, p); 

			if(HouseInfo[p][HouseMusic])
			{
				StopAudioStreamForPlayer(playerid);
				PlayAudioStreamForPlayer(playerid, HouseInfo[p][HouseMusicLink]);
			}
		}

	}
	for(new b = 1; b < MAX_BUSINESS; b++)
	{
		if(!BusinessInfo[b][BusinessDBID])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[b][BusinessEntrance][0], BusinessInfo[b][BusinessEntrance][1], BusinessInfo[b][BusinessEntrance][2]))
		{
			if(GetPlayerInterior(playerid) != BusinessInfo[b][BusinessEntranceWorld])
				continue;
					
			if(GetPlayerVirtualWorld(playerid) != BusinessInfo[b][BusinessEntranceInterior])
				continue;

			if(GetPlayerMoney(playerid) < BusinessInfo[b][BusinessEntrancePrice])
				return GameTextForPlayer(playerid, "~r~You don't have money", 3000, 1);

			if(!BusinessInfo[b][BusinessInterior][0] || !BusinessInfo[b][BusinessInterior][1] || !BusinessInfo[b][BusinessInterior][2] || BusinessInfo[b][BusinessType] == BUSINESS_TYPE_DEALERVEHICLE)
				return GameTextForPlayer(playerid, "~r~Close", 3000, 1);

			if(BusinessInfo[b][BusinessLock] == true && !PlayerInfo[playerid][pAdminDuty] && BusinessInfo[b][BusinessOwnerDBID] != PlayerInfo[playerid][pDBID])
				return GameTextForPlayer(playerid, "~r~Lock", 3000, 1);


			PlayerInfo[playerid][pInsideBusiness] = b;

			SetPlayerPos(playerid, BusinessInfo[b][BusinessInterior][0], BusinessInfo[b][BusinessInterior][1], BusinessInfo[b][BusinessInterior][2] - 3);
			SetPlayerVirtualWorld(playerid, BusinessInfo[b][BusinessInteriorWorld]);
			SetPlayerInterior(playerid, BusinessInfo[b][BusinessInteriorID]);

			GiveMoney(playerid, -BusinessInfo[b][BusinessEntrancePrice]);
			BusinessInfo[b][BusinessCash] += BusinessInfo[b][BusinessEntrancePrice];

			TogglePlayerControllable(playerid, 0);
			SetTimerEx("OnPlayerEnterBusiness", 2000, false, "ii", playerid, b); 

			if(BusinessInfo[b][BusinessMusic])
			{
				StopAudioStreamForPlayer(playerid);
				PlayAudioStreamForPlayer(playerid,  BusinessInfo[b][BusinessMusicLink]);
			}
			SendBusinessType(playerid, b);
		}
	}
	for(new e = 1; e < MAX_ENTRANCE; e++)
	{
		if(!EntranceInfo[e][EntranceDBID])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 3.0, EntranceInfo[e][EntranceLoc][0], EntranceInfo[e][EntranceLoc][1], EntranceInfo[e][EntranceLoc][2]))
		{
			if(GetPlayerInterior(playerid) != EntranceInfo[e][EntranceLocInID])
				continue;
					
			if(GetPlayerVirtualWorld(playerid) != EntranceInfo[e][EntranceLocWorld])
				continue;

			if(!EntranceInfo[e][EntranceLocIn][0] || !EntranceInfo[e][EntranceLocIn][1] || !EntranceInfo[e][EntranceLocIn][2])
				return GameTextForPlayer(playerid, "~r~Close", 3000, 1);

			TogglePlayerControllable(playerid, 0);
			SetPlayerPos(playerid, EntranceInfo[e][EntranceLocIn][0], EntranceInfo[e][EntranceLocIn][1], EntranceInfo[e][EntranceLocIn][2] - 3);
			SetPlayerVirtualWorld(playerid, EntranceInfo[e][EntanceLocInWorld]);
			SetPlayerInterior(playerid, EntranceInfo[e][EntranceLocInInID]);
			SetTimerEx("OnPlayerEnter", 2000, false, "ii", playerid, e);

			return 1;
		}
	}

	return 1;
}

CMD:door(playerid, params[])
{
	return 1;
}

CMD:ram(playerid,params[])
{
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�����˹��§ҹ�Ѱ���"); 

	new bool:checked = false;
	for(new p = 1; p < MAX_HOUSE; p++)
	{
		if(!HouseInfo[p][HouseDBID])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[p][HouseEntrance][0], HouseInfo[p][HouseEntrance][1], HouseInfo[p][HouseEntrance][2]))
		{
			if(GetPlayerVirtualWorld(playerid) != HouseInfo[p][HouseEntranceWorld])
				continue;
					
			if(GetPlayerInterior(playerid) != HouseInfo[p][HouseEntranceInterior])
				continue;

			if(!HouseInfo[p][HouseInterior][0] || !HouseInfo[p][HouseInterior][1] || !HouseInfo[p][HouseInterior][2])
				return GameTextForPlayer(playerid, "~r~Close", 3000, 1);

			PlayerInfo[playerid][pInsideProperty] = p;
			HouseInfo[p][HouseLock] = false;

			SetPlayerPos(playerid, HouseInfo[p][HouseInterior][0], HouseInfo[p][HouseInterior][1], HouseInfo[p][HouseInterior][2] - 3);
			
			SetPlayerVirtualWorld(playerid, HouseInfo[p][HouseInteriorWorld]);
			SetPlayerInterior(playerid, HouseInfo[p][HouseInteriorID]);
			
			TogglePlayerControllable(playerid, 0);
			SetTimerEx("OnPlayerEnterProperty", 2000, false, "ii", playerid, p); 

			if(HouseInfo[p][HouseMusic])
			{
				StopAudioStreamForPlayer(playerid);
				PlayAudioStreamForPlayer(playerid, HouseInfo[p][HouseMusicLink]);
			}
		}
		else checked = true;

	}

	if(checked) return SendErrorMessage(playerid, "�س�������������ҹ");

	return 1;
}


CMD:exit(playerid, params[])
{
	new 
		id = PlayerInfo[playerid][pInsideProperty],
		b_id = PlayerInfo[playerid][pInsideBusiness]
	;

	if(id != 0)
	{
        if(!IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[id][HouseInterior][0], HouseInfo[id][HouseInterior][1], HouseInfo[id][HouseInterior][2]))
			return SendErrorMessage(playerid, "�س�������������еٷҧ�͡");
		
		SetPlayerPos(playerid, HouseInfo[id][HouseEntrance][0], HouseInfo[id][HouseEntrance][1], HouseInfo[id][HouseEntrance][2]);
		
		SetPlayerVirtualWorld(playerid, HouseInfo[id][HouseEntranceWorld]);
		SetPlayerInterior(playerid, HouseInfo[id][HouseEntranceInterior]);
		PlayerInfo[playerid][pInsideProperty] = 0;
		PlayerTextDrawHide(playerid, PlayerSwicthOff[playerid][0]);
		StopAudioStreamForPlayer(playerid);
		return 1;
    }
	if(b_id != 0)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[b_id][BusinessInterior][0], BusinessInfo[b_id][BusinessInterior][1], BusinessInfo[b_id][BusinessInterior][2]))
			return SendErrorMessage(playerid, "�س�������������еٷҧ�͡");

		if(BusinessInfo[b_id][BusinessType] == BUSINESS_TYPE_RESTAURANT || BusinessInfo[b_id][BusinessType] == BUSINESS_TYPE_STORE)
		{
			if(PlayerInfo[playerid][pGUI] == 5)
			{
				for(new f = 0; f < 8; f++)
				{
					PlayerTextDrawDestroy(playerid, BuyFood[playerid][f]);
				}
				PlayerInfo[playerid][pGUI] = 0;
				CancelSelectTextDraw(playerid);
			}
			if(PlayerInfo[playerid][pGUI] == 6)
			{
				MenuStore_Close(playerid);
				PlayerInfo[playerid][pGUI] = 0;
			}
		}


		StopAudioStreamForPlayer(playerid);
		
		SetPlayerPos(playerid, BusinessInfo[b_id][BusinessEntrance][0], BusinessInfo[b_id][BusinessEntrance][1], BusinessInfo[b_id][BusinessEntrance][2]);
		SetPlayerVirtualWorld(playerid, BusinessInfo[b_id][BusinessEntranceWorld]);
		SetPlayerInterior(playerid, BusinessInfo[b_id][BusinessEntranceInterior]);
		PlayerInfo[playerid][pInsideBusiness] = 0;

		return 1;
	}
	for(new e = 1; e < MAX_ENTRANCE; e++)
	{
		if(!EntranceInfo[e][EntranceDBID])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 3.0, EntranceInfo[e][EntranceLocIn][0], EntranceInfo[e][EntranceLocIn][1], EntranceInfo[e][EntranceLocIn][2]))
		{
			if(GetPlayerInterior(playerid) != EntranceInfo[e][EntranceLocInInID])
				continue;
					
			if(GetPlayerVirtualWorld(playerid) != EntranceInfo[e][EntanceLocInWorld])
				continue;

			if(EntranceInfo[e][EntranceLocWorld] != 0)
			{
				TogglePlayerControllable(playerid, 0);
				SetPlayerPos(playerid, EntranceInfo[e][EntranceLoc][0], EntranceInfo[e][EntranceLoc][1], EntranceInfo[e][EntranceLoc][2]-3);
				SetTimerEx("OnPlayerExit", 2000, false, "ii", playerid, e);
				return 1;
			}
			//else SetPlayerPos(playerid, EntranceInfo[e][EntranceLoc][0], EntranceInfo[e][EntranceLoc][1], EntranceInfo[e][EntranceLoc][2]);

			SetPlayerPos(playerid, EntranceInfo[e][EntranceLoc][0], EntranceInfo[e][EntranceLoc][1], EntranceInfo[e][EntranceLoc][2]);
			SetPlayerVirtualWorld(playerid, EntranceInfo[e][EntranceLocInID]);
			SetPlayerInterior(playerid, EntranceInfo[e][EntranceLocWorld]);

			return 1;
		}
	}
	return 1;
}

alias:stopanimation("sa", "stopanim")
CMD:stopanimation(playerid, params[])
{
	if(PlayerInfo[playerid][pHandcuffed])
	{
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
    	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CUFFED);
		return 1;
	}

	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	PlayerInfo[playerid][pAnimation] = 0;
	return 1;
}


CMD:lock(playerid,params[])
{
	if(PlayerInfo[playerid][pInsideProperty])
	{
		new id = PlayerInfo[playerid][pInsideProperty];

		if(HouseInfo[id][HouseOwnerDBID] != PlayerInfo[playerid][pDBID] && PlayerInfo[playerid][pDBID] != HouseInfo[id][HouseRent] && PlayerInfo[playerid][pHouseKey] != id)
			return SendErrorMessage(playerid,"�س�������Ңͧ��ҹ��ѧ���");

		
		if(HouseInfo[id][HouseLock])
		{
			GameTextForPlayer(playerid, "~w~DOOR ~g~UNLOCKED", 1000, 6);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			HouseInfo[id][HouseLock] = false;
		}
		else
		{
			GameTextForPlayer(playerid, "~w~DOOR ~r~LOCKED", 1000, 6);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			HouseInfo[id][HouseLock] = true;
		}
		return 1;
	}
	else if(IsPlayerNearHouse(playerid) != 0)
	{
		new id = IsPlayerNearHouse(playerid);

		if(HouseInfo[id][HouseOwnerDBID] != PlayerInfo[playerid][pDBID] && !PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pDBID] != HouseInfo[id][HouseRent] && PlayerInfo[playerid][pHouseKey] != id)
			return SendErrorMessage(playerid,"�س�������Ңͧ��ҹ��ѧ���");

		if(HouseInfo[id][HouseLock])
		{
			GameTextForPlayer(playerid, "~w~DOOR ~g~UNLOCKED", 1000, 6);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			HouseInfo[id][HouseLock] = false;
		}
		else
		{
			GameTextForPlayer(playerid, "~w~DOOR ~r~LOCKED", 1000, 6);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			HouseInfo[id][HouseLock] = true;
		}
		return 1;
	}
	else if(PlayerInfo[playerid][pInsideBusiness])
	{
		new id = PlayerInfo[playerid][pInsideBusiness];

		if(BusinessInfo[id][BusinessOwnerDBID] !=  PlayerInfo[playerid][pDBID] && !PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pBusinessKey] != BusinessInfo[id][BusinessOwnerDBID])
			return SendErrorMessage(playerid,"�س�������Ңͧ�Ԩ��ù��");

		if(BusinessInfo[id][BusinessLock] == true)
		{
			GameTextForPlayer(playerid, "~w~DOOR ~g~UNLOCKED", 1000, 6);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			BusinessInfo[id][BusinessLock] = false;
		}
		else
		{
			GameTextForPlayer(playerid, "~w~DOOR ~r~LOCKED", 1000, 6);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			BusinessInfo[id][BusinessLock] = true;
		}

		return 1;
	}
	else if(IsPlayerNearBusiness(playerid) != 0)
	{
		new id = IsPlayerNearBusiness(playerid);

		if(BusinessInfo[id][BusinessOwnerDBID] !=  PlayerInfo[playerid][pDBID] && !PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pBusinessKey] != BusinessInfo[id][BusinessOwnerDBID])
			return SendErrorMessage(playerid,"�س�������Ңͧ�Ԩ��ù��");

		if(BusinessInfo[id][BusinessLock] == true)
		{
			GameTextForPlayer(playerid, "~w~DOOR ~g~UNLOCKED", 1000, 6);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			BusinessInfo[id][BusinessLock] = false;
		}
		else
		{
			GameTextForPlayer(playerid, "~w~DOOR ~r~LOCKED", 1000, 6);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			BusinessInfo[id][BusinessLock] = true;
		}
		return 1;

	}
	else if(!IsPlayerInAnyVehicle(playerid))
	{
		new bool:foundCar = false, vehicleid, Float:fetchPos[3];

		for (new i = 0; i < MAX_VEHICLES; i++)
		{
			GetVehiclePos(i, fetchPos[0], fetchPos[1], fetchPos[2]);
			if(IsPlayerInRangeOfPoint(playerid, 2.0, fetchPos[0], fetchPos[1], fetchPos[2]))
			{
				foundCar = true;
				vehicleid = i; 
				break; 
			}
		}

		if(foundCar == true)
		{
			if(CheckPlayeyKey(playerid, vehicleid))
			{
				if(IsElecVehicle(vehicleid))
					return SendErrorMessage(playerid, "�������ö�ѧ�ҹ��˹Фѹ�������");

				if(VehicleInfo[vehicleid][eVehicleAdminSpawn])
					return SendErrorMessage(playerid, "�������ö�ѧ�ҹ��˹Фѹ�������");

				if(VehicleInfo[vehicleid][eVehicleFaction] > 0)
				{
					if(VehicleInfo[vehicleid][eVehicleFaction] != PlayerInfo[playerid][pFaction])
						return SendErrorMessage(playerid, "�������ö�ѧ�ҹ��˹Фѹ�������");	
				}

				if (!isnull(params) && !strcmp(params, "breakin", true)) 
				{
			
					SendClientMessage(playerid, COLOR_WHITE, "�س����ö������ѧ��е���㹢�й��! �Ը�㹡�þѧ:");
					SendClientMessage(playerid, COLOR_WHITE, "-�ӻ��");
					SendClientMessage(playerid, COLOR_WHITE, "-���ظ���л�ЪԴ");

					VehicleInfo[vehicleid][eVedhicleBreaktime] = 20;

					new str[65];
					format(str, sizeof(str), "���ѧ���Թ��þѧ�ҹ��˹� %d",VehicleInfo[vehicleid][eVedhicleBreaktime]);

					VehicleInfo[vehicleid][eVehicleBreakUI] = Create3DTextLabel(str, COLOR_WHITE, 0.0, 0.0, 0.0, 25.0, GetPlayerVirtualWorld(playerid), 0); 
					Attach3DTextLabelToVehicle(VehicleInfo[vehicleid][eVehicleBreakUI], vehicleid, -0.7, -1.9, -0.3); 
					VehicleInfo[vehicleid][eVehicleBreak] = true;
					return 1;
				}
				else return SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: �ҡ�س���������оѧ����: "EMBED_YELLOW"\"/lock "EMBED_WHITE"breakin"EMBED_YELLOW"\"");

			}

			new statusString[90]; 
			new engine, lights, alarm, doors, bonnet, boot, objective; 
			
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
					
			if(VehicleInfo[vehicleid][eVehicleLocked])
			{
				if(VehicleInfo[vehicleid][eVehicleBreak])
				{
					VehicleInfo[vehicleid][eVehicleBreak] = false;
					VehicleInfo[vehicleid][eVedhicleBreaktime] = 0;

					if(IsValidDynamic3DTextLabel(VehicleInfo[vehicleid][eVehicleBreakUI]))
						Delete3DTextLabel(VehicleInfo[vehicleid][eVehicleBreakUI]); 
				}
				format(statusString, sizeof(statusString), "~g~%s UNLOCKED", ReturnVehicleName(vehicleid));
					
				SetVehicleParamsEx(vehicleid, engine, lights, alarm, false, bonnet, boot, objective);
				VehicleInfo[vehicleid][eVehicleLocked] = false;
			}
			else 
			{
				if(VehicleInfo[vehicleid][eVehicleBreak])
				{
					VehicleInfo[vehicleid][eVehicleBreak] = false;
					VehicleInfo[vehicleid][eVedhicleBreaktime] = 0;

					if(IsValidDynamic3DTextLabel(VehicleInfo[vehicleid][eVehicleBreakUI]))
						Delete3DTextLabel(VehicleInfo[vehicleid][eVehicleBreakUI]); 
				}

				format(statusString, sizeof(statusString), "~r~%s LOCKED", ReturnVehicleName(vehicleid));
						
				SetVehicleParamsEx(vehicleid, engine, lights, alarm, true, bonnet, boot, objective);
				VehicleInfo[vehicleid][eVehicleLocked] = true;
			}
			GameTextForPlayer(playerid, statusString, 3000, 3);
		}
		else SendErrorMessage(playerid,"�س�������������е� ��ҹ/�Ԩ���/ö");
		return 1;
	}
	else if(IsPlayerInAnyVehicle(playerid))
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		
		if(CheckPlayeyKey(playerid, vehicleid))
			return SendErrorMessage(playerid, "�س����աح�����Ѻö�ѹ���");

		if(IsElecVehicle(vehicleid))
			return SendErrorMessage(playerid, "�������ö�ѧ�ҹ��˹Фѹ�������");

		new statusString[90]; 
		new engine, lights, alarm, doors, bonnet, boot, objective; 
		
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
				
		if(VehicleInfo[vehicleid][eVehicleLocked])
		{
			if(VehicleInfo[vehicleid][eVehicleBreak])
			{
				VehicleInfo[vehicleid][eVehicleBreak] = false;
				VehicleInfo[vehicleid][eVedhicleBreaktime] = 0;

				if(IsValidDynamic3DTextLabel(VehicleInfo[vehicleid][eVehicleBreakUI]))
					Delete3DTextLabel(VehicleInfo[vehicleid][eVehicleBreakUI]); 
			}

			format(statusString, sizeof(statusString), "~g~%s UNLOCKED", ReturnVehicleName(vehicleid));
				
			SetVehicleParamsEx(vehicleid, engine, lights, alarm, false, bonnet, boot, objective);
			VehicleInfo[vehicleid][eVehicleLocked] = false;
		}
		else 
		{
			if(VehicleInfo[vehicleid][eVehicleBreak])
			{
				VehicleInfo[vehicleid][eVehicleBreak] = false;
				VehicleInfo[vehicleid][eVedhicleBreaktime] = 0;

				if(IsValidDynamic3DTextLabel(VehicleInfo[vehicleid][eVehicleBreakUI]))
					Delete3DTextLabel(VehicleInfo[vehicleid][eVehicleBreakUI]); 
			}

			format(statusString, sizeof(statusString), "~r~%s LOCKED", ReturnVehicleName(vehicleid));
					
			SetVehicleParamsEx(vehicleid, engine, lights, alarm, true, bonnet, boot, objective);
			VehicleInfo[vehicleid][eVehicleLocked] = true;
		}
		GameTextForPlayer(playerid, statusString, 3000, 3);
		return 1;
	}
	else SendErrorMessage(playerid,"�س�������������е� ��ҹ/�Ԩ���/ö");
	return 1;
}


CMD:mypos(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:a;

	if(IsPlayerInAnyVehicle(playerid))
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		GetVehiclePos(vehicleid,  x, y, z);
		GetVehicleZAngle(vehicleid, a);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle_Pos: %.3f %.3f %.3f %.3f", x, y, z, a);
		SendClientMessageEx(playerid, COLOR_WHITE, "World: %d", GetVehicleVirtualWorld(vehicleid));
		SendClientMessageEx(playerid, COLOR_WHITE, "Interior: %d", GetPlayerInterior(playerid));
		return 1;
	}
	else
	{
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		SendClientMessageEx(playerid, COLOR_WHITE, "POS: %.3f %.3f %.3f %.3f", x, y, z, a);
		SendClientMessageEx(playerid, COLOR_WHITE, "World: %d", GetPlayerVirtualWorld(playerid));
		SendClientMessageEx(playerid, COLOR_WHITE, "Interior: %d", GetPlayerInterior(playerid));
	}
	return 1;
}


CMD:check(playerid,params[])
{
	new
		Float: x,
		Float: y,
		Float: z,
		principal_str[256]
	;

	if(!IsPlayerInAnyVehicle(playerid) && GetNearestVehicle(playerid) != INVALID_VEHICLE_ID)
	{
		GetVehicleBoot(GetNearestVehicle(playerid), x, y, z);

		new 
			vehicleid = GetNearestVehicle(playerid)
		;

		if(HasNoEngine(vehicleid))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "�ҹ��˹��������ö�红ͧ��");

		if(IsCheckBike(vehicleid))
			return SendErrorMessage(playerid, "�������ö�����觹��Ѻ�ҹ��˹з���� ������䫵���"); 

		if(!VehicleInfo[vehicleid][eVehicleDBID] && VehicleInfo[vehicleid][eVehicleAdminSpawn])
			return SendServerMessage(playerid, "ö�ѹ�����ö��ǹ�ؤ���������ö������ /check ��");

		if(!IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z))
			return SendErrorMessage(playerid, "�س������������ç����ö");

		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

		if(!boot)
			return SendClientMessage(playerid, COLOR_YELLOWEX, "����ç����ö�ѧ�����١�Դ");
		
		for(new i = 1; i < 6; i++)
		{
			if(VehicleInfo[vehicleid][eVehicleWeapons][i])
				format(principal_str, sizeof(principal_str), "%s%i. %s[����ع: %i]\n", principal_str, i, ReturnWeaponName(VehicleInfo[vehicleid][eVehicleWeapons][i]), VehicleInfo[vehicleid][eVehicleWeaponsAmmo][i]);
				
			else
				format(principal_str, sizeof(principal_str), "%s%i. [��ҧ����]\n", principal_str, i);
		}
		Dialog_Show(playerid, DIALOG_DEFAULT, DIALOG_STYLE_LIST, "Trunk:", principal_str, "��ŧ", "<<");
	}
	else if(IsPlayerInAnyVehicle(playerid))
	{
		new
			vehicleid = GetPlayerVehicleID(playerid)
		;

		if(!VehicleInfo[vehicleid][eVehicleDBID] && !VehicleInfo[vehicleid][eVehicleAdminSpawn])
			return SendServerMessage(playerid, "ö�ѹ�����ö��ǹ�ؤ���������ö�����觹����");
		
		for(new i = 1; i < 6; i++)
		{
			if(VehicleInfo[vehicleid][eVehicleWeapons][i])
				format(principal_str, sizeof(principal_str), "%s%i. %s[����ع: %i]\n", principal_str, i, ReturnWeaponName(VehicleInfo[vehicleid][eVehicleWeapons][i]), VehicleInfo[vehicleid][eVehicleWeaponsAmmo][i]);
				
			else
				format(principal_str, sizeof(principal_str), "%s%i. [��ҧ����]\n", principal_str, i);
		}
			 
		Dialog_Show(playerid, DIALOG_DEFAULT, DIALOG_STYLE_LIST, "Trunk:", principal_str, "��ŧ", "<<");
	}
	else if(PlayerInfo[playerid][pInsideProperty])
	{
		new
			id = PlayerInfo[playerid][pInsideProperty],
			longstr[600]
		;
		
		if(!IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[id][HousePlacePos][0], HouseInfo[id][HousePlacePos][1], HouseInfo[id][HousePlacePos][2]))
			return SendErrorMessage(playerid, "�س������������ش���૿");
			
		for(new i = 1; i < 22; i++)
		{
			if(!HouseInfo[id][HouseWeapons][i])
				format(longstr, sizeof(longstr), "%s%d. [��ҧ����]\n", longstr, i);
				
			else format(longstr, sizeof(longstr), "%s%d. %s[����ع: %d]\n", longstr, i, ReturnWeaponName(HouseInfo[id][HouseWeapons][i]), HouseInfo[id][HouseWeaponsAmmo][i]); 
		}
		
		Dialog_Show(playerid, DIALOG_DEFAULT, DIALOG_STYLE_LIST, "Weapons:", longstr, "��ŧ", "¡��ԡ");		
	}
	else SendErrorMessage(playerid, "�س�������ö��������㹢�й��");
	return 1;
}

CMD:place(playerid, params[])
{

	new
		Float: x,
		Float: y,
		Float: z,
		str[128],
		weaponid,
		idx
	;

	if(sscanf(params, "i", weaponid))
		return SendUsageMessage(playerid, "/place [�ʹ����ظ]");

	if(weaponid < 1 || weaponid > 46 || weaponid == 35 || weaponid == 36 || weaponid == 37 || weaponid == 38 || weaponid == 39)
	    return SendErrorMessage(playerid, "���ظ����ҹ��١�Ѵ�����ظ��ͧ���������׿�����");


	if(GetPlayerWeapon(playerid) != weaponid)
		return SendErrorMessage(playerid, "�س����������ظ���");

	if(!IsPlayerInAnyVehicle(playerid) && GetNearestVehicle(playerid) != INVALID_VEHICLE_ID)
	{
		GetVehicleBoot(GetNearestVehicle(playerid), x, y, z); 
		
		new 
			vehicleid = GetNearestVehicle(playerid)
		;

		if(HasNoEngine(vehicleid))
			return SendErrorMessage(playerid, "�������ö�����觹��Ѻ�ҹ��˹з����������ͧ¹����");

		if(IsCheckBike(vehicleid))
			return SendErrorMessage(playerid, "�������ö�����觹��Ѻ�ҹ��˹з���� ������䫵���");

		if(VehicleInfo[vehicleid][eVehicleFaction])
		{
			new factionid = VehicleInfo[vehicleid][eVehicleFaction];
			
			if(FactionInfo[factionid][eFactionJob] != POLICE && FactionInfo[factionid][eFactionJob] != SHERIFF)
				return SendErrorMessage(playerid, "�����������������..");
			
			if(PlayerInfo[playerid][pFaction] != factionid)
				return SendErrorMessage(playerid, "�س�������ö�����觹��Ѻ�ҹ��˹�ῤ��������");
			
			if(GetPlayerWeapon(playerid) != weaponid)
				return SendErrorMessage(playerid, "�س���������ظ���س���͡");

			RemovePlayerWeapon(playerid, weaponid);
		
			format(str, sizeof(str), "* %s ���ҧ %s ŧ��ö %s.", ReturnName(playerid, 0), ReturnWeaponName(weaponid), ReturnVehicleName(vehicleid));
			SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4000);
			SendClientMessage(playerid, COLOR_EMOTE, str);
			return 1;
		}

		/*if(!PlayerHasWeapon(playerid, weaponid))
			return SendErrorMessage(playerid, "�س��������ظ�ѧ�����");*/

		if(VehicleInfo[vehicleid][eVehicleFaction])
			return SendClientMessage(playerid, COLOR_YELLOW, "ö�ѹ�����ö�ͧ࿤����������ö�����觹����");
		
		if(!IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z))
			return SendErrorMessage(playerid, "�س������������ҡ���ç����ö");
 
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		
		if(!boot)
			return SendClientMessage(playerid, COLOR_YELLOWEX, "�س������Դ�ҡ���ç����ö"); 
			
		for(new i = 1; i < 6; i++)
		{
			if(!VehicleInfo[vehicleid][eVehicleWeapons][i])
			{
				idx = i;
				break;
			}
		}
		
		VehicleInfo[vehicleid][eVehicleWeapons][idx] = weaponid; 
		VehicleInfo[vehicleid][eVehicleWeaponsAmmo][idx] = GetPlayerAmmo(playerid);

		PlayerInfo[playerid][pGunAmmo][ReturnWeaponIDSlot(weaponid)] = 0;
		PlayerInfo[playerid][pGun][ReturnWeaponIDSlot(weaponid)] = 0;

		PlayerInfo[playerid][pWeapons][g_aWeaponSlots[weaponid]] = 0;
		PlayerInfo[playerid][pWeaponsAmmo][g_aWeaponSlots[weaponid]] = 0;
		
		RemovePlayerWeapon(playerid, weaponid);
		
		format(str, sizeof(str), "* %s ���ҧ %s ŧ��ö %s.", ReturnName(playerid, 0), ReturnWeaponName(weaponid), ReturnVehicleName(vehicleid));
		SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4000);

		format(str, sizeof(str), "[%s] %s place weapon incar %s(%d) %s(%d) Ammo: %d", ReturnDate(), ReturnRealName(playerid,0), ReturnVehicleName(vehicleid),VehicleInfo[vehicleid][eVehicleDBID],ReturnWeaponName(weaponid),weaponid,VehicleInfo[vehicleid][eVehicleWeaponsAmmo][idx]);
		SendDiscordMessageEx("weapons", str);
		SaveVehicle(vehicleid); 
	}
	else if(IsPlayerInAnyVehicle(playerid))
	{
		new 
			vehicleid = GetPlayerVehicleID(playerid)
		;
		
		if(VehicleInfo[vehicleid][eVehicleFaction])
			return SendClientMessage(playerid, COLOR_YELLOW, "ö�ѹ�����ö�ͧ࿤����������ö�����觹����");
			
		for(new i = 1; i < 6; i++)
		{
			if(!VehicleInfo[vehicleid][eVehicleWeapons][i])
			{
				idx = i;
				break;
			}
		}

		/*if(!PlayerHasWeapon(playerid, weaponid))
			return SendErrorMessage(playerid, "�س��������ظ�ѧ�����");*/
		
		VehicleInfo[vehicleid][eVehicleWeapons][idx] = weaponid; 
		VehicleInfo[vehicleid][eVehicleWeaponsAmmo][idx] = PlayerInfo[playerid][pGunAmmo][ReturnWeaponIDSlot(weaponid)];

		PlayerInfo[playerid][pGunAmmo][ReturnWeaponIDSlot(weaponid)] = 0;
		PlayerInfo[playerid][pGun][ReturnWeaponIDSlot(weaponid)] = 0;

		PlayerInfo[playerid][pWeapons][g_aWeaponSlots[weaponid]] = 0;
		PlayerInfo[playerid][pWeaponsAmmo][g_aWeaponSlots[weaponid]] = 0;
		
		RemovePlayerWeapon(playerid, weaponid);
		
		format(str, sizeof(str), "* %s ���ҧ %s ŧ��ö %s.", ReturnName(playerid, 0), ReturnWeaponName(weaponid), ReturnVehicleName(vehicleid));
		SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4000); 
		SendClientMessage(playerid, COLOR_EMOTE, str);

		format(str, sizeof(str), "[%s] %s place weapon incar %s(%d) %s(%d) Ammo: %d", ReturnDate(), ReturnRealName(playerid,0), ReturnVehicleName(vehicleid),VehicleInfo[vehicleid][eVehicleDBID],ReturnWeaponName(weaponid),weaponid,VehicleInfo[vehicleid][eVehicleWeaponsAmmo][idx]);
		SendDiscordMessageEx("weapons", str);
		SaveVehicle(vehicleid); 
	}
	else if(IsPlayerInHouse(playerid) != 0)
	{
		new
			id = IsPlayerInHouse(playerid),
			pid
		;

		if(!IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[id][HousePlacePos][0], HouseInfo[id][HousePlacePos][1], HouseInfo[id][HousePlacePos][2]))
			return SendErrorMessage(playerid, "�س������������ش���૿");

		for(new i = 1; i < 22; i++)
		{
			if(!HouseInfo[id][HouseWeapons][i])
			{
				pid = i;
				break;
			}
		}

		/*if(!PlayerHasWeapon(playerid, weaponid))
			return SendErrorMessage(playerid, "�س��������ظ�ѧ�����");*/

		HouseInfo[id][HouseWeapons][pid] = weaponid;
		HouseInfo[id][HouseWeaponsAmmo][pid] = PlayerInfo[playerid][pGunAmmo][ReturnWeaponIDSlot(weaponid)];

		PlayerInfo[playerid][pGunAmmo][ReturnWeaponIDSlot(weaponid)] = 0;
		PlayerInfo[playerid][pGun][ReturnWeaponIDSlot(weaponid)] = 0;

		PlayerInfo[playerid][pWeapons][g_aWeaponSlots[weaponid]] = 0;
		PlayerInfo[playerid][pWeaponsAmmo][g_aWeaponSlots[weaponid]] = 0;

		RemovePlayerWeapon(playerid, weaponid);

		format(str, sizeof(str), "* %s ���ҧ %s ���㹵��૿", ReturnName(playerid, 0), ReturnWeaponName(weaponid));
		SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4000); 
		SendClientMessage(playerid, COLOR_EMOTE, str);

		format(str, sizeof(str), "[%s] %s place in house(%d) %s(%d) Ammo: %d", ReturnDate(), ReturnRealName(playerid,0), id,ReturnWeaponName(weaponid),weaponid,HouseInfo[id][HouseWeaponsAmmo][pid]);
		SendDiscordMessageEx("weapons", str);

		CharacterSave(playerid); Savehouse(id);
	}
	else SendErrorMessage(playerid, "�س������ö�����觹����㹢�й��");
	return 1;
}

CMD:takegun(playerid, params[])
{
	new slotid;

	if(IsPlayerInAnyVehicle(playerid))
	{
		new vehicleid = GetPlayerVehicleID(playerid);

		if(HasNoEngine(vehicleid))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "�ҹ��˹��������ö�红ͧ��"); 

		if(!VehicleInfo[vehicleid][eVehicleDBID] && VehicleInfo[vehicleid][eVehicleAdminSpawn] && !VehicleInfo[vehicleid][eVehicleFaction])
			return SendServerMessage(playerid, "ö�ѹ�����ö��ǹ�ؤ���������ö������ /takegun ��");


		if(sscanf(params, "i", slotid))
			return SendUsageMessage(playerid, "/takegun <1-5>");

		if(slotid < 1 || slotid > 5)
			return SendErrorMessage(playerid, "��س���� ���͵���١��ͧ");

		if(VehicleInfo[vehicleid][eVehicleFaction])
		{
			new factionid = VehicleInfo[vehicleid][eVehicleFaction];
			new modelid = GetVehicleModel(vehicleid);
			
			if(FactionInfo[factionid][eFactionJob] != POLICE && FactionInfo[factionid][eFactionJob] != SHERIFF)
				return SendErrorMessage(playerid, "�����������������..");
			
			if(PlayerInfo[playerid][pFaction] != factionid)
				return SendErrorMessage(playerid, "�س�������ö�����觹��Ѻ�ҹ��˹�ῤ��������");

			if(modelid != 596 && modelid != 598 && modelid != 599 && modelid != 490 && modelid != 528 && modelid != 427 && modelid != 597 && modelid != 426 && modelid != 560)
				return SendErrorMessage(playerid, "�����������������..");

			switch(slotid)
			{
				case 1:
				{
					new str[255];

					GivePlayerWeaponEx(playerid, 25, 100);
							
					format(str, sizeof(str), "* %s ��Ժ %s �͡�Ҩҡö %s", ReturnName(playerid, 0), ReturnWeaponName(25), 
					ReturnVehicleName(vehicleid));
								
					SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500); 
					SendClientMessage(playerid, COLOR_EMOTE, str);
				}
				case 2:
				{
					new str[255];

					GivePlayerWeaponEx(playerid, 29, 60);
							
					format(str, sizeof(str), "* %s ��Ժ %s �͡�Ҩҡö %s", ReturnName(playerid, 0), ReturnWeaponName(29), 
					ReturnVehicleName(vehicleid));
								
					SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500); 
					SendClientMessage(playerid, COLOR_EMOTE, str);
				}
				case 3:
				{
					new str[255];

					GivePlayerWeaponEx(playerid, 31, 60);
							
					format(str, sizeof(str), "* %s ��Ժ %s �͡�Ҩҡö %s", ReturnName(playerid, 0), ReturnWeaponName(31), 
					ReturnVehicleName(vehicleid));
								
					SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500); 
					SendClientMessage(playerid, COLOR_EMOTE, str);
				}
				case 4:
				{
					new str[255];

					GivePlayerWeaponEx(playerid, 34, 60);
							
					format(str, sizeof(str), "* %s ��Ժ %s �͡�Ҩҡö %s", ReturnName(playerid, 0), ReturnWeaponName(34), 
					ReturnVehicleName(vehicleid));
								
					SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500); 
					SendClientMessage(playerid, COLOR_EMOTE, str);
				}
				case 5:
				{
					new str[255];

					GivePlayerWeaponEx(playerid, 27, 60);
							
					format(str, sizeof(str), "* %s ��Ժ %s �͡�Ҩҡö %s", ReturnName(playerid, 0), ReturnWeaponName(27), 
					ReturnVehicleName(vehicleid));
								
					SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500); 
					SendClientMessage(playerid, COLOR_EMOTE, str);
				}
			}
			return 1;
		}

		if(!VehicleInfo[vehicleid][eVehicleWeapons][slotid])
			return SendErrorMessage(playerid, "��������ظ� ���͵���س���͡");

		new str[255];

		GivePlayerValidWeapon(playerid, VehicleInfo[vehicleid][eVehicleWeapons][slotid], VehicleInfo[vehicleid][eVehicleWeaponsAmmo][slotid]);

		format(str, sizeof(str), "> %s ��Ժ %s �͡�Ҩҡö %s", ReturnName(playerid, 0), ReturnWeaponName(VehicleInfo[vehicleid][eVehicleWeapons][slotid]), 
		ReturnVehicleName(vehicleid));
		SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500); 
		SendClientMessage(playerid, COLOR_EMOTE, str);

		format(str, sizeof(str), "[%s] %s takegun leave vehicle %s(%d) %s(%d) Ammo: %d", ReturnDate(), ReturnRealName(playerid,0), ReturnVehicleName(vehicleid),VehicleInfo[vehicleid][eVehicleDBID],ReturnWeaponName(VehicleInfo[vehicleid][eVehicleWeapons][slotid]),VehicleInfo[vehicleid][eVehicleWeapons][slotid],VehicleInfo[vehicleid][eVehicleWeaponsAmmo][slotid]);
		SendDiscordMessageEx("weapons", str);
				
				
		VehicleInfo[vehicleid][eVehicleWeapons][slotid] = 0; 
		VehicleInfo[vehicleid][eVehicleWeaponsAmmo][slotid] = 0; 
	}
	else if(GetNearestVehicle(playerid) != INVALID_VEHICLE_ID)
	{
		new Float: x, Float: y, Float: z;
		new engine, lights, alarm, doors, bonnet, boot, objective;

		GetVehicleBoot(GetNearestVehicle(playerid), x, y, z);

		new vehicleid = GetNearestVehicle(playerid);

		if(HasNoEngine(vehicleid))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "�ҹ��˹��������ö�红ͧ��"); 
		
		if(IsCheckBike(vehicleid))
			return SendErrorMessage(playerid, "�������ö�����觹��Ѻ�ҹ��˹з���� ������䫵���"); 

		if(!VehicleInfo[vehicleid][eVehicleDBID] && VehicleInfo[vehicleid][eVehicleAdminSpawn] && !VehicleInfo[vehicleid][eVehicleFaction])
			return SendServerMessage(playerid, "ö�ѹ�����ö��ǹ�ؤ���������ö������ /takegun ��");

		if(!IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z))
			return SendErrorMessage(playerid, "�س������������ҡ���ç����ö");
			
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

		if(!boot)
			return SendErrorMessage(playerid, "�����ҹ��˹��ѧ����Դ");

		if(sscanf(params, "i", slotid))
			return SendUsageMessage(playerid, "/takegun <1-5>");

		if(slotid < 1 || slotid > 5)
			return SendErrorMessage(playerid, "��س���� ���͵���١��ͧ");

		if(VehicleInfo[vehicleid][eVehicleFaction])
		{
			new factionid = VehicleInfo[vehicleid][eVehicleFaction];
			new modelid = GetVehicleModel(vehicleid);
			
			if(FactionInfo[factionid][eFactionJob] != POLICE && FactionInfo[factionid][eFactionJob] != SHERIFF)
				return SendErrorMessage(playerid, "�����������������..");
			
			if(PlayerInfo[playerid][pFaction] != factionid)
				return SendErrorMessage(playerid, "�س�������ö�����觹��Ѻ�ҹ��˹�ῤ��������");

			if(modelid != 596 && modelid != 598 && modelid != 599 && modelid != 490 && modelid != 528 && modelid != 427 && modelid != 597 && modelid != 426 && modelid != 560)
				return SendErrorMessage(playerid, "�����������������..");

			switch(slotid)
			{
				case 1:
				{
					new str[255];

					GivePlayerWeaponEx(playerid, 25, 100);
							
					format(str, sizeof(str), "* %s ��Ժ %s �͡�Ҩҡö %s", ReturnName(playerid, 0), ReturnWeaponName(25), 
					ReturnVehicleName(vehicleid));
								
					SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500); 
					SendClientMessage(playerid, COLOR_EMOTE, str);
				}
				case 2:
				{
					new str[255];

					GivePlayerWeaponEx(playerid, 29, 60);
							
					format(str, sizeof(str), "* %s ��Ժ %s �͡�Ҩҡö %s", ReturnName(playerid, 0), ReturnWeaponName(29), 
					ReturnVehicleName(vehicleid));
								
					SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500); 
					SendClientMessage(playerid, COLOR_EMOTE, str);
				}
				case 3:
				{
					new str[255];

					GivePlayerWeaponEx(playerid, 31, 60);
							
					format(str, sizeof(str), "* %s ��Ժ %s �͡�Ҩҡö %s", ReturnName(playerid, 0), ReturnWeaponName(31), 
					ReturnVehicleName(vehicleid));
								
					SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500); 
					SendClientMessage(playerid, COLOR_EMOTE, str);
				}
				case 4:
				{
					new str[255];

					GivePlayerWeaponEx(playerid, 34, 60);
							
					format(str, sizeof(str), "* %s ��Ժ %s �͡�Ҩҡö %s", ReturnName(playerid, 0), ReturnWeaponName(34), 
					ReturnVehicleName(vehicleid));
								
					SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500); 
					SendClientMessage(playerid, COLOR_EMOTE, str);
				}
				case 5:
				{
					new str[255];

					GivePlayerWeaponEx(playerid, 27, 60);
							
					format(str, sizeof(str), "* %s ��Ժ %s �͡�Ҩҡö %s", ReturnName(playerid, 0), ReturnWeaponName(27), 
					ReturnVehicleName(vehicleid));
								
					SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500); 
					SendClientMessage(playerid, COLOR_EMOTE, str);
				}
			}
			return 1;
		}

		if(!VehicleInfo[vehicleid][eVehicleWeapons][slotid])
			return SendErrorMessage(playerid, "��������ظ� ���͵���س���͡");

		new str[255];

		GivePlayerValidWeapon(playerid, VehicleInfo[vehicleid][eVehicleWeapons][slotid], VehicleInfo[vehicleid][eVehicleWeaponsAmmo][slotid]);

				
		format(str, sizeof(str), "> %s ��Ժ %s �͡�Ҩҡ����ö %s", ReturnName(playerid, 0), ReturnWeaponName(VehicleInfo[vehicleid][eVehicleWeapons][slotid]), 
		ReturnVehicleName(vehicleid));
		SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500); 
		SendClientMessage(playerid, COLOR_EMOTE, str);

		format(str, sizeof(str), "[%s] %s takegun leave trunk vehicle %s(%d) %s(%d) Ammo: %d", ReturnDate(), ReturnRealName(playerid,0), ReturnVehicleName(vehicleid),VehicleInfo[vehicleid][eVehicleDBID],ReturnWeaponName(VehicleInfo[vehicleid][eVehicleWeapons][slotid]),VehicleInfo[vehicleid][eVehicleWeapons][slotid],VehicleInfo[vehicleid][eVehicleWeaponsAmmo][slotid]);
		SendDiscordMessageEx("weapons", str);
				
		VehicleInfo[vehicleid][eVehicleWeapons][slotid] = 0; 
		VehicleInfo[vehicleid][eVehicleWeaponsAmmo][slotid] = 0; 
		return 1;
	}
	else if(PlayerInfo[playerid][pInsideProperty])
	{
		new id = PlayerInfo[playerid][pInsideProperty];

		if(!IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[id][HousePlacePos][0], HouseInfo[id][HousePlacePos][1], HouseInfo[id][HousePlacePos][2]))
			return SendErrorMessage(playerid, "�س������������ش���૿");
		
		if(sscanf(params, "i", slotid))
			return SendUsageMessage(playerid, "/takegun <1-21>");

		if(slotid < 1 || slotid > 21)
			return SendErrorMessage(playerid, "��س���� ���͵���١��ͧ");

		if(!HouseInfo[id][HouseWeapons][slotid])
			return SendErrorMessage(playerid, "��������ظ� ���͵���س���͡");

		GivePlayerValidWeapon(playerid, HouseInfo[id][HouseWeapons][slotid], HouseInfo[id][HouseWeaponsAmmo][slotid]);

		new str[255];	
		format(str, sizeof(str), "> %s ��Ժ %s �͡�Ҩҡ���૿", ReturnName(playerid, 0), ReturnWeaponName(HouseInfo[id][HouseWeapons][slotid])); 
		SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500); 
		SendClientMessage(playerid, COLOR_EMOTE, str); 

		format(str, sizeof(str), "[%s] %s takegun leave house %d %s(%d) Ammo: %d", ReturnDate(), ReturnRealName(playerid,0), id,ReturnWeaponName(HouseInfo[id][HouseWeapons][slotid]),HouseInfo[id][HouseWeapons][slotid],HouseInfo[id][HouseWeaponsAmmo][slotid]);
		SendDiscordMessageEx("weapons", str);
				
		HouseInfo[id][HouseWeapons][slotid] = 0; 
		HouseInfo[id][HouseWeaponsAmmo][slotid] = 0; 
			
		CharacterSave(playerid); Savehouse(id);
		return 1;
	}
	else SendErrorMessage(playerid, "�����������������..");
	return 1;
}

CMD:checkweapons(playerid, params[])
{
	new longstr[MAX_STRING], playerb;

	if(PlayerInfo[playerid][pAdmin])
	{
		if(sscanf(params, "I(-1)", playerb))
			return 1; 

		if(playerb == -1)
		{
			for(new i = 0; i < 4; i++)
			{
					if(!PlayerInfo[playerid][pWeapons][i])
						format(longstr, sizeof(longstr), "%s%d. [��ҧ����]\n", longstr, i);
						
					else format(longstr, sizeof(longstr), "%s%d. %s[����ع: %d]\n", longstr, i, ReturnWeaponName(PlayerInfo[playerid][pWeapons][i]), PlayerInfo[playerid][pWeaponsAmmo][i]); 
			}
			Dialog_Show(playerid, DIALOG_MYEAPON, DIALOG_STYLE_LIST, "Weapons:", longstr, "��ŧ", "¡��ԡ");
			return 1;
		}
		else
		{
			for(new i = 0; i < 4; i++)
			{
					if(!PlayerInfo[playerb][pWeapons][i])
						format(longstr, sizeof(longstr), "%s%d. [��ҧ����]\n", longstr, i);
						
					else format(longstr, sizeof(longstr), "%s%d. %s[����ع: %d]\n", longstr, i, ReturnWeaponName(PlayerInfo[playerb][pWeapons][i]), PlayerInfo[playerb][pWeaponsAmmo][i]); 
			}
			new weapons[4][2];
			SendClientMessage(playerid, -1, "-------------------------WEAPONS NOT IN DATABSE----------------------");
			
			for (new i = 0; i < 4; i++)
			{	
				GetPlayerWeaponData(playerb, i, weapons[i][0], weapons[i][1]);


				if(!weapons[i][0])
					continue;

				if(PlayerInfo[playerb][pWeapons][i])
					continue;

				if(PlayerInfo[playerb][pWeaponsAmmo][i] == weapons[i][1])
					continue;

				SendClientMessageEx(playerid, COLOR_LIGHTRED, "%s %d", ReturnWeaponName(weapons[i][0]), weapons[i][1]);
			}
			Dialog_Show(playerid, DIALOG_MYEAPON, DIALOG_STYLE_LIST, "Weapons: %s", longstr, "��ŧ", "¡��ԡ", ReturnName(playerb,0));
			return 1;
		}
		
	}
	else
	{
		for(new i = 0; i < 4; i++)
		{
				if(!PlayerInfo[playerid][pWeapons][i])
					format(longstr, sizeof(longstr), "%s%d. [��ҧ����]\n", longstr, i);
					
				else format(longstr, sizeof(longstr), "%s%d. %s[����ع: %d]\n", longstr, i, ReturnWeaponName(PlayerInfo[playerid][pWeapons][i]), PlayerInfo[playerid][pWeaponsAmmo][i]); 
		}
		Dialog_Show(playerid, DIALOG_MYEAPON, DIALOG_STYLE_LIST, "Weapons:", longstr, "��ŧ", "¡��ԡ");
	}
	return 1;
}

CMD:damages(playerid, params[])
{
	new playerb;
	
	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/damages [���ͺҧ��ǹ/�ʹ�]");
		
	if(!IsPlayerConnected(playerb))	
		return SendErrorMessage(playerid, "�����������ӡ��������������׿�����");
		
	if(!BitFlag_Get(gPlayerBitFlag[playerb], IS_LOGGED))
		return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");
		
	if(PlayerInfo[playerid][pAdminDuty])
	{
		ShowPlayerDamages(playerb, playerid, 1); 
	}
	else
	{
		if(!IsPlayerNearPlayer(playerid, playerb, 5.0))
			return SendErrorMessage(playerid, "�س�����������������");
			
		ShowPlayerDamages(playerb, playerid, 0); 
	}
	return 1;
}

CMD:acceptdeath(playerid, params[])
{
	if(GetPlayerTeam(playerid) != PLAYER_STATE_WOUNDED)
		return SendErrorMessage(playerid, "�س�ѧ������Ѻ�Ҵ��");
		
	CallLocalFunction("OnPlayerDead", "iii", playerid, INVALID_PLAYER_ID, -1, 0); 
	return 1;
}

CMD:respawnme(playerid, params[])
{
	
	if(GetPlayerTeam(playerid) != PLAYER_STATE_DEAD)
		return SendErrorMessage(playerid, "�س�ѧ������Ѻ�Ҵ��");

	if(gettime() - PlayerInfo[playerid][pRespawnTime] < 60)
		return SendErrorMessage(playerid, "�س�ѧ�������ö�Դ���ô���ա %d",gettime() - PlayerInfo[playerid][pRespawnTime]);

	PlayerInfo[playerid][pRespawnTime] = 0;
	SetPlayerChatBubble(playerid, "Respawned", COLOR_WHITE, 20.0, 1500);
	SetPlayerTeam(playerid, PLAYER_STATE_ALIVE); 
			
	TogglePlayerControllable(playerid, 1);

	ResetPlayerWeapons(playerid);
	
	for(new i = 0; i < 13; i++)
	{
		PlayerInfo[playerid][pWeapons][i] = 0;
		PlayerInfo[playerid][pWeaponsAmmo][i] = 0;
	}

	GiveMoney(playerid, -2000);
	SetPlayerHealth(playerid, 100);
	ClearDamages(playerid);
	
	SetPlayerPos(playerid, 1172.3795,-1322.9852,15.4022);
	SetPlayerFacingAngle(playerid, 268.8748);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	return 1;
}

CMD:stats(playerid, params[])
{
	new playerb;
	
	if(PlayerInfo[playerid][pAdmin])
	{
		if (sscanf(params, "I(-1)", playerb))
			return 1; 
			
		if(playerb == -1)
		{
			return ShowCharacterStats(playerid, playerid);
		}
		else
		{
			if(!IsPlayerConnected(playerb))
				return SendErrorMessage(playerid, "�����������ӡ��������������׿�����");
				
			if(!BitFlag_Get(gPlayerBitFlag[playerb], IS_LOGGED))
				return SendErrorMessage(playerid, "�����蹡��ѧ�������к�"); 
				
			ShowCharacterStats(playerb, playerid); 
		}
	}
	else return ShowCharacterStats(playerid, playerid);
	return 1;
}

CMD:pc(playerid, params[])
{
	if(PlayerShowMecMenu[playerid])
		return MecJobShow(playerid, false);
	
	
	return SelectTextDraw(playerid, COLOR_GRAD1);
}

CMD:admins(playerid, params[])
{
	
	new bool:adminOn = false;
	
	foreach (new i : Player)
	{
		if (PlayerInfo[playerid][pAdmin]) adminOn = true;
	}
	
	if(adminOn == true)
	{
		SendClientMessage(playerid, COLOR_GREY, "Admins Online:");
		
		foreach(new i : Player)
		{
			if(PlayerInfo[i][pAdminDuty])
			{
				SendClientMessageEx(playerid, COLOR_DARKGREEN, "(Level: %d) %s - On Duty: Yes", PlayerInfo[i][pAdmin], e_pAccountData[i][mForumName]);
			}
		}
	}
	else
	{
		return SendClientMessage(playerid, COLOR_GREY, "Admins Online:");
	}

	return 1;
}

CMD:online(playerid, params[])
{
	new Android = 0, PC = 0;

	foreach(new i : Player)
	{
		if(IsPlayerAndroid(i) == true)
		{
			Android++;
		}
		else PC++;
	}
	SendClientMessageEx(playerid, COLOR_GREY, "Android: %d �� PC: %d ��",Android, PC);
	return 1;
}


CMD:helpers(playerid, params[])
{
	new bool:TesterOn = false;
	
	foreach (new i : Player)
	{
		if (PlayerInfo[i][pTester]) TesterOn = true;
	}
	
	if(TesterOn == true)
	{
		SendClientMessage(playerid, COLOR_GREY, "Tester Online:");
		
		foreach(new i : Player)
		{
			if(PlayerInfo[i][pTesterDuty])
			{
				if(PlayerInfo[i][pTesterDuty])
				{
					SendClientMessageEx(playerid, COLOR_DARKGREEN, "(Level: %d) %s - On Duty: Yes", PlayerInfo[i][pTester], e_pAccountData[i][mForumName]);
				}
			}
		}
	}
	else
	{
		return SendClientMessage(playerid, COLOR_GREY, "Tester Online:");
	}
	return 1;
}

alias:ooc("o")
CMD:ooc(playerid, params[])
{
	if(isnull(params))
		return SendUsageMessage(playerid, "/(o)oc [text]"); 
		
	if(!oocEnabled && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "OOC �١�Դ�����ҹ����ҹ��"); 
		
	if(PlayerInfo[playerid][pAdminDuty])
		SendClientMessageToAllEx(COLOR_SAMP, "{adc3e7}[OOC] {FB8C00}%s{adc3e7}: %s", ReturnRealName(playerid, 0), params); 
	else if(PlayerInfo[playerid][pTesterDuty])	
		SendClientMessageToAllEx(COLOR_SAMP, "{adc3e7}[OOC] {229954}%s{adc3e7}: %s", ReturnRealName(playerid, 0), params);

	else SendClientMessageToAllEx(COLOR_SAMP, "{adc3e7}[OOC] %s: %s", ReturnRealName(playerid, 0), params);
	return 1;
}

CMD:pay(playerid, params[])
{
	new playerb, amount, emote[90], str[128]; 

	if(sscanf(params, "uiS('None')[90]", playerb, amount, emote))
		return SendUsageMessage(playerid, "/pay [���ͺҧ��ǹ/�ʹ�] [�ӹǹ] [��á�з� (�����)]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "��������������������׿�����");

	if(!BitFlag_Get(gPlayerBitFlag[playerb], IS_LOGGED))
		return SendErrorMessage(playerid, "�����蹡��ѧ�������к�"); 

	if(!IsPlayerNearPlayer(playerid, playerb, 5.0))
		return SendErrorMessage(playerid, "������������������س");

	if(amount > PlayerInfo[playerid][pCash])
		return SendErrorMessage(playerid, "�س������Թ�ͷ������");

	if(amount < 1)
		return SendErrorMessage(playerid, "��س�����Թ���١��ͧ");

	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0); PlayerPlaySound(playerb, 1052, 0.0, 0.0, 0.0);

	SendClientMessageEx(playerid, COLOR_GREY, " �س��ӡ�è����Թ��� %s �ӹǹ $%s.", ReturnRealName(playerb, 0), MoneyFormat(amount)); 
	SendClientMessageEx(playerb, COLOR_GREY, " �س���Ѻ�Թ �ӹǹ $%s �ҡ %s", MoneyFormat(amount), ReturnRealName(playerid, 0));

	if(!strcmp(emote, "'None'", false))
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "> %s ���ѡ�Թ�ҧ��ǹ�͡�Ҩҡ����������ͺ���Ѻ %s", ReturnName(playerid, 0), ReturnName(playerb, 0)); 

	else SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "> %s %s %s", ReturnName(playerid, 0), emote, ReturnName(playerb, 0));

	if(PlayerInfo[playerid][pLevel] <= 3 && PlayerInfo[playerb][pLevel] <= 3 || amount >= 50000)
	{
		format(str, sizeof(str), "%s ������Թ �ӹǹ $%s ���Ѻ %s �������͹���繡�üԴ�����������ô��Ǩ�ͺ����", ReturnName(playerid), MoneyFormat(amount), ReturnName(playerb)); 
		SendAdminMessage(1, str);
	}
	
	format(str, sizeof(str), "[%s] %s pay to %s amount: $%s",ReturnDate(), ReturnRealName(playerid), ReturnRealName(playerb), MoneyFormat(amount));
	SendDiscordMessageEx("money", str);

	GiveMoney(playerid, -amount); GiveMoney(playerb, amount);
	return 1;
}

CMD:setchannel(playerid, params[])
{
	new 
		slot, 
		channel
	;

	if(!PlayerInfo[playerid][pHasRadio])
		return SendErrorMessage(playerid, "�س����� �Է��"); 
	
	if(!PlayerInfo[playerid][pRadioOn])
		return SendErrorMessage(playerid, "�س�ѧ������Դ�Է��");

	if(sscanf(params, "ii", channel, slot))
		return SendUsageMessage(playerid, "/setchannel [�����] [��͵]"); 
		
	if(slot > 2 || slot < 1)
		return SendErrorMessage(playerid, "��͵������ö��Ѻ����§�� (1-2)");
		
	if(channel < 1 || channel > 1000000)
		return SendErrorMessage(playerid, "�س�������ö��Ѻ�����Թ (1-1000000)"); 
	
	if(channel == 911)
	{
		if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != GOVERMENT)
			return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} �س�������ö��駤�� �����Է�ع�������ͧ�ҡ�س�����˹��§ҹ�Ѱ���"); 
	}
	
	PlayerInfo[playerid][pRadio][slot] = channel;
	PlayerInfo[playerid][pMainSlot] = slot;
	SendClientMessageEx(playerid, COLOR_RADIOEX, "�س���Ѻ�Է��价����� %i ����� ���͵ %i.", channel, slot);
	UpDateRadioStats(playerid);
	CharacterSave(playerid); 
	return 1;
}

CMD:radioon(playerid, params[])
{
	if(!PlayerInfo[playerid][pHasRadio])
		return SendErrorMessage(playerid, "�س�ѧ������Է��");
	
	if(PlayerInfo[playerid][pRadioOn])
	{
		PlayerInfo[playerid][pRadioOn] = false;
		SendClientMessage(playerid, COLOR_GREY, "�س��Դ�Է��");
		return 1;
	}
	else
	{
		PlayerInfo[playerid][pRadioOn] = true;
		SendClientMessage(playerid, COLOR_YELLOWEX, "�س���Դ�Է��");
	}

	return 1;
}

alias:radio("r")
CMD:radio(playerid, params[])
{
	if(!PlayerInfo[playerid][pHasRadio])
		return SendErrorMessage(playerid, "�س������Է��");

	if(!PlayerInfo[playerid][pRadioOn])
		return SendErrorMessage(playerid, "�س�ѧ������Դ�Է��");

	new
		local,
		channel
	;
		
	local = PlayerInfo[playerid][pMainSlot]; 
	channel = PlayerInfo[playerid][pRadio][local]; 
	
	if(!PlayerInfo[playerid][pRadio][local])
		return SendErrorMessage(playerid, "�س�ѧ������� ���͵"); 
		
	if(isnull(params))
		return SendUsageMessage(playerid, "/r(adio) [��ͤ���]");
		
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pRadioOn])
		{
			for(new r = 1; r < 3; r ++)
			{
				if(PlayerInfo[i][pRadio][r] == channel)
				{
					if(r != PlayerInfo[i][pMainSlot])
					{
						if(strlen(params) > 75)
						{
							SendClientMessageEx(i, COLOR_RADIO, "**[CH: %d, S: %d] %s �ٴ���: %.75s", PlayerInfo[i][pRadio][r], PlayerInfo[playerid][pMainSlot], ReturnName(playerid, 0), params);
							SendClientMessageEx(i, COLOR_RADIO, "**[CH: %d, S: %d] %s", PlayerInfo[i][pRadio][r],PlayerInfo[playerid][pMainSlot], params[75]);
						}
						else SendClientMessageEx(i, COLOR_RADIO, "**[CH: %d, S: %d] %s �ٴ���: %s", PlayerInfo[i][pRadio][r], PlayerInfo[playerid][pMainSlot], ReturnName(playerid, 0), params);
					}
					else 
					{
						if(strlen(params) > 75)
						{
							SendClientMessageEx(i, COLOR_RADIO, "**[CH: %d, S: %d] %s �ٴ���: %.75s", PlayerInfo[i][pRadio][r], PlayerInfo[playerid][pMainSlot], ReturnName(playerid, 0), params);
							SendClientMessageEx(i, COLOR_RADIO, "**[CH: %d, S: %d] %s", PlayerInfo[i][pRadio][r], PlayerInfo[playerid][pMainSlot], params[75]);
						}
						else SendClientMessageEx(i, COLOR_RADIO, "**[CH: %d, S: %d] %s �ٴ���: %s", PlayerInfo[i][pRadio][r], PlayerInfo[playerid][pMainSlot], ReturnName(playerid, 0), params);
					}
				}
			}
		}
	}
	
	new str[120];
	format(str, sizeof(str),"(�Է��) %s �ٴ���: %s", ReturnName(playerid, 0), params);
	SetPlayerChatBubble(playerid, str, COLOR_GRAD1, 10.0, 6000);

	new Float:posx, Float:posy, Float:posz;
	GetPlayerPos(playerid, posx,posy,posz);

	foreach(new i : Player)
	{
	   	if(i == playerid)
	       continue;

		else if(IsPlayerInRangeOfPoint(i, 10.0, posx,posy,posz))
		{
			if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid))
				continue;
			
			SendClientMessageEx(i, COLOR_GRAD1, "(�Է��) %s �ٴ���: %s", ReturnName(playerid, 0), params);
		}
	}
	return 1;
}

CMD:rlow(playerid, params[])
{
	if(!PlayerInfo[playerid][pHasRadio])
		return SendErrorMessage(playerid, "�س������Է��");

	if(!PlayerInfo[playerid][pRadioOn])
		return SendErrorMessage(playerid, "�س�ѧ������Դ�Է��");

	new
		local,
		channel
	;
		
	local = PlayerInfo[playerid][pMainSlot]; 
	channel = PlayerInfo[playerid][pRadio][local]; 
	
	if(!PlayerInfo[playerid][pRadio][local])
		return SendErrorMessage(playerid, "�س�ѧ����������͵"); 
		
	if(isnull(params))
		return SendUsageMessage(playerid, "/rlow [��ͤ���]");
		
	foreach(new i : Player)
	{
		for(new r = 1; r < 3; r ++)
		{
			if(PlayerInfo[i][pRadio][r] == channel)
			{
				if(r != PlayerInfo[i][pMainSlot])
					SendClientMessageEx(i, COLOR_RADIOEX, "**[CH: %d, S: %d] %s �ٴ���: %s", PlayerInfo[i][pRadio][r], GetChannelSlot(i, channel), ReturnName(playerid, 0), params);
					
				else SendClientMessageEx(i, COLOR_RADIO, "**[CH: %d, S: %d] %s �ٴ���: %s", PlayerInfo[i][pRadio][r], GetChannelSlot(i, channel), ReturnName(playerid, 0), params);
			}
		}
	}

	new str[120];
	format(str, sizeof(str),"(�Է��) %s �ٴ���: %s", ReturnName(playerid, 0), params);
	SetPlayerChatBubble(playerid, str, COLOR_GRAD1, 5.0, 6000);
	
	new Float:posx, Float:posy, Float:posz;
	GetPlayerPos(playerid, posx,posy,posz);

	foreach(new i : Player)
	{
	   	if(i == playerid)
	       continue;

		else if(IsPlayerInRangeOfPoint(i, 5.0, posx,posy,posz))
		{
			if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid))
				continue;
			
			SendClientMessageEx(i, COLOR_GRAD1, "(�Է��) %s �ٴ���[��]: %s", ReturnName(playerid, 0), params);
		}
	}
	return 1;
}

CMD:setspawn(playerid, params[])
{
	new 
		id;

	if(sscanf(params, "i", id))
	{
		SendUsageMessage(playerid, "/setspawn [spawn id]");
		SendClientMessage(playerid, COLOR_WHITE, "1. ʹ���Թ, 2. ��ҹ, 3. ࿤���, 4.�ش����ش");
		return 1;
	}

	if(id > 4 || id < 1)
		return SendErrorMessage(playerid, "����ʻ�� ����§ (1-4)");

	switch(id)
	{
		case 1:
		{
			if(PlayerInfo[playerid][pSpawnPoint] == 0)
				return SendErrorMessage(playerid, "�س��ӡ���絨ش�Դ�ͧ�س�� ʹ���Թ��������");

			PlayerInfo[playerid][pSpawnPoint] = SPAWN_AT_DEFAULT; 
			SendServerMessage(playerid, "�س��ӡ���絨ش�Դ�ͧ�س�� ʹ���Թ");
			CharacterSave(playerid);
		}
		case 2:
		{
			new id_house = IsPlayerInHouse(playerid);

			if(id_house == 0)
				return SendErrorMessage(playerid, "�س���������㹺�ҹ");

			if(HouseInfo[id_house][HouseOwnerDBID] != PlayerInfo[playerid][pDBID] && HouseInfo[id_house][HouseRent] != PlayerInfo[playerid][pDBID] && PlayerInfo[playerid][pHouseKey] != id_house)
				return SendErrorMessage(playerid, "�س�������Ңͧ��ҹ��ѧ���");

			PlayerInfo[playerid][pSpawnPoint] = SPAWN_AT_HOUSE;
			PlayerInfo[playerid][pSpawnHouse] = id_house;
			SendServerMessage(playerid, "�س��ӡ���絨ش�Դ�ͧ�س�� ��ҹ %s", HouseInfo[id_house][HouseName]);
			CharacterSave(playerid);
		}
		case 3:
		{
			new id_fac = PlayerInfo[playerid][pFaction];

			if(id_fac == 0)
				return SendErrorMessage(playerid, "�س�����࿤���");
			
			if(!FactionInfo[id_fac][eFactionSpawn][0] || !FactionInfo[id_fac][eFactionSpawn][1] || !FactionInfo[id_fac][eFactionSpawn][2])
				return SendErrorMessage(playerid, "࿤��蹢ͧ�س�ѧ����ա���絨ش�Դ");

			PlayerInfo[playerid][pSpawnPoint] = SPAWN_AT_FACTION;
			SendServerMessage(playerid, "�س��ӡ���絨ش�Դ�ͧ�س�� ࿤���");
			CharacterSave(playerid);
		}
		case 4:
		{
			PlayerInfo[playerid][pSpawnPoint] = SPAWN_AT_LASTPOS;
			SendServerMessage(playerid, "�س��ӡ���絨ش�Դ�繨ش�Դ ����ش");
			CharacterSave(playerid);
		}
	}
	return 1;
}


alias:leavegun("lg")
CMD:leavegun(playerid, params[])
{
	if(PlayerInfo[playerid][pDuty])
		return SendErrorMessage(playerid, "�س�����ʶҹС�÷ӧҹ��˹��§ҹ�Ѱ�������ö�����觹����");

	if(GetPlayerState(playerid) != PLAYER_STATE_ALIVE)
		return SendErrorMessage(playerid, "�س����������ʶҹл��Է�����������ö�����觹����");

	new 
		weaponid, 
		idx,
		id, 
		Float:x,
		Float:y,
		Float:z
	;
	
	if(sscanf(params, "i", weaponid))
	{
		SendUsageMessage(playerid, "/leavegun [�ʹ����ظ]");
		SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF}�س����ö��Ժ�׹������¡�þ���� /grabgun."); 
		return 1;
	}
	
	if(weaponid < 1 || weaponid > 46 || weaponid == 35 || weaponid == 36 || weaponid == 37 || weaponid == 38 || weaponid == 39)
	    return SendErrorMessage(playerid, "���ظ����ҹ��١�Ѵ�����ظ��ͧ���������׿�����");
		
	/*if(!PlayerHasWeapon(playerid, weaponid))
		return SendErrorMessage(playerid, "�س����������ظ��Դ�ѧ�����"); */

	if(GetPlayerWeapon(playerid) != weaponid)
		return SendErrorMessage(playerid, "�س����������ظ %s", ReturnWeaponName(weaponid));
		
	for(new i = 0; i < sizeof(WeaponDropInfo); i++)
	{
		if(!WeaponDropInfo[i][eWeaponDropped])
		{
			idx = i;
			break;
		}
	}
	
	id = ReturnWeaponIDSlot(weaponid); 
	GetPlayerPos(playerid, x, y, z); 
	
	WeaponDropInfo[idx][eWeaponDropped] = true;
	WeaponDropInfo[idx][eWeaponDroppedBy] = PlayerInfo[playerid][pDBID]; 
	
	WeaponDropInfo[idx][eWeaponWepID] = weaponid;
	WeaponDropInfo[idx][eWeaponWepAmmo] = GetPlayerAmmo(playerid);
	
	WeaponDropInfo[idx][eWeaponPos][0] = x;
	WeaponDropInfo[idx][eWeaponPos][1] = y;
	WeaponDropInfo[idx][eWeaponPos][2] = z;
	
	WeaponDropInfo[idx][eWeaponInterior] = GetPlayerInterior(playerid);
	WeaponDropInfo[idx][eWeaponWorld] = GetPlayerVirtualWorld(playerid); 
	
	RemovePlayerWeapon(playerid, weaponid);
	PlayerInfo[playerid][pGun][id] = 0;
	PlayerInfo[playerid][pGunAmmo][id] = 0; 
	PlayerInfo[playerid][pWeapons][g_aWeaponSlots[weaponid]] = 0;
	PlayerInfo[playerid][pWeaponsAmmo][g_aWeaponSlots[weaponid]] = 0;
	
	WeaponDropInfo[idx][eWeaponObject] = CreateDynamicObject(
		ReturnWeaponsModel(weaponid),
		x,
		y,
		z - 1,
		80.0,
		0.0,
		0.0,
		GetPlayerVirtualWorld(playerid),
		GetPlayerInterior(playerid)); 
		
	WeaponDropInfo[idx][eWeaponTimer] = SetTimerEx("OnPlayerLeaveWeapon", 600000, false, "i", idx); 
	SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} ���ظ�ͧ�س���ѧ�����躹�����֧ 10 �ҷա�͹�ж١ź�͡�ҡ�׿�����");
	
	new str[120];
	format(str, sizeof(str), "%s leavegun %s(%d) Ammo: %d", ReturnRealName(playerid,0),ReturnWeaponName(weaponid),weaponid, WeaponDropInfo[idx][eWeaponWepAmmo]);
	SendDiscordMessageEx("weapons", str);
	return 1;
}

alias:grabgun("gg")
CMD:grabgun(playerid, params[])
{	
	new
		bool:foundWeapon = false,
		id,
		str[128]
	;

	for(new i = 0; i < sizeof(WeaponDropInfo); i++)
	{
		if(!WeaponDropInfo[i][eWeaponDropped])
			continue; 
	
		if(IsPlayerInRangeOfPoint(playerid, 3.0, WeaponDropInfo[i][eWeaponPos][0], WeaponDropInfo[i][eWeaponPos][1], WeaponDropInfo[i][eWeaponPos][2]))
		{
			if(GetPlayerVirtualWorld(playerid) == WeaponDropInfo[i][eWeaponWorld])
			{
				foundWeapon = true;
				id = i;
			}							
		}
	}
	
	if(foundWeapon)
	{
		GivePlayerGun(playerid, WeaponDropInfo[id][eWeaponWepID], WeaponDropInfo[id][eWeaponWepAmmo]);
		
		format(str, sizeof(str), "* %s ��Ժ %s ����Ҩҡ���", ReturnName(playerid, 0), ReturnWeaponName(WeaponDropInfo[id][eWeaponWepID]));
		SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 3000);
		SendClientMessage(playerid, COLOR_EMOTE, str);

		format(str, sizeof(str), "%s grabgun %s(%d) Ammo: %d", ReturnRealName(playerid,0),ReturnWeaponName(WeaponDropInfo[id][eWeaponWepID]), WeaponDropInfo[id][eWeaponWepID], WeaponDropInfo[id][eWeaponWepAmmo]);
		SendDiscordMessageEx("weapons", str);
		
		WeaponDropInfo[id][eWeaponDropped] = false; 
		WeaponDropInfo[id][eWeaponDroppedBy] = 0;
		
		WeaponDropInfo[id][eWeaponWepID] = 0; WeaponDropInfo[id][eWeaponWepAmmo] = 0; 
		
		KillTimer(WeaponDropInfo[id][eWeaponTimer]); 
		DestroyDynamicObject(WeaponDropInfo[id][eWeaponObject]); 
	}
	else return SendServerMessage(playerid, "��������ظ������������㹺���ǳù��");
	return 1;
}

CMD:levelup(playerid, params[])
{
	new
		exp_count,
		str[128]
	;
	
	exp_count = ((PlayerInfo[playerid][pLevel]) * 4 + 2); 
	
	if(PlayerInfo[playerid][pExp] < exp_count)
	{
		SendServerMessage(playerid, "�س�ѧ�� ��һ��ʺ��ó�����ҡ�� ���繵�ͧ�դ�һ��ʺ��ó� %i �֧������ö�ѻ�ô��", exp_count); 
		return 1; 
	}
	
	PlayerInfo[playerid][pLevel]++; 
	PlayerInfo[playerid][pExp] = 0; 
	
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]); 
	
	format(str, sizeof(str), "~g~Leveled Up~n~~w~You leveled up to level %i", PlayerInfo[playerid][pLevel]);
	GameTextForPlayer(playerid, str, 5000, 1);

	CharacterSave(playerid); 
	return 1;
}

alias:license("lic", "�ѵû�ЪҪ�", "�ѵ�")
CMD:license(playerid, params[])
{
	new playerb;
		
	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/license [���ͺҧ��ǹ/�ʹ�]"); 
	
	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "��������������������׿�����");
		
	if(!BitFlag_Get(gPlayerBitFlag[playerb], IS_LOGGED))
		return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");
		
	if(!IsPlayerNearPlayer(playerid, playerb, 5.0))
		return SendErrorMessage(playerid, "������������������س"); 
		
	if(playerb != playerid)
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "> %s ��Ժ�ѵû�Шӵ�Ǻѵû�ЪҪ���������� %s", ReturnName(playerid, 0), ReturnName(playerb, 0));
		
	else SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "> %s ��Ժ�ѵû�Шӵ�Ǻѵû�ЪҪ�����Ҵ�", ReturnName(playerid, 0));
	
	ReturnLicenses(playerid, playerb); 	
	return 1;
}

CMD:time(playerid, params[])
{
	new str[20];
	format(str, sizeof(str), "�ٹ��ԡ�");
	callcmd::ame(playerid, str);
	
	new string[128], hour, minute, seconds;
	
	gettime(hour, minute, seconds);
	
	if(PlayerInfo[playerid][pAdminjailed] == true)
		format(string, sizeof(string), "~g~|~w~%02d:%02d~g~|~n~~w~Jail Time left: %d SEC", hour, minute, PlayerInfo[playerid][pAdminjailTime]);

	else if(PlayerInfo[playerid][pArrest] == true)
		format(string, sizeof(string), "~g~|~w~%02d:%02d~g~|~n~~w~Arrest Time left: %d SEC", hour, minute, PlayerInfo[playerid][pArrestTime]);
	else
		format(string, sizeof(string), "~g~|~w~%02d:%02d~g~|", hour, minute);


		
		
	GameTextForPlayer(playerid, string, 2000, 1);
	
	return 1;
}

CMD:rcp(playerid, params[])
{
	DisablePlayerCheckpoint(playerid);
	
	//Disabling checkpoint referring variables:
	PlayerCheckpoint[playerid] = 0;
	return 1;
}

CMD:b(playerid, params[])
{
	if (isnull(params))
		return SendUsageMessage(playerid, "/b [��ͤ���]"); 
	
	if(PlayerInfo[playerid][pAdminDuty] == true)
	{
		if(strlen(params) > 84)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_GREY, "(( [%d] {FF9900}%s{AFAFAF}: %.84s ))", playerid, ReturnName(playerid), params);
			SendNearbyMessage(playerid, 20.0, COLOR_GREY, "(( [%d] {FF9900}%s{AFAFAF}: ...%s ))", playerid, ReturnName(playerid), params[84]);
		}
		else SendNearbyMessage(playerid, 20.0, COLOR_GREY, "(( [%d] {FF9900}%s{AFAFAF}: %s ))", playerid, ReturnName(playerid), params);
		Log(chatlog, WARNING, "(( [%d] %s: %.84s ))", playerid, ReturnName(playerid), params);
	}
	else if(PlayerInfo[playerid][pTesterDuty] == true)
	{
		if(strlen(params) > 84)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_GREY, "(( [%d] {229954}%s{AFAFAF}: %.84s ))", playerid, ReturnName(playerid), params);
			SendNearbyMessage(playerid, 20.0, COLOR_GREY, "(( [%d] {229954}%s{AFAFAF}: ...%s ))", playerid, ReturnName(playerid), params[84]);
		}
		else SendNearbyMessage(playerid, 20.0, COLOR_GREY, "(( [%d] {229954}%s{AFAFAF}: %s ))", playerid, ReturnName(playerid), params);
		Log(chatlog, WARNING, "(( [%d] %s: %.84s ))", playerid, ReturnName(playerid), params);
	}
	else
	{
		if(strlen(params) > 84)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_GREY, "(( [%d] %s: %.84s ))", playerid, ReturnName(playerid), params);
			SendNearbyMessage(playerid, 20.0, COLOR_GREY, "(( [%d] %s: ...%s ))", playerid, ReturnName(playerid), params[84]); 
		}
		else SendNearbyMessage(playerid, 20.0, COLOR_GREY, "(( [%d] %s: %s ))", playerid, ReturnName(playerid), params);
		Log(chatlog, WARNING, "(( [%d] %s: %.84s ))", playerid, ReturnName(playerid), params);
	}	
	return 1;
}

CMD:pm(playerid, params[])
{
	new
		playerb,
		text[144]
	;

	if(PlayerInfo[playerid][pTogPm] && !PlayerInfo[playerid][pAdmin] && !PlayerInfo[playerid][pTester])
		return SendErrorMessage(playerid, "�س��Դ����Ѻ ��ͤ�����ǹ���");
		
	if(sscanf(params, "us[144]", playerb, text))
		return SendUsageMessage(playerid, "/pm [���ͺҧ��ǹ/�ʹ�] [text]");
		
	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "������������������͡Ѻ�׿�����");
	
	if(PlayerInfo[playerb][pTogPm] && !PlayerInfo[playerid][pAdmin] && !PlayerInfo[playerid][pTester])
		return SendErrorMessage(playerid, "�������ա����ա�ûԴ�����ҹ����觢�ͤ�����ǹ���");
	
	if(PlayerInfo[playerid][pAdminDuty])
	{
		
		SendClientMessageEx(playerb, COLOR_PMRECEIVED, "(( PM �ҡ {FF9900}%s{FFDC18} (ID: %d): %s ))", ReturnName(playerid), playerid, text); 
		Log(chatlog, WARNING, "(( PM �ҡ %s (ID: %d): %s ))", ReturnName(playerid), playerid, text);

		if(!PlayerInfo[playerb][pAdminDuty])
			SendClientMessageEx(playerid, COLOR_PMSENT, "(( PM ����ѧ %s (ID: %d): %s ))", ReturnName(playerb), playerb, text); 
			
		else SendClientMessageEx(playerid, COLOR_PMSENT, "(( PM ����ѧ {FF9900}%s{EEE854} (ID: %d): %s ))", ReturnName(playerb), playerb, text); 
		Log(chatlog, WARNING, "(( PM ����ѧ %s (ID: %d): %s ))", ReturnName(playerb), playerb, text);
	}
	else if(PlayerInfo[playerid][pTesterDuty])
	{
		SendClientMessageEx(playerb, COLOR_PMRECEIVED, "(( PM �ҡ {229954}%s{FFDC18} (ID: %d): %s ))", ReturnName(playerid), playerid, text); 
		Log(chatlog, WARNING, "(( PM �ҡ %s (ID: %d): %s ))", ReturnName(playerid), playerid, text);

		if(!PlayerInfo[playerb][pTesterDuty])
			SendClientMessageEx(playerid, COLOR_PMSENT, "(( PM ����ѧ %s (ID: %d): %s ))", ReturnName(playerb), playerb, text); 
			
		else SendClientMessageEx(playerid, COLOR_PMSENT, "(( PM ����ѧ {229954}%s{EEE854} (ID: %d): %s ))", ReturnName(playerb), playerb, text); 
		Log(chatlog, WARNING, "(( PM ����ѧ %s (ID: %d): %s ))", ReturnName(playerb), playerb, text);
	}
	else
	{
		if(PlayerInfo[playerb][pAdminDuty])
		{
			SendClientMessageEx(playerb, COLOR_PMRECEIVED, "(( PM �ҡ %s (ID: %d): %s ))", ReturnName(playerid), playerid, text); 
			SendClientMessageEx(playerid, COLOR_PMSENT, "(( PM ����ѧ {FF9900}%s{EEE854} (ID: %d): %s ))", ReturnName(playerb), playerb, text); 
		}
		else if(PlayerInfo[playerb][pTesterDuty])
		{
			SendClientMessageEx(playerb, COLOR_PMRECEIVED, "(( PM �ҡ %s (ID: %d): %s ))", ReturnName(playerid), playerid, text); 
			SendClientMessageEx(playerid, COLOR_PMSENT, "(( PM ����ѧ {229954}%s{EEE854} (ID: %d): %s ))", ReturnName(playerb), playerb, text); 
		}
		else
		{
			SendClientMessageEx(playerb, COLOR_PMRECEIVED, "(( PM �ҡ %s (ID: %d): %s ))", ReturnName(playerid), playerid, text); 
			SendClientMessageEx(playerid, COLOR_PMSENT, "(( PM ����ѧ %s (ID: %d): %s ))", ReturnName(playerb), playerb, text);
			Log(chatlog, WARNING, "(( PM ����ѧ %s (ID: %d): %s ))", ReturnName(playerb), playerb, text); 
		}
	}
	return 1;
}

CMD:togpm(playerid, params[])
{
	if(!PlayerInfo[playerid][pDonater] && !PlayerInfo[playerid][pAdmin] && !PlayerInfo[playerid][pTester])
		return SendErrorMessage(playerid, "�س����� Donater");

	if(PlayerInfo[playerid][pTogPm])
	{
		PlayerInfo[playerid][pTogPm] = false;
		SendClientMessage(playerid, COLOR_ORANGE, "�س���Դ����Ѻ��ͤ�����ǹ���");
		return 1;
	}
	else
	{
		PlayerInfo[playerid][pTogPm] = true;
		SendClientMessage(playerid, COLOR_ORANGE, "�س��Դ����Ѻ��ͤ�����ǹ���");
	}
	return 1;
}

alias:quit("q")
CMD:quit(playerid, params[])
{
	if(IsPlayerAndroid(playerid))
	{
		CharacterSave(playerid);
		Kick(playerid);
		return 1;
	}
	return 1;
}

CMD:fines(playerid, params[])
{
	new factionid = PlayerInfo[playerid][pFaction];
	
	new tagerid;
	if(factionid != 0)
	{
		if(FactionInfo[factionid][eFactionJob] != POLICE && FactionInfo[factionid][eFactionJob] != SHERIFF)
			return ShowFines(playerid, playerid);

		if(sscanf(params, "i(-1)", tagerid))
			return ShowFines(playerid, playerid);
		
		if(!IsPlayerConnected(tagerid))
			return SendErrorMessage(playerid, "����������������������������");

		if(IsPlayerLogin(tagerid))
			return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");

		ShowFines(playerid, tagerid);
		return 1;
	}
	else ShowFines(playerid, playerid);
	return 1;
}

CMD:helpme(playerid, params[])
{
	if(GetPVarInt(playerid, "HelpmeNows"))
		return SendErrorMessage(playerid, "�س���ա�� Helpme �����");

	
	if(isnull(params) || strlen(params) < 3)
		return SendUsageMessage(playerid, "/helpme <��ͤ���>"); 

	format(PlayerHelpme[playerid], 120, "%s",params);
	new idx;
	
	for (new i = 1; i < sizeof(HelpmeData); i ++)
	{
		if (HelpmeData[i][hHelpmeExit] == false)
		{
			idx = i;
			break; 
		}
	}




	SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: �Ӣͤ�����������ͧ͢�س��١����ѧ�����ŷء������͹�Ź�");
	SetPVarInt(playerid, "HelpmeNows", 1);
	
	new str[60];
	format(str, sizeof(str), "[%s] %s Helpme now", ReturnDate(),ReturnRealName(playerid,0));
	SendDiscordMessageEx("support-chat", str);
			
	OnPlayerHelpme(playerid, idx, PlayerHelpme[playerid]);
	return 1;
}

CMD:setstyle(playerid, params[])
{
	if(!PlayerInfo[playerid][pDonater] && !PlayerInfo[playerid][pAdmin] && !PlayerInfo[playerid][pTester])
		return SendErrorMessage(playerid, "�س����� Donater");

	new fightid;

	if(sscanf(params, "d", fightid))
		return SendUsageMessage(playerid, "/setstyle (1-6)");
	
	if(fightid < 1 || fightid > 6)
		return SendErrorMessage(playerid, "��س�����Ţ���١��ͧ (1-6)");

	switch(fightid)
	{
		case 1:
		{
			PlayerInfo[playerid][pFight] = FIGHT_STYLE_NORMAL;
			SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);
			SendClientMessage(playerid, COLOR_GREY, "�س������¹��ҷҧ������ͧ�س�� ����");
			CharacterSave(playerid);
			return 1;
		}
		case 2:
		{
			PlayerInfo[playerid][pFight] = FIGHT_STYLE_BOXING;
			SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING);
			SendClientMessage(playerid, COLOR_GREY, "�س������¹��ҷҧ������ͧ�س�� �ѡ���");
			CharacterSave(playerid);
			return 1;
		}
		case 3:
		{
			PlayerInfo[playerid][pFight] = FIGHT_STYLE_ELBOW;
			SetPlayerFightingStyle(playerid, FIGHT_STYLE_ELBOW);
			SendClientMessage(playerid, COLOR_GREY, "�س������¹��ҷҧ������ͧ�س�� ���͡");
			CharacterSave(playerid);
			return 1;
		}
		case 4:
		{
			PlayerInfo[playerid][pFight] = FIGHT_STYLE_GRABKICK;
			SetPlayerFightingStyle(playerid, FIGHT_STYLE_GRABKICK);
			SendClientMessage(playerid, COLOR_GREY, "�س������¹��ҷҧ������ͧ�س�� ��꺤ԡ");
			CharacterSave(playerid);
			return 1;
		}
		case 5:
		{
			PlayerInfo[playerid][pFight] = FIGHT_STYLE_KNEEHEAD;
			SetPlayerFightingStyle(playerid, FIGHT_STYLE_KNEEHEAD);
			SendClientMessage(playerid, COLOR_GREY, "�س������¹��ҷҧ������ͧ�س�� ������");
			return 1;
		}
		case 6:
		{
			PlayerInfo[playerid][pFight] = FIGHT_STYLE_KUNGFU;
			SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU);
			SendClientMessage(playerid, COLOR_GREY, "�س������¹��ҷҧ������ͧ�س�� �ѧ��");
			CharacterSave(playerid);
			return 1;
		}
		default:
		{
			PlayerInfo[playerid][pFight] = FIGHT_STYLE_NORMAL;
			SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);
			SendClientMessage(playerid, COLOR_GREY, "�س������¹��ҷҧ������ͧ�س�� ����");
			CharacterSave(playerid);
			return 1;
		}
	}
	return 1;
}


CMD:cigarettes(playerid, params[])
{
	new option[11], secoption;

	if(sscanf(params, "s[11]D(-1)", option, secoption)) 
	{
		SendClientMessageEx(playerid,  -1, "{7e98b6}[!] {a9c4e4}�س�պ�����ӹǹ %d �ǹ", PlayerInfo[playerid][pCigare]);
		SendClientMessage(playerid, -1, "{7e98b6}[!] �����ҹ : {a9c4e4}/cigarettes use, give, drop & /passjoint");
		return 1;
	}

	if(!PlayerInfo[playerid][pCigare])
		return SendErrorMessage(playerid, "�س����պ�����");

	if(CompareStrings(option, "use"))
	{
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "�س��ͧ���躹���");

		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_SMOKE_CIGGY);
		SendNearbyMessage(playerid, 3.2, COLOR_EMOTE, "> %s ��Ժ������͡��˹����ǹ������Ѻ�ش���Ǥպ�����ҡ",ReturnName(playerid,0));
		SendClientMessage(playerid, -1, "{7e98b6}[!] {a9c4e4}�� ENTER ������ش����ٺ������");
		PlayerInfo[playerid][pCigare]--;
		return 1;
	}
	else if(CompareStrings(option, "give"))
	{
		new userid, amount;

		if(sscanf(params, "{s[7]}ud", userid, amount)) 
			return SendClientMessage(playerid, -1, "{7e98b6}[!] �����ҹ : {a9c4e4}/cigarettes give [�ʹռ�����/���ͺҧ��ǹ] [�ӹǹ]");

		if(!IsPlayerConnected(userid))
			return SendErrorMessage(playerid, "������������������͡Ѻ���������");

		if(amount < 1)
			return SendErrorMessage(playerid, "�س��ͧ�кبӹǹ�ҡ���� 1");

		if (PlayerInfo[playerid][pCigare] < amount)
			return SendErrorMessage(playerid, "�س�պ����������§��");
		
		if (!IsPlayerNearPlayer(playerid, userid, 5.0))
			return SendErrorMessage(playerid, "�����蹹��������������س");
		
		if (userid == playerid)
			return SendErrorMessage(playerid, "�س�������ö��������Ѻ����ͧ��");

		PlayerInfo[playerid][pCigare] -= amount;
		PlayerInfo[userid][pCigare] += amount;
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s ��������Ѻ %s", ReturnName(playerid, 0), ReturnName(userid, 0));
		SendClientMessageEx(playerid, -1, "{7e98b6}[!] {a9c4e4}�س��������Ѻ %s �ӹǹ {7e98b6}%d {a9c4e4}�ǹ", ReturnName(userid, 0), amount);
		SendClientMessageEx(userid, -1, "{7e98b6}[!] {a9c4e4}�س���Ѻ������ҡ %s �ӹǹ {7e98b6}%d {a9c4e4}�ǹ", ReturnName(playerid, 0), amount);
		return 1;
	}
	else if(CompareStrings(option, "drop"))
	{
		new slot;

		if (sscanf(params, "{s[7]}d", slot)) 
			return SendClientMessage(playerid, -1, "{7e98b6}[!] �����ҹ : {a9c4e4}/cigarettes drop [�ӹǹ]");
		
		if (PlayerInfo[playerid][pCigare] < slot)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "�س����պ�������§��");

		if (slot < 1)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��ͧ�кبӹǹ�ҡ���� 1");

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s ��駺�����ŧ�����", ReturnRealName(playerid));

		SendClientMessageEx(playerid, -1, "{7e98b6}[!] {a9c4e4}�س���駺�����ӹǹ %d �ǹ", slot);
		SendClientMessage(playerid, -1, "{7e98b6}[!] Hint: {a9c4e4}�س����ö���ͺ�����������ҡ 24/7 �ҡ�س��ͧ���");

		PlayerInfo[playerid][pCigare] -= slot;
		CharacterSave(playerid);
		return 1;
	}
	else SendErrorMessage(playerid, "�س�Ծ���������١��ͧ");

	return 1;
}

CMD:smoke(playerid, params[])
{
    new gesture;
    if(sscanf(params, "d", gesture)) 
		return SendUsageMessage(playerid,"/smoke [1-2]");

	if(!PlayerInfo[playerid][pCigare])
		return SendErrorMessage(playerid, "�س����պ�����");

	switch(gesture)
	{
		case 1: 
		{
			ApplyAnimation(playerid,"SMOKING","M_smk_in",4.1, 0, 1, 1, 1, 1, 1);
		}
		case 2: 
		{
			ApplyAnimation(playerid,"SMOKING","M_smklean_loop",4.1, 0, 1, 1, 1, 1, 1);
		}
		default: return SendUsageMessage(playerid,"/smoke [1-2]");
	}
    return 1;
}

CMD:checkcom(playerid, params[])
{
	new count;
	for(new i = 1; i < MAX_COMPUTER; i++)
	{
		if(!ComputerInfo[i][ComputerDBID])
			continue;

		if(ComputerInfo[i][ComputerOwnerDBID] != PlayerInfo[playerid][pDBID])
			continue;

		count++;
		SendClientMessageEx(playerid, COLOR_GREY, "COMPUTER ID %d: Spawn: %s",ComputerInfo[i][ComputerDBID], (ComputerInfo[i][ComputerSpawn] != 0) ? (""EMBED_GREENMONEY"�ҧ����") : ("�ѧ������ҧ"));
	}

	if(!count)
		return SendClientMessage(playerid, COLOR_GREY, "�س�ѧ����ա�ë��ͤ���������");

	
	return 1;
}

CMD:helpup(playerid, params[])
{
	new tagerid;

	if(sscanf(params, "u", tagerid))
		return SendUsageMessage(playerid, "/helpup <���ͺҧ��ǹ/�ʹ�>");

	if(tagerid == playerid)
		return SendErrorMessage(playerid, "�������ö��Ѻ����ͧ��");

	if(!IsPlayerConnected(tagerid))
		return SendErrorMessage(playerid, "��������������������׿�����");
		
	if(!BitFlag_Get(gPlayerBitFlag[tagerid], IS_LOGGED))
		return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");
		
	if(!IsPlayerNearPlayer(playerid, tagerid, 2.5))
		return SendErrorMessage(playerid, "������������������س");

	if(GetPlayerTeam(playerid) == PLAYER_STATE_DEAD || GetPlayerTeam(playerid) == PLAYER_STATE_WOUNDED)
		return SendErrorMessage(playerid, "�س�������ö��������ͧ�ҡ�س�ͧ������Ҿ��ҧ���������� ��е�ͧ��á���ѡ�����ҧ��ǹ�蹡ѹ");

	
	if(GetPlayerTeam(tagerid) == PLAYER_STATE_ALIVE)
		return SendErrorMessage(playerid, "������������Ѻ�Ҵ�红�Ҵ������ª��Ե");

	if(GetPlayerTeam(tagerid) == PLAYER_STATE_DEAD)
		return SendErrorMessage(playerid, "���������ª��Ե����");

	if(PlayerHelpUp[tagerid])
		return SendErrorMessage(playerid, "�ա�ê������������...");

	SendClientMessageEx(playerid, -1, "�س���ѧ��������� %s ������Ѻ����͡��˹ ������ҧ��ê��������", ReturnName(tagerid,0));
	PlayerHelpUp[tagerid] = true;
	SetTimerEx("HelpUpPLayer", 15000, false, "dd",playerid, tagerid);
	return 1;
}

CMD:id(playerid, params[])
{
	new tagerid;

	if(sscanf(params, "u", tagerid))
		return SendUsageMessage(playerid, "/id <���ͺҧ��ǹ/�ʹ�>");

	if(!IsPlayerConnected(tagerid))
		return SendErrorMessage(playerid, "��������������������׿�����");
		
	if(!BitFlag_Get(gPlayerBitFlag[tagerid], IS_LOGGED))
		return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");

	SendClientMessageEx(playerid, COLOR_GREY, "[ID: %d] ����: %s ��蹼�ҹ: %s", tagerid,ReturnRealName(tagerid,0), (IsPlayerAndroid(tagerid)) ? ("Android") : ("PC"));
	return 1;
}

CMD:setstation(playerid, params[])
{
	new option[15],url[400], secstr[150];

	if(sscanf(params, "s[15]S()[150]", option,secstr)) 
	{
		SendUsageMessage(playerid, "/setstation <option>");
		SendClientMessage(playerid, -1, "��駤�����Ѻ����ŧ: https://vocaroo.com/upload");
		SendClientMessage(playerid, -1, "�Ըա������ �ѻ��Ŵ�ŧ����ͧ��èҡ����������ͧ�سŧ����駤���");
		SendClientMessage(playerid, -1, "��й���駤����������㹡���Դ�ŧ");
		SendClientMessage(playerid, COLOR_GREY, "OPTION: Close Open");
		return 1;
	}

	if(!strcmp(option, "close", true))
	{
		if(PlayerInfo[playerid][pInsideProperty])
		{
			new id = PlayerInfo[playerid][pInsideProperty];

			foreach(new i : Player)
			{
				if(PlayerInfo[i][pInsideProperty] != PlayerInfo[playerid][pInsideProperty])
					continue;

				StopAudioStreamForPlayer(i);
			}

			HouseInfo[id][HouseMusic] = true;
			format(HouseInfo[id][HouseMusicLink], 150, "");
			SendNearbyMessage(playerid, 30.5, COLOR_EMOTE, "> %s ��Դ����ͧ����Է��", ReturnName(playerid,0));
			return 1;
		}
		if(GetPlayerVehicleID(playerid) != 0)
		{
			foreach(new i : Player)
			{
				if(GetPlayerVehicleID(i) != GetPlayerVehicleID(playerid))
					continue;

				StopAudioStreamForPlayer(i);
			}
			new vehicleid = GetPlayerVehicleID(playerid);
			VehicleInfo[vehicleid][eVehicleMusic] = false;
			format(VehicleInfo[vehicleid][eVehicleMusicLink],1,"");
			SendNearbyMessage(playerid, 30.5, COLOR_EMOTE, "> %s ��Դ����ͧ����Է��", ReturnName(playerid,0));
			return 1;
		}
		else if(PlayerInfo[playerid][pInsideBusiness])
		{
			new id = PlayerInfo[playerid][pInsideBusiness];

			foreach(new i : Player)
			{
				if(PlayerInfo[i][pInsideBusiness] != PlayerInfo[playerid][pInsideBusiness])
					continue;

				StopAudioStreamForPlayer(i);
			}

			BusinessInfo[id][BusinessMusic] = true;
			format(BusinessInfo[id][BusinessMusicLink], 150, "");
			SendNearbyMessage(playerid, 30.5, COLOR_EMOTE, "> %s ��Դ����ͧ����Է��", ReturnName(playerid,0));
			return 1;
		}
		else if(PlayerInfo[playerid][pBoomBoxSpawnID] && !PlayerInfo[playerid][pInsideBusiness] && !PlayerInfo[playerid][pInsideProperty])
		{
			new id = PlayerInfo[playerid][pBoomBoxSpawnID];
			if(IsPlayerInRangeOfPoint(playerid, 2.5, BoomBoxInfo[id][BoomBoxPos][0], BoomBoxInfo[id][BoomBoxPos][1], BoomBoxInfo[id][BoomBoxPos][2]))
			{
				foreach(new i : Player)
				{
					if(!IsPlayerInRangeOfPoint(i, 35.0, BoomBoxInfo[id][BoomBoxPos][0], BoomBoxInfo[id][BoomBoxPos][1], BoomBoxInfo[id][BoomBoxPos][2]))
						continue;

					StopAudioStreamForPlayer(i);
				}
			}
			SendNearbyMessage(playerid, 15.5, COLOR_EMOTE, "> %s ��Դʶҹ��Է��", ReturnName(playerid,0));
		}
		else SendErrorMessage(playerid, "�س����������� ��ҹ / �Ԩ��� / BoomBox");
	}
	else if(!strcmp(option, "open", true))
	{
		if(sscanf(secstr, "s[400]",url))
			return SendUsageMessage(playerid, "/setstaion <open> <url>");
	
		if(PlayerInfo[playerid][pInsideProperty])
		{
			new id = PlayerInfo[playerid][pInsideProperty];

			if(strlen(url) < 5)
				return SendErrorMessage(playerid, "��س������駤���١��ͧ");

			foreach(new i : Player)
			{
				if(PlayerInfo[i][pInsideProperty] != PlayerInfo[playerid][pInsideProperty])
					continue;

				StopAudioStreamForPlayer(i);
				PlayAudioStreamForPlayer(i, url);
			}

			HouseInfo[id][HouseMusic] = true;
			format(HouseInfo[id][HouseMusicLink], 150, "%s",url);
			SendNearbyMessage(playerid, 30.5, COLOR_EMOTE, "> %s ������¹ʶҹ��Է��", ReturnName(playerid,0));
			return 1;
		}
		else if(GetPlayerVehicleID(playerid) != 0)
		{
			if(HasNoEngine(GetPlayerVehicleID(playerid)))
				return SendErrorMessage(playerid, "���������ͧ¹��");

			if(!VehicleInfo[GetPlayerVehicleID(playerid)][eVehicleEngineStatus])
				return SendErrorMessage(playerid, "��ͧ�Դ����ͧ¹���͹");

			if(strlen(url) < 5)
				return SendErrorMessage(playerid, "��س������駤���١��ͧ");

			foreach(new i : Player)
			{
				if(GetPlayerVehicleID(i) != GetPlayerVehicleID(playerid))
					continue;

				StopAudioStreamForPlayer(i);
				PlayAudioStreamForPlayer(i, url);
			}
			new vehicleid = GetPlayerVehicleID(playerid);
			VehicleInfo[vehicleid][eVehicleMusic] = true;
			format(VehicleInfo[vehicleid][eVehicleMusicLink], 150, "%s",url);
			SendNearbyMessage(playerid, 30.5, COLOR_EMOTE, "> %s ������¹ʶҹ��Է��", ReturnName(playerid,0));
			return 1;
		}
		else if(PlayerInfo[playerid][pInsideBusiness])
		{
			new id = PlayerInfo[playerid][pInsideBusiness];

			if(strlen(url) < 5)
				return SendErrorMessage(playerid, "��س������駤���١��ͧ");


			if(BusinessInfo[id][BusinessOwnerDBID] != PlayerInfo[playerid][pDBID])
				return SendErrorMessage(playerid, "�س�������Ңͧ�Ԩ��ù��");

			foreach(new i : Player)
			{
				if(PlayerInfo[i][pInsideBusiness] != PlayerInfo[playerid][pInsideBusiness])
					continue;

				StopAudioStreamForPlayer(i);
				PlayAudioStreamForPlayer(i, url);
			}

			BusinessInfo[id][BusinessMusic] = true;
			format(BusinessInfo[id][BusinessMusicLink], 150, "%s",url);
			SendNearbyMessage(playerid, 30.5, COLOR_EMOTE, "> %s ������¹ʶҹ��Է��", ReturnName(playerid,0));
		}
		else if(PlayerInfo[playerid][pBoomBoxSpawnID] && !PlayerInfo[playerid][pInsideBusiness] && !PlayerInfo[playerid][pInsideProperty])
		{
			new id = PlayerInfo[playerid][pBoomBoxSpawnID];
			if(IsPlayerInRangeOfPoint(playerid, 2.5, BoomBoxInfo[id][BoomBoxPos][0], BoomBoxInfo[id][BoomBoxPos][1], BoomBoxInfo[id][BoomBoxPos][2]))
			{
				foreach(new i : Player)
				{
					if(!IsPlayerInRangeOfPoint(i, 35.0, BoomBoxInfo[id][BoomBoxPos][0], BoomBoxInfo[id][BoomBoxPos][1], BoomBoxInfo[id][BoomBoxPos][2]))
						continue;

					StopAudioStreamForPlayer(i);
					PlayAudioStreamForPlayer(i, url, BoomBoxInfo[id][BoomBoxPos][0], BoomBoxInfo[id][BoomBoxPos][1], BoomBoxInfo[id][BoomBoxPos][2], 35.0,1);
				}
				SendNearbyMessage(playerid, 15.5, COLOR_EMOTE, "> %s ������¹ʶҹ��Է��", ReturnName(playerid,0));
				return 1;
			}
		}
		else SendErrorMessage(playerid, "�س����������� ��ҹ / �Ԩ��� / BoomBox");
	}
	else SendErrorMessage(playerid, "��سҾԾ�����١��ͧ");
    return 1;
}

CMD:close(playerid, params[])
{
	if(PlayerInfo[playerid][pGUI] != 6)
		return 1;

	PlayerInfo[playerid][pGUI] = 6;
	MenuStore_Close(playerid);
	return 1;
}


CMD:frisk(playerid, params[])
{
	/*if(GetPlayerTeam(playerid) != PLAYER_STATE_ALIVE)
		return SendErrorMessage(playerid, "�س�������ö�����觹����㹢�з��س����������ʶҳл���");*/

	new tagerid, option[20];
	if(sscanf(params, "uS()[20]", tagerid, option))
		return SendUsageMessage(playerid, "/frisk <���ͺҧ��ǹ/�ʹ�>");

	/*if(GetPlayerTeam(tagerid) != PLAYER_STATE_ALIVE)
		return SendErrorMessage(playerid, "�س�������ö�����觹�����ҡ�������ա��������������ʶҳл���");*/

	if(FriskInfo[playerid][Frisk_ID] != INVALID_PLAYER_ID)
	{
		if(!IsPlayerNearPlayer(playerid, FriskInfo[playerid][Frisk_ID], 3.5))
		{
			FriskInfo[playerid][Frisk_ID] = 0;

			if(!IsPlayerConnected(tagerid))
				return SendErrorMessage(playerid, "��������������������������");

			if(IsPlayerLogin(playerid))
				return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");

			if(!IsPlayerNearPlayer(playerid, tagerid, 3.5))
				return SendErrorMessage(playerid, "������������������س");

			FriskInfo[playerid][Frisk_ID] = tagerid;
			FriskInfo[tagerid][Frisk_BY] = playerid;
			SendClientMessageEx(tagerid, COLOR_LIGHTRED, "%s ��ͤ����㹵�Ǣͧ�س /frisk %d yes �ҡ�س����Ѻ",playerid,ReturnName(playerid,0));
			SendClientMessageEx(playerid, COLOR_GREY, "�س��ͤ鹵�Ǣͧ %s",ReturnName(tagerid,0));
			return 1;
		}
		else SendErrorMessage(playerid, "�س�ѧ�դӢͤ鹵���ա������");
	}
	else
	{
		if(!IsPlayerConnected(tagerid))
		return SendErrorMessage(playerid, "��������������������������");

		if(IsPlayerLogin(playerid))
			return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");

		if(!IsPlayerNearPlayer(playerid, tagerid, 3.5))
			return SendErrorMessage(playerid, "������������������س");

		if(tagerid == FriskInfo[playerid][Frisk_BY])
		{
			if(!strcmp(option, "no", true))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "�س�黯��ʸ %s 㹡�ä����㹵�Ǣͧ�س",ReturnName(tagerid,0));
				SendClientMessageEx(tagerid, COLOR_GREY, "%s ����ʸ㹡�ä�����㹵��", ReturnName(playerid,0));


				FriskInfo[playerid][Frisk_ID] = INVALID_PLAYER_ID;
				FriskInfo[playerid][Frisk_BY] = INVALID_PLAYER_ID;
				FriskInfo[tagerid][Frisk_ID] = INVALID_PLAYER_ID;
				FriskInfo[tagerid][Frisk_BY] = INVALID_PLAYER_ID;
				return 1;
			}
			else if(!strcmp(option, "yes", true))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "�س������Ѻ��� %s �����㹵�Ǣͧ�س",ReturnName(tagerid,0));
				SendClientMessageEx(tagerid, COLOR_HELPME, "�س�������������㹵�Ǣͧ %s", ReturnName(playerid,0));

				ShowInvPlayer(tagerid, playerid);

				FriskInfo[playerid][Frisk_ID] = INVALID_PLAYER_ID;
				FriskInfo[playerid][Frisk_BY] = INVALID_PLAYER_ID;
				FriskInfo[tagerid][Frisk_ID] = INVALID_PLAYER_ID;
				FriskInfo[tagerid][Frisk_BY] = INVALID_PLAYER_ID;
			}
			else SendErrorMessage(playerid, "������١��ͧ (yes or no)");
			return 1;
		}

		FriskInfo[playerid][Frisk_ID] = tagerid;
		FriskInfo[tagerid][Frisk_BY] = playerid;
		SendClientMessageEx(tagerid, COLOR_LIGHTRED, "%s ��ͤ����㹵�Ǣͧ�س /frisk %d yes �ҡ�س����Ѻ",ReturnName(playerid,0),playerid);
		SendClientMessageEx(playerid, COLOR_GREY, "�س��ͤ鹵�Ǣͧ %s",ReturnName(tagerid,0));
	}
	return 1;
}

CMD:walkstyle(playerid, params[])
{
	if(!PlayerInfo[playerid][pDonater] && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "�س����� Donater");

	new id;

	if(sscanf(params, "d", id))
		return SendUsageMessage(playerid, "/walkstyle <1-18>");

	if(id < 1 || id > 18)
		return SendErrorMessage(playerid, "�س����������Ţ ��ҷҧ����Թ���١��ͧ (1-18)");

	PlayerInfo[playerid][pWalk] = id;

	Player_SetWalkingStyle(playerid, id);
	SendClientMessageEx(playerid, COLOR_GREY, "�س���駤�ҷ�ҷҧ����Թ�ͧ�س价�� %d",id);
	return 1;
}

CMD:walk(playerid, params[])
{
	switch(PlayerInfo[playerid][pWalk])
	{
		case 1: ApplyAnimation(playerid,"PED","WALK_gang1",4.1,1,1,1,1,1);
		case 2: ApplyAnimation(playerid,"PED","WOMAN_walksexy",4.1,1,1,1,1,1);
		case 3: ApplyAnimation(playerid,"PED","WALK_armed",4.1,1,1,1,1,1);
		case 4: ApplyAnimation(playerid,"PED","WALK_civi",4.1,1,1,1,1,1);
		case 5: ApplyAnimation(playerid,"PED","WALK_csaw",4.1,1,1,1,1,1);
		case 6: ApplyAnimation(playerid,"PED","WALK_gang2",4.1,1,1,1,1,1);
		case 7: ApplyAnimation(playerid,"PED","WALK_drunk",4.1,1,1,1,1,1);
		case 8: ApplyAnimation(playerid,"PED","WALK_fat",4.1,1,1,1,1,1);
		case 9: ApplyAnimation(playerid,"PED","WALK_fatold",4.1,1,1,1,1,1);
		case 10: ApplyAnimation(playerid,"PED","WALK_old",4.1,1,1,1,1,1);
		case 11: ApplyAnimation(playerid,"PED","WALK_player",4.1,1,1,1,1,1);
		case 12: ApplyAnimation(playerid,"PED","WALK_rocket",4.1,1,1,1,1,1);
		case 13: ApplyAnimation(playerid,"PED","WALK_shuffle",4.1,1,1,1,1,1);
		case 14: ApplyAnimation(playerid,"PED","WOMAN_walknorm",4.1,1,1,1,1,1);
		case 15: ApplyAnimation(playerid,"PED","WOMAN_walkpro",4.1,1,1,1,1,1);
		case 16: ApplyAnimation(playerid,"PED","WOMAN_walkbusy",4.1,1,1,1,1,1);
		case 17: ApplyAnimation(playerid,"PED","WOMAN_walknorm",4.1,1,1,1,1,1);
		case 18: ApplyAnimation(playerid,"PED","Walk_Wuzi",4.1,1,1,1,1,1);
		default: ApplyAnimation(playerid,"PED","WALK_player",4.1,1,1,1,1,1);
	}
	return 1;
}

CMD:tackle(playerid, params[]) {
	if(GetPVarType(playerid, "TacklingMode")) {
		SendClientMessage(playerid, COLOR_LIGHTRED, "[ ! ] "EMBED_WHITE"���������һзж١�Դ");
		DeletePVar(playerid, "TacklingMode");
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "[ ! ] "EMBED_WHITE"���������һзж١�Դ");
		SendClientMessage(playerid, COLOR_LIGHTRED, "�ҡ�س�����ѡ�� �ѹ���繡�þ�������һз�");
		SendClientMessage(playerid, COLOR_LIGHTRED, "�����蹷��س�������Ѻ��ͤ��� �ʴ������繡�þ�����������һзй��");
		SendClientMessage(playerid, COLOR_LIGHTRED, "������ж١����ѧ᪷�����������������͹����ǡѺ��þ�����");
		SendClientMessage(playerid, COLOR_LIGHTRED, "�س�ж١�ѧ�Ѻ������͹�����蹡��ⴴ������ͻ�ͧ�ѹ��þ�������觼Դ��Ҵ");
		SendClientMessage(playerid, COLOR_LIGHTRED, "�ҡ�����蹹�������蹺������һз� ��§ҹ�����������");
		SetPVarInt(playerid, "TacklingMode", 1);
	}
	return 1;
}

CMD:coin(playerid, params[])
{
	new str[128];
	format(str, sizeof(str), "> %s ��ԡ����­ŧ�������ѹ�͡%s", ReturnRealName(playerid), (random(2)) ? ("���") : ("����"));
    SendNearbyMessage(playerid, 15.0, COLOR_EMOTE, str);
	return 1;
	
}

CMD:shakehand(playerid, params[])
{
	new targetid, type;

	if(sscanf(params, "ui", targetid, type))
	    return SendUsageMessage(playerid, "/shakehand <���ͺҧ��ǹ/�ʹ�> <������ (1-6)>");

	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 1.5))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "����������������������������/����������������س");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "�س�������ö�����觹��Ѻ��Ǥس�ͧ��");
	}

	if(PlayerInfo[playerid][pShakeOffer] != INVALID_PLAYER_ID)
	{
		new offeredby = PlayerInfo[playerid][pShakeOffer];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "������ա���觢ͤ������س");
	    }

	    ClearAnimations(playerid);
		ClearAnimations(offeredby);

		SetPlayerToFacePlayer(playerid, offeredby);
		SetPlayerToFacePlayer(offeredby, playerid);

		switch(PlayerInfo[playerid][pShakeType])
		{
		    case 1:
		    {
				ApplyAnimation(playerid,  "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(offeredby, "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 2:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(offeredby, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 3:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(offeredby, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 4:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(offeredby, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 5:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(offeredby, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 6:
			{
			    ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0);
			    ApplyAnimation(offeredby, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0);
			}
		}
  		PlayerInfo[playerid][pShakeOffer] = INVALID_PLAYER_ID;
		return 1;
	}

	if(!(1 <= type <= 6))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "�س���͡���������١��ͧ 1-6 ��ҹ��");
	}

	PlayerInfo[targetid][pShakeOffer] = playerid;
	PlayerInfo[targetid][pShakeType] = type;

	SendClientMessageEx(targetid, COLOR_WHITE, "** %s ��ͧ��÷��ШѺ��͡Ѻ�س (/shakehand %d)", ReturnName(playerid, 0), playerid);
	SendClientMessageEx(playerid, COLOR_WHITE, "** �س���觤Ӣ͡�èѺ��͡Ѻ %s", ReturnName(targetid, 0));
	return 1;
}

CMD:isafk(playerid, params[])
{
	new 
		playerb;
		
	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/isafk <���ͺҧ��ǹ/�ʹ�>");
		
	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "����������������������������");
	
	if(IsAfk{playerb})
		SendClientMessageEx(playerid, COLOR_GREY, "%s AFK %d �Թҷ�", ReturnName(playerb), AFKCount[playerb]);
		
	else SendClientMessageEx(playerid, COLOR_GREY, "����������� AFK.", ReturnName(playerb)); 

	return 1;
}

CMD:meal(playerid, params[])
{
	new
	    type[24],
		menuid,
		value;

	if (sscanf(params, "s[24]D()D()", type, menuid, value))
 	{
	    SendClientMessage(playerid, COLOR_GRAD3, "Available commands:");
	    SendClientMessage(playerid, -1, "{FF6347}/meal order "EMBED_WHITE"- �Դ������������");
        SendClientMessage(playerid, -1, "{FF6347}/meal place "EMBED_WHITE"- �ҡ�س���ѧ��ͶҴ����� �س����ö�ҧ�ѹ�������");
        SendClientMessage(playerid, -1, "{FF6347}/meal pickup "EMBED_WHITE"- �س����ö��Ժ�Ҵ����âͧ�س����ҧ������");
        SendClientMessage(playerid, -1, "{FF6347}/meal throw "EMBED_WHITE"- �¹�Ҵ����÷��");
		return 1;
	}
	if (!strcmp(type, "order", true))
	{	
		callcmd::eat(playerid, "");
	}
	else if (!strcmp(type, "place", true))
	{
		if(MealOder[playerid] == false || PlayerInfo[playerid][pObject][9] != INVALID_OBJECT_ID)
			return SendErrorMessage(playerid, "�س�ѧ������������� / �����նҴ����÷���ѧ�������");
		
		if(IsPlayerAttachedObjectSlotUsed(playerid, 9))
			RemovePlayerAttachedObject(playerid, 9);

		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		PlayerInfo[playerid][pObject][9] = CreateDynamicObject(2222, x, y, z, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
		EditDynamicObject(playerid, PlayerInfo[playerid][pObject][9]);
		SetPVarInt(playerid, "MealEditPosObj", 1);

		return 1;
	}
	else if (!strcmp(type, "pickup", true))
	{
		new Float:x, Float:y, Float:z;
		GetDynamicObjectPos(PlayerInfo[playerid][pObject][9], x, y, z);

		if(!IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z))
		{
			return SendErrorMessage(playerid, "�س������������Ҵ����âͧ�س");
		}

		if(IsValidDynamicObject(PlayerInfo[playerid][pObject][9]))
            DestroyDynamicObject(PlayerInfo[playerid][pObject][9]);
		
		GetMealOder(playerid);
		return 1;
	}
	else if (!strcmp(type, "throw", true))
	{
		if(MealOder[playerid] == false)
			return SendErrorMessage(playerid, "�س�ѧ������������� / �����նҴ����÷���ѧ�������");

		if(IsPlayerAttachedObjectSlotUsed(playerid, 9))
			RemovePlayerAttachedObject(playerid, 9);
		
		MealOder[playerid] = false;
		SendNearbyMessage(playerid, 3.0, COLOR_EMOTE, "> %s �¹�Ҵ����÷��",ReturnName(playerid,0));
		return 1;
	}
	else SendErrorMessage(playerid, "�Ծ���������١��ͧ");
	return 1;
}

alias:hidehud("toghud")
CMD:hidehud(playerid, params[])
{
	if(GetPVarInt(playerid, "HideHud"))
	{
		ShowHudVehicle(playerid, false);
		DeletePVar(playerid, "HideHud");
		
	}
	else
	{
		SetPVarInt(playerid, "HideHud", 1);
		ShowHudVehicle(playerid, true);
	}
	return 1;
}

CMD:dice(playerid, params[])
{
	new str[128];
	format(str, sizeof(str), "> %s ����١�������ѹ�͡ %d", ReturnRealName(playerid), random(6)+1);
    SendNearbyMessage(playerid, 15.0, COLOR_EMOTE, str);
	return 1;
}

CMD:rnumber(playerid, params[])
{
	new
	    rmin,
	    rmax,
		emote[128],
		str[128];

	if (sscanf(params, "dds[128]", rmin, rmax, emote))
	    return SendSyntaxMessage(playerid, "/rnumber <min> <max> [������]");

	if(rmin >= rmax) {
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "����Ţ����ش��ͧ���¡��ҵ���Ţ�٧�ش");
	}

	format(str, sizeof(str), "> %s %s %d (( %d �֧ %d ))", ReturnRealName(playerid), emote, randomEx(rmin, rmax), rmin, rmax);
    SendNearbyMessage(playerid, 30.0, COLOR_EMOTE, str);
	return 1;
}

alias:whisper("w")
CMD:whisper(playerid, params[])
{
	new tagerid, text[128];

	if(sscanf(params, "us[128]", tagerid, text))
	    return SendSyntaxMessage(playerid, "/(w)hisper <�ʹռ�����/���ͺҧ��ǹ> <��ͤ���>");
	
	if(!IsPlayerConnected(tagerid))
		return SendErrorMessage(playerid, "����������������������������");
	
	if (!IsPlayerNearPlayer(playerid, tagerid, 3.0))
	    return SendErrorMessage(playerid,"�����蹹��������������س");
	
	if (tagerid == playerid)
		return SendErrorMessage(playerid, "�س�������ö��ЫԺ�Ѻ����ͧ��");
	

	if (strlen(text) > 80) {
	    SendClientMessageEx(tagerid, COLOR_YELLOW, "%s ��ЫԺ: %.80s", ReturnRealName(playerid), text);
	    SendClientMessageEx(tagerid, COLOR_YELLOW, "... %s **", text[80]);

	    SendClientMessageEx(playerid, COLOR_YELLOW, "��ЫԺ�֧ %s", ReturnRealName(tagerid));
	}
	else {
	    SendClientMessageEx(tagerid, COLOR_YELLOW, "%s ��ЫԺ: %s", ReturnRealName(playerid), text);
	    SendClientMessageEx(playerid, COLOR_YELLOW, "��ЫԺ�֧ %s", ReturnRealName(tagerid));
	}
	//format(text, sizeof(text), "��ЫԺ %s: %s", ReturnPlayerName(userid), text);
	//SQL_LogChat(playerid, "/w", text);
	
	format(text, sizeof(text), "%s ����Ӻҧ���ҧ", ReturnRealName(playerid));
	SetPlayerChatBubble(playerid, text, COLOR_PURPLE, 30.0, 6000);
	return 1;
}


CMD:cw(playerid, params[])
{
	new text[128], vehicle = GetPlayerVehicleID(playerid);

    if (sscanf(params, "s[128]", text))
	    return SendSyntaxMessage(playerid, "/(cw)hisper [��ͤ���]");

	if (!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_GRAD1, "�س��������躹ö!");

	foreach (new i : Player)
	{
	    if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == vehicle) {
		    if (strlen(text) > 80) {
			    SendClientMessageEx(i, 0xD7DFF3AA, "%s %s �ٴ���: %.80s", (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) ? ("���Ѻ"): ("��������"), ReturnRealName(playerid), text);
			    SendClientMessageEx(i, 0xD7DFF3AA, "... %s", text[80]);
			}
			else {
			    SendClientMessageEx(i, 0xD7DFF3AA, "%s %s �ٴ���: %s", (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) ? ("���Ѻ"): ("��������"), ReturnRealName(playerid), text);
			}
		}
	}

	//SQL_LogChat(playerid, "/cw", text);
	return 1;
}


CMD:guied(playerid, params[])
{
	ShowPlayerGuid(playerid);
	return 1;
}


CMD:pullincar(playerid, params[])
{
	new
		userid,
		seatname[16],
		vehicleid = GetNearestVehicle(playerid);

	if (sscanf(params, "us[16]", userid, seatname))
	    return SendSyntaxMessage(playerid, "/pullincar [�ʹռ�����/���ͺҧ��ǹ] [fr (˹�Ң��) / bl (��ѧ����) / br (��ѧ���)]");

	if(!IsPlayerConnected(userid))
		return SendErrorMessage(playerid, "�������������������������");
	
	if(userid == playerid) return SendClientMessage(playerid, COLOR_GRAD2, "�س�������ö�¹����ͧ��");

	if (vehicleid == INVALID_VEHICLE_ID)
	    return SendClientMessage(playerid, COLOR_GRAD2, "�س�������������ҹ��˹�� �");
	    
    if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD2, "�س����������������蹹��");

	if (GetVehicleMaxSeats(vehicleid) < 2)
  	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������ö�֧��Ǽ����蹹����ҹ��˹й����");

	new seatid = -1;
	if(!strcmp(seatname, "˹�Ң��", true) || !strcmp(seatname, "fr", true)) {
	    if ((seatid = GetAvailableSeat(vehicleid, 1)) == -1) return SendClientMessage(playerid, COLOR_LIGHTRED, "����觹�������ҧ");
	}
	else if(!strcmp(seatname, "��ѧ����", true) || !strcmp(seatname, "bl", true)) {
	    if ((seatid = GetAvailableSeat(vehicleid, 2)) == -1) return SendClientMessage(playerid, COLOR_LIGHTRED, "����觹�������ҧ");
	}
	else if(!strcmp(seatname, "��ѧ���", true) || !strcmp(seatname, "br", true)) {
	    if ((seatid = GetAvailableSeat(vehicleid, 3)) == -1) return SendClientMessage(playerid, COLOR_LIGHTRED, "����觹�������ҧ");
	}
	else {
		return SendSyntaxMessage(playerid, "/pullincar [�ʹռ�����/���ͺҧ��ǹ] [fr (˹�Ң��) / bl (��ѧ����) / br (��ѧ���)]");
	}

	PutPlayerInVehicle(userid, vehicleid, seatid);
	return 1;
}

CMD:eject(playerid, params[]) {
	new
		targetID;

	if(sscanf(params, "u", targetID))
		return SendSyntaxMessage(playerid, "/eject [�ʹռ�����/���ͺҧ��ǹ]");

	if(!IsPlayerConnected(targetID))
		return SendErrorMessage(playerid, "�������������������������");

	if(targetID == playerid) return SendClientMessage(playerid, COLOR_GRAD2, "�س�������ö������ͧ��");
	    
	if(GetPlayerState(playerid) == 2) {
		if(GetPlayerVehicleID(playerid) == GetPlayerVehicleID(targetID)) {

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ���ѡ %s �͡�ҡ��˹�", ReturnRealName(playerid), ReturnRealName(targetID));
			RemovePlayerFromVehicle(targetID);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "�����蹹��������������㹾�˹�");
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "�س��ͧ�����ʶҹм��Ѻö");
	
	return 1;
}

randomEx(min, max)
{
    new rand = random(max-min)+min;
    return rand;
}

stock ShowInvPlayer(tagerid, playerid)
{
	new weapon_id[2][13];

	SendClientMessageEx(tagerid, -1, "FRISK : %s",ReturnName(playerid,0));

	ReturnLicenses(playerid, tagerid);

	if(PlayerInfo[playerid][pCash] > 500)
	{
		SendClientMessage(tagerid, -1, "�Թ���㹵��: �ҡ���� $500");
	}
	else SendClientMessage(tagerid, -1, "�Թ���㹵��: ���¡��� $500");

	SendClientMessage(tagerid, COLOR_DARKGREEN, "______________WEAPONS_____________"); 
	for(new i = 0; i < 13; i++)
	{
		GetPlayerWeaponData(playerid, i, weapon_id[0][i], weapon_id[1][i]); 
		
		if(!weapon_id[0][i])
			continue;
			
		SendClientMessageEx(tagerid, COLOR_GRAD1, "%s", ReturnWeaponName(weapon_id[0][i]), weapon_id[1][i]); 
	}

	if(PlayerInfo[playerid][pDrug][0] && PlayerInfo[playerid][pDrug][1] && PlayerInfo[playerid][pDrug][2])
	{
		SendClientMessage(tagerid, COLOR_GREY, "�����ʾ�Դ���㹵��");
	}
	else SendClientMessage(tagerid, COLOR_GREY, "��������ʾ�Դ���㹵��");
	return 1;
}

forward HelpUpPLayer(playerid, tagerid);
public HelpUpPLayer(playerid, tagerid)
{
	if(GetPlayerTeam(playerid) == PLAYER_STATE_DEAD || GetPlayerTeam(playerid) == PLAYER_STATE_WOUNDED)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "��ê�������������������ͧ�ҡ�س�����ª��Ե��͹");
		PlayerHelpUp[tagerid] = false;
		return 1;
	}

	if(GetPlayerTeam(tagerid) == PLAYER_STATE_ALIVE)
	{
		PlayerHelpUp[tagerid] = false;
		return SendErrorMessage(playerid, "������������Ѻ�Ҩ�红�Ҵ������ª��Ե");
	}

	if(GetPlayerTeam(tagerid) == PLAYER_STATE_DEAD)
	{
		SendErrorMessage(playerid, "���������ª��Ե����");
		PlayerHelpUp[tagerid] = false;
		return 1;
	}

	if(!IsPlayerNearPlayer(playerid, tagerid, 2.5))
	{
		PlayerHelpUp[tagerid] = false;
		return SendErrorMessage(playerid, "������������������س");
	}

	SetPlayerTeam(tagerid, PLAYER_STATE_ALIVE); 
	SetPlayerHealth(tagerid, 10); 
	TogglePlayerControllable(tagerid, 1); 
	SetPlayerWeather(tagerid, globalWeather);  
	PlayerHelpUp[tagerid] = false;
	SendNearbyMessage(playerid, 3.5, COLOR_EMOTE, "> %s �����Һ�����ͧ�����Ѻ %s",ReturnName(playerid,0), ReturnName(tagerid,0));

	new str[150];
	format(str, sizeof(str), "%s Helpup %s", ReturnRealName(playerid,0), ReturnRealName(tagerid,0));
	SendDiscordMessage("death", str);
	return 1;
}



stock OnPlayerHelpme(playerid, reportid, text[])
{
	if(HelpmeData[reportid][hHelpmeExit] == true)
	{
		for (new i = 1; i < sizeof(PlayerHelpme); i ++)
		{
			if(HelpmeData[i][hHelpmeExit] == false)
			{
				reportid = i;
				break;
			}
		}
	}
	
	HelpmeData[reportid][hHelpmeDBID] = reportid;
	HelpmeData[reportid][hHelpmeExit] = true;
		
	format(HelpmeData[reportid][hHelpmeDetel], 90, "%s", text);
	HelpmeData[reportid][hHelpmeBy] = playerid;
		
	SendTesterMessageEx(COLOR_YELLOWEX, "%s(ID: %d) �ͤ������������: %.40s... ����ö�Ѻ���¡�� /helpmes accept %d �����Ѻ", ReturnRealName(playerid,0), playerid, HelpmeData[reportid][hHelpmeDetel], HelpmeData[reportid][hHelpmeDBID]);
		
	if(strfind(text, "hack", true) != -1 || strfind(text, "cheat", true) != -1)
	{
		foreach(new i : Player)
		{
			if(PlayerInfo[i][pAdmin] || PlayerInfo[i][pTester]) GameTextForPlayer(i, "~y~~h~Priority Report", 4000, 1);
		}
	}
	return 1;
}

stock ClearHelpme(reportid)
{
	HelpmeData[reportid][hHelpmeExit] = false;
	HelpmeData[reportid][hHelpmeDBID] = 0;
    HelpmeData[reportid][hHelpmeBy] = INVALID_PLAYER_ID;
    HelpmeData[reportid][hHelpmeDetel] = ' ';
	return 1;
}


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PlayerInfo[playerid][pGUI] == 6)
	{
		if(RELEASED(KEY_CTRL_BACK))
		{
			PlayerInfo[playerid][pGUI] = 0;
			MenuStore_Close(playerid);
			return 1;
		}
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	new str[120];
	
	for(new i = 1; i < sizeof(HelpmeData); i++)
    {
        if(HelpmeData[i][hHelpmeExit] == true)
        {
			if(HelpmeData[i][hHelpmeBy] == playerid)
			{
				ClearHelpme(i);

				format(str, sizeof(str), "[%s] %s Disconnect Helpme therefore deleted %s",ReturnDate(),ReturnRealName(playerid,0));
				SendDiscordMessageEx("support-chat",str);
				DeletePVar(playerid, "HelpmeNows");
			}
        }
    }

	if(GetPVarInt(playerid, "HideHud"))
        ShowHudVehicle(playerid, false);

	
	return 1;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(issuerid != INVALID_PLAYER_ID)
	{
		if(GetPlayerTeam(playerid) == PLAYER_STATE_ALIVE)
		{
			if(GetPVarType(issuerid, "TacklingMode") && weaponid == 0) 
			{
				SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "> %s ���价�� %s ��о�����������һз����ŧ仹͹�Ѻ���", ReturnRealName(issuerid), ReturnRealName(playerid));
				ApplyAnimation(issuerid, "PED", "EV_dive",4.1,0,1,1,1,0);
				ApplyAnimation(playerid, "PED", "FLOOR_hit_f",4.1,0,1,1,1,0);
				return 0;
			}
		}
	}
	return 1;
}