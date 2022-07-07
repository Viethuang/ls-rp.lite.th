#include <YSI_Coding\y_hooks>


new dmv_vehicles[4];

new bool:PlayerTakingLicense[MAX_PLAYERS], PlayerLicenseTime[MAX_PLAYERS]; 
new PlayerLicensePoint[MAX_PLAYERS]; 
new PlayersLicenseVehicle[MAX_PLAYERS]; 
new Speedveh[MAX_PLAYERS], VehicleID[MAX_PLAYERS];

enum E_LICENSETEST_INFO
{
	Float: eCheckpointX,
	Float: eCheckpointY,
	Float: eCheckpointZ,
	bool: eFinishLine
}


new LicensetestInfo[][E_LICENSETEST_INFO] = 
{
	{1237.5154, -1572.2375, 13.3828, false},
	{1186.1718, -1572.1316, 13.3828, false},
	{1122.9329, -1572.2052, 13.4022, false},
	{1046.1570, -1569.9575, 13.3828, false},
	{1050.3602, -1506.8011, 13.3906, false},
	{1065.1661, -1416.7653, 13.4577, false},
	{1183.5283, -1405.4906, 13.2156, false},
	{1261.6847, -1405.8959, 13.0086, false},
	{1332.1536, -1405.6932, 13.3703, false},
	{1324.8597, -1486.7848, 13.3828, false},
	{1295.2579, -1561.2516, 13.3906, true}
};

hook OnGameModeInit()
{
    dmv_vehicles[0] = AddStaticVehicle(405,1270.5680,-1557.5950,13.4384,270.6683,1,1); SetVehicleNumberPlate(dmv_vehicles[0], "DMV");
    dmv_vehicles[1] = AddStaticVehicle(405,1270.4249,-1554.2535,13.4394,269.7206,1,1); SetVehicleNumberPlate(dmv_vehicles[1], "DMV");
    dmv_vehicles[2] = AddStaticVehicle(405,1270.3258,-1551.0619,13.4829,271.6855,1,1); SetVehicleNumberPlate(dmv_vehicles[2], "DMV");
    dmv_vehicles[3] = AddStaticVehicle(405,1270.4993,-1547.6730,13.4389,270.6118,1,1); SetVehicleNumberPlate(dmv_vehicles[3], "DMV");
    

	for(new c = 0; c < sizeof dmv_vehicles; c++) {
    	SetVehicleNumberPlate(dmv_vehicles[c], "DMV");
		format(VehicleInfo[dmv_vehicles[c]][eVehiclePlates], 32, "DMV");
		SetVehicleParamsEx(dmv_vehicles[c], 0, 0, 0, 0, 0, 0, 0);
		VehicleInfo[dmv_vehicles[c]][eVehicleFuel] = 100;
        VehicleInfo[dmv_vehicles[c]][eVehicleEngine] = 100;
	}
	
	return 1;
}


stock IsPlayerInDMVVehicle(playerid)
{
	new
		vehicleid = GetPlayerVehicleID(playerid);
	
	if(!vehicleid)
		return 0; 
		
	for(new i = 0; i < sizeof dmv_vehicles; i++)
	{
		if(vehicleid == dmv_vehicles[i])
			return 1;
	}
		
	return 0;
}

stock StopDriverstest(playerid)
{
	SetVehicleToRespawn(PlayersLicenseVehicle[playerid]);
	ToggleVehicleEngine(PlayersLicenseVehicle[playerid], false); 
	VehicleInfo[PlayersLicenseVehicle[playerid]][eVehicleEngineStatus] = false;
	
	PlayersLicenseVehicle[playerid] = INVALID_VEHICLE_ID; 
	
	PlayerLicensePoint[playerid] = 0;
	PlayerTakingLicense[playerid] = false;
	Speedveh[playerid] = 0;
	VehicleID[playerid] = 0;
	
	DisablePlayerCheckpoint(playerid);
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(PlayerTakingLicense[playerid])
	{
		if(PlayerCheckpoint[playerid] == 2)
		{
			StopDriverstest(playerid);
			SendClientMessageEx(playerid, COLOR_RED, "����� %s ���ҹ��÷��ͺ㺢Ѻ�������", ReturnName(playerid, 0)); 
			
			PlayerInfo[playerid][pDriverLicense] = true;
			PlayerInfo[playerid][pDriverLicenseWarn] = 0;
			PlayerInfo[playerid][pDriverLicenseRevoke] = false;
			PlayerInfo[playerid][pDriverLicenseSus] = false;

			CharacterSave(playerid);
			
			PlayerCheckpoint[playerid] = 0; 
			return 1; 
		}
		if(PlayerLicensePoint[playerid] < sizeof LicensetestInfo)
		{
			SendClientMessage(playerid, COLOR_GREY, "��ѡ�ҹ�ͺ㺢Ѻ��� �ٴ���: �Ѻö仵���ش���ҧ���Ѵ���ѧ"); 
			PlayerLicensePoint[playerid]++;
			PlayerLicenseTime[playerid] += 35; 
				
			new 
				idx = PlayerLicensePoint[playerid]
			;
				
			SetPlayerCheckpoint(playerid, LicensetestInfo[idx][eCheckpointX], LicensetestInfo[idx][eCheckpointY], LicensetestInfo[idx][eCheckpointZ], 3.0);
				
			if(LicensetestInfo[idx][eFinishLine])
			{
				//StopDriverstest(playerid);
				PlayerCheckpoint[playerid] = 2;

				if(Speedveh[playerid] > 3)
				{
					StopDriverstest(playerid);
					SendClientMessage(playerid, COLOR_GREY, "��ѡ�ҹ�ͺ㺢Ѻ��� �ٴ���: �س�Ѻö�����Թ���ҷ����ҡ�˹���� ���ʴ���������㨴��¤س�ͺ����ҹ"); 
				}
			}
		}
	}
    return 1;
}

