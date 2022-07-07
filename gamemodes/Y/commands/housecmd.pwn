#include <YSI_Coding\y_hooks>

CMD:housecmds(playerid, params[])
{
    SendClientMessage(playerid, COLOR_DARKGREEN, "____________________HOUSE COMMAND__________________________");

    SendClientMessage(playerid, COLOR_GRAD2,"[HOUSE] /house /buyhouse /sellhouse /lock /placepos /switch /knock /ddo /ds");

    SendClientMessage(playerid, COLOR_GRAD2,"[HOUSE] /renthouse /sethouse /givehousekey");

    SendClientMessage(playerid, COLOR_GREEN,"________________________________________________________________");
    SendClientMessage(playerid, COLOR_GRAD1,"�ô�֡�Ҥ���������������������㹿��������� /helpme ���ͤ͢������������");
    return 1;
}

CMD:house(playerid, params[])
{
    new id = PlayerInfo[playerid][pInsideProperty];

    if(id == 0)
        return SendErrorMessage(playerid, "�س���������㹺�ҹ�ͧ�س");

    if(HouseInfo[id][HouseOwnerDBID] != PlayerInfo[playerid][pDBID])
        return SendErrorMessage(playerid, "�س���������㹺�ҹ�ͧ�س");

    new str[MAX_STRING], longstr[MAX_STRING];

    format(longstr, sizeof(longstr), "��ҹ�Ţ���: %s\n",HouseInfo[id][HouseName]);
    strcat(str, longstr);
    format(longstr, sizeof(longstr), "�ҤҺ�ҹ: %s\n",MoneyFormat(HouseInfo[id][HousePrice]));
    strcat(str, longstr);

    Dialog_Show(playerid, DIALOG_MYHOUSE, DIALOG_STYLE_MSGBOX, "HOUSE:", str, ">>", "");
    return 1;
}

CMD:sethouse(playerid, params[])
{
    new id = PlayerInfo[playerid][pInsideProperty];

    if(!id)
        return SendErrorMessage(playerid, "�س���繨е�ͧ�������㹺�ҹ�ͧ�س");

    if(HouseInfo[id][HouseOwnerDBID] != PlayerInfo[playerid][pDBID])
        return SendErrorMessage(playerid,"��ҹ��ѧ���������ҹ�ͧ�س");

    new str[60], secstr[60];

    if(sscanf(params, "s[60]S()[60]", str, secstr))
    {
        SendUsageMessage(playerid, "/sethouse <option>");
        SendClientMessage(playerid, -1, "OPTION: rentopen , rentprice");
        return 1;
    }

    if(!strcmp(str, "rentopen", true))
    {
        new query[MAX_STRING], count;

        if(HouseInfo[id][HouseRentStats])
        {
            HouseInfo[id][HouseRentStats] = false;
            SendClientMessage(playerid, COLOR_LIGHTRED, "�س��¡��ԡ�ѭ�ҡ����Һ�ҹ��ѧ����͡");

            foreach(new i : Player)
            {
                if(PlayerInfo[i][pDBID] != HouseInfo[id][HouseRent])
                    continue;
                
                SendClientMessageEx(i, COLOR_LIGHTRED, "��ҹ: %s, Los Santos, San Andreas ���ա��¡��ԡ�ѭ�ҡ����Һ�ҹ��ѧ�ѧ���������",HouseInfo[id][HouseName]);
                SendClientMessage(i, COLOR_LIGHTRED, "�ҡ�س����� ��Ңͧ��ҹ��ѧ�ѧ�����������ա�õ�ŧ���ͷӼԴ����ѭ�ҷ��ǡ�س���ѹ������͡��� (IC)");
                SendClientMessage(i, COLOR_LIGHTRED, "�س����ö���͡������ͧ���¹����ͧ�����㹷ѹ�� �¡����駡Ѻ���˹�ҷ����Ǩ���� �ӹѡ�ҹ���Ǩ");
                
                if(PlayerInfo[i][pSpawnHouse] == HouseInfo[id][HouseDBID])
                {
                    PlayerInfo[i][pSpawnPoint] = SPAWN_AT_DEFAULT;
                    PlayerInfo[i][pSpawnHouse] = 0;
                    SendClientMessage(i, -1, "�س��١�絨ش�Դ��Ѻ�ҷ�� ʹ���Թ����!");
                    count++;
                }
            }

            if(!count)
            {
                mysql_format(dbCon, query, sizeof(query), "UPDATE `characters` SET `pSpawnPoint`='0', `pSpawnHouse` = '0' WHERE `char_dbid` = %d", HouseInfo[id][HouseRent]);
                mysql_tquery(dbCon, query);
                
            }
            HouseInfo[id][HouseRent] = 0;
            Savehouse(id);
            return 1;
        }
        else
        {
            if(!HouseInfo[id][HouseRentPrice])
                return SendErrorMessage(playerid, "��ҹ��ѧ����ѧ�����ͧ�Ҥ�㹡�ê��");
              
            HouseInfo[id][HouseRentStats] = true;
            SendClientMessage(playerid, COLOR_LIGHTRED, "�س��ӡ�û���º�ҹ��ѧ���ͧ�س�繡�����");
            Savehouse(id);
        }
        return 1;
    }
    else if(!strcmp(str, "rentprice", true))
    {
        new value;

        if(HouseInfo[id][HouseRent])
            return SendErrorMessage(playerid, "�ѧ�ռ����Һ�ҹ�ͧ�س����");
    
        if(sscanf(secstr, "d", value))
            return SendUsageMessage(playerid, "/sethouse <rentprice> <�ӹǹ������>");

        if(value < 1 || value > 200000)
            return SendErrorMessage(playerid, "�س����ҤҤ����Һ�ҹ���١��ͧ <1-200000>");

        HouseInfo[id][HouseRentPrice] = value;
        SendClientMessageEx(playerid, COLOR_DARKGREEN, "��ҹ: %d %s Los Santos, San Andreas",HouseInfo[id][HouseDBID], HouseInfo[id][HouseName]);
        SendClientMessageEx(playerid, COLOR_DARKGREEN, "���ա�û�Ѻ�ҤҤ����Һ�ҹ��ѧ����� $%s",MoneyFormat(value));
        return 1;
    }
    return 1;
}

