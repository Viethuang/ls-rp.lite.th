
#include <YSI_Coding\y_hooks>


hook OnGameModeInit()
{
    //Harbor Station Exterior
	new pd_maps;
	pd_maps = CreateDynamicObject(6134, 2150.121093, -2177.105468, 16.696870, 0.000000, 0.000000, 45.400009, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 4550, "skyscr1_lan2", "gm_labuld2_b", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19379, 2140.007812, -2200.301025, 12.534366, 0.000000, 0.000000, 45.399990, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 3629, "arprtxxref_las", "corrRoof_64HV", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19379, 2146.751220, -2200.243164, 12.534366, 0.000000, 0.000000, 135.399993, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 3629, "arprtxxref_las", "corrRoof_64HV", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19379, 2140.017333, -2193.599609, 12.534366, 0.000000, 0.000000, 135.399993, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 3629, "arprtxxref_las", "corrRoof_64HV", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19379, 2146.730712, -2193.548095, 12.534366, 0.000000, 0.000000, 225.399993, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 3629, "arprtxxref_las", "corrRoof_64HV", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19379, 2143.348876, -2196.967529, 17.724384, 0.000000, 90.000000, 225.399993, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(1692, 2143.096679, -2196.903076, 18.300319, 0.000000, 0.000000, 45.400005, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, -1, "none", "none", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(1214, 2143.923339, -2190.370117, 12.274368, 0.000000, 0.000000, -42.699996, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	SetDynamicObjectMaterial(pd_maps, 1, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	pd_maps = CreateDynamicObject(1214, 2149.896240, -2196.219726, 12.274368, 0.000000, 0.000000, -41.699981, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	SetDynamicObjectMaterial(pd_maps, 1, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	pd_maps = CreateDynamicObject(19431, 2182.502441, -2166.873046, 11.756875, 90.000000, -44.799995, 0.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2182.592529, -2164.411865, 11.756875, 90.000000, -44.799995, 90.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2180.759765, -2166.255859, 11.756875, 90.000000, -44.799995, 90.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2178.667236, -2168.363037, 11.756875, 90.000000, -44.799995, 90.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2176.595458, -2170.448730, 11.756875, 90.000000, -44.799995, 90.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2174.545166, -2172.513183, 11.756875, 90.000000, -44.799995, 90.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2180.036865, -2169.356445, 11.756875, 90.000000, -44.799995, 0.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2177.584960, -2171.825439, 11.756875, 90.000000, -44.799995, 0.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2176.894531, -2172.519775, 11.766876, 90.000000, -44.799995, 0.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2152.646972, -2156.179931, 11.756878, 90.000000, -44.599998, 0.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2152.764648, -2153.709960, 11.756878, 90.000000, -44.599998, 90.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2150.809814, -2155.448242, 11.756878, 90.000000, -44.599998, 90.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2148.801269, -2157.498046, 11.756878, 90.000000, -44.599998, 90.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2146.939941, -2159.341064, 11.756878, 90.000000, -44.599998, 90.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2144.924804, -2161.397460, 11.756878, 90.000000, -44.599998, 90.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2142.846191, -2163.745117, 11.756878, 90.000000, -44.599998, 90.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2150.196777, -2158.665527, 11.756878, 90.000000, -44.599998, 0.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2147.767578, -2161.128173, 11.756878, 90.000000, -44.599998, 0.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19431, 2145.316406, -2163.611816, 11.756878, 90.000000, -44.599998, 0.000000, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterial(pd_maps, 0, 19523, "sampicons", "yellograd32", 0xFFFFFFFF);
	pd_maps = CreateDynamicObject(19327, 2123.441162, -2188.083496, 20.426877, 0.000000, 0.000000, -134.700073, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}2175", 20, "Ariel", 20, 1, 0x00000000, 0x00000000, 1);
	pd_maps = CreateDynamicObject(19327, 2123.441162, -2188.083496, 20.426877, 0.000000, 0.000000, -134.700073, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}2175", 20, "Ariel", 20, 1, 0x00000000, 0x00000000, 1);
	pd_maps = CreateDynamicObject(19327, 2128.527832, -2182.943603, 17.796882, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}LOS SANTO", 20, "Ariel", 18, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2126.860351, -2184.627441, 17.796882, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}TOS", 20, "Ariel", 18, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2125.918457, -2185.580322, 17.796882, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}POLICE", 20, "Ariel", 18, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2128.056640, -2183.419433, 16.916881, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}HARBOR", 20, "Ariel", 17, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2126.326171, -2185.167236, 16.906877, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}STATION", 20, "Ariel", 17, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2128.527832, -2182.943603, 17.796882, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}LOS SANTO", 20, "Ariel", 18, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2126.860351, -2184.627441, 17.796882, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}TOS", 20, "Ariel", 18, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2125.918457, -2185.580322, 17.796882, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}POLICE", 20, "Ariel", 18, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2126.326171, -2185.167236, 16.906877, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}STATION", 20, "Ariel", 17, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2128.056640, -2183.419433, 16.916881, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}HARBOR", 20, "Ariel", 17, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2126.142578, -2185.351318, 17.826879, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}______________________________________", 20, "Ariel", 20, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2127.591552, -2183.887207, 17.826879, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}______________________________________", 20, "Ariel", 20, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2128.513183, -2182.956054, 17.826879, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}______________________________________", 20, "Ariel", 20, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2128.513183, -2182.956054, 17.826879, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}______________________________________", 20, "Ariel", 20, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2127.591552, -2183.887207, 17.826879, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}______________________________________", 20, "Ariel", 20, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2126.142578, -2185.351318, 17.826879, 0.000000, 0.000000, -134.700088, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}______________________________________", 20, "Ariel", 20, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2138.396972, -2171.716552, 15.264369, 0.000000, 0.000000, -134.700042, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}POLICE", 30, "Ariel", 16, 1, 0x00000000, 0x00000000, 0);
	pd_maps = CreateDynamicObject(19327, 2138.396972, -2171.716552, 15.264369, 0.000000, 0.000000, -134.700042, -1, -1, -1, 600.00, 600.00);
	SetDynamicObjectMaterialText(pd_maps, 0, "{000000}POLICE", 30, "Ariel", 16, 1, 0x00000000, 0x00000000, 0);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	pd_maps = CreateDynamicObject(638, 2132.928710, -2178.051513, 13.194373, 0.000000, 0.000000, -44.100002, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(638, 2134.619140, -2176.305908, 13.194373, 0.000000, 0.000000, -44.100002, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(638, 2136.296630, -2174.575439, 13.194373, 0.000000, 0.000000, -44.100002, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(638, 2141.251220, -2169.376220, 13.194373, 0.000000, 0.000000, -44.100002, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(638, 2142.944580, -2167.632324, 13.194373, 0.000000, 0.000000, -44.100002, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(638, 2144.659179, -2165.964843, 13.194373, 0.000000, 0.000000, -44.100002, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(638, 2146.274658, -2164.299072, 13.194373, 0.000000, 0.000000, -44.100002, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(638, 2148.015380, -2162.503417, 13.194373, 0.000000, 0.000000, -44.100002, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(638, 2149.705566, -2160.786376, 13.194373, 0.000000, 0.000000, -44.100002, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(638, 2151.403076, -2159.033935, 13.194373, 0.000000, 0.000000, -44.100002, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(638, 2152.977050, -2157.411376, 13.194373, 0.000000, 0.000000, -44.100002, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(638, 2154.090087, -2156.261962, 13.194373, 0.000000, 0.000000, -44.100002, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(638, 2155.357910, -2154.955566, 13.194373, 0.000000, 0.000000, -44.100002, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(638, 2157.086181, -2155.544189, 13.194373, 0.000000, 0.000000, 45.899997, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(638, 2158.874267, -2157.278320, 13.194373, 0.000000, 0.000000, 45.899997, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(967, 2162.852783, -2158.811279, 12.546875, 0.000000, 0.000000, 136.199981, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(966, 2163.551269, -2158.078125, 12.546875, 0.000000, 0.000000, -134.000030, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1214, 2168.599365, -2152.877685, 12.186872, 0.000000, 0.000000, 43.700004, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1214, 2169.114257, -2152.345947, 12.186872, 0.000000, 0.000000, 45.199996, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1214, 2169.629394, -2151.828857, 12.186872, 0.000000, 0.000000, 45.199996, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1214, 2170.116699, -2151.339843, 12.186872, 0.000000, 0.000000, 45.199996, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1345, 2169.480957, -2177.255126, 13.316875, 0.000000, 0.000000, -135.099990, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1345, 2167.384521, -2179.641601, 13.316875, 0.000000, 0.000000, -135.099990, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1441, 2169.243896, -2176.234130, 13.126872, 0.000000, 0.000000, -131.499984, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1691, 2145.672119, -2199.181396, 17.890110, 0.000000, 0.000000, -45.600006, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1691, 2140.801513, -2194.208984, 17.890110, 0.000000, 0.000000, -45.600006, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(3294, 2146.762207, -2193.495849, 13.774373, 0.000000, 0.000000, 45.400012, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1533, 2142.639404, -2190.773193, 12.554370, 0.000000, 0.000000, -135.199996, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1300, 2145.799316, -2182.579589, 12.864367, 0.000000, 0.000000, 45.500011, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1635, 2125.343017, -2191.891601, 17.056873, 0.000000, 0.000000, 45.399997, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(16335, 2129.410888, -2189.104736, -69.313133, 0.000000, 0.000000, 45.600002, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(4574, 2131.860595, -2185.596435, 6.994069, 0.000000, 0.000000, 136.600036, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1687, 2143.284179, -2171.171875, 19.970266, 0.000000, 0.000000, 42.799987, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1294, 2182.767333, -2165.441650, 16.956871, 0.000000, 0.000000, 0.000000, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1294, 2162.168945, -2185.303466, 16.866870, 0.000000, 0.000000, -43.099990, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1294, 2163.290527, -2146.496582, 16.856872, 0.000000, 0.000000, 47.199996, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1280, 2133.707031, -2175.125488, 12.886872, 0.000000, 0.000000, -44.099994, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1280, 2140.773681, -2167.836914, 12.886872, 0.000000, 0.000000, -44.099994, -1, -1, -1, 600.00, 600.00);
	pd_maps = CreateDynamicObject(1211, 2163.715332, -2144.480468, 12.956874, 0.000000, 0.000000, -40.199996, -1, -1, -1, 600.00, 600.00);
    return 1;
}


hook OnPlayerConnect(playerid)
{
    RemoveBuildingForPlayer(playerid, 3687, 2135.742, -2186.445, 15.671, 0.250);
    RemoveBuildingForPlayer(playerid, 3687, 2162.851, -2159.750, 15.671, 0.250);
    RemoveBuildingForPlayer(playerid, 3686, 2195.085, -2216.843, 15.906, 0.250);
    RemoveBuildingForPlayer(playerid, 3686, 2220.781, -2261.054, 15.906, 0.250);
    RemoveBuildingForPlayer(playerid, 3687, 2150.195, -2172.359, 15.671, 0.250);
    RemoveBuildingForPlayer(playerid, 3744, 2193.257, -2286.289, 14.812, 0.250);
    RemoveBuildingForPlayer(playerid, 3744, 2183.171, -2237.273, 14.812, 0.250);
    RemoveBuildingForPlayer(playerid, 3744, 2174.640, -2215.656, 15.101, 0.250);
    RemoveBuildingForPlayer(playerid, 3744, 2193.062, -2196.640, 15.101, 0.250);
    RemoveBuildingForPlayer(playerid, 3744, 2101.789, -2162.578, 15.132, 0.250);
    RemoveBuildingForPlayer(playerid, 5305, 2198.851, -2213.921, 14.882, 0.250);
    RemoveBuildingForPlayer(playerid, 3747, 2234.390, -2244.828, 14.937, 0.250);
    RemoveBuildingForPlayer(playerid, 3747, 2226.968, -2252.140, 14.937, 0.250);
    RemoveBuildingForPlayer(playerid, 3747, 2219.421, -2259.523, 14.882, 0.250);
    RemoveBuildingForPlayer(playerid, 3747, 2212.093, -2267.070, 14.937, 0.250);
    RemoveBuildingForPlayer(playerid, 3747, 2204.632, -2274.414, 14.937, 0.250);
    RemoveBuildingForPlayer(playerid, 1531, 2173.593, -2165.187, 15.304, 0.250);
    RemoveBuildingForPlayer(playerid, 3574, 2193.257, -2286.289, 14.812, 0.250);
    RemoveBuildingForPlayer(playerid, 3569, 2204.632, -2274.414, 14.937, 0.250);
    RemoveBuildingForPlayer(playerid, 3569, 2212.093, -2267.070, 14.937, 0.250);
    RemoveBuildingForPlayer(playerid, 3627, 2220.781, -2261.054, 15.906, 0.250);
    RemoveBuildingForPlayer(playerid, 3569, 2219.421, -2259.523, 14.882, 0.250);
    RemoveBuildingForPlayer(playerid, 3578, 2194.476, -2242.875, 13.257, 0.250);
    RemoveBuildingForPlayer(playerid, 3569, 2226.968, -2252.140, 14.937, 0.250);
    RemoveBuildingForPlayer(playerid, 3569, 2234.390, -2244.828, 14.937, 0.250);
    RemoveBuildingForPlayer(playerid, 3574, 2183.171, -2237.273, 14.812, 0.250);
    RemoveBuildingForPlayer(playerid, 3574, 2174.640, -2215.656, 15.101, 0.250);
    RemoveBuildingForPlayer(playerid, 3627, 2195.085, -2216.843, 15.906, 0.250);
    RemoveBuildingForPlayer(playerid, 5244, 2198.851, -2213.921, 14.882, 0.250);
    RemoveBuildingForPlayer(playerid, 3574, 2193.062, -2196.640, 15.101, 0.250);
    RemoveBuildingForPlayer(playerid, 3622, 2135.742, -2186.445, 15.671, 0.250);
    RemoveBuildingForPlayer(playerid, 1226, 2215.804, -2199.218, 16.312, 0.250);
    RemoveBuildingForPlayer(playerid, 1226, 2207.875, -2191.250, 16.312, 0.250);
    RemoveBuildingForPlayer(playerid, 1226, 2223.742, -2207.187, 16.312, 0.250);
    RemoveBuildingForPlayer(playerid, 3622, 2150.195, -2172.359, 15.671, 0.250);
    RemoveBuildingForPlayer(playerid, 3574, 2101.796, -2162.562, 15.070, 0.250);
    RemoveBuildingForPlayer(playerid, 3567, 2083.523, -2159.617, 13.257, 0.250);
    RemoveBuildingForPlayer(playerid, 3622, 2162.851, -2159.750, 15.671, 0.250);
    return 1;
}