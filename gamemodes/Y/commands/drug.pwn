#include <YSI_Coding\y_hooks>

CMD:drughelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_DARKGREEN, "____________DRUGS HELP____________");

    SendClientMessage(playerid, -1, "");
    SendClientMessage(playerid, -1, "/checkdrug (��Ǩ�������� ��ҹ ���� �ҹ��˹�)");
    SendClientMessage(playerid, -1, "/mydrug (�����ʾ�Դ���㹵��)");
    SendClientMessage(playerid, -1, "/givedrug (�����)");
    SendClientMessage(playerid, -1, "/usedrug (����)");
    SendClientMessage(playerid, -1, "/getdrug (������͡��)");
    SendClientMessage(playerid, -1, "/placedrug (�ҧ���ʾ�Դ *㹺�ҹ ���� �ҹ��˹���ҹ��*)");
    SendClientMessage(playerid, -1, "");

    SendClientMessage(playerid, COLOR_DARKGREEN, "__________________________________");
    return 1;
}

CMD:placedrug(playerid, params[])
{
    new type, Float:amount;

    if(sscanf(params, "df", type, amount))
    {
        SendUsageMessage(playerid, "/placedrug <������> <�ӹǹ>");
        SendUsageMessage(playerid, "1.Cocaine 2.Cannabis 3.Heroin");
        return 1;
    }

    if(type < 1 || type > 3)
        return SendErrorMessage(playerid, "��س������������١��ͧ");

    if(amount < 0.01)
        return SendErrorMessage(playerid, "��س����ӹǹ���١��ͧ");

    if(PlayerInfo[playerid][pDrug][type-1] < amount)
        return SendErrorMessage(playerid, "���ʾ�Դ�ͧ�س�����§��");

    if(IsPlayerInAnyVehicle(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);

        if(HasNoEngine(vehicleid))
            return SendErrorMessage(playerid, "�������ö��Ѻ�ҹ��˹з���� �ѡ��ҹ��");

        PlaceDrugVehicle(playerid, vehicleid, type, amount);
        return 1;
    }
    else if(PlayerInfo[playerid][pInsideProperty])
    {
        new id = PlayerInfo[playerid][pInsideProperty];

        if(HouseInfo[id][HouseOwnerDBID] != PlayerInfo[playerid][pDBID])
            return SendErrorMessage(playerid, "���������ҹ�ͧ�س");

        if(!IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[id][HousePlacePos][0], HouseInfo[id][HousePlacePos][1], HouseInfo[id][HousePlacePos][2]))
            return SendErrorMessage(playerid, "�س���������ش Place Pos");

        PlaceDrugHouse(playerid, id, type, amount);
        return 1;
    }
    else SendErrorMessage(playerid, "�س����������������� ��ҹ ���� �ҹ�ҹТͧ�س");
    return 1;
}

CMD:getdrug(playerid, params[])
{
    new type, Float:amount;

    if(sscanf(params, "df", type, amount))
    {
        SendUsageMessage(playerid, "/getdrug <������> <�ӹǹ>");
        SendUsageMessage(playerid, "1.Cocaine 2.Cannabis 3.Heroin");
        return 1;
    }

    if(type < 1 || type > 3)
        return SendErrorMessage(playerid, "��س������������١��ͧ");

    if(amount < 0.01)
        return SendErrorMessage(playerid, "��س����ӹǹ���١��ͧ");


    if(IsPlayerInAnyVehicle(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);

        if(HasNoEngine(vehicleid))
            return SendErrorMessage(playerid, "�������ö��Ѻ�ҹ��˹з���� �ѡ��ҹ��");

        if(VehicleInfo[vehicleid][eVehicleDrug][type-1] < amount)
            return SendErrorMessage(playerid, "���ʾ�Դ�ͧ�س�����§��");

        GetDrugVehicle(playerid, vehicleid, type, amount);
        return 1;
    }
    else if(PlayerInfo[playerid][pInsideProperty])
    {
        new id = PlayerInfo[playerid][pInsideProperty];

        if(HouseInfo[id][HouseDrug][type-1] < amount)
            return SendErrorMessage(playerid, "���ʾ�Դ�ͧ�س�����§��");

        if(!IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[id][HousePlacePos][0], HouseInfo[id][HousePlacePos][1], HouseInfo[id][HousePlacePos][2]))
            return SendErrorMessage(playerid, "�س���������ش Place Pos");

        GetDrugHouse(playerid, id, type, amount);
        return 1;
    }
    else SendErrorMessage(playerid, "�س����������������� ��ҹ ���� �ҹ�ҹТͧ�س");
    return 1;
}

