#include <YSI_Coding\y_hooks>

new miner_pickup, startjob[2], proceed_pickup;
new bool:PlayerStartOre[MAX_PLAYERS];


hook OnGameModeInit@13()
{
    miner_pickup = CreateDynamicPickup(1239, 2, 586.4755,872.6391,-42.4973, -1, -1,-1);
    proceed_pickup = CreateDynamicPickup(1239, 2, 674.1799,828.0583,-38.9921, -1, -1,-1);

    startjob[0] = CreateDynamicCircle(595.3938,926.8503, 15.0,-1);
    startjob[1] = CreateDynamicCircle(545.7205,919.6435, 15.0,-1);
    Create3DTextLabel("��ԡ ������ͷӡ�âش���㹺����ù��", COLOR_EMOTE, 594.6451,926.9291,-37.3309, 50, 0, 0);
    //CreateDynamicCircle(Float:x, Float:y, Float:size, worldid = -1, interiorid = -1, playerid = -1);
    return 1;
}

hook OP_PickUpDynamicPickup(playerid, STREAMER_TAG_PICKUP:pickupid)
{
    if(pickupid == miner_pickup)
    {
        SendClientMessage(playerid, -1, "����� /takejob ������Ѥçҹ �ѡ�ش����ͧ");
        return 1;
    }
    if(pickupid == proceed_pickup)
    {
        SendClientMessage(playerid, -1, "����� /ptze �������ٻ");
        return 1;
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(RELEASED(KEY_RIGHT) || RELEASED(KEY_CTRL_BACK))
    {
        if(PlayerInfo[playerid][pJob] != JOB_MINER && PlayerInfo[playerid][pSideJob] != JOB_MINER)
            return 1;

        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
            return 1;

        if(!IsPlayerInDynamicArea(playerid, startjob[0]) && !IsPlayerInDynamicArea(playerid, startjob[1]))
            return 1;

        if(PlayerStartOre[playerid])
            return 1;

        //GetPlayerPos(playerid, newPos[0], newPos[1], newPos[2]);

        if(IsPlayerInRangeOfPoint(playerid, 2.5, PlayerInfo[playerid][pLastPosX], PlayerInfo[playerid][pLastPosY], PlayerInfo[playerid][pLastPosZ]))
            return SendErrorMessage(playerid, "�س��ͧ����¹�ش�ش�ͧ�س");

        if(PlayerInfo[playerid][pOre] >= 50)
            return SendErrorMessage(playerid, "�س�����㹵���������");

        new str[120];
        format(str, sizeof(str), "��������ش���...");
        callcmd::me(playerid, str);
        TogglePlayerControllable(playerid, 0);
        PlayerStartOre[playerid] = true;
        GetPlayerPos(playerid, PlayerInfo[playerid][pLastPosX], PlayerInfo[playerid][pLastPosY], PlayerInfo[playerid][pLastPosZ]);
        SetTimerEx("StartMine", 5000, false, "d",playerid);
        
        return 1;
    }
    return 1;
}

forward StartMine(playerid);
public StartMine(playerid)
{
    new amount = Random(1,3);
    PlayerStartOre[playerid] = false;
    PlayerInfo[playerid][pOre] += amount;
    SendClientMessageEx(playerid, COLOR_REPORT, "[MINER JOB] �س��������ش���������������ѧ��������ٻ�ӹǹ %d ���",amount);
    TogglePlayerControllable(playerid, 1);
    CharacterSave(playerid);
    return 1;
}

CMD:checkore(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] != JOB_MINER && PlayerInfo[playerid][pSideJob] != JOB_MINER && !PlayerInfo[playerid][pAdmin])
        return SendErrorMessage(playerid, "�س������Ҫվ �ѡ�ش����ͧ");

    if(PlayerInfo[playerid][pAdmin])
    {
        new tagetid;
        if(sscanf(params, "i(-1)", tagetid))
            return 1;

        if(tagetid == -1)
		{
			return  ShowOre(playerid);
		}
		else
		{
			if(!IsPlayerConnected(tagetid))
				return SendErrorMessage(tagetid, "�����������ӡ��������������׿�����");
				
			if(!BitFlag_Get(gPlayerBitFlag[tagetid], IS_LOGGED))
				return SendErrorMessage(playerid, "�����蹡��ѧ�������к�"); 
				
			ShowOre(tagetid);
		}
        return 1;
    }
    else ShowOre(playerid);
    return 1;
}