CMD:renthouse(playerid, params[])
{
    new bool:Check;
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

            if(!HouseInfo[p][HouseRentStats])
                return SendErrorMessage(playerid, "�س�������ö��Һ�ҹ��ѧ��������ͧ�ҡ��ҹ��ѧ����繺�ҹ��ǹ�ؤ�� ������ա���Դ���������������ҧ�");

            if(HouseInfo[p][HouseRent])
                return SendErrorMessage(playerid, "��ҹ��ѧ����դ��������㹺�ҹ��������");

            if(PlayerInfo[playerid][pDBID] == HouseInfo[p][HouseRent])
                return SendErrorMessage(playerid, "�س����Һ�ҹ��ѧ�����������");

            if(PlayerInfo[playerid][pDBID] == HouseInfo[p][HouseOwnerDBID])
                return SendErrorMessage(playerid, "�س�������ö��Һ�ҹ�ͧ����ͧ��");

            if(PlayerInfo[playerid][pCash] < HouseInfo[p][HouseRentPrice])
                return SendErrorMessage(playerid, "�س���Թ�����§�͵�͡����� �Ҥ���Ҥ�� $%s, (�ѧ�Ҵ���� $%s)",MoneyFormat(HouseInfo[p][HouseRentPrice]), MoneyFormat(HouseInfo[p][HouseRentPrice] - PlayerInfo[playerid][pCash]));

            HouseInfo[p][HouseRent] = PlayerInfo[playerid][pDBID];

            
            GiveMoney(playerid, -HouseInfo[p][HouseRentPrice]);
            
            new total_tax = floatround(HouseInfo[p][HouseRentPrice] * 0.07,floatround_round);

            foreach(new i : Player)
            {
                if(PlayerInfo[i][pDBID] == HouseInfo[p][HouseOwnerDBID])
                {
                    GiveMoney(playerid, HouseInfo[p][HouseRentPrice] - total_tax);
                    GiveMoney(i, HouseInfo[p][HouseRentPrice] - total_tax);
                    GlobalInfo[G_GovCash]+= total_tax;
                    SendClientMessageEx(i, COLOR_RADIO, "SMS: %s ���ա����Һ�ҹ %d %s, Los Santos, San Andreas �ͧ�س���� ����¤������ҷ��س $%s",ReturnName(playerid,0), HouseInfo[p][HouseDBID], HouseInfo[p][HouseName], MoneyFormat(HouseInfo[p][HouseRentPrice] - total_tax));
                }
                else
                {
                    AddPlayerCash(HouseInfo[p][HouseOwnerDBID], HouseInfo[p][HouseRentPrice] - total_tax);
                }
            }

            Savehouse(p);
            Saveglobal();

            Check = true;

            return 1;
        }
        else Check = false;
    }

    if(!Check)
        return SendErrorMessage(playerid, "�س�������������ҹ����Դ������");
    
    return 1;
}

CMD:buyhouse(playerid, params[])
{
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

            if(CountPlayerProperties(playerid) > 3)
			    return SendErrorMessage(playerid, "�س����ö����Ңͧ��ҹ����§�� 3 ��ѧ��ҹ��");


            if(HouseInfo[p][HouseOwnerDBID])
                return SendClientMessage(playerid, -1, "{27AE60}HOUSE {F39C12}SYSTEM:{FFFFFF} ��ҹ��ѧ�������Ңͧ��������");

            if(GetPlayerMoney(playerid) < HouseInfo[p][HousePrice] || PlayerInfo[playerid][pLevel] < HouseInfo[p][HouseLevel])
                return SendClientMessage(playerid, -1, "{27AE60}HOUSE {F39C12}SYSTEM:{FFFFFF} �س���Թ���� ����� �����§�͵�͡�ë��ͺ�ҹ");

            HouseInfo[p][HouseOwnerDBID] = PlayerInfo[playerid][pDBID];
            GiveMoney(playerid, -HouseInfo[p][HousePrice]);
            SendClientMessage(playerid,-1,"{27AE60}HOUSE {F39C12}SYSTEM:{66FF99}�س����ͺ�ҹ���������");
            HouseInfo[p][HouseLock] = false;

            if(IsValidDynamicPickup(HouseInfo[p][HousePickup]))
                DestroyDynamicPickup(HouseInfo[p][HousePickup]);
            
            Savehouse(p);

            //HouseInfo[p][HousePickup] = CreateDynamicPickup(1272, 23, HouseInfo[p][HouseEntrance][0], HouseInfo[p][HouseEntrance][1], HouseInfo[p][HouseEntrance][2],-1,-1);
            return 1;
        }
        else SendErrorMessage(playerid, "�س������������ҹ���Ы���");
    }
    return 1;
}

CMD:sellhouse(playerid, params[])
{
    new id = PlayerInfo[playerid][pInsideProperty];

    if(!PlayerInfo[playerid][pInsideProperty])
        return SendClientMessage(playerid,-1,"{27AE60}HOUSE {F39C12}SYSTEM:{FF0000} �س���������㹺�ҹ");

    if(HouseInfo[id][HouseOwnerDBID] != PlayerInfo[playerid][pDBID])
        return SendClientMessage(playerid,-1,"{27AE60}HOUSE {F39C12}SYSTEM:{FF0000} ��ҹ��ѧ���������ҹ�ͧ�س");

    if(HouseInfo[id][HouseRentStats])
        return SendErrorMessage(playerid, "�س���繵�ͧ任Դ�����Һ�ҹ��͹");
    
    Dialog_Show(playerid, DIALOG_SELL_HOUSE, DIALOG_STYLE_MSGBOX, "�س���?", "�س�����������Т�º�ҹ��ѧ���\n\
                                                                               �س�����Թ�׹����觢ͧ�ҤҺ�ҹ����˴\n\
                                                                               �ô�Դ���ա�͹���С����� �׹�ѹ", "�׹�ѹ", "¡��ԡ");

    return 1;
}

CMD:placepos(playerid,params[])
{
    new id = PlayerInfo[playerid][pInsideProperty];

    if(!PlayerInfo[playerid][pInsideProperty])
        return SendClientMessage(playerid,-1,"{27AE60}HOUSE {F39C12}SYSTEM:{FF0000} �س���������㹺�ҹ");

    if(HouseInfo[id][HouseOwnerDBID] != PlayerInfo[playerid][pDBID])
        return SendClientMessage(playerid,-1,"{27AE60}HOUSE {F39C12}SYSTEM:{FF0000} ��ҹ��ѧ���������ҹ�ͧ�س");

    GetPlayerPos(playerid, HouseInfo[id][HousePlacePos][0], HouseInfo[id][HousePlacePos][1], HouseInfo[id][HousePlacePos][2]);


    SendClientMessage(playerid, -1, "{27AE60}HOUSE {F39C12}SYSTEM:{FFFFFF} �س���ҧ�ش���૿���ç���˹觵ç�������");
    Savehouse(id);
    return 1;
}

