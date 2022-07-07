
#include <YSI_Coding\y_hooks>


new PlayerSkinCloseID[MAX_PLAYERS];

new buy_weapon[2];

hook OnGameModeInit()
{
    buy_weapon[0] = CreateDynamicPickup(1239, 2, 1410.8884,-10.3149,1000.9465, -1, -1, -1, 300);
    return 1;
}

hook OP_Connect(playerid)
{
    PlayerSkinCloseID[playerid] = 0;
    return 1;
}

CMD:bizcmd(playerid, params[])
{
    SendClientMessage(playerid, COLOR_DARKGREEN, "____________________BUSINESS COMMAND__________________________");

    SendClientMessage(playerid, COLOR_GRAD2,"[BUSINESS] /buybiz /sellbiz /lock /biz");
    SendClientMessage(playerid, COLOR_GREEN,"________________________________________________________________");
    SendClientMessage(playerid, COLOR_GRAD1,"�ô�֡�Ҥ���������������������㹿��������� /helpme ���ͤ͢������������");
    return 1;
}

CMD:buybiz(playerid,params[])
{
    new b_id = IsPlayerNearBusiness(playerid);
    new MyCash = GetPlayerMoney(playerid);
    new Level = PlayerInfo[playerid][pLevel];
    
    if(b_id != 0)
    {
        if(CountPlayerBusiness(playerid) > 10)
        {
            SendErrorMessage(playerid, "�س����Ңͧ�Ԩ����������");
            return 1;
        }

        else if(BusinessInfo[b_id][BusinessOwnerDBID])
            return SendErrorMessage(playerid, "�Ԩ��ù������Ңͧ��������");

        else if(MyCash < BusinessInfo[b_id][BusinessPrice])
            return SendErrorMessage(playerid, "�س���Թ�����§��");
        
        else if(Level < BusinessInfo[b_id][Businesslevel])
            return SendErrorMessage(playerid, "�س������������§��");

        BusinessInfo[b_id][BusinessOwnerDBID] = PlayerInfo[playerid][pDBID];
        
        if(BusinessInfo[b_id][BusinessType] == BUSINESS_TYPE_BANK)
        {
            if(IsValidDynamicPickup(BusinessInfo[b_id][BusinessEntrancePickUp]))
                DestroyDynamicPickup(BusinessInfo[b_id][BusinessEntrancePickUp]);

            BusinessInfo[b_id][BusinessEntrancePickUp] = CreateDynamicPickup(1239, 23, BusinessInfo[b_id][BusinessEntrance][0], BusinessInfo[b_id][BusinessEntrance][1], BusinessInfo[b_id][BusinessEntrance][2],-1,-1);
        }

        SendClientMessageEx(playerid, -1, "{33FF66}BUSINESS {F57C00}SYSTEM:{F57C00} �Թ�մ���!! �س����͡Ԩ�����Ҥ� $%s", MoneyFormat(BusinessInfo[b_id][BusinessPrice]));                     
        
        for(new i = 1; i < MAX_FUELS; i++)
        {
            if(!FuelInfo[i][F_ID])
                continue;

            if(FuelInfo[i][F_Business] == BusinessInfo[b_id][BusinessDBID])
            {
                FuelInfo[i][F_OwnerDBID] = PlayerInfo[playerid][pDBID];
                SaveFuel(i);
            }
        }
        
        GiveMoney(playerid, -BusinessInfo[b_id][BusinessPrice]);
        CharacterSave(playerid);
        SaveBusiness(b_id);
    }
    else SendErrorMessage(playerid, "�س���������������ǳ�Ԩ��÷���ͧ��� ����");
    return 1;
}

CMD:sellbiz(playerid, params[])
{
    new id = PlayerInfo[playerid][pInsideBusiness];
    new str[MAX_STRING];
    
    if(id != 0)
    {
        if(BusinessInfo[id][BusinessOwnerDBID] != PlayerInfo[playerid][pDBID])
            return SendErrorMessage(playerid, "�س�������Ңͧ�Ԩ���");

        format(str, sizeof(str), "{FFFFFF}�س������ͻ��Ƿ��� ��¡Ԩ��âͧ�س ��â�¡Ԩ��ù��س�����Ѻ�Թ�ӹǹ {2ECC71}$%s{FFFFFF} �Թ�ӹǹ������Թ���觹֧�ͧ�Ҥ����㹡Ԩ����ҡ�س��¡Ԩ�������\n\
                                  �س���������ö�Ѵ��áԨ��âͧ�س���ա��� �����س�Դ���ա�͹�еͺ '�׹�ѹ'",MoneyFormat(BusinessInfo[id][BusinessPrice] / 2));
        Dialog_Show(playerid, DIALOG_SELL_BU, DIALOG_STYLE_MSGBOX, "�س����?", str, "�Թ�ѹ", "¡��ԡ");
        return 1;
    }
    else SendErrorMessage(playerid, "�س���������㹡Ԩ���");
    return 1;
}