ptask PlayerLicenseTimeCount[1000](playerid) 
{
	if(PlayerTakingLicense[playerid] && PlayerLicenseTime[playerid] <= 2000)
    {
        PlayerLicenseTime[playerid]--; 
                
        new
            str[128]
        ;
                
        format(str, sizeof(str), "~w~%d", PlayerLicenseTime[playerid]);
        GameTextForPlayer(playerid, str, 2000, 3); 
                
        if(PlayerLicenseTime[playerid] < 1)
        {
            StopDriverstest(playerid);
            SendClientMessage(playerid, COLOR_RED, "�س�Ѻö�ҹ�Թ仡������ҷ���˹�"); 
        }
        if(GetVehicleSpeed(VehicleID[playerid]) > 100)
        {
			Speedveh[playerid]++;
			SendClientMessageEx(playerid, COLOR_RED, "�Ѻ�Թ 100 �������õ�ͪ������ �س�Ҩ������ҹ�����ͺ����� (%d)", Speedveh[playerid]); 
        }
    }
	return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(!ispassenger)
	{
		for(new i = 0; i < sizeof dmv_vehicles; i++) if(vehicleid == dmv_vehicles[i])
		{
			if(PlayerInfo[playerid][pDriverLicense])
			{
				SendErrorMessage(playerid, "�س��㺢Ѻ�����������");
				return ClearAnimations(playerid);
			}
		}
	}
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(IsPlayerInDMVVehicle(playerid))
		{
			SendClientMessage(playerid, -1, "{17A589}�͹���س�����躹ö ���ͺ㺢Ѻ��� �س����ö����� {FFFF00}/licenseexam {17A589}���ͷӡ�÷��ͺ��âѺö�ͧ�س");
			SendClientMessage(playerid, -1, "{F44336}---------------------------------{F4511E}Rule TestDriver{F44336}---------------------------------");
			SendClientMessage(playerid, -1, "1.�����Ѻö���Ƿ����ö ������������Դ����");
			SendClientMessage(playerid, -1, "2.�����Ѻ���¤��������Թ 100 �������õ�ͪ������");
			SendClientMessage(playerid, -1, "{F44336}---------------------------------{F4511E}Rule TestDriver{F44336}---------------------------------");
			SendClientMessage(playerid, COLOR_RED, "������ö������㹡����蹺��ҷ����������դ�������Ǣ�ͧ��Ѻ ��÷��ͺ�Ѻö��� �ҡ����� �зӡ����");
			SendClientMessage(playerid, COLOR_RED, "�ء�ʹ�Թ ����������������");
			return 1;
		}
	}
	return 1;
}

CMD:licenseexam(playerid, params[])
{
	if(PlayerInfo[playerid][pDriverLicense] == true)
		return SendErrorMessage(playerid, "�س��㺢Ѻ�����������");

	if(PlayerInfo[playerid][pDriverLicenseRevoke] == true)
		return SendErrorMessage(playerid, "�س��㺢Ѻ����������� (�١�ִ)");
	
	if(!IsPlayerInDMVVehicle(playerid))
		return SendErrorMessage(playerid, "�س��������躹ö���ͺ��âѺ���"); 
		
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendErrorMessage(playerid, "�س������繤��Ѻö"); 
		
	if(PlayerTakingLicense[playerid])
		return SendErrorMessage(playerid, "�س���ѧ�ӡ�÷��ͺ��âѺ�������");
		
	new
		vehicleid = GetPlayerVehicleID(playerid);

	PlayerTakingLicense[playerid] = true; 
	PlayerLicenseTime[playerid] = 100;
	
	PlayersLicenseVehicle[playerid] = vehicleid;
	PlayerLicensePoint[playerid] = 0; 
	
	ToggleVehicleEngine(vehicleid, true); 
	VehicleInfo[vehicleid][eVehicleEngineStatus] = true;
	
	SendClientMessage(playerid, COLOR_GREY, "��ѡ�ҹ㺢Ѻ��� �ٴ���: ��سҢѺö����ش�社������ҧ���Ѵ���ѧ");
	TogglePlayerControllable(playerid, 1);

	VehicleID[playerid] = GetPlayerVehicleID(playerid);
	SetPlayerCheckpoint(playerid, LicensetestInfo[0][eCheckpointX], LicensetestInfo[1][eCheckpointY], LicensetestInfo[2][eCheckpointZ], 3.0); 
	return 1;
}