CMD:ds(playerid, params[])
{
    if(!PlayerInfo[playerid][pInsideProperty] && !IsPlayerNearHouse(playerid))
        return SendErrorMessage(playerid, "�س���������˹��/� ��ҹ");

    if(isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD2, "/ds [��ͤ���]");
    
    new str[128];
	if (strlen(params) > 80) {
	    format(str, sizeof(str), "%s ��⡹: %.80s", ReturnRealName(playerid, 0), params);
	    ProxDetector(playerid, 30.0, str);

	    format(str, sizeof(str), "... %s!", params[80]);
	    ProxDetector(playerid, 30.0, str);

        foreach(new i : Player)
        {
            if(IsPlayerInHouse(i) != IsPlayerNearHouse(playerid) || IsPlayerInHouse(playerid) != IsPlayerNearHouse(i))
                continue;

            SendClientMessage(i, COLOR_GRAD1, str);
        }
	}
	else 
    {
        format(str, sizeof(str), "%s ��⡹: %s!", ReturnRealName(playerid, 0), params), ProxDetector(playerid, 30.0, str);

        foreach(new i : Player)
        {
            if(IsPlayerInHouse(i) != IsPlayerNearHouse(playerid) || IsPlayerInHouse(playerid) != IsPlayerNearHouse(i))
                continue;

            SendClientMessage(i, COLOR_GRAD1, str);
        }

    }

    return 1;
}

CMD:ddo(playerid, params[])
{
    if(!PlayerInfo[playerid][pInsideProperty] && !IsPlayerNearHouse(playerid))
        return SendErrorMessage(playerid, "�س���������˹��/� ��ҹ");

    if(isnull(params))
	    return SendSyntaxMessage(playerid, "/ddo [action]");
    
    if(strlen(params) > 80)
    {
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %.80s", params);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "... %s (( %s ))", params[80], ReturnRealName(playerid, 0));

        foreach(new i : Player)
        {
            if(IsPlayerInHouse(i) != IsPlayerNearHouse(playerid) || IsPlayerInHouse(playerid) != IsPlayerNearHouse(i))
                continue;

            SendClientMessageEx(i, COLOR_PURPLE, "* %.80s",params);
            SendClientMessageEx(i, COLOR_PURPLE, "... %s (( %s ))",params[80],ReturnRealName(playerid, 0));
        }
    }
    else
    {
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s (( %s ))", params, ReturnRealName(playerid, 0));
        foreach(new i : Player)
        {
            if(IsPlayerInHouse(i) != IsPlayerNearHouse(playerid) || IsPlayerInHouse(playerid) != IsPlayerNearHouse(i))
                continue;

            SendClientMessageEx(i, COLOR_PURPLE, "* %s (( %s ))",params,ReturnRealName(playerid, 0));
        }
    }
    return 1;
}

CMD:knock(playerid, params[])
{
    if(!IsPlayerNearHouse(playerid))
        return SendErrorMessage(playerid, "�س���������˹��/� ��ҹ");
    
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* ��л�е� (( %s ))", ReturnRealName(playerid, 0));

    foreach(new i : Player)
    {
        if(IsPlayerInHouse(i) != IsPlayerNearHouse(playerid) || IsPlayerInHouse(playerid) != IsPlayerNearHouse(i))
            continue;

        SendClientMessageEx(i, COLOR_PURPLE, "* ��л�е� (( %s ))",ReturnRealName(playerid, 0));
    }
    return 1;
}


CMD:switch(playerid, params[])
{
    new id = PlayerInfo[playerid][pInsideProperty], str[32];

    if(id == 0)
        return SendErrorMessage(playerid, "��س��������㹺�ҹ��͹");

    new trun[10];

    if(sscanf(params, "s[10]",trun))
    {
        SendClientMessage(playerid, -1, "on = �Դ����㹺�ҹ");
        SendClientMessage(playerid, -1, "off = �Դ����㹺�ҹ");
        SendUsageMessage(playerid, "/switch <on ���� off>");
        return 1;
    }

    if(!strcmp(trun, "on"))
    {
        if(HouseInfo[id][HouseSwicth])
            return 1;

        HouseInfo[id][HouseSwicth] = true;

        foreach(new i : Player)
        {
            if(!IsPlayerInHouse(i))
                continue;
                
            PlayerTextDrawHide(i, PlayerSwicthOff[playerid][0]);
        }

        if(HouseInfo[id][HouseEle] * 7 >=  10000)
        {
            GiveMoney(playerid, -HouseInfo[id][HouseEle] * 7 / 2);
            CharacterSave(playerid);
            SendClientMessageEx(playerid, COLOR_LIGHTRED, "�س������¤��俺�ҹ ��Ҩ��繵�ͧ�Ѵ�Թ�ͧ�س $%s ����繤��觹֧�ͧ��Ť���",MoneyFormat(HouseInfo[id][HouseEle] * 7 / 2));
            HouseInfo[id][HouseEle] -= HouseInfo[id][HouseEle] / 2;
        }
        
        HouseInfo[id][HouseTimerEle] = SetTimerEx("HouseElectricitybill", 3600000, true, "i",id);//1800000
        format(str, sizeof(str), "�Դ��Է������㹺�ҹ");
        callcmd::me(playerid,str);
        return 1;
    }
    else if(!strcmp(trun, "off"))
    {
        if(!HouseInfo[id][HouseSwicth])
            return 1;

        HouseInfo[id][HouseSwicth] = false;

        foreach(new i : Player)
        {
            if(!IsPlayerInHouse(i))
                continue;

            PlayerTextDrawShow(i, PlayerSwicthOff[playerid][0]);
        }

        for(new c = 1; c < MAX_COMPUTER; c++)
        {
            if(ComputerInfo[c][ComputerOwnerDBID] != HouseInfo[id][HouseOwnerDBID])
                continue;
            
            ComputerInfo[c][ComputerStartBTC] = false;
            ComputerInfo[id][ComputerOn] = false;
            KillTimer(ComputerInfo[id][ComputerTimer]);
        }

        KillTimer(HouseInfo[id][HouseTimerEle]);

        format(str, sizeof(str), "�Դ��Է������㹺�ҹ");
        SendClientMessage(playerid, COLOR_YELLOWEX, "俷���ҹ�ͧ�س�Ѻ�������� /switch on �����Դ");
        callcmd::me(playerid,str);
        return 1;
    }
    return 1;
}

CMD:checkele(playerid, params[])
{
    new id = PlayerInfo[playerid][pInsideProperty], bill;

    if(!PlayerInfo[playerid][pInsideProperty])
        return SendClientMessage(playerid,-1,"{27AE60}HOUSE {F39C12}SYSTEM:{FF0000} �س���������㹺�ҹ");

    if(HouseInfo[id][HouseOwnerDBID] != PlayerInfo[playerid][pDBID] && HouseInfo[id][HouseRent] != PlayerInfo[playerid][pDBID])
        return SendClientMessage(playerid,-1,"{27AE60}HOUSE {F39C12}SYSTEM:{FF0000} ��ҹ��ѧ���������ҹ�ͧ�س");

    bill = HouseInfo[id][HouseEle];

    if(bill == 0)
        return SendClientMessage(playerid, -1, "俿�Ңͧ�س�ѧ���֧˹��·���˹�");
    
    SendClientMessageEx(playerid, -1, "[HOUSE BILL] ���俷����� %s ˹��� ����� $%s ����ö仨��¤������� City Hall",MoneyFormat(HouseInfo[id][HouseEle]), MoneyFormat(bill * 7));
    return 1;
}