CMD:ptze(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] != JOB_MINER && PlayerInfo[playerid][pSideJob] != JOB_MINER)
        return SendErrorMessage(playerid, "�س������Ҫվ �ѡ�ش����ͧ");

    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 674.1799,828.0583,-38.9921))
        return SendErrorMessage(playerid, "�س���������㹨ش Proceed");

    new amount, str[255];

    if(sscanf(params, "d",amount))
        return SendUsageMessage(playerid, "/ptze <�ӹǹ>");

    if(amount < 1)
        return SendUsageMessage(playerid, "/ptze <�ӹǹ> ���ӹǹ���١��ͧ");

    if(PlayerInfo[playerid][pOre] < amount)
        return SendErrorMessage(playerid, "�ӹǹ�����§��");

    format(str, sizeof(str), "�ӡ�����ٻ���...");
    callcmd::me(playerid, str);
    TogglePlayerControllable(playerid, 0);
    SendClientMessageEx(playerid, COLOR_YELLOW, "�س��������ٻ���ͧ�س �ӹǹ %d ��� ��ͧ������㹡�����ٻ %d �Թҷ�",amount, amount);
    PlayerInfo[playerid][pOre]-= amount;
    SetTimerEx("ProceedOre", amount*1000, false, "dd", playerid, amount);
    return 1;
}