CMD:mydrug(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin])
    {
        new tagetid;

        if(sscanf(params, "I(-1)", tagetid))
        {
            SendClientMessage(playerid, COLOR_DARKGREEN, "__________DRUGS__________");
            SendClientMessageEx(playerid, -1, "Cocaine: %.2f",PlayerInfo[playerid][pDrug][0]);
            SendClientMessageEx(playerid, -1, "Cannabis: %.2f",PlayerInfo[playerid][pDrug][1]);
            SendClientMessageEx(playerid, -1, "Heroin: %.2f",PlayerInfo[playerid][pDrug][2]);
            return 1;
        }

        if(tagetid == -1)
        {
            SendClientMessage(playerid, COLOR_DARKGREEN, "__________DRUGS__________");
            SendClientMessageEx(playerid, -1, "Cocaine: %.2f",PlayerInfo[playerid][pDrug][0]);
            SendClientMessageEx(playerid, -1, "Cannabis: %.2f",PlayerInfo[playerid][pDrug][1]);
            SendClientMessageEx(playerid, -1, "Heroin: %.2f",PlayerInfo[playerid][pDrug][2]);
            return 1;
        }

        if(!IsPlayerConnected(tagetid))
            return SendErrorMessage(playerid, "����������������������������");

        if(IsPlayerLogin(tagetid))
            return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");
        
        SendClientMessageEx(playerid, COLOR_DARKGREEN, "__________DRUGS %s__________", ReturnName(tagetid,0));
        SendClientMessageEx(playerid, -1, "Cocaine: %.2f",PlayerInfo[tagetid][pDrug][0]);
        SendClientMessageEx(playerid, -1, "Cannabis: %.2f",PlayerInfo[tagetid][pDrug][1]);
        SendClientMessageEx(playerid, -1, "Heroin: %.2f",PlayerInfo[tagetid][pDrug][2]);
        return 1;
        
    }
    SendClientMessage(playerid, COLOR_DARKGREEN, "__________DRUGS__________");
    SendClientMessageEx(playerid, -1, "Cocaine: %.2f",PlayerInfo[playerid][pDrug][0]);
    SendClientMessageEx(playerid, -1, "Cannabis: %.2f",PlayerInfo[playerid][pDrug][1]);
    SendClientMessageEx(playerid, -1, "Heroin: %.2f",PlayerInfo[playerid][pDrug][2]);
    return 1;
}

CMD:checkdrug(playerid, params[])
{
    if(PlayerInfo[playerid][pInsideProperty])
    {
        new id = PlayerInfo[playerid][pInsideProperty];

        if(!IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[id][HousePlacePos][0], HouseInfo[id][HousePlacePos][1], HouseInfo[id][HousePlacePos][2]))
            return SendErrorMessage(playerid, "�س���������ش Place Pos");

        SendClientMessage(playerid, COLOR_DARKGREEN, "__________DRUGS House__________");
        SendClientMessageEx(playerid, -1, "Cocaine: %.2f",HouseInfo[id][HouseDrug][0]);
        SendClientMessageEx(playerid, -1, "Cannabis: %.2f",HouseInfo[id][HouseDrug][1]);
        SendClientMessageEx(playerid, -1, "Heroin: %.2f",HouseInfo[id][HouseDrug][2]);
        return 1;
    }
    else if(IsPlayerInAnyVehicle(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);

        if(HasNoEngine(vehicleid))
            return SendErrorMessage(playerid, "�������ö��Ѻ�ҹ��˹з���� �ѡ��ҹ��");

        SendClientMessage(playerid, COLOR_DARKGREEN, "__________DRUGS Vehicle__________");
        SendClientMessageEx(playerid, -1, "Cocaine: %.2f",VehicleInfo[vehicleid][eVehicleDrug][0]);
        SendClientMessageEx(playerid, -1, "Cannabis: %.2f",VehicleInfo[vehicleid][eVehicleDrug][1]);
        SendClientMessageEx(playerid, -1, "Heroin: %.2f",VehicleInfo[vehicleid][eVehicleDrug][2]);
        return 1;
    }
    return 1;
}