CMD:placecom(playerid, params[])
{
    if(IsPlayerAndroid(playerid) == true)
        return SendErrorMessage(playerid, "�к���麹��絿�����ͧ�س�ѧ����ͧ�Ѻ");
        
    new id = PlayerInfo[playerid][pInsideProperty];

    if(!PlayerInfo[playerid][pInsideProperty])
        return SendClientMessage(playerid,-1,"�س���������㹺�ҹ");

    if(PlayerEditObject[playerid])
        return SendErrorMessage(playerid, "�س���ѧ��� Object ����");

    if(sscanf(params, "d", id))
        return SendUsageMessage(playerid, "/placecom < �ʹդ���������ͧ�س >");

    if(!ComputerInfo[id][ComputerDBID])
        return SendErrorMessage(playerid,"����դ�����س���͡");
    
    if(ComputerInfo[id][ComputerOwnerDBID] != PlayerInfo[playerid][pDBID])
        return SendErrorMessage(playerid, "�������ͧ��������ͧ�س");

    if(ComputerInfo[id][ComputerSpawn])
        return SendErrorMessage(playerid, "������������١�ҧ��������");
    
    EditObjectComputer(playerid, id);
    return 1;
}

CMD:editcom(playerid, params[])
{
    new id, option[32];

    if(IsPlayerAndroid(playerid) == true)
        return SendErrorMessage(playerid, "�к���麹��絿�����ͧ�س�ѧ����ͧ�Ѻ");

    if(!PlayerInfo[playerid][pInsideProperty])
        return SendClientMessage(playerid,-1,"�س���������㹺�ҹ");

    /*if(ComputerInfo[id][ComputerOwnerDBID] != PlayerInfo[playerid][pDBID])
        return SendErrorMessage(playerid, "�������ͧ��������ͧ�س");*/

    if(PlayerEditObject[playerid])
        return SendErrorMessage(playerid, "�س���ѧ��� Object ����");

    id = IsPlayerNearComputer(playerid);

    if(id == 0)
        return SendErrorMessage(playerid, "�س�������������� ���� ��绷�ͻ");

    if(sscanf(params, "s[32]", option))
    {
        SendUsageMessage(playerid, "/editcom < option >");
        SendClientMessageEx(playerid, COLOR_GREY, "pos upgrade get");
        return 1;
    }  


    if(!strcmp(option, "pos"))
    {
        if(!ComputerInfo[id][ComputerDBID])
            return SendErrorMessage(playerid,"����դ�����س���͡");

        if(!ComputerInfo[id][ComputerSpawn])
            return SendErrorMessage(playerid, "���������������١�ҧ");

        if(IsPlayerNearComputer(playerid) != id)
            return SendErrorMessage(playerid, "�س��������������������� ���� ��绷�ͻ");


        DestroyDynamicObject(ComputerInfo[id][ComputerObject]);

        EditObjectComputer(playerid, id);
        return 1;
    }
    else if(!strcmp(option, "upgrade"))
    {
        if(!ComputerInfo[id][ComputerDBID])
            return SendErrorMessage(playerid,"����դ�����س���͡");

        if(!ComputerInfo[id][ComputerSpawn])
            return SendErrorMessage(playerid, "���������������١�ҧ");

        if(IsPlayerNearComputer(playerid) != id)
            return SendErrorMessage(playerid, "�س��������������������� ���� ��绷�ͻ");

        new str[255], longstr[255];
        format(str, sizeof(str), "CPU: %s\n", ReturnCPUNames(ComputerInfo[id][ComputerCPU]));
        strcat(longstr, str);
        format(str, sizeof(str), "GPU 1: %s\n", ReturnGPUNames(ComputerInfo[id][ComputerGPU][0]));
        strcat(longstr, str);
        format(str, sizeof(str), "GPU 2: %s\n", ReturnGPUNames(ComputerInfo[id][ComputerGPU][1]));
        strcat(longstr, str);
        format(str, sizeof(str), "GPU 3: %s\n", ReturnGPUNames(ComputerInfo[id][ComputerGPU][2]));
        strcat(longstr, str);
        format(str, sizeof(str), "GPU 4: %s\n", ReturnGPUNames(ComputerInfo[id][ComputerGPU][3]));
        strcat(longstr, str);
        format(str, sizeof(str), "GPU 5: %s\n", ReturnGPUNames(ComputerInfo[id][ComputerGPU][4]));
        strcat(longstr, str);
        format(str, sizeof(str), "RAM: %s \n", ReturnRams(ComputerInfo[id][ComputerRAM]));
        strcat(longstr, str);
        format(str, sizeof(str), "Stored: %s\n", ReturnStoreds(ComputerInfo[id][ComputerStored]));
        strcat(longstr, str);

        Dialog_Show(playerid, D_COMPUTER_UPGRAD_LIST, DIALOG_STYLE_LIST, "Upgrade computer:", longstr, "�׹�ѹ", "¡��ԡ");
        return 1;
    }
    else if(!strcmp(option, "get"))
    {
        if(!ComputerInfo[id][ComputerDBID])
            return SendErrorMessage(playerid,"����դ�����س���͡");
    
        if(ComputerInfo[id][ComputerOwnerDBID] != PlayerInfo[playerid][pDBID])
            return SendErrorMessage(playerid, "�������ͧ��������ͧ�س");

        if(!ComputerInfo[id][ComputerSpawn])
            return SendErrorMessage(playerid, "���������������١�ҧ");

        if(IsPlayerNearComputer(playerid) != id)
            return SendErrorMessage(playerid, "�س��������������������� ���� ��绷�ͻ");

        DestroyDynamicObject(ComputerInfo[id][ComputerObject]);
        ComputerInfo[id][ComputerSpawn] = false;
    }
    else SendErrorMessage(playerid, "������١��ͧ");
    return 1;
}