CMD:biz(playerid,params[])
{   
    new id = IsPlayerInBusiness(playerid);

    if(!IsPlayerInBusiness(playerid))
        return SendErrorMessage(playerid, "�س��������㹡Ԩ���");

    if(BusinessInfo[id][BusinessOwnerDBID] != PlayerInfo[playerid][pDBID] && !PlayerInfo[playerid][pAdmin])
        return SendErrorMessage(playerid, "�س�������Ңͧ�Ԩ���");

    ShowPlayerBusiness(playerid, id);
    return 1;
}

CMD:eat(playerid, params[])
{
    if(MealOder[playerid] == true)
		return SendErrorMessage(playerid, "�س�ѧ�նҴ���������");

    new id = PlayerInfo[playerid][pInsideBusiness];

    if(BusinessInfo[id][BusinessType] != BUSINESS_TYPE_RESTAURANT)
        return SendErrorMessage(playerid, "�س�����������ҹ��������");

    callcmd::meal(playerid, "");
    PlayerInfo[playerid][pGUI] = 5;
    ShowPlayerBuyFood(playerid);
    return 1;
}

alias:createdrinkmenu("makedrink", "createdrink")
CMD:createdrinkmenu(playerid, params[])
{
    new id = IsPlayerInBusiness(playerid);

    if(!IsPlayerInBusiness(playerid))
        return SendErrorMessage(playerid, "�س��������㹡Ԩ���");

    if(BusinessInfo[id][BusinessOwnerDBID] != PlayerInfo[playerid][pDBID] && !PlayerInfo[playerid][pAdmin])
        return SendErrorMessage(playerid, "�س�������Ңͧ�Ԩ���");


    new name[60], price, model, drunk, idx = 0;

    for(new m = 1; m < MAX_DRINKMENU; m++)
    {
        if(!DrinkMenuInfo[m][drink_id])
            continue;

        idx = m;
    }


    if(!idx)
        return SendErrorMessage(playerid, "�س����ö���ҧ�������ҡ�ش 10 ����");

    if(sscanf(params, "s[60]ddd", name, price, model, drunk))
        return SendUsageMessage(playerid, "/createdrinkmenu <��������> <�Ҥ�> <����> <�������>");


    if(strlen(name) > 15)
        return SendErrorMessage(playerid, "�س��������ҧ����������Թ 15 ����ѡ��");

    if(price < 50 || price > 10000)
        return SendErrorMessage(playerid, "�س����Ҥ����١��ͧ (50 - 10000)");

    
    return 1;
}

CMD:buy(playerid, params[])
{

    if(IsPlayerInRangeOfPoint(playerid, 2.0, 1410.8884,-10.3149,1000.9465)) /// SHOP POLICE HARBOR STATION
    {
        if(ReturnFactionJob(playerid) != POLICE)
            return SendErrorMessage(playerid, "�س��������˹�ҷ����Ǩ");

        if(!PlayerInfo[playerid][pDuty])
            return SendErrorMessage(playerid, "�س���������㹡�÷�˹�ҷ����Ǩ");
        
        PlayerInfo[playerid][pGUI] = 6;
        SendClientMessage(playerid, -1, "�Ծ�� /close ���ͻԴ˹�ҵ�ҧ��ë��� ���͡� esc");
        MenuStore_AddItem(playerid, 1, 348, "Desert Eagle", 500, "Desert Eagle - 100 Ammo", 200);
        MenuStore_AddItem(playerid, 2, 349, "Shotgun", 550, "Shotgun - 50 Ammo", 200);
        MenuStore_AddItem(playerid, 3, 356, "M4", 1000, "M4 - 250 Ammo", 200);
        MenuStore_AddItem(playerid, 4, 334, "Nightstick", 100, "Nightstick", 200);
        MenuStore_AddItem(playerid, 5, 365, "Spraycan", 100, "Spraycan - 100 Ammo", 200);
        MenuStore_AddItem(playerid, 6, 1242, "Armour", 50, "Armour - 1", 200);
        MenuStore_AddItem(playerid, 7, 19942, "Radio", 100, "Radio - 1", 200);
        MenuStore_Show(playerid, SHOP_POLICE, "SHOP POLICE");
        return 1;
    }
    else
    {
        new id = PlayerInfo[playerid][pInsideBusiness];
    
        if(BusinessInfo[id][BusinessType] == BUSINESS_TYPE_STORE)
        {
            PlayerInfo[playerid][pGUI] = 6;
            SendClientMessage(playerid, -1, "�Ծ�� /close ���ͻԴ˹�ҵ�ҧ��ë��� ���͡� esc");
            MenuStore_AddItem(playerid, 1, 18919, "OOC Mask", 100, "OOC Mask use /mask", 200);
            MenuStore_AddItem(playerid, 2, 367, "Camera", 50, "Cemara To Take Photo", 200);
            MenuStore_AddItem(playerid, 3, 325, "Flower", 10, "Flower", 200);
            MenuStore_AddItem(playerid, 4, 19897, "Cigarette", 25, "Flower", 200);
            MenuStore_AddItem(playerid, 5, 2226, "BoomBox", 500, "BoomBox use music staion", 200);
            MenuStore_AddItem(playerid, 6, 336, "Baseball Bat", 250, "Baseball Bat", 200);
            MenuStore_AddItem(playerid, 7, 1650, "GasCan", 2000, "GasCan use /refill", 200);
            MenuStore_Show(playerid, Shop, "SHOP");
            return 1;
        }
        else if(BusinessInfo[id][BusinessType] == BUSINESS_TYPE_JOB)
        {
            PlayerInfo[playerid][pGUI] = 6;
            SendClientMessage(playerid, -1, "�Ծ�� /close ���ͻԴ˹�ҵ�ҧ��ë��� ���͡� esc");
            MenuStore_AddItem(playerid, 1, 19921, "Repair Box", 75, "Use In Repair Vehicle", 200);
            MenuStore_Show(playerid, Shop_Job, "SHOP");
            return 1;
        }
        else SendErrorMessage(playerid, "�س������������ҹ");
        return 1;
    }
}