CMD:givedrug(playerid, params[])
{
    new tagetid, type, Float:amout, str[200];

    if(sscanf(params, "udf", tagetid, type, amout))
    {
        SendUsageMessage(playerid, "/givedrug <���ͺҧ��ǹ> <�ʹ�> <�ӹǹ : ����>");
        SendUsageMessage(playerid, "1.Cocaine 2.Cannabis 3.Heroin");
        return 1;
    }

    if(tagetid == playerid)
        return SendErrorMessage(playerid, "�������ö��Ѻ����ͧ��");

    if(!IsPlayerConnected(tagetid))
        return SendErrorMessage(playerid, "����������������������������");

    if(IsPlayerLogin(tagetid))
        return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");

    if(!IsPlayerNearPlayer(playerid, tagetid, 2.5))
        return SendErrorMessage(playerid, "�������������������Ǣͧ�س");

    if(amout < 0.01)
        return SendErrorMessage(playerid, "���ӹǹ�����Թ�");

    switch(type)
    {
        case 1:
        {
            if(PlayerInfo[playerid][pDrug][0] < amout)
                return SendErrorMessage(playerid, "�س�ըӹǹ�������§�͵�͡�����");

            SendNearbyMessage(playerid, 3.0, COLOR_EMOTE, "> %s ��蹺ҧ���ҧ���Ѻ %s",ReturnName(playerid,0), ReturnName(tagetid,0));
            SendClientMessageEx(playerid, COLOR_GREY, "�س���ͺ Cocaine ���Ѻ %s �ӹǹ %.2f ����",ReturnName(tagetid,0), amout);
            
            format(str, sizeof(str), "[%s] %s Give Drug 'Cocaine' to %s Amount: %.2f", ReturnDate(),ReturnName(playerid,0), ReturnName(tagetid,0), amout);
            SendDiscordMessage("drug", str);

            Log(druglog, WARNING, str);

            PlayerInfo[playerid][pDrug][0]-=amout;
            PlayerInfo[tagetid][pDrug][0]+=amout;
            //GiveDrug(tagetid, type, amout);
            CharacterSave(playerid);
        }
        case 2:
        {
            if(PlayerInfo[playerid][pDrug][1] < amout)
                return SendErrorMessage(playerid, "�س�ըӹǹ�������§�͵�͡�����");

            SendNearbyMessage(playerid, 3.0, COLOR_EMOTE, "> %s ��蹺ҧ���ҧ���Ѻ %s",ReturnName(playerid,0), ReturnName(tagetid,0));
            SendClientMessageEx(playerid, COLOR_GREY, "�س���ͺ Cannabis ���Ѻ %s �ӹǹ %.2f ����",ReturnName(tagetid,0), amout);
            
            format(str, sizeof(str), "[%s] %s Give Drug 'Cannabis' to %s Amount: %.2f", ReturnDate(),ReturnName(playerid,0), ReturnName(tagetid,0), amout);
            SendDiscordMessage("drug", str);
            Log(druglog, WARNING, str);        
            
            PlayerInfo[playerid][pDrug][1]-=amout;
            PlayerInfo[tagetid][pDrug][1]+=amout;
            //GiveDrug(tagetid, type, amout);
            CharacterSave(playerid);
        }
        case 3:
        {
            if(PlayerInfo[playerid][pDrug][2] < amout)
                return SendErrorMessage(playerid, "�س�ըӹǹ�������§�͵�͡�����");

            SendNearbyMessage(playerid, 3.0, COLOR_EMOTE, "> %s ��蹺ҧ���ҧ���Ѻ %s",ReturnName(playerid,0), ReturnName(tagetid,0));
            SendClientMessageEx(playerid, COLOR_GREY, "�س���ͺ Heroin ���Ѻ %s �ӹǹ %.2f ����",ReturnName(tagetid,0), amout);
            
            format(str, sizeof(str), "[%s] %s Give Drug 'Heroin' to %s Amount: %.2f", ReturnDate(),ReturnName(playerid,0), ReturnName(tagetid,0), amout);
            SendDiscordMessage("drug", str);
            Log(druglog, WARNING, str);

            PlayerInfo[playerid][pDrug][2]-=amout;
            PlayerInfo[tagetid][pDrug][2]+=amout;
            //GiveDrug(tagetid, type, amout);
            CharacterSave(playerid);
        }
        default: SendErrorMessage(playerid, "�����������١��ͧ");
    }
    return 1;
}