CMD:checkbill(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 3.5, 1480.9369,-1769.4884,18.7958))
    {
        new str[255], longstr[255], idx[255], houseid;


        format(str, sizeof(str), "��ҹ\t����\n");
        strcat(longstr,str);

        for(new h = 1; h < MAX_HOUSE; h++)
        {
            if(!HouseInfo[h][HouseDBID])
                continue;
            
            if(HouseInfo[h][HouseOwnerDBID] != PlayerInfo[playerid][pDBID] && HouseInfo[h][HouseRent] != PlayerInfo[playerid][pDBID])
                continue;

            if(HouseInfo[h][HouseEle] <= 200)
                continue;
            
            format(idx, sizeof(idx), "%d",houseid);
            SetPVarInt(playerid, idx, h);
            houseid++;

            format(str, sizeof(str), "%d %s, Los Santos, San Andreas\t$%s",HouseInfo[h][HouseDBID], HouseInfo[h][HouseName], MoneyFormat(HouseInfo[h][HouseEle] * 7));
            strcat(longstr,str);
        }
        if(!houseid)
            return Dialog_Show(playerid, DIALOG_ELE_NONEBILL, DIALOG_STYLE_LIST, "����", "����դ��俷յ�ͧ����", "�׹�ѹ", "¡��ԡ");

        
        Dialog_Show(playerid, DIALOG_ELE_BILL, DIALOG_STYLE_TABLIST_HEADERS, "����:", longstr, "�׹�ѹ", "¡��ԡ");
    }
    else if(PlayerInfo[playerid][pInsideBusiness])
    {
        new id = PlayerInfo[playerid][pInsideBusiness];

        if(BusinessInfo[id][BusinessType] != BUSINESS_TYPE_STORE)
            return SendErrorMessage(playerid, "�س�����������ҹ 24/7");
        
        new str[255], longstr[255], idx[255], houseid;


        format(str, sizeof(str), "��ҹ\t����\n");
        strcat(longstr,str);

        for(new h = 1; h < MAX_HOUSE; h++)
        {
            if(!HouseInfo[h][HouseDBID])
                continue;
            
            if(HouseInfo[h][HouseOwnerDBID] != PlayerInfo[playerid][pDBID])
                continue;

            if(HouseInfo[h][HouseEle] <= 200)
                continue;
            
            format(idx, sizeof(idx), "%d",houseid);
            SetPVarInt(playerid, idx, h);
            houseid++;

            format(str, sizeof(str), "%d %s, Los Santos, San Andreas\t$%s",HouseInfo[h][HouseDBID], HouseInfo[h][HouseName], MoneyFormat(HouseInfo[h][HouseEle] * 7));
            strcat(longstr,str);
        }
        if(!houseid)
            return Dialog_Show(playerid, DIALOG_ELE_NONEBILL, DIALOG_STYLE_LIST, "����", "����դ��俷յ�ͧ����", "�׹�ѹ", "¡��ԡ");

        
        Dialog_Show(playerid, DIALOG_ELE_BILL, DIALOG_STYLE_TABLIST_HEADERS, "����:", longstr, "�׹�ѹ", "¡��ԡ");

    }
    else SendErrorMessage(playerid, "�س��������˹�� City Hall ����� 24/7");

    return 1;
}

CMD:checkbit(playerid, params[])
{
    SendClientMessageEx(playerid, -1, "BITSAMP: %.5f",PlayerInfo[playerid][pBTC]);    
    return 1;
}

CMD:givebit(playerid, params[])
{
    new number,tagetid, Float:bit;

    if(sscanf(params, "df",number, bit))
        return SendUsageMessage(playerid, "/givebit <������> <�ӹǹ>");

    foreach(new i : Player)
    {
        if(PlayerInfo[i][pPhone] == number)
        {
            tagetid = i;
        }
    }

    if(!IsPlayerConnected(tagetid))
		return SendErrorMessage(playerid, "������س��ͧ����͹����͹�Ź�����");

	if(!BitFlag_Get(gPlayerBitFlag[tagetid], IS_LOGGED))
		return SendErrorMessage(playerid, "�����蹡��ѧ�������к�"); 

    if(PlayerInfo[playerid][pBTC] < bit)
        return SendErrorMessage(playerid, "�س�� BIT �����§��");

    PlayerInfo[playerid][pBTC]-=bit;
    PlayerInfo[tagetid][pBTC]+=bit;
    SendClientMessageEx(playerid, COLOR_REPORT, "SMS: �س���͹ BITSAMP �ӹǹ %.5f ���Ѻ���� %d",bit, PlayerInfo[tagetid][pPhone]);
    return 1;
}

stock EditObjectComputer(playerid, id)
{
    new Float:x, Float:y, Float:z, worldid, interiorid;
    GetPlayerPos(playerid, x, y, z);
    worldid = GetPlayerVirtualWorld(playerid);
    interiorid = GetPlayerInterior(playerid);

    ComputerInfo[id][ComputerObject] =  CreateDynamicObject(19893, x, y, z, 0.0, 0.0, 0.0, worldid, interiorid, -1);
    EditDynamicObject(playerid, ComputerInfo[id][ComputerObject]);
    ComputerEdit[playerid] = id;
    PlayerEditObject[playerid] = true;
    return 1;
}

public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{

    switch(response)
    {
        case EDIT_RESPONSE_FINAL:
        {

            if(ComputerEdit[playerid])
            {
                new id = ComputerEdit[playerid];
                new id_h = PlayerInfo[playerid][pInsideProperty];

                ComputerInfo[id][ComputerPos][0] = x;
                ComputerInfo[id][ComputerPos][1] = y;
                ComputerInfo[id][ComputerPos][2] = z;
                ComputerInfo[id][ComputerPos][3] = rx;
                ComputerInfo[id][ComputerPos][4] = ry;
                ComputerInfo[id][ComputerPos][5] = rz;
                ComputerInfo[id][ComputerPosWorld] = GetPlayerVirtualWorld(playerid);
                ComputerInfo[id][ComputerPosInterior] = GetPlayerInterior(playerid);
                ComputerInfo[id][ComputerSpawn] = true;
                ComputerInfo[id][ComputerHouseDBID] = id_h;
                ComputerEdit[playerid]  = 0;
                PlayerEditObject[playerid] = false;

                DestroyDynamicObject(ComputerInfo[id][ComputerObject]);
                
                ComputerInfo[id][ComputerObject] = CreateDynamicObject(19893, x, y, z, rx, ry, rz, ComputerInfo[id][ComputerPosWorld], ComputerInfo[id][ComputerPosInterior], -1);
                SaveComputer(id);
                return 1;
            }
        }
        case EDIT_RESPONSE_CANCEL:
        {

            if(ComputerEdit[playerid])
            {
                new id = ComputerEdit[playerid];

                if(ComputerInfo[id][ComputerSpawn])
                {
                    DestroyDynamicObject(objectid);
                    objectid = CreateDynamicObject(19893, ComputerInfo[id][ComputerPos][0], ComputerInfo[id][ComputerPos][1], ComputerInfo[id][ComputerPos][2], ComputerInfo[id][ComputerPos][3], ComputerInfo[id][ComputerPos][4], ComputerInfo[id][ComputerPos][5], ComputerInfo[id][ComputerPosWorld], ComputerInfo[id][ComputerPosInterior], -1);
                    ComputerEdit[playerid]  = 0;
                    PlayerEditObject[playerid] = false;
                    return 1;
                }

                DestroyDynamicObject(objectid);
                ComputerEdit[playerid]  = 0;
                PlayerEditObject[playerid] = false;
                return 1;
            }
        }
    }
    return 1;
}

