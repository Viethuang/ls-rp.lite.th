/*
This file was generated by Nickk's TextDraw editor script
Nickk888 is the author of the NTD script
*/

//Variables
new PlayerText:PlayerID_Card[MAX_PLAYERS][13];

//Textdraws

//Player Textdraws
PlayerID_Card[playerid][0] = CreatePlayerTextDraw(playerid, 511.000000, 235.000000, "_");
PlayerTextDrawFont(playerid, PlayerID_Card[playerid][0], 1);
PlayerTextDrawLetterSize(playerid, PlayerID_Card[playerid][0], 0.600000, 16.550006);
PlayerTextDrawTextSize(playerid, PlayerID_Card[playerid][0], 298.500000, 178.500000);
PlayerTextDrawSetOutline(playerid, PlayerID_Card[playerid][0], 1);
PlayerTextDrawSetShadow(playerid, PlayerID_Card[playerid][0], 0);
PlayerTextDrawAlignment(playerid, PlayerID_Card[playerid][0], 2);
PlayerTextDrawColor(playerid, PlayerID_Card[playerid][0], -1);
PlayerTextDrawBackgroundColor(playerid, PlayerID_Card[playerid][0], 255);
PlayerTextDrawBoxColor(playerid, PlayerID_Card[playerid][0], 255);
PlayerTextDrawUseBox(playerid, PlayerID_Card[playerid][0], 1);
PlayerTextDrawSetProportional(playerid, PlayerID_Card[playerid][0], 1);
PlayerTextDrawSetSelectable(playerid, PlayerID_Card[playerid][0], 0);

PlayerID_Card[playerid][1] = CreatePlayerTextDraw(playerid, 511.000000, 239.000000, "_");
PlayerTextDrawFont(playerid, PlayerID_Card[playerid][1], 1);
PlayerTextDrawLetterSize(playerid, PlayerID_Card[playerid][1], 0.600000, 15.700014);
PlayerTextDrawTextSize(playerid, PlayerID_Card[playerid][1], 298.500000, 171.000000);
PlayerTextDrawSetOutline(playerid, PlayerID_Card[playerid][1], 1);
PlayerTextDrawSetShadow(playerid, PlayerID_Card[playerid][1], 0);
PlayerTextDrawAlignment(playerid, PlayerID_Card[playerid][1], 2);
PlayerTextDrawColor(playerid, PlayerID_Card[playerid][1], -1);
PlayerTextDrawBackgroundColor(playerid, PlayerID_Card[playerid][1], 255);
PlayerTextDrawBoxColor(playerid, PlayerID_Card[playerid][1], -1);
PlayerTextDrawUseBox(playerid, PlayerID_Card[playerid][1], 1);
PlayerTextDrawSetProportional(playerid, PlayerID_Card[playerid][1], 1);
PlayerTextDrawSetSelectable(playerid, PlayerID_Card[playerid][1], 0);

PlayerID_Card[playerid][2] = CreatePlayerTextDraw(playerid, 428.000000, 240.000000, "Preview_Model");
PlayerTextDrawFont(playerid, PlayerID_Card[playerid][2], 5);
PlayerTextDrawLetterSize(playerid, PlayerID_Card[playerid][2], 0.600000, 2.000000);
PlayerTextDrawTextSize(playerid, PlayerID_Card[playerid][2], 44.000000, 88.000000);
PlayerTextDrawSetOutline(playerid, PlayerID_Card[playerid][2], 0);
PlayerTextDrawSetShadow(playerid, PlayerID_Card[playerid][2], 0);
PlayerTextDrawAlignment(playerid, PlayerID_Card[playerid][2], 1);
PlayerTextDrawColor(playerid, PlayerID_Card[playerid][2], -1);
PlayerTextDrawBackgroundColor(playerid, PlayerID_Card[playerid][2], 255);
PlayerTextDrawBoxColor(playerid, PlayerID_Card[playerid][2], 255);
PlayerTextDrawUseBox(playerid, PlayerID_Card[playerid][2], 0);
PlayerTextDrawSetProportional(playerid, PlayerID_Card[playerid][2], 1);
PlayerTextDrawSetSelectable(playerid, PlayerID_Card[playerid][2], 0);
PlayerTextDrawSetPreviewModel(playerid, PlayerID_Card[playerid][2], 299);
PlayerTextDrawSetPreviewRot(playerid, PlayerID_Card[playerid][2], -10.000000, 0.000000, -4.000000, 0.930000);
PlayerTextDrawSetPreviewVehCol(playerid, PlayerID_Card[playerid][2], 1, 1);