CMD:bank(playerid, params[])
{
	new
		id = IsPlayerInBusiness(playerid),
		amount
	;
		
	if(!id)
		return SendErrorMessage(playerid, "�س���������㹸�Ҥ��");
		
	if(BusinessInfo[id][BusinessType] != BUSINESS_TYPE_BANK)
		return SendErrorMessage(playerid, "�س���������㹸�Ҥ��"); 
		
	if(sscanf(params, "d", amount))
		return SendUsageMessage(playerid, "/bank [�ӹǹ�Թ���нҡ]");
		
	if(amount < 1 || amount > PlayerInfo[playerid][pCash])
		return SendErrorMessage(playerid, "�س���Թ�����§��"); 

    if(PlayerInfo[playerid][pSaving])
        return SendErrorMessage(playerid, "�س�������ö�͹���ͽҡ�Թ���������騹���Ҥس��¡��ԡ�ѭ��");
		
	PlayerInfo[playerid][pBank]+= amount;
	GiveMoney(playerid, -amount); 
	
	SendClientMessageEx(playerid, COLOR_ACTION, "�س��ҡ�Թ�ӹǹ $%s ���㹺ѭ�ո�Ҥ�âͧ�س �ҡ���:$%s", MoneyFormat(amount), MoneyFormat(PlayerInfo[playerid][pBank]));
	CharacterSave(playerid);
	return 1; 
}
new PlayerSavingAdd[MAX_PLAYERS];