Dialog:DIALOG_ELE_BILL(playerid, response, listitem, inputtext[])
{
    if(!response)
        SendServerMessage(playerid, "¡��ԡ��è��¤���");

    new idx[255];
    format(idx, sizeof(idx), "%d",listitem);
    new id = GetPVarInt(playerid, idx);

    if(HouseInfo[id][HouseEle] * 7 > PlayerInfo[playerid][pCash])
        return SendErrorMessage(playerid, "�س���ʹ�Թ�����§�͵�͡�è���");

    if(PlayerInfo[playerid][pInsideBusiness])
    {
        new id_b = PlayerInfo[playerid][pInsideBusiness];

        GiveMoney(playerid, -HouseInfo[id][HouseEle] * 7+15);
        SendClientMessageEx(playerid, COLOR_YELLOWEX, "�س����¤��俺�ҹ�ͧ�س���º�������Ǵ��¨ӹǹ�Թ $%s",  MoneyFormat(HouseInfo[id][HouseEle] * 7+15));
        BusinessInfo[id_b][BusinessCash] += 15;
        GlobalInfo[G_GovCash]+= HouseInfo[id][HouseEle] * 7;
        HouseInfo[id][HouseEle] = 0;
        Savehouse(id);
        CharacterSave(playerid);
    }
    else
    {
        GiveMoney(playerid, -HouseInfo[id][HouseEle] * 7);
        SendClientMessageEx(playerid, COLOR_YELLOWEX, "�س����¤��俺�ҹ�ͧ�س���º�������Ǵ��¨ӹǹ�Թ $%s",  MoneyFormat(HouseInfo[id][HouseEle] * 7));
        HouseInfo[id][HouseEle] = 0;
        GlobalInfo[G_GovCash]+= HouseInfo[id][HouseEle] * 7;
        Savehouse(id);
        CharacterSave(playerid);
    }
    return 1;
}

Dialog:D_COMPUTER_UPGRAD_LIST(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        ClearSelectBuyComputer(playerid);
        return 1;
    }

    if(!IsPlayerNearComputer(playerid))
    {
        ClearSelectBuyComputer(playerid);
        return 1;
    }

    new id = IsPlayerNearComputer(playerid), str[400], longstr[400];

    switch(listitem)
    {
        case 0: // CPU
        {
            format(str, sizeof(str), "CPU ���س��: %s\n",ReturnCPUNames(PlayerInfo[playerid][pCPU]));
            strcat(longstr, str);

            if(ComputerInfo[id][ComputerCPU])
            {
                format(str, sizeof(str), "[ ! ] �ʹ CPU %s �͡\n",ReturnCPUNames(ComputerInfo[id][ComputerCPU]));
                strcat(longstr, str);
            }

            Dialog_Show(playerid, D_COM_UPGRAD_CPU, DIALOG_STYLE_LIST, "Upgrad CPU:", longstr, "�׹�ѹ", "¡��ԡ");
            return 1;
        }
        case 1: // GPU SLOTID 1
        {
            format(str, sizeof(str), "GPU ���س��: %s\n",ReturnGPUNames(PlayerInfo[playerid][pGPU]));
            strcat(longstr, str);

            if(ComputerInfo[id][ComputerGPU][0])
            {
                format(str, sizeof(str), "[ ! ] �ʹ GPU %s �͡\n",ReturnGPUNames(ComputerInfo[id][ComputerGPU][0]));
                strcat(longstr, str);
            }
            
            PlayerSelectSlot[playerid] = 0;
            Dialog_Show(playerid, D_COM_UPGRAD_GPU, DIALOG_STYLE_LIST, "Upgrad GPU:", longstr, "�׹�ѹ", "¡��ԡ");
            return 1;
        }
        case 2: // GPU SLOTID 2
        {

            format(str, sizeof(str), "GPU ���س��: %s\n",ReturnGPUNames(PlayerInfo[playerid][pGPU]));
            strcat(longstr, str);

            if(ComputerInfo[id][ComputerGPU][1])
            {
                format(str, sizeof(str), "[ ! ] �ʹ GPU %s �͡\n",ReturnGPUNames(ComputerInfo[id][ComputerGPU][1]));
                strcat(longstr, str);
            }
            
            PlayerSelectSlot[playerid] = 1;
            Dialog_Show(playerid, D_COM_UPGRAD_GPU, DIALOG_STYLE_LIST, "Upgrad GPU:", longstr, "�׹�ѹ", "¡��ԡ");
            return 1;
        }
        case 3: // GPU SLOTID 3
        {
            format(str, sizeof(str), "GPU ���س��: %s\n",ReturnGPUNames(PlayerInfo[playerid][pGPU]));
            strcat(longstr, str);

            if(ComputerInfo[id][ComputerGPU][2])
            {
                format(str, sizeof(str), "[ ! ] �ʹ GPU %s �͡\n",ReturnGPUNames(ComputerInfo[id][ComputerGPU][2]));
                strcat(longstr, str);
            }
            
            PlayerSelectSlot[playerid] = 2;
            Dialog_Show(playerid, D_COM_UPGRAD_GPU, DIALOG_STYLE_LIST, "Upgrad GPU:", longstr, "�׹�ѹ", "¡��ԡ");
            return 1;
        }
        case 4: // GPU SLOTID 4
        {
            format(str, sizeof(str), "GPU ���س��: %s\n",ReturnGPUNames(PlayerInfo[playerid][pGPU]));
            strcat(longstr, str);

            if(ComputerInfo[id][ComputerGPU][3])
            {
                format(str, sizeof(str), "[ ! ] �ʹ GPU %s �͡\n",ReturnGPUNames(ComputerInfo[id][ComputerGPU][3]));
                strcat(longstr, str);
            }
            
            PlayerSelectSlot[playerid] = 3;
            Dialog_Show(playerid, D_COM_UPGRAD_GPU, DIALOG_STYLE_LIST, "Upgrad GPU:", longstr, "�׹�ѹ", "¡��ԡ");
            return 1;
        }
        case 5: // GPU SLOTID 5
        {
            format(str, sizeof(str), "GPU ���س��: %s\n",ReturnGPUNames(PlayerInfo[playerid][pGPU]));
            strcat(longstr, str);

            if(ComputerInfo[id][ComputerGPU][4])
            {
                format(str, sizeof(str), "[ ! ] �ʹ GPU %s �͡\n",ReturnGPUNames(ComputerInfo[id][ComputerGPU][4]));
                strcat(longstr, str);
            }
            
            PlayerSelectSlot[playerid] = 4;
            Dialog_Show(playerid, D_COM_UPGRAD_GPU, DIALOG_STYLE_LIST, "Upgrad GPU:", longstr, "�׹�ѹ", "¡��ԡ");
            return 1;
        }
        case 6: // RAM
        {
            format(str, sizeof(str), "RAM ���س��: %s\n",ReturnRams(PlayerInfo[playerid][pRAM]));
            strcat(longstr, str);

            if(ComputerInfo[id][ComputerRAM])
            {
                format(str, sizeof(str), "[ ! ] �ʹ RAM %s �͡\n",ReturnRams(ComputerInfo[id][ComputerRAM]));
                strcat(longstr, str);
            }
        
            Dialog_Show(playerid, D_COM_UPGRAD_RAM, DIALOG_STYLE_LIST, "Upgrad RAM:", longstr, "�׹�ѹ", "¡��ԡ");
            return 1;
        }
        case 7: // STORED
        {
            format(str, sizeof(str), "SSD ���س��: %s\n",ReturnStoreds(PlayerInfo[playerid][pStored]));
            strcat(longstr, str);

            if(ComputerInfo[id][ComputerStored])
            {
                format(str, sizeof(str), "[ ! ] �ʹ SSD %s �͡\n",ReturnStoreds(ComputerInfo[id][ComputerStored]));
                strcat(longstr, str);
            }
        
            Dialog_Show(playerid, D_COM_UPGRAD_STORED, DIALOG_STYLE_LIST, "Upgrad STORED:", longstr, "�׹�ѹ", "¡��ԡ");
            return 1;
        }
    }
    return 1;
}

