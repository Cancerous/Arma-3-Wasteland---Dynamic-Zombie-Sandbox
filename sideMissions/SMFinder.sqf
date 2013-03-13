//By Craig
//Choses the next sidemission

private ["_numb","_element","_num","_Earray"];

if (count SMarray == 0) then {missionActive = false; publicVariable "missionActive"; SMarray = ["SM1","SM2","SM3","SM4"];};
_numb = count SMarray;
_num = floor (random _numb);
_element = SMarray select _num;
_Earray = [_element];
SMarray = SMarray - _Earray;


[] execVM format ["sideMissions\%1.sqf",_element];