CMD:saving(playerid, params[])
{
    if(PlayerInfo[playerid][pSaving])
        return SendErrorMessage(playerid, "�س��ӡ��������ҡ�����Ѿ����������");
    
    new
		id = IsPlayerInBusiness(playerid),
        money
	;
		
	if(!id)
		return SendErrorMessage(playerid, "�س���������㹸�Ҥ��");
		
	if(BusinessInfo[id][BusinessType] != BUSINESS_TYPE_BANK)
		return SendErrorMessage(playerid, "�س���������㹸�Ҥ��");

    if(PlayerInfo[playerid][pBank])
        return SendErrorMessage(playerid, "�͹�Թ�������ͧ�س�͡��������͹���нҡ��������");

    if(PlayerInfo[playerid][pCash] < 2000)
        return SendErrorMessage(playerid, "�Թ���е�ͧ�������㹡�ýҡ�Թ��� ����ӡ��� $2,000 ��������Թ $1,000,00");

    if(sscanf(params, "d", money))
        return SendUsageMessage(playerid, "/saving  <�ӹǹ�Թ>");
    
    if(money < 2000 || money >= 1000000)
        return SendErrorMessage(playerid, "�س�е�ͧ�ҡ�Թ��鹵�� $2,000 �������Թ $1,000,000");

    PlayerSavingAdd[playerid] = money;

    new str[1000];
    format(str, sizeof(str), "��͵�ŧ㹡�÷Ӻѭ�������Ѿ��ͧ�س��� �繢�͵�ŧ�����ҧ�س�Ѻ��Ҥ�� ��\n\
    \t���¹ %s\n\
    \t\t��͵�ŧ㹡�÷Ӻѭ�������Ѿ��ͧ�س��� �繢�͵�ŧ�����ҧ�س�Ѻ��Ҥ�� ���բ�͡�˹���ҧ� ���س����\n�е�ͧ��ԺѵԵ���������Ѻ�ѹ�ѧ��͡�˹�\n\
    ��ͷ�� 1: �س�����Ѻ�͡�����ҡ��鹨ҡ������س�����蹡��� 0.9\n\
    ��ͷ�� 2: �س���������ö�͹�Թ�騹�����Թ�ͧ�س�Фú��˹� $20,000,000\n\
    ��ͷ�� 3: �ҡ�س�ӡ�ö͹��͹��˹��ж١�ҧ��Ҥ�û�Ѻ�Թ�س ��� 2 �ͧ�Թ���������س��\n\
    �ҡ�س��ҹ��͡�˹��ͧ������������Ѻ�ô���ӹǹ�Թ���е�ͧ�������㹡�ýҡ�Թ��� ����ӡ��� $2,000 ��������Թ $1,000,000",ReturnName(playerid, 0));
    Dialog_Show(playerid, DIALOG_CONFIRM_SAVEING, DIALOG_STYLE_MSGBOX, "��͵�ŧ㹡�ýҡ�Թ�����Ѿ��", str, "�׹�ѹ����¡��", "¡��ԡ��÷���¡��");
    return 1;
}

Dialog:DIALOG_CONFIRM_SAVEING(playerid, response, listitem, inputtext[])
{  
    if(!response)
        return SendClientMessage(playerid, -1, "�س�黮��ʸ�ѭ�Ң�͵�ŧ�Ѻ��Ҥ��");

    new money = PlayerSavingAdd[playerid];

    GiveMoney(playerid, -money);
    PlayerInfo[playerid][pSaving] = true;
    PlayerInfo[playerid][pBank] += money;
    CharacterSave(playerid);

    SendClientMessageEx(playerid, COLOR_DARKGREEN, "�س��������ҡ�ԹẺ�ѭ�������Ѿ�����Ǩӹǹ�Թ������� $%s",MoneyFormat(money));
    PlayerSavingAdd[playerid] = 0;
    return 1;
}

CMD:withdraw(playerid, params[])
{
    new id = PlayerInfo[playerid][pInsideBusiness], amount;


    if(BusinessInfo[id][BusinessType] != BUSINESS_TYPE_STORE && BusinessInfo[id][BusinessType] != BUSINESS_TYPE_BANK)
        return SendErrorMessage(playerid, "�س���������㹸�Ҥ��������ҹʴǡ����");

    if(sscanf(params, "i", amount))
		return SendUsageMessage(playerid, "/withdraw [�ӹǹ�Թ]");

    if(amount < 1 || amount > PlayerInfo[playerid][pBank])
		return SendErrorMessage(playerid, "�س���Թ㹺ѭ�ո�Ҥ�������§��"); 

    if(PlayerInfo[playerid][pSaving] && PlayerInfo[playerid][pBank] < MONEY_MAX_SAVING)
    {
        PlayerInfo[playerid][pBank] = PlayerInfo[playerid][pBank] / 2;
        PlayerInfo[playerid][pSaving] = false;
        SendClientMessage(playerid, -1, "[BANK] �س����������ͧ�͹�Թ�͡�ҡ��Ҥ��������ҧ���ҡ�����Ѿ�����������ѭ�Ңͧ�س�Ѻ��Ҥ�âҴ");
        SendClientMessage(playerid, -1, "....��е����͵�ŧ��鹤س����ѭ�����Ѻ�ҧ��Ҥ�� ��Ҥ�è֧���繵�ͧ��Ѻ�Թ���觹֧㹺ѭ�բͧ�س�����͡�˹�");

        if(PlayerInfo[playerid][pBank] < amount)
            return SendErrorMessage(playerid, "�س���Թ㹺ѭ�ո�Ҥ�������§�� �Թ�س����� $%s", MoneyFormat(PlayerInfo[playerid][pBank]));
 
        PlayerInfo[playerid][pSaving] = false;
        PlayerInfo[playerid][pBank]-= amount;
        GiveMoney(playerid, amount);
        SendClientMessageEx(playerid, COLOR_ACTION, "�س��͹�Թ�ӹǹ $%s �ҡ�ѭ�ո�Ҥ�âͧ�س �������:$%s", MoneyFormat(amount), MoneyFormat(PlayerInfo[playerid][pBank]));
        CharacterSave(playerid);
        return 1;
    }

    PlayerInfo[playerid][pBank]-= amount;
	GiveMoney(playerid, amount);
    SendClientMessageEx(playerid, COLOR_ACTION, "�س��͹�Թ�ӹǹ $%s �ҡ�ѭ�ո�Ҥ�âͧ�س �������:$%s", MoneyFormat(amount), MoneyFormat(PlayerInfo[playerid][pBank]));
	CharacterSave(playerid);
    return 1;
}