Dialog:D_COM_UPGRAD_CPU(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        ClearSelectBuyComputer(playerid);
        return 1;
    }

    if(!IsPlayerNearComputer(playerid))
    {
        ClearSelectBuyComputer(playerid);
        return 1;
    }

    new id = IsPlayerNearComputer(playerid);

    switch(listitem)
    {
        case 0:
        {
            if(!PlayerInfo[playerid][pCPU])
                return SendErrorMessage(playerid, "�س����� CPU ����㹵��");

            
            if(ComputerInfo[id][ComputerCPU] == PlayerInfo[playerid][pCPU])
            {
                SendErrorMessage(playerid, "�س�������ö����¹ CPU �����������");
                PlayerSelectSlot[playerid] = 0;
                CharacterSave(playerid);
                SaveComputer(id);
                return 1;
            }

            PlayerOldComp[playerid] = ComputerInfo[id][ComputerCPU];
            ComputerInfo[id][ComputerCPU] = PlayerInfo[playerid][pCPU];
            PlayerInfo[playerid][pCPU] = PlayerOldComp[playerid];
            SendClientMessageEx(playerid, -1, "�س���Ѿ�ô CPU �� %s", ReturnCPUNames(ComputerInfo[id][ComputerCPU]));
            ClearSelectBuyComputer(playerid);
            CharacterSave(playerid);
            SaveComputer(id);
            return 1;
        }
        case 1:
        {
            if(!ComputerInfo[id][ComputerCPU])
                return SendErrorMessage(playerid, "���������� ���� ��绷�ͻ����ͧ��� ����� CPU");

            if(PlayerInfo[playerid][pCPU])
                return SendErrorMessage(playerid, "�س�� CPU ����㹵��");
            
            SendClientMessageEx(playerid, -1, "�س��ʹ CPU  %s �͡", ReturnCPUNames(ComputerInfo[id][ComputerCPU]));
            PlayerInfo[playerid][pCPU] = ComputerInfo[id][ComputerCPU];
            ComputerInfo[id][ComputerCPU] = 0;
            CharacterSave(playerid);
            SaveComputer(id);
            return 1;
        }
    }


    return 1;
}


Dialog:D_COM_UPGRAD_GPU(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        ClearSelectBuyComputer(playerid);
        return 1;
    }

    if(!IsPlayerNearComputer(playerid))
    {
        ClearSelectBuyComputer(playerid);
        return 1;
    }

    new id = IsPlayerNearComputer(playerid), slotid = PlayerSelectSlot[playerid];

    switch(listitem)
    {
        case 0:
        {
            if(ComputerInfo[id][ComputerGPU][slotid] == PlayerInfo[playerid][pGPU])
            {
                SendErrorMessage(playerid, "�س�������ö����¹ GPU �����������");
                PlayerSelectSlot[playerid] = 0;
                CharacterSave(playerid);
                SaveComputer(id);
                return 1;
            }

            PlayerOldComp[playerid] = ComputerInfo[id][ComputerGPU][slotid];
            ComputerInfo[id][ComputerGPU][slotid] = PlayerInfo[playerid][pGPU];
            PlayerInfo[playerid][pGPU] = PlayerOldComp[playerid];
            SendClientMessageEx(playerid, -1, "�س���Ѿ�ô GPU Slot %d �� %s",  slotid,ReturnGPUNames(ComputerInfo[id][ComputerGPU][slotid]));
            PlayerSelectSlot[playerid] = 0;
            CharacterSave(playerid);
            SaveComputer(id);
            return 1;
        }
        case 1:
        {
            if(PlayerInfo[playerid][pCPU])
                return SendErrorMessage(playerid, "�س�� GPU ����㹵��");

            SendClientMessageEx(playerid, -1, "�س��ʹ GPU  %s �͡", ReturnGPUNames(ComputerInfo[id][ComputerGPU][slotid]));
            PlayerInfo[playerid][pGPU] = ComputerInfo[id][ComputerGPU][slotid];
            ComputerInfo[id][ComputerGPU][slotid] = 0;
            CharacterSave(playerid);
            SaveComputer(id);
            return 1;
        
        }
    }
    return 1;
}

Dialog:D_COM_UPGRAD_RAM(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        ClearSelectBuyComputer(playerid);
        return 1;
    }

    if(!IsPlayerNearComputer(playerid))
    {
        ClearSelectBuyComputer(playerid);
        return 1;
    }

    new id = IsPlayerNearComputer(playerid);

    switch(listitem)
    {
        case 0:
        {
            if(!PlayerInfo[playerid][pRAM])
                return SendErrorMessage(playerid, "�س����� RAM ����㹵��");

            
            if(ComputerInfo[id][ComputerRAM] == PlayerInfo[playerid][pRAM])
            {
                SendErrorMessage(playerid, "�س�������ö����¹ RAM �����������");
                CharacterSave(playerid);
                SaveComputer(id);
                return 1;
            }

            PlayerOldComp[playerid] = ComputerInfo[id][ComputerRAM];
            ComputerInfo[id][ComputerRAM] = PlayerInfo[playerid][pRAM];
            PlayerInfo[playerid][pRAM] = PlayerOldComp[playerid];
            SendClientMessageEx(playerid, -1, "�س���Ѿ�ô RAM �� %s", ReturnRams(ComputerInfo[id][ComputerRAM]));
            ClearSelectBuyComputer(playerid);
            CharacterSave(playerid);
            SaveComputer(id);
            return 1;
        }
        case 1:
        {
            if(!ComputerInfo[id][ComputerRAM])
                return SendErrorMessage(playerid, "���������� ���� ��绷�ͻ����ͧ��� ����� RAM");

            if(PlayerInfo[playerid][pRAM])
                return SendErrorMessage(playerid, "�س�� RAM ����㹵��");
            
            SendClientMessageEx(playerid, -1, "�س��ʹ RAM  %s �͡", ReturnRams(ComputerInfo[id][ComputerRAM]));
            PlayerInfo[playerid][pRAM] = ComputerInfo[id][ComputerRAM];
            ComputerInfo[id][ComputerRAM] = 0;
            CharacterSave(playerid);
            SaveComputer(id);
            return 1;
        }
    }


    return 1;
}