CMD:giveore(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] != JOB_MINER && PlayerInfo[playerid][pSideJob] != JOB_MINER)
        return SendErrorMessage(playerid, "�س������Ҫվ �ѡ�ش����ͧ");

    new amount, type[60], tagetid;

    if(sscanf(params, "s[60]dd",type, amount, tagetid))
    {
        SendUsageMessage(playerid, "/giveore <������ :  ���> <�ӹǹ> <���ͺҧ��ǹ/�ʹ�>");
        SendClientMessage(playerid, -1, "[ORE TYPE:] ore coal iron copper kno3");
        return 1;
    }


    if(!strcmp(type, "ore", true))
    {
        if(PlayerInfo[playerid][pOre] < amount)
            return SendErrorMessage(playerid, "�س�ըӹǹ��� Ore �����§��");

        if(!IsPlayerConnected(tagetid))
            return SendErrorMessage(playerid,"�����������������������������");

        if(playerid  == tagetid)
            return SendErrorMessage(playerid, "�س�������ö������Ѻ����ͧ��");

        if(IsPlayerLogin(playerid))
            return SendErrorMessage(playerid,"�����蹡��ѧ�������к�");

        
        PlayerInfo[tagetid][pOre] += amount;
        PlayerInfo[playerid][pOre] -= amount;
        SendClientMessageEx(playerid, COLOR_DARKGREEN, "�س����� Unprocessed Ores �ӹǹ %d ��͹�Ѻ %s",amount,  ReturnName(tagetid,0));
        SendClientMessageEx(tagetid, COLOR_DARKGREEN, "�س���Ѻ Unprocessed Ores �ӹǹ %d ��͹�ҡ %s",amount,  ReturnName(playerid,0));
        SendNearbyMessage(playerid, 3.0, COLOR_EMOTE, "* %s ��Ժ Unprocessed Ores ���Ѻ %s", ReturnName(playerid,0), ReturnName(tagetid,0));
        return 1;
    }
    else if(!strcmp(type, "coal", true))
    {
        if(PlayerInfo[playerid][pCoal] < amount)
            return SendErrorMessage(playerid, "�س�ըӹǹ��� Coal Ore �����§��");

        if(!IsPlayerConnected(tagetid))
            return SendErrorMessage(playerid,"�����������������������������");

        if(playerid  == tagetid)
            return SendErrorMessage(playerid, "�س�������ö������Ѻ����ͧ��");

        if(IsPlayerLogin(playerid))
            return SendErrorMessage(playerid,"�����蹡��ѧ�������к�");

        
        PlayerInfo[tagetid][pCoal] += amount;
        PlayerInfo[playerid][pCoal] -= amount;
        SendClientMessageEx(playerid, COLOR_DARKGREEN, "�س����� Coal Ore �ӹǹ %d ��͹�Ѻ %s",amount,  ReturnName(tagetid,0));
        SendClientMessageEx(tagetid, COLOR_DARKGREEN, "�س���Ѻ Coal Ore �ӹǹ %d ��͹�ҡ %s",amount,  ReturnName(playerid,0));
        SendNearbyMessage(playerid, 3.0, COLOR_EMOTE, "* %s ��Ժ Coal Ore ���Ѻ %s", ReturnName(playerid,0), ReturnName(tagetid,0));
        return 1;
    }
    else if(!strcmp(type, "iron", true))
    {
        if(PlayerInfo[playerid][pIron] < amount)
            return SendErrorMessage(playerid, "�س�ըӹǹ��� Iron Ore �����§��");

        if(!IsPlayerConnected(tagetid))
            return SendErrorMessage(playerid,"�����������������������������");

        if(playerid  == tagetid)
            return SendErrorMessage(playerid, "�س�������ö������Ѻ����ͧ��");

        if(IsPlayerLogin(playerid))
            return SendErrorMessage(playerid,"�����蹡��ѧ�������к�");

        
        PlayerInfo[tagetid][pIron] += amount;
        PlayerInfo[playerid][pIron] -= amount;
        SendClientMessageEx(playerid, COLOR_DARKGREEN, "�س����� Iron Ore �ӹǹ %d ��͹�Ѻ %s",amount,  ReturnName(tagetid,0));
        SendClientMessageEx(tagetid, COLOR_DARKGREEN, "�س���Ѻ Iron Ore �ӹǹ %d ��͹�ҡ %s",amount,  ReturnName(playerid,0));
        SendNearbyMessage(playerid, 3.0, COLOR_EMOTE, "* %s ��Ժ Iron Ore ���Ѻ %s", ReturnName(playerid,0), ReturnName(tagetid,0));
        return 1;
    }
    else if(!strcmp(type, "copper", true))
    {
        if(PlayerInfo[playerid][pCopper] < amount)
            return SendErrorMessage(playerid, "�س�ըӹǹ��� Iron Ore �����§��");

        if(!IsPlayerConnected(tagetid))
            return SendErrorMessage(playerid,"�����������������������������");

        if(playerid  == tagetid)
            return SendErrorMessage(playerid, "�س�������ö������Ѻ����ͧ��");

        if(IsPlayerLogin(playerid))
            return SendErrorMessage(playerid,"�����蹡��ѧ�������к�");

        
        PlayerInfo[tagetid][pCopper] += amount;
        PlayerInfo[playerid][pCopper] -= amount;
        SendClientMessageEx(playerid, COLOR_DARKGREEN, "�س����� Copper Ore �ӹǹ %d ��͹�Ѻ %s",amount,  ReturnName(tagetid,0));
        SendClientMessageEx(tagetid, COLOR_DARKGREEN, "�س���Ѻ Copper Ore �ӹǹ %d ��͹�ҡ %s",amount,  ReturnName(playerid,0));
        SendNearbyMessage(playerid, 3.0, COLOR_EMOTE, "* %s ��Ժ Copper Ore ���Ѻ %s", ReturnName(playerid,0), ReturnName(tagetid,0));
        return 1;
    }
    else if(!strcmp(type, "kno3", true))
    {
        if(PlayerInfo[playerid][pCopper] < amount)
            return SendErrorMessage(playerid, "�س�ըӹǹ��� Potassium Nitrate �����§��");

        if(!IsPlayerConnected(tagetid))
            return SendErrorMessage(playerid,"�����������������������������");

        if(playerid  == tagetid)
            return SendErrorMessage(playerid, "�س�������ö������Ѻ����ͧ��");

        if(IsPlayerLogin(playerid))
            return SendErrorMessage(playerid,"�����蹡��ѧ�������к�");

        
        PlayerInfo[tagetid][pKNO3] += amount;
        PlayerInfo[playerid][pKNO3] -= amount;
        SendClientMessageEx(playerid, COLOR_DARKGREEN, "�س����� Potassium Nitrate �ӹǹ %d ��͹�Ѻ %s",amount,  ReturnName(tagetid,0));
        SendClientMessageEx(tagetid, COLOR_DARKGREEN, "�س���Ѻ Potassium Nitrate �ӹǹ %d ��͹�ҡ %s",amount,  ReturnName(playerid,0));
        SendNearbyMessage(playerid, 3.0, COLOR_EMOTE, "* %s ��Ժ Potassium Nitrate ���Ѻ %s", ReturnName(playerid,0), ReturnName(tagetid,0));
        return 1;
    }
    else SendErrorMessage(playerid, "�����������١��ͧ");

    return 1;
}

