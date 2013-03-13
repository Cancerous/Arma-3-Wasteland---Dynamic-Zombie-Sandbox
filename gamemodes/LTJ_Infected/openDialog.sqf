createDialog "BuyDialog";


weaponsArray = [
["P07","hgun_P07_F",40,"16Rnd_9x21_Mag",2],
["Rook-40","hgun_Rook40_F",40,"16Rnd_9x21_Mag",2], 
["SDAR","arifle_SDAR_F",100,"20Rnd_556x45_UW_mag",5],
["MX","arifle_MX_F",100,”30Rnd_65x39_caseless_mag”,5],
["TRG-21","arifle_TRG21_F","30Rnd_65x39_case_mag",100,5],
["TRG-20","arifle_TRG20_F","30Rnd_65x39_case_mag",100,5],
["MXC","arifle_MXC_F",100,”30Rnd_65x39_caseless_mag”,5],
["Katiba","arifle_Khaybar_F",100,”30Rnd_65x39_caseless_mag”,5],
["Katiba Carabine","arifle_Khaybar_C_F",100,”30Rnd_65x39_caseless_mag”,5],
["MX 3GL","arifle_MX_GL_F",200,”30Rnd_65x39_caseless_mag”,10],
["Katiba GL","arifle_Khaybar_GL_F",200,”30Rnd_65x39_caseless_mag”,10],
["EBR","srifle_EBR_F",250,"20Rnd_762x45_Mag",10], 
["MX SW","arifle_MX_SW_F",250,”100Rnd_65x39_caseless_mag_Tracer”,10],
["Mk200","LMG_Mk200_F",250,"200Rnd_65x39_cased_Box",10],
["TRG-21 EGLM","arifle_TRG21_GL_F",275,"30Rnd_65x39_case_mag",5],
["NLAWr","launch_NLAW_F",300,"NLAW_F",20],
["RPG-42 Alamut","launch_RPG32_F",300,"RPG32_F",20],
["MXM","arifle_MXM_F",450,"20Rnd_762x45_Mag",30]
];

{
_weapon = _x select 1;
_display_name = _x select 0;
_text = _display_name + format [" - %1",_x select 2];
_index = lbAdd [1500, _text];
} forEach weaponsArray;
