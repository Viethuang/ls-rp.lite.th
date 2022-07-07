CMD:heal(playerid, params[])
{
    new factionid = PlayerInfo[playerid][pFaction], tagetid;

    if(FactionInfo[factionid][eFactionJob] != MEDIC)
        return SendErrorMessage(playerid, "�س��������˹�ҷ� ᾷ��");

    if(sscanf(params, "u", tagetid))
		return SendUsageMessage(playerid, "/heal <���ͺҧ��ǹ/�ʹ�>"); 
		
	if(!IsPlayerConnected(tagetid))
		return SendErrorMessage(playerid, "������������������͡Ѻ�׿�����"); 
		
	if(!BitFlag_Get(gPlayerBitFlag[tagetid], IS_LOGGED))
		return SendErrorMessage(playerid, "�����蹡��ѧ�������к�");
    
    if(!IsPlayerNearPlayer(playerid, tagetid, 2.5))
		return SendErrorMessage(playerid, "������������������س");

    GiveMoney(tagetid, -120);
    GlobalInfo[G_GovCash] += 120;

    SendClientMessageEx(playerid, COLOR_PINK, "�س��ӡ���ѡ���������ʹ���Ѻ %s ��� 100 ����",ReturnName(tagetid, 0));
    SendClientMessageEx(tagetid, COLOR_GREY, "�س���Ѻ����ѡ�Ҩҡ ᾷ�� %s ���ʹ�ͧ�س��Ѻ����� 100 ����",ReturnName(playerid, 0));
    SetPlayerHealth(tagetid, 100);
    return 1;
}