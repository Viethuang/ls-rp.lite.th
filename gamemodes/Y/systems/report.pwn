alias:report("re")
CMD:report(playerid, params[])
{
	if(isnull(params) || strlen(params) < 3)
		return SendUsageMessage(playerid, "/re(port) [text]"); 
	
	new 
		showString[MAX_STRING]
	;
	
	format(showString, sizeof(showString), "{FFFFFF}�س�ѹ�����������������§��\n\n�ô�������ҡ����§ҹ�����蹹�鹵���������Ǥ�è�����˵ء�ó������Ѻ���� �Ҿ ���� �Դ��� �����������ѡ�ҹ㹡�ê������Ҽ����蹴ѧ����ǼԴ��ԧ\n�����������ҧ�á�����觷���á�з��ҡ����ش��͡�� ���� ���� �Ѵ�Դ��� �������ѡ�ҹ��й����§ҹ㹿������дա��ҡ����§ҹ��ҹ�ҧ /report\n\n{FFFFFF}��§ҹ����ͧ: {F44336}%s", params);
	Dialog_Show(playerid, DIALOG_REPORT, DIALOG_STYLE_MSGBOX, "�׹�ѹ��÷���¡��", showString, "��ŧ", "¡��ԡ"); 
	
	format(playerReport[playerid], 128, "%s", params);
	return 1;
}

Dialog:DIALOG_REPORT(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
		return SendServerMessage(playerid, "¡��ԡ��� ��§��");
	}
			
	new idx;
	
	for (new i = 1; i < sizeof(ReportInfo); i ++)
	{
		if (ReportInfo[i][rReportExists] == false)
		{
			idx = i;
			break; 
		}
	}

	new str[60];
	format(str, sizeof(str), "[%s] %s Report now", ReturnDate(),ReturnRealName(playerid,0));
	SendDiscordMessageEx("admin-chat", str);

	OnPlayerReport(playerid, idx, playerReport[playerid]); 
	return 1;
}

Dialog:DIALOG_CLEARREPORT(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		for (new i = 0; i < sizeof(ReportInfo); i ++)
		{
			ReportInfo[i][rReportExists] = false;
			ReportInfo[i][rReportDetails] = ' '; 
			ReportInfo[i][rReportBy] = INVALID_PLAYER_ID;
			ReportInfo[i][rReportTime] = 0; 
		}
		
		new str[128];
		
		format(str, sizeof(str), "%s ��ź�����§ҹ %d", ReturnRealName(playerid, 0));
		SendAdminMessage(1, str); 
	}
	else return SendServerMessage(playerid, "¡��ԡ��á�зӴѧ�����");
	return 1;
}

stock OnPlayerReport(playerid, reportid, const text[])
{
	if(ReportInfo[reportid][rReportExists] == true)
	{
		for (new i = 1; i < sizeof(ReportInfo); i ++)
		{
			if(ReportInfo[i][rReportExists] == false)
			{
				reportid = i;
				break;
			}
		}
	}
		
	ReportInfo[reportid][rReportExists] = true;
	ReportInfo[reportid][rReportTime] = gettime();
		
	format(ReportInfo[reportid][rReportDetails], 90, "%s", text);
	ReportInfo[reportid][rReportBy] = playerid;
		
	SendServerMessage(playerid, "�س������§ҹ�ͧ�س��ѧ�����ŷ���͹�Ź�����");
		
	if(strlen(text) > 67)
	{
		SendAdminMessageEx(COLOR_REPORT, 1, "[��§ҹ: %d] %s (%d): %.75s", reportid, ReturnName(playerid), playerid, text);
		SendAdminMessageEx(COLOR_REPORT, 1, "[��§ҹ: %d] ...%s", reportid, text[75]);
	}
	else SendAdminMessageEx(COLOR_REPORT, 1, "[��§ҹ: %d] %s (%d): %s", reportid, ReturnName(playerid), playerid, text);
		
	if(strfind(text, "hack", true) != -1 || strfind(text, "cheat", true) != -1)
	{
		foreach(new i : Player)
		{
			if(PlayerInfo[i][pAdmin]) GameTextForPlayer(i, "~y~~h~Priority Report", 4000, 1);
		}
	}
	return 1;
}