PlayerID_Card[playerid][3] = CreatePlayerTextDraw(playerid, 511.000000, 279.000000, "_");
PlayerTextDrawFont(playerid, PlayerID_Card[playerid][3], 1);
PlayerTextDrawLetterSize(playerid, PlayerID_Card[playerid][3], 0.600000, 11.199995);
PlayerTextDrawTextSize(playerid, PlayerID_Card[playerid][3], 298.500000, 171.000000);
PlayerTextDrawSetOutline(playerid, PlayerID_Card[playerid][3], 1);
PlayerTextDrawSetShadow(playerid, PlayerID_Card[playerid][3], 0);
PlayerTextDrawAlignment(playerid, PlayerID_Card[playerid][3], 2);
PlayerTextDrawColor(playerid, PlayerID_Card[playerid][3], -1);
PlayerTextDrawBackgroundColor(playerid, PlayerID_Card[playerid][3], 255);
PlayerTextDrawBoxColor(playerid, PlayerID_Card[playerid][3], -1);
PlayerTextDrawUseBox(playerid, PlayerID_Card[playerid][3], 1);
PlayerTextDrawSetProportional(playerid, PlayerID_Card[playerid][3], 1);
PlayerTextDrawSetSelectable(playerid, PlayerID_Card[playerid][3], 0);

PlayerID_Card[playerid][4] = CreatePlayerTextDraw(playerid, 535.000000, 240.000000, "SAN ANDREAS IDENTIFICATION CARD");
PlayerTextDrawFont(playerid, PlayerID_Card[playerid][4], 2);
PlayerTextDrawLetterSize(playerid, PlayerID_Card[playerid][4], 0.262499, 1.200000);
PlayerTextDrawTextSize(playerid, PlayerID_Card[playerid][4], 400.000000, 164.500000);
PlayerTextDrawSetOutline(playerid, PlayerID_Card[playerid][4], 1);
PlayerTextDrawSetShadow(playerid, PlayerID_Card[playerid][4], 0);
PlayerTextDrawAlignment(playerid, PlayerID_Card[playerid][4], 2);
PlayerTextDrawColor(playerid, PlayerID_Card[playerid][4], 255);
PlayerTextDrawBackgroundColor(playerid, PlayerID_Card[playerid][4], 0);
PlayerTextDrawBoxColor(playerid, PlayerID_Card[playerid][4], 50);
PlayerTextDrawUseBox(playerid, PlayerID_Card[playerid][4], 0);
PlayerTextDrawSetProportional(playerid, PlayerID_Card[playerid][4], 1);
PlayerTextDrawSetSelectable(playerid, PlayerID_Card[playerid][4], 0);

PlayerID_Card[playerid][5] = CreatePlayerTextDraw(playerid, 535.000000, 267.000000, "_");
PlayerTextDrawFont(playerid, PlayerID_Card[playerid][5], 1);
PlayerTextDrawLetterSize(playerid, PlayerID_Card[playerid][5], 0.600000, -0.099999);
PlayerTextDrawTextSize(playerid, PlayerID_Card[playerid][5], 298.500000, 112.500000);
PlayerTextDrawSetOutline(playerid, PlayerID_Card[playerid][5], 1);
PlayerTextDrawSetShadow(playerid, PlayerID_Card[playerid][5], 0);
PlayerTextDrawAlignment(playerid, PlayerID_Card[playerid][5], 2);
PlayerTextDrawColor(playerid, PlayerID_Card[playerid][5], -1);
PlayerTextDrawBackgroundColor(playerid, PlayerID_Card[playerid][5], 255);
PlayerTextDrawBoxColor(playerid, PlayerID_Card[playerid][5], 255);
PlayerTextDrawUseBox(playerid, PlayerID_Card[playerid][5], 1);
PlayerTextDrawSetProportional(playerid, PlayerID_Card[playerid][5], 1);
PlayerTextDrawSetSelectable(playerid, PlayerID_Card[playerid][5], 0);