alias:balance("bal")
CMD:balance(playerid, params[])
{
	new
		id = IsPlayerInBusiness(playerid)
	;
		
	if(!id)
		return SendErrorMessage(playerid, "�س���������㹸�Ҥ��������ҹʴǡ����");
		
	if(BusinessInfo[id][BusinessType] != BUSINESS_TYPE_STORE && BusinessInfo[id][BusinessType] != BUSINESS_TYPE_BANK)
		return SendErrorMessage(playerid, "�س���������㹸�Ҥ��������ҹʴǡ����"); 
	
	SendClientMessageEx(playerid, COLOR_ACTION, "�س���Թ����㹺ѭ�ո�Ҥ�� $%s ����դ�Ҩ�ҧ��ª������ $%s  �Ѿഷ������ѹ���: %s", MoneyFormat(PlayerInfo[playerid][pBank]), MoneyFormat(PlayerInfo[playerid][pPaycheck]), ReturnDate());	
	return 1;
}

hook OP_PickUpDynamicPickup(playerid, STREAMER_TAG_PICKUP:pickupid)
{
    new
		id = IsPlayerInBusiness(playerid)
	;

    if(pickupid == BusinessInfo[id][BusinessBankPickup])
    {
        if(PlayerInfo[playerid][pPaycheck] == 0)
            return 1;
        
        GiveMoney(playerid, PlayerInfo[playerid][pPaycheck]);
        SendClientMessageEx(playerid, COLOR_GREY, "�س���Ѻ�Թ��ª������ͧ�س���� �ӹǹ $%s", MoneyFormat(PlayerInfo[playerid][pPaycheck]));
        PlayerInfo[playerid][pPaycheck] = 0;
        return 1;
    }
    return 1;
}

CMD:buygun(playerid, params[])
{
    new id = PlayerInfo[playerid][pInsideBusiness];
    

    if(BusinessInfo[id][BusinessType] != BUSINESS_TYPE_AMMUNITION)
        return SendErrorMessage(playerid, "�س�������������ҹ�׹");

    if(!PlayerInfo[playerid][pWeaponLicense])
        return SendErrorMessage(playerid, "�س������͹حҵ�����Ѻ��ë��ͻ׹");

    if(PlayerInfo[playerid][pWeaponLicenseSus])
        return SendErrorMessage(playerid, "㺾����ظ�ͧ�س�١�ִ����");

    if(PlayerInfo[playerid][pWeaponLicenseRevoke])
        return SendErrorMessage(playerid, "㺾����ظ�ͧ�س�١�ִ����");
    

    new str[255],longstr[255];

    format(str, sizeof(str), "����:\t�Ҥ�:\n");
    strcat(longstr, str);

    format(str, sizeof(str), "Desert eagle\t$35,000\n");
    strcat(longstr, str);
    format(str, sizeof(str), "Shotgun\t$55,000\n");
    strcat(longstr, str);
    format(str, sizeof(str), "Country rifle\t$45,000\n");
    strcat(longstr, str);

    Dialog_Show(playerid, DIALOG_WEAPON_BUY, DIALOG_STYLE_TABLIST_HEADERS, "WEAPON SHOP:", longstr, "�׹�ѹ", "¡��ԡ");
    return 1;
}

CMD:buyammo(playerid, params[])
{
    
    return 1;
}

CMD:skin(playerid, params[])
{
    new id = PlayerInfo[playerid][pInsideBusiness];
    

    if(BusinessInfo[id][BusinessType] != BUSINESS_TYPE_SKIN)
        return SendErrorMessage(playerid, "�س����������ҹ�������ͼ��");

    ShowSkinModelMenu(playerid);
    return 1;
}

alias:changeclothing("cct")
CMD:changeclothing(playerid, params[])
{
    if(PlayerInfo[playerid][pGUI])
        return SendErrorMessage(playerid, "�س�������ö�����觢���ա�÷ӧҹ�ͧ�к� Textdraw");

    new str[255], longstr[255];
    format(str, sizeof(str), "�ش��� 1: %d\n",PlayerInfo[playerid][pSkinClothing][0]);
    strcat(longstr, str);

    format(str, sizeof(str), "�ش��� 2: %d\n",PlayerInfo[playerid][pSkinClothing][1]);
    strcat(longstr, str);

    format(str, sizeof(str), "�ش��� 3: %d\n",PlayerInfo[playerid][pSkinClothing][2]);
    strcat(longstr, str);

    Dialog_Show(playerid, DIALOG_SKINCLOST_CHANG, DIALOG_STYLE_LIST, "Clothing Skin:", longstr, "�׹�ѹ", "¡��ԡ");
    return 1;
}

