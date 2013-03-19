/*
 *	General publicVariable event handlers
 */
"AnimSync" addPublicVariableEventHandler{[(_this select 1)] execVM "tonic\animsync.sqf";}; //Animation Syncer

/*
 *	General purpose eventhandlers
 */

//onRespawn = compile preprocessfile "tonic\onRespawn.sqf"; //Precompile OnRespawn actions
//onKilled = compile preprocessfile "tonic\onKilled.sqf"; //Precompile OnKilled actions
//player addMPEventHandler ["MPRespawn", {[_this] call onRespawn;}];
//player addMPEventHandler ["MPKilled", {[_this] call onKilled;}];