PlayerID_Card[playerid][6] = CreatePlayerTextDraw(playerid, 478.000000, 269.000000, "ID: XXXXXXXX");
PlayerTextDrawFont(playerid, PlayerID_Card[playerid][6], 2);
PlayerTextDrawLetterSize(playerid, PlayerID_Card[playerid][6], 0.275000, 1.049999);
PlayerTextDrawTextSize(playerid, PlayerID_Card[playerid][6], 592.500000, 17.000000);
PlayerTextDrawSetOutline(playerid, PlayerID_Card[playerid][6], 1);
PlayerTextDrawSetShadow(playerid, PlayerID_Card[playerid][6], 0);
PlayerTextDrawAlignment(playerid, PlayerID_Card[playerid][6], 1);
PlayerTextDrawColor(playerid, PlayerID_Card[playerid][6], 255);
PlayerTextDrawBackgroundColor(playerid, PlayerID_Card[playerid][6], 0);
PlayerTextDrawBoxColor(playerid, PlayerID_Card[playerid][6], 50);
PlayerTextDrawUseBox(playerid, PlayerID_Card[playerid][6], 0);
PlayerTextDrawSetProportional(playerid, PlayerID_Card[playerid][6], 1);
PlayerTextDrawSetSelectable(playerid, PlayerID_Card[playerid][6], 0);

PlayerID_Card[playerid][7] = CreatePlayerTextDraw(playerid, 535.000000, 281.000000, "_");
PlayerTextDrawFont(playerid, PlayerID_Card[playerid][7], 1);
PlayerTextDrawLetterSize(playerid, PlayerID_Card[playerid][7], 0.600000, -0.099999);
PlayerTextDrawTextSize(playerid, PlayerID_Card[playerid][7], 298.500000, 112.500000);
PlayerTextDrawSetOutline(playerid, PlayerID_Card[playerid][7], 1);
PlayerTextDrawSetShadow(playerid, PlayerID_Card[playerid][7], 0);
PlayerTextDrawAlignment(playerid, PlayerID_Card[playerid][7], 2);
PlayerTextDrawColor(playerid, PlayerID_Card[playerid][7], -1);
PlayerTextDrawBackgroundColor(playerid, PlayerID_Card[playerid][7], 255);
PlayerTextDrawBoxColor(playerid, PlayerID_Card[playerid][7], 255);
PlayerTextDrawUseBox(playerid, PlayerID_Card[playerid][7], 1);
PlayerTextDrawSetProportional(playerid, PlayerID_Card[playerid][7], 1);
PlayerTextDrawSetSelectable(playerid, PlayerID_Card[playerid][7], 0);

PlayerID_Card[playerid][8] = CreatePlayerTextDraw(playerid, 429.000000, 289.000000, "Name: FRISTNAME LASTNAME");
PlayerTextDrawFont(playerid, PlayerID_Card[playerid][8], 2);
PlayerTextDrawLetterSize(playerid, PlayerID_Card[playerid][8], 0.183332, 1.200000);
PlayerTextDrawTextSize(playerid, PlayerID_Card[playerid][8], 598.000000, 17.000000);
PlayerTextDrawSetOutline(playerid, PlayerID_Card[playerid][8], 1);
PlayerTextDrawSetShadow(playerid, PlayerID_Card[playerid][8], 0);
PlayerTextDrawAlignment(playerid, PlayerID_Card[playerid][8], 1);
PlayerTextDrawColor(playerid, PlayerID_Card[playerid][8], 255);
PlayerTextDrawBackgroundColor(playerid, PlayerID_Card[playerid][8], 0);
PlayerTextDrawBoxColor(playerid, PlayerID_Card[playerid][8], 50);
PlayerTextDrawUseBox(playerid, PlayerID_Card[playerid][8], 0);
PlayerTextDrawSetProportional(playerid, PlayerID_Card[playerid][8], 1);
PlayerTextDrawSetSelectable(playerid, PlayerID_Card[playerid][8], 0);

PlayerID_Card[playerid][9] = CreatePlayerTextDraw(playerid, 429.000000, 301.000000, "DOB: XX/XX/XXXX");
PlayerTextDrawFont(playerid, PlayerID_Card[playerid][9], 2);
PlayerTextDrawLetterSize(playerid, PlayerID_Card[playerid][9], 0.183332, 1.200000);
PlayerTextDrawTextSize(playerid, PlayerID_Card[playerid][9], 598.000000, 17.000000);
PlayerTextDrawSetOutline(playerid, PlayerID_Card[playerid][9], 1);
PlayerTextDrawSetShadow(playerid, PlayerID_Card[playerid][9], 0);
PlayerTextDrawAlignment(playerid, PlayerID_Card[playerid][9], 1);
PlayerTextDrawColor(playerid, PlayerID_Card[playerid][9], 255);
PlayerTextDrawBackgroundColor(playerid, PlayerID_Card[playerid][9], 0);
PlayerTextDrawBoxColor(playerid, PlayerID_Card[playerid][9], 50);
PlayerTextDrawUseBox(playerid, PlayerID_Card[playerid][9], 0);
PlayerTextDrawSetProportional(playerid, PlayerID_Card[playerid][9], 1);
PlayerTextDrawSetSelectable(playerid, PlayerID_Card[playerid][9], 0);

