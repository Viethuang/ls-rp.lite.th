#include <YSI_Coding\y_hooks>

#define DEFAULT_STOCK (100)
#define CARGO_PRICE (65)

new bool:PlayerGetcargo[MAX_PLAYERS];


enum cargo_get_data
{
    Float:cargo_pos_x,
    Float:cargo_pos_y,
    Float:cargo_pos_z,
    cargo_stock,
    Text3D:cargo_text
}
new cargoinfo[][cargo_get_data] = 
{
    {2734.831,-2465.132,13.648, DEFAULT_STOCK}
};



enum T_BOX_DROP
{
	bool:TruckerDrop,
	TruckerObject,
    TruckerType,
	TruckerTimer,
	
	Float:TruckerPos[3],
	TruckerInterior,
	TruckerWorld,
	
	TruckerDroppedBy
}

new TruckerObjDrop[200][T_BOX_DROP];
new CargoSellPosPoint[MAX_PLAYERS];


hook OP_Connect(playerid)
{
    PlayerGetcargo[playerid] = false;
    CargoSellPosPoint[playerid] = 0;
    return 1;
}


enum v_trucker {
    v_cargo_box,
};
new VehicleCargo[MAX_VEHICLES][v_trucker];


new const Float:CargoSellPos[11][3] = {
	{1467.5077,-1233.7401,161.3438},
	{2381.5671,-1905.5107,13.5469},
	{2125.8206,-1819.8051,13.5546},
    {1914.0164,-1785.1846,13.5469},
    {1341.8522,-1768.4110,13.5140},
    {1315.6212,-875.9968,39.5781},
    {1185.7675,-912.1340,43.2590},
    {1000.6126,-920.0488,42.3281},
    {479.4545,-1535.7347,19.5742},
    {503.5644,-1405.9856,16.1569},
    {791.7493,-1607.5709,13.3906}
};


//2483.477, -2120.070, 13.546, 352.181 : General goods supplier


hook OnGameModeInit()
{
    new str[120];
    format(str, sizeof(str), "General goods supplier\n{559ABD}Stock %d/100", DEFAULT_STOCK);

    cargoinfo[0][cargo_text] = CreateDynamic3DTextLabel(str, COLOR_WHITE, 2734.831,-2465.132,13.648, 25.0);
    return 1;
}


hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(IsPlayerInTruckVehicle(playerid))
		{
            
            if(VehicleCargo[GetPlayerVehicleID(playerid)][v_cargo_box])
                return 1;
            
            SendClientMessage(playerid, -1, "�س����ö�� /startshipment �����������èѴ�觴���ö��÷ء��");
            return 1;
		}
	}
	return 1;
}


alias:startshipment("guiedship", "�ҹ�觢ͧ")
CMD:startshipment(playerid, params[])
{
    new str[4000], longstr[4000];

    format(str, sizeof(str), "���ʴդسʹ㨷��зӧҹ��Ҫվ�觡��ͧ�Թ������������? ����Թ�շ����йӤس����Ҫվ�ӧҹ���ҧ��\n");
    strcat(longstr, str);
    format(str, sizeof(str), "���ҧ�á�����ҡ���س��������͹�������Ҫվ������Ҫվ����������������������� ���ͤس������繧ҹ��Шӡ���\n");
    strcat(longstr, str);
    format(str, sizeof(str), "��÷��Ҫվ������ҧ�á��¤س��е�ͧ���ҹ��˹С�͹ ����ª����ҹ��˹з������ö���ͧ������ �ѧ���\n");
    strcat(longstr, str);
    format(str, sizeof(str), "Bobcat ��è��� 5 ���ͧ\n");
    strcat(longstr, str);
    format(str, sizeof(str), "Burrito ��è��� 5 ���ͧ\n");
    strcat(longstr, str);
    format(str, sizeof(str), "Boxville Mission ��è��� 8 ���ͧ\n");
    strcat(longstr, str);
    format(str, sizeof(str), "Mule ��è��� 12 ���ͧ\n");
    strcat(longstr, str);
    format(str, sizeof(str), "Benson ��è��� 15 ���ͧ\n");
    strcat(longstr, str);
    format(str, sizeof(str), "�¤���觾�鹰ҹ�س����ö���оԾ�� /shipmentcmds ���ʹ١����ҹ������������\n");
    strcat(longstr, str);

    Dialog_Show(playerid, DEFAULT_DIALOG, DIALOG_STYLE_MSGBOX, "TRUCK GUIED", longstr, "�׹�ѹ", "");
    
    return 1;
}

