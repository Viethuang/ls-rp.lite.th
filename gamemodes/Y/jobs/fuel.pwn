#include <YSI_Coding\y_hooks>

new PlayerGetFuel[MAX_PLAYERS];

CMD:fuel(playerid, params[])
{
    new option[16];

    if(sscanf(params, "s[16]", option))
    {
        SendClientMessage(playerid, COLOR_GRAD3, "Available commands:");
	    SendClientMessage(playerid, -1, ""EMBED_YELLOW"/fuel list "EMBED_WHITE"- �ʴ��ӹǹ�ѧ����ѹ�����������ö");
        SendClientMessage(playerid, -1, ""EMBED_YELLOW"/fuel place "EMBED_WHITE"- �ҧ�ѧ����ѹŧ�");
        SendClientMessage(playerid, -1, ""EMBED_YELLOW"/fuel get "EMBED_WHITE"- ¡�ѧ����ѹ�����");
        SendClientMessage(playerid, -1, ""EMBED_YELLOW"/fuel drop "EMBED_WHITE"- �ҧ�ѧ����ѹ");
        SendClientMessage(playerid, -1, ""EMBED_YELLOW"/fuel buy "EMBED_WHITE"- ���Ͷѧ����ѹ");
        SendClientMessage(playerid, -1, ""EMBED_YELLOW"/fuel sell "EMBED_WHITE"- ��¹���ѹ���Ѻ�Ԩ���");
        return 1;
    }

    if(!strcmp(option, "list", true))
    {
        new Float:x, Float:y, Float:z;
        if(!IsPlayerInAnyVehicle(playerid) && GetNearestVehicle(playerid) != INVALID_VEHICLE_ID)
        {
            GetVehicleBoot(GetNearestVehicle(playerid), x, y, z); 
            new 
                vehicleid = GetNearestVehicle(playerid)
            ;

            if(!IsCheckVehicleFuel(vehicleid))
                return SendErrorMessage(playerid, "�س�������������ҹ��˹з���������Ѻ���觹���ѹ");

            if(VehicleInfo[vehicleid][eVehicleLocked])
                return SendServerMessage(playerid, "ö�ѹ���١��ͤ����");

            if(!IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z))
                return SendErrorMessage(playerid, "�س���������������ö");

            SendClientMessageEx(playerid, COLOR_ORANGE, "����ѹ��������������ҹ��˹� %s �ӹǹ: %d �ѧ",ReturnVehicleName(vehicleid), VehicleInfo[vehicleid][eVehicleFuelStock]);
            return 1;

        }

        else SendErrorMessage(playerid, "�س�������������ҹ��˹�");
    }
    else if(!strcmp(option, "place", true))
    {
        if(!PlayerGetFuel[playerid])
            return SendErrorMessage(playerid, "�س������Ͷѧ����ѹ");

        new Float:x, Float:y, Float:z;
        if(!IsPlayerInAnyVehicle(playerid) && GetNearestVehicle(playerid) != INVALID_VEHICLE_ID)
        {
            GetVehicleBoot(GetNearestVehicle(playerid), x, y, z); 
            new 
                vehicleid = GetNearestVehicle(playerid)
            ;

            if(!IsCheckVehicleFuel(vehicleid))
                return SendErrorMessage(playerid, "�س�������������ҹ��˹з���������Ѻ���觹���ѹ");

            if(VehicleInfo[vehicleid][eVehicleLocked])
                return SendServerMessage(playerid, "ö�ѹ���١��ͤ����");

            if(!IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z))
                return SendErrorMessage(playerid, "�س���������������ö");


            new modelid = GetVehicleModel(vehicleid);


            switch(modelid)
            {
                case 422, 554:
                {
                    if(VehicleInfo[vehicleid][eVehicleFuelStock] > 4)
                        return SendErrorMessage(playerid, "�ҹ��ҹФѹ����������");

                    VehicleInfo[vehicleid][eVehicleFuelStock]++;
                    PlaceFuel(playerid);
                    return 1;
                }
                case 573:
                {
                    if(VehicleInfo[vehicleid][eVehicleFuelStock] > 10)
                        return SendErrorMessage(playerid, "�ҹ��ҹФѹ����������");

                    VehicleInfo[vehicleid][eVehicleFuelStock]++;
                    PlaceFuel(playerid);
                    return 1;
                }
            }
            return 1;

        }
    }
    else if(!strcmp(option, "get", true))
    {
        if(PlayerGetFuel[playerid])
            return SendErrorMessage(playerid, "�س��Ͷѧ����ѹ����");

        new Float:x, Float:y, Float:z;
        if(!IsPlayerInAnyVehicle(playerid) && GetNearestVehicle(playerid) != INVALID_VEHICLE_ID)
        {
            GetVehicleBoot(GetNearestVehicle(playerid), x, y, z); 
            new 
                vehicleid = GetNearestVehicle(playerid)
            ;

            if(!IsCheckVehicleFuel(vehicleid))
                return SendErrorMessage(playerid, "�س�������������ҹ��˹з���������Ѻ���觹���ѹ");

            if(VehicleInfo[vehicleid][eVehicleLocked])
                return SendServerMessage(playerid, "ö�ѹ���١��ͤ����");

            if(!IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z))
                return SendErrorMessage(playerid, "�س���������������ö");


            if(!VehicleInfo[vehicleid][eVehicleFuelStock])
                return SendErrorMessage(playerid, "�ҹ��˹Фѹ���������նѧ����ѹ�ѡ�����");


            VehicleInfo[vehicleid][eVehicleFuelStock]--;
            GetPlayerFuel(playerid);
            return 1;

        }
    }
    else if(!strcmp(option, "buy", true))
    {
        if(!IsPlayerInRangeOfPoint(playerid, 3.0, -1024.2225,-688.4048,32.0078) && !IsPlayerInRangeOfPoint(playerid, 3.0, -1030.3638,-688.3743,32.0126) && !IsPlayerInRangeOfPoint(playerid, 3.0, -1037.9266,-688.1974,32.0126))
            return SendErrorMessage(playerid,"�س���������㹨ش�Ѻ����ѹ");

        if(PlayerInfo[playerid][pCash] < 100)
            return SendErrorMessage(playerid, "�س���Թ�����§�� ($100)");
        
        GiveMoney(playerid, -100);
        GetPlayerFuel(playerid);
        return 1;
    }
    else if(!strcmp(option, "sell", true))
    {
        if(!PlayerGetFuel[playerid])
            return SendErrorMessage(playerid, "�س������Ͷѧ����ѹ");

        
        new id;
        for(new i = 1; i < MAX_FUELS; i++)
        {
            if(!FuelInfo[i][F_ID])
                continue;
            
            if(IsPlayerInRangeOfPoint(playerid, 3.5, FuelInfo[i][F_Pos][0], FuelInfo[i][F_Pos][1], FuelInfo[i][F_Pos][2]))
            {
                id = i;
                break;
            }
        }

        if(id == 0)
            return SendErrorMessage(playerid, "�س���������������������ѹ");

        new b_id = FuelInfo[id][F_Business];

        if(!BusinessInfo[b_id][BusinessCash])
            return SendErrorMessage(playerid, "�Թ���㹡Ԩ��ù���������");
        

        if(FuelInfo[id][F_Fuel] >= 99999.0)
            return SendErrorMessage(playerid, "�ѧ������չ���ѹ����������");

        FuelInfo[id][F_Fuel] += 50.0;
        UpdateFuel(id);
        PlaceFuel(playerid);
        GiveMoney(playerid, FuelInfo[id][F_PriceBuy]);
        BusinessInfo[b_id][BusinessCash] -= FuelInfo[id][F_PriceBuy];

        CharacterSave(playerid);
        SaveFuel(id);
        return 1;
    }
    else if(!strcmp(option, "drop", true))
    {
        if(!PlayerGetFuel[playerid])
            return SendErrorMessage(playerid, "�س������Ͷѧ����ѹ");
        
        PlaceFuel(playerid);
        SendNearbyMessage(playerid, 5.5, COLOR_EMOTE, "> %s ���ҧ�ѧ����ѹŧ�", ReturnName(playerid,0));
        return 1;
    }
    return 1;
}


stock GetPlayerFuel(playerid)
{
    PlayerGetFuel[playerid] = true;
    ApplyAnimation(playerid, "CARRY","liftup", 4.1, 0, 0, 0, 0, 0, 1);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    SetPlayerAttachedObject(playerid, 9, 3632, 5, 0.092999, 0.373000, 0.186999, -80.899963, -9.800071, 178.300048, 0.714000, 0.712000, 0.793000);

    new str[90];
    format(str, sizeof(str), "��¡�ѧ����ѹ��������������ͧ���");
    callcmd::me(playerid, str);
    return 1;
}

stock PlaceFuel(playerid)
{
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(playerid, 9);
    PlayerGetFuel[playerid] = false;
    return 1;
}