alias:advertisements("ads")
CMD:advertisements(playerid, params[])
{
    if(isnull(params)) 
        return SendUsageMessage(playerid, "/advertisements [��ͤ���]");

    if(PlayerInfo[playerid][pCash] < 200)
        return SendErrorMessage(playerid, "�س���Թ�����§�� (���繵�ͧ�� $200)");

    
    if(strlen(params) > 100)
    {
		SendClientMessageToAllEx(COLOR_LIGHTGREEN, "[Advertisements] %.89s", params);
        SendClientMessageToAllEx(COLOR_LIGHTGREEN, "... %s",params[100]);
    }
    else 
    {
        SendClientMessageToAllEx(COLOR_LIGHTGREEN, "[Advertisements] %s",params);
    }

    GiveMoney(playerid, -200);

    return 1;
}


alias:givebusinesskey("givebizkey")
CMD:givebusinesskey(playerid, params[])
{
    if(!IsPlayerInBusiness(playerid))
        return SendErrorMessage(playerid, "�س������������㹡Ԩ��âͧ�س");

    new id = PlayerInfo[playerid][pInsideBusiness];

    if(BusinessInfo[id][BusinessOwnerDBID] != PlayerInfo[playerid][pDBID])
        return SendErrorMessage(playerid, "�س�������Ңͧ�Ԩ���");

    new tagetid;
    if(sscanf(params, "u", tagetid))
        return SendUsageMessage(playerid, "/givebusinesskey <���ͺҧ��ǹ/�ʹ�> ");


    if(!IsPlayerNearPlayer(playerid, tagetid, 4.0))
        return SendErrorMessage(playerid, "�س������������ %s", ReturnRealName(playerid));


    PlayerInfo[tagetid][pBusinessKey] = id;

    GiveMoney(playerid, -1000);
    SendClientMessageEx(playerid, COLOR_GREY, "�س�����ح����ͧ�ͧ�Ԩ��âͧ�س�Ѻ %s ���º�������� �س�����Թ��ҡح����ͧ�Ԩ���� $1,000", ReturnRealName(tagetid));
    SendClientMessageEx(tagetid, COLOR_LIGHTGREEN, "�س���Ѻ�بᨡԨ��èҡ %s �����Ţ�Ԩ��� %d", ReturnRealName(playerid), id); 
    return 1;
}


CMD:createmenu(playerid, params[])
{
    new id = PlayerInfo[playerid][pInsideBusiness];

    if(BusinessInfo[id][BusinessType] != BUSINESS_TYPE_CLUB)
        return SendErrorMessage(playerid, "�س�������������ҹ ���� �ͧ�س");
    
    if(BusinessInfo[id][BusinessOwnerDBID] != PlayerInfo[playerid][pDBID])
        return SendErrorMessage(playerid, "�س���������Ңͧ�Ԩ��ù��");

    new idx = 0;
    for(new i = 1; i < 11; i++)
    {
        if(!BusinessInfo[id][BizDrink][i])
        {
            idx = i;
            break;
        }
    }
    if(!idx)
        return SendErrorMessage(playerid, "�س�����ҧ Menu �������");

    new menuname[60], price, model, drunk;

    if(sscanf(params, "s[60]ddd", menuname, price, model, drunk))
    {
        SendUsageMessage(playerid, "/createmenu <��������> <�Ҥ�> <����> <drunk>");
        SendClientMessage(playerid, COLOR_WHITE, "");
        return 1;
    }
    
    if(strlen(menuname) < 5 || strlen(menuname) > 60)
        return SendErrorMessage(playerid, "��͡�������١��ͧ");

    if(price < 1 || price > 5000)
        return SendErrorMessage(playerid, "��͡�Ҥ����١��ͧ");
    
    if(model != 1484)
        return SendErrorMessage(playerid, "��� �ʹ����١��ͧ");

    if(drunk < 4000 || drunk > 10000)
        return SendErrorMessage(playerid, "�س��駤�Ҥ�����ҹ��¡��� 4,000 �����ҡ���� 10,000");

    
    CreateMenuBar(playerid, idx, menuname, price, model, drunk);
    return 1;
}