PlayerID_Card[playerid][10] = CreatePlayerTextDraw(playerid, 429.000000, 312.000000, "ORIGIN: Los Santos");
PlayerTextDrawFont(playerid, PlayerID_Card[playerid][10], 2);
PlayerTextDrawLetterSize(playerid, PlayerID_Card[playerid][10], 0.183332, 1.200000);
PlayerTextDrawTextSize(playerid, PlayerID_Card[playerid][10], 598.000000, 17.000000);
PlayerTextDrawSetOutline(playerid, PlayerID_Card[playerid][10], 1);
PlayerTextDrawSetShadow(playerid, PlayerID_Card[playerid][10], 0);
PlayerTextDrawAlignment(playerid, PlayerID_Card[playerid][10], 1);
PlayerTextDrawColor(playerid, PlayerID_Card[playerid][10], 255);
PlayerTextDrawBackgroundColor(playerid, PlayerID_Card[playerid][10], 0);
PlayerTextDrawBoxColor(playerid, PlayerID_Card[playerid][10], 50);
PlayerTextDrawUseBox(playerid, PlayerID_Card[playerid][10], 0);
PlayerTextDrawSetProportional(playerid, PlayerID_Card[playerid][10], 1);
PlayerTextDrawSetSelectable(playerid, PlayerID_Card[playerid][10], 0);

PlayerID_Card[playerid][11] = CreatePlayerTextDraw(playerid, 429.000000, 323.000000, "GENDER: MALE, FAMLE");
PlayerTextDrawFont(playerid, PlayerID_Card[playerid][11], 2);
PlayerTextDrawLetterSize(playerid, PlayerID_Card[playerid][11], 0.183332, 1.200000);
PlayerTextDrawTextSize(playerid, PlayerID_Card[playerid][11], 598.000000, 17.000000);
PlayerTextDrawSetOutline(playerid, PlayerID_Card[playerid][11], 1);
PlayerTextDrawSetShadow(playerid, PlayerID_Card[playerid][11], 0);
PlayerTextDrawAlignment(playerid, PlayerID_Card[playerid][11], 1);
PlayerTextDrawColor(playerid, PlayerID_Card[playerid][11], 255);
PlayerTextDrawBackgroundColor(playerid, PlayerID_Card[playerid][11], 0);
PlayerTextDrawBoxColor(playerid, PlayerID_Card[playerid][11], 50);
PlayerTextDrawUseBox(playerid, PlayerID_Card[playerid][11], 0);
PlayerTextDrawSetProportional(playerid, PlayerID_Card[playerid][11], 1);
PlayerTextDrawSetSelectable(playerid, PlayerID_Card[playerid][11], 0);

PlayerID_Card[playerid][12] = CreatePlayerTextDraw(playerid, 429.000000, 361.000000, "EXP: VAID, EXPIRE");
PlayerTextDrawFont(playerid, PlayerID_Card[playerid][12], 2);
PlayerTextDrawLetterSize(playerid, PlayerID_Card[playerid][12], 0.183332, 1.200000);
PlayerTextDrawTextSize(playerid, PlayerID_Card[playerid][12], 598.000000, 17.000000);
PlayerTextDrawSetOutline(playerid, PlayerID_Card[playerid][12], 1);
PlayerTextDrawSetShadow(playerid, PlayerID_Card[playerid][12], 0);
PlayerTextDrawAlignment(playerid, PlayerID_Card[playerid][12], 1);
PlayerTextDrawColor(playerid, PlayerID_Card[playerid][12], 255);
PlayerTextDrawBackgroundColor(playerid, PlayerID_Card[playerid][12], 0);
PlayerTextDrawBoxColor(playerid, PlayerID_Card[playerid][12], 50);
PlayerTextDrawUseBox(playerid, PlayerID_Card[playerid][12], 0);
PlayerTextDrawSetProportional(playerid, PlayerID_Card[playerid][12], 1);
PlayerTextDrawSetSelectable(playerid, PlayerID_Card[playerid][12], 0);


/*Player Progress Bars
Requires "progress2" include by Southclaws
Download: https://github.com/Southclaws/progress2/releases */