CMD:usedrug(playerid, params[])
{
    if(PlayerDrugUse[playerid] != -1)
        return SendErrorMessage(playerid, "�س�ѧ�ա���ʾ���ʾ�Դ����㹢�й��");

    new type, Float:health;

    if(sscanf(params, "d", type))
    {
        SendUsageMessage(playerid, "/usedrug <������>");
        SendUsageMessage(playerid, "1.Cocaine 2.Cannabis 3.Heroin");
        return 1;
    }

    if(type < 1 || type > 3)
        return SendErrorMessage(playerid, "�س�����������ʾ�Դ���١ (1-3 ��ҹ��)");

    if(PlayerInfo[playerid][pDrug][type-1] < 0.2)
        return SendErrorMessage(playerid, "�س���������§�͵�͡�÷����ʾ");
    

    GetPlayerHealth(playerid, health);

    switch(type)
    {
        case 1:
        {
            if(health > 170)
                return SendErrorMessage(playerid, "�س�����ʹ�֧�մ�ӡѴ����");

            PlayerDrugUse[playerid] = SetTimerEx("SetPlayerHealth_Stap", 2000, true, "dd",playerid, type);

            SendClientMessage(playerid, COLOR_GREY, "�س���ա���ʾ���ʾ�Դ 'Cocaine' ��������ʹ�ͧ�س�������� +2");
            PlayerInfo[playerid][pDrug][0]-= 0.2;
            PlayerInfo[playerid][pAddicted] = false;
            PlayerInfo[playerid][pAddictedCount] = 1;
            Log(druglog, WARNING, "%s �ա���� ���ʾ�Դ 'Cocaine'", ReturnName(playerid, 0));
            
            new str[120];
            format(str, sizeof(str), "��Ժ���͡���ʾ");
            callcmd::ame(playerid, str);

            format(str, sizeof(str), "%s use drug 'Cocaine'",ReturnRealName(playerid, 0));
            SendDiscordMessageEx("drug", str);
            return 1;
        }
        case 2:
        {
            if(health > 150)
                return SendErrorMessage(playerid, "�س�����ʹ�֧�մ�ӡѴ����");

            PlayerDrugUse[playerid] = SetTimerEx("SetPlayerHealth_Stap", 2000, true, "dd",playerid, type);
            SendClientMessage(playerid, COLOR_GREY, "�س���ա���ʾ���ʾ�Դ 'Cannabis' ��������ʹ�ͧ�س�������� +2");
            PlayerInfo[playerid][pDrug][1]-= 0.2;
            PlayerInfo[playerid][pAddicted] = false;
            PlayerInfo[playerid][pAddictedCount] = 1;
            Log(druglog, WARNING, "%s �ա���� ���ʾ�Դ 'Cannabis'", ReturnName(playerid, 0));
            
            new str[120];
            format(str, sizeof(str), "��Ժ���͡���ʾ");
            callcmd::ame(playerid, str);

            format(str, sizeof(str), "%s use drug 'Cannabis'",ReturnRealName(playerid, 0));
            SendDiscordMessageEx("drug", str);
        }
        case 3:
        {
            if(health > 200)
                return SendErrorMessage(playerid, "�س�����ʹ�֧�մ�ӡѴ����");

            PlayerDrugUse[playerid] = SetTimerEx("SetPlayerHealth_Stap", 2000, true, "dd",playerid, type);
            SendClientMessage(playerid, COLOR_GREY, "�س���ա���ʾ���ʾ�Դ 'Heroin' ��������ʹ�ͧ�س�������� +2");
            PlayerInfo[playerid][pDrug][1]-= 0.2;
            PlayerInfo[playerid][pAddicted] = false;
            PlayerInfo[playerid][pAddictedCount] = 1;
            Log(druglog, WARNING, "%s �ա���� ���ʾ�Դ ''", ReturnName(playerid, 0));
            
            new str[120];
            format(str, sizeof(str), "��Ժ���͡���ʾ");
            callcmd::ame(playerid, str);

            format(str, sizeof(str), "%s use drug 'Heroin'",ReturnRealName(playerid, 0));
            SendDiscordMessageEx("drug", str);
        }
    }
    return 1;
}