stock CreateMenuBar(playerid, newid, menuname[], price, model, drunk)
{
    new idx = 0;
    new id = PlayerInfo[playerid][pInsideBusiness];


    for(new i = 1; i < MAX_DRINKMENU; i++)
    {
        if(!DrinkMenuInfo[i][drink_id])
        {
            idx = i;
            break;
        }
    }
    if(!idx)
        return SendErrorMessage(playerid, "�ʹն֧�ش����ش����");

    DrinkMenuInfo[idx][drink_id] = idx;
    DrinkMenuInfo[idx][drink_bizid] = id;
    format(DrinkMenuInfo[idx][drink_name], 60, "%s",menuname);
    DrinkMenuInfo[idx][drink_price] = price;
    DrinkMenuInfo[idx][drink_model] = model;
    DrinkMenuInfo[idx][drink_drunk] = drunk;

    BusinessInfo[id][BizDrink][newid] = idx;

    SaveBusiness(id);

    SendClientMessageEx(playerid, COLOR_GREY, "�س�����ҧ ���� (%d)%s ���º�������� ����� /buydrink - ���ʹ�����", BusinessInfo[id][BizDrink][newid], DrinkMenuInfo[idx][drink_name]);
    return 1;
}

CMD:buydrink(playerid, params[])
{
    new id = PlayerInfo[playerid][pInsideBusiness];

    if(BusinessInfo[id][BusinessType] != BUSINESS_TYPE_CLUB)
        return SendErrorMessage(playerid, "�س�������������ҹ ���� �ͧ�س");
    
    if(BusinessInfo[id][BusinessOwnerDBID] != PlayerInfo[playerid][pDBID])
        return SendErrorMessage(playerid, "�س���������Ңͧ�Ԩ��ù��");
    
    
    new str[120], longstr[120];

    for(new i = 1; i < 11; i++)
    {
        if(!BusinessInfo[id][BizDrink][i])
            continue;
        
        format(str, sizeof(str), "%s - $%s\n", DrinkMenuInfo[BusinessInfo[id][BizDrink][i]][drink_name], MoneyFormat(DrinkMenuInfo[BusinessInfo[id][BizDrink][i]][drink_price]));
        strcat(longstr, str);
    }

    

    Dialog_Show(playerid, DIALOG_DEFAULT, DIALOG_STYLE_LIST, "MENU:", longstr, "�׹�ѹ", "¡��ԡ");
    return 1;
}




Dialog:DIALOG_SKINCLOST_CHANG(playerid, response, listitem, inputtext[])
{
    if(!response)
        return 1;


    switch(listitem)
    {
        case 0:
        {  
            PlayerSkinCloseID[playerid] = 0;
            Dialog_Show(playerid, DIALOG_SKINCLOST_CH_SLOT, DIALOG_STYLE_LIST, "Clothing Skin:", "[ ! ] ��ҧ\n[ ! ] ����¹", "�׹�ѹ", "¡��ԡ");

        }
        case 1:
        {  
            PlayerSkinCloseID[playerid] = 1;
            Dialog_Show(playerid, DIALOG_SKINCLOST_CH_SLOT, DIALOG_STYLE_LIST, "Clothing Skin:", "[ ! ] ��ҧ\n[ ! ] ����¹", "�׹�ѹ", "¡��ԡ");

        }
        case 2:
        {  
            PlayerSkinCloseID[playerid] = 2;
            Dialog_Show(playerid, DIALOG_SKINCLOST_CH_SLOT, DIALOG_STYLE_LIST, "Clothing Skin:", "[ ! ] ��ҧ\n[ ! ] ����¹", "�׹�ѹ", "¡��ԡ");

        }
    }
    return 1;
}

Dialog:DIALOG_SKINCLOST_CH_SLOT(playerid, response, listitem, inputtext[])
{
    if(!response)
        return 1;


    new slotid = PlayerSkinCloseID[playerid];
    new skinid = PlayerInfo[playerid][pSkinClothing][slotid];
    switch(listitem)
    {
        case 0:
        {
            if(PlayerInfo[playerid][pSkinClothing][slotid] == 0)
                return SendErrorMessage(playerid, "Sloid �����ҧ��������");

            PlayerInfo[playerid][pSkinClothing][slotid] = 0;
            SendClientMessageEx(playerid, -1, "�س��ӡ����ҧ��ͧ SkinClothing ��ͧ�� %d ���º��������", slotid+1);
        }
        case 1:
        {
            if(PlayerInfo[playerid][pSkinClothing][slotid] == 0)
                return SendErrorMessage(playerid, "�������ö����¹ Skin ���س�����ͧ�ҡ��ͧ����繪�ͧ�����ҧ");
            
            new str[255];
            format(str, sizeof(str), "�ӡ�ѧ����¹����ͼ�Ңͧ��");

            SetTimerEx("ChangSkinClosthing", 5000, false, "dd",playerid, skinid);
            TogglePlayerControllable(playerid, 0);
            callcmd::me(playerid,  str);
        }
    }
    return 1;
}