CMD:shipmentcmds(playerid, params[])
{
    SendClientMessage(playerid, COLOR_DARKGREEN, "-------------www.lsrplite.in.th-------------");
    SendClientMessage(playerid, -1, "/startshipment -�٤��йӧҹ");
    SendClientMessage(playerid, -1, "/pickupcreate(/getcargo) -���͡��ͧ�Թ���");
    SendClientMessage(playerid, -1, "/loadcreate(/loadcargo) -�ҧ���ͧ�Թ���ŧ��ҹ��˹�");
    SendClientMessage(playerid, -1, "/dropcreate(/dropcargo) -��駡��ͧ�Թ���");
    SendClientMessage(playerid, -1, "/unloadcreate(/unloadcargo) -��Ժ���ͧ�Թ����͡�Ҩҡ�ҹ��˹�");
    SendClientMessage(playerid, -1, "/sellcreate(/sellcargo) -��¡��ͧ�Թ������Ѻ�Ԩ���");
    SendClientMessage(playerid, COLOR_DARKGREEN, "-------------www.lsrplite.in.th-------------");
    return 1;
}

alias:pickupcreate("getcargo", "��Ժ���ͧ")
CMD:pickupcreate(playerid, params[])
{
    new id = 0;

    if(PlayerInfo[playerid][pCash] < CARGO_PRICE)
        return SendErrorMessage(playerid, "�س���Թ�����§�� ��ͧ���Թ���ҧ���� $%d", CARGO_PRICE);

    for(new i = 0; i < sizeof cargoinfo; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, cargoinfo[i][cargo_pos_x], cargoinfo[i][cargo_pos_y], cargoinfo[i][cargo_pos_z]))
        {
            id = i;
        }
    }

    if(!id)
    {
        if(!IsPlayerInRangeOfPoint(playerid, 3.0, cargoinfo[id][cargo_pos_x], cargoinfo[id][cargo_pos_y], cargoinfo[id][cargo_pos_z]))
            return SendErrorMessage(playerid, "�س���������㹨ش��Ժ���ͧ�Թ���...");
    }
    else
    {
        return SendErrorMessage(playerid, "�س���������㹨ش��Ժ���ͧ�Թ���");
    }

    if(!cargoinfo[id][cargo_stock])
        return SendErrorMessage(playerid, "��ѧ�Թ���㹵͹����������");
    
    GetPlayerCargo(playerid);
    new str[120];

    cargoinfo[id][cargo_stock]--;
    GiveMoney(playerid, -CARGO_PRICE);
    SendClientMessage(playerid, -1, "{559ABD}TRUCKER {FFFFFF} �س��Ժ���ͧ����� �Թ价�����ö��÷ء�ͧ�س��о���� {559ABD}/loadcreate{FFFFFF} ���ʹ��Թ��õ��");
    format(str, sizeof(str), "General goods supplier\n{559ABD}Stock %d/100", cargoinfo[id][cargo_stock]);
    UpdateDynamic3DTextLabelText(cargoinfo[id][cargo_text], COLOR_WHITE, str);
    return 1;
}