CMD:sellore(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] != JOB_MINER && PlayerInfo[playerid][pSideJob] != JOB_MINER)
        return SendErrorMessage(playerid, "�س������Ҫվ �ѡ�ش����ͧ");

    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 2151.4236,-2266.5696,13.3064) && !IsPlayerInRangeOfPoint(playerid, 3.0, 2149.4441,-2264.5461,13.3057))
        return SendErrorMessage(playerid,  "�س���������㹨ش������");

    new type[60],amount;

    if(sscanf(params, "s[60]d", type, amount))
    {
        SendUsageMessage(playerid, "/sellore <������  :���> <�ӹǹ>");
        SendClientMessage(playerid, -1, "[ORE TYPE:] Coal Iron Copper KNO3"); 
        return 1; 
    }  

    if(!strcmp(type, "coal", true))
    {
        if(PlayerInfo[playerid][pCoal] < amount)
            return SendErrorMessage(playerid, "�س�� Coal Ore �����§��");

        PlayerInfo[playerid][pCoal]-= amount;
        GiveMoney(playerid, amount*5);
        SendClientMessageEx(playerid, -1, "�س������� Coal Ore �ӹǹ %d ���Թ�� %s",amount, MoneyFormat(amount *5));       
        return 1;
    }
    else if(!strcmp(type, "iron", true))
    {
        if(PlayerInfo[playerid][pIron] < amount)
            return SendErrorMessage(playerid, "�س�� Iron Ore �����§��");

        PlayerInfo[playerid][pIron]-= amount;
        GiveMoney(playerid, amount*15);
        SendClientMessageEx(playerid, -1, "�س������� Iron Ore �ӹǹ %d ���Թ�� %s",amount, MoneyFormat(amount *15));       
        return 1;
    }
    else if(!strcmp(type, "copper", true))
    {
        if(PlayerInfo[playerid][pCopper] < amount)
            return SendErrorMessage(playerid, "�س�� Copper Ore �����§��");

        PlayerInfo[playerid][pCopper]-= amount;
        GiveMoney(playerid, amount*10);
        SendClientMessageEx(playerid, -1, "�س������� Copper Ore �ӹǹ %d ���Թ�� %s",amount, MoneyFormat(amount *10));       
        return 1;
    }
    else if(!strcmp(type, "kno3", true))
    {
        if(PlayerInfo[playerid][pKNO3] < amount)
            return SendErrorMessage(playerid, "�س�� Potassium Nitrate �����§��");

        PlayerInfo[playerid][pKNO3]-= amount;
        GiveMoney(playerid, amount*50);
        SendClientMessageEx(playerid, -1, "�س������� Potassium Nitrate �ӹǹ %d ���Թ�� %s",amount, MoneyFormat(amount *50));       
        return 1;
    }
    return 1;
}