forward ChangSkinClosthing(playerid, skinid);
public ChangSkinClosthing(playerid, skinid)
{
    new str[255];
    format(str, sizeof(str), "�����");

    PlayerInfo[playerid][pLastSkin] = skinid; SetPlayerSkin(playerid, skinid);
    callcmd::do(playerid,  str);
    TogglePlayerControllable(playerid, 1);
    return 1;
}


Dialog:DIALOG_SKINCLOST_LIST(playerid, response, listitem, inputtext[])
{
    if(!response)
        return 1;

    
    switch(listitem)
    {
        case 0:
        {
            ShowDialogClostingSkin(playerid, 0);
            PlayerSkinCloseID[playerid] = 0;
            return 1;
        }
        case 1:
        {
            ShowDialogClostingSkin(playerid, 1);
            PlayerSkinCloseID[playerid] = 1;
        }
        case 2:
        {
            ShowDialogClostingSkin(playerid, 2);
            PlayerSkinCloseID[playerid] = 2;
        }
    }
    return 1;
}

stock ShowDialogClostingSkin(playerid, id)
{
    SendClientMessageEx(playerid, COLOR_HELPME, "�س�����͡ SkinClothing Slot ��� %d", id+1);
    Dialog_Show(playerid, DIALOG_BUYSKIN_INPUT, DIALOG_STYLE_INPUT, "���� Skin", "㹡������¹ Skin ���繵�ͧ�ӹ֧�֧���ҷ�ͧ����Ф�����ѡ�ҡ�����繼������\n����¹�� Skin ���˭ԧ���Ƿҧ�����ž��ͨзӡ�����͡�ҡ���������\n�ҡ�١���͡㹡ó����ǡѹ�ú 3 ���駨зӡ��ź����Фõ�ǹ�鹷ѹ��","�׹�ѹ", "¡��ԡ");
    return 1;
}

Dialog:DIALOG_BUYSKIN_INPUT(playerid, response, listitem, inputtext[])
{
    if(!response)
        return 1;

    if(PlayerInfo[playerid][pCash] < 1000)
        return SendErrorMessage(playerid, "�س���Թ���¡��� $1,000");
    
    new skinid = strval(inputtext);
    new id = PlayerInfo[playerid][pInsideBusiness];
    new slotid = PlayerSkinCloseID[playerid];


    PlayerInfo[playerid][pLastSkin] = skinid; SetPlayerSkin(playerid, skinid);
    PlayerInfo[playerid][pSkinClothing][slotid] = skinid;

    SendClientMessageEx(playerid, COLOR_DARKGREEN, "�س��ӡ������¹ Skin �ͧ�س�� ID: %d",skinid);
    SaveBusiness(id);
    CharacterSave(playerid);
    return 1;
}

Dialog:DIALOG_WEAPON_BUY(playerid, response, listitem, inputtext[])
{
    if(!response)
        return 1;

    switch(listitem)
    {
        case 0:
        {
            if(PlayerInfo[playerid][pCash] < 35000)
                return SendErrorMessage(playerid, "�س���Թ�����§��");

        
            new idx = ReturnWeaponIDSlot(24); 
            
            GivePlayerWeapon(playerid, 24, 200); 
            
            PlayerInfo[playerid][pWeapons][idx] = 24;
            PlayerInfo[playerid][pWeaponsAmmo][idx] = 200; 
            GiveMoney(playerid, -35000);
            return 1;
        }
        case 1:
        {
            if(PlayerInfo[playerid][pCash] < 55000)
                return SendErrorMessage(playerid, "�س���Թ�����§��");

        
            new idx = ReturnWeaponIDSlot(25); 
            
            GivePlayerWeapon(playerid, 25, 200); 
            
            PlayerInfo[playerid][pWeapons][idx] = 25;
            PlayerInfo[playerid][pWeaponsAmmo][idx] = 200; 
            GiveMoney(playerid, -55000);
            return 1;
        }
        case 2:
        {
            if(PlayerInfo[playerid][pCash] < 45000)
                return SendErrorMessage(playerid, "�س���Թ�����§��");

        
            new idx = ReturnWeaponIDSlot(33); 
            
            GivePlayerWeapon(playerid, 33, 200); 
            
            PlayerInfo[playerid][pWeapons][idx] = 33;
            PlayerInfo[playerid][pWeaponsAmmo][idx] = 200; 
            GiveMoney(playerid, -45000);
            return 1;
        }
    }
    return 1;
}