alias:loadcreate("loadcargo", "�ҧ���ͧ")
CMD:loadcreate(playerid, params[])
{
    if(PlayerGetcargo[playerid] == false)
        return SendErrorMessage(playerid, "�س������͡��ͧ�Թ���");

    new
        Float:x,
        Float:y,
        Float:z
    ;

    if(!IsPlayerInAnyVehicle(playerid) && GetNearestVehicle(playerid) != INVALID_VEHICLE_ID)
    {
            GetVehicleBoot(GetNearestVehicle(playerid), x, y, z); 
            new vehicleid = GetNearestVehicle(playerid);

            if(!HasTruckVehicle(vehicleid))
                return SendErrorMessage(playerid, "�س�������������ҹ��˹з���������Ѻ�����ͧ");

            
            if(VehicleInfo[vehicleid][eVehicleLocked])
                return SendServerMessage(playerid, "ö�ѹ���١��ͤ����");

            if(!IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z))
                return SendErrorMessage(playerid, "�س���������������ö");

            if(!CheckStockInVehicle(vehicleid))
            {
                new randdom = Random(1, 11);
                CargoSellPosPoint[playerid] = randdom;
                SendErrorMessage(playerid, "�ͧ��ҹ��˹е͹����������");
                return SetPlayerCheckpoint(playerid, CargoSellPos[CargoSellPosPoint[playerid]][0], CargoSellPos[CargoSellPosPoint[playerid]][1], CargoSellPos[CargoSellPosPoint[playerid]][2], 2);
            }


            VehicleCargo[vehicleid][v_cargo_box]++;
            PlaceCargo(playerid);

            SendClientMessageEx(playerid, -1, "{559ABD}TRUCKER :{FFFFFF} �س��è��ѧŧ�ö��÷ء�ͧ�س���� - �س�� {559ABD}%d{FFFFFF} ��ҹ��˹Тͧ�س", VehicleCargo[vehicleid][v_cargo_box]);
            SendClientMessage(playerid, -1, "{559ABD}TRUCKER :{FFFFFF} �س����ö�� {559ABD}/deliveroo{FFFFFF} �������ͺ�ŧҹ�Ѩ�غѹ�ͧ�س");
            SendClientMessage(playerid, -1, "{559ABD}TRUCKER:{FFFFFF} �س��Ժ���ͧ����� �Թ价�����ö��÷ء�ͧ�س��о������о���� {F1C40F}/loadcreate {FFFFFF} ���ʹ��Թ��õ��");

            if(!CheckStockInVehicle(vehicleid))
            {
                new randdom = Random(1, 11);
                CargoSellPosPoint[playerid] = randdom;
                return SetPlayerCheckpoint(playerid, CargoSellPos[CargoSellPosPoint[playerid]][0], CargoSellPos[CargoSellPosPoint[playerid]][1], CargoSellPos[CargoSellPosPoint[playerid]][2], 2);
            } 

            return 1;
    }
    else return SendErrorMessage(playerid, "�س�������������ҹ��˹��觢ͧ");
}

alias:dropcreate("dropcargo", "��駡��ͧ")
CMD:dropcreate(playerid, params[])
{
    
    if(PlayerGetcargo[playerid] == false)
        return SendErrorMessage(playerid, "�س������͡��ͧ�Թ���");


    GiveMoney(playerid, CARGO_PRICE);
    SendClientMessage(playerid, -1, "�س���駡��ͧ�Թ���ŧ���");
    PlaceCargo(playerid);
    return 1;
}

alias:unloadcreate("unloadcargo", "��Ժ���ͧ���")
CMD:unloadcreate(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid) && GetNearestVehicle(playerid) != INVALID_VEHICLE_ID)
    {
        new
            Float:x,
            Float:y,
            Float:z
        ;

        GetVehicleBoot(GetNearestVehicle(playerid), x, y, z); 
        new vehicleid = GetNearestVehicle(playerid);

        if(!HasTruckVehicle(vehicleid))
            return SendErrorMessage(playerid, "�س�������������ҹ��˹з���������Ѻ�����ͧ");

            
        if(VehicleInfo[vehicleid][eVehicleLocked])
            return SendServerMessage(playerid, "ö�ѹ���١��ͤ����");

        if(!IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z))
            return SendErrorMessage(playerid, "�س���������������ö");

        if(!VehicleCargo[vehicleid][v_cargo_box])
            return SendErrorMessage(playerid, "����ա��ͧ�Թ������������ҹ��˹�");

    
        SendClientMessage(playerid, -1, "TRUCKER: �س����Ժ���ͧ�Թ����͡�Ҩҡö �Թ价��⫹��èѴ����о���� /sellcreate ���ʹ��Թ��õ��");
        GetPlayerCargo(playerid);
        VehicleCargo[vehicleid][v_cargo_box]--;
        SetPlayerCheckpoint(playerid, CargoSellPos[CargoSellPosPoint[playerid]][0], CargoSellPos[CargoSellPosPoint[playerid]][1], CargoSellPos[CargoSellPosPoint[playerid]][2], 2);
        return 1;
    }
    else SendErrorMessage(playerid, "�س����������������ҹ��˹�ö��÷ء");
    
    return 1;
}