CMD:setdrug(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
        return SendUnauthMessage(playerid);

    new tagetid,type, Float:amout;

    if(sscanf(params, "udf", tagetid, type, amout))
    {
        SendUsageMessage(playerid, "/setdrug <���ͺҧ��ǹ/�ʹ�> <���������ʾ�Դ> <�ӹǹ : ����>");
        SendUsageMessage(playerid, "1.Cocaine 2.Cannabis 3.Heroin");
        return 1;
    }

    if(!IsPlayerConnected(tagetid))
        return SendErrorMessage(playerid, "����������������������������");

    if(IsPlayerLogin(tagetid))
        return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");

    if(amout < 0.00)
        return SendErrorMessage(playerid, "���ӹǹ�����Թ�");

    switch(type)
    {
        case 1:
        {
            PlayerInfo[tagetid][pDrug][0] = amout;
            SendClientMessageEx(tagetid, COLOR_YELLOWEX, "���������Ѻ���ʾ�Դ 'Cocaine' �ͧ�س�� %.2f ����",amout);
            SendClientMessageEx(playerid, COLOR_GREY, "�س���Ѻ���ʾ�Դ 'Cocaine' �ͧ %s ����� %.2f ����",ReturnName(tagetid,0), amout);
        }
        case 2:
        {
            PlayerInfo[tagetid][pDrug][1] = amout;
            SendClientMessageEx(tagetid, COLOR_YELLOWEX, "���������Ѻ���ʾ�Դ 'Cannabis' �ͧ�س�� %.2f ����",amout);
            SendClientMessageEx(playerid, COLOR_GREY, "�س���Ѻ���ʾ�Դ 'Cannabis' �ͧ %s ����� %.2f ����",ReturnName(tagetid,0), amout);
        }
        case 3:
        {
            PlayerInfo[tagetid][pDrug][1] = amout;
            SendClientMessageEx(tagetid, COLOR_YELLOWEX, "���������Ѻ���ʾ�Դ 'Heroin' �ͧ�س�� %.2f ����",amout);
            SendClientMessageEx(playerid, COLOR_GREY, "�س���Ѻ���ʾ�Դ 'Heroin' �ͧ %s ����� %.2f ����",ReturnName(tagetid,0), amout);
        }
        default: SendErrorMessage(playerid, "����������ͧ���ʾ�Դ���١��ͧ");
    }
    return 1;
}