forward ProceedOre(playerid, amount);
public ProceedOre(playerid, amount)
{
    TogglePlayerControllable(playerid, 1);
    
    new randore = random(9);
    
    switch(randore)
    {
        case 0:
        {
            PlayerInfo[playerid][pCoal] += amount;
            SendClientMessageEx(playerid, -1, "�س�����ٻ���ͧ�س �س�� ��ҹ �� %d ��͹",amount);
            CharacterSave(playerid);
            return 1;
        }
        case 1:
        {
            PlayerInfo[playerid][pCoal] += amount;
            SendClientMessageEx(playerid, -1, "�س�����ٻ���ͧ�س �س�� ��ҹ �� %d ��͹",amount);
            CharacterSave(playerid);
            return 1;
        }
        case 2:
        {
            PlayerInfo[playerid][pCoal] += amount;
            SendClientMessageEx(playerid, -1, "�س�����ٻ���ͧ�س �س�� ��ҹ �� %d ��͹",amount);
            CharacterSave(playerid);
            return 1;
        }
        case 3:
        {
            PlayerInfo[playerid][pIron] += amount;
            SendClientMessageEx(playerid, -1, "�س�����ٻ���ͧ�س �س�� ���� �� %d ��͹",amount);
            CharacterSave(playerid);
            return 1;
        }
        case 4:
        {
            PlayerInfo[playerid][pIron] += amount;
            SendClientMessageEx(playerid, -1, "�س�����ٻ���ͧ�س �س�� ���� �� %d ��͹",amount);
            CharacterSave(playerid);
            return 1;
        }
        case 5:
        {
            PlayerInfo[playerid][pCopper] += amount;
            SendClientMessageEx(playerid, -1, "�س�����ٻ���ͧ�س �س�� �ͧᴧ �� %d ��͹",amount);
            CharacterSave(playerid);
            return 1;
        }
        case 6:
        {
            PlayerInfo[playerid][pCopper] += amount;
            SendClientMessageEx(playerid, -1, "�س�����ٻ���ͧ�س �س�� �ͧᴧ �� %d ��͹",amount);
            CharacterSave(playerid);
            return 1;
        }
        case 7:
        {
            PlayerInfo[playerid][pCopper] += amount;
            SendClientMessageEx(playerid, -1, "�س�����ٻ���ͧ�س �س�� �ͧᴧ �� %d ��͹",amount);
            CharacterSave(playerid);
            return 1;
        }
        case 8:
        {
            PlayerInfo[playerid][pKNO3] += amount / 2;
            SendClientMessageEx(playerid, -1, "�س�����ٻ���ͧ�س �س�� �ͧᴧ �� %d ��͹",amount /2);
            CharacterSave(playerid);
            return 1;
        }
    }
    return 1;
}

stock ShowOre(playerid)
{
    SendClientMessageEx(playerid, COLOR_DARKGREEN, "---------- ORE %s ----------",  ReturnName(playerid,0));
    SendClientMessageEx(playerid, COLOR_WHITE, "Unprocessed Ores: %d ���", PlayerInfo[playerid][pOre]);
    SendClientMessageEx(playerid, COLOR_WHITE, "Coal Ore: %d ���", PlayerInfo[playerid][pCoal]);
    SendClientMessageEx(playerid, COLOR_WHITE, "Iron Ore: %d ���", PlayerInfo[playerid][pIron]);
    SendClientMessageEx(playerid, COLOR_WHITE, "Copper Ore: %d ���", PlayerInfo[playerid][pCopper]);
    SendClientMessageEx(playerid, COLOR_WHITE, "Potassium Nitrate: %d ���", PlayerInfo[playerid][pKNO3]);
    SendClientMessage(playerid, COLOR_DARKGREEN, "---------- ORE ----------");
    return 1;
}