#include "defines.sqf"

class gunshopd {

	idd = gunshop_DIALOG;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "[] execVM 'player_system\populate.sqf'";
	
	class controlsBackground {
		
		class MainBG : w_RscPicture {
		
			idc = -1;
			text = "\ca\ui\data\ui_background_controlers_ca.paa";
			
			moving = true;
			
			x = 0.325; y = 0.1;
			w = 1.0; h = 0.65;
		
		};
		
		class MainTitle : w_RscText {
		
			idc = -1;
			text = "Gun Store Menu";
			
			x = 0.35; y = 0.109;
			w = 0.4; h = 0.07;
		
		};
		class MagazineText : w_RscText {
		
			idc = -1;
			text = "Magazines:";
			
			x = 0.93; y = 0.45;
			w = 0.4; h = 0.07;
		
		};
		
		class BandageCount : w_RscText {
		
			idc = gunshop_money;
		
			text = "";
			sizeEx = 0.025;
		
			x = 0.90; y = 0.109;
			w = 0.4; h = 0.07;
		};
		
		class MagPriceInfo : w_RscText {
			
		idc = gunshop_mags_text;
		
		text = "";
		sizeEx = 0.025;
		
		x = 0.95; y = 0.50;
		w = 0.4; h = 0.2;
		};
		
		class gunPicture : w_RscPicture {
			
		idc = gunshop_gun_pic;
		
		text = "";
		sizeEx = 0.025;
		
		x = 0.55; y = 0.2;
		w = 0.202; h = 0.109;
		};
		
		class w_gun_info : w_RscText
		{
			idc = gunshop_gun_info;
			type = CT_STRUCTURED_TEXT+ST_LEFT;
			size = 0.023;
			x = 0.55; y = 0.3;
			w = 0.350; h = 0.3;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0,0,0,0};
			text = "";
		};
		
		
		
		class PriceInfo : w_RscText {
		
		idc = gunshop_gun_TEXT;
		
		text = "";
		sizeEx = 0.025;
		
		x = 0.55; y = 0.1;
		w = 0.4; h = 0.2;
		};
		
	};
	
	class controls {
		
	
		class gunList : w_Rsclist {
		
		idc = gunshop_gun;
		onLBSelChanged = "[0] execvm 'player_system\weaponInfo.sqf'";
		
		x = 0.34; y = 0.170;
		w = 0.2; h = 0.4;
		
		};
		
		class MagazineAmount : w_RscCombo {
		
			idc = gunshop_mags;
			onLBSelChanged = "[1] execVM 'player_system\weaponInfo.sqf'";
			
			x = 0.93; y = 0.50;
			w = 0.12; h = 0.023;
		
		};
		
		class BuyAmmoButton : w_RscButton {
		
			text = "Buy";
			onButtonClick = "[1] execVM 'player_system\buy.sqf';";
			
			x = 0.93; y = 0.53;
			w = 0.125; h = 0.05;
			
		};
		
		class CancelButton : w_RscButton {
			
			text = "Cancel";
			onButtonClick = "closeDialog 0;";
			
			x = 0.47; y = 0.60;
			w = 0.125; h = 0.05;
			
		};
		
		class BuyButton : w_RscButton {
		
			text = "Buy";
			onButtonClick = "[0] execVM 'player_system\buy.sqf';";
			
			x = 0.34; y = 0.60;
			w = 0.125; h = 0.05;
			
		};
		
		class sellPrimary : w_RscButton {
		
		text = "Sell Current Weapon In Hand";
		onButtonClick = "closeDialog 0; execVM 'player_system\sellWeapon.sqf'";
		
		x = 0.350; y = 0.68;
		w = 0.425; h = 0.05;
		
		};
		
	};

};