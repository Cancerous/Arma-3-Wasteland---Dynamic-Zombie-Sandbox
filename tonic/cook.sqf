player switchMove "AinvPknlMstpSlayWrflDnon_medic";
AnimSync = [player,"AinvPknlMstpSlayWrflDnon_medic"];
publicVariable "AnimSync";

if(waste_chicken > 0) then
{
	waste_chicken_c = waste_chicken_c + waste_chicken;
	waste_chicken = 0;
};

if(waste_cow > 0) then
{
	waste_cow_c = waste_cow_c + waste_cow;
	waste_cow = 0;
};

if(waste_goat > 0) then
{
	waste_goat_c = waste_goat_c + waste_goat;
	waste_goat = 0;
};
if(waste_boar > 0) then
{
	waste_boar_c = waste_boar_c + waste_boar;
	waste_boar = 0;
};
if(waste_rabit > 0) then
{
	waste_rabit_c = waste_rabit_c + waste_rabit;
	waste_rabit = 0;
};

hintSilent "You have cooked all your raw meat";