Dialog:D_COM_UPGRAD_STORED(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        ClearSelectBuyComputer(playerid);
        return 1;
    }

    if(!IsPlayerNearComputer(playerid))
    {
        ClearSelectBuyComputer(playerid);
        return 1;
    }

    new id = IsPlayerNearComputer(playerid);

    switch(listitem)
    {
        case 0:
        {
            if(!PlayerInfo[playerid][pStored])
                return SendErrorMessage(playerid, "�س����� SSD ����㹵��");

            
            if(ComputerInfo[id][ComputerStored] == PlayerInfo[playerid][pStored])
            {
                SendErrorMessage(playerid, "�س�������ö����¹ SSD �����������");
                CharacterSave(playerid);
                SaveComputer(id);
                return 1;
            }

            PlayerOldComp[playerid] = ComputerInfo[id][ComputerStored];
            ComputerInfo[id][ComputerStored] = PlayerInfo[playerid][pStored];
            PlayerInfo[playerid][pStored] = PlayerOldComp[playerid];
            SendClientMessageEx(playerid, -1, "�س���Ѿ�ô SSD �� %s", ReturnStoreds(ComputerInfo[id][ComputerStored]));
            ClearSelectBuyComputer(playerid);
            CharacterSave(playerid);
            SaveComputer(id);
            return 1;
        }
        case 1:
        {
            if(!ComputerInfo[id][ComputerStored])
                return SendErrorMessage(playerid, "���������� ���� ��绷�ͻ����ͧ��� ����� SSD");

            if(PlayerInfo[playerid][pStored])
                return SendErrorMessage(playerid, "�س�� SSD ����㹵��");
            
            SendClientMessageEx(playerid, -1, "�س��ʹ SSD %s �͡", ReturnStoreds(ComputerInfo[id][ComputerStored]));
            PlayerInfo[playerid][pStored] = ComputerInfo[id][ComputerStored];
            ComputerInfo[id][ComputerStored] = 0;
            CharacterSave(playerid);
            SaveComputer(id);
            return 1;
        }
    }
    return 1;
}


alias:givehousekey("���حᨺ�ҹ")
CMD:givehousekey(playerid, params[])
{
    if(!IsPlayerInHouse(playerid))
        return SendErrorMessage(playerid, "�س������������㹺�ҹ");

    new id = PlayerInfo[playerid][pInsideProperty];

    if(HouseInfo[id][HouseOwnerDBID] != PlayerInfo[playerid][pDBID])
        return SendErrorMessage(playerid, "�س���������Ңͧ��ҹ��ѧ���");

    new tagetid;
    
    if(sscanf(params, "u", tagetid))
        return SendUsageMessage(playerid, "/givehousekey <���ͺҧ��ǹ/�ʹ�>");

    if(playerid == tagetid)
        return SendErrorMessage(playerid, "�������ö���حᨺ�ҹ���ͧ�Ѻ����ͧ��");
    
    if(!IsPlayerConnected(tagetid))
		return SendErrorMessage(playerid, "������������������͡Ѻ�׿�����"); 
		
	if(!BitFlag_Get(gPlayerBitFlag[tagetid], IS_LOGGED))
		return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");

    if(!IsPlayerNearPlayer(playerid, tagetid, 2.0))
        return SendErrorMessage(playerid, "������������������س");

    if(PlayerInfo[tagetid][pHouseKey] == id)
    {
        PlayerInfo[tagetid][pHouseKey] = 0;
        SendServerMessage(playerid, "�س���ִ�حᨺ�ҹ�ͧ %s ���º��������", ReturnName(tagetid));
        SendServerMessage(tagetid, "�س��١�ִ�حᨺ�ҹ�� %s", ReturnName(playerid));

        CharacterSave(tagetid);
        CharacterSave(playerid);
        return 1;
    }
    else 
    {
        PlayerInfo[tagetid][pHouseKey] = id;
        SendServerMessage(playerid, "�س�����سᨺ�ҹ���ͧ�Ѻ %s ���� �����Թ ($500)", ReturnName(tagetid));
        SendServerMessage(tagetid, "�س���Ѻ�ح����ͧ�ͧ��ҹ %d  �ҡ %s ����", ReturnName(playerid));

        CharacterSave(tagetid);
        CharacterSave(playerid);
    }
    return 1;
}


CMD:bareswitch(playerid, params[])
{
    if(!IsPlayerInHouse(playerid))
        return SendErrorMessage(playerid, "�س������������㹺�ҹ");

    new id = PlayerInfo[playerid][pInsideProperty];
    
    if(HouseInfo[id][HouseOwnerDBID] != PlayerInfo[playerid][pDBID] && PlayerInfo[playerid][pHouseKey] != id)
        return SendErrorMessage(playerid, "�س���������Ңͧ��ҹ��ѧ���");

    new Float:x, Float:y, Float:z;

    if(HouseInfo[id][HouseStatus])
    {
        HouseInfo[id][HouseStatus]=0;
	    SendClientMessage(playerid, COLOR_WHITE, "�س�Դ���� Bareswitch");
	    //HouseInfo[id][HouseInterior][2]+=100.0;

        foreach(new i : Player)
		{
			if(PlayerInfo[i][pInsideProperty] == id)
     		{
				GetPlayerPos(i, x, y, z);
				//SetPlayerPos(i, x, y, z+100.5);
            }
        }
    
    }
    else
    {
        HouseInfo[id][HouseStatus]=1;
	    SendClientMessage(playerid, COLOR_WHITE, "�س���Դ���� Bareswitch");
		//HouseInfo[id][HouseInterior][2]-=100.0;

        foreach(new i : Player)
		{
			if(PlayerInfo[i][pInsideProperty] == id)
     		{
				GetPlayerPos(i, x, y, z);
				//SetPlayerPos(i, x, y, z+100.5);
            }
        }
    }

    DestroyDynamicArea(HouseInfo[id][HouseAreaID]);
	HouseInfo[id][HouseAreaID] = CreateDynamicSphere(HouseInfo[id][HouseInterior][0], HouseInfo[id][HouseInterior][1], HouseInfo[id][HouseInterior][2], 3.0, HouseInfo[id][HouseInteriorWorld], HouseInfo[id][HouseInteriorID]); // The house interior.	
	Streamer_SetIntData(STREAMER_TYPE_AREA, HouseInfo[id][HouseAreaID], E_STREAMER_EXTRA_ID, id);
    Savehouse(id);
    return 1;
}