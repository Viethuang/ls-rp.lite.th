#include <YSI_Coding\y_hooks>

static
    loginAttempt[MAX_PLAYERS], 
    g_MysqlRaceCheck[MAX_PLAYERS];

hook OnPlayerDisconnect(playerid, reason) {
	loginAttempt[playerid]=0;
	g_MysqlRaceCheck[playerid]++;
    return 1;
}

forward OnPlayerJoin(playerid);
public OnPlayerJoin(playerid)
{
	new rows;
	cache_get_value_index_int(0, 0, rows);
	if(rows) Auth_Login(playerid);
	else Auth_Register(playerid);
	return 1;
}

forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{
	SendClientMessage(playerid, COLOR_YELLOW2, "�ͺ�س����Ѻ���ŧ����¹! �س����ö�������к�������");
    Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "�������к�", "�ͺ�س����Ѻ���ŧ����¹, %s\n\n��͹���ʼ�ҹ��ҹ��ҧ������������ҹ:", "�������к�", "�͡", ReturnPlayerName(playerid));
	return 1;
}

forward OnPlayerLogin(playerid, race_check);
public OnPlayerLogin(playerid, race_check)
{
	if (race_check != g_MysqlRaceCheck[playerid]) 
		return Kick(playerid);

	new pPass[129], unhashed_pass[129];
	GetPVarString(playerid, "Unhashed_Pass",unhashed_pass, 129);
	if(cache_num_rows())
	{
		cache_get_value_index(0, 0, pPass, 129);
		cache_get_value_index_int(0, 1, e_pAccountData[playerid][mDBID]);
        cache_get_value_index(0, 2, e_pAccountData[playerid][mAccName], 60);
		cache_get_value_index(0, 3, e_pAccountData[playerid][mForumName], 60);
		
        if (strequal(unhashed_pass, pPass, true)) {
            DeletePVar(playerid, "Unhashed_Pass");

            cache_get_value_name_int(0, "admin", PlayerInfo[playerid][pAdmin]);
            ShowCharacterSelection(playerid);

        }
        else {

			if(loginAttempt[playerid] == DEFAULT_PLAYER_LOGIN_ATTEMPT) {
				SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR: "EMBED_WHITE"�س��͡���ʼ�ҹ�Դ�ҡ�Թ�");
				KickEx(playerid);
				return 1;
			}
			loginAttempt[playerid]++;
			
			Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "�������к�",""EMBED_RED"ERROR:"EMBED_DIALOG" ���ʼ�ҹ���١��ͧ\n\n"EMBED_DIALOG"�ô��͡���ʼ�ҹ�ͧ�س��ҹ��ҧ��������������к�:\n\n"EMBED_RED"�����������㹡���������к� (%d/%d)","�������к�","�͡", DEFAULT_PLAYER_LOGIN_ATTEMPT - loginAttempt[playerid], DEFAULT_PLAYER_LOGIN_ATTEMPT);
		}
	}
    else {
        printf("ERROR: %s can't log-in", ReturnPlayerName(playerid));
    }
	return 1;
}

Auth_Login(playerid) {
    Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "�������к�", "���ʴ�, %s\n\n��͹���ʼ�ҹ��ҹ��ҧ������������ҹ:", "�������к�", "�͡", ReturnPlayerName(playerid));
    return 1;
}

Auth_Register(playerid) {

	#if defined IN_GAME_REGISTER

    	Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "��Ѥ���Ҫԡ", "�ѭ�չ���ѧ���������㹰ҹ������ �ôŧ����¹���¡�á�͡���ʼ�ҹ��ҹ��ҧ���", "ŧ����¹", "�͡");

	#else

		SendClientMessageEx(playerid, COLOR_LIGHTRED, "ERROR: "EMBED_WHITE"��辺�ѭ�ռ������� %s", ReturnPlayerName(playerid));
		SendClientMessage(playerid, COLOR_LIGHTRED, "[ ! ] "EMBED_WHITE"��Ǩ�ͺ��������Ҥس����ͺѭ��(��ѡ)�ͧ�س �������͵���Ф�!");
		SendClientMessage(playerid, COLOR_LIGHTRED, "[ ! ] "EMBED_WHITE"��ҵ�ͧ������ҧ�ѭ�ռ�����ô价�� http://yoursite.com/");
		KickEx(playerid);

	#endif

    return 1;
}

timer ShowLoginCamera[400](playerid)
{
	if(IsPlayerConnected(playerid) && BitFlag_Get(gPlayerBitFlag[playerid], IS_LOGGED)) {
		SetPlayerVirtualWorld(playerid, playerid + 8000);
		SetPlayerCameraPos(playerid, 2559.6138,-1719.2664,37.2296);
		SetPlayerCameraLookAt(playerid, 2488.2173,-1665.3325,13.3438, CAMERA_CUT);
	}
}

Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[])
{
    if (!response)
        Kick(playerid);

    new query[128], buf[129];

    WP_Hash(buf, sizeof (buf), inputtext);
    SetPVarString(playerid, "Unhashed_Pass",buf);

	g_MysqlRaceCheck[playerid]++;
    mysql_format(dbCon, query, sizeof(query), "SELECT acc_pass, acc_dbid, acc_name, forum_name ,admin from `masters` WHERE acc_name = '%e'", ReturnPlayerName(playerid));
    mysql_tquery(dbCon, query, "OnPlayerLogin", "id", playerid, g_MysqlRaceCheck[playerid]);

    return 1;
}

Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[])
{
    if (!response)
        Kick(playerid);

    new
        buf[129];

    WP_Hash(buf, sizeof (buf), inputtext);

    new query[256];
    mysql_format(dbCon, query, sizeof(query), "INSERT INTO `masters` (acc_name, acc_pass) VALUES('%e', '%e')", ReturnPlayerName(playerid), buf);
	mysql_tquery(dbCon, query, "OnPlayerRegister", "d", playerid);

    return 1;
}

Dialog:DIALOG_SET_USERNAME(playerid, response, listitem, inputtext[])
{
	if (!response)
        Kick(playerid);
	
	if(strlen(inputtext) < 1 || strlen(inputtext) > 90)
		return Dialog_Show(playerid, DIALOG_SET_USERNAME, DIALOG_STYLE_INPUT, "������ Username ���س��ͧ���", "�س������ Usenrame �������¡��� 1 �����ҡ���� 90 ����ѡ�� �ô�������:", "�׹¹", "¡��ԡ");

	new maxusername = strlen(inputtext);

	for(new i=0; i<maxusername; i++)
	{
		if(inputtext[i] == '_')
		{
			return Dialog_Show(playerid, DIALOG_SET_USERNAME, DIALOG_STYLE_INPUT, "������ Username ���س��ͧ���", "����!�������ͧ���� _ ŧ�㹪��� Username �ͧ�س:", "�׹¹", "¡��ԡ");
		}
	}
	SetPlayerName(playerid, inputtext);

	new existCheck[129];
	
	mysql_format(dbCon, existCheck, sizeof(existCheck), "SELECT COUNT(acc_name) FROM `masters` WHERE acc_name = '%e'", ReturnPlayerName(playerid));
	mysql_tquery(dbCon, existCheck, "OnPlayerJoin", "d", playerid);
	return 1;
}