CMD:agivedrug(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
        return SendUnauthMessage(playerid);

    new tagetid,type, Float:amout;

    if(sscanf(params, "udf", tagetid, type, amout))
    {
        SendUsageMessage(playerid, "/agivedrug <���ͺҧ��ǹ/�ʹ�> <���������ʾ�Դ> <�ӹǹ : ����>");
        SendUsageMessage(playerid, "1.Cocaine 2.Cannabis 3.Heroin");
        return 1;
    }

    if(!IsPlayerConnected(tagetid))
        return SendErrorMessage(playerid, "����������������������������");

    if(IsPlayerLogin(tagetid))
        return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");

    if(amout < 0.01)
        return SendErrorMessage(playerid, "���ӹǹ�����Թ�");

    switch(type)
    {
        case 1:
        {
            PlayerInfo[tagetid][pDrug][0] += amout;
            SendClientMessageEx(tagetid, COLOR_YELLOWEX, "���������������ʾ�Դ 'Cocaine' �ͧ�س %.2f ����",amout);
            SendClientMessageEx(playerid, COLOR_GREY, "�س���������ʾ�Դ 'Cocaine' �ͧ %s ��� %.2f ����",ReturnName(tagetid,0), amout);
        }
        case 2:
        {
            PlayerInfo[tagetid][pDrug][1] += amout;
            SendClientMessageEx(tagetid, COLOR_YELLOWEX, "���������������ʾ�Դ 'Cannabis' �ͧ�س %.2f ����",amout);
            SendClientMessageEx(playerid, COLOR_GREY, "�س���������ʾ�Դ 'Cannabis' �ͧ %s ��� %.2f ����",ReturnName(tagetid,0), amout);
        }
        case 3:
        {
            PlayerInfo[tagetid][pDrug][2] += amout;
            SendClientMessageEx(tagetid, COLOR_YELLOWEX, "���������������ʾ�Դ 'Heroin' �ͧ�س %.2f ����",amout);
            SendClientMessageEx(playerid, COLOR_GREY, "�س���������ʾ�Դ 'Heroin' �ͧ %s ��� %.2f ����",ReturnName(tagetid,0), amout);
        }
        default: SendErrorMessage(playerid, "����������ͧ���ʾ�Դ���١��ͧ");
    }
    return 1;
}


forward SetPlayerHealth_Stap(playerid, type);
public SetPlayerHealth_Stap(playerid, type)
{
    new Float:health;

    GetPlayerHealth(playerid, health);

    if(GetPlayerTeam(playerid) != PLAYER_STATE_ALIVE)
    {
        KillTimer(PlayerDrugUse[playerid]);
        PlayerDrugUse[playerid] = -1;
        SendClientMessage(playerid, COLOR_LIGHTRED, "ʶҹФس�������������Ѻ����ʾ��");
        return 1;
    }

    if(PlayerDrugUse[playerid] == -1)
        return 1;

    switch(type)
    {
        case 1:
        {
            if(health > 170)
            {
                SetPlayerHealth(playerid, 170);
                KillTimer(PlayerDrugUse[playerid]);
                PlayerDrugUse[playerid] = -1;
                GameTextForPlayer(playerid, "~r~Max Health Increase", 5000, 4);
                return 1;
            }

            GivePlayerHealth(playerid, 2);
        }
        case 2:
        {
            if(health > 150)
            {
                SetPlayerHealth(playerid, 150);
                KillTimer(PlayerDrugUse[playerid]);
                PlayerDrugUse[playerid] = -1;
                GameTextForPlayer(playerid, "~r~Max Health Increase", 5000, 4);
                return 1;
            }
            GivePlayerHealth(playerid, 2);
        }
        case 3:
        {
            if(health > 200)
            {
                SetPlayerHealth(playerid, 200);
                KillTimer(PlayerDrugUse[playerid]);
                PlayerDrugUse[playerid] = -1;
                GameTextForPlayer(playerid, "~r~Max Health Increase", 5000, 4);
                return 1;
            }
            GivePlayerHealth(playerid, 2);
        }
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    KillTimer(PlayerDrugUse[playerid]);
    PlayerDrugUse[playerid] = -1;
    return 1;
}