alias:sellcreate("sellcargo", "��¡��ͧ")
CMD:sellcreate(playerid, params[])
{
    if(PlayerGetcargo[playerid] == false)
        return SendErrorMessage(playerid, "�س������͡��ͧ�Թ���");
    
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, CargoSellPos[CargoSellPosPoint[playerid]][0], CargoSellPos[CargoSellPosPoint[playerid]][1], CargoSellPos[CargoSellPosPoint[playerid]][2]))
        return SendErrorMessage(playerid, "�س���������㹨ش����Թ���");

    
    new money = CARGO_PRICE*2;
    SendClientMessageEx(playerid, -1, "�س���觡��ͧ�Թ��� ���ˡ������������ "EMBED_GREENMONEY"- ���Ѻ�Թ $%s", MoneyFormat(money));
    
    GiveMoney(playerid, money);

    PlaceCargo(playerid);
    DisablePlayerCheckpoint(playerid);
    return 1;
}





stock CheckStockInVehicle(vehicleid)
{
    switch(GetVehicleModel(vehicleid))
    {
        case 422,482:
        {
            if(VehicleCargo[vehicleid][v_cargo_box] >= 5)
                return 0;

            return 1;
        }
        case 609:
        {
            if(VehicleCargo[vehicleid][v_cargo_box] >= 8)
                return 0;
            
            return 1;
        }
        case 414:
        {
            if(VehicleCargo[vehicleid][v_cargo_box] >= 12)
                return 0;

            return 1;
        }
        case 499:
        {
            if(VehicleCargo[vehicleid][v_cargo_box] >= 15)
                return 0;

            return 1;
        }
    }
    return 0;
}


stock IsPlayerInTruckVehicle(playerid)
{
	new
		vehicleid = GetPlayerVehicleID(playerid);
	
	if(!vehicleid)
		return 0; 
		
	switch(GetVehicleModel(vehicleid))
    {
        case 422,482,609,414,499: return 1;
    }
		
	return 0;
}


stock HasTruckVehicle(vehicleid)
{

    switch(GetVehicleModel(vehicleid))
    {
        case 422,482,609,414,499: return 1;
        default: return 0;
    }

    return 0;
}





forward DeleteCargoObj(id);
public DeleteCargoObj(id)
{
    TruckerObjDrop[id][TruckerDrop] = false;
    TruckerObjDrop[id][TruckerDroppedBy] = 0;
    TruckerObjDrop[id][TruckerPos][0] = 0.0;
    TruckerObjDrop[id][TruckerPos][1] = 0.0;
    TruckerObjDrop[id][TruckerPos][2] = 0.0;
    TruckerObjDrop[id][TruckerInterior] = 0;
    TruckerObjDrop[id][TruckerWorld] = 0;
    TruckerObjDrop[id][TruckerType] = 0;
    DestroyDynamicObject(TruckerObjDrop[id][TruckerObject]);
    KillTimer(TruckerObjDrop[id][TruckerTimer]);
    return 1;
}


stock GetPlayerCargo(playerid)
{
    PlayerGetcargo[playerid] = true;
    ApplyAnimation(playerid, "CARRY","liftup", 4.1, 0, 0, 0, 0, 0, 1);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    SetPlayerAttachedObject(playerid, 9, 2912, 1, -0.019, 0.713999, -0.076, 0, 87.1, -9.4, 1.0000, 1.0000, 1.0000);

    new str[90];
    format(str, sizeof(str), "��¡���ͧ�Թ��Ң���Ҵ����ͧ���");
    callcmd::me(playerid, str);
    return 1;
}

stock PlaceCargo(playerid)
{
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(playerid, 9);
    PlayerGetcargo[playerid] = false;
    return 